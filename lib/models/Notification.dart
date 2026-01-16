class NotificationModel {
  final int id;
  final String type;
  final String message;
  final DateTime dateEmission;
  bool lu;
  final int personneId;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    required this.dateEmission,
    required this.lu,
    required this.personneId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      message: json['message'],
      dateEmission: DateTime.parse(json['dateEmission']),
      lu: json['lu'],
      personneId: json['personneId'],
    );
  }
}
