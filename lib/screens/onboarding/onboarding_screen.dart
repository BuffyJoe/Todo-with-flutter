import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:todo_app/screens/onboarding/page_one.dart';
import 'package:todo_app/wrapper.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // const OnboardingScreen({ Key? key }) : super(key: key);
  final controller = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(5),
        // color: Colors.grey,
        child: currentIndex == 5
            ? Center(
                child: FlatButton(
                  color: Colors.red,
                  child: Text('Get Started'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (_) {
                      return Wrapper();
                    }), (route) => false);
                  },
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    onPressed: () {
                      controller.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.slowMiddle);
                    },
                    child: Text('previous'),
                  ),
                  SmoothPageIndicator(
                    controller: controller,
                    count: 6,
                    onDotClicked: (int index) {
                      controller.jumpToPage(index);
                    },
                    effect: JumpingDotEffect(
                      activeDotColor: Colors.blue,
                      dotColor: Colors.white,
                      spacing: 4,
                      dotHeight: 14,
                      dotWidth: 14,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubicEmphasized);
                    },
                    child: Text('next'),
                  ),
                ],
              ),
      ),
      body: SafeArea(
        child: PageView(
          onPageChanged: (value) {
            currentIndex = value;
            setState(() {
              currentIndex;
            });
          },
          controller: controller,
          children: <Widget>[
            PageOne(),
            PageTwo(),
            Container(
              color: Colors.green,
              child: Center(child: Text('Page 3')),
            ),
            Container(
              color: Colors.yellow,
              child: Center(child: Text('Page 4')),
            ),
            Container(
              color: Colors.white,
              child: Center(child: Text('Page 5')),
            ),
            Container(
              color: Colors.orange,
              child: Center(child: Text('Page 6')),
            ),
          ],
        ),
      ),
    );
  }
}
