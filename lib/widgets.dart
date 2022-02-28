import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kokodap/farm_data_collection.dart';
import 'package:kokodap/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget displayFarmCount(BuildContext context) {
  return StreamBuilder<dynamic>(
    stream: getfarmCountStream(),
    builder: (context, visitSnapshot) {
      if (visitSnapshot.hasData) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'Farm Count : ${visitSnapshot.data}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 24,
              ),
            ),
          ),
        );
      } else {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'No Farms Visited',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 24,
              ),
            ),
          ),
        );
      }
    },
  );
}

Widget displayForm(BuildContext context, farmFormKey, getFarmName, currentDate,
    currentTime, currentLocation) {
  return Form(
    key: farmFormKey,
    child: CupertinoFormSection.insetGrouped(
      header: Text(
        'Kokodap',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 15,
          color: CupertinoColors.black,
        ),
      ),
      children: [
        CupertinoFormRow(
          child: CupertinoTextFormFieldRow(
            prefix: const Text('Farm Name'),
            textAlign: TextAlign.center,
            autofocus: true,
            controller: getFarmName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter farm name';
              }
            },
          ),
        ),
        CupertinoFormRow(
          child: CupertinoTextFormFieldRow(
            prefix: const Text('Date'),
            textAlign: TextAlign.center,
            readOnly: true,
            initialValue: currentDate,
          ),
        ),
        CupertinoFormRow(
          child: CupertinoTextFormFieldRow(
            prefix: const Text('Time'),
            textAlign: TextAlign.center,
            readOnly: true,
            initialValue: currentTime,
          ),
        ),
        CupertinoFormRow(
          child: CupertinoTextFormFieldRow(
            prefix: const Text('Location'),
            textAlign: TextAlign.center,
            readOnly: true,
            initialValue: currentLocation,
          ),
        ),
      ],
    ),
  );
}

Widget displayFormButton(
    BuildContext context,
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
    listLongitude) {
  return Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CupertinoButton.filled(
          child: Text(
            'Export',
            style: TextStyle(
              fontSize: MediaQuery.textScaleFactorOf(context) * 15,
            ),
          ),
          onPressed: () async {
            SharedPreferences localstorage = await prefs;
            if (localstorage.getStringList('farmName') == null) {
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text('Export Error'),
                  content: const Text('No Data stored'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('close'),
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            } else {
              createCsv(
                localstorage.getStringList('farmName'),
                localstorage.getStringList('date'),
                localstorage.getStringList('time'),
                localstorage.getStringList('latitude'),
                localstorage.getStringList('longitude'),
                localstorage.getString('fieldExecutive'),
              );
            }
          },
        ),
        CupertinoButton.filled(
          child: Text(
            'Submit',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 24,
            ),
          ),
          onPressed: () async {
            SharedPreferences localstorage = await prefs;
            if (farmFormKey.currentState!.validate()) {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(9),
                    child: CupertinoActionSheet(
                      title: Text(
                        'Farm Details',
                        style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: MediaQuery.of(context).size.width / 24,
                        ),
                      ),
                      message: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Field Executive : ${localstorage.getString('fieldExecutive')}',
                              style: TextStyle(
                                color: CupertinoColors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width / 24,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Farm Name : ${getFarmName.text}',
                              style: TextStyle(
                                color: CupertinoColors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width / 24,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Date : $currentDate',
                              style: TextStyle(
                                color: CupertinoColors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width / 24,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Time : $currentTime',
                              style: TextStyle(
                                color: CupertinoColors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width / 24,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Location : ${locationSnapshot.data[0]} ${locationSnapshot.data[1]}',
                              style: TextStyle(
                                color: CupertinoColors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width / 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        CupertinoActionSheetAction(
                          child: const Text('Save'),
                          onPressed: () async {
                            SharedPreferences localstorage = await prefs;
                            listFarmName.add(getFarmName.text.toString());
                            listDate.add(currentDate.toString());
                            listTime.add(currentTime.toString());
                            listLatitude
                                .add(locationSnapshot.data[0].toString());
                            listLongitude
                                .add(locationSnapshot.data[1].toString());
                            await localstorage.setStringList(
                                'farmName', listFarmName);
                            await localstorage.setStringList('date', listDate);
                            await localstorage.setStringList('time', listTime);
                            await localstorage.setStringList(
                                'latitude', listLatitude);
                            await localstorage.setStringList(
                                'longitude', listLongitude);
                            getFarmName.clear();
                            Navigator.pop(context);
                            showCupertinoDialog<void>(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoAlertDialog(
                                title: const Text('Submitted'),
                                content: const Text('Farm Data stored'),
                                actions: <CupertinoDialogAction>[
                                  CupertinoDialogAction(
                                    child: const Text('close'),
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: CupertinoColors.systemRed,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    ),
  );
}

Widget displayExecutiveForm(
    BuildContext context, executiveFormKey, getExecutiveName, prefs) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: CupertinoButton.filled(
      child: const Text('Get Started'),
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                color: CupertinoColors.systemGroupedBackground,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: executiveFormKey,
                      child: CupertinoFormSection.insetGrouped(
                        header: Center(
                          child: Text(
                            'Enter Executive Name',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 15,
                              color: CupertinoColors.black,
                            ),
                          ),
                        ),
                        children: [
                          CupertinoFormRow(
                            child: CupertinoTextFormFieldRow(
                              autofocus: true,
                              textAlign: TextAlign.center,
                              placeholder: 'Executive name',
                              controller: getExecutiveName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoButton.filled(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 24,
                        ),
                      ),
                      onPressed: () async {
                        if (executiveFormKey.currentState!.validate()) {
                          SharedPreferences localStorage = await prefs;
                          localStorage.setString(
                              'fieldExecutive', getExecutiveName.text);
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const farmDatacollection(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
