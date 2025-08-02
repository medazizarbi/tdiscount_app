import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';

class AutoScrollCarousel extends StatefulWidget {
  final Function(int) onPageChanged; // Callback to update the current page

  const AutoScrollCarousel({
    super.key,
    required this.onPageChanged,
  });

  @override
  AutoScrollCarouselState createState() => AutoScrollCarouselState();
}

class AutoScrollCarouselState extends State<AutoScrollCarousel> {
  final PageController _pageController = PageController(viewportFraction: 1);
  late Timer _timer;
  int _currentPage = 0;
  bool _isUserInteracting = false;
  bool _isScrollingForward = true; // Track scrolling direction

  // List of images (hardcoded for now, will be replaced with server data later)
  final List<String> images = [
    "assets/images/tdiscount16.jpg",
    "assets/images/tdiscount16.jpg",
    "assets/images/tdiscount16.jpg",
    "assets/images/tdiscount16.jpg",
    "assets/images/tdiscount16.jpg",
    "assets/images/tdiscount16.jpg",
  ];

  // Original aspect ratio (1132 / 490)
  final double aspectRatio = 1132 / 490;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isUserInteracting) {
        if (_isScrollingForward) {
          // Scroll forward
          if (_currentPage < images.length - 1) {
            _currentPage++;
          } else {
            // Reverse direction when reaching the last image
            _isScrollingForward = false;
            _currentPage--;
          }
        } else {
          // Scroll backward
          if (_currentPage > 0) {
            _currentPage--;
          } else {
            // Reverse direction when reaching the first image
            _isScrollingForward = true;
            _currentPage++;
          }
        }

        if (mounted && _currentPage >= 0 && _currentPage < images.length) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
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
    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight = screenWidth / aspectRatio; // 📌 Dynamic height

    return Column(
      children: [
        GestureDetector(
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
            height: imageHeight, // ✅ Maintain aspect ratio
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                widget.onPageChanged(index); // Notify parent of page change
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                      width: screenWidth * 0.8,
                      height: imageHeight,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        IndicatorDots(
          currentPage: _currentPage,
          totalPages: images.length, // Use the length of the images list
        ),
      ],
    );
  }
}

class IndicatorDots extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const IndicatorDots({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(
            index == currentPage ? Icons.circle : Icons.circle_outlined,
            size: 10,
            color: index == currentPage
                ? (Theme.of(context).brightness == Brightness.dark
                    ? TColors.white
                    : TColors.black)
                : Colors.grey,
          ),
        );
      }),
    );
  }
}
