import 'package:dlalat_quaran_new/models/chat_message_entity.dart';
import 'package:dlalat_quaran_new/ui/chat/helpers/clean_reply.dart';
import 'package:dlalat_quaran_new/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final avatar =
        isUser
            ? CircleAvatar(child: Icon(Icons.person, color: Colors.white, size: 16))
            : CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.05),
              child: Image.asset(AssetsData.logoSmall, height: 30),
            );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: !isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isUser) avatar,
          Flexible(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.green[200] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:
                      message.isTyping
                          ? Lottie.asset(AssetsData.loading, height: 100, width: double.infinity)
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     const SizedBox(width: 8),
                          //     const SizedBox(
                          //       height: 12,
                          //       width: 12,
                          //       child: CircularProgressIndicator(strokeWidth: 2),
                          //     ),
                          //     const SizedBox(width: 8),
                          //   ],
                          // )
                          : InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: cleanReply(message.text, removeHtml: true)),
                              );
                            },

                            // child: MarkdownBody(
                            //   data: cleanReply(message.text),
                            //   // textAlign: TextAlign.right,
                            //   styleSheet: MarkdownStyleSheet(
                            //     p: TextStyle(color: Colors.green),
                            //     listBullet: Theme.of(
                            //       context,
                            //     ).textTheme.bodyMedium?.copyWith(color: Colors.green),
                            //     a: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blue),
                            //   ),
                            // ),
                            child: Html(
                              data: cleanReply(message.text),
                              // textAlign: TextAlign.right,
                            ),
                          ),
                ),
                if (!isUser)
                  Positioned(
                    bottom: 5,
                    left: !isUser ? -10 : null,
                    right: isUser ? -10 : null,
                    child: InkWell(
                      onTap: () {
                        SharePlus.instance.share(
                          ShareParams(text: cleanReply(message.text, removeHtml: true)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isUser ? Colors.green : Colors.grey,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Icon(MdiIcons.share, size: 25, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!isUser) avatar,
        ],
      ),
    );
  }
}
