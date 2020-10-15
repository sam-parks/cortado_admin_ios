import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flutter/material.dart';

class DailySalesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DailySalesChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory DailySalesChart.withSampleData() {
    return DailySalesChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  // [BarLabelDecorator] will automatically position the label
  // inside the bar if the label will fit. If the label will not fit,
  // it will draw outside of the bar.
  // Labels can always display inside or outside using [LabelPosition].
  //
  // Text style for inside / outside can be controlled independently by setting
  // [insideLabelStyleSpec] and [outsideLabelStyleSpec].
  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barRendererDecorator: charts.BarLabelDecorator<String>(
          insideLabelStyleSpec: charts.TextStyleSpec(
              fontFamily: kFontFamilyNormal,
              color: charts.Color.fromHex(code: '#FFF6ED')),
          outsideLabelStyleSpec: charts.TextStyleSpec()),
      domainAxis: charts.OrdinalAxisSpec(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<DailySales, String>> _createSampleData() {
    final data = [
      DailySales('Coffee1', 5),
      DailySales('Coffee1', 25),
      DailySales('Coffee2', 100),
      DailySales('Coffee3', 75),
      DailySales('Coffee4', 75),
    ];

    return [
      charts.Series<DailySales, String>(
          id: 'Sales',
          domainFn: (DailySales sales, _) => sales.day,
          measureFn: (DailySales sales, _) => sales.amount,
          data: data,
          fillColorFn: (_, __) => charts.Color.fromHex(code: '#471D00'),
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (DailySales sales, _) => sales.amount.toString())
    ];
  }
}

/// Sample ordinal data type.
class DailySales {
  final String day;
  final double amount;

  DailySales(this.day, this.amount);
}
