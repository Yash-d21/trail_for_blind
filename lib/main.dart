import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/camera_screen.dart'; // Import CameraScreen

void main() {
  runApp(const TrailApp());
}

class TrailApp extends StatelessWidget {
  const TrailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print('SplashScreen initState called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('SplashScreen addPostFrameCallback triggered');
      Future.delayed(const Duration(seconds: 3), () {
        try {
          print('Navigating to HomeScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } catch (e) {
          print('Navigation error: $e');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/image.png',
          width: 150,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $error');
            return const Text('Error loading logo');
          },
        ),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<String> _icons = ["camera.webp", "mic.png", "settings.webp"];
  int _currentIndex = 0;

  void _onSwipe(bool isRight) {
    setState(() {
      if (isRight) {
        _currentIndex = (_currentIndex + 1) % _icons.length;
      } else {
        _currentIndex = (_currentIndex - 1 + _icons.length) % _icons.length;
      }
    });
  }

  void _handleBigIconTap() {
    // Only navigate to CameraScreen if the current big icon is the camera
    if (_icons[_currentIndex] == "camera.webp") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0) {
              _onSwipe(false); // Swipe Left
            } else if (details.primaryVelocity! < 0) {
              _onSwipe(true); // Swipe Right
            }
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _handleBigIconTap,
                child: Image.asset(
                  'assets/${_icons[_currentIndex]}',
                  width: 150,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading icon: $error');
                    return const Text('Error loading icon');
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _icons.length,
                      (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index ? Colors.red : Colors.transparent,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/${_icons[index]}',
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading small icon: $error');
                          return const Icon(Icons.error, size: 50);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _icons.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: _currentIndex == index ? 12 : 8,
                    height: _currentIndex == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "USERNAME",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "EMERGENCY PHNO.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}