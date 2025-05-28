class PageAyatSuraModel {
  String _ayaId;

  PageAyatSuraModel(this._ayaId, this._suraId);

  String get ayaId => _ayaId;

  @override
  String toString() {
    return 'PageAyatSuraModel{_ayaId: $_ayaId, _suraId: $_suraId}';
  }

  set ayaId(String value) {
    _ayaId = value;
  }

  String _suraId;

  String get suraId => _suraId;

  set suraId(String value) {
    _suraId = value;
  }
}
