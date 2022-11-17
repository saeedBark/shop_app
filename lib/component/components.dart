import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/layout/shop_app/cubit/cubit.dart';
import 'package:flutter_apps/modules/shop_app/login/shop_login_screen.dart';
import 'package:flutter_apps/shared/cubit/cubit.dart';
import 'package:flutter_apps/shared/network/local/cache_helper.dart';
import 'package:flutter_apps/styles/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  Color color = Colors.blue,
  double width = double.infinity,
  double raduis = 0,
  bool isUpperCase = true,
  required Function fanction,
  required String text,
}) {
  return Container(
    height: 40,
    width: width,
    child: MaterialButton(
      onPressed: () {
        fanction();
      },
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: TextStyle(color: Colors.white),
      ),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(raduis),
      color: color,
    ),
  );
}

Widget defaultTextBotton({
  required Function onPress,
  required String text,
}) =>
    TextButton(
      onPressed: () {
        onPress();
      },
      child: Text(text),
    );
Widget defaultFormFile({
  required TextEditingController controller,
  Function? onsubmit,
  required Function validator,
  required String lable,
  required IconData prefix,
  Function? onTap,
  TextInputType? type,
  IconData? suffix,
  bool enable = true,
  bool isPassword = false,
}) =>
    TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: type,
      onFieldSubmitted: (d) {
        onsubmit!(d);
      },
      validator: (m) {
        validator(m);
      },
      onTap: () {
        onTap!();
      },
      enabled: enable,
      decoration: InputDecoration(
        labelText: lable,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null ? Icon(suffix) : null,
        border: OutlineInputBorder(),
      ),
    );

Widget bulidTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: Icon(Icons.check_box),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'archive',
                  id: model['id'],
                );
              },
              icon: Icon(Icons.archive),
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );

Widget tasksBuilder({required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) {
            return bulidTaskItem(tasks[index], context);
          },
          separatorBuilder: (context, index) => MyDiver(),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.grey,
            ),
            Text(
              'No Taks Yet, Please Add Some Tasks',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );

Widget builderArchveItem(article, context) => InkWell(
      onTap: () {
        // navigatorTo(
        //   context,
        //   //WebViewScreen(article['url']),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage('${article['urlToImage']}'),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${article['title']}',
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
Widget MyDiver() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey,
      ),
    );

Widget articleBuilder(list, context, {issearch = false}) => ConditionalBuilder(
      condition: list.length > 0,
      builder: (context) => ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) =>
            builderArchveItem(list[index], context),
        separatorBuilder: (context, index) => MyDiver(),
        itemCount: 10,
      ),
      fallback: (context) =>
          issearch ? Container() : Center(child: CircularProgressIndicator()),
    );

void navigatorTo(context, Widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Widget,
    ));

void navigatorAndFinish(context, Widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Widget,
      ),
      (Route<dynamic> route) => false,
    );

void showToast({
  required String text,
  required ToastState state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: choosToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastState { SECCESS, ERRO, WARNING }

Color choosToastColor(ToastState state) {
  Color color;

  switch (state) {
    case ToastState.SECCESS:
      color = Colors.green;
      break;

    case ToastState.ERRO:
      color = Colors.red;
      break;

    case ToastState.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

void LogOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigatorAndFinish(context, ShopLoginScreen());
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String token = '';

Widget buildListeProduct(model, context, {bool isOldPrice = true}) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 120,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(model.image),
                    width: 120,
                    fit: BoxFit.cover,
                    height: 120,
                  ),
                  if (model.discount != 0 && isOldPrice)
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        color: Colors.red,
                        child: Text(
                          'DISCOUNT',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        )),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, height: 1.3),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: daufltcolor),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          model.oldPrice.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changFavorites(model.id);
                        },
                        icon: CircleAvatar(
                          backgroundColor:
                              ShopCubit.get(context).favorites[model.id]!
                                  ? daufltcolor
                                  : Colors.grey,
                          radius: 15,
                          child: Icon(
                            Icons.favorite_border,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
