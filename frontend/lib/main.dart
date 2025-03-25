// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'feedback_screen.dart';
import 'navigation_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async { 
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(IITIndoreAppStyled());
  }

class IITIndoreAppStyled extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IIT Indore App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 197, 195, 202)),
        fontFamily: 'Roboto',
      ),
      home: MainPageStyled(),
    );
  }
}

class MainPageStyled extends StatefulWidget {
  @override
  _MainPageStyledState createState() => _MainPageStyledState();
}

class _MainPageStyledState extends State<MainPageStyled> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    FeedbackScreen(),
    NavigationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 10)
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feedback_outlined),
              label: 'Feedback',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.navigation_outlined),
              label: 'Navigate',
            ),
          ],
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 5,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
