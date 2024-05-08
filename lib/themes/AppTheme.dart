/*
* File : App Theme
* Version : 1.0.0
* */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AppThemeNotifier.dart';

class AppTheme {
  static final int themeLight = 1;
  static final int themeDark = 2;
  static final int putih = 3;
  //custom color for pit elektronik

  static final Color warnaHitam = Color(0xFF1C1939);
  static final Color warnaHijau = Color(0xFF00A09D);
  static final Color warnaUngu = Color(0xFF875A7B);
  static final Color warnaAbuMuda = Color(0xFF939393);
  static final Color warnaAbuTua = Color(0xFF545353);
  static final Color warnaDongker = Color(0xFF1C3147);

  static CustomAppTheme customTheme = getCustomAppTheme(AppThemeNotifier.theme);
  static ThemeData theme = getThemeFromThemeMode(AppThemeNotifier.theme);

  AppTheme._();

  static CustomAppTheme getCustomAppTheme(int themeMode) {
    if (themeMode == themeLight) {
      return CustomAppTheme.lightCustomAppTheme;
    } else if (themeMode == themeDark) {
      return CustomAppTheme.darkCustomAppTheme;
    }
    return CustomAppTheme.darkCustomAppTheme;
  }

  static InputDecorationTheme getSearchBoxDecorationTheme() {
    return InputDecorationTheme(
        hintStyle: TextStyle(
            color: Color(0xFFA3A3A3),
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic),
        filled: true,
        fillColor: Colors.white,
        // disabledBorder: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(4.0))));
  }

  static InputDecorationTheme getLaporanBoxDecorationTheme() {
    return InputDecorationTheme(
        hintStyle: TextStyle(
            color: Color(0xFFA3A3A3),
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w400,
            fontSize: 13,
            fontStyle: FontStyle.italic),
        filled: true,
        fillColor: Colors.white,
        // disabledBorder: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(18.5))),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(18.5))));
  }

  static InputDecorationTheme getTeknisiDecorationTheme() {
    return InputDecorationTheme(
      hintStyle: TextStyle(
          color: Colors.transparent,
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
          fontSize: 15,
          fontStyle: FontStyle.italic),
      filled: true,
      fillColor: Colors.transparent,
      // disabledBorder: InputBorder.none,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
              color: const Color(0xFF27394E).withOpacity(0.2), width: 1.0)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
              color: const Color(0xFF27394E).withOpacity(0.2), width: 1.0)),
    );
  }

  static InputDecorationTheme loginDecorationTheme() {
    return InputDecorationTheme(
      disabledBorder: InputBorder.none,
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 5),
      fillColor: Colors.white70,
    );
  }

  //appbar untuk produk, pembelian,penjualan, jenis pembayaran, detail transaksi,hutang
  static TextStyle appBarTheme() {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600,
        fontSize: 17,
        color: Colors.white);
  }

  static TextStyle tabBarTheme() {
    return TextStyle(
      fontFamily: 'OpenSans',
      // fontWeight: FontWeight.w400,
      fontSize: 18,
    );
  }

  static TextStyle textFormFloatingButton() {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF333333));
  }

  static TextStyle titleFormFloatingButton() {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFF008199));
  }

  static TextStyle bottomNavigationTheme() {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF000D65));
  }

  //hutang theme
  static TextStyle hutangCardAtasJenis() {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Color(0xFF87859A));
  }

  static TextStyle textFormField(double size, Color warna) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: warna);
  }

  static TextStyle textFormFieldBold(double size, Color warna) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: warna);
  }

  static TextStyle hutangCardAtasNominal() {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: Color(0xFF000D65));
  }

  //isi tab
  static TextStyle hutangTitle(double size, Color warna) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: warna);
  }

  static TextStyle hutangsubTitle(double size, Color warna) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: warna);
  }

  //
  static TextStyle hutangCardAtasMore() {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF008199));
  }

  static TextStyle CommonTitle(double size, Color warna) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: warna);
  }

  //
  static TextStyle OpenSans700LS(
      double size, Color warna, double letterspacing) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: warna,
        letterSpacing: letterspacing);
  }

  static TextStyle OpenSans700(double size, Color warna) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: warna);
  }

  static TextStyle Roboto700(double size, Color warna) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: warna);
  }

  static TextStyle OpenSans600(double size, Color warna) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: warna);
  }

  static TextStyle OpenSans600LS(
      double size, Color warna, double letterspacing) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: warna,
        letterSpacing: letterspacing);
  }

  static TextStyle OpenSans500(double size, Color warna) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: warna);
  }

  static TextStyle OpenSans500LS(
      double size, Color warna, double letterspacing) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: warna,
        letterSpacing: letterspacing);
  }

  static TextStyle Roboto500(double size, Color warna) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: warna);
  }

  static TextStyle OpenSans400(double size, Color warna) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: warna);
  }

  static TextStyle OpenSans400LT(double size, Color warna) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: warna,
        decoration: TextDecoration.lineThrough);
  }

  static TextStyle OpenSans400LS(
      double size, Color warna, double letterspacing) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: warna,
        letterSpacing: letterspacing);
  }

  static TextStyle OpenSans300(double size, Color warna) {
    return TextStyle(
      fontFamily: 'OpenSans',
      fontSize: size,
      fontWeight: FontWeight.w300,
      color: warna,
    );
  }

  static TextStyle OpenSans300LS(
      double size, Color warna, double letterspacing) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w300,
        color: warna,
        letterSpacing: letterspacing);
  }

  static TextStyle Roboto400(double size, Color warna) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: warna);
  }

  static TextStyle OpenSans400Italic(double size, Color warna) {
    return TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: warna);
  }

  static FontWeight _getFontWeight(int weight) {
    switch (weight) {
      case 100:
        return FontWeight.w100;
      case 200:
        return FontWeight.w200;
      case 300:
        return FontWeight.w300;
      case 400:
        return FontWeight.w300;
      case 500:
        return FontWeight.w400;
      case 600:
        return FontWeight.w500;
      case 700:
        return FontWeight.w600;
      case 800:
        return FontWeight.w700;
      case 900:
        return FontWeight.w900;
    }
    return FontWeight.w400;
  }

  static double RadiusResponsive(BuildContext context, double size) {
    return (size * MediaQuery.of(context).size.height);
  }

  static TextStyle getTextStyle(TextStyle? textStyle,
      {int fontWeight = 500,
      bool muted = false,
      bool xMuted = false,
      double letterSpacing = 0.15,
      Color? color,
      TextDecoration decoration = TextDecoration.none,
      double? height,
      double wordSpacing = 0,
      double? fontSize}) {
    double? finalFontSize = fontSize != null ? fontSize : textStyle!.fontSize;

    Color? finalColor;
    if (color == null) {
      finalColor = xMuted
          ? textStyle!.color!.withAlpha(160)
          : (muted ? textStyle!.color!.withAlpha(200) : textStyle!.color);
    } else {
      finalColor = xMuted
          ? color.withAlpha(160)
          : (muted ? color.withAlpha(200) : color);
    }

    return GoogleFonts.ibmPlexSans(
        fontSize: finalFontSize,
        fontWeight: _getFontWeight(fontWeight),
        letterSpacing: letterSpacing,
        color: finalColor,
        decoration: decoration,
        height: height,
        wordSpacing: wordSpacing);
  }

  //App Bar Text
  static final TextTheme lightAppBarTextTheme = TextTheme(
    headline1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 102, color: Colors.black)),
    headline2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 64, color: Colors.black)),
    headline3: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 51, color: Colors.black)),
    headline4: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 36, color: Colors.black)),
    headline5: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 25, color: Colors.black)),
    headline6: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(
            fontSize: 22, color: Colors.white, fontFamily: 'OpenSans')),
    subtitle1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 17, color: Colors.black)),
    subtitle2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 15, color: Colors.black)),
    bodyText1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 16, color: Colors.black)),
    bodyText2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 14, color: Colors.black)),
    button: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 15, color: Colors.black)),
    caption: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 13, color: Colors.black)),
    overline: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 11, color: Colors.black)),
  );

  //Text Themes
  static final TextTheme lightTextTheme = TextTheme(
    headline1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 102, color: Colors.red)),
    headline2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 64, color: Colors.red)),
    headline3: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 51, color: Colors.red)),
    headline4: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 36, color: Colors.red)),
    headline5: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 25, color: Colors.red)),
    headline6: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 18, color: Colors.red)),
    subtitle1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(
            fontSize: 17, color: Colors.black, fontFamily: 'OpenSans')),
    subtitle2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 15, color: Colors.red)),
    bodyText1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 16, color: Colors.red)),
    bodyText2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(
            fontSize: 14, color: Colors.black, fontFamily: 'OpenSans')),
    button: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 15, color: Colors.red)),
    caption: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 13, color: Colors.red)),
    overline: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 11, color: Colors.red)),
  );

  //Color Themes
  static final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xff3d63ff),
      canvasColor: Colors.white,
      backgroundColor: Color(0xfff6f6f6),
      scaffoldBackgroundColor: Color(0xfff6f6f6),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        textTheme: lightAppBarTextTheme,
        actionsIconTheme: IconThemeData(
          color: Color(0xff495057),
        ),
        color: Color(0xff008199),
        iconTheme: IconThemeData(color: Colors.white, size: 24),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        minimumSize: Size(340, 60),
        onPrimary: Colors.white,
        primary: Color(0xFF008199),
        padding: EdgeInsets.only(left: 37, right: 37),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
        ),
      )),
      navigationRailTheme: NavigationRailThemeData(
          selectedIconTheme:
              IconThemeData(color: Color(0xff3d63ff), opacity: 1, size: 24),
          unselectedIconTheme:
              IconThemeData(color: Color(0xff495057), opacity: 1, size: 24),
          backgroundColor: Color(0xffffffff),
          elevation: 3,
          selectedLabelTextStyle: TextStyle(color: Color(0xff3d63ff)),
          unselectedLabelTextStyle: TextStyle(color: Color(0xff495057))),
      colorScheme: ColorScheme.light(
          primary: Color(0xff3d63ff),
          onPrimary: Colors.white,
          primaryVariant: Color(0xff0055ff),
          secondary: Color(0xff495057),
          secondaryVariant: Color(0xff3cd278),
          onSecondary: Colors.white,
          surface: Color(0xffe2e7f1),
          background: Color(0xfff3f4f7),
          onBackground: Color(0xff495057)),
      cardTheme: CardTheme(
        color: Colors.white,
        shadowColor: Colors.black,
        elevation: 20,
        margin: EdgeInsets.all(3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          fontSize: 17,
          color: Color(0xFF333333).withOpacity(0.415),
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.red, width: 1.0)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.red, width: 1.0)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
                color: const Color(0xFF27394E).withOpacity(0.2), width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: const Color(0xFF008199), width: 2.0)),
      ),
      splashColor: Colors.white.withAlpha(100),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: lightTextTheme,
      indicatorColor: Colors.white,
      disabledColor: Color(0xffdcc7ff),
      highlightColor: Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xff3d63ff),
          splashColor: Colors.white.withAlpha(100),
          highlightElevation: 8,
          elevation: 4,
          focusColor: Color(0xff3d63ff),
          hoverColor: Color(0xff3d63ff),
          foregroundColor: Colors.white),
      dividerColor: Color(0xffd1d1d1),
      errorColor: Color(0xfff0323c),
      cardColor: Colors.white,
      // accentColor: Color(0xff3d63ff),//original
      accentColor: Color(0xFF008199), //custombyadip
      popupMenuTheme: PopupMenuThemeData(
        color: Color(0xffffffff),
        textStyle: lightTextTheme.bodyText2!
            .merge(TextStyle(color: Color(0xff495057))),
      ),
      bottomAppBarTheme:
          BottomAppBarTheme(color: Color(0xffffffff), elevation: 2),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Color(0xff495057),
        labelColor: Color(0xff3d63ff),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Color(0xff3d63ff), width: 2.0),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: Color(0xff3d63ff),
        inactiveTrackColor: Color(0xff3d63ff).withAlpha(140),
        trackShape: RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbColor: Color(0xff3d63ff),
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
        tickMarkShape: RoundSliderTickMarkShape(),
        inactiveTickMarkColor: Colors.red[100],
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      radioTheme: RadioThemeData(),
      unselectedWidgetColor: Colors.blue);
  static final ThemeData putihTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      canvasColor: Colors.white,
      backgroundColor: Color(0xfff6f6f6),
      scaffoldBackgroundColor: Color(0xfff6f6f6),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        textTheme: lightAppBarTextTheme,
        actionsIconTheme: IconThemeData(
          color: Color(0xff495057),
        ),
        color: Color(0xff008199),
        iconTheme: IconThemeData(color: Colors.white, size: 24),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        minimumSize: Size(340, 60),
        onPrimary: Colors.white,
        primary: Color(0xFF008199),
        padding: EdgeInsets.only(left: 37, right: 37),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
        ),
      )),
      navigationRailTheme: NavigationRailThemeData(
          selectedIconTheme:
              IconThemeData(color: Color(0xff3d63ff), opacity: 1, size: 24),
          unselectedIconTheme:
              IconThemeData(color: Color(0xff495057), opacity: 1, size: 24),
          backgroundColor: Color(0xffffffff),
          elevation: 3,
          selectedLabelTextStyle: TextStyle(color: Color(0xff3d63ff)),
          unselectedLabelTextStyle: TextStyle(color: Color(0xff495057))),
      colorScheme: ColorScheme.light(
          primary: Color(0xff3d63ff),
          onPrimary: Colors.white,
          primaryVariant: Color(0xff0055ff),
          secondary: Color(0xff495057),
          secondaryVariant: Color(0xff3cd278),
          onSecondary: Colors.white,
          surface: Color(0xffe2e7f1),
          background: Color(0xfff3f4f7),
          onBackground: Color(0xff495057)),
      cardTheme: CardTheme(
        color: Colors.white,
        shadowColor: Colors.black,
        elevation: 20,
        margin: EdgeInsets.all(3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          fontSize: 17,
          color: Color(0xFF333333).withOpacity(0.415),
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.red, width: 1.0)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.red, width: 1.0)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
                color: const Color(0xFF27394E).withOpacity(0.2), width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: const Color(0xFF008199), width: 2.0)),
      ),
      splashColor: Colors.white.withAlpha(100),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: lightTextTheme,
      indicatorColor: Colors.white,
      disabledColor: Color(0xffdcc7ff),
      highlightColor: Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xff3d63ff),
          splashColor: Colors.white.withAlpha(100),
          highlightElevation: 8,
          elevation: 4,
          focusColor: Color(0xff3d63ff),
          hoverColor: Color(0xff3d63ff),
          foregroundColor: Colors.white),
      dividerColor: Color(0xffd1d1d1),
      errorColor: Color(0xfff0323c),
      cardColor: Colors.white,
      // accentColor: Color(0xff3d63ff),//original
      accentColor: Color(0xFF008199), //custombyadip
      popupMenuTheme: PopupMenuThemeData(
        color: Color(0xffffffff),
        textStyle: lightTextTheme.bodyText2!
            .merge(TextStyle(color: Color(0xff495057))),
      ),
      bottomAppBarTheme:
          BottomAppBarTheme(color: Color(0xffffffff), elevation: 2),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Color(0xff495057),
        labelColor: Color(0xff3d63ff),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Color(0xff3d63ff), width: 2.0),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: Color(0xff3d63ff),
        inactiveTrackColor: Color(0xff3d63ff).withAlpha(140),
        trackShape: RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbColor: Color(0xff3d63ff),
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
        tickMarkShape: RoundSliderTickMarkShape(),
        inactiveTickMarkColor: Colors.red[100],
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      radioTheme: RadioThemeData(),
      unselectedWidgetColor: Colors.blue);

  static ThemeData getThemeFromThemeMode(int themeMode) {
    return lightTheme;
  }

  static NavigationBarTheme getNavigationThemeFromMode(int themeMode) {
    // print(themeMode);
    NavigationBarTheme navigationBarTheme = NavigationBarTheme();
    if (themeMode == themeLight) {
      navigationBarTheme.backgroundColor = Colors.white;
      navigationBarTheme.selectedItemColor = Color(0xff3d63ff);
      navigationBarTheme.unselectedItemColor = Color(0xff495057);
      navigationBarTheme.selectedOverlayColor = Color(0x383d63ff);
      return navigationBarTheme;
    } else if (themeMode == themeDark) {
      navigationBarTheme.backgroundColor = Color(0xff37404a);
      navigationBarTheme.selectedItemColor = Color(0xff37404a);
      navigationBarTheme.unselectedItemColor = Color(0xffd1d1d1);
      navigationBarTheme.selectedOverlayColor = Color(0xffffffff);
      return navigationBarTheme;
    } else if (themeMode == putihTheme) {
      navigationBarTheme.backgroundColor = Colors.white;
      navigationBarTheme.selectedItemColor = Colors.white;
      navigationBarTheme.unselectedItemColor = Colors.white;
      navigationBarTheme.selectedOverlayColor = Colors.white;
      return navigationBarTheme;
    }
    return navigationBarTheme;
  }
}

