import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/models/shop_app/login_model.dart';
import 'package:flutter_apps/modules/shop_app/login/cubit/state.dart';
import 'package:flutter_apps/shared/network/end_points.dart';
import 'package:flutter_apps/shared/network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginCubit extends Cubit<ShopLoginState> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHolper.postData(url: LOGIN, data: {
      'email': email,
      'password': password,
    }).then((value) {
      // print(value.data['id']);

      //print(value.data['message']);
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShopChangePasswordVisibilityState());
  }
}
