import 'package:dlalat_quaran_new/widgets/custom_fading_widget.dart';
import 'package:flutter/material.dart';

class ArticlesWidgetLodingColumn extends StatelessWidget {
  const ArticlesWidgetLodingColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (i) => const ArticlesWidgetLoding()),
    );
  }
}

class ArticlesWidgetLoding extends StatelessWidget {
  const ArticlesWidgetLoding({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFadingWidget(
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.grey, backgroundColor: Colors.white, padding: EdgeInsets.zero, elevation: 2),
          onPressed: () {},
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsetsDirectional.only(start: 5, end: 100, top: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 300,
                    height: 25,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.only(start: 5, end: 50, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 500,
                    height: 25,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