class CustomAppTheme {
  final Color bgLayer1,
      bgLayer2,
      bgLayer3,
      bgLayer4,
      border1,
      border2,
      disabledColor,
      onDisabled,
      colorInfo,
      colorWarning,
      colorSuccess,
      colorError,
      shadowColor,
      onInfo,
      onWarning,
      onSuccess,
      onError,
      shimmerBaseColor,
      shimmerHighlightColor;

  final Color groceryBg1, groceryBg2;
  final Color groceryPrimary, groceryOnPrimary;

  final Color medicarePrimary, medicareOnPrimary;

  final Color cookifyPrimary, cookifyOnPrimary;

  final Color lightBlack,
      red,
      green,
      yellow,
      orange,
      blue,
      purple,
      pink,
      brown,
      violet,
      indigo;

  final Color estatePrimary,
      estateOnPrimary,
      estateSecondary,
      estateOnSecondary;

  final Color homemadePrimary,
      homemadeSecondary,
      homemadeOnPrimary,
      homemadeOnSecondary;

  CustomAppTheme({
    this.border1 = const Color(0xffeeeeee),
    this.border2 = const Color(0xffe6e6e6),
    this.bgLayer1 = const Color(0xffffffff),
    this.bgLayer2 = const Color(0xfff8faff),
    this.bgLayer3 = const Color(0xfff8f8f8),
    this.bgLayer4 = const Color(0xffdcdee3),
    this.disabledColor = const Color(0xffdcc7ff),
    this.onDisabled = const Color(0xffffffff),
    this.colorWarning = const Color(0xffffc837),
    this.colorInfo = const Color(0xffff784b),
    this.colorSuccess = const Color(0xff3cd278),
    this.shadowColor = const Color(0xff1f1f1f),
    this.onInfo = const Color(0xffffffff),
    this.onWarning = const Color(0xffffffff),
    this.onSuccess = const Color(0xffffffff),
    this.colorError = const Color(0xfff0323c),
    this.onError = const Color(0xffffffff),
    this.shimmerBaseColor = const Color(0xFFF5F5F5),
    this.shimmerHighlightColor = const Color(0xFFE0E0E0),
    //Grocery color scheme

    this.groceryPrimary = const Color(0xff10bb6b),
    this.groceryOnPrimary = const Color(0xffffffff),
    this.groceryBg1 = const Color(0xfffbfbfb),
    this.groceryBg2 = const Color(0xfff5f5f5),

    //Cookify
    this.cookifyPrimary = const Color(0xffdf7463),
    this.cookifyOnPrimary = const Color(0xffffffff),

    //Color
    this.lightBlack = const Color(0xffa7a7a7),
    this.red = const Color(0xffFF0000),
    this.green = const Color(0xff008000),
    this.yellow = const Color(0xfffff44f),
    this.orange = const Color(0xffFFA500),
    this.blue = const Color(0xff0000ff),
    this.purple = const Color(0xff800080),
    this.pink = const Color(0xffFFC0CB),
    this.brown = const Color(0xffA52A2A),
    this.indigo = const Color(0xff4B0082),
    this.violet = const Color(0xff9400D3),

    //Medicare Color Scheme
    this.medicarePrimary = const Color(0xff6d65df),
    this.medicareOnPrimary = const Color(0xffffffff),

    //Estate Color Scheme
    this.estatePrimary = const Color(0xff1c8c8c),
    this.estateOnPrimary = const Color(0xffffffff),
    this.estateSecondary = const Color(0xfff15f5f),
    this.estateOnSecondary = const Color(0xffffffff),

    //Homemade Color Scheme
    this.homemadePrimary = const Color(0xffc5558e),
    this.homemadeSecondary = const Color(0xffCC9D60),
    this.homemadeOnPrimary = const Color(0xffffffff),
    this.homemadeOnSecondary = const Color(0xffffffff),
  });

  //--------------------------------------  Custom App Theme ----------------------------------------//

  static final CustomAppTheme lightCustomAppTheme = CustomAppTheme(
      bgLayer1: Color(0xffffffff),
      bgLayer2: Color(0xfff9f9f9),
      bgLayer3: Color(0xffe8ecf4),
      bgLayer4: Color(0xffdcdee3),
      disabledColor: Color(0xff636363),
      onDisabled: Color(0xffffffff),
      colorInfo: Color(0xffff784b),
      colorWarning: Color(0xffffc837),
      colorSuccess: Color(0xff3cd278),
      shadowColor: Color(0xffd9d9d9),
      onInfo: Color(0xffffffff),
      onSuccess: Color(0xffffffff),
      onWarning: Color(0xffffffff),
      colorError: Color(0xfff0323c),
      onError: Color(0xffffffff),
      shimmerBaseColor: Color(0xFFF5F5F5),
      shimmerHighlightColor: Color(0xFFE0E0E0));

  static final CustomAppTheme darkCustomAppTheme = CustomAppTheme(
      bgLayer1: Color(0xff212429),
      bgLayer2: Color(0xff282930),
      bgLayer3: Color(0xff303138),
      bgLayer4: Color(0xff383942),
      border1: Color(0xff303030),
      border2: Color(0xff363636),
      disabledColor: Color(0xffbababa),
      onDisabled: Color(0xff000000),
      colorInfo: Color(0xffff784b),
      colorWarning: Color(0xffffc837),
      colorSuccess: Color(0xff3cd278),
      shadowColor: Color(0xff202020),
      onInfo: Color(0xffffffff),
      onSuccess: Color(0xffffffff),
      onWarning: Color(0xffffffff),
      colorError: Color(0xfff0323c),
      onError: Color(0xffffffff),
      shimmerBaseColor: Color(0xFF1a1a1a),
      shimmerHighlightColor: Color(0xFF454545),

      //Grocery Dark
      groceryBg1: Color(0xff212429),
      groceryBg2: Color(0xff282930));
}

class NavigationBarTheme {
  Color? backgroundColor,
      selectedItemIconColor,
      selectedItemTextColor,
      selectedItemColor,
      selectedOverlayColor,
      unselectedItemIconColor,
      unselectedItemTextColor,
      unselectedItemColor;
}
