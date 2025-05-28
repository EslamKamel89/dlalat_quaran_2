import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dlalat_quaran_new/controllers/similar_word_controller.dart';
import 'package:dlalat_quaran_new/models/RelatedArticlesModel.dart';
import 'package:dlalat_quaran_new/models/RelatedTagModel.dart';
import 'package:dlalat_quaran_new/models/TagWordModel.dart';
import 'package:dlalat_quaran_new/models/article_model.dart';
import 'package:dlalat_quaran_new/models/aya_model.dart';
import 'package:dlalat_quaran_new/models/db_word_model.dart';
import 'package:dlalat_quaran_new/models/language_model.dart';
import 'package:dlalat_quaran_new/models/page_ayat_sura_model.dart';
import 'package:dlalat_quaran_new/models/reciters_model.dart';
import 'package:dlalat_quaran_new/models/similar_word_model.dart';
import 'package:dlalat_quaran_new/models/sura_model.dart';
import 'package:dlalat_quaran_new/models/sura_search_model.dart';
import 'package:dlalat_quaran_new/models/sura_search_result_model.dart';
import 'package:dlalat_quaran_new/models/tag_model.dart';
import 'package:dlalat_quaran_new/models/video_category.dart';
import 'package:dlalat_quaran_new/models/video_model.dart';
import 'package:dlalat_quaran_new/models/word_model.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static Database? _database;

  static Database get database => _database!;
  static const String _dataBaseName = 'dlalat_qurann.db';
  static const String _sura = 'sura';
  static const String _tag = 'tags';
  static const String _articles = 'articles';
  static const String _articlesSeries = 'articles-series';
  static const String _series = 'articles-series';
  static const String _ayat = 'ayat';
  static const String _recitersTable = 'reciters';
  static const String _videosTable = 'videos';
  static const String _videoCats = 'video_categories';
  static DataBaseHelper? _baseHelper;

  static DataBaseHelper dataBaseInstance() {
    _baseHelper ??= DataBaseHelper();
    return _baseHelper!;
  }

  Future initDb() async {
    if (_database == null) {
      var dbPath = await getDatabasesPath();
      final path = join(dbPath, _dataBaseName);

      final exist = await databaseExists(path);

      if (exist) {
        //print("Data Base State = Exist");
        await openDatabase(path);
      } else {
        //print('Data Base State = Not Exist');

        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (_) {}

        ByteData data = await rootBundle.load(join("assets", _dataBaseName));
        List<int> bytes = data.buffer.asUint8ClampedList(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
        //print('Opened');
      }
      _database = await openDatabase(path, version: 1);
    }
    // List<Map> list = await database.rawQuery('SELECT * FROM quran WHERE field1 = 9996');
    // //print('List ${list.toString()}');
  }

  Future<List<SuraModel>> suraIndex() async {
    List<SuraModel> suras = [];
    List<Map<String, dynamic>> rawQuery = await _database!.rawQuery("SELECT * FROM $_sura");
    for (var x = 0; x < rawQuery.length; x++) {
      var suraModel = SuraModel.fromJson(rawQuery[x]);
      suras.add(suraModel);
    }
    //log('Data In Sura All ');
    return suras;
  }

  // Worked For Word
  Future<List<List<WordModel>>> getFull(int page) async {
    List<List<WordModel>> linesModelList = [];
    // String query =
    //     "SELECT words.id, words.position as position, words.vedio as word_video, words.char_type , ayat.vedio as vedio , ayat.id as ayaId , words.line, words.ayat_id as ayaNo, words.juz, words.sura_id, tag_word.tag_id, words.code as word_ar, words.page , tag_word.id as has_tag, tags.id as tag_id, tags.name_ar  as tag_name_ar "
    //     "  FROM words"
    //     "  join ayat on ( words.sura_id = ayat.sura_id and words.ayat_id = ayat.ayah )"
    //     "  left join ( tag_word join tags on tag_word.tag_id = tags.id AND tags.enabled = 1 and tag_word.enabled = 1 )"
    //     "  on tag_word.word_id = words.id where words.page  =$page  group by words.id"
    //     "  order by words.id";
    String query =
        "   SELECT words.id, words.position as position, words.vedio as word_video, words.char_type , ayat.vedio as vedio , ayat.id as ayaId , words.line, words.ayat_id as ayaNo, words.juz, words.sura_id, tag_word.tag_id, words.code as word_ar, words.page , tag_word.id as has_tag, tags.id as tag_id, tags.name_ar  as tag_name_ar "
        " , videos.id as word_video_id, videos.url as word_video_url, videos.name as word_video_title"
        " , ayatvideos.id as aya_video_id, ayatvideos.url as aya_video_url, ayatvideos.name as aya_video_title"
        " FROM words"
        " left join videos on ( videos.word_id = words.id AND videos.type = 'tag' AND videos.enabled = 1 )"
        " join ayat on ( words.sura_id = ayat.sura_id and words.ayat_id = ayat.ayah )"
        " left join videos ayatvideos on ( ayatvideos.ayat_id = ayat.id AND ayatvideos.type = 'explain' AND ayatvideos.enabled = 1 )"
        " left join ( tag_word join tags on tag_word.tag_id = tags.id "
        " AND tags.enabled = 1 "
        "and tag_word.enabled = 1 )"
        " on tag_word.word_id = words.id where words.page  = $page "
        "group by words.id"
        " order by words.id";
    List<Map<String, dynamic>> rawQuery = await _database!.rawQuery(query);
    log('querty = \n$query');

    int linesCount = int.parse(rawQuery[rawQuery.length - 1]['line'].toString());

    var newMap = groupBy(rawQuery, (Map obj) => obj['line']);

    for (var i = 0; i < linesCount; i++) {
      String line = "";
      List<WordModel> wordModelList = [];
      WordModel mainWord = WordModel();
      // تشيك على اول سطر
      if (newMap[newMap.keys.first + i] != null) {
        for (var j = 0; j < newMap[newMap.keys.first + i]!.length; j++) {
          WordModel childWord = WordModel();

          childWord.word_id = newMap[newMap.keys.first + i]![j]['id'].toString();
          childWord.sura = newMap[newMap.keys.first + i]![j]['sura_id'].toString();
          childWord.color =
              newMap[newMap.keys.first + i]![j]['has_tag'].toString() != 'null' ? Colors.red : Colors.black;
          childWord.ayaId = newMap[newMap.keys.first + i]![j]['ayaId'].toString();
          String n = newMap[newMap.keys.first + i]![j]['word_ar'].toString() != "null"
              ? newMap[newMap.keys.first + i]![j]['word_ar'].toString()
              : newMap[newMap.keys.first + i]![j]['ayaNo'].toString();
          childWord.line = newMap[newMap.keys.first + i]![j]['line'];
          childWord.char_type = childWord.word_ar = n;
          childWord.suraName = await getSuraById(childWord.sura!);
          childWord.position = newMap[newMap.keys.first + i]![j]['position'];
          childWord.ayaNo = newMap[newMap.keys.first + i]![j]['ayaNo'];

          // childWord.juz = newMap[newMap.keys.first+1]![j]['juz'];
          childWord.char_type = newMap[newMap.keys.first + i]![j]['char_type'];
          childWord.tagId = newMap[newMap.keys.first + i]![j]['tag_id'].toString();
          childWord.videoId = newMap[newMap.keys.first + i]![j]['aya_video_url'].toString();
          childWord.wordVideo = newMap[newMap.keys.first + i]![j]['word_video_url'].toString();

          log('wordVideo = ${newMap[newMap.keys.first + i]![j]['word_video'].toString()}');

          // childWord.videoId = newMap[newMap.keys.first + i]![j]['vedio'].toString();

          line = '$line $n';
          mainWord.word_ar = line;
          wordModelList.add(childWord);
        }
      }
      if (wordModelList.isNotEmpty) {
        linesModelList.add(wordModelList);
      }
    }

    return linesModelList;
  }

  Future<String> getAyaId(int suraId, int ayaNo) async {
    String ayaId = '0';
    List<Map<String, dynamic>> rawQuery =
        await _database!.rawQuery("SELECT id FROM ayat WHERE sura_id = '$suraId' AND ayah = '$ayaNo' ");
    ayaId = rawQuery[0]['id'].toString();
    //print('aya_AyaId $ayaId');
    return ayaId;
  }

  Future<String> getAyaTextArByAyaId(int ayaId) async {
    String ayaAr = '';
    List<Map<String, dynamic>> rawQuery = await _database!.rawQuery("SELECT text_ar FROM ayat WHERE id = '$ayaId' ");
    ayaAr = rawQuery[0]['text_ar'].toString();
    return ayaAr;
  }

  Future<String> getAyaTextAr(int suraId, int ayaNo, int ayaId) async {
    print("rawQuery ======================= $suraId     , $ayaNo     $ayaId");

    String ayaAr = '';
    List<Map<String, dynamic>> rawQuery = await _database!.rawQuery("SELECT text_ar FROM ayat WHERE id = '$ayaId' ");
    ayaAr = rawQuery[0]['text_ar'].toString();
    return ayaAr;
  }

  // Worked For Word
  Future<List<List<WordModel>>> getFullByAya(int suraId, int startAya) async {
    List<List<WordModel>> linesModelList = [];

    var endAya = startAya + 10;
    var sqlQuery =
        "SELECT words.id, words.position as position, words.char_type ,  ayat.id as ayaId , words.line, words.ayat_id as ayaNo,  words.juz, words.sura_id, tag_word.tag_id, words.word_ar, words.word_en, words.page , tag_word.id as has_tag, tags.id as tag_id, tags.name_ar  as tag_name_ar  "
        " FROM words "
        " join ayat on ( words.sura_id = ayat.sura_id and words.ayat_id = ayat.ayah ) "
        " left join ( tag_word join tags on tag_word.tag_id = tags.id AND tags.enabled = 1 and tag_word.enabled = 1 ) "
        " on tag_word.word_id = words.id where words.sura_id  ='$suraId'  AND words.ayat_id BETWEEN $startAya AND $endAya  group by words.id";
    //print('Sql Query = $sqlQuery');
    List<Map<String, dynamic>> rawQuery = await _database!.rawQuery(sqlQuery);

    //print('current ayat Start $startAya End $endAya');
    int linesCount = int.parse(rawQuery[rawQuery.length - 1]['ayaNo'].toString());

    var newMap = groupBy(rawQuery, (Map obj) => obj['ayaNo']);

    for (var i = 0; i < linesCount; i++) {
      String line = "";
      String lineEn = "";
      List<WordModel> wordModelList = [];
      WordModel mainWord = WordModel();
      // تشيك على اول سطر
      if (newMap[newMap.keys.first + i] != null) {
        for (var j = 0; j < newMap[newMap.keys.first + i]!.length; j++) {
          WordModel childWord = WordModel();

          childWord.word_id = newMap[newMap.keys.first + i]![j]['id'].toString();
          childWord.sura = newMap[newMap.keys.first + i]![j]['sura_id'].toString();
          childWord.color =
              newMap[newMap.keys.first + i]![j]['has_tag'].toString() != 'null' ? Colors.red : Colors.black;
          childWord.ayaId = newMap[newMap.keys.first + i]![j]['ayaId'].toString();
          String n = newMap[newMap.keys.first + i]![j]['word_ar'] != "null"
              ? newMap[newMap.keys.first + i]![j]['word_ar'].toString()
              : newMap[newMap.keys.first + i]![j]['ayaNo'].toString();

          String nEn = newMap[newMap.keys.first + i]![j]['word_en'].toString().toLowerCase() != "null"
              ? newMap[newMap.keys.first + i]![j]['word_en'].toString()
              : newMap[newMap.keys.first + i]![j]['ayaNo'].toString();

          childWord.line = newMap[newMap.keys.first + i]![j]['line'];
          childWord.char_type = childWord.word_ar = n;
          childWord.suraName = await getSuraById(childWord.sura!);
          childWord.position = newMap[newMap.keys.first + i]![j]['position'];
          childWord.ayaNo = newMap[newMap.keys.first + i]![j]['ayaNo'];

          // childWord.juz = newMap[newMap.keys.first+1]![j]['juz'];

          childWord.tagId = newMap[newMap.keys.first + i]![j]['tag_id'].toString();
          childWord.videoId = newMap[newMap.keys.first + i]![j]['vedio'].toString();
          childWord.word_en = newMap[newMap.keys.first + i]![j]['word_en'].toString().replaceAll("NULL", 'null');
          // childWord.videoId = newMap[newMap.keys.first + i]![j]['vedio'].toString();

          line = '$line $n';
          lineEn = '$lineEn $nEn';
          mainWord.word_ar = line;
          mainWord.word_en = lineEn;
          //log('English line \n ${mainWord.word_ar}');
          wordModelList.add(childWord);
        }
      }
      if (wordModelList.isNotEmpty) {
        linesModelList.add(wordModelList);
      }
    }

    return linesModelList;
  }

  Future<String> getJuz(int aya, int sura) async {
    String juz = "";
    var queryResult =
        await _database!.rawQuery("SELECT juz FROM ayat where ayah ='$aya' AND sura_id = '$sura' LIMIT '1'");
    juz = queryResult[0]['juz'].toString();
    return juz;
  }

  Future<String> getSuraById(String id) async {
    String suraName = '';

    var queryResult = await _database!.rawQuery("SELECT * FROM sura where id ='$id'");

    // //print("Sura Object ${queryResult[0]['sura_ar']}");
    suraName = '${queryResult[0]['sura_ar']}';
    return suraName;
  }

  Future<int> getAyaPage(String ayaId) async {
    int ayaPage = 1;

    var queryResult = await _database!.rawQuery("SELECT page FROM ayat where id ='$ayaId'");

    // //print("Sura Object ${queryResult[0]['sura_ar']}");
    ayaPage = int.parse(queryResult[0]['page'].toString());
    return ayaPage;
  }

  Future<String> getSuraByPage(int suraId) async {
    //print('Sura Id $suraId');
    var list = await _database!.rawQuery("SELECT * FROM sura WHERE id ='$suraId' ");

    String suraName = "";
    // //print('List Aya $list');

    suraName = list[list.length - 1]["sura_ar"].toString();

    // //print('Single Aya $suraName');
    return suraName;
  }

  Future<int> suraCount(int suraId) async {
    int suraCount = 0;
    var list = await _database!.rawQuery("SELECT ayah FROM $_sura WHERE id = '$suraId'");
    suraCount = int.parse(list[0]['ayah'].toString());
    //print('sura Count is $list Count = $suraCount');

    return suraCount;
  }

  String name() {
    String name = "name_ar";
    switch (GetStorage().read(language)) {
      case 'ar':
        name = 'name_ar';
        break;
      case 'en':
        name = 'name_en';
        break;
      case 'fr':
        name = 'name_fr';
        break;
      case 'es':
        name = 'name_sp';
        break;
      case 'it':
        name = 'name_it';
        break;
      default:
        name = 'name_ar';
    }
    return name;
  }

  //TODO Tags
  Future<List<TagModel>> tagsIndex() async {
    List<TagModel> tags = [];
    String query = " SELECT tags.* "
        " FROM tags "
        " left join tag_word on tag_word.tag_id = tags.id and tag_word.enabled = 1 "
        " left join words on tag_word.word_id = words.id "
        " left join videos on videos.word_id = tags.id and videos.type='tag' and videos.enabled=1 "
        " where tags.enabled = 1 "
        " group by tags.id "
        // " having ( count(videos.id) > 0 or tags.desc_ar is not NULL ) "
        " ORDER BY ${name()} ";
    log('TagsQuery $query');

    List<Map<String, dynamic>> rawQuery = await _database!.rawQuery(query);
    for (var x = 0; x < rawQuery.length; x++) {
      var tagModel = TagModel.fromJson(rawQuery[x]);
      tags.add(tagModel);
    }
    return tags;
  }

  Future<List<VideoModel>> tagsVideos(int tagId) async {
    List<VideoModel> videos = [];
    String query = "select * from videos "
        " where type = 'tag' and enabled = 1"
        " and word_id in ( select word_id from tags where word_id = $tagId and enabled = 1 ) "
        " group by url";

    log('tagsVideos Query = $query');

    var list = await database.rawQuery(query);
    log('video tags = $list');
    if (list.isNotEmpty) {
      for (var x = 0; x < list.length; x++) {
        videos.add(VideoModel.fromJson(list[x]));
      }
    }
    return videos;
  }

  Future<List<TagModel>> relatedTags(int articleId) async {
    List<TagModel> relatedList = [];
    // List<Map<String, dynamic>> rawQuery = await _database!.rawQuery(
    //     "SELECT related_tag_id FROM $_articlesRelations WHERE $_articlesId = '$articleId'");
    List<Map<String, dynamic>> rawQuery = await _database!
        .rawQuery("select * from tags where id in ( select related_tag_id from related_tag WHERE tag_id = $articleId)");

    // "select * from tags where id in ( select related_tag_id from article_tag )"
    //log("related => $rawQuery");
    for (var x = 0; x < rawQuery.length; x++) {
      relatedList.add(TagModel.fromJson(rawQuery[x]));
    }
    //log("related => $rawQuery");

    return relatedList;
  }

//TODO Tags

//TODO ARTICLES
  Future<List<ArticleModel>> allArticles() async {
    var langId = modes.where((element) => element.langCode == GetStorage().read(language)).toList()[0].dbLangId;

    List<ArticleModel> articlesList = [];
    List<Map<String, dynamic>> rawQuery =
        await _database!.rawQuery("SELECT * FROM $_articles  WHERE lang_id = '$langId'");

    for (var x = 0; x < rawQuery.length; x++) {
      var tagModel = ArticleModel.fromJson(rawQuery[x]);
      articlesList.add(tagModel);
    }
    //log("Articles Length ${articlesList.length}}");
    return articlesList;
  }

  Future<List<ArticleModel>> relatedArticles(int articleId) async {
    List<ArticleModel> relatedList = [];
    // List<Map<String, dynamic>> rawQuery = await _database!.rawQuery(
    //     "SELECT related_tag_id FROM $_articlesRelations WHERE $_articlesId = '$articleId'");
    List<Map<String, dynamic>> rawQuery = await _database!.rawQuery(
        "select * from articles where id in ( select related_article_id from related_articles WHERE article_id = $articleId)");

    // "select * from tags where id in ( select related_tag_id from article_tag )"
    //log("related => $rawQuery");
    for (var x = 0; x < rawQuery.length; x++) {
      relatedList.add(ArticleModel.fromJson(rawQuery[x]));
    }
    //log("related => $rawQuery");

    return relatedList;
  }

//TODO ARTICLES

//TODO VIDEOS
  Future<List<VideoModel>> allVideos() async {
    List<VideoModel> videosList = [];
    List<Map<String, dynamic>> rawQuery =
        await _database!.rawQuery("SELECT * FROM $_videosTable WHERE type = 'public'");

    for (var x = 0; x < rawQuery.length; x++) {
      var videoModel = VideoModel.fromJson(rawQuery[x]);
      videosList.add(videoModel);
    }
    //log("Articles Length ${videosList.length}}");
    return videosList;
  }

  Future<List<VideoModel>> getAllVideosRaw() async {
    List<VideoModel> videosList = [];
    List<Map<String, dynamic>> rawQuery = await _database!.rawQuery("SELECT * FROM $_videosTable "
        // "WHERE type = 'public'",
        );

    for (var x = 0; x < rawQuery.length; x++) {
      var videoModel = VideoModel.fromJson(rawQuery[x]);
      videosList.add(videoModel);
    }
    //log("Articles Length ${videosList.length}}");
    pr(videosList, 'getAllVideosRaw');
    return videosList;
  }

  Future<List<VideoModel>> categoryVideos(String type) async {
    List<VideoModel> videosList = [];
    String query = "SELECT  DISTINCT * FROM $_videosTable WHERE type = '$type' AND enabled = 1 GROUP by id";
    List<Map<String, dynamic>> rawQuery = await _database!.rawQuery(query);
    log('SLSLS \n $query');

    for (var x = 0; x < rawQuery.length; x++) {
      var videoModel = VideoModel.fromJson(rawQuery[x]);
      videosList.add(videoModel);
    }
    //log("Articles Length ${videosList.length}}");
    return videosList;
  }

  Future<List<VideoCategory>> videosCategories() async {
    List<VideoCategory> cats = [];
    String query = "SELECT * FROM video_categories where enabled = 1";
    var list = await _database!.rawQuery(query);
    // cats.add(VideoCategory(id:'tag',nameAr: "كلمات قرآنية" ,nameEn: 'Quranic words',enabled: 1));
    // cats.add(VideoCategory(id:'explain',nameAr: "تفسير آيات" ,nameEn: 'Verses explaination',enabled: 1));
    for (var element in list) {
      https: //qurantoall.com/control-panel/storage/
      // await AudioFolders().downloadIcon(element['icon']);
      log('Videos Url ${element['icon']}');
      cats.add(VideoCategory.fromJson(element));
    }
    return cats;
  }

//TODO VIDEOS

//TODO EXPLANATION

  Future<Map<String, Object?>> getExplanation(String aya) async {
    String explainingKey = '';
    String textKey = '';
    switch (GetStorage().read(language)) {
      case 'ar':
        explainingKey = 'explain_ar';
        textKey = 'text_ar';
        break;
      case 'en':
        explainingKey = 'explain_en';
        textKey = 'text_en';
        break;
      case 'fr':
        explainingKey = 'explain_fr';
        textKey = 'text_fr';
        break;
      case 'es':
        explainingKey = 'explain_sp';
        textKey = 'text_sp';

        break;
      case 'it':
        explainingKey = 'explain_it';
        textKey = 'text_it';

        break;
      default:
        explainingKey = 'explain_ar';
        textKey = 'text_ar';
    }
    var result = await _database!.rawQuery(
        "SELECT $textKey as ayaText, $explainingKey as explainText , vedio as videoUrl FROM $_ayat WHERE id = '$aya' LIMIT 1 ");
    return result[0];
  }

//TODO EXPLANATION

//TODO TAGS
  Future<Map<String, Object?>> getTagVideo(String wordId) async {
    String descriptionKey = '';
    String nameKey = '';
    switch (GetStorage().read(language)) {
      case 'ar':
        descriptionKey = 'desc_ar';
        nameKey = 'name_ar';
        break;
      case 'en':
        descriptionKey = 'desc_en';
        nameKey = 'name_en';
        break;
      case 'fr':
        descriptionKey = 'desc_fr';
        nameKey = 'name_fr';
        break;
      case 'es':
        descriptionKey = 'desc_sp';
        nameKey = 'name_sp';

        break;
      default:
        descriptionKey = 'desc_ar';
        nameKey = 'name_ar';
    }

    // var list = await _database!.rawQuery(
    //     "SELECT url , name from videos WHERE type = 'tag' and word_id = $wordId");
    var list = await _database!.rawQuery(
        " SELECT tags.$descriptionKey as desc , tags.$nameKey as name ,videos.url as url , videos.name as video_name , tags.enabled as is_enabled"
        " from tags "
        " LEFT JOIN videos ON tags.id = videos.word_id "
        " WHERE tags.id = '$wordId' ");
    //print('result ${list[0]['url']}');
    return list[0];
  }

//TODO TAGS

//TODO Reciters

  Future<List<ReciterModel>> getReciters() async {
    List<ReciterModel> reciters = [];

    var list = await _database!.rawQuery("SELECT * FROM $_recitersTable");
    for (var x = 0; x < list.length; x++) {
      reciters.add(ReciterModel.fromJson(list[x]));
    }
    return reciters;
  }

  Future<ReciterModel> getCurrentReciter(var selectedId) async {
    String query = selectedId.toString() != 'null'
        ? 'SELECT * FROM $_recitersTable WHERE id = $selectedId'
        : 'SELECT * FROM $_recitersTable LIMIT 1';

    var list = await _database!.rawQuery(query);
    return ReciterModel.fromJson(list[0]);
  }

//TODO Reciters

  Future<List<PageAyatSuraModel>> pageAyatSura(int page) async {
    List<PageAyatSuraModel> models = [];
    var list = await _database!.rawQuery("SELECT sura_id, ayah FROM $_ayat WHERE page = $page");
    for (var x = 0; x < list.length; x++) {
      models.add(PageAyatSuraModel(list[x]['ayah'].toString(), list[x]['sura_id'].toString()));
    }
    // //print('Models $models');
    return models;
  }

  // Sync

  // Suras
  Future<int> insertSura(SuraModel suraModel) async {
    log('Inset Aya ${suraModel.id}');
    return await _database!.insert(_sura, suraModel.toJson());
  }

  Future<int> updateSura(SuraModel suraModel) async {
    log('Update Aya ${suraModel.id}');
    return await _database!.update(_sura, suraModel.toJson(), where: 'id = ?', whereArgs: [suraModel.id]);
  }

  Future<int> deleteSura(int suraId) async {
    log('Delete Aya $suraId');
    return await _database!.delete(_sura, where: 'id = ?', whereArgs: [suraId]);
  }

  // Ayat
  Future<List<AyaModel>> getAyaBySuaId(int suraId) async {
    const t = 'getAyaBySuaId - DatabaseHelper';
    try {
      var queryResult = await _database!.rawQuery("SELECT * FROM $_ayat where sura_id ='$suraId'");
      pr(queryResult, '$t raw response');
      List<AyaModel> ayat = queryResult.map<AyaModel>((aya) => AyaModel.fromJson(aya)).toList();
      pr(ayat, '$t parsed response');
      return ayat;
    } on Exception catch (e) {
      pr(e, '$t Exception occured');
      return <AyaModel>[];
    }
  }

  Future<int> insertAya(AyaModel ayaModel) async {
    log('Inset Aya ${ayaModel.id}');
    return await _database!.insert(_ayat, ayaModel.toJson());
  }

  Future<int> updateAya(AyaModel ayaModel) async {
    log('Update Aya ${ayaModel.id}');
    return await _database!.update(_ayat, ayaModel.toJson(), where: 'id = ?', whereArgs: [ayaModel.id]);
  }

  Future<int> deleteAya(int ayaId) async {
    log('Update Aya $ayaId}');
    return await _database!.delete(_ayat, where: 'id = ?', whereArgs: [ayaId]);
  }

  // Words
  Future<List<DbWordModel>> getWordByAyahId(int suraId, int ayaId) async {
    const t = 'getWordByAyahId - DatabaseHelper';
    try {
      var queryResult =
          await _database!.rawQuery(pr("SELECT * FROM words where ayat_id =$ayaId AND sura_id=$suraId", t));
      // var queryResult = await _database!.rawQuery("SELECT * FROM words WHERE ayat_id=1 LIMIT 1");
      pr(queryResult, '$t raw response');
      List<DbWordModel> words = queryResult.map<DbWordModel>((aya) => DbWordModel.fromJsonOnlyAyaId(aya)).toList();
      pr(words, '$t parsed response');
      return words;
    } on Exception catch (e) {
      pr(e, '$t Exception occured');
      return <DbWordModel>[];
    }
  }

  Future<int> insertWord(DbWordModel wordModel) async {
    log('Insert Word ${wordModel.id}');
    return await _database!.insert('words', wordModel.toJson());
  }

  Future<int> updateWord(DbWordModel wordModel) async {
    log('Update Word ${wordModel.id}');
    return await _database!.update('words', wordModel.toJson(), where: 'id = ?', whereArgs: [wordModel.id]);
  }

  Future<int> deleteWord(int id) async {
    log('Delete Word $id');
    return await _database!.delete('words', where: 'id = ?', whereArgs: [id]);
  }

  // articles
  Future<int> insertArticles(ArticleModel articleModel) async {
    log('insert Article ${articleModel.id}');
    return await _database!.insert(_articles, articleModel.toJson());
  }

  Future<int> updateArticles(ArticleModel articleModel) async {
    log('Update Article ${articleModel.id}');
    return await _database!.update(_articles, articleModel.toJson(), where: 'id = ?', whereArgs: [articleModel.id]);
  }

  Future<int> deleteArticles(int articleModel) async {
    log('delete Article $articleModel');
    return await _database!.delete(_articles, where: 'id = ?', whereArgs: [articleModel]);
  }

// articles series
  // Future<List<ArticleModel>> allArticlesSeries() async {
  //   var langId = modes.where((element) => element.langCode == GetStorage().read(language)).toList()[0].dbLangId;

  //   List<ArticleModel> articlesList = [];
  //   List<Map<String, dynamic>> rawQuery =
  //       await _database!.rawQuery("SELECT * FROM $_articles  WHERE lang_id = '$langId'");

  //   for (var x = 0; x < rawQuery.length; x++) {
  //     var tagModel = ArticleModel.fromJson(rawQuery[x]);
  //     articlesList.add(tagModel);
  //   }
  //   //log("Articles Length ${articlesList.length}}");
  //   return articlesList;
  // }

  // Future<int> insertArticlesSeries(ArticleModel articleModel) async {
  //   log('insert Article ${articleModel.id}');
  //   return await _database!.insert(_articles, articleModel.toJson());
  // }

  // Future<int> updateArticlesSeries(ArticleModel articleModel) async {
  //   log('Update Article ${articleModel.id}');
  //   return await _database!.update(_articles, articleModel.toJson(), where: 'id = ?', whereArgs: [articleModel.id]);
  // }

  // Future<int> deleteArticlesSeries(int articleModel) async {
  //   log('delete Article $articleModel');
  //   return await _database!.delete(_articles, where: 'id = ?', whereArgs: [articleModel]);
  // }

  // tags
  Future<int> insertTags(TagModel tagModel) async {
    log('insert Tag ${tagModel.id}');
    if (!await ifExists(_tag, tagModel.id!.toString())) {
      return await _database!.insert(_tag, tagModel.toJson());
    } else {
      return 0;
    }
  }

  Future<int> updateTags(TagModel tagModel) async {
    log('Update Tag ${tagModel.toString()}');
    return await _database!.update(_tag, tagModel.toJson(), where: 'id = ?', whereArgs: [tagModel.id]);
  }

  Future<int> deleteTags(int tagModel) async {
    log('delete(table) Tag $tagModel');
    return await _database!.delete(_tag, where: 'id = ?', whereArgs: [tagModel]);
  }

  // reciters
  Future<int> insertReciters(ReciterModel reciterModel) async {
    log('insert Reciter ${reciterModel.id}');
    int value;
    try {
      value = await _database!.insert(_recitersTable, reciterModel.toJson());
    } catch (e) {
      log('Error Inserting $e}');
      value = await updateReciters(reciterModel);
    }
    return value;
  }

  Future<int> updateReciters(ReciterModel reciterModel) async {
    log('Update Reciter ${reciterModel.id}');
    return await _database!
        .update(_recitersTable, reciterModel.toJson(), where: 'id = ?', whereArgs: [reciterModel.id]);
  }

  Future<int> deleteReciters(int reciterModel) async {
    log('delete Reciter $reciterModel');
    return await _database!.delete(_recitersTable, where: 'id = ?', whereArgs: [reciterModel]);
  }

  // languages
  Future<int> insertLanguages(LanguageModel languageModel) async {
    log('insert Languages ${languageModel.dbLangId}');
    // return await _database!.update(_articles, languageModel.toJson(),
    //     where: 'id = ?', whereArgs: [languageModel.id]);
    return 0;
  }

  Future<int> updateLanguages(LanguageModel languageModel) async {
    log('Update Languages ${languageModel.dbLangId}');
    // return await _database!.update(_articles, languageModel.toJson(),
    //     where: 'id = ?', whereArgs: [languageModel.id]);
    return 0;
  }

  Future<int> deleteLanguages(int languageModel) async {
    log('Delete Languages $languageModel');
    // return await _database!.update(_articles, languageModel.toJson(),
    //     where: 'id = ?', whereArgs: [languageModel.id]);
    return 0;
  }

  // video Categories
  Future<int> insertVideoCats(VideoCategory videoCats) async {
    // log('insert Video ${videoModel.id}');
    log('insert Video Cat ');
    if (!await uidExists(videoCats.id!)) {
      await _database!.insert(_videoCats, videoCats.toJson());
    }

    return 0;
  }

  Future<bool> uidExists(String id) async {
    var result = await _database!.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $_videoCats WHERE id="$id")',
    );
    int exists = Sqflite.firstIntValue(result)!;
    return exists == 1;
  }

  Future<bool> ifExists(String table, String id) async {
    var result = await _database!.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $table WHERE id="$id")',
    );
    int exists = Sqflite.firstIntValue(result)!;
    return exists == 1;
  }

  Future<int> updateVideoCats(VideoCategory videoCats) async {
    return await _database!.update(_videoCats, videoCats.toJson(), where: 'id = ?', whereArgs: [videoCats.id]);
  }

  Future<int> deleteVideoCats(String videoModel) async {
    return await _database!.delete(_videoCats, where: 'id = ?', whereArgs: [videoModel]);
  }

  // videos
  Future<int> insertVideos(VideoModel videoModel) async {
    // log('insert Video ${videoModel.id}');
    return await _database!.insert(_videosTable, videoModel.toJson());
  }

  Future<int> updateVideos(VideoModel videoModel) async {
    log('Update Video ${videoModel.id}');
    return await _database!.update(_videosTable, videoModel.toJson(), where: 'id = ?', whereArgs: [videoModel.id]);
  }

  Future<int> deleteVideos(int videoModel) async {
    log('delete Video $videoModel');
    return await _database!.delete(_videosTable, where: 'id = ?', whereArgs: [videoModel]);
  }

  // relatedArticles
  Future<int> insertRelatedArticles(RelatedArticlesModel relatedArticlesModel) async {
    log('insert RelatedArticlesModel ${relatedArticlesModel.id}');
    return await _database!.insert(
      'related_articles',
      relatedArticlesModel.toJson(),
    );
  }

  Future<int> updateRelatedArticles(RelatedArticlesModel relatedArticlesModel) async {
    log('Update RelatedArticlesModel ${relatedArticlesModel.id}');
    return await _database!.update('related_articles', relatedArticlesModel.toJson(),
        where: 'id = ?', whereArgs: [relatedArticlesModel.id]);
  }

  Future<int> deleteRelatedArticles(int relatedArticlesModel) async {
    log('delete RelatedArticlesModel $relatedArticlesModel');
    return await _database!.delete('related_articles', where: 'id = ?', whereArgs: [relatedArticlesModel]);
  }

  // tagWords
  Future<int> insertTagWords(TagWordModel tagModel) async {
    log('insert updateTagWords ${tagModel.id}');
    return await _database!.insert('tag_word', tagModel.toJson());
  }

  Future<int> updateTagWords(TagWordModel tagModel) async {
    log('Update updateTagWords ${tagModel.id}');
    return await _database!.update('tag_word', tagModel.toJson(), where: 'id = ?', whereArgs: [tagModel.id]);
  }

  Future<int> deleteTagWords(int tagModel) async {
    log('delete updateTagWords $tagModel');
    return await _database!.delete('tag_word', where: 'id = ?', whereArgs: [tagModel]);
  }

  Future<TagWordModel?> getTagWord(int? wordId) async {
    // Future<void> getTagWord([int? wordId]) async {
    // const t = 'syncManger';
    try {
      // pr('getTagWord is called', t);
      var data = await _database!.query("tag_word  ", where: "word_id = $wordId");
      // pr(data, t);
      if (data.isNotEmpty) {
        return data.map<TagWordModel>((json) => TagWordModel.fromJsonSimplified(json)).toList().first;
      } else {
        return null;
      }
    } on Exception catch (e) {
      // pr('error occured : $e', t);
      return null;
    }
  }

  // relatedTags
  Future<int> insertRelatedTags(RelatedTagModel relatedTagModel) async {
    log('insert RelatedTags ${relatedTagModel.id}');
    return await _database!.insert('related_tag', relatedTagModel.toJson());
  }

  Future<int> updateRelatedTags(RelatedTagModel relatedTagModel) async {
    log('Update RelatedTags ${relatedTagModel.id}');
    return await _database!
        .update('related_tag', relatedTagModel.toJson(), where: 'id = ?', whereArgs: [relatedTagModel.id]);
  }

  Future<int> deleteRelatedTags(int relatedTagModel) async {
    log('delete RelatedTags $relatedTagModel');
    return await _database!.delete('related_tag', where: 'id = ?', whereArgs: [relatedTagModel]);
  }

  Future<String> pageAyatText() async {
    String ayat = '\n';
    var rawQuery = await _database!.rawQuery("select text from quran_text where sura = '2'");

    for (var x = 0; x < 8; x++) {
      ayat = '$ayat${rawQuery[x]['text']!}\n';
    }
    log('ayat text = $ayat');
    return ayat;
  }

  Future<String> videoUrlAya(int ayaId) async {
    String url = 'null';
    String query = 'SELECT url FROM videos WHERE ayat_id = $ayaId AND enabled = 1';
    var result = await _database!.rawQuery(query);
    if (result.isNotEmpty) {
      url = result[0]['url'].toString();
    }
    return url;
  }

  Future<String> videoUrlWord(int wordId) async {
    String url = 'null';
    String query = 'SELECT url FROM videos WHERE word_id = $wordId AND enabled = 1';
    var result = await _database!.rawQuery(query);
    log('Vudei Yrk = $result \n query $query');
    if (result.isNotEmpty) {
      url = result[0]['url'].toString();
    }
    return url;
  }

