class Country {
  final int id;
  final String code;
  final String nameEn;
  final String nameAr;

  Country({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameAr,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      code: json['code']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      nameAr: json['name_ar']?.toString() ?? '',
    );
  }
}
