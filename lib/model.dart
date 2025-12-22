

class IngredientItem {
  final String name;
  final double quantity;
  final String unit;

  IngredientItem({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'unit': unit,
  };
}


class Recipe {
  final int? id;
  final String title;
  final String description;
  final int calories;
  final int prepTimeMinutes;
  final List<IngredientItem> ingredients;
  final List<String> instructions;
  bool isFavorite;

  Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.calories,
    required this.prepTimeMinutes,
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final List<dynamic> ingredientsJson = json['ingredients'] ?? [];

    final List<IngredientItem> ingredientsList = ingredientsJson.map((item) {
      if (item is String) {
        return IngredientItem(name: item, quantity: 100.0, unit: 'grams');
      }
      return IngredientItem(
        name: item['name'] as String? ?? 'Unknown',
        quantity: (item['quantity'] as num?)?.toDouble() ?? 0.0,
        unit: item['unit'] as String? ?? 'grams',
      );
    }).toList();

    return Recipe(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      calories: json['calories'] as int? ?? 0,
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 0,
      ingredients: ingredientsList,
      instructions: (json['instructions'] as List<dynamic>).cast<String>(),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}