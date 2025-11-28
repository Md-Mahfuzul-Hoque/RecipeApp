
import 'dart:convert';
import 'model.dart';


abstract class NutritionalData {
  static const Map<String, double> caloriePer100g = {
    'Basmati Rice': 350.0, 'Chicken Pieces': 165.0, 'Yogurt': 59.0, 'Biryani Masala': 100.0,
    'Onions': 40.0, 'Ghee': 883.0, 'Beef Cuts': 250.0, 'Curry Powder': 325.0, 'Tomatoes': 18.0,
    'Coconut Milk': 230.0, 'Lentils (Moong/Masoor)': 350.0, 'Cauliflower': 25.0, 'Potatoes': 77.0,
    'Peas': 81.0, 'Fettuccine Pasta': 371.0, 'Butter': 717.0, 'Heavy Cream': 340.0,
    'Parmesan Cheese': 431.0, 'Bread Slices': 266.0, 'Cheese': 402.0, 'Tomato': 18.0,
    'Cucumber': 15.0, 'Egg': 155.0, 'Mango (Pulp)': 60.0, 'Milk': 42.0, 'Sugar': 387.0,
    'Ginger-Garlic Paste': 150.0, 'Red Chili Powder': 318.0, 'Corn Flour': 381.0,
    'Oil for frying': 900.0, 'Turmeric Powder': 354.0, 'Cumin Powder': 375.0, 'Garam Masala': 364.0,
    'Apples': 52.0, 'Bananas': 89.0, 'Grapes': 69.0, 'Oranges': 47.0, 'Strawberries': 33.0,
    'Honey/Yogurt': 200.0, 'Carrots': 41.0, 'Green Beans': 31.0, 'Soy Sauce': 53.0, 'Sesame Oil': 884.0,
  };
}

