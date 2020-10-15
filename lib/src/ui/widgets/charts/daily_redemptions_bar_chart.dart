/// Vertical bar chart with bar label renderer example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flutter/material.dart';

class PurchasedCoffeesVerticalBarLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PurchasedCoffeesVerticalBarLabelChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory PurchasedCoffeesVerticalBarLabelChart.withSampleData() {
    return PurchasedCoffeesVerticalBarLabelChart(
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
  static List<charts.Series<PurchasedCoffees, String>> _createSampleData() {
    final data = [
      PurchasedCoffees('Coffee1', 5),
      PurchasedCoffees('Coffee1', 25),
      PurchasedCoffees('Coffee2', 100),
      PurchasedCoffees('Coffee3', 75),
      PurchasedCoffees('Coffee4', 75),
    ];

    return [
      charts.Series<PurchasedCoffees, String>(
          id: 'Sales',
          domainFn: (PurchasedCoffees coffees, _) => coffees.name,
          measureFn: (PurchasedCoffees coffees, _) => coffees.amount,
          data: data,
          fillColorFn: (_, __) => charts.Color.fromHex(code: '#471D00'),
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (PurchasedCoffees coffees, _) =>
              '\$${coffees.amount.toString()}')
    ];
  }
}

/// Sample ordinal data type.
class PurchasedCoffees {
  final String name;
  final int amount;

  PurchasedCoffees(this.name, this.amount);
}
