import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/news_app/cubit/cubit.dart';
import 'package:flutter_apps/layout/news_app/cubit/states.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = NewsCubit.get(context).search;

        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultFormFile(
                  onsubmit: (value) {
                    NewsCubit.get(context).getSearch(value);
                  },
                  controller: searchController,
                  type: TextInputType.text,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'search must not be empty';
                    }
                    return null;
                  },
                  lable: 'Search',
                  prefix: Icons.search,
                ),
              ),
              Expanded(
                  child: articleBuilder(
                list,
                context,
                issearch: true,
              )),
            ],
          ),
        );
      },
    );
  }
}
