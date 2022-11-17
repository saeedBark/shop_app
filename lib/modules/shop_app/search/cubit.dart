import 'package:bloc/bloc.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/models/shop_app/search_model.dart';
import 'package:flutter_apps/modules/shop_app/search/state.dart';
import 'package:flutter_apps/shared/network/end_points.dart';
import 'package:flutter_apps/shared/network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  late SearchModel model;
  void search(String text) {
    emit(SearchLoadingState());
    DioHolper.postData(url: SEARCH, data: {
      'text': text,
      token: token,
    }).then((value) {
      model = SearchModel.fromJson(value.data);
      printFullText(model.message.toString());
      emit(SearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState(error.toString()));
    });
  }
}
