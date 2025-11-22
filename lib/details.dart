import 'package:flutter/material.dart';
import 'model.dart'; // Recipe model টি ইম্পোর্ট করুন

class RecipeDetailScreen extends StatelessWidget {
  // Recipe অবজেক্টটি constructor এর মাধ্যমে গ্রহণ করা হচ্ছে
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Title and Calories Section ---
            Text(
              recipe.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 8),
            Text(
              recipe.description,
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),
            const Divider(height: 32, thickness: 2, color: Colors.tealAccent),

            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.redAccent, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Calories: ${recipe.calories}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // --- Ingredients Section (উপকরণ) ---
            const Text(
              '**উপকরণ (Ingredients)**',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            // উপকরণগুলো লিস্ট আকারে দেখানো হচ্ছে
            ...recipe.ingredients.map((item) => Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18, color: Colors.teal)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )).toList(),

            const SizedBox(height: 30),

            // --- Instructions Section (নির্দেশাবলী) ---
            const Text(
              '**নির্দেশাবলী (Instructions)**',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // নির্দেশাবলীগুলো ১, ২, ৩... আকারে দেখানো হচ্ছে
              children: recipe.instructions.asMap().entries.map((entry) {
                int index = entry.key;
                String step = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade500,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step,
                          style: const TextStyle(fontSize: 16, height: 1.4),
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