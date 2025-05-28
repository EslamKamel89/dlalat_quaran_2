class LanguageModel {
  LanguageModel(this.langName, this.langFlag, this.lagId, this.dbLangId,
      this.selected, this.langCode);

  late String langName, langFlag, langCode;
  late int lagId, dbLangId;
  late bool selected;

  @override
  String toString() {
    return langName;
  }
}
