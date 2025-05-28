import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:flutter/material.dart';

enum ShareOrReadAction {
  share,
  read,
  nothing,
}

Future<ShareOrReadAction?> showCustomDialog(BuildContext context) async {
  return showDialog<ShareOrReadAction>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('برجاء'),
        content: const Text('أختيار مشاركة أو قراءة الأية'),
        actions: [
          // Share Button
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(ShareOrReadAction.share);
            },
            icon: const Icon(
              Icons.share,
              size: 30,
              color: primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(ShareOrReadAction.read);
            },
            icon: const Icon(
              Icons.play_arrow,
              size: 30,
              color: primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(ShareOrReadAction.nothing);
            },
            icon: const Icon(
              Icons.cancel,
              size: 30,
              color: primaryColor,
            ),
          ),
        ],
      );
    },
  );
}