const String _rawRecipeJson = '''
[
  {"id": 1, "title": "Chicken Biryani", "description": "Aromatic basmati rice cooked with spiced chicken.", "calories": 0, "isFavorite": false, "prepTimeMinutes": 60, "ingredients": [{"name": "Basmati Rice", "quantity": 300, "unit": "grams"}, {"name": "Chicken Pieces", "quantity": 400, "unit": "grams"}, {"name": "Yogurt", "quantity": 150, "unit": "grams"}, {"name": "Biryani Masala", "quantity": 50, "unit": "grams"}, {"name": "Onions", "quantity": 100, "unit": "grams"}, {"name": "Ghee", "quantity": 30, "unit": "grams"}], "instructions": ["Marinate chicken...", "Partially cook rice...", "Layer and cook.", "Serve hot."]},
  {"id": 2, "title": "Beef Curry", "description": "Slow-cooked beef in a rich curry gravy.", "calories": 0, "isFavorite": false, "prepTimeMinutes": 120, "ingredients": [{"name": "Beef Cuts", "quantity": 500, "unit": "grams"}, {"name": "Onions", "quantity": 100, "unit": "grams"}, {"name": "Ginger-Garlic Paste", "quantity": 20, "unit": "grams"}, {"name": "Curry Powder", "quantity": 15, "unit": "grams"}, {"name": "Tomatoes", "quantity": 80, "unit": "grams"}, {"name": "Coconut Milk", "quantity": 200, "unit": "ml"}], "instructions": ["Sear the beef.", "Sauté spices.", "Simmer for 2 hours.", "Stir in coconut milk."]},
  {"id": 3, "title": "Vegetable Khichuri", "description": "Rice and lentils cooked with mixed vegetables.", "calories": 0, "isFavorite": false, "prepTimeMinutes": 45, "ingredients": [{"name": "Rice", "quantity": 150, "unit": "grams"}, {"name": "Lentils (Moong/Masoor)", "quantity": 100, "unit": "grams"}, {"name": "Cauliflower", "quantity": 100, "unit": "grams"}, {"name": "Potatoes", "quantity": 50, "unit": "grams"}, {"name": "Peas", "quantity": 50, "unit": "grams"}, {"name": "Ghee", "quantity": 20, "unit": "grams"}], "instructions": ["Wash and soak rice and lentils.", "Heat ghee and temper with whole spices.", "Add vegetables and sauté.", "Mix in rice and lentils, add water and salt.", "Pressure cook for 3 whistles or simmer until done."]},
  {"id": 4, "title": "Pasta Alfredo", "description": "Creamy white sauce pasta with parmesan cheese.", "calories": 0, "isFavorite": false, "prepTimeMinutes": 30, "ingredients": [{"name": "Fettuccine Pasta", "quantity": 150, "unit": "grams"}, {"name": "Butter", "quantity": 40, "unit": "grams"}, {"name": "Heavy Cream", "quantity": 80, "unit": "ml"}, {"name": "Parmesan Cheese", "quantity": 30, "unit": "grams"}], "instructions": ["Cook pasta.", "Melt butter and sauté garlic.", "Pour in heavy cream and simmer.", "Whisk in Parmesan cheese.", "Toss the cooked pasta in the sauce and serve."]},
  {"id": 5, "title": "Grilled Sandwich", "description": "Toasted sandwich filled with cheese and vegetables.", "calories": 0, "isFavorite": false, "prepTimeMinutes": 15, "ingredients": [{"name": "Bread Slices", "quantity": 100, "unit": "grams"}, {"name": "Cheese", "quantity": 50, "unit": "grams"}, {"name": "Tomato", "quantity": 30, "unit": "grams"}, {"name": "Cucumber", "quantity": 20, "unit": "grams"}, {"name": "Onion", "quantity": 10, "unit": "grams"}, {"name": "Butter", "quantity": 15, "unit": "grams"}], "instructions": ["Slice vegetables thinly.", "Butter one side of two bread slices.", "Place cheese and vegetables between the unbuttered sides.", "Grill the sandwich until golden brown and cheese is melted."]},
  {"id": 6, "title": "Chicken Fry", "description": "Crispy deep-fried chicken with spices.", "calories": 0, "isFavorite": false, "prepTimeMinutes": 40, "ingredients": [{"name": "Chicken Pieces", "quantity": 300, "unit": "grams"}, {"name": "Ginger-Garlic Paste", "quantity": 15, "unit": "grams"}, {"name": "Red Chili Powder", "quantity": 5, "unit": "grams"}, {"name": "Corn Flour", "quantity": 20, "unit": "grams"}, {"name": "Egg", "quantity": 50, "unit": "grams"}, {"name": "Oil for frying", "quantity": 100, "unit": "ml"}], "instructions": ["Marinate chicken...", "Refrigerate...", "Heat oil...", "Deep fry...", "Serve immediately..."]},
  {"id": 7, "title": "Egg Curry", "description": "Boiled eggs cooked in masala gravy.", "calories": 0, "isFavorite": false, "prepTimeMinutes": 35, "ingredients": [{"name": "Egg", "quantity": 150, "unit": "grams"}, {"name": "Onions", "quantity": 50, "unit": "grams"}, {"name": "Ginger-Garlic Paste", "quantity": 10, "unit": "grams"}, {"name": "Turmeric Powder", "quantity": 5, "unit": "grams"}, {"name": "Cumin Powder", "quantity": 5, "unit": "grams"}, {"name": "Garam Masala", "quantity": 5, "unit": "grams"}], "instructions": ["Peel and lightly fry the boiled eggs.", "Sauté onion and ginger-garlic paste...", "Add spice powders...", "Add water to create gravy...", "Drop in the fried eggs and simmer."]},
  {"id": 8, "title": "Fruit Salad", "description": "Mixed seasonal fruits served chilled.", "calories": 0, "isFavorite": false, "prepTimeMinutes": 10, "ingredients": [{"name": "Apples", "quantity": 100, "unit": "grams"}, {"name": "Bananas", "quantity": 100, "unit": "grams"}, {"name": "Grapes", "quantity": 50, "unit": "grams"}, {"name": "Oranges", "quantity": 100, "unit": "grams"}, {"name": "Strawberries", "quantity": 50, "unit": "grams"}, {"name": "Honey/Yogurt", "quantity": 30, "unit": "grams"}], "instructions": ["Wash and chop all fruits...", "Mix all chopped fruits...", "Add a light drizzle of honey...", "Chill in the refrigerator..."]},
  {"id": 9, "title": "Fried Rice", "description": "Rice fried with vegetables, egg, and soy sauce.", "calories": 0, "isFavorite": false, "prepTimeMinutes": 35, "ingredients": [{"name": "Basmati Rice", "quantity": 200, "unit": "grams"}, {"name": "Carrots", "quantity": 50, "unit": "grams"}, {"name": "Peas", "quantity": 30, "unit": "grams"}, {"name": "Green Beans", "quantity": 30, "unit": "grams"}, {"name": "Egg", "quantity": 50, "unit": "grams"}, {"name": "Soy Sauce", "quantity": 20, "unit": "ml"}, {"name": "Sesame Oil", "quantity": 10, "unit": "ml"}], "instructions": ["Heat oil in a wok...", "Scramble the egg...", "Sauté vegetables...", "Add cooked rice...", "Stir-fry...", "Mix in the scrambled egg and serve hot."]},
  {"id": 10, "title": "Mango Lassi", "description": "Sweet yogurt drink blended with ripe mango.", "calories": 0, "isFavorite": false, "prepTimeMinutes": 15, "ingredients": [{"name": "Mango (Pulp)", "quantity": 150, "unit": "grams"}, {"name": "Yogurt", "quantity": 100, "unit": "grams"}, {"name": "Milk", "quantity": 50, "unit": "ml"}, {"name": "Sugar", "quantity": 20, "unit": "grams"}], "instructions": ["Peel and chop the ripe mango.", "Combine mango pulp, yogurt, milk, and sugar...", "Blend until smooth...", "Add ice cubes...", "Pour into glasses..."]}
]
''';

class RecipeController {
  final List<Recipe> _recipes = [];

  RecipeController() {
    try {
      final List<dynamic> jsonList = jsonDecode(_rawRecipeJson);
      final initialRecipes = jsonList
          .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
          .toList();

      for (var recipe in initialRecipes) {
        final calculatedCalories = calculateTotalCalories(recipe);
        _recipes.add(Recipe(
          id: recipe.id,
          title: recipe.title,
          description: recipe.description,
          calories: calculatedCalories,
          prepTimeMinutes: recipe.prepTimeMinutes,
          ingredients: recipe.ingredients,
          instructions: recipe.instructions,
          isFavorite: recipe.isFavorite,
        ));
      }
    } catch (e) {
      print('Error parsing initial recipes: $e');
    }
  }

  int calculateTotalCalories(Recipe recipe) {
    double totalCalories = 0.0;
    for (var item in recipe.ingredients) {
      final ingredientName = item.name.trim();
      final quantity = item.quantity;
      final caloriesPer100 = NutritionalData.caloriePer100g[ingredientName];
      if (caloriesPer100 != null && quantity > 0) {
        totalCalories += (quantity / 100) * caloriesPer100;
      }
    }
    return totalCalories.round();
  }

  void toggleFavorite(int id) {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index != -1) {
      final currentRecipe = _recipes[index];
      _recipes[index] = Recipe(
        id: currentRecipe.id,
        title: currentRecipe.title,
        description: currentRecipe.description,
        calories: currentRecipe.calories,
        prepTimeMinutes: currentRecipe.prepTimeMinutes,
        ingredients: currentRecipe.ingredients,
        instructions: currentRecipe.instructions,
        isFavorite: !currentRecipe.isFavorite,
      );
    }
  }

  Future<List<Recipe>> fetchRecipes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_recipes);
  }

  void addRecipe(Recipe newRecipe) {
    final nextId = _recipes.isEmpty ? 1 : (_recipes.last.id ?? 0) + 1;
    final calculatedCalories = calculateTotalCalories(newRecipe);

    final recipeWithId = Recipe(
      id: nextId,
      title: newRecipe.title,
      description: newRecipe.description,
      calories: calculatedCalories,
      prepTimeMinutes: newRecipe.prepTimeMinutes,
      ingredients: newRecipe.ingredients,
      instructions: newRecipe.instructions,
      isFavorite: newRecipe.isFavorite,
    );
    _recipes.add(recipeWithId);
  }

  void updateRecipe(Recipe updatedRecipe) {
    if (updatedRecipe.id == null) return;

    final index = _recipes.indexWhere((r) => r.id == updatedRecipe.id);
    if (index != -1) {
      final calculatedCalories = calculateTotalCalories(updatedRecipe);

      final finalUpdatedRecipe = Recipe(
        id: updatedRecipe.id,
        title: updatedRecipe.title,
        description: updatedRecipe.description,
        calories: calculatedCalories,
        prepTimeMinutes: updatedRecipe.prepTimeMinutes,
        ingredients: updatedRecipe.ingredients,
        instructions: updatedRecipe.instructions,
        isFavorite: updatedRecipe.isFavorite,
      );
      _recipes[index] = finalUpdatedRecipe;
    }
  }

  void deleteRecipe(int id) {
    _recipes.removeWhere((r) => r.id == id);
  }
}