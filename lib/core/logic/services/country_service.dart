import 'package:cosmetics/core/logic/models/country.dart';
import 'package:cosmetics/core/logic/network/dio_helper.dart';

class CountryService {
  static final CountryService _instance = CountryService._internal();
  factory CountryService() => _instance;
  CountryService._internal();

  List<Country> _countries = [];

  List<Country> get countries => _countries;

  Future<void> fetchCountries() async {
    if (_countries.isNotEmpty) return;
    try {
      final response = await DioHelper.get("/api/Countries");
      final data = response.data as List;
      _countries = data.map((e) => Country.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching countries: $e");
    }
  }
}
