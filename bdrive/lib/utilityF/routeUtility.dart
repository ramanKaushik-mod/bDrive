import 'package:bdrive/authenticationF/authenticationPage.dart';
import 'package:bdrive/contentF/homePage.dart';
import 'package:bdrive/contentF/imageCapture.dart';
import 'package:bdrive/contentF/logoPage.dart';
import 'package:bdrive/contentF/profileScreen.dart';
import 'package:bdrive/contentF/searchPage.dart';
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
      case '/sep':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case '/pp':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case '/imc':
        return MaterialPageRoute(builder: (_) => ImageCapture());
      case '/aup':
        return MaterialPageRoute(builder: (_) => AuthenticationPage());
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