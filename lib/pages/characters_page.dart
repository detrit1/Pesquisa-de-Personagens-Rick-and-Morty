import 'package:flutter/material.dart';
import '../model/character.dart';

class CharacterPage extends StatelessWidget {
  final Character character;

  const CharacterPage({super.key, required this.character});

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

        title: Text(
          character.name,
          style: const TextStyle(
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // 🔥 CENTRALIZADO
          children: [
            // Foto com neon
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.greenAccent.withOpacity(0.6),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  character.image,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Card centralizado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF13171B),
                borderRadius: BorderRadius.circular(22),
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

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // 🔥 CENTRALIZADO
                children: [
                  infoItem("Nome", character.name),
                  infoItem("Origem", character.origin),
                  infoItem("Localização atual", character.location),
                  infoItem("Espécie", character.species),
                  infoItem("Status", character.status),
                  infoItem("Gênero", character.gender),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget de item centralizado
  Widget infoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // 🔥 CENTRALIZADO
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 5,
                  color: Colors.greenAccent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
