import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/shop_app/shop_layout.dart';
import 'package:flutter_apps/modules/shop_app/login/cubit/cubit.dart';
import 'package:flutter_apps/modules/shop_app/login/cubit/state.dart';
import 'package:flutter_apps/modules/shop_app/register/cubit/cubit.dart';
import 'package:flutter_apps/modules/shop_app/register/cubit/state.dart';
import 'package:flutter_apps/shared/network/local/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopRegisterScreen extends StatelessWidget {
  var formkey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterState>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
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
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
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
                          'RERGISTER',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        defaultFormFile(
                          controller: nameController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your name ';
                            }
                          },
                          lable: 'Name',
                          prefix: Icons.person,
                          type: TextInputType.name,
                        ),
                        SizedBox(
                          height: 25.0,
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
                          isPassword: ShopRegisterCubit.get(context).isPassword,
                          onsubmit: (value) {
                            if (formkey.currentState!.validate()) {
                              ShopRegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your password';
                            }
                          },
                          lable: 'Password',
                          prefix: Icons.lock_outlined,
                          suffix: ShopRegisterCubit.get(context).suffix,
                          onTap: () {
                            //suffixOnPpress
                            ShopRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          type: TextInputType.visiblePassword,
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        defaultFormFile(
                          controller: phoneController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your phone';
                            }
                          },
                          lable: 'phone',
                          prefix: Icons.phone,
                          type: TextInputType.phone,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          //state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                              fanction: () {
                                if (formkey.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              text: 'Register',
                              isUpperCase: true),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
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
