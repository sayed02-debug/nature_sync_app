import 'package:flutter/material.dart';
import 'onboarding_page.dart';
import 'onboarding_model.dart';
import '../location/location_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Skip Button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, right: 20),
              child: TextButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LocationScreen())
                ),
                child: const Text('Skip', style: TextStyle(color: Color(0xFF1a237e))),
              ),
            ),
          ),

          // Pages
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: OnboardingData.items.length,
              onPageChanged: (page) => setState(() => _currentPage = page),
              itemBuilder: (context, index) => OnboardingPage(
                item: OnboardingData.items[index],
              ),
            ),
          ),

          // Indicators & Next Button
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Indicators
                ...List.generate(
                  OnboardingData.items.length,
                      (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? const Color(0xFF1a237e) : Colors.grey,
                    ),
                  ),
                ),

                const Spacer(),

                // Next Button
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < OnboardingData.items.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LocationScreen())
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1a237e),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_currentPage == OnboardingData.items.length - 1 ? 'Start' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}