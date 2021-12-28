import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_loan/src/model/group.dart';
import 'package:location/location.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AppState {
  final groups = RM.inject<List<Group>>(
    () => [],
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

  late final CollectionReference<Map<String, dynamic>> _groupsRef;

  AppState() : _groupsRef = FirebaseFirestore.instance.collection('groups');

  Future<List<Group>> addGroup(Group group) {
    return groups.setState(
      (s) async {
        var doc = await _groupsRef.add(group.toMap());
        group.id = doc.id;
        return [...s, group];
      },
    );
  }

  void removeGroup(Group group) {
    groups.setState((s) async {
      await _groupsRef.doc(group.id).delete();
      return s.where((g) => g.id != group.id).toList();
    });
  }

  void updateGroup(Group group) {
    groups.setState((s) async {
      await _groupsRef.doc(group.id).update(group.toMap());
      return s.map((g) => g.id == group.id ? group : g).toList();
    });
  }

  void loadGroups() {
    if (groups.state.isEmpty) {
      groups.setState((s) async {
        var snapshot = await _groupsRef.limit(20).get();
        return snapshot.docs.map((doc) {
          var g = Group.fromMap(doc.data());
          g.id = doc.id;
          return g;
        }).toList();
      });
    }
  }

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
}
