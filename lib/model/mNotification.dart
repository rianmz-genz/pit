class PushNotification {
  String? title = "";
  String? body = "";
  String? dataTitle = "";
  String? dataBody = "";
  Map<String, dynamic>? data = {};
  init() {}
  PushNotification(
      {this.title, this.body, this.dataTitle, this.dataBody, this.data});
}
