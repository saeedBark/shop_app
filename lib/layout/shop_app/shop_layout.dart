import 'package:flutter/material.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/shop_app/cubit/cubit.dart';
import 'package:flutter_apps/layout/shop_app/cubit/states.dart';
import 'package:flutter_apps/modules/news_app/search/search_screen.dart';
import 'package:flutter_apps/modules/shop_app/login/shop_login_screen.dart';
import 'package:flutter_apps/modules/shop_app/search/searchScreen.dart';
import 'package:flutter_apps/shared/network/local/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopState>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = ShopCubit.get(context);
        return  Scaffold(
            appBar: AppBar(
              title: Text('Salle'),
              actions: [
                IconButton(onPressed: (){
                  navigatorTo(context, SearchScreenShop());
                }, icon: Icon(Icons.search),),
              ],
            ),
            body: cubit.bottomScreen[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBotton(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.category),label: 'Category'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Favorites'),
              BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Settinges'),
            ],
          ),

        );
      },

    );

  }
}