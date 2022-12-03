import 'package:flutter/material.dart';
import 'package:notes_application/sql/items.dart';

class CategoriesDropdown extends StatefulWidget {
  List<Category> categories;

  Function(Category) categoryCallback;

  CategoriesDropdown(
      this.categories,
      this.categoryCallback, {
        Key? key,
      }) : super(key: key);

  @override
  State<CategoriesDropdown> createState() => _CategoriesDropdownState();
}

class _CategoriesDropdownState extends State<CategoriesDropdown> {
  var selectedCategory;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Category>(
        value: selectedCategory,
        hint: const Text('Select Category'),
        isExpanded: true,
        items: widget.categories.map((categoryTable){
          return DropdownMenuItem(
            value: categoryTable,
            child: Text(categoryTable.category!),
          );
        }).toList(),
        onChanged: (Category? value){
          setState(() {
            widget.categoryCallback(value!);
            selectedCategory = value;
          });
        }
    );
  }
}
