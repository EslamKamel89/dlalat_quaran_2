import 'package:dlalat_quaran_new/controllers/chat_controller.dart';
import 'package:dlalat_quaran_new/models/chat_history_entity.dart';
import 'package:dlalat_quaran_new/ui/chat/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatHistoryDrawer extends StatefulWidget {
  const ChatHistoryDrawer({super.key});

  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  late final ChatController controller;
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    controller = Get.find<ChatController>();
    Future.delayed(10.ms, () {
      controller.filterConversations('');
    });
    searchController.addListener(() {
      controller.filterConversations(searchController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      color: Colors.white,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "المحادثات السابقة",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: Navigator.of(context).pop,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField("ابحث في المحادثات السابقة", searchController, ''),
            ),
            const SizedBox(height: 16),
            // InkWell(
            //   onTap: () {
            //     serviceLocator<SharedPreferences>().clear();
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //       color: context.primaryColor,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Text('clear cache', style: TextStyle(color: Colors.white)),
            //   ),
            // ),
            // const SizedBox(height: 16),

            // Chat List
            Expanded(
              child: GetBuilder<ChatController>(
                builder: (controller) {
                  return ListView.builder(
                    itemCount: controller.state.filteredConversations!.length,
                    itemBuilder: (context, index) {
                      final chat = controller.state.filteredConversations![index];
                      return InkWell(
                        onTap: () async {
                          controller.selectConversation(chat.id!);
                          await Future.delayed(Duration(milliseconds: 900));
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                        },
                        child: Transform.scale(
                          scale: controller.state.selectedConversation?.id == chat.id ? 1.2 : 1,
                          child: _buildChatCard(chat, context),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatCard(ChatHistoryEntity chat, BuildContext context) {
    final chatCard = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 20,
                child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.title == null
                          ? "${chat.timestamp.hour}:${chat.timestamp.minute} - ${chat.timestamp.day}/${chat.timestamp.month}/${chat.timestamp.year}"
                          : chat.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
    if (controller.state.conversationsInHistory.length > 1 &&
        controller.state.selectedConversation?.id != chat.id) {
      return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.horizontal,
        onDismissed: (_) {
          controller.deleteConversation(chat.id!);
        },
        background: Container(
          decoration: BoxDecoration(color: Colors.red),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 30),
                child: Icon(MdiIcons.trashCan, color: Colors.white, size: 30),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Icon(MdiIcons.trashCan, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
        child: chatCard,
      );
    }
    return chatCard;
  }
}
