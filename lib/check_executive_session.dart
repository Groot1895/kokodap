import 'package:flutter/cupertino.dart';
import 'package:kokodap/functions.dart';
import 'package:kokodap/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class checkExecutiveSession extends StatefulWidget {
  const checkExecutiveSession({Key? key}) : super(key: key);

  @override
  _checkExecutiveSessionState createState() => _checkExecutiveSessionState();
}

class _checkExecutiveSessionState extends State<checkExecutiveSession> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  TextEditingController getExecutiveName = TextEditingController();
  final executiveFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkExecutive(context, prefs);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Kokodap',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 6,
              ),
            ),
          ),
          displayExecutiveForm(
            context,
            executiveFormKey,
            getExecutiveName,
            prefs,
          ),
        ],
      ),
    );
  }
}
