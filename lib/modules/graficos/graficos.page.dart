import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/date_picker_range.component.dart';
import 'package:mybabernew/components/drop_down.component.dart';
import 'package:mybabernew/components/empty_list.component.dart';
import 'package:mybabernew/components/scaffold.component.dart';
import 'package:mybabernew/entity/grafico.dart';
import 'package:mybabernew/enums/tipo_periodo_grafico.dart';
import 'package:mybabernew/modules/graficos/graficos.controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficoPage extends StatefulWidget {
  final GraficoController graficoController;

  const GraficoPage({required this.graficoController});

  @override
  State<GraficoPage> createState() => GraficoPageState();
}

class GraficoPageState extends State<GraficoPage> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = graficoController.buscarDadosGrafico();
  }

  GraficoController get graficoController => widget.graficoController;

  List<int> anos = List.generate(DateTime.now().year - 2023 + 1, (index) => 2023 + index);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return ScaffoldComponent(
      isActionHome: true,
      isActionVoltar: false,
      isDrawer: false,
      labelAppBar: 'Gráficos',
      widgetAppBar: Container(),
      body: FutureBuilder(
        future: _future,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Carregando(inverterCor: true));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: TripleBuilder<GraficoController, List<Grafico>>(
                        store: graficoController,
                        builder: (ctx, triple) {
                          return triple.isLoading
                              ? const Center(child: Carregando(inverterCor: true))
                              : Column(
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(top: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  //SEMANA
                                                  Visibility(
                                                    visible: graficoController.tipoPeriodoGrafico == TipoPeriodoGrafico.SEMANA,
                                                    child: ConstrainedBox(
                                                      constraints: BoxConstraints(
                                                          maxWidth: deviceSize.width * 0.45),
                                                      child: DatePickerRangeComponent(
                                                        isSemanal: true,
                                                        onDateChanged: (newDate) {
                                                          graficoController.periodo = newDate;
                                                          _future = graficoController.buscarDadosGrafico();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: graficoController.tipoPeriodoGrafico != TipoPeriodoGrafico.SEMANA,
                                                    child: ConstrainedBox(
                                                      constraints: BoxConstraints(
                                                          maxWidth: deviceSize.width * 0.30),
                                                      child: DropDownComponent(
                                                        menuMaxHeight: deviceSize.height * 0.4,
                                                        value: graficoController.ano,
                                                        items: anos,
                                                        label: 'Ano',
                                                        onChanged: (Object? tipo) {
                                                          graficoController.ano = tipo as int;
                                                          _future = graficoController.buscarDadosGrafico();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxWidth: (graficoController.tipoPeriodoGrafico == TipoPeriodoGrafico.SEMANA
                                                            ? deviceSize.width * 0.40
                                                            : deviceSize.width * 0.50)),
                                                    child: DropDownComponent(
                                                      menuMaxHeight: deviceSize.height * 0.4,
                                                      value: graficoController.tipoPeriodoGrafico,
                                                      items: TipoPeriodoGrafico.values,
                                                      label: 'Período',
                                                      onChanged: (Object? tipo) {
                                                        graficoController.tipoPeriodoGrafico = (tipo as TipoPeriodoGrafico);
                                                        graficoController.atribuirPeriodoSemanaAtual();
                                                        _future = graficoController.buscarDadosGrafico();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    triple.state.isNotEmpty
                                        ? SfCartesianChart(
                                            plotAreaBorderWidth: 0,
                                            primaryXAxis: const CategoryAxis(
                                              majorGridLines: MajorGridLines(width: 0),
                                            ),
                                            // Chart title
                                            title: ChartTitle(
                                                text: 'Análise ${graficoController.titleGraficoPorPeriodo}'),
                                            // Enable legend
                                            legend: const Legend(isVisible: true),
                                            // Enable tooltip
                                            tooltipBehavior: TooltipBehavior(
                                                enable: true, header: 'Total R\$'),
                                            series: <CartesianSeries>[
                                                StackedColumnSeries<Grafico, String>(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    dataSource: triple.state,
                                                    xValueMapper: (Grafico graf, _) => graf.descricao!.substring(0, 3),
                                                    yValueMapper: (Grafico graf, _) => graf.valor,
                                                    name: 'Total R\$',
                                                    dataLabelMapper: (Grafico graf, _) => graf.valor!.toStringAsFixed(0),
                                                    dataLabelSettings: const DataLabelSettings(isVisible: true))
                                              ])
                                        : const EmptyList(),
                                  ],
                                );
                        }),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
