import 'package:flutter/material.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/shop_app/cubit/cubit.dart';
import 'package:flutter_apps/layout/shop_app/shop_layout.dart';

import 'package:flutter_apps/modules/shop_app/login/shop_login_screen.dart';
import 'package:flutter_apps/shared/cubit/cubit.dart';
import 'package:flutter_apps/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_apps/layout/news_app/cubit/cubit.dart';

import 'package:flutter_apps/modules/shop_app/on_boarding/on_boarding_screen.dart';

import 'package:flutter_apps/shared/network/local/cache_helper.dart';
import 'package:flutter_apps/shared/network/remote/dio_helper.dart';
import 'package:flutter_apps/styles/bloc_observ.dart';
import 'package:flutter_apps/styles/themes.dart';

import 'layout/news_app/news_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHolper.init();
  await CacheHelper.init();

// bool isDark = CacheHelper.getBoolean(key: 'isDark');
  Widget widget;

  bool onBroading = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);
  print(onBroading);

  if (onBroading != null) {
    if (token != null)
      widget = ShopLayout();
    else
      widget = ShopLoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;
  MyApp({this.startWidget});
  //final bool isDark ;
  //  MyApp(this.isDark);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => NewsCubit()
              ..getBusiness()
              ..getSports()
              ..getScience()),
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
                // fromShared : isDark,
                ),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategoryData()
            ..getFavoritesData()
            ..getUserData(),
        )
      ],
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,

            //   darkTheme: darkTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
            //startWidget,
            //true ? ShopLoginScreen() :  OnBoardingScreen(),
          );
        },
      ),
    );
  }
}
