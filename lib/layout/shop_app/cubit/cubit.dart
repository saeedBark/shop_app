import 'package:flutter/material.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/news_app/cubit/states.dart';
import 'package:flutter_apps/layout/shop_app/cubit/states.dart';
import 'package:flutter_apps/models/shop_app/categories_model.dart';
import 'package:flutter_apps/models/shop_app/chang_favorites_model.dart';
import 'package:flutter_apps/models/shop_app/favorites_model.dart';
import 'package:flutter_apps/models/shop_app/home_model.dart';
import 'package:flutter_apps/models/shop_app/login_model.dart';
import 'package:flutter_apps/modules/setting_screen/setting_screen.dart';
import 'package:flutter_apps/modules/shop_app/category/categories.dart';
import 'package:flutter_apps/modules/shop_app/favorites/favoritesScreen.dart';
import 'package:flutter_apps/modules/shop_app/produits/produit.dart';
import 'package:flutter_apps/modules/shop_app/setting/settingScreen.dart';
import 'package:flutter_apps/shared/network/end_points.dart';
import 'package:flutter_apps/shared/network/local/cache_helper.dart';
import 'package:flutter_apps/shared/network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreen = [
    ProduitScreen(),
    CategoriesScreen(),
    FavoritsScreen(),
    SettingScreenn(),
  ];
  changeBotton(index) {
    currentIndex = index;
    emit(ShopBottonNavigatState());
  }

  Map<int, bool> favorites = {};
  late HomeModel homeModel;

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHolper.getData(url: HOME, token: token).then((value) {
      //  print(value.data);
      homeModel = HomeModel.fromJson(value.data);
      // print(homeModel.data.banners[0].id);
      // print(homeModel.data.products[0].oldPrice);
      homeModel.data!.products.forEach((element) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      });
      // print(favorites.toString());
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  late CategoryModel categoryModel;

  void getCategoryData() {
    //emit(ShopLoadingHomeDataState());

    DioHolper.getData(url: GET_CATEGORY, token: token).then((value) {
      categoryModel = CategoryModel.fromJson(value.data);
      emit(ShopSuccessCategoryDataState());
    }).catchError((error) {
      // print(error.toString());
      emit(ShopErrorCategoryDataState());
    });
  }

  late ChangFavoritesModel changefavoritesModel;

  void changFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangFavoritesDataState());
    DioHolper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      token = CacheHelper.getData(key: 'token');
      changefavoritesModel = ChangFavoritesModel.fromJson(value.data);
      //   print(value.data);
      if (!changefavoritesModel.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavoritesData();
      }
      emit(ShopSuccessChangFavoritesDataState(changefavoritesModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangFavoritesDataState());
    });
  }

  late FavoritesModel favoritesModel;

  void getFavoritesData() {
    emit(ShopLoadingGetFavDataState());
    DioHolper.getData(url: FAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      printFullText(value.data.toString());
      emit(ShopSuccessGetFavDataState());
    }).catchError((error) {
      // print(error.toString());
      emit(ShopErrorGetFavDataState());
    });
  }

  late ShopLoginModel UserModel;

  void getUserData() {
    emit(ShopLoadingGetUserDataState());
    DioHolper.getData(
      url: PROFIT,
      token: token,
    ).then((value) {
      UserModel = ShopLoginModel.fromJson(value.data);
      printFullText(UserModel.data!.name);
      emit(ShopSuccessGetUserDataState(UserModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingGetUserDataState());
    DioHolper.putData(url: UPDAT_PROFLE, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
    }).then((value) {
      UserModel = ShopLoginModel.fromJson(value.data);
      printFullText(UserModel.data!.name);
      emit(ShopSuccessUpdateUserDataState(UserModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserDataState());
    });
  }
}
