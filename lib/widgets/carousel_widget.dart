import 'dart:async';
import 'package:flutter/material.dart';

class AutoScrollCarousel extends StatefulWidget {
  const AutoScrollCarousel({super.key});

  @override
  _AutoScrollCarouselState createState() => _AutoScrollCarouselState();
}

class _AutoScrollCarouselState extends State<AutoScrollCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  late Timer _timer;
  int _currentPage = 0;
  bool _isUserInteracting = false;
  bool _isForward = true; // ✅ Track direction

  final List<String> images = [
    "assets/tdiscount16.jpg",
    "assets/tdiscount16.jpg",
    "assets/tdiscount16.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isUserInteracting) {
        setState(() {
          if (_isForward) {
            _currentPage++; // Move forward
            if (_currentPage >= images.length - 1) {
              _isForward = false; // Reverse direction when reaching last image
            }
          } else {
            _currentPage--; // Move backward
            if (_currentPage <= 0) {
              _isForward = true; // Forward again when reaching first image
            }
          }
        });

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) {
        setState(() {
          _isUserInteracting = true;
        });
      },
      onPanEnd: (_) {
        setState(() {
          _isUserInteracting = false;
        });
      },
      child: SizedBox(
        height: 200,
        child: PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
