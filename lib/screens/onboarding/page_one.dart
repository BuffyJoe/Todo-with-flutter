import 'package:flutter/material.dart';
import 'package:todo_app/providers/text_styles.dart';

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.2,
          ),
          Container(
            height: size.height * 0.5,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('Assets/images/Image001.png'))),
          ),
          Text(
            'Swipe Left to right to show more options',
            style: textStyles.onboardingTitleText(
              context,
              color: Colors.blue,
              italic: true,
              size: 20,
            ),
          ),
          Text(
            'Swipe right to left to show less options',
            style: textStyles.onboardingTitleText(
              context,
              color: Colors.blue,
              italic: true,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.2,
          ),
          Container(
            height: size.height * 0.5,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('Assets/images/Image002.png'))),
          ),
          Text(
            'Tap the expired icon to navigate to view expired tasks',
            style: textStyles.onboardingTitleText(
              context,
              color: Colors.green,
              italic: true,
              size: 15,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'tap the completed icon to navigate to the completed tasks',
            style: textStyles.onboardingTitleText(
              context,
              color: Colors.blue,
              italic: true,
              size: 15,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'tap the add icon to add a new task',
            style: textStyles.onboardingTitleText(
              context,
              // color: Colors.red,
              italic: true,
              size: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
