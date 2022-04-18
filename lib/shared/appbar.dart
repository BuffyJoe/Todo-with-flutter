import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/providers/user_provider.dart';
import 'package:todo_app/wrapper.dart';

class AppBarCustom extends StatefulWidget {
  final String title;
  AppBarCustom(this.title);

  @override
  State<AppBarCustom> createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> {
  followDeveloper() async {
    await FlutterWebBrowser.openWebPage(
      url: "https://linkedin.com/in/okafor-onyekachukwu-133989209/",
      customTabsOptions: const CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        toolbarColor: Colors.blue,
        secondaryToolbarColor: Colors.green,
        navigationBarColor: Colors.transparent,
        shareState: CustomTabsShareState.on,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Colors.green,
        preferredControlTintColor: Colors.amber,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }

  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    void onSelected(int value) {
      switch (value) {
        case 0:
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (builder) {
            return Wrapper();
          }), (Route<dynamic> route) => false);
          break;
        case 1:
          Provider.of<UserProvider>(context, listen: false).signOut();
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (builder) {
            return Wrapper();
          }), (Route<dynamic> route) => false);
          break;
        case 2:
          followDeveloper();
          break;
      }
    }

    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (builder) {
              return Wrapper();
            }), (Route<dynamic> route) => false);
          },
          icon: Icon(Icons.home)),
      title: Text(widget.title),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.blue,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PopupMenuButton(
            padding: EdgeInsets.all(10),
            offset: Offset(0, 60),
            onSelected: (value) {
              onSelected(value);
            },
            color: Colors.brown[50],
            elevation: 20,
            icon: Icon(Icons.arrow_drop_down_circle),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      Text('expired')
                    ],
                  ),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.logout,
                          color: Colors.blue,
                        ),
                      ),
                      Text('Sign-Out')
                    ],
                  ),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.developer_mode,
                          color: Colors.blue,
                        ),
                      ),
                      Text('Contact Developer')
                    ],
                  ),
                  value: 3,
                ),
              ];
            },
          ),
        )
      ],
    );
  }
}
