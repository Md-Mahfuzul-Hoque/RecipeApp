
import 'package:flutter/material.dart';
import 'model.dart';

class RecipeFormScreen extends StatefulWidget {
  final Recipe? recipe;

  const RecipeFormScreen({super.key, this.recipe});

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _instructionsController;
  late TextEditingController _prepTimeController;

  late List<IngredientItem> _ingredientItems;

  @override
  void initState() {
    super.initState();
    final recipe = widget.recipe;

    _titleController = TextEditingController(text: recipe?.title ?? '');
    _descriptionController = TextEditingController(text: recipe?.description ?? '');
    _instructionsController = TextEditingController(text: recipe?.instructions.join('\n') ?? '');
    _prepTimeController = TextEditingController(text: recipe?.prepTimeMinutes.toString() ?? '0');

    _ingredientItems = List.from(recipe?.ingredients ?? [
      IngredientItem(name: '', quantity: 0.0, unit: 'grams')
    ]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    _prepTimeController.dispose();
    super.dispose();
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      final validIngredients = _ingredientItems.where((item) => item.name.trim().isNotEmpty && item.quantity > 0).toList();
      final instructionsList = _instructionsController.text.split('\n').where((s) => s.trim().isNotEmpty).toList();

      final savedRecipe = Recipe(
        id: widget.recipe?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        calories: 0,
        prepTimeMinutes: int.tryParse(_prepTimeController.text.trim()) ?? 0,
        ingredients: validIngredients,
        instructions: instructionsList,
        isFavorite: widget.recipe?.isFavorite ?? false,
      );

      Navigator.pop(context, savedRecipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Add New Recipe' : 'Edit Recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextField(_titleController, 'Title', 'Recipe title is required'),
              _buildTextField(_descriptionController, 'Description', 'Description is required', maxLines: 3),
              _buildTextField(_prepTimeController, 'Preparation Time (in minutes)', 'Time is required', keyboardType: TextInputType.number),

              const SizedBox(height: 20),
              const Text('Ingredients - Enter quantity for each:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
              const SizedBox(height: 10),

              ..._ingredientItems.asMap().entries.map((entry) {
                int index = entry.key;
                IngredientItem item = entry.value;
                return IngredientItemRow(
                  key: ValueKey(item.hashCode),
                  initialItem: item,
                  onChanged: (updatedItem) {
                    _ingredientItems[index] = updatedItem;
                  },
                  onDelete: () {
                    setState(() {
                      _ingredientItems.removeAt(index);
                    });
                  },
                );
              }).toList(),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _ingredientItems.add(IngredientItem(name: '', quantity: 0.0, unit: 'grams'));
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                  label: const Text('Add Ingredient', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 30),
              const Text('Instructions - Write each step on a new line:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
              _buildTextField(_instructionsController, 'Instructions', 'Instructions are required', maxLines: null),

              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _saveRecipe,
                icon: const Icon(Icons.save),
                label: Text(widget.recipe == null ? 'Save (Calories will be calculated)' : 'Update (Calories will be calculated)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String validationMessage, {TextInputType keyboardType = TextInputType.text, int? maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          if (keyboardType == TextInputType.number && int.tryParse(value) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}


class IngredientItemRow extends StatefulWidget {
  final IngredientItem initialItem;
  final ValueChanged<IngredientItem> onChanged;
  final VoidCallback onDelete;

  const IngredientItemRow({
    super.key,
    required this.initialItem,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<IngredientItemRow> createState() => _IngredientItemRowState();
}

class _IngredientItemRowState extends State<IngredientItemRow> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late String _selectedUnit;

  static const List<String> units = ['grams', 'ml', 'tsp', 'tbsp', 'cup', 'piece'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialItem.name);
    _quantityController = TextEditingController(text: widget.initialItem.quantity.toString());
    _selectedUnit = widget.initialItem.unit;

    _nameController.addListener(_updateItem);
    _quantityController.addListener(_updateItem);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _updateItem() {
    final quantity = double.tryParse(_quantityController.text) ?? 0.0;
    widget.onChanged(IngredientItem(
      name: _nameController.text.trim(),
      quantity: quantity,
      unit: _selectedUnit,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ingredient (Name)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? 'Enter name' : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) return 'Enter quantity';
                if (double.tryParse(value) == null) return 'Enter number';
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              value: _selectedUnit,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              ),
              items: units.map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUnit = newValue!;
                  _updateItem();
                });
              },
              validator: (value) => value == null ? 'Select unit' : null,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}