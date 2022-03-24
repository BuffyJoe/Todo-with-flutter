import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:todo_app/screens/completed.dart';
import 'package:todo_app/screens/home.dart';

class AppBarCustom extends StatelessWidget {
  final String title;
  AppBarCustom(this.title);

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

  @override
  Widget build(BuildContext context) {
    void onSelected(int value) {
      switch (value) {
        case 0:
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (builder) {
            return Home();
          }), (Route<dynamic> route) => false);
          break;
        case 1:
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (builder) {
            return Completed();
          }), (Route<dynamic> route) => false);
          break;
        case 3:
          followDeveloper();
          break;
      }
    }

    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (builder) {
              return Home();
            }), (Route<dynamic> route) => false);
          },
          icon: Icon(Icons.home)),
      title: Text(title),
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
            icon: Icon(Icons.more_vert_outlined),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                    children: [
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
