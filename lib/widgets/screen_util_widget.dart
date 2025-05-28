import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ScreenUtilWidget extends StatelessWidget {
//   const ScreenUtilWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//    ScreenUtil.init(
//       context,
//       designSize: Size(360, 690), // Set your design size
//       minTextAdapt: true,
//       splitScreenMode: true,
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ScreenUtil with Device Preview'),
//       ),
//       body: Center(
//         child: Container(
//           width: 0.8.sw, // Set width with ScreenUtil
//           height: 200.h, // Set height with ScreenUtil
//           color: Colors.blue,
//           child: Center(
//             child: Text(
//               'Hello, ScreenUtil!',
//               style: TextStyle(fontSize: 24.sp), // Set font size with ScreenUtil
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

initScreenUtil(BuildContext context) {
  ScreenUtil.init(
    context,
    designSize: const Size(360, 690), // Set your design size
    minTextAdapt: true,
    splitScreenMode: true,
  );
}
