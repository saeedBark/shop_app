import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/news_app/cubit/cubit.dart';
import 'package:flutter_apps/layout/news_app/cubit/states.dart';
import 'package:flutter_apps/modules/news_app/search/search_screen.dart';
import 'package:flutter_apps/shared/cubit/cubit.dart';
import 'package:flutter_apps/shared/network/remote/dio_helper.dart';

class NewsLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('New App'),
            actions: [
              IconButton(
                  onPressed: () {
                    navigatorTo(
                      context,
                      SearchScreen(),
                    );
                  },
                  icon: Icon(Icons.search)),
              IconButton(
                  onPressed: () {
                    AppCubit.get(context).changeAppMode();
                  },
                  icon: Icon(Icons.brightness_4_outlined)),
            ],
          ),
          body: cubit.screen[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomBar(index);
            },
            items: cubit.bottomItems,
          ),
        );
      },
    );
  }
}
