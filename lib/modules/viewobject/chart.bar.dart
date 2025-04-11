import 'dart:ui';

class ChartData {
  String valorX;
  double valorY;
  double porcentagem;
  int total;
  int totalConcluida;
  Color? color;

  ChartData({
    required this.valorX,
    required this.valorY,
    required this.porcentagem,
    required this.total,
    required this.totalConcluida,
    this.color,
  });


  @override
  String toString() {
    return '$valorX $porcentagem%';
  }

}