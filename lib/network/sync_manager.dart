import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/dialogs/custom_snack_bar.dart';
import 'package:dlalat_quaran_new/models/RelatedArticlesModel.dart';
import 'package:dlalat_quaran_new/models/RelatedTagModel.dart';
import 'package:dlalat_quaran_new/models/TagWordModel.dart';
import 'package:dlalat_quaran_new/models/article_model.dart';
import 'package:dlalat_quaran_new/models/aya_model.dart';
import 'package:dlalat_quaran_new/models/db_word_model.dart';
import 'package:dlalat_quaran_new/models/reciters_model.dart';
import 'package:dlalat_quaran_new/models/sura_model.dart';
import 'package:dlalat_quaran_new/models/tag_model.dart';
import 'package:dlalat_quaran_new/models/video_category.dart';
import 'package:dlalat_quaran_new/models/video_model.dart';
import 'package:dlalat_quaran_new/utils/audio_download.dart';
import 'package:dlalat_quaran_new/utils/audio_folders.dart';
import 'package:dlalat_quaran_new/utils/is_internet_available.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SyncManager extends GetxController {
  static const String _domainLink = "https://ioqs.org/control-panel/api/v1/";
  static const String _deviceKey = 'device_key';
  // Insert
  static const String _getInsert = "get-public-created";
  // Updated
  static const String _getUpdates = "get-public-updates";
  // Deleted
  static const String _getDeletes = "get-public-deleted";
  //
  static const String _confirmSync = "confirm-sync";

  static const String _dateFormat = 'yyyy-MM-dd HH:mm:ss';

  // temp varaible holders
  int page = 0;
  int limit = 10;
  List articles = [];
  List tags = [];
  List reciters = [];
  List languages = [];
  List videos = [];
  List videoCats = [];
  List relatedArticles = [];
  List tagWords = [];
  List relatedTags = [];
  List suras = [];
  List ayats = [];
  List word = [];
  final Dio _dio = Dio();

  var deviceId = '';

  var syncStarted = false;

  var isLoading = false.obs;

  var dbInstance = DataBaseHelper.database;

  String? lastSync;
  String? lastSyncInserted;
  String? lastSyncUpdated;
  String loadingState = "";
  bool hasMorePages = false;

  void setLoading(bool value) {
    isLoading.value = value;
    update();
  }

  static Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor.toString(); // Unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      log('Device Key ${androidDeviceInfo.id.toString()}');
      return androidDeviceInfo.id.toString(); // Unique ID on Android
    }
  }

  void syncData({bool forceUpdate = false}) async {
    return;
    String t = ' syncData inserted loop';
    pr('sync Started', t);
    if (!(await isInternetAvailable())) {
      showCustomSnackBar(title: 'تحذير', body: 'لا يوجد أتصال بالأنترنت', isSuccess: false);
      return;
    }
    try {
      if (!syncStarted) {
        syncStarted = true;
        bool continueLoop = true;
        page = 0;
        do {
          // reset all arrays
          articles = [];
          tags = [];
          reciters = [];
          languages = [];
          videos = [];
          videoCats = [];
          relatedArticles = [];
          tagWords = [];
          relatedTags = [];
          await _insertedData(forceUpdate: forceUpdate);
          pr('page: $page', t);
          pr('limit: $limit', t);
          pr('articles: ${articles.length}', t);
          pr('tags: ${tags.length}', t);
          pr('reciters: ${reciters.length}', t);
          pr('languages: ${languages.length}', t);
          pr('videos: ${videos.length}', t);
          pr('videoCats: ${videoCats.length}', t);
          pr('relatedArticles: ${relatedArticles.length}', t);
          pr('tagWords: ${tagWords.length}', t);
          pr('relatedTags: ${relatedTags.length}', t);
          if (articles.isEmpty &&
              tags.isEmpty &&
              reciters.isEmpty &&
              languages.isEmpty &&
              videos.isEmpty &&
              videoCats.isEmpty &&
              relatedArticles.isEmpty &&
              tagWords.isEmpty &&
              relatedTags.isEmpty) {
            continueLoop = false;
          } else {
            continueLoop = true;
            page++;
            pr('continue loop', t);
            pr('continueLoop : $continueLoop');
            pr('page : $page');
          }
          await Future.delayed(const Duration(seconds: 1));
        } while (continueLoop);
        t = ' syncData updated loop';
        continueLoop = true;
        page = 0;
        do {
          // reset all arrays
          articles = [];
          tags = [];
          reciters = [];
          languages = [];
          videos = [];
          videoCats = [];
          relatedArticles = [];
          tagWords = [];
          relatedTags = [];
          await _getUpdated();
          pr('page: $page', t);
          pr('limit: $limit', t);
          pr('articles: ${articles.length}', t);
          pr('tags: ${tags.length}', t);
          pr('reciters: ${reciters.length}', t);
          pr('languages: ${languages.length}', t);
          pr('videos: ${videos.length}', t);
          pr('videoCats: ${videoCats.length}', t);
          pr('relatedArticles: ${relatedArticles.length}', t);
          pr('tagWords: ${tagWords.length}', t);
          pr('relatedTags: ${relatedTags.length}', t);
          if (articles.isEmpty &&
              tags.isEmpty &&
              reciters.isEmpty &&
              languages.isEmpty &&
              videos.isEmpty &&
              videoCats.isEmpty &&
              relatedArticles.isEmpty &&
              tagWords.isEmpty &&
              relatedTags.isEmpty) {
            continueLoop = false;
          } else {
            continueLoop = true;
            page++;
            pr('continue loop', t);
            pr('continueLoop : $continueLoop');
            pr('page : $page');
          }
        } while (continueLoop);
        await _getDeleted();
        await _endSync();
      } else {
        await DataBaseHelper().videosCategories();
      }
    } on Exception catch (e) {
      syncStarted = false;
    }
  }

  // Inserted
  Future<void> _insertedData({bool forceUpdate = false}) async {
    // getLastSyncDate();
    const t = "inserted Data - sync manager";
    // updateSyncDate();
    pr("inserted data is called", t);
    //----------------------------------------------------------------------------------------------
    final now = DateTime.now();
    String currentDate = DateFormat(_dateFormat).format(now); // 28/03/2020
    lastSync = await DataBaseHelper.dataBaseInstance().getLastSyncDate();
    // pr('cached last lastSync: $lastSync', t);

    DateTime lastSyncDate = DateFormat(_dateFormat).parse(lastSync ?? '');
    DateTime timeNow = DateTime.now();

    // if (lastSyncDate.millisecondsSinceEpoch <
    //     DateTime(2024, 10, 7).millisecondsSinceEpoch) {
    //   lastSync = DateTime(2024, 10, 8).toString();
    // }

    // pr('forceUpdate: $forceUpdate', t);
    if (forceUpdate) {
      lastSync = DateFormat(_dateFormat).parse(lastSync ?? '').subtract(const Duration(days: 1)).toString();
    }
    // pr('lastSync: $lastSync', t);
    if (lastSync == currentDate && !forceUpdate) {
      return;
    }
    if (lastSyncDate.isAfter(timeNow) && !forceUpdate) {
      return;
    }

    if (!await isInternetAvailable()) {
      return;
    }
    //----------------------------------------------------------------------------------------------
    // pr("step 1", t);
    // pr('syncStarted $syncStarted', t);
    // if (!syncStarted) {
    if (true) {
      //----------------------------------------------------------------------------------------------
      // pr("step 2", t);
      // syncStarted = true;
      setLoading(true);
      deviceId = await _getId();
      // pr('deviceId: $deviceId', t);
      try {
        // _dio.interceptors.add(
        //   DioLoggingInterceptor(
        //     level: Level.body,
        //     compact: false,
        //   ),
        // );
        //----------------------------------------------------------------------------------------------
        // pr("step 3", t);
        // pr('_domainLink: $_domainLink', t);
        // pr('_getInsert: $_getInsert', t);
        // pr('deviceId: $deviceId', t);
        // pr('lastSync: $lastSync', t);
        var response = await _dio.get("$_domainLink$_getInsert/${page * limit}/$limit",
            queryParameters: {_deviceKey: deviceId, 'date': lastSync});
        //----------------------------------------------------------------------------------------------
        // pr("step 4", t);

        bool hasUpdates = response.data['status'];
        // pr('hasUpdates: $hasUpdates', t);
        //----------------------------------------------------------------------------------------------
        if (hasUpdates) {
          // pr("step 5", t);
          // List suras = response.data['sura'];
          // List ayats = response.data['ayats'];
          // List word = response.data['word'];
          articles = response.data['articles'] ?? [];
          tags = response.data['tags'] ?? [];
          // pr(tags, t);
          reciters = response.data['reciters'] ?? [];
          languages = response.data['languages'] ?? [];
          videos = response.data['videos'] ?? [];
          videoCats = response.data['video_categories'] ?? [];
          relatedArticles = response.data['related_articles'] ?? [];
          tagWords = response.data['tag_words'] ?? [];
          relatedTags = response.data['related_tags'] ?? [];
          // Suras
          // if (suras.isNotEmpty) {
          //   for (var x = 0; x < suras.length; x++) {
          //     SuraModel suraModel = SuraModel.fromJson(suras[x]);
          //     await DataBaseHelper.dataBaseInstance().insertSura(suraModel);
          //   }
          // }
          //
          // if (ayats.isNotEmpty) {
          //   for (var x = 0; x < ayats.length; x++) {
          //     AyaModel ayaModel = AyaModel.fromJson(ayats[x]);
          //     await DataBaseHelper.dataBaseInstance().insertAya(ayaModel);
          //   }
          // }
          // if (word.isNotEmpty) {
          //   for (var x = 0; x < word.length; x++) {
          //     DbWordModel wordModel = DbWordModel.fromJson(ayats[x]);
          //     await DataBaseHelper.dataBaseInstance().insertWord(wordModel);
          //   }
          // }
          // pr("step 6", t);

          // Articles
          if (articles.isNotEmpty) {
            for (var x = 0; x < articles.length; x++) {
              ArticleModel articleModel = ArticleModel.fromJson(articles[x]);
              await DataBaseHelper.dataBaseInstance().insertArticles(articleModel);
            }
          }
          // pr("step 7", t);
          // Tags
          if (tags.isNotEmpty) {
            for (var x = 0; x < tags.length; x++) {
              TagModel tagModel = TagModel.fromJson(tags[x]);
              await DataBaseHelper.dataBaseInstance().insertTags(tagModel);
            }
          }

          // Reciters
          if (reciters.isNotEmpty) {
            for (var x = 0; x < reciters.length; x++) {
              ReciterModel reciterModel = ReciterModel.fromJson(reciters[x]);
              await DataBaseHelper.dataBaseInstance().insertReciters(reciterModel);
            }
          }
          // pr("step 8", t);

          // Languages
          if (languages.isNotEmpty) {
            // for (var x = 0; x < languages.length; x++) {
            //   LanguageModel languageModel = LanguageModel.fromJson(languages[x]);
            //   var result =
            //   await DataBaseHelper.dataBaseInstance().updateSura(languageModel);
            //   print('updating Sura ${languageModel.id} $result}');
            // }
          }
          // pr("step 9", t);

          //Videos Categories
          if (videoCats.isNotEmpty) {
            for (var x = 0; x < videoCats.length; x++) {
              VideoCategory videoCat = VideoCategory.fromJson(videoCats[x]);
              await DataBaseHelper.dataBaseInstance().insertVideoCats(videoCat);

              await AudioFolders().downloadIcon(videoCat.iconUrl!);
              // print('updating Videos ${videoModel.id} $حresult}');
            }
          }
          // pr("step 10", t);

          //Videos
          if (videos.isNotEmpty) {
            for (var x = 0; x < videos.length; x++) {
              VideoModel videoModel = VideoModel.fromJson(videos[x]);
              await DataBaseHelper.dataBaseInstance().insertVideos(videoModel);
              // print('updating Videos ${videoModel.id} $result}');
            }
          }
          // pr("step 11", t);

          // TODO
          // RelatedArticles
          if (relatedArticles.isNotEmpty) {
            for (var x = 0; x < relatedArticles.length; x++) {
              RelatedArticlesModel relatedArticlesModel = RelatedArticlesModel.fromJson(relatedArticles[x]);
              await DataBaseHelper.dataBaseInstance().insertRelatedArticles(relatedArticlesModel);
            }
          }
          // pr("step 12", t);
          // tagWords
          if (tagWords.isNotEmpty) {
            for (var x = 0; x < tagWords.length; x++) {
              TagWordModel tagWordModel = TagWordModel.fromJson(tagWords[x]);
              await DataBaseHelper.dataBaseInstance().insertTagWords(tagWordModel);
            }
          }
          // pr("step13", t);
          // relatedTags
          if (relatedTags.isNotEmpty) {
            for (var x = 0; x < relatedTags.length; x++) {
              RelatedTagModel tagModel = RelatedTagModel.fromJson(relatedTags[x]);
              await DataBaseHelper.dataBaseInstance().insertRelatedTags(tagModel);
            }
          }
        }
        // pr("step 14", t);
        // log length
        // pr('articles: ${articles.length}', t);
        // pr('tags: ${tags.length}', t);
        // pr('reciters: ${reciters.length}', t);
        // pr('languages: ${languages.length}', t);
        // pr('videos: ${videos.length}', t);
        // pr('videoCats: ${videoCats.length}', t);
        // pr('relatedArticles: ${relatedArticles.length}', t);
        // pr('tagWords: ${tagWords.length}', t);
        // pr('relatedTags: ${relatedTags.length}', t);
        if (tags.isNotEmpty) {
          pr('tagsId: ${tags.first["id"]}', t);
        }

        // _getUpdated();
        // syncStarted = false;
      } on Exception catch (e) {
        syncStarted = false;
        pr('Exception occured: $e', t);
      }
      // _getDeleted();
    } else {
      pr('only triggred if sync is already started!!!', t);
      // await DataBaseHelper().videosCategories();
    }
  }

  static const String tag = 'SyncManager';

  // Updates
  Future<void> _getUpdated() async {
    const t = "_getUpdated - sync manager";
    pr("updated data is called", t);
    try {
      if (!await AudioDownload().isInternetAvailable()) {
        return;
      }
      // log('$tag _getUpdated $deviceId');
      // String deviceId = await _getId();
      // pr("step 1", t);
      pr('lastSync: $lastSync', t);
      var response = await _dio.get("$_domainLink$_getUpdates/${page * limit}/$limit",
          queryParameters: {_deviceKey: deviceId, 'date': lastSync});
      bool hasUpdates = response.data['status'];
      // pr("step 2", t);
      if (!hasUpdates) {
        pr("You shouldn't see this message: hasUpdates = $hasUpdates", t);
        return;
      }
      // pr("step 3", t);

      suras = response.data['sura'] ?? [];
      ayats = response.data['ayats'] ?? [];
      word = response.data['word'] ?? [];
      articles = response.data['articles'] ?? [];
      tags = response.data['tags'] ?? [];
      reciters = response.data['reciters'] ?? [];
      languages = response.data['languages'] ?? [];
      videos = response.data['videos'] ?? [];
      relatedArticles = response.data['related_articles'] ?? [];
      tagWords = response.data['tag_words'] ?? [];
      relatedTags = response.data['related_tags'] ?? [];
      videoCats = response.data['video_categories'] ?? [];
      // pr("step 4", t);

      // Suras
      if (suras.isNotEmpty) {
        for (var x = 0; x < suras.length; x++) {
          SuraModel suraModel = SuraModel.fromJson(suras[x]);
          await DataBaseHelper.dataBaseInstance().updateSura(suraModel);
        }
      }
      // pr("step 5", t);

      if (ayats.isNotEmpty) {
        for (var x = 0; x < ayats.length; x++) {
          AyaModel ayaModel = AyaModel.fromJson(ayats[x]);
          await DataBaseHelper.dataBaseInstance().updateAya(ayaModel);
        }
      }
      // pr("step 6", t);

      if (word.isNotEmpty) {
        // log('Words length ${word.length}');
        for (var x = 0; x < word.length; x++) {
          log('currenty ${word[x]}');
          DbWordModel wordModel = DbWordModel.fromJson(word[x]);
          await DataBaseHelper.dataBaseInstance().updateWord(wordModel);
        }
      }
      // pr("step 7", t);

      // Articles
      if (articles.isNotEmpty) {
        for (var x = 0; x < articles.length; x++) {
          ArticleModel articleModel = ArticleModel.fromJson(articles[x]);
          await DataBaseHelper.dataBaseInstance().updateArticles(articleModel);
        }
      }
      // pr("step 8", t);
      // Tags
      if (tags.isNotEmpty) {
        for (var x = 0; x < tags.length; x++) {
          TagModel tagModel = TagModel.fromJson(tags[x]);
          await DataBaseHelper.dataBaseInstance().updateTags(tagModel);
        }
      }
      // pr("step 9", t);
      // Reciters
      if (reciters.isNotEmpty) {
        for (var x = 0; x < reciters.length; x++) {
          ReciterModel reciterModel = ReciterModel.fromJson(reciters[x]);
          await DataBaseHelper.dataBaseInstance().updateReciters(reciterModel);
        }
      }
      // pr("step 10", t);
      // Languages
      if (languages.isNotEmpty) {
        // for (var x = 0; x < languages.length; x++) {
        //   LanguageModel languageModel = LanguageModel.fromJson(languages[x]);
        //   var result =
        //   await DataBaseHelper.dataBaseInstance().updateSura(languageModel);
        //   print('updating Sura ${languageModel.id} $result}');
        // }
      }
      // pr("step 11", t);
      //Videos Cats
      if (videos.isNotEmpty) {
        for (var x = 0; x < videos.length; x++) {
          VideoModel videoModel = VideoModel.fromJson(videos[x]);
          await DataBaseHelper.dataBaseInstance().updateVideos(videoModel);
        }
      }

      // pr("step 12", t);
      if (videoCats.isNotEmpty) {
        for (var x = 0; x < (videoCats.length ?? 0); x++) {
          VideoCategory videoCat = VideoCategory.fromJson(videoCats[x]);
          await DataBaseHelper.dataBaseInstance().updateVideoCats(videoCat);
          await AudioFolders().downloadIcon(videoCat.iconUrl!);
          // print('updating Videos ${videoModel.id} $result}');
        }
      }

      // pr("step 13", t);
      //Videos
      if (videos.isNotEmpty) {
        for (var x = 0; x < videos.length; x++) {
          VideoModel videoModel = VideoModel.fromJson(videos[x]);
          await DataBaseHelper.dataBaseInstance().updateVideos(videoModel);
        }
      }
      // pr("step 14", t);

      // TODO
      // RelatedArticles
      if (relatedArticles.isNotEmpty) {
        for (var x = 0; x < (relatedArticles.length ?? 0); x++) {
          RelatedArticlesModel relatedArticlesModel = RelatedArticlesModel.fromJson(relatedArticles[x]);
          DataBaseHelper.dataBaseInstance().updateRelatedArticles(relatedArticlesModel);
        }
      }
      // pr("step 15", t);

      // tagWords
      if (tagWords.isNotEmpty) {
        for (var x = 0; x < (tagWords.length ?? 0); x++) {
          TagWordModel tagWordModel = TagWordModel.fromJson(tagWords[x]);
          await DataBaseHelper.dataBaseInstance().updateTagWords(tagWordModel);
        }
      }
      // pr("step 16", t);
      // relatedTags
      if (relatedTags.isNotEmpty) {
        for (var x = 0; x < (relatedTags.length ?? 0); x++) {
          RelatedTagModel tagModel = RelatedTagModel.fromJson(relatedTags[x]);
          await DataBaseHelper.dataBaseInstance().updateRelatedTags(tagModel);
        }
      }
      // pr("step 17", t);
      // pr('articles: ${articles.length}', t);
      // pr('tags: ${tags.length}', t);
      // pr('reciters: ${reciters.length}', t);
      // pr('languages: ${languages.length}', t);
      // pr('videos: ${videos.length}', t);
      // pr('videoCats: ${videoCats.length}', t);
      // pr('relatedArticles: ${relatedArticles.length}', t);
      // pr('tagWords: ${tagWords.length}', t);
      // pr('relatedTags: ${relatedTags.length}', t);
      if (tags.isNotEmpty) {
        // pr('tagsId: ${tags.first["id"]}', t);
      }
      // _getDeleted();
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      syncStarted = false;
    }
  }

  // Deleted
  Future<void> _getDeleted() async {
    const t = '_getDeleted - syncManager';
    pr('_getDeleted is called', t);
    try {
      // log('$tag _getDeleted  $deviceId');
      // print('$tag _getDeleted  $deviceId');
      if (!await AudioDownload().isInternetAvailable()) {
        return;
      }
      var response =
          await _dio.get(_domainLink + _getDeletes, queryParameters: {_deviceKey: deviceId, 'date': lastSync});
      bool hasUpdates = response.data['status'];
      if (!hasUpdates) {
        return;
      }

      // List suras = response.data['sura'];
      // List ayats = response.data['ayats'];
      // List word = response.data['word'];
      List articles = response.data['articles'];
      List tags = response.data['tags'];
      List reciters = response.data['reciters'];
      List languages = response.data['languages'];
      List videos = response.data['videos'];
      List relatedArticles = response.data['related_articles'];
      List tagWords = response.data['tag_words'];
      List relatedTags = response.data['related_tags'];
      List videoCats = response.data['video_categories'];

      // Suras
      // if (suras.isNotEmpty) {
      //   for (var x = 0; x < suras.length; x++) {
      //     int suraModel = suras[x];
      //     var result =
      //         await DataBaseHelper.dataBaseInstance().deleteSura(suraModel);
      //     print('delete Sura $suraModel $result}');
      //   }
      // }

      // if (ayats.isNotEmpty) {
      //   for (var x = 0; x < ayats.length; x++) {
      //     int ayaId = ayats[x];
      //     var result =
      //         await DataBaseHelper.dataBaseInstance().deleteAya(ayaId);
      //     print('delete Aya $ayaId $result}');
      //   }
      // }
      // if (word.isNotEmpty) {
      //   for (var x = 0; x < word.length; x++) {
      //     int wordModel = word[x];
      //     var result =
      //         await DataBaseHelper.dataBaseInstance().deleteWord(wordModel);
      //     print('Delete Word $wordModel $result}');
      //   }
      // }

      // Articles
      if (articles.isNotEmpty) {
        for (var x = 0; x < articles.length; x++) {
          int articleModel = articles[x];
          await DataBaseHelper.dataBaseInstance().deleteArticles(articleModel);
        }
      }
      // Tags
      if (tags.isNotEmpty) {
        for (var x = 0; x < tags.length; x++) {
          int tagModel = tags[x];
          await DataBaseHelper.dataBaseInstance().deleteTags(tagModel);
        }
      }
      // Reciters
      if (reciters.isNotEmpty) {
        for (var x = 0; x < reciters.length; x++) {
          int reciterModel = reciters[x];
          await DataBaseHelper.dataBaseInstance().deleteReciters(reciterModel);
        }
      }
      // Languages
      if (languages.isNotEmpty) {
        // for (var x = 0; x < languages.length; x++) {
        //   LanguageModel languageModel = LanguageModel.fromJson(languages[x]);
        //   var result =
        //   await DataBaseHelper.dataBaseInstance().updateSura(languageModel);
        //   print('updating Sura ${languageModel.id} $result}');
        // }
      }

      if (videoCats.isNotEmpty) {
        for (var x = 0; x < videoCats.length; x++) {
          VideoCategory videoCat = VideoCategory.fromJson(videoCats[x]);
          await DataBaseHelper.dataBaseInstance().deleteVideoCats(videoCat.id!);
          // print('updating Videos ${videoModel.id} $result}');
        }
      }

      //Videos
      if (videos.isNotEmpty) {
        for (var x = 0; x < videos.length; x++) {
          int videoModel = videos[x];
          await DataBaseHelper.dataBaseInstance().deleteVideos(videoModel);
        }
      }

      // TODO
      // RelatedArticles
      if (relatedArticles.isNotEmpty) {
        for (var x = 0; x < relatedArticles.length; x++) {
          int relatedArticlesModel = relatedArticles[x];
          await DataBaseHelper.dataBaseInstance().deleteRelatedArticles(relatedArticlesModel);
        }
      }

      // tagWords
      if (tagWords.isNotEmpty) {
        for (var x = 0; x < tagWords.length; x++) {
          int tagWordModel = tagWords[x];
          await DataBaseHelper.dataBaseInstance().deleteTagWords(tagWordModel);
        }
      }
      // relatedTags
      if (relatedTags.isNotEmpty) {
        for (var x = 0; x < relatedTags.length; x++) {
          int tagModel = relatedTags[x];
          await DataBaseHelper.dataBaseInstance().deleteRelatedTags(tagModel);
        }
      }

      // _endSync();
    } on Exception catch (e) {
      syncStarted = false;
    }
  }

  Future<void> _endSync() async {
    const t = '_endSync - syncManager';
    pr('_endSync is called', t);
    // var response =
    //     await _dio.post(_domainLink + _confirmSync, queryParameters: {_deviceKey: deviceId, 'date': lastSync});
    // bool hasUpdates = response.data['status'];
    // log('End Sync Status $hasUpdates');
    // print('End Sync Status $hasUpdates');
    await updateSyncDate();
    syncStarted = false;
    pr('custom bar should show success');
    showCustomSnackBar(title: "تم بنجاح", body: "المزامنة مع قاعدة البيانات");

    setLoading(false);
  }

  Future<void> updateSyncDate({bool isLoop = false}) async {
    const t = 'updateSyncDate - syncManager';
    pr('updateSyncDate is called', t);
    // log('current Date  update Start ');
    final now = DateTime.now();
    String formatter = DateFormat(_dateFormat).format(now); // 28/03/2020
    lastSync = formatter;
    pr('lastSync: $lastSync', t);
    update();
    // log('current Date  update date $formatter');
    String query = " UPDATE saved_values SET value = '$formatter' WHERE key = 1";
    await dbInstance.rawUpdate(query);
  }
}
