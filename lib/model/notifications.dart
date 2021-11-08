class NotificationModel {
  NotificationModel({
    this.notificationId,
    this.title,
    this.message,
    this.created,
  });

  String notificationId;
  String title;
  String message;
  DateTime created;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        notificationId:
            json["notification_id"] == null ? null : json["notification_id"],
        title: json["title"] == null ? null : json["title"],
        message: json["message"] == null ? null : json["message"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
      );
}
