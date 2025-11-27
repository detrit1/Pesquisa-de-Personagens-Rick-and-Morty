import 'package:flutter/material.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 15, 19),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.85,
              child: Image.asset(
                "assets/images/space.gif",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/images/portal.png',
                width: 280,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  "Rick and Morty",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 6,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 20),

                Text(
                  "Character Explorer",
                  style: TextStyle(
                    fontSize: 22,
                    color: Color.fromARGB(255, 0, 0, 0),
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.blueAccent,
                      )
                    ],
                  ),
                ),


                const SizedBox(height: 80),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchPage()),
                    );
                  },
                  child: const Text(
                    "Buscar Personagens",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
