import 'package:e_id_bf/Screens/NotificationDetail.dart';
import 'package:e_id_bf/layout/main_layout.dart';
import 'package:e_id_bf/models/Notification.dart';
import 'package:e_id_bf/services/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  NotificationListPageState createState() => NotificationListPageState();
}

// ⚡ State public
class NotificationListPageState extends State<NotificationListPage>
    with AutomaticKeepAliveClientMixin {
  // rendre le future "public" via un getter
  Future<List<NotificationModel>>? notificationsFuture;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  // méthode publique pour rafraîchir les notifications
  void loadNotifications() {
    setState(() {
      notificationsFuture = NotificationService.getMyNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: MainLayout.mainColor,
        foregroundColor: Colors.white,
      ),
      body: notificationsFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<NotificationModel>>(
              future: notificationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Erreur: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucune notification"));
                }

                final notifications = snapshot.data!;

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifications[index];

                    return InkWell(
                      onTap: () async {
                        if (!notif.lu) {
                          await NotificationService.markAsRead(notif.id);
                          notif.lu = true;
                        }

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NotificationDetailPage(notification: notif),
                          ),
                        );

                        loadNotifications();
                      },
                      child: Container(
                        color: notif.lu
                            ? Colors.white
                            : Colors.blue.withOpacity(0.08),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: notif.lu
                                  ? Colors.grey
                                  : Colors.blue,
                              child: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notif.message,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: notif.lu
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${notif.dateEmission.day}/${notif.dateEmission.month}/${notif.dateEmission.year} "
                                    "${notif.dateEmission.hour}:${notif.dateEmission.minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!notif.lu)
                              const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: Colors.blue,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
