import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingStateButton<LoadingState> extends StatelessWidget {
  final dynamic button;
  final Bloc bloc;

  const LoadingStateButton({Key key, this.button, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: bloc,
      builder: (context, state) {
        if (state is LoadingState) {
          print("Loading Button State");
          print(state);
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.caramel)),
          );
        }
        return button;
      },
    );
  }
}
