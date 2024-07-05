class MyException implements Exception {
  final String msg;

  MyException({
    required this.msg,
  });

  @override
  String toString() {
    return msg;
  }
}