import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:kokodap/check_executive_session.dart';
import 'package:kokodap/functions.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: CupertinoColors.systemGroupedBackground,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: CupertinoColors.systemGroupedBackground,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const Kokodap());
}

class Kokodap extends StatelessWidget {
  const Kokodap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: localisationDelegates(),
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
      ),
      home: const checkExecutiveSession(),
    );
  }
}
