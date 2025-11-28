
import 'package:flutter/material.dart';
import 'controller.dart';
import 'model.dart';
import 'details.dart';
import 'recipe_form_screen.dart';
import 'main.dart';


enum RecipeFilter { all, favorites }

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final RecipeController _controller = RecipeController();
  Future<List<Recipe>>? _recipesFuture;

  String _searchText = '';
  RecipeFilter _currentFilter = RecipeFilter.all;

  @override
  void initState() {
    super.initState();
    _recipesFuture = _controller.fetchRecipes();
  }

  void _refreshRecipes() {
    setState(() {
      _recipesFuture = _controller.fetchRecipes();
    });
  }

  void _toggleFavorite(int id) {
    _controller.toggleFavorite(id);
    _refreshRecipes();
  }

  void _navigateToAddRecipe() async {
    final newRecipe = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(
        builder: (context) => const RecipeFormScreen(recipe: null),
      ),
    );

    if (newRecipe != null) {
      _controller.addRecipe(newRecipe);
      _refreshRecipes();
    }
  }

  void _navigateToEditRecipe(Recipe recipe) async {
    final updatedRecipe = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeFormScreen(recipe: recipe),
      ),
    );

    if (updatedRecipe != null) {
      _controller.updateRecipe(updatedRecipe);
      _refreshRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {

    final isDarkMode = RecipeListApp.of(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Book'),
        centerTitle: true,
        actions: [

          Switch(
            value: isDarkMode,
            onChanged: (bool value) {

              RecipeListApp.of(context).toggleTheme(value ? ThemeMode.dark : ThemeMode.light);


              setState(() {});
            },
            activeColor: Colors.amber,
            inactiveThumbColor: Colors.blueGrey,
            inactiveTrackColor: Colors.blueGrey.shade200,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Find recipe (name or description)',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                fillColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: const Text('All recipes'),
                  selected: _currentFilter == RecipeFilter.all,
                  onSelected: (selected) {
                    setState(() {
                      _currentFilter = RecipeFilter.all;
                    });
                  },
                  selectedColor: Colors.teal.shade700,
                  backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                  labelStyle: TextStyle(
                    color: _currentFilter == RecipeFilter.all
                        ? Colors.white
                        : (isDarkMode ? Colors.white70 : Colors.black87),
                    fontWeight: FontWeight.w600,
                  ),
                  checkmarkColor: Colors.white,
                ),
                FilterChip(
                  label: const Text('My favorite'),
                  selected: _currentFilter == RecipeFilter.favorites,
                  onSelected: (selected) {
                    setState(() {
                      _currentFilter = RecipeFilter.favorites;
                    });
                  },
                  selectedColor: Colors.teal.shade700,
                  backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                  labelStyle: TextStyle(
                    color: _currentFilter == RecipeFilter.favorites
                        ? Colors.white
                        : (isDarkMode ? Colors.white70 : Colors.black87),
                    fontWeight: FontWeight.w600,
                  ),
                  checkmarkColor: Colors.white,
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Recipe>>(
              future: _recipesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.teal));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                List<Recipe> recipes = snapshot.data ?? [];


                if (_currentFilter == RecipeFilter.favorites) {
                  recipes = recipes.where((r) => r.isFavorite).toList();
                }


                if (_searchText.isNotEmpty) {
                  recipes = recipes.where((r) =>
                  r.title.toLowerCase().contains(_searchText.toLowerCase()) ||
                      r.description.toLowerCase().contains(_searchText.toLowerCase())
                  ).toList();
                }

                if (recipes.isEmpty) {
                  return const Center(
                    child: Text('No recipes found.', style: TextStyle(color: Colors.grey, fontSize: 18)),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade500,
                            child: Text(
                              (recipe.id ?? 0).toString(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            recipe.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '${recipe.description}\n${recipe.calories} Calories | ${recipe.prepTimeMinutes} Mins',
                            style: TextStyle(color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              IconButton(
                                icon: Icon(
                                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: recipe.isFavorite ? Colors.red : Colors.grey,
                                ),
                                onPressed: () => _toggleFavorite(recipe.id!),
                              ),

                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.teal),
                                onPressed: () => _navigateToEditRecipe(recipe),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(recipe: recipe),
                              ),
                            ).then((_) => _refreshRecipes());
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddRecipe,
        tooltip: 'Add New Recipe',
        child: const Icon(Icons.add),
      ),
    );
  }
}