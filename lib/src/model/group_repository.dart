import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'group.dart';

class GroupParam {
  final int? countToRead;
  final String? id;
  final String? name;
  GroupParam({this.id, this.name, this.countToRead});
}

class GroupRepository implements ICRUD<Group, GroupParam> {
  late final CollectionReference<Map<String, dynamic>> _groupsCollection;

  @override
  Future<Group> create(Group item, GroupParam? param) async {
    final group = await _groupsCollection.add(item.toMap());
    item.id = group.id;
    return item;
  }

  @override
  Future delete(List<Group> items, GroupParam? param) async {
    for (final item in items) {
      await _groupsCollection.doc(item.id).delete();
    }
  }

  @override
  void dispose() {}

  @override
  Future<void> init() async {
    _groupsCollection = FirebaseFirestore.instance.collection('groups');
  }

  @override
  Future<List<Group>> read(GroupParam? param) async {
    final query = _groupsCollection.orderBy(
      'registrationDate',
      descending: true,
    );
    if (param?.name != null) {
      query.where('name', arrayContains: param!.name!);
    }
    if (param?.countToRead != null) {
      query.limit(param!.countToRead!);
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map(
          (doc) => Group.fromMap(
            doc.data(),
          )..id = doc.id,
        )
        .toList();
  }

  @override
  Future update(List<Group> items, GroupParam? param) async {
    for (final item in items) {
      await _groupsCollection.doc(item.id).update(item.toMap());
    }
  }
}
