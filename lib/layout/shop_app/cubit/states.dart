import 'package:flutter_apps/models/shop_app/chang_favorites_model.dart';
import 'package:flutter_apps/models/shop_app/login_model.dart';

abstract class ShopState{}

class ShopInitialState extends ShopState{}

class ShopBottonNavigatState extends ShopState{}

class ShopLoadingHomeDataState extends ShopState{}

class ShopSuccessHomeDataState extends ShopState{}

class ShopErrorHomeDataState extends ShopState{}

class ShopSuccessCategoryDataState extends ShopState{}

class ShopErrorCategoryDataState extends ShopState{}

class ShopSuccessChangFavoritesDataState extends ShopState{
  final ChangFavoritesModel  modl;

  ShopSuccessChangFavoritesDataState(this.modl);
}

class ShopChangFavoritesDataState extends ShopState{}

class ShopErrorChangFavoritesDataState extends ShopState{}

class ShopLoadingGetFavDataState extends ShopState{}

class ShopSuccessGetFavDataState extends ShopState{}

class ShopErrorGetFavDataState extends ShopState{}

class ShopLoadingGetUserDataState extends ShopState{}

class ShopSuccessGetUserDataState extends ShopState{
  final ShopLoginModel model;

  ShopSuccessGetUserDataState(this.model);

}

class ShopErrorGetUserDataState extends ShopState{}


class ShopLoadingUpdateUserDataState extends ShopState{}

class ShopSuccessUpdateUserDataState extends ShopState{
  final ShopLoginModel model;

  ShopSuccessUpdateUserDataState(this.model);

}

class ShopErrorUpdateUserDataState extends ShopState{}