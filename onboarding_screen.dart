import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';
import '../controllers/onboarding_controller.dart';
import 'registration_screen.dart'; // تأكد من أنك استوردت شاشة التسجيل

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late List<OnboardingModel> onboardingData;

  @override
  void initState() {
    super.initState();
    // استدعاء البيانات من OnboardingController
    onboardingData = OnboardingController().getOnboardingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length, // استخدام عدد الصفحات من البيانات
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // عرض الصورة بناءً على البيانات من OnboardingController
                      Image.asset(
                        onboardingData[index].image, 
                        height: 250, 
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 30),
                      // عرض العنوان
                      Text(
                        onboardingData[index].title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // عرض الوصف
                      Text(
                        onboardingData[index].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(2); // تخطي إلى آخر صفحة
                  },
                  child: const Text("Skip"),
                ),
                Row(
                  children: List.generate(
                    onboardingData.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.blue : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_currentPage == onboardingData.length - 1) { // إذا كنا في آخر صفحة
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(_currentPage == onboardingData.length - 1 ? "Start" : "Next"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