// -====================================================================================- //

  Future<List<SuraSearchModel>> searchByWord(String key) async {
    bool isSimilarFound = false;
    SimilarWordModel? similarWordModel;
    for (SimilarWordModel model in SimilarWordData.equalsList) {
      if (key == model.firstWord || key == model.secondWord) {
        isSimilarFound = true;
        similarWordModel = model;
        break;
      }
    }

    List<SuraSearchModel> result = [];
    String query = '';
    if (isSimilarFound) {
      query = " SELECT COUNT(*) AS count, sura.id AS sura_id, sura.sura_ar,sura.sura_en "
          " FROM ayat JOIN sura ON sura.id = ayat.sura_id  "
          " WHERE ayat.simple LIKE '%${similarWordModel?.firstWord}%' OR ayat.simple LIKE '%${similarWordModel?.secondWord}%' "
          " GROUP BY sura.id";
      pr(query, 'DatabaseHelper - similar word is found and the query: ');
    } else {
      query =
          " SELECT COUNT(*) AS count, sura.id AS sura_id, sura.sura_ar,sura.sura_en FROM ayat JOIN sura ON sura.id = ayat.sura_id WHERE ayat.simple LIKE  '%$key%' "
          " GROUP BY sura.id";
      pr(query, 'DatabaseHelper - similar word is not found and the query: ');
    }

    // " SELECT count(*) as count, sura.id as sura_id, sura_ar, sura_en from ayat,sura where sura.id=ayat.sura_id and ayat.simple like  '%$key%' "
    //     " group by sura_id";

    var dbRaw = await _database!.rawQuery(query);
    if (dbRaw.isNotEmpty) {
      for (var x = 0; x < dbRaw.length; x++) {
        result.add(SuraSearchModel.fromJson(dbRaw[x]));
      }
    }
    return result;
  }

  Future<List<List<SuraSearchResultModel>>> getDetails(int suraId, String key) async {
    List<List<SuraSearchResultModel>> result = [];
    // String query = ""
    //     "SELECT ayat.text_ar, ayat.simple, sura.sura_ar, ayat.page"
    //     " from words,sura, ayat "
    //     " where sura.id=words.sura_id "
    //     " and sura.id=ayat.sura_id "
    //     " and sura.id= $suraId "
    //     " and ayat.simple like "
    //     " '%$key%' "
    //     " group by ayat.id ";
    bool isSimilarFound = false;
    SimilarWordModel? similarWordModel;
    for (SimilarWordModel model in SimilarWordData.equalsList) {
      if (key == model.firstWord || key == model.secondWord) {
        isSimilarFound = true;
        similarWordModel = model;
        break;
      }
    }

    String query = '';
    if (isSimilarFound) {
      query = " select words.code as word_ar, sura.sura_ar, words.simple, words.ayat_id , words.page , ayat.id as ayaId"
          " from words, ayat, sura"
          " on ayat.ayah=words.ayat_id "
          " and words.sura_id=ayat.sura_id "
          " and words.sura_id=$suraId "
          " and sura.id = $suraId"
          " and ( ayat.simple like '%${similarWordModel?.firstWord}%' OR ayat.simple like '%${similarWordModel?.secondWord}%')"
          " group by words.id";
      pr(query, 'DatabaseHelper - similar word is found and the query: ');
    } else {
      query = " select words.code as word_ar, sura.sura_ar, words.simple, words.ayat_id , words.page , ayat.id as ayaId"
          " from words, ayat, sura"
          " on ayat.ayah=words.ayat_id "
          " and words.sura_id=ayat.sura_id "
          " and words.sura_id=$suraId "
          " and sura.id = $suraId"
          " and ayat.simple "
          // " and ayat.text_ar "
          " 	like"
          " 	'%$key%'"
          " group by words.id";
      pr(query, 'DatabaseHelper - similar word is not found and the query: ');
    }

    log('details Result Query \n$query');

    List<Map<String, dynamic>> list = await _database!.rawQuery(query);
    var newMap = groupBy(list, (Map obj) => obj['ayat_id']);
    int linesCount = int.parse(list[list.length - 1]['ayat_id'].toString());

    for (var x = 0; x < linesCount; x++) {
      if (newMap[newMap.keys.first + x] != null) {
        var newMap2 = newMap[newMap.keys.first + x];
        List<SuraSearchResultModel> singleAya = [];

        for (var i = 0; i < newMap2!.length; i++) {
          var aya = SuraSearchResultModel();
          log('finalResult ${newMap2[i]}');
          aya.textAr = newMap2[i]['word_ar'];
          aya.searchKey = key;
          aya.page = newMap2[i]['page'];
          aya.simple = newMap2[i]['simple'] ?? " ";
          aya.suraAr = newMap2[i]['sura_ar'];
          aya.ayaId = newMap2[i]['ayaId'];
          log('finalResult Aya $x - $i ${aya.toJson()}}');

          singleAya.add(aya);
        }
        result.add(singleAya);
      }
    }

    // log('finalResulty ${result[0][0].toJson()}}');
    return result;
  }

  Future<String> getLastSyncDate() async {
    String lastData = '';
    String query = "SELECT value FROM saved_values WHERE key = 1";
    var list = await _database!.rawQuery(query);
    log('current Date db $list');
    lastData = list[0]['value'].toString();
    return lastData;
  }

  // Colors
  Future<int> getColor(String id) async {
    int colorIndex = 23;
    String mQuery = "SELECT * FROM colors where id ='$id'";
    List<Map<String, dynamic>> list = await _database!.rawQuery(mQuery);
    if (list.isNotEmpty) {
      colorIndex = list[0]['color_value'];
    }
    log('Coloras $id = $list Index => $colorIndex');
    return colorIndex;
  }

  void updateColor(String id, int colorValue) async {
    String mQuery = "Update colors set color_value = $colorValue where id = '$id'";
    var list = await _database!.rawQuery(mQuery);
    log('UpdateStatus $list $mQuery');
  }

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}
