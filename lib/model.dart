class Recipe {
  final int id;
  final String title;
  final String description;
  final int calories;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.calories,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      calories: json['calories'] as int,
    );
  }
}