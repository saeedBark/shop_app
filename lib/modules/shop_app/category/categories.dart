import 'package:flutter/material.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/shop_app/cubit/cubit.dart';
import 'package:flutter_apps/layout/shop_app/cubit/states.dart';
import 'package:flutter_apps/models/shop_app/categories_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context).categoryModel.data!.data;
        return ListView.separated(
            itemBuilder: (context, index) => builderCatItem(cubit![index]),
            separatorBuilder: (context, index) => MyDiver(),
            itemCount: cubit!.length);
      },
    );
  }

  Widget builderCatItem(DataModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(model.image!),
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              model.name!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      );
}
