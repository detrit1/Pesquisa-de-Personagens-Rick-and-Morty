import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ricmort/pages/characters_page.dart';
import '../services/api_service.dart';
import '../model/character.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Character> characters = [];
  bool isLoading = false;
  String query = "";
  String selectedGender = ""; // NOVO: Controlador do gênero selecionado

  // NOVO: Lista de gêneros disponíveis
  final List<String> genders = [
    "",
    "Female",
    "Male", 
    "Genderless",
    "unknown"
  ];

  @override
  void initState() {
    super.initState();
    search("", "");
  }

  // ATUALIZADO: Método search agora aceita gênero
  void search(String value, String gender) async {
    setState(() {
      query = value;
      selectedGender = gender;

      // Se ambos estão vazios → limpa a lista
      if (value.isEmpty && gender.isEmpty) {
        characters = [];
        isLoading = false;
        return;
      }

      isLoading = true;
    });

    final service = ApiService();
    List<Character> results = [];

    // LÓGICA DE BUSCA:
    if (gender.isNotEmpty && value.isNotEmpty) {
      // Busca por nome E gênero (a API suporta múltiplos filtros)
      final url = "https://rickandmortyapi.com/api/character/?name=$value&gender=$gender";
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final resultsList = jsonData['results'] as List;
          results = resultsList.map((e) => Character.fromJson(e)).toList();
        }
      } catch (e) {
        print("Erro na busca combinada: $e");
      }
    } else if (gender.isNotEmpty) {
      // Busca apenas por gênero
      results = await service.fetchCharactersByGender(gender);
    } else {
      // Busca apenas por nome (comportamento original)
      results = await service.fetchCharacters(value);
    }

    setState(() {
      characters = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F13),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 15, 19),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.greenAccent,
        ),
        title: const Text(
          "Buscar Personagens",
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 6,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CAMPO DE BUSCA POR NOME (mantido)
            TextField(
              onChanged: (value) => search(value, selectedGender),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Digite o nome do personagem...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.greenAccent),
                filled: true,
                fillColor: const Color(0xFF13171B),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.greenAccent.withOpacity(0.4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.greenAccent.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // NOVO: FILTRO POR GÊNERO
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF13171B),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.greenAccent.withOpacity(0.3),
                ),
              ),
              child: DropdownButton<String>(
                value: selectedGender,
                isExpanded: true,
                dropdownColor: const Color(0xFF13171B),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                underline: const SizedBox(), // Remove a linha inferior
                icon: const Icon(Icons.arrow_drop_down, color: Colors.greenAccent),
                items: [
                  DropdownMenuItem(
                    value: "",
                    child: Text(
                      "Todos os gêneros",
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                  ...genders.where((g) => g.isNotEmpty).map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(
                        _getGenderDisplayName(gender),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    search(query, newValue);
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(color: Colors.greenAccent),
              ),

            if (!isLoading && query.isEmpty && selectedGender.isEmpty && characters.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.search_rounded,
                      color: Colors.white70,
                      size: 70,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Digite um nome ou selecione um gênero",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

            if (!isLoading && (query.isNotEmpty || selectedGender.isNotEmpty) && characters.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.search_off_rounded,
                      color: Colors.white70,
                      size: 70,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Nenhum personagem encontrado",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final c = characters[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CharacterPage(character: c),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13171B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.greenAccent.withOpacity(0.3),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.15),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.greenAccent.withOpacity(0.6),
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(c.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${c.species} • ${c.gender}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 18, color: Colors.greenAccent),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // NOVO: Método para traduzir os gêneros
  String _getGenderDisplayName(String gender) {
    switch (gender) {
      case "Female": return "Feminino";
      case "Male": return "Masculino";
      case "Genderless": return "Sem Gênero";
      case "unknown": return "Desconhecido";
      default: return gender;
    }
  }
}