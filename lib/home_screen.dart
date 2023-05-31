import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Repository> _repositories = [];

  Future<void> _fetchRepositories(String searchTerm) async {
    String apiUrl = 'https://api.github.com/users/$searchTerm/repos';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      // Decodifica a resposta JSON para uma lista dinâmica
      List<dynamic> jsonList = json.decode(response.body);
      List<Repository> repositories = [];

      // Itera sobre a lista de itens JSON e cria objetos Repository a partir deles
      for (var item in jsonList) {
        repositories.add(Repository.fromJson(item));
      }

      // Atualiza o estado da lista de repositórios com os dados obtidos
      setState(() {
        _repositories = repositories;
      });
    } else {
      // Se ocorrer um erro na solicitação, você pode exibir uma mensagem de erro ou realizar outra ação adequada.
      log('Erro na solicitação: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Github Repos'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2830F0),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Digite um nome de usuário',
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                IconButton(
                  onPressed: () {
                    String searchTerm = _searchController.text;
                    _fetchRepositories(searchTerm);
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Color(0xFF2830F0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _repositories.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      _repositories[index].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_repositories[index].description ?? ''),
                        Text(
                          'Linguagem: ${_repositories[index].language ?? 'N/A'}',
                          style: const TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
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

class Repository {
  final int id;
  final String name;
  final String? description;
  final String? language;

  Repository({
    required this.id,
    required this.name,
    this.description,
    this.language,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      language: json['language'],
    );
  }
}
