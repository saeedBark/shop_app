import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/shop_app/cubit/cubit.dart';
import 'package:flutter_apps/layout/shop_app/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreenn extends StatelessWidget {
  var formkey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context).UserModel;
        nameController.text = cubit.data!.name;
        emailController.text = cubit.data!.email;
        phoneController.text = cubit.data!.phone;

        return ConditionalBuilder(
          condition: ShopCubit.get(context).UserModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: ListView(
                  children: [
                    if (state is ShopLoadingUpdateUserDataState)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    defaultFormFile(
                      controller: nameController,
                      type: TextInputType.name,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'name must not be empty';
                        }
                        return null;
                      },
                      lable: 'Name',
                      prefix: Icons.person,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    defaultFormFile(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'email must not be empty';
                        }
                        return null;
                      },
                      lable: 'Email Adress',
                      prefix: Icons.email,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    defaultFormFile(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'phone must not be empty';
                        }
                        return null;
                      },
                      lable: 'Phone',
                      prefix: Icons.phone,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    defaultButton(
                        fanction: () {
                          if (formkey.currentState!.validate()) {
                            ShopCubit.get(context).updateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            );
                          }
                        },
                        text: 'UPDATE'),
                    SizedBox(
                      height: 20,
                    ),
                    defaultButton(
                        fanction: () {
                          LogOut(context);
                        },
                        text: 'LOG UOT'),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
