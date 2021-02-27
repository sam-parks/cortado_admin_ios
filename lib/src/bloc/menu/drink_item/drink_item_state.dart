part of 'drink_item_bloc.dart';

@CopyWith()
class DrinkItemState extends Equatable {
  const DrinkItemState(
      {this.drinkTemplate,
      this.regularSizes = const [
        SizeInOunces.six,
        SizeInOunces.eight,
        SizeInOunces.twelve,
        SizeInOunces.sixteen,
        SizeInOunces.twenty,
        SizeInOunces.twentyFour
      ]});

  final DrinkTemplate drinkTemplate;

  final List<SizeInOunces> regularSizes;

  @override
  List<Object> get props => [
        drinkTemplate,
        regularSizes,
      ];
}
