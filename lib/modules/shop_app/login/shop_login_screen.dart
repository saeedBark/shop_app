import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/shop_app/shop_layout.dart';
import 'package:flutter_apps/modules/shop_app/login/cubit/cubit.dart';
import 'package:flutter_apps/modules/shop_app/login/cubit/state.dart';
import 'package:flutter_apps/modules/shop_app/register/shop_register_screen.dart';
import 'package:flutter_apps/shared/network/local/cache_helper.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginScreen extends StatelessWidget {
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginState>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status!) {
              print(state.loginModel.message);
              print(state.loginModel.data!.token);

              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                token = state.loginModel.data!.token;
                navigatorAndFinish(
                  context,
                  ShopLayout(),
                );
              });
            } else {
              //    print(state.loginModel.message);

              showToast(
                text: state.loginModel.message!,
                state: ToastState.ERRO,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        defaultFormFile(
                          controller: emailController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your email adress';
                            }
                          },
                          lable: 'Email Adress',
                          prefix: Icons.email_outlined,
                          type: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        defaultFormFile(
                          controller: passwordController,
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          onsubmit: (value) {
                            if (formkey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your password';
                            }
                          },
                          lable: 'Password',
                          prefix: Icons.lock_outlined,
                          suffix: ShopLoginCubit.get(context).suffix,
                          onTap: () {
                            //suffixOnPpress
                            ShopLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          type: TextInputType.visiblePassword,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                              fanction: () {
                                if (formkey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: 'login',
                              isUpperCase: true),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            defaultTextBotton(
                                onPress: () {
                                  navigatorTo(
                                    context,
                                    ShopRegisterScreen(),
                                  );
                                },
                                text: 'register'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
//8 minute => 6
