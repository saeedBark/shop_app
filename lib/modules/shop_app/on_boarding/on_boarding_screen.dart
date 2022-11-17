import 'package:flutter/material.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/modules/shop_app/login/shop_login_screen.dart';
import 'package:flutter_apps/shared/network/local/cache_helper.dart';
import 'package:flutter_apps/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModle {
  final String? image;
  final String? title;
  final String? body;

  BoardingModle({this.image, this.title, this.body});
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModle> boarding = [
    BoardingModle(
      image: 'assets/images/images_shop.jpg',
      title: 'On Board 1 Title',
      body: 'On Board 1 Body',
    ),
    BoardingModle(
      image: 'assets/images/images_shop1.png',
      title: 'On Board 2 Title',
      body: 'On Board 2 Body',
    ),
    BoardingModle(
      image: 'assets/images/images_shop2.jpg',
      title: 'On Board 3 Title',
      body: 'On Board 3 Body',
    ),
  ];

  bool isLast = false;

  var borderController = PageController();

  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        navigatorAndFinish(
          context,
          ShopLoginScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextBotton(
              onPress: () {
                submit();
              },
              text: 'SKIP'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                controller: borderController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                physics: const BouncingScrollPhysics(),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: borderController,
                  count: boarding.length,
                  effect: const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: daufltcolor,
                      expansionFactor: 4,
                      spacing: 5),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else
                      borderController.nextPage(
                          duration: const Duration(
                            milliseconds: 720,
                          ),
                          curve: Curves.fastLinearToSlowEaseIn);
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModle model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Image(image: AssetImage('${model.image}'))),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${model.title}',
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            '${model.body}',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      );
}
