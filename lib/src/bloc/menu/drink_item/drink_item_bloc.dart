import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:cortado_admin_ios/src/data/item_template.dart';
import 'package:cortado_admin_ios/src/services/menu_service.dart';
import 'package:equatable/equatable.dart';

part 'drink_item_event.dart';
part 'drink_item_state.dart';
part 'drink_item_bloc.g.dart';

class DrinkItemBloc extends Bloc<DrinkItemEvent, DrinkItemState> {
  DrinkItemBloc() : super(DrinkItemState());

  @override
  Stream<DrinkItemState> mapEventToState(
    DrinkItemEvent event,
  ) async* {
    if (event is InitializeDrinkItem) {
      yield state.copyWith(drinkTemplate: event.drinkTemplate);
    } else if (event is ChangeName) {
      DrinkTemplate drinkTemplate =
          state.drinkTemplate.copyWith(name: event.name);
      yield state.copyWith(drinkTemplate: drinkTemplate);
    } else if (event is ChangeDescription) {
      DrinkTemplate drinkTemplate =
          state.drinkTemplate.copyWith(description: event.description);
      yield state.copyWith(drinkTemplate: drinkTemplate);
    } else if (event is ChangeRedeemableSize) {
      DrinkTemplate drinkTemplate =
          state.drinkTemplate.copyWith(redeemableSize: event.redeemableSize);
      yield state.copyWith(drinkTemplate: drinkTemplate);
    } else if (event is ChangeRedeemableType) {
      DrinkTemplate drinkTemplate =
          state.drinkTemplate.copyWith(redeemableType: event.type);
      yield state.copyWith(drinkTemplate: drinkTemplate);
    } else if (event is AddToRequiredAddIns) {
      List<String> requiredAddIns =
          List.from(state.drinkTemplate.requiredAddIns)..add(event.addInId);

      DrinkTemplate drinkTemplate =
          state.drinkTemplate.copyWith(requiredAddIns: requiredAddIns);

      yield state.copyWith(drinkTemplate: drinkTemplate);
    } else if (event is RemoveFromRequiredAddIns) {
      List<String> requiredAddIns =
          List.from(state.drinkTemplate.requiredAddIns)..remove(event.addInId);

      DrinkTemplate drinkTemplate =
          state.drinkTemplate.copyWith(requiredAddIns: requiredAddIns);

      yield state.copyWith(drinkTemplate: drinkTemplate);
    } else if (event is AddToAvailableAddIns) {
      List<String> availableAddIns =
          List.from(state.drinkTemplate.availableAddIns)..add(event.addInId);

      DrinkTemplate drinkTemplate =
          state.drinkTemplate.copyWith(availableAddIns: availableAddIns);

      yield state.copyWith(drinkTemplate: drinkTemplate);
    } else if (event is RemoveFromAvailableAddIns) {
      List<String> availableAddIns =
          List.from(state.drinkTemplate.availableAddIns)..remove(event.addInId);

      DrinkTemplate drinkTemplate =
          state.drinkTemplate.copyWith(availableAddIns: availableAddIns);

      yield state.copyWith(drinkTemplate: drinkTemplate);
    } else if (event is AddPriceToSizePriceMap) {
      Map<SizeInOunces, dynamic> sizePriceMap =
          Map.from(state.drinkTemplate.sizePriceMap);

      sizePriceMap[event.size] = '0.00';

      if (state.drinkTemplate.servedIced) this.add(ChangeServeIced(true));

      DrinkTemplate drinkTemplate =
          state.drinkTemplate.copyWith(sizePriceMap: sizePriceMap);

      yield state.copyWith(drinkTemplate: drinkTemplate);
    } else if (event is RemovePriceFromSizePriceMap) {
      Map<SizeInOunces, dynamic> sizePriceMap =
          Map.from(state.drinkTemplate.sizePriceMap);

      sizePriceMap.remove(event.size);
      if (state.drinkTemplate.servedIced) this.add(ChangeServeIced(true));
      DrinkTemplate drinkTemplate =
          state.drinkTemplate.copyWith(sizePriceMap: sizePriceMap);

      yield state.copyWith(drinkTemplate: drinkTemplate);
    } else if (event is ChangePriceForSize) {
      Map<SizeInOunces, dynamic> sizePriceMap =
          Map.from(state.drinkTemplate.sizePriceMap);

      sizePriceMap[event.size] = event.price;
      if (state.drinkTemplate.servedIced) this.add(ChangeServeIced(true));
      DrinkTemplate drinkTemplate =
          state.drinkTemplate.copyWith(sizePriceMap: sizePriceMap);

      yield state.copyWith(drinkTemplate: drinkTemplate);
    } else if (event is ChangeServeIced) {
      Map<SizeInOunces, dynamic> sizePriceMap =
          Map.from(state.drinkTemplate.sizePriceMap);
      DrinkTemplate drinkTemplate;
      if (event.serveIced) {
        if (sizePriceMap.containsKey(SizeInOunces.six))
          sizePriceMap[SizeInOunces.sixIced] = sizePriceMap[SizeInOunces.six];

        if (sizePriceMap.containsKey(SizeInOunces.eight))
          sizePriceMap[SizeInOunces.eightIced] =
              sizePriceMap[SizeInOunces.eight];
        if (sizePriceMap.containsKey(SizeInOunces.twelve))
          sizePriceMap[SizeInOunces.twelveIced] =
              sizePriceMap[SizeInOunces.twelve];
        if (sizePriceMap.containsKey(SizeInOunces.sixteen))
          sizePriceMap[SizeInOunces.sixteenIced] =
              sizePriceMap[SizeInOunces.sixteen];
        if (sizePriceMap.containsKey(SizeInOunces.twenty))
          sizePriceMap[SizeInOunces.twentyIced] =
              sizePriceMap[SizeInOunces.twenty];
        if (sizePriceMap.containsKey(SizeInOunces.twentyFour))
          sizePriceMap[SizeInOunces.twentyFourIced] =
              sizePriceMap[SizeInOunces.twentyFour];
      } else {
        sizePriceMap.remove(SizeInOunces.sixIced);
        sizePriceMap.remove(SizeInOunces.eightIced);
        sizePriceMap.remove(SizeInOunces.twelveIced);
        sizePriceMap.remove(SizeInOunces.sixteenIced);
        sizePriceMap.remove(SizeInOunces.twentyIced);
        sizePriceMap.remove(SizeInOunces.twentyFourIced);
      }

      drinkTemplate = state.drinkTemplate
          .copyWith(servedIced: event.serveIced, sizePriceMap: sizePriceMap);

      yield state.copyWith(drinkTemplate: drinkTemplate);
    }
  }
}
