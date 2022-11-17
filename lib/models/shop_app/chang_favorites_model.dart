class ChangFavoritesModel {
  bool? status;
  String? message;

  ChangFavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
