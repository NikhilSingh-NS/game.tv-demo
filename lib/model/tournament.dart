class Tournament {
  Tournament.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gameName = json['game_name'];
    coverUrl = json['cover_url'];
  }

  String name;
  String gameName;
  String coverUrl;

  Map<String, dynamic> toMap() {
    return {'name': name, 'game_name': gameName, 'cover_url': coverUrl};
  }
}
