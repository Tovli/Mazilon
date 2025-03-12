import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> saveCategoryName(String categoryName) async {
  final prefs = await SharedPreferences.getInstance();
  // Retrieve the current map of categories and their strings
  Map<String, List<String>> categoryMap = _getCategoriesMap(prefs);

  // If the category already exists, don't add it again, otherwise add the category
  if (!categoryMap.containsKey(categoryName)) {
    categoryMap[categoryName] = [];
  }

  // Save the updated map back to SharedPreferences
  await prefs.setStringList('categoryMap', categoryMap.entries
      .map((entry) => '${entry.key}:${entry.value.join(",")}')
      .toList());
}

Map<String, List<String>> _getCategoriesMap(SharedPreferences prefs) {
  // Retrieve the current list of category maps stored as a string list
  List<String> storedMap = prefs.getStringList('categoryMap') ?? [];
  
  // Convert the list back to a map
  Map<String, List<String>> categoryMap = {};
  for (var entry in storedMap) {
    var parts = entry.split(":");
    if (parts.length == 2) {
      categoryMap[parts[0]] = parts[1].split(",");
    }
  }
  return categoryMap;
}

Future<void> addStringToCategory(String categoryName, String newString) async {
  final prefs = await SharedPreferences.getInstance();
  
  // Get the existing map of categories and their strings
  Map<String, List<String>> categoryMap = _getCategoriesMap(prefs);

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
  Map<String, List<String>> categoryMap = _getCategoriesMap(prefs);
  
  // Print the contents of all categories
  print("Categories and their strings: $categoryMap");
}

Future<int> clearCustomCategories() async {
  final prefs = await SharedPreferences.getInstance();
  // Remove the customCategories key, which deletes all its contents
  await prefs.remove('categoryMap');
  return 1;
}

class CustomCategoryPage extends StatefulWidget {
  //final Function changeLocale;

  CustomCategoryPage(
      {super.key,
      //required this.changeLocale
      });
      @override
  _CustomCategoryPageState createState() => _CustomCategoryPageState();
  
}

class _CustomCategoryPageState extends State<CustomCategoryPage> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _stringController = TextEditingController();
List<String> categoryNames = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

// Load the category names from SharedPreferences
  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, List<String>> categoryMap = _getCategoriesMap(prefs);
    
    // Get the category names (keys of the map)
    setState(() {
      categoryNames = categoryMap.keys.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: SingleChildScrollView(
            child: Center(
                child: myAutoSizedText(
                    "Add Category",
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
                    null,
                    40)),
          ),
          backgroundColor: primaryPurple,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0))),
          toolbarHeight: 100),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Enter custom category name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String categoryName = _categoryController.text;
                if (categoryName.isNotEmpty) {
                  await saveCategoryName(categoryName);
                  _loadCategories(); // Reload category list
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Category added successfully')),
                  );
                }
              },
            style: TextButton.styleFrom(
                backgroundColor: primaryPurple,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: myAutoSizedText(
                  "Submit",
                  TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  null,
                  24),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              hint: Text('Select Category'),
              value: categoryNames.isNotEmpty ? categoryNames[0] : null,
              onChanged: (category) {
                setState(() {
                  // Update selected category for adding strings
                });
              },
              items: categoryNames.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _stringController,
              decoration: InputDecoration(
                labelText: 'Enter string to add to category',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String newString = _stringController.text;
                String selectedCategory = categoryNames.isNotEmpty ? categoryNames[0] : '';
                if (newString.isNotEmpty && selectedCategory.isNotEmpty) {
                  await addStringToCategory(selectedCategory, newString);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('String added successfully')),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: primaryPurple,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: myAutoSizedText(
                "Add String to Category",
                TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  null,
                  24
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await printCategories(); // Print the categories to the console
              },
              style: TextButton.styleFrom(
                backgroundColor: primaryPurple,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: myAutoSizedText(
                "Print Categories",
                TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  null,
                  24
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                int cleared = await clearCustomCategories();
                if (cleared == 1) {
                  setState(() {
                    categoryNames.clear();
                  });
                }
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Categories cleared')),
                  );
              },
            style: TextButton.styleFrom(
                backgroundColor: primaryPurple,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: myAutoSizedText(
                  "clear categories",
                  TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  null,
                  24),
            ),
          ],
        ),
        
      ),
      backgroundColor: lightGray,
    );
  }
}

/*
                            onPressed: () {
                String inputText = _controller.text;
                if (inputText.isNotEmpty) {
                  // Do something with the input text
                  Navigator.pop(context, inputText);  // Return the input text back to the previous page
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a category name')),
                  );
                }
              },
*/