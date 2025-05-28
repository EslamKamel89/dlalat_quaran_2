// import 'package:audioplayers/audioplayers.dart';
// import 'package:dlalat_quaran_new/controllers/read_full_surah_controller.dart';
// import 'package:dlalat_quaran_new/utils/colors.dart';
// import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
// import 'package:dlalat_quaran_new/utils/text_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AudioPlayerFullSuraWidget extends StatefulWidget {
//   const AudioPlayerFullSuraWidget({super.key});

//   @override
//   AudioPlayerFullSuraWidgetState createState() => AudioPlayerFullSuraWidgetState();
// }

// class AudioPlayerFullSuraWidgetState extends State<AudioPlayerFullSuraWidget> {
//   final readFullSuraController = Get.find<ReadFullSurahController>();
//   final _audioPlayer = Get.find<ReadFullSurahController>().audioPlayer;
//   PlayerState playerState = PlayerState.stopped;
//   Duration? playerDuration;
//   Duration? playerPosition;
//   @override
//   void initState() {
//     super.initState();

//     // _audioPlayer.onDurationChanged.listen((Duration d) {
//     //   if (mounted) {
//     //     setState(() {
//     //       playerDuration = d;
//     //       readFullSuraController.playerDuration = d;
//     //     });
//     //   }
//     // });
//     // _audioPlayer.onPositionChanged.listen((Duration p) {
//     //   if (mounted) {
//     //     setState(() {
//     //       playerPosition = p;
//     //       readFullSuraController.playerPosition = p;
//     //     });
//     //   }
//     // });
//     // _audioPlayer.onPlayerComplete.listen((_) {
//     //   if (mounted) {
//     //     setState(() {
//     //       readFullSuraController.resetAudioPlayer();
//     //     });
//     //   }
//     // });
//     // _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
//     //   if (mounted) {
//     //     setState(() {
//     //       playerState = state;
//     //     });
//     //   }
//     // });
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   void _playPause() {
//     if (playerState == PlayerState.playing) {
//       _audioPlayer.pause();
//     } else if (playerState == PlayerState.paused) {
//       _audioPlayer.resume();
//     } else {
//       readFullSuraController.playFullSura();
//     }
//     if (mounted) {
//       setState(() {
//         readFullSuraController.isPlaying = !readFullSuraController.isPlaying;
//       });
//     }
//   }

//   void _stop() {
//     if (mounted) {
//       setState(() {
//         readFullSuraController.resetAudioPlayer();
//         readFullSuraController.stopPlaying = true;

//         // readFullSuraController.position = const Duration();
//       });
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ReadFullSurahController>(builder: (_) {
//       return Container(
//         padding: const EdgeInsets.all(20.0),
//         decoration: const BoxDecoration(
//           color: primaryColor,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const SizedBox(height: 10),
//             readFullSuraController.responseState == ResponseState.loading
//                 ? const SizedBox(height: 30, child: Center(child: CircularProgressIndicator()))
//                 // : const SizedBox(height: 30),
//                 : SizedBox(
//                     height: 100,
//                     child: ListView(
//                       children: [
//                         DefaultText(
//                           readFullSuraController.ayahAr,
//                           color: Colors.white,
//                           fontSize: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//             const SizedBox(height: 15),
//             const SizedBox(height: 25),
//             Builder(builder: (context) {
//               double value = playerPosition?.inSeconds.toDouble() ?? 0;
//               double max = readFullSuraController.playerDuration?.inSeconds.toDouble() ?? 0;
//               if (value >= max) {
//                 value = max;
//               }
//               return Slider(
//                 value: value,
//                 min: 0.0,
//                 max: max,
//                 onChanged: (double value) {
//                   setState(() {
//                     _audioPlayer.seek(Duration(seconds: value.toInt()));
//                   });
//                 },
//               );
//             }),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   _formatDuration(playerPosition ?? const Duration()),
//                   style: const TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 // Text(
//                 //   _formatDuration(readFullSuraController.playerDuration ?? const Duration()),
//                 //   style: const TextStyle(color: Colors.white, fontSize: 18),
//                 // ),
//                 const SizedBox(),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 IconButton(
//                   icon: Builder(builder: (context) {
//                     return Icon(
//                       playerState == PlayerState.playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
//                       size: 48.0,
//                       color: Colors.blueAccent,
//                     );
//                   }),
//                   onPressed: _playPause,
//                 ),
//                 const SizedBox(width: 20),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.stop_circle,
//                     size: 48.0,
//                     color: Colors.redAccent,
//                   ),
//                   onPressed: _stop,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
