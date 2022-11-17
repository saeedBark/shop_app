import 'package:flutter/material.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/shop_app/cubit/cubit.dart';
import 'package:flutter_apps/models/shop_app/search_model.dart';
import 'package:flutter_apps/modules/shop_app/search/cubit.dart';
import 'package:flutter_apps/modules/shop_app/search/state.dart';
import 'package:flutter_apps/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreenShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var fromKey = GlobalKey<FormState>();
    var searchContrller = TextEditingController();
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: fromKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormFile(
                      controller: searchContrller,
                      type: TextInputType.text,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Enter text to search';
                        }
                        return null;
                      },
                      onsubmit: (String text) {
                        SearchCubit.get(context).search(text);
                      },
                      lable: 'Search',
                      prefix: Icons.search,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (state is SearchLoadingState) LinearProgressIndicator(),
                    SizedBox(
                      height: 12,
                    ),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) => buildListeProduct(
                                SearchCubit.get(context)
                                    .model
                                    .data!
                                    .data[index],
                                context,
                                isOldPrice: false),
                            separatorBuilder: (context, index) => MyDiver(),
                            itemCount: SearchCubit.get(context)
                                .model
                                .data!
                                .data
                                .length),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
