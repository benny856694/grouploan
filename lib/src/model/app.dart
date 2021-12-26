import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group_loan/src/model/group.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AppState {
  late final CollectionReference<Map<String, dynamic>> groupsRef;
  final groups = <Group>[].inj();
  final counter = 0.inj();

  AppState() : groupsRef = FirebaseFirestore.instance.collection('groups');

  Future<List<Group>> addGroup(Group group) {
    return groups.setState(
      (s) async {
        var doc = await groupsRef.add(group.toMap());
        group.id = doc.id;
        return [...s, group];
      },
    );
  }

  void removeGroup(Group group) {
    groups.setState((s) async {
      await groupsRef.doc(group.id).delete();
      return s.where((g) => g.id != group.id).toList();
    });
  }

  void updateGroup(Group group) {
    groups.setState((s) async {
      await groupsRef.doc(group.id).update(group.toMap());
      return s.map((g) => g.id == group.id ? group : g).toList();
    });
  }

  void loadGroups() {
    if (groups.state.isEmpty) {
      groups.setState((s) async {
        var snapshot = await groupsRef.limit(20).get();
        return snapshot.docs.map((doc) {
          var g = Group.fromMap(doc.data());
          g.id = doc.id;
          return g;
        }).toList();
      });
    }
  }
}
