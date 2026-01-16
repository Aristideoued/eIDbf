import 'package:e_id_bf/Screens/Home.dart';
import 'package:e_id_bf/layout/demande.dart';
import 'package:e_id_bf/layout/notification.dart';
import 'package:e_id_bf/layout/profil.dart';
import 'package:e_id_bf/services/notification_service.dart'; // ton service
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as badges;

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  static const Color mainColor = Color(0xFF0B3C8A);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // 🔑 GlobalKey pour notifier NotificationListPage
  final GlobalKey<NotificationListPageState> _notifKey = GlobalKey();

  int _unreadCount = 0; // compteur des notifications non lues

  late final List<Widget> _pages = [
    const HomePage(),
    const DemandePage(),
    NotificationListPage(key: _notifKey),
    const ProfilPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  // 🔄 Charger le nombre de notifications non lues
  Future<void> _loadUnreadCount() async {
    try {
      final count = await NotificationService.getUnreadNotificationsCount();
      setState(() {
        _unreadCount = count;
      });
    } catch (e) {
      print("Erreur compteur notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: IndexedStack(index: _currentIndex, children: _pages),
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
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) async {
                setState(() => _currentIndex = index);

                // 🔄 Rafraîchir notifications si onglet sélectionné
                if (index == 2) {
                  _notifKey.currentState?.loadNotifications();
                  await _loadUnreadCount(); // mettre à jour le badge
                }
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              selectedFontSize: 12,
              unselectedFontSize: 11,
              iconSize: 26,
              showUnselectedLabels: true,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Accueil',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.assignment),
                  label: 'Demandes',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.notifications),
                      if (_unreadCount > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '$_unreadCount',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: 'Notifications',
                ),

                const BottomNavigationBarItem(
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
