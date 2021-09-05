import 'package:bdrive/authenticationF/numberVerificationPage.dart';
import 'package:bdrive/authenticationF/smsVerificationPage.dart';
import 'package:bdrive/contentF/homePage.dart';
import 'package:bdrive/contentF/logoPage.dart';
import 'package:bdrive/contentF/profileScreen.dart';
import 'package:bdrive/contentF/settingsPage.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    if (args != null) {
      print(args);
    }

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LogoPage());
      case '/hp':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/nvp':
        return MaterialPageRoute(builder: (_) => NumberVerificationPage());
      case '/svp':
        return MaterialPageRoute(builder: (_) => SMSVerificationPage());
      case '/sep':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case '/pp':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      // case '/messageScreen':
      //   return MaterialPageRoute(
      //       builder: (_) => MessageScreen(contactModel: args,));
      // case '/userScreen':
      //   return MaterialPageRoute(builder: (_) => UserProfile(contactNo: args,));
      // case '/verifyNumberScreen':
      //   return MaterialPageRoute(builder: (_) => VerifyNumberScreen());
      // case '/verifySmsScreen':
      //   return MaterialPageRoute(
      //       builder: (_) => VerifySmsScreen(
      //             data: args,
      //           ));
      // case '/profileScreen':
      //   return MaterialPageRoute(builder: (_) => ProfileScreen());
      // case '/imageCapture':
      //   return MaterialPageRoute(
      //       builder: (_) => ImageCapture(
      //             function: args,
      //           ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}






// Navigator.pushNamed(context, '/verifyNumberScreen');