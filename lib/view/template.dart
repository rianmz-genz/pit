import 'package:flutter/material.dart';

class Template extends StatelessWidget {
  Template();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(36, 59, 83, 1),
          leading: IconButton(
            splashColor: Colors.transparent,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.keyboard_arrow_left, size: 40),
          ),
          centerTitle: true,
          title: const Text(
            'PIT Elektronik',
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        body: SafeArea(
          child: Container(),
        ),
      ),
    );
  }
}
