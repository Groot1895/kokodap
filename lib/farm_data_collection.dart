import 'package:flutter/cupertino.dart';
import 'package:kokodap/functions.dart';
import 'package:kokodap/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class farmDatacollection extends StatefulWidget {
  const farmDatacollection({Key? key}) : super(key: key);

  @override
  _farmDatacollectionState createState() => _farmDatacollectionState();
}

class _farmDatacollectionState extends State<farmDatacollection> {
  TextEditingController getFarmName = TextEditingController();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final farmFormKey = GlobalKey<FormState>();
  late String currentLocation;
  late String latitude;
  late String longitude;
  List<String> listFieldExecutive = [];
  List<String> listFarmName = [];
  List<String> listDate = [];
  List<String> listTime = [];
  List<String> listLatitude = [];
  List<String> listLongitude = [];

  @override
  Widget build(BuildContext context) {
    String currentDate = DateTime.now().day.toString() +
        '/' +
        DateTime.now().month.toString() +
        '/' +
        DateTime.now().year.toString();
    String currentTime = DateTime.now().hour.toString() +
        ' : ' +
        DateTime.now().minute.toString();
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: Column(
          children: [
            displayFarmCount(context),
            FutureBuilder<dynamic>(
              future: getLocation(),
              builder: (context, locationSnapshot) {
                if (locationSnapshot.hasData) {
                  currentLocation = locationSnapshot.data[0].toString() +
                      ' ' +
                      locationSnapshot.data[1].toString();
                  return Column(
                    children: [
                      displayForm(
                        context,
                        farmFormKey,
                        getFarmName,
                        currentDate,
                        currentTime,
                        currentLocation,
                      ),
                      displayFormButton(
                        context,
                        prefs,
                        farmFormKey,
                        getFarmName,
                        currentDate,
                        currentTime,
                        locationSnapshot,
                        listFarmName,
                        listDate,
                        listTime,
                        listLatitude,
                        listLongitude,
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
