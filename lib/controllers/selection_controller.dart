import 'package:flutter/material.dart';

class SelectionController extends ChangeNotifier {
  final Set<int> _selectedItems = {};

  bool get isSelectionMode => _selectedItems.isNotEmpty;
  int get count => _selectedItems.length;
  Set<int> get selectedItems => _selectedItems;

  void toggle(int item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    notifyListeners();
  }
  void selectAll(List<String> items){
    for (var i = 0; i < items.length; i++) {
      _selectedItems.add(i);
    }
    notifyListeners();
  }

  void clear() {
    _selectedItems.clear();
    notifyListeners();
  }

  bool isSelected(int item) => _selectedItems.contains(item);
}
