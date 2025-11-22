import 'dart:convert';
import 'model.dart';

const String _rawRecipeJson = r'''
[
  {
    "id": 1,
    "title": "Chicken Biryani",
    "description": "Aromatic basmati rice cooked with spiced chicken.",
    "calories": 550,
    "ingredients": [
      "Basmati Rice",
      "Chicken Pieces",
      "Yogurt",
      "Biryani Masala",
      "Onions",
      "Ghee"
    ],
    "instructions": [
      "Marinate chicken in yogurt and spices for 2 hours.",
      "Partially cook the basmati rice.",
      "Layer the rice and chicken mixture in a heavy-bottomed pot.",
      "Cook on low heat (dum) for 25 minutes.",
      "Serve hot with raita."
    ]
  },
  {
    "id": 2,
    "title": "Beef Curry",
    "description": "Slow-cooked beef in a rich curry gravy.",
    "calories": 620,
    "ingredients": [
      "Beef Cuts",
      "Onions",
      "Ginger-Garlic Paste",
      "Curry Powder",
      "Tomatoes",
      "Coconut Milk"
    ],
    "instructions": [
      "Sear the beef pieces until browned.",
      "Sauté onions, garlic, and ginger with curry powder.",
      "Add beef, tomatoes, and water.",
      "Simmer for 2 hours until beef is tender.",
      "Stir in coconut milk before serving."
    ]
  },
  {
    "id": 3,
    "title": "Vegetable Khichuri",
    "description": "Rice and lentils cooked with mixed vegetables.",
    "calories": 400,
    "ingredients": [
      "Rice",
      "Lentils (Moong/Masoor)",
      "Cauliflower",
      "Potatoes",
      "Peas",
      "Ghee",
      "Spices"
    ],
    "instructions": [
      "Wash and soak rice and lentils.",
      "Heat ghee and temper with whole spices.",
      "Add vegetables and sauté.",
      "Mix in rice and lentils, add water and salt.",
      "Pressure cook for 3 whistles or simmer until done."
    ]
  },
  {
    "id": 4,
    "title": "Pasta Alfredo",
    "description": "Creamy white sauce pasta with parmesan cheese.",
    "calories": 480,
    "ingredients": [
      "Fettuccine Pasta",
      "Butter",
      "Heavy Cream",
      "Parmesan Cheese",
      "Garlic",
      "Black Pepper"
    ],
    "instructions": [
      "Cook pasta according to package directions.",
      "Melt butter and sauté garlic.",
      "Pour in heavy cream and bring to a simmer.",
      "Remove from heat, then gradually whisk in Parmesan cheese.",
      "Toss the cooked pasta in the sauce and serve."
    ]
  },
  {
    "id": 5,
    "title": "Grilled Sandwich",
    "description": "Toasted sandwich filled with cheese and vegetables.",
    "calories": 310,
    "ingredients": [
      "Bread Slices",
      "Cheese",
      "Tomato",
      "Cucumber",
      "Onion",
      "Butter/Mayo"
    ],
    "instructions": [
      "Slice vegetables thinly.",
      "Butter one side of two bread slices.",
      "Place cheese and vegetables between the unbuttered sides.",
      "Grill the sandwich until golden brown and cheese is melted."
    ]
  },
  {
    "id": 6,
    "title": "Chicken Fry",
    "description": "Crispy deep-fried chicken with spices.",
    "calories": 530,
    "ingredients": [
      "Chicken Drumsticks",
      "Ginger-Garlic Paste",
      "Red Chili Powder",
      "Corn Flour",
      "Egg",
      "Oil for frying"
    ],
    "instructions": [
      "Marinate chicken with spices and flour mixture.",
      "Refrigerate for at least 30 minutes.",
      "Heat oil in a deep frying pan.",
      "Deep fry chicken pieces until golden brown and cooked through.",
      "Serve immediately with dipping sauce."
    ]
  },
  {
    "id": 7,
    "title": "Egg Curry",
    "description": "Boiled eggs cooked in masala gravy.",
    "calories": 450,
    "ingredients": [
      "Boiled Eggs",
      "Onion Paste",
      "Ginger-Garlic Paste",
      "Turmeric Powder",
      "Cumin Powder",
      "Garam Masala"
    ],
    "instructions": [
      "Peel and lightly fry the boiled eggs.",
      "Sauté onion and ginger-garlic paste until brown.",
      "Add spice powders and a little water to make a paste.",
      "Add water to create gravy and bring to a boil.",
      "Drop in the fried eggs and simmer for 5 minutes."
    ]
  },
  {
    "id": 8,
    "title": "Fruit Salad",
    "description": "Mixed seasonal fruits served chilled.",
    "calories": 250,
    "ingredients": [
      "Apples",
      "Bananas",
      "Grapes",
      "Oranges",
      "Strawberries",
      "A drizzle of Honey/Yogurt"
    ],
    "instructions": [
      "Wash and chop all fruits into bite-sized pieces.",
      "Mix all chopped fruits in a large bowl.",
      "Add a light drizzle of honey or a dollop of yogurt (optional).",
      "Chill in the refrigerator for 30 minutes before serving."
    ]
  },
  {
    "id": 9,
    "title": "Fried Rice",
    "description": "Rice fried with vegetables, egg, and soy sauce.",
    "calories": 500,
    "ingredients": [
      "Cooked Rice",
      "Carrots",
      "Peas",
      "Green Beans",
      "Egg",
      "Soy Sauce",
      "Sesame Oil"
    ],
    "instructions": [
      "Heat oil in a wok or large pan.",
      "Scramble the egg and set aside.",
      "Sauté vegetables until tender-crisp.",
      "Add cooked rice, soy sauce, and sesame oil.",
      "Stir-fry on high heat for 3-5 minutes.",
      "Mix in the scrambled egg and serve hot."
    ]
  },
  {
    "id": 10,
    "title": "Mango Lassi",
    "description": "Sweet yogurt drink blended with ripe mango.",
    "calories": 300,
    "ingredients": [
      "Ripe Mango (Pulp)",
      "Yogurt (Doi)",
      "Milk",
      "Sugar (to taste)",
      "Cardamom Powder (optional)",
      "Ice Cubes"
    ],
    "instructions": [
      "Peel and chop the ripe mango.",
      "Combine mango pulp, yogurt, milk, and sugar in a blender.",
      "Blend until smooth and creamy.",
      "Add ice cubes and blend for a few more seconds.",
      "Pour into glasses and garnish with a mint leaf."
    ]
  }
]
''';

class RecipeController {

  Future<List<Recipe>> fetchRecipes() async {
    try {

      final List<dynamic> jsonList = jsonDecode(_rawRecipeJson);

      final List<Recipe> recipes = jsonList
          .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
          .toList();

      await Future.delayed(const Duration(milliseconds: 500));

      return recipes;
    } catch (e) {
      print('Error parsing recipes: $e');
      throw Exception('Failed to load recipes: $e');
    }
  }
}