import 'package:dlalat_quaran_new/controllers/correct_word_controller.dart';
import 'package:dlalat_quaran_new/controllers/similar_word_controller.dart';
import 'package:dlalat_quaran_new/ui/add_research.dart';
import 'package:dlalat_quaran_new/ui/articles_screen/articles_screen.dart';
import 'package:dlalat_quaran_new/ui/chat/chat_screen.dart';
import 'package:dlalat_quaran_new/ui/home_sura_screen.dart';
import 'package:dlalat_quaran_new/ui/read_full_sura_screen/read_full_sura_screen.dart';
import 'package:dlalat_quaran_new/ui/setting_screen.dart';
import 'package:dlalat_quaran_new/ui/tags_screen/tags_screen.dart';
import 'package:dlalat_quaran_new/ui/video_screen/videos_screen.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:dlalat_quaran_new/widgets/splash_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class IntroScreen extends StatefulWidget {
  static var id = '/IntroScreen';

  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    Get.find<SimilarWordController>().getSimilarWords();
    Get.find<CorrectWordController>().getCorrectWords();
    // getPermissionRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // pr('database deleted');
    // deleteDatabase('dlalat_qurann.db');
    // pr('sharedPreferences cleared');
    // serviceLocator<SharedPreferences>().clear();
    var itemSize = (MediaQuery.of(context).size.width - 80) / 3;
    var scHeight = Get.height;
    var scWidth = Get.width;
    // Get.find<ReadFullSurahController>().playFullSura('An-Nas');
    if (scWidth < 600) {
      return Stack(
        children: [
          SplashBackground(
            childWidget: Container(
              padding: EdgeInsets.only(top: itemSize / 3),
              child: Column(
                children: [
                  Image.asset(logoSmall, width: 60, height: 60),
                  Text(
                    'app_name'.tr,
                    // '',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: scHeight / 40, fontFamily: 'Almarai'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'introText'.tr,
                    style: TextStyle(color: const Color(0xFFF5B45E), fontSize: scHeight / 70, fontFamily: 'Almarai'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 70),
                  Transform.scale(
                    scale: 1.2,
                    child: Stack(
                      children: [
                        Image.asset(_centerView(), width: scHeight / 2.8, height: scHeight / 2.3),
                        Positioned(
                          left: itemSize,
                          top: 20,
                          child: Container(
                            color: Colors.blue.withOpacity(0.0),
                            width: itemSize,
                            height: itemSize - 20,
                            child: GestureDetector(
                              onTap: () {
                                // Get.toNamed(ChatScreen.id);
                                Get.toNamed(HomeSuraScreen.id);
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: itemSize - 30,
                          child: Container(
                            color: Colors.green.withOpacity(0.0),
                            width: itemSize - 20,
                            height: itemSize - 20,
                            child: GestureDetector(
                              // onTap: () => Get.to(const ArticlesScreen()),
                              onTap:
                                  () => Navigator.of(
                                    context,
                                  ).push(MaterialPageRoute(builder: (_) => const ArticlesScreen())),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          bottom: itemSize - 15,
                          child: Container(
                            color: Colors.red.withOpacity(0.0),
                            width: itemSize - 20,
                            height: itemSize - 20,
                            child: GestureDetector(
                              // onTap: () => Get.to(const TagsScreen()),
                              onTap:
                                  () =>
                                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TagsScreen())),
                            ),
                          ),
                        ),
                        Positioned(
                          left: itemSize,
                          bottom: 15,
                          child: Container(
                            color: Colors.yellow.withOpacity(0.0),
                            width: itemSize,
                            height: itemSize - 20,
                            child: GestureDetector(
                              // onTap: () => Get.to(SettingScreen()),
                              onTap:
                                  () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingScreen())),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: itemSize - 30,
                          child: Container(
                            color: Colors.blue.withOpacity(0.0),
                            width: itemSize - 20,
                            height: itemSize - 20,
                            child: GestureDetector(
                              // onTap: () => Get.to(AudioRecitationsScreen(), transition: Transition.fade),
                              onTap: () => Get.toNamed(ReadFullSuraScreen.id),
                            ),
                            // onTap: () => Navigator.of(context)
                            // .push(MaterialPageRoute(builder: (_) => const ReadFullSuraScreen()))),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: itemSize - 15,
                          child: Container(
                            color: Colors.orange.withOpacity(0.0),
                            width: itemSize - 20,
                            height: itemSize - 20,
                            child: GestureDetector(
                              // onTap: () => Get.to(VideoCategoriesScreen(), transition: Transition.fade),
                              // onTap: () => Get.to(const VideosScreen(), transition: Transition.fade),
                              onTap:
                                  () => Navigator.of(
                                    context,
                                  ).push(MaterialPageRoute(builder: (_) => const VideosScreen())),
                            ),
                          ),
                        ),
                        Positioned(
                          top: itemSize + 5,
                          bottom: itemSize + 5,
                          left: itemSize - 20,
                          right: itemSize - 20,
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.red.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            width: itemSize,
                            height: itemSize - 20,
                            child: GestureDetector(
                              onTap: () {
                                // Get.toNamed(HomeSuraScreen.id);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          QuestionAndResearchWidget(),
        ],
      );
    }

    return Stack(
      children: [
        SplashBackground(
          childWidget: Container(
            padding: EdgeInsets.only(top: itemSize / 1.3),
            child: Column(
              children: [
                Image.asset(logoSmall, width: scHeight / 8, height: scHeight / 8),
                Text(
                  'app_name'.tr,
                  // '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: scHeight / 40, fontFamily: 'Almarai'),
                ),
                const SizedBox(height: 8),
                Text(
                  'introText'.tr,
                  style: TextStyle(color: const Color(0xFFF5B45E), fontSize: scHeight / 70, fontFamily: 'Almarai'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: scHeight / 20),
                Stack(
                  children: [
                    Image.asset(_centerView(), width: 50.vw, height: 40.vh, fit: BoxFit.fill),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Center(
                        child: Container(
                          color: Colors.blue.withOpacity(0.0),
                          width: 20.vw,
                          height: 10.vh,
                          child: GestureDetector(
                            onTap: () {
                              int page =
                                  GetStorage().read(savedPage).toString() == 'null' ? 0 : GetStorage().read(savedPage);
                              Locale loca = Get.locale!;
                              Widget destination;
                              if (loca.languageCode == 'ar') {
                                destination = const HomeSuraScreen();
                              } else {
                                destination = const HomeSuraScreen();
                              }
                              // ShortExplanationIndex();
                              // Get.to(() => destination);
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => destination));
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0.vw,
                      top: 10.vh,
                      child: Container(
                        color: Colors.green.withOpacity(0.0),
                        width: 20.vw,
                        height: 10.vh,
                        child: GestureDetector(
                          // onTap: () => Get.to(const ArticlesScreen()),
                          onTap:
                              () =>
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ArticlesScreen())),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 10.vh,
                      child: Container(
                        color: Colors.red.withOpacity(0.0),
                        width: 20.vw,
                        height: 10.vh,
                        child: GestureDetector(
                          // onTap: () => Get.to(const TagsScreen()),
                          onTap:
                              () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TagsScreen())),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          color: Colors.yellow.withOpacity(0.0),
                          width: 20.vw,
                          height: 10.vh,
                          child: GestureDetector(
                            // onTap: () => Get.to(SettingScreen()),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingScreen())),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.vw,
                      top: 10.vh,
                      child: Container(
                        color: Colors.blue.withOpacity(0.0),
                        width: 20.vw,
                        height: 10.vh,
                        child: GestureDetector(
                          // onTap: () => Get.to(AudioRecitationsScreen(), transition: Transition.fade),
                          onTap: () => Get.toNamed(ReadFullSuraScreen.id),
                        ),
                        // onTap: () => Navigator.of(context)
                        // .push(MaterialPageRoute(builder: (_) => const ReadFullSuraScreen()))),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 10.vh,
                      child: Container(
                        color: Colors.orange.withOpacity(0.0),
                        width: 20.vw,
                        height: 10.vh,
                        child: GestureDetector(
                          // onTap: () => Get.to(VideoCategoriesScreen(), transition: Transition.fade),
                          // onTap: () => Get.to(const VideosScreen(), transition: Transition.fade),
                          onTap:
                              () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VideosScreen())),
                        ),
                      ),
                    ),
                    Positioned(
                      top: itemSize,
                      bottom: itemSize,
                      left: itemSize,
                      child: SizedBox(
                        // color: Colors.red.withOpacity(0.5),
                        width: itemSize - 20,
                        height: itemSize - 20,
                        child: GestureDetector(onTap: () => print('Quraaan')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        QuestionAndResearchWidget(),
      ],
    );
  }

  String _centerView() {
    return 'assets/images/center_view.png';
    // String path = '';
    // switch (GetStorage().read(language)) {
    //   case 'ar':
    //     path = 'assets/images/center_view.png';
    //     break;
    //   case 'en':
    //     path = 'assets/images/center_view_en.png';
    //     break;
    //   case 'fr':
    //     path = 'assets/images/center_view.png';
    //     break;
    //   case 'es':
    //     path = 'assets/images/center_view.png';
    //     break;
    //   default:
    //     path = 'assets/images/center_view.png';
    // }
    // return path;
  }
}

class QuestionAndResearchWidget extends StatelessWidget {
  const QuestionAndResearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: SizedBox(
          // width: double,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(ChatScreen.id);
                  // Get.toNamed(CompetitionsScreen.id);
                },
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: Image.asset("assets/images/answer_icon.png", fit: BoxFit.cover),
                      // child: Image.asset(AssetsData.search, fit: BoxFit.cover),
                    ),
                    SizedBox(height: 5),
                    const ArabicText('أسئلة تحتاج الي اجابة', color: Colors.white, fontSize: 10),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  // height: 50,
                  margin: const EdgeInsets.only(bottom: 70),
                  child: Image.asset("assets/images/Line.png", fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  // Get.toNamed(AddResearchView.id);
                  Navigator.of(context).pushNamed(AddResearchView.id);
                  // Get.toNamed(AudioPlayerScreen.id);
                },
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: Image.asset("assets/images/research_icon.png", fit: BoxFit.cover),
                    ),
                    SizedBox(height: 5),
                    const ArabicText("رفع بحث", color: Colors.white, fontSize: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // const double size = 50;
    // return Positioned(
    //   bottom: 30,
    //   right: 0,
    //   left: 0,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 50),
    //     child: SizedBox(
    //       // width: double,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           GestureDetector(
    //             onTap: () {
    //               // Get.toNamed(CompetitionsScreen.id);
    //               // Navigator.of(context).pushNamed(CompetitionsScreen.id);
    //               Get.toNamed(ChatScreen.id);
    //             },
    //             child: Stack(
    //               clipBehavior: Clip.none,
    //               children: [
    //                 Padding(
    //                   padding: EdgeInsets.only(bottom: 35),
    //                   child: Container(
    //                     height: size,
    //                     // width: 50,
    //                     alignment: Alignment.center,
    //                     // child: Image.asset("assets/images/answer_icon.png", fit: BoxFit.cover),
    //                     child: Image.asset(AssetsData.questionLogo, fit: BoxFit.cover),
    //                   ),
    //                 ),
    //                 Positioned(
    //                   bottom: 0,
    //                   right: 0,
    //                   left: 0,
    //                   child: const ArabicText(
    //                     'أسئلة تحتاج الي اجابة',
    //                     color: Colors.white,
    //                     fontSize: 10,
    //                     textAlign: TextAlign.center,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Transform.translate(
    //             offset: Offset(-11, 20),
    //             child: Expanded(
    //               child: Container(
    //                 // height: 50,
    //                 margin: const EdgeInsets.only(bottom: 70),
    //                 child: Image.asset("assets/images/Line.png", fit: BoxFit.cover),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(width: 5),
    //           GestureDetector(
    //             onTap: () {
    //               // Get.toNamed(AddResearchView.id);
    //               Navigator.of(context).pushNamed(AddResearchView.id);
    //               // Get.toNamed(AudioPlayerScreen.id);
    //             },
    //             child: Stack(
    //               children: [
    //                 Padding(
    //                   padding: EdgeInsets.only(bottom: 35),

    //                   child: Container(
    //                     height: size,
    //                     // width: 50,
    //                     alignment: Alignment.center,
    //                     child: Image.asset(
    //                       // "assets/images/research_icon.png",
    //                       AssetsData.researchLogoB,
    //                       fit: BoxFit.cover,
    //                     ),
    //                   ),
    //                 ),
    //                 Positioned(
    //                   bottom: 17,
    //                   right: 0,
    //                   left: 0,
    //                   child: const ArabicText(
    //                     "رفع بحث",
    //                     textAlign: TextAlign.center,
    //                     color: Colors.white,
    //                     fontSize: 10,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

extension Height on int {
  double get vh => this * (Get.height / 100);
  double get vw => this * (Get.width / 100);
}
