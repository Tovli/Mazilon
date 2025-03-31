import 'package:shared_preferences/shared_preferences.dart';





Future<void> addStringToCategory(String categoryName, String newString) async {
  final prefs = await SharedPreferences.getInstance();
  
  // Get the existing map of categories and their strings
  Map<String, List<String>> categoryMap = getCategoriesMap(prefs);

  // If the category exists, add the string to the list
  if (categoryMap.containsKey(categoryName)) {
    categoryMap[categoryName]?.add(newString);

  }

  // Save the updated map back to SharedPreferences
  await prefs.setStringList('categoryMap', categoryMap.entries
      .map((entry) => '${entry.key}:${entry.value.join(",")}')
      .toList());
}

Future<void> printCategories() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Retrieve and print the current map of categories and their strings
  Map<String, List<String>> categoryMap = getCategoriesMap(prefs);
  
  // Print the contents of all categories
  print("Categories and their strings: $categoryMap");
}

Future<int> clearCustomCategories() async {
  final prefs = await SharedPreferences.getInstance();
  // Remove the customCategories key, which deletes all its contents
  await prefs.remove('categoryMap');
  return 1;
}
// Load categories from SharedPreferences
Future<Map<String, List<String>>> loadCategories() async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, List<String>> categoryMap = getCategoriesMap(prefs);
  //onCategoriesLoaded(categoryMap);  // Pass the map to the callback to update UI
  return categoryMap;
}

// Get the categories map from SharedPreferences
Map<String, List<String>> getCategoriesMap(SharedPreferences prefs) {
  List<String> storedMap = prefs.getStringList('categoryMap') ?? [];
  
  Map<String, List<String>> categoryMap = {};
  for (var entry in storedMap) {
    var parts = entry.split(":");
    if (parts.length == 2) {
      categoryMap[parts[0]] = parts[1].split(",");
    }
  }
  return categoryMap;
}

// Save a category name to SharedPreferences
Future<void> saveCategoryName(String categoryName) async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, List<String>> categoryMap = getCategoriesMap(prefs);
  
  if (!categoryMap.containsKey(categoryName)) {
    categoryMap[categoryName] = [];
  }

  await prefs.setStringList('categoryMap', categoryMap.entries
      .map((entry) => '${entry.key}:${entry.value.join(",")}')
      .toList());
}

// Edit the name of an existing category
Future<void> editCategoryName(String oldName, String newName) async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, List<String>> categoryMap = getCategoriesMap(prefs);
  
  if (categoryMap.containsKey(oldName)) {
    List<String> categoryStrings = categoryMap[oldName]!;
    categoryMap.remove(oldName);
    categoryMap[newName] = categoryStrings;

    await prefs.setStringList('categoryMap', categoryMap.entries
        .map((entry) => '${entry.key}:${entry.value.join(",")}')
        .toList());
  }
}

// Delete a category from SharedPreferences
Future<void> deleteCategory(String categoryName) async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, List<String>> categoryMap = getCategoriesMap(prefs);
  
  if (categoryMap.containsKey(categoryName)) {
    categoryMap.remove(categoryName);

    await prefs.setStringList('categoryMap', categoryMap.entries
        .map((entry) => '${entry.key}:${entry.value.join(",")}')
        .toList());
  }
}

Future<void> deleteStringFromCategory(String categoryName, String stringToDelete) async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, List<String>> categoryMap = getCategoriesMap(prefs);

  if (categoryMap.containsKey(categoryName)) {
    categoryMap[categoryName]!.remove(stringToDelete);

    await prefs.setStringList('categoryMap', categoryMap.entries
        .map((entry) => '${entry.key}:${entry.value.join(",")}')
        .toList());
  }
}


Future<void> clearStringsFromCategory(String categoryName) async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, List<String>> categoryMap = getCategoriesMap(prefs);

  if (categoryMap.containsKey(categoryName)) {
    categoryMap[categoryName]!.clear();

    await prefs.setStringList('categoryMap', categoryMap.entries
        .map((entry) => '${entry.key}:${entry.value.join(",")}')
        .toList());
  }
}

Future<void> printStringInCategory(String categoryName) async {
  final prefs = await SharedPreferences.getInstance();
  
  // Retrieve and print the current map of categories and their strings
  Map<String, List<String>> categoryMap = getCategoriesMap(prefs);
  if (categoryMap.containsKey(categoryName)) {
    List<String>? catStrList = categoryMap[categoryName];
    print("Categories and their strings: $catStrList");
  } else {
    print('error');
  }
  
  // Print the contents of all categories
  
}

