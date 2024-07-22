import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../classes/via_cep_service.dart';
import '../repositories/via_cep_repository.dart';

class CepPage extends StatefulWidget {
  const CepPage({super.key});

  @override
  _CepPageState createState() => _CepPageState();
}

class _CepPageState extends State<CepPage> {
  final ViaCepService viaCepService = ViaCepService();
  final CepService cepService = CepService();
  final TextEditingController _cepController = TextEditingController();
  List<ParseObject> _ceps = [];

  @override
  void initState() {
    super.initState();
    _fetchAllCeps();
  }

  Future<void> _fetchAllCeps() async {
    final ceps = await cepService.fetchAllCeps();
    setState(() {
      _ceps = ceps;
    });
  }

  Future<void> _addCep(String cep) async {
    final cepData = await viaCepService.fetchCep(cep);
    if (cepData != null && cepData['cep'] != null) {
      final existingCep = await cepService.fetchCep(cepData['cep'] as String);
      if (existingCep == null) {
        await cepService.addCep({
          'cep': cepData['cep'] as String,
          'logradouro': cepData['logradouro'] as String,
          'bairro': cepData['bairro'] as String,
          'localidade': cepData['localidade'] as String,
          'uf': cepData['uf'] as String,
        });
        _fetchAllCeps();
      } else {
        // CEP já cadastrado
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 218, 226),
      appBar: AppBar(
        title: const Text('Cadastro de CEPs'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cepController,
                    decoration: const InputDecoration(
                      labelText: 'CEP',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.blueGrey),
                  onPressed: () {
                    _addCep(_cepController.text);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _ceps.length,
              itemBuilder: (context, index) {
                final cep = _ceps[index];
                return ListTile(
                  title: Text(cep.get<String>('cep') ?? ''),
                  subtitle: Text(
                      '${cep.get<String>('logradouro') ?? ''}, ${cep.get<String>('bairro') ?? ''}, ${cep.get<String>('localidade') ?? ''}, ${cep.get<String>('uf') ?? ''}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueGrey),
                        onPressed: () {
                          // Implementar edição
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.blueGrey),
                        onPressed: () {
                          cepService.deleteCep(cep);
                          _fetchAllCeps();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
