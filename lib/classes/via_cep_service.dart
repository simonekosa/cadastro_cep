import 'package:http/http.dart' as http;
import 'dart:convert';

class ViaCepService {
  Future<Map<String, dynamic>?> fetchCep(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
