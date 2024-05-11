import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/constants.dart';
import 'package:e_commerce_app/size_config.dart';

// This is the best practice
import '../components/splash_content.dart';
import '../../../components/default_button.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  PageController _pageController = PageController();
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Tokoto, Let’s shop!",
      "image": "assets/images/splash_home_screen.png"
    },
    {
      "text": "You need to Login first to use the application",
      "image": "assets/images/splash_home_screen.png"
    },
    {
      "text": "You can browse the products in the home screen",
      "image": "assets/images/splash_home_screen.png"
    },
    {
      "text": "You can also search for products in categories or search",
      "image": "assets/images/splash_home_screen.png"
    },
    {
      "text": "Add products to wishlist or cart",
      "image": "assets/images/splash_cart_wishlist.png"
    },
    {
      "text": "We deliver the products at your doorstep",
      "image": "assets/images/splash_deliver_screen.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                controller: _pageController,
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    currentPage != splashData.length - 1
                        ? Row(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(1),
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).cardTheme.color),
                                  foregroundColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .color),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, HomeScreen.routeName);
                                },
                                child: Text(
                                  "Skip",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: SizeConfig.screenWidth * 0.45,
                                child: DefaultButton(
                                  text: "Next",
                                  icon: Icons.keyboard_arrow_right_outlined,
                                  press: () {
                                    currentPage++;
                                    _pageController.animateToPage(
                                      currentPage,
                                      duration: Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : DefaultButton(
                            text: "Login",
                            press: () {
                              Navigator.pushNamed(
                                  context, SignInScreen.routeName);
                            },
                          ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index
            ? Theme.of(context).buttonColor
            : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
