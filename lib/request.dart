//? articles
//! Get Request
// ignore_for_file: unused_element

const _articleEndpoint = "{{baseUrl}}/articles";
const _articlesResponse = [
  {
    "id": "some_data",
    "lang_id": "some_data",
    "name": "some_data",
    "author": "some_data",
    "description": "some_data",
    "created_by": "some_data",
    "enabled": "some_data",
    "created_at": "some_data",
    "updated_at": "some_data",
  },
  {"......."},
];

//? related articles
//! Get Request
const _relatedArticlesEndpoint = "{{baseUrl}}/related-articles?article-id=5";
const _relatedArticlesResponse = [
  {
    "id": "some_data",
    "lang_id": "some_data",
    "name": "some_data",
    "author": "some_data",
    "description": "some_data",
    "created_by": "some_data",
    "enabled": "some_data",
    "created_at": "some_data",
    "updated_at": "some_data",
  },
  {"......."},
];

//? get All Tags
// enum type { difference, meaning, equal }

const _tagsIndexEndpoint = "{{baseUrl}}/tags?type=difference";
const _tagsIndexResonse = [
  {
    "name_ar": "some_data",
    "name_en": "some_data",
    "name_fr": "some_data",
    "name_sp": "some_data",
    "name_it": "some_data",
    "desc_ar": "some_data",
    "desc_it": "some_data",
    "desc_en": "some_data",
    "desc_sp": "some_data",
    "desc_fr": "some_data",
    "created_by": "some_data",
    "enabled": "some_data",
    "created_at": "some_data",
    "updated_at": "some_data",
  },
  {"......."},
];

//? get related tags
const _relatedTagsEndpoint = "{{baseUrl}}/related-tags?tag_id=5";
const _relatedTagsResonse = [
  {
    "name_ar": "some_data",
    "name_en": "some_data",
    "name_fr": "some_data",
    "name_sp": "some_data",
    "name_it": "some_data",
    "desc_ar": "some_data",
    "desc_it": "some_data",
    "desc_en": "some_data",
    "desc_sp": "some_data",
    "desc_fr": "some_data",
    "created_by": "some_data",
    "enabled": "some_data",
    "created_at": "some_data",
    "updated_at": "some_data",
  },
  {"......."},
];

//? getTagVideoss
const _tagVideoEndpoint = "{{baseUrl}}/tag-video?tag-id=5";
const _tagVideoResponse = [
  {
    "id": "some_data",
    "url": "some_data",
    "name": "some_data",
    "type": "some_data",
    "word_id": "some_data",
    "created_at": "some_data",
    "updated_at": "some_data",
  },
  {"......."},
];

//? tagWord
const _tagWordRequest = [
  21613,
  21614,
  21615,
  21616,
  21617,
  21618,
  21619,
  21620,
  21621,
];
const _tagWordResponse = {
  21614: [
    10,
    [50, 70, 100]
  ], // [red , green , blue]
  21617: [
    15,
    [50, 70, 100]
  ],
  21619: [
    30,
    [50, 70, 100]
  ],
};

//? series articles
//* create series table which have one to many relationship with the articles table
//! Get Request
const _articleSericeEndpoint = "{{baseUrl}}/article-series/offset/limit/devicelocale";
const _articleSeriesResponse = [
  {
    'id': 'series id',
    'name': 'series name',
    'content': 'seires content or description',
    'articles': [
      {
        "id": "article id",
        "lang_id": "some_data",
        "name": "article name",
        "author": "some_data",
        "description": "some_data",
        "created_by": "some_data",
        "enabled": "some_data",
        "created_at": "some_data",
        "updated_at": "some_data",
      },
      {"......."},
    ],
  },
  {"......"}
];

//? series videos
//! Get Request
const _videoSericeEndpoint = "{{baseUrl}}/video-series/devicelocale";
const _videoSeriesResponse = [
  {
    'id': 'series id',
    'name': 'series name',
    'content': 'seires content or description',
    'videos': [
      {
        "id": 'id',
        "url": 'url',
        "name": 'name',
        "type": 'type',
        "word_id": 'word_id',
        "ayat_id": 'ayat_id',
        "enabled": 'enabled',
        "created_at": 'created_at',
        "updated_at": 'updated_at',
      },
      {"......."},
    ],
  },
  {"......"}
];

//? videos
//! Get Request
const _videosEndpoint = "{{baseUrl}}/videos/deviceLocale";
const _videosResponse = [
  {
    "id": 'id',
    "url": 'url',
    "name": 'name',
    "type": 'type',
    "word_id": 'word_id',
    "ayat_id": 'ayat_id',
    "enabled": 'enabled',
    "created_at": 'created_at',
    "updated_at": 'updated_at',
  },
  {"......."},
];

//? search by key request
//! Get Request
const _searchByWordEndpoint = "{{baseUrl}}/search-word/{search-key}";
const _searchByWordResponse = [
  {
    'count': 'count',
    'sura_id': 'sura_id',
    'sura_ar': 'sura_ar',
    'sura_en': 'sura_en',
    'searchKey': 'searchKey',
    'aya-ids': [1, 2, 3, 4, 5, 6, 7, 8, 9],
  },
  {"......."},
];

//? search by key request
//! Get Request
const _searchByWordEndpoint2 = "{{baseUrl}}/search-word/{search-key}";
const _searchByWordResponse2 = [
  {
    'count': 'count',
    'sura_id': 'sura_id',
    'sura_ar': 'sura_ar',
    'sura_en': 'sura_en',
    'searchKey': 'searchKey',
    'aya-data': [
      {
        'text_ar': 'text_ar',
        'simple': 'simple',
        'sura_ar': 'sura_ar',
        'page': 'page',
        'searchKey': 'searchKey',
      },
      {"........"}
    ],
  },
  {"......."},
];

//? getSimilarWords
//! Get Request
const _similarWordsEndpoint = "{{baseUrl}}/similar-word";
const _similarWordsResponse = [
  {
    'firstWord': 'firstWord',
    'secondWord': 'secondWord',
  },
  {"......."},
];
