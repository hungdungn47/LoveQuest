class Film {
  String name;
  String author;
  String actors;
  String type;
  String description;
  String filmUrl;
  String image;

  Film(
    this.name,
    this.author,
    this.actors,
    this.type,
    this.description,
    this.filmUrl,
    this.image,
  );

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      json['name'] ?? '',
      json['author'] ?? '',
      json['actors'] ?? '',
      json['type'] ?? '',
      json['description'] ?? '',
      json['filmUrl'] ?? '',
      json['image'] ?? '',
    );
  }
}
