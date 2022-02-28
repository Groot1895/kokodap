import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kokodap/farm_data_collection.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Location location = Location();
late bool _serviceEnabled;
late PermissionStatus _permissionGranted;
late LocationData locationData;

localisationDelegates() {
  return [
    DefaultMaterialLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
    DefaultWidgetsLocalizations.delegate,
  ];
}

checkExecutive(context, prefs) async {
  SharedPreferences localStorage = await prefs;
  String? fieldExecutive = localStorage.getString('fieldExecutive');
  if (fieldExecutive != null) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => const farmDatacollection(),
      ),
      (route) => false,
    );
  }
}

getLocation() async {
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  locationData = await location.getLocation();
  return [locationData.latitude, locationData.longitude];
}

createCsv(farmname, date, time, lat, long, fieldExe) async {
  Directory directory = await getApplicationDocumentsDirectory();
  File file = File('${directory.path}/Kokodap.csv');
  if (farmname.length == date.length &&
      farmname.length == lat.length &&
      farmname.length == long.length &&
      farmname.length == time.length) {
    for (var i = 0; i < farmname.length; i++) {
      file.writeAsStringSync(
        "${farmname[i]}, ${date[i]}, ${time[i]}, ${lat[i]}, ${long[i]}, $fieldExe\r\n",
        mode: FileMode.append,
      );
    }
  }
  Share.shareFiles(['${directory.path}/Kokodap.csv']);
}

getfarmCount() async {
  SharedPreferences localstorage = await SharedPreferences.getInstance();
  return localstorage.getStringList('farmName')!.length;
}

Stream getfarmCountStream() async* {
  yield* Stream.periodic(
    const Duration(seconds: 1),
    (_) {
      return getfarmCount();
    },
  ).asyncMap(
    (value) async => await value,
  );
}
