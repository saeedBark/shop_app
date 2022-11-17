import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/shop_app/cubit/states.dart';
import 'package:flutter_apps/models/shop_app/favorites_model.dart';
import 'package:flutter_apps/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/shop_app/cubit/cubit.dart';

class FavoritsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context).favoritesModel.data!.data;
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavDataState,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) =>
                  buildListeProduct(cubit![index].product, context),
              separatorBuilder: (context, index) => MyDiver(),
              itemCount: cubit!.length),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
