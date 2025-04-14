import 'dart:async';
import 'package:flutter/material.dart';

class CarouselViewModel extends ChangeNotifier {
  final PageController pageController = PageController(viewportFraction: 1);
  late Timer _timer;
  int _currentPage = 0;
  bool _isScrollingForward = true;

  final List<String> images = [
    "assets/tdiscount16.jpg",
    "assets/tdiscount16.jpg",
    "assets/tdiscount16.jpg",
    "assets/tdiscount16.jpg",
    "assets/tdiscount16.jpg",
    "assets/tdiscount16.jpg",
  ];

  int get currentPage => _currentPage;

  void startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_isScrollingForward) {
        if (_currentPage < images.length - 1) {
          _currentPage++;
        } else {
          _isScrollingForward = false;
          _currentPage--;
        }
      } else {
        if (_currentPage > 0) {
          _currentPage--;
        } else {
          _isScrollingForward = true;
          _currentPage++;
        }
      }

      pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      notifyListeners();
    });
  }

  void stopAutoScroll() {
    _timer.cancel();
  }

  void updateCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    pageController.dispose();
    super.dispose();
  }
}
