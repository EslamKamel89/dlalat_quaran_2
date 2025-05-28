import 'package:dlalat_quaran_new/controllers/read_aya_controller.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final ayaController = Get.find<ReadAyaController>();
  final _audioPlayer = Get.find<ReadAyaController>().audioPlayer;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((Duration d) {
      if (mounted) {
        setState(() {
          ayaController.duration = d;
        });
      }
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() {
          ayaController.position = p;
        });
      }
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          ayaController.resetAudioPlayer();
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() {
    if (ayaController.isPlaying) {
      _audioPlayer.pause();
    } else {
      // _audioPlayer.play(_audioUrl);
      ayaController.audioPlayer.resume();
    }
    if (mounted) {
      setState(() {
        ayaController.isPlaying = !ayaController.isPlaying;
      });
    }
  }

  void _stop() {
    _audioPlayer.stop();
    if (mounted) {
      setState(() {
        ayaController.isPlaying = false;
        ayaController.position = const Duration();
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReadAyaController>(builder: (_) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10),
            DefaultText(
              ayaController.ayahAr,
              color: Colors.white,
              fontSize: 20,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'reciter'.tr,
                    style: const TextStyle(fontFamily: 'Almarai', color: Colors.white),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    height: 50,
                    decoration:
                        const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: Colors.white),
                    child: const ReadersDropdown(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 25),
            Slider(
              value: ayaController.position.inSeconds.toDouble(),
              min: 0.0,
              max: ayaController.duration.inSeconds.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _audioPlayer.seek(Duration(seconds: value.toInt()));
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _formatDuration(ayaController.position),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  _formatDuration(ayaController.duration),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    ayaController.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    size: 48.0,
                    color: Colors.blueAccent,
                  ),
                  onPressed: _playPause,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(
                    Icons.stop_circle,
                    size: 48.0,
                    color: Colors.redAccent,
                  ),
                  onPressed: _stop,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class ReadersDropdown extends StatefulWidget {
  const ReadersDropdown({super.key});

  @override
  ReadersDropdownState createState() => ReadersDropdownState();
}

class ReadersDropdownState extends State<ReadersDropdown> {
  ReadAyaController readAyaController = Get.find<ReadAyaController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withOpacity(0.5)),
      ),
      alignment: Alignment.center,
      child: DropdownButton<ReaderName>(
        isDense: true,
        dropdownColor: primaryColor.withOpacity(0.7),
        value: readAyaController.readerName,
        items: readAyaController.readersList.map<DropdownMenuItem<ReaderName>>((ReaderName readerName) {
          return DropdownMenuItem<ReaderName>(
            value: readerName,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: DefaultText(readerName.displayName(), color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            readAyaController.readerName = value;
            setState(() {});
          }
        },
        isExpanded: true,
        underline: Container(color: Colors.green),
      ),
    );
  }
}
