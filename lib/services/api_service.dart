import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/character.dart';

class ApiService {
  Future<List<Character>> fetchCharacters(String query) async {
  try {
    final url = Uri.parse("https://rickandmortyapi.com/api/character/?name=$query");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final results = jsonData['results'] as List;

      return results.map((e) => Character.fromJson(e)).toList();
    } else {
      print("API retornou erro: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Erro ao buscar personagens: $e");
    return [];
  }
}

}
