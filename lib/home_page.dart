import 'package:average_grades/gpa.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF273F4F),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // فقط به اندازه محتوا فضا می‌گیره
            children: [
              // آیکون بالای متن
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.school_rounded,
                    color: Color(0xFFFE7743),
                    size: 80,
                  ),
                  const Icon(
                    Icons.calculate,
                    color: Color(0xFFFE7743),
                    size: 80,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // متن اصلی
              const Text(
                'محاسبه معدل',
                style: TextStyle(
                  color: Color(0xFFFE7743),
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'vazir',
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                '!معدل‌گیری هیچ‌وقت انقدر ساده نبوده',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white70,
                  fontFamily: 'vazir',
                ),
              ),

              const SizedBox(height: 40),

              const SizedBox(height: 80), // فاصله تا دکمه

              // دکمه شروع
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE7743),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GPAHomePage()),
                    );
                  },
                  child: const Text(
                    'شروع',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'vazir',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
