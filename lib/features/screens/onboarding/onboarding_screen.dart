import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/constants/app_strings.dart';
import 'package:evently/core/Extension.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnBoardingData> _getPages(BuildContext context) {
    return [
      OnBoardingData(
        image: 'assets/images/lightOnboarding_1.png',
        title: context.locale.onBoardingTitle2,
        description: context.locale.onBoardingDesc2,
      ),
      OnBoardingData(
        image: 'assets/images/lightOnboarding_2.png',
        title: context.locale.onBoardingTitle3,
        description: context.locale.onBoardingDesc3,
      ),
      OnBoardingData(
        image: 'assets/images/lightOnboarding_3.png',
        title: context.locale.onBoardingTitle4,
        description: context.locale.onBoardingDesc4,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(int pagesLength) {
    if (_currentPage < pagesLength - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppStrings.login);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = _getPages(context);
    final isDark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkPurple : AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 36, height: 36),
                  SizedBox(width: 8),
                  Text(
                    context.locale.logo,
                    style: context.textTheme.headlineLarge?.copyWith(
                      color: AppColors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppColors.purple,
                  dotColor: isDark ? AppColors.gray : const Color(0xFFE0E0E0),
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      onPressed: _previousPage,
                      icon: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back, color: AppColors.purple),
                      ),
                    )
                  else
                    SizedBox(width: 48),
                  IconButton(
                    onPressed: () => _nextPage(pages.length),
                    icon: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _currentPage == pages.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnBoardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(data.image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 24),
          Text(
            data.title,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.purple,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.theme.brightness == Brightness.dark
                  ? AppColors.offWhite
                  : AppColors.black,
              height: 1.5,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class OnBoardingData {
  final String image;
  final String title;
  final String description;

  OnBoardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}
