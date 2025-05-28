import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dlalat_quaran_new/env.dart';
import 'package:dlalat_quaran_new/models/chat_history_entity.dart';
import 'package:dlalat_quaran_new/models/chat_message_entity.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:dlalat_quaran_new/utils/shared_prefrences_key.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final Dio dio = serviceLocator();

  ChatService() {
    dio.options.headers = {
      'Authorization': 'Bearer ${Env.apiKey}',
      'OpenAI-Beta': 'assistants=v2',
      'Content-Type': 'application/json',
    };
  }

  Future<String> ask(String question) async {
    try {
      // Step 1: Create thread
      final threadResponse = await dio.post('https://api.openai.com/v1/threads');
      final threadId = threadResponse.data['id'];

      // Step 2: Add user message
      await dio.post(
        'https://api.openai.com/v1/threads/$threadId/messages',
        data: {'role': 'user', 'content': question},
      );

      // Step 3: Start assistant run
      final runResponse = await dio.post(
        'https://api.openai.com/v1/threads/$threadId/runs',
        data: {'assistant_id': Env.assistantId},
      );
      final runId = runResponse.data['id'];

      // Step 4: Poll until completed
      String status = '';
      int attempt = 0;
      const int maxAttempts = 60;

      do {
        await Future.delayed(Duration(seconds: 1));
        final statusResponse = await dio.get(
          'https://api.openai.com/v1/threads/$threadId/runs/$runId',
        );
        status = statusResponse.data['status'];
        attempt++;
      } while (status != 'completed' && attempt < maxAttempts);

      if (status != 'completed') {
        throw Exception('Assistant did not respond in time.');
      }

      // Step 5: Fetch messages
      final messagesResponse = await dio.get(
        'https://api.openai.com/v1/threads/$threadId/messages',
      );
      final List messages = messagesResponse.data['data'];

      for (var message in messages) {
        if (message['role'] == 'assistant') {
          return message['content'][0]['text']['value'] ?? 'No reply found.';
        }
      }

      return 'No assistant reply found.';
    } on Exception catch (e) {
      return 'Dio error: $e';
    } catch (e) {
      return 'Error: $e';
    }
  }
}

class ChatState {
  List<ChatMessageEntity> messages;
  List<ChatHistoryEntity>? filteredConversations;
  List<ChatHistoryEntity> conversationsInHistory;
  ChatHistoryEntity? currentSessionConversation;
  ChatHistoryEntity? selectedConversation;

  ChatState({
    required this.messages,
    required this.conversationsInHistory,
    this.filteredConversations,
    this.currentSessionConversation,
    this.selectedConversation,
  });

  ChatState copyWith({
    List<ChatMessageEntity>? messages,
    List<ChatHistoryEntity>? conversationsInHistory,
    List<ChatHistoryEntity>? filteredConversations,
    ChatHistoryEntity? currentSessionConversation,
    ChatHistoryEntity? selectedConversation,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      conversationsInHistory: conversationsInHistory ?? this.conversationsInHistory,
      filteredConversations: filteredConversations ?? this.filteredConversations,
      currentSessionConversation: currentSessionConversation ?? this.currentSessionConversation,
      selectedConversation: selectedConversation ?? this.selectedConversation,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'messages': messages.map((x) => x.toJson()).toList(),
      'conversationsInHistory': conversationsInHistory.map((x) => x.toJson()).toList(),
      'currentSessionConversation': currentSessionConversation?.toJson(),
      'selectedConversation': selectedConversation?.toJson(),
    };
  }

  factory ChatState.fromJson(Map<String, dynamic> json) {
    return ChatState(
      messages: List<ChatMessageEntity>.from(
        (json['messages'] as List<int>).map<ChatMessageEntity>(
          (x) => ChatMessageEntity.fromJson(x as Map<String, dynamic>),
        ),
      ),
      conversationsInHistory: List<ChatHistoryEntity>.from(
        (json['conversationsInHistory'] as List<int>).map<ChatHistoryEntity>(
          (x) => ChatHistoryEntity.fromJson(x as Map<String, dynamic>),
        ),
      ),
      currentSessionConversation: ChatHistoryEntity.fromJson(
        json['currentSessionConversation'] as Map<String, dynamic>,
      ),
      selectedConversation:
          json['selectedConversation'] != null
              ? ChatHistoryEntity.fromJson(json['selectedConversation'] as Map<String, dynamic>)
              : null,
    );
  }

  @override
  String toString() {
    return 'ChatState(messages: $messages, conversationsInHistory: $conversationsInHistory, currentSessionConversation: $currentSessionConversation, selectedConversation: $selectedConversation)';
  }
}

