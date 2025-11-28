
import 'package:flutter/material.dart';
import 'model.dart';
import 'controller.dart';
import 'dart:async';
import 'main.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final RecipeController _controller = RecipeController();
  late Recipe _currentRecipe;
  late Set<int> _completedSteps;
  Timer? _timer;
  int _remainingTime = 0;
  bool _isRunning = false;


  @override
  void initState() {
    super.initState();
    _currentRecipe = widget.recipe;
    _completedSteps = <int>{};
    _remainingTime = _currentRecipe.prepTimeMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleFavorite() {
    _controller.toggleFavorite(_currentRecipe.id!);

    setState(() {
      _currentRecipe = Recipe(
        id: _currentRecipe.id,
        title: _currentRecipe.title,
        description: _currentRecipe.description,
        calories: _currentRecipe.calories,
        prepTimeMinutes: _currentRecipe.prepTimeMinutes,
        ingredients: _currentRecipe.ingredients,
        instructions: _currentRecipe.instructions,
        isFavorite: !_currentRecipe.isFavorite,
      );
    });
  }

  void _toggleTimer() {
    if (_remainingTime <= 0) {
      _remainingTime = _currentRecipe.prepTimeMinutes * 60;
    }

    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          setState(() {
            _remainingTime--;
          });
        } else {
          _timer?.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cooking Time is Up!'), duration: Duration(seconds: 3)),
          );
          setState(() {
            _isRunning = false;
          });
        }
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = RecipeListApp.of(context).isDarkMode;
    final primaryColor = isDarkMode ? Colors.teal.shade300 : Colors.teal;
    final secondaryTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700;

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentRecipe.title),
        actions: [
          IconButton(
            icon: Icon(
              _currentRecipe.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _currentRecipe.isFavorite ? Colors.redAccent : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _currentRecipe.title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              _currentRecipe.description,
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: secondaryTextColor),
            ),
            const Divider(height: 32, thickness: 2, color: Colors.tealAccent),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.redAccent, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Calories: ${_currentRecipe.calories}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),


                if (_currentRecipe.prepTimeMinutes > 0)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          _formatDuration(_remainingTime),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                        const SizedBox(width: 8),

                        InkWell(
                          onTap: _toggleTimer,
                          child: Icon(
                            _isRunning ? Icons.pause_circle_filled : Icons.play_circle_filled,
                            color: _isRunning ? Colors.red : Colors.green,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
            const SizedBox(height: 30),

            const Text(
              '**Ingredients**',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            ..._currentRecipe.ingredients.map((item) => Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18, color: Colors.teal)),
                  Expanded(
                    child: Text(
                      '${item.name} (${item.quantity} ${item.unit})',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )).toList(),

            const SizedBox(height: 30),
            const Text(
              '**Instructions - Track Steps**',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _currentRecipe.instructions.asMap().entries.map((entry) {
                int index = entry.key;
                String step = entry.value;
                bool isCompleted = _completedSteps.contains(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Checkbox(
                        value: isCompleted,
                        onChanged: (bool? newValue) {
                          setState(() {
                            if (newValue == true) {
                              _completedSteps.add(index);
                            } else {
                              _completedSteps.remove(index);
                            }
                          });
                        },
                        activeColor: Colors.teal,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${index + 1}. $step',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.4,
                              decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                              color: isCompleted ? Colors.grey : (isDarkMode ? Colors.white : Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}