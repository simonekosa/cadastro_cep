import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CepService {
  Future<ParseObject?> fetchCep(String cep) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Cep'))
      ..whereEqualTo('cep', cep);
    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results!.first as ParseObject;
    }
    return null;
  }

  Future<ParseObject> addCep(Map<String, dynamic> data) async {
    final cepObject = ParseObject('Cep')
      ..set('cep', data['cep'] as String)
      ..set('logradouro', data['logradouro'] as String)
      ..set('bairro', data['bairro'] as String)
      ..set('localidade', data['localidade'] as String)
      ..set('uf', data['uf'] as String);
    final response = await cepObject.save();

    if (response.success) {
      return response.result as ParseObject;
    } else {
      throw Exception('Failed to add CEP');
    }
  }

  Future<List<ParseObject>> fetchAllCeps() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Cep'));
    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> deleteCep(ParseObject cepObject) async {
    await cepObject.delete();
  }

  Future<void> updateCep(
      ParseObject cepObject, Map<String, dynamic> data) async {
    cepObject
      ..set('logradouro', data['logradouro'] as String)
      ..set('bairro', data['bairro'] as String)
      ..set('localidade', data['localidade'] as String)
      ..set('uf', data['uf'] as String);
    await cepObject.save();
  }
}
