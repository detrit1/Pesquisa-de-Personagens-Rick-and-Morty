class Character {
  final String name;
  final String origin;
  final String image;
  final String status;
  final String species;
  final String gender;
  final String location;
  final List<String> episode;
  final String created;


  Character({required this.name, required this.origin, required this.image, required this.status,
  required this.species, required this.gender, required this.location, required this.episode, required this.created,});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? 'Sem nome',

      // origin é um MAP → precisa pegar apenas o ["name"]
      origin: json['origin']?['name'] ?? 'Desconhecida',

      status: json['status'] ?? '',
      species: json['species'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',

      // location também é um MAP → precisa ["name"]
      location: json['location']?['name'] ?? 'Desconhecida',

      // episode é uma LISTA de Strings → nunca uma String
      episode: List<String>.from(json['episode'] ?? []),

      // created é String → ok
      created: json['created'] ?? '',
    );
  }
}