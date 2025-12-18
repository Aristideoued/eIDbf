import 'package:e_id_bf/Screens/Home.dart';
import 'package:e_id_bf/layout/demande.dart';
import 'package:e_id_bf/layout/notification.dart';
import 'package:e_id_bf/layout/profil.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  static const Color mainColor = Color(0xFF0B3C8A);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    DemandePage(),
    NotificationPage(),
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // ================= CONTENU =================
      body: IndexedStack(index: _currentIndex, children: _pages),

      // ================= BOTTOM BAR =================
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: MainLayout.mainColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          bottom: true, // prend en compte la zone safe du bas
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ), // padding au lieu de height fixe
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,

              backgroundColor: Colors.transparent,
              elevation: 0,

              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,

              selectedFontSize: 12,
              unselectedFontSize: 11,

              iconSize: 26,
              showUnselectedLabels: true,

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Accueil',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment),
                  label: 'Demandes',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
