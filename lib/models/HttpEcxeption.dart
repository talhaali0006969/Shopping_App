class HttpEcxeption implements Exception {
  final String message;
  HttpEcxeption({required this.message});

  @override
  String toString() {
    return message;

    /*return super.toString();*/
  }
}
