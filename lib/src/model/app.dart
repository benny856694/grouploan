import 'package:group_loan/src/model/group.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AppState {
  final groups = <Group>[].inj();
  final counter = 0.inj();

  void addGroup(Group group) {
    groups.state.add(group);
    groups.notify();
  }

  void removeGroup(Group group) {
    groups.state.remove(group);
    groups.notify();
  }

  void updateGroup(Group group) {
    groups.notify();
  }
}
