import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:flutter/material.dart';

enum IconType { research, competition }

class LongPressIcon extends StatefulWidget {
  const LongPressIcon({
    super.key,
    required this.child,
    required this.onTap,
    required this.isLeft,
    required this.iconType,
    required this.itemSize,
  });
  final Widget child;
  final void Function()? onTap;
  final bool isLeft;
  final IconType iconType;
  final double itemSize;

  @override
  State<LongPressIcon> createState() => _LongPressIconState();
}

class _LongPressIconState extends State<LongPressIcon> {
  String selectedImage = "";
  @override
  Widget build(BuildContext context) {
    final research = [
      'research1.png',
      'research2.png',
      'research3.png',
      'research4.png',
      'research5.png',
      'research6.png',
      'research7.png',
      'quran.png',
    ];

    final comp = [
      'comp1.png',
      'comp2.png',
      'comp3.png',
      'competition.png',
    ];
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () {
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
              widget.isLeft ? 0 : 100, 200, widget.isLeft ? 100 : 0, 100), // Adjust position as needed
          items: [
            ...List.from(widget.iconType == IconType.competition ? comp : research)
                .map((value) => PopupMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            // const PopupMenuItem(
            //   value: 'Option 1',
            //   child: Text('Option 1'),
            // ),
            // const PopupMenuItem(
            //   value: 'Option 2',
            //   child: Text('Option 2'),
            // ),
            // const PopupMenuItem(
            //   value: 'Option 3',
            //   child: Text('Option 3'),
            // ),
          ],
        ).then((value) {
          if (value != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You selected: $value')),
            );
            selectedImage = value.toString();
            setState(() {});
          }
        });
      },
      child: Container(
        height: widget.itemSize / 1.8,
        width: widget.itemSize / 1.8,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: mediumGray.withOpacity(0.5),
          boxShadow: [
            BoxShadow(offset: const Offset(3, 3), color: mediumGray.withOpacity(0.2)),
          ],
        ),
        child: Image.asset(
          selectedImage == ''
              ? widget.iconType == IconType.competition
                  ? "assets/images/competition.png"
                  : "assets/images/quran.png"
              : "assets/images/$selectedImage",
          // fit: BoxFit.cover,
          height: widget.itemSize / 2.4,
          width: widget.itemSize / 2.4,
        ),
      ),
    );
  }
}
