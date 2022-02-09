import 'package:flutter/material.dart';
import 'package:group_loan/src/model/group.dart';
import 'package:group_loan/src/model/group_repository.dart';
import 'package:location/location.dart';
import 'package:states_rebuilder/states_rebuilder.dart';



class AppState {
  final groups = RM.injectCRUD<Group, GroupParam>(
    () => GroupRepository(),
    param: () => GroupParam(countToRead: 20),
    readOnInitialization: true,
    sideEffects: SideEffects.onAll(
      onData: null,
      onWaiting: null,
      onError: (error, _) {
        RM.scaffold.showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
            ),
          ),
        );
      },
    ),
  );

  final _locator = Location();


  Future<LocationData?> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await _locator.serviceEnabled();
    permissionGranted = await _locator.hasPermission();
    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
      return await _locator.getLocation();
    } else {
      serviceEnabled = await _locator.requestService();
      if (serviceEnabled) {
        permissionGranted = await _locator.requestPermission();
        if (permissionGranted == PermissionStatus.granted) {
          return await _locator.getLocation();
        }
      }
    }

    return null;
  }

  String get nextGroupId => groups.getRepoAs<GroupRepository>().nextDocId;
}