ChatHistoryEntity? currentSession;

class ChatController extends GetxController {
  final ChatService service = serviceLocator();
  final sharedPreferences = serviceLocator<SharedPreferences>();
  ChatState state = ChatState(messages: [], conversationsInHistory: []);
  void init() async {
    List<String> conversationsInHistoryJson =
        sharedPreferences.getStringList(ShPrefKey.chatHistoryData) ?? [];
    List<ChatHistoryEntity> conversationsInHistory =
        conversationsInHistoryJson
            .map((json) => ChatHistoryEntity.fromJson(jsonDecode(json)))
            .where((conversation) => conversation.title != null)
            .toList();
    if (currentSession == null) {
      currentSession = ChatHistoryEntity(timestamp: DateTime.now());
      await sharedPreferences.setStringList(ShPrefKey.chatHistoryData, [
        jsonEncode(currentSession?.toJson()),
        ...conversationsInHistoryJson,
      ]);
      conversationsInHistory = [currentSession!, ...conversationsInHistory];
    }
    List<String> chatDataJson =
        sharedPreferences.getStringList("${ShPrefKey.chatData}.${currentSession!.id}") ?? [];
    List<ChatMessageEntity> chatData =
        chatDataJson.map((chat) => ChatMessageEntity.fromJson(jsonDecode(chat))).toList();
    state = state.copyWith(
      conversationsInHistory: conversationsInHistory,
      filteredConversations: conversationsInHistory,
      messages: chatData,
      currentSessionConversation: currentSession,
      selectedConversation: currentSession,
    );
    update();
  }

  Future<void> sendMessage(String text) async {
    final userMessage = ChatMessageEntity(
      text: text,
      isUser: true,
      chatHistoryId: state.currentSessionConversation!.id!,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      currentSessionConversation: state.currentSessionConversation!.copyWith(
        title: state.currentSessionConversation?.title ?? text,
      ),
      conversationsInHistory: cacheChatHistory(
        state.conversationsInHistory
            .map(
              (conversation) =>
                  conversation.id == currentSession!.id && conversation.title == null
                      ? conversation.copyWith(title: text)
                      : conversation,
            )
            .toList(),
      ),
    );
    update();

    // Add typing indicator
    final typingIndicator = ChatMessageEntity(
      text: '',
      isUser: false,
      isTyping: true,
      chatHistoryId: state.currentSessionConversation!.id!,
    );
    state = state.copyWith(messages: [...state.messages, typingIndicator]);
    update();
    String response = await service.ask(text);
    final botReply = ChatMessageEntity(
      // text: "Bot: هذه هي الإجابة على سؤالك.",
      text: response,
      isUser: false,
      chatHistoryId: state.currentSessionConversation!.id!,
    );
    final updatedMessages = state.messages.where((msg) => !msg.isTyping).toList()..add(botReply);
    state = state.copyWith(messages: updatedMessages);
    update();
    sharedPreferences.setStringList(
      "${ShPrefKey.chatData}.${state.selectedConversation?.id}",
      state.messages.map((chat) => jsonEncode(chat.toJson())).toList(),
    );
  }

  void selectConversation(String conversationId) {
    final ChatHistoryEntity selectedCoversation = state.conversationsInHistory.firstWhere(
      (conversation) => conversation.id == conversationId,
    );
    List<String> chatDataJson =
        sharedPreferences.getStringList("${ShPrefKey.chatData}.${selectedCoversation.id}") ?? [];
    List<ChatMessageEntity> chatData =
        chatDataJson.map((chat) => ChatMessageEntity.fromJson(jsonDecode(chat))).toList();
    state = state.copyWith(messages: chatData, selectedConversation: selectedCoversation);
  }

  void deleteConversation(String conversationId) {
    if (state.conversationsInHistory.length <= 1) return;
    state.conversationsInHistory.removeWhere((conversation) => conversation.id == conversationId);
    cacheChatHistory(state.conversationsInHistory);
    state = state.copyWith();
    update();
  }

  List<ChatHistoryEntity> cacheChatHistory(List<ChatHistoryEntity> conversations) {
    sharedPreferences.setStringList(
      ShPrefKey.chatHistoryData,
      conversations.map((conversation) => jsonEncode(conversation.toJson())).toList(),
    );
    return conversations;
  }

  void filterConversations(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredConversations: state.conversationsInHistory);
      update();
    } else {
      final filtered =
          state.conversationsInHistory.where((conversation) {
            return conversation.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
          }).toList();
      state = state.copyWith(filteredConversations: filtered);
      update();
    }
  }
}
