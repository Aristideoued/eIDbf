import 'package:flutter/material.dart';

class MainLayoutController {
  // Avant : ne prenait que le Widget
  // void Function(Widget page)? openSubPage;

  // Maintenant : prend Widget + titre optionnel
  void Function(Widget page, {String title})? openSubPage;
  void Function()? closeSubPage;
}

final mainLayoutController = MainLayoutController();
