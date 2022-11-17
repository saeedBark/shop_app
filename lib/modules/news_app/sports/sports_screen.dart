import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/layout/news_app/cubit/cubit.dart';
import 'package:flutter_apps/layout/news_app/cubit/states.dart';

class SportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = NewsCubit.get(context).sports;

        return articleBuilder(list, context);
      },
    );
  }
}
