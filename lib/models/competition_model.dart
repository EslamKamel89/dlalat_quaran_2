class CompetitionModel {
  int? id;
  String? nameAr;
  String? nameEn;
  String? nameFr;
  String? nameSp;
  String? nameIt;
  int? active;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  CompetitionModel({
    this.id,
    this.nameAr,
    this.nameEn,
    this.nameFr,
    this.nameSp,
    this.nameIt,
    this.active,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'CompetitionModel(id: $id, nameAr: $nameAr, nameEn: $nameEn, nameFr: $nameFr, nameSp: $nameSp, active: $active, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt, nameIt: $nameIt)';
  }

  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json['id'] as int?,
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      nameFr: json['name_fr'] as String?,
      nameSp: json['name_sp'] as String?,
      nameIt: json['name_it'] as String?,
      active: json['active'] as int?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_ar': nameAr,
        'name_en': nameEn,
        'name_fr': nameFr,
        'name_sp': nameSp,
        'active': active,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'name_it': nameIt,
      };
}
