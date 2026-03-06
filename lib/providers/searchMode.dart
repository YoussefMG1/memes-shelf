import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  bool SearchMode = false;

  void searchOn(){
    SearchMode = true;
    notifyListeners();
  }
  void searchOff(){
    SearchMode = false;
    notifyListeners();
  }
}