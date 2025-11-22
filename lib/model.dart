class Recipe {
  final int id;
  final String title;
  final String description;
  final int calories;

  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.calories,

    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      calories: json['calories'] as int,
      ingredients: (json['ingredients'] as List<dynamic>).cast<String>(),
      instructions: (json['instructions'] as List<dynamic>).cast<String>(),
    );
  }
}