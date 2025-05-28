import 'package:dlalat_quaran_new/controllers/chat_controller.dart';
import 'package:dlalat_quaran_new/ui/chat/widgets/chat_bubble.dart';
import 'package:dlalat_quaran_new/ui/chat/widgets/chat_histroy_drawer.dart';
import 'package:dlalat_quaran_new/ui/chat/widgets/message_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const id = '/ChatScreen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  late ChatController controller;
  @override
  void initState() {
    controller = Get.find<ChatController>();
    super.initState();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(title: const Text("دلالات شات"), backgroundColor: Colors.green),
              drawer: ChatHistoryDrawer(),
              body: GetBuilder<ChatController>(
                // listener: (context, state) {
                // _scrollToBottom();
                // },
                builder: (controller) {
                  final state = controller.state;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Column(
                      children: [
                        if (state.messages.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final message = state.messages[index];
                                return ChatBubble(
                                  message: message,
                                ).animate().fadeIn(duration: 300.ms);
                              },
                            ),
                          ),
                        if (state.messages.isEmpty)
                          Expanded(
                            child: Center(
                              child: Text(
                                "اطرح سؤالاً",
                                style: TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                            ),
                          ),
                        MessageInput(
                          onSend: (text) {
                            controller.sendMessage(text);
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
