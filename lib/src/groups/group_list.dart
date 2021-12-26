import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:group_loan/main.dart';
import 'package:group_loan/src/model/group.dart';
import 'package:intl/intl.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  var nameEditController = TextEditingController();
  var phoneNumberEditController = TextEditingController();
  var leaderNameEditController = TextEditingController();
  var accountNumberEditController = TextEditingController();
  DateTime? registrationDate = DateTime.now();
  var nameFocusNode = FocusNode();
  var isEdit = false;

  final firestore = FirebaseFirestore.instance;

  void clear() {
    nameEditController.clear();
    accountNumberEditController.clear();
    leaderNameEditController.clear();
    phoneNumberEditController.clear();
  }

  Widget _buildGroupDialog(
    BuildContext context, {
    Group? group,
  }) {
    clear();
    isEdit = group != null;
    registrationDate = group?.registrationDate ?? DateTime.now();

    if (isEdit) {
      nameEditController.text = group!.name;
      accountNumberEditController.text = group.accountNumber;
      if (group.leaderName != null) {
        leaderNameEditController.text = group.leaderName!;
      }
      if (group.phoneNumber != null) {
        phoneNumberEditController.text = group.phoneNumber!;
      }
    }

    return AlertDialog(
      title: Row(
        children: [
          Text(
            isEdit ? 'Edit Group' : 'Add Group',
          ),
          const SizedBox(
            width: 5,
          ),
          OnReactive(() {
            if (appState.groups.isWaiting) {
              return const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
            return const SizedBox.shrink();
          })
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              focusNode: nameFocusNode,
              autofocus: true,
              controller: nameEditController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
              ),
            ),
            TextField(
              controller: accountNumberEditController,
              decoration: const InputDecoration(
                labelText: 'Account Number',
              ),
            ),
            TextField(
              controller: leaderNameEditController,
              decoration: const InputDecoration(
                labelText: 'Group Leader',
              ),
            ),
            TextField(
              controller: phoneNumberEditController,
              decoration: const InputDecoration(
                labelText: 'Telephone Number',
              ),
            ),
            DateTimePicker(
              type: DateTimePickerType.date,
              initialValue: registrationDate.toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'Date of Registration',
              timeLabelText: "Hour",
              onChanged: (value) {
                registrationDate = DateTime.parse(value);
              },
              onSaved: (val) {
                registrationDate = DateTime.parse(val!);
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        if (!isEdit)
          _buildCreateButton(
            onPressed: () async {
              var group = _getGroup();
              await appState.addGroup(group);
              if (!appState.groups.hasError) {
                Navigator.pop(context);
              }
            },
          ),
        if (!isEdit)
          _buildCreateButton(
            isCreateMore: true,
            onPressed: () async {
              var group = _getGroup();
              await appState.addGroup(group);
              if (!appState.groups.hasError) {
                clear();
                nameFocusNode.requestFocus();
              }
            },
          ),
        TextButton(
          child: Text(!isEdit ? 'Cancel' : 'OK'),
          onPressed: () {
            var g = _getGroup();
            if (group != null) {
              g.id = group.id;
              appState.updateGroup(g);
            }
            Navigator.of(context).pop();
          },
        ),
        if (isEdit)
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }

  Group _getGroup() {
    return Group(
      "",
      nameEditController.text,
      accountNumberEditController.text,
      registrationDate: registrationDate ?? DateTime.now(),
      leaderName: leaderNameEditController.text,
      phoneNumber: phoneNumberEditController.text,
    );
  }

  Widget _buildCreateButton({
    bool isCreateMore = false,
    void Function()? onPressed,
    void Function()? postAction,
  }) {
    return OnReactive(
      () => TextButton(
        onPressed: appState.groups.isWaiting
            ? null
            : () {
                try {
                  onPressed?.call();
                  postAction?.call();
                } catch (e) {
                  RM.scaffold.showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
        child: Text(
          isCreateMore ? 'Create & More' : 'Create',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    appState.loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return _buildGroupDialog(context);
                  },
                );
              },
              label: const Text('Create Group'),
              icon: const Icon(Icons.add),
            ),
            const SizedBox(
              width: 8,
            ),
            OnReactive(
              () => appState.groups.onOrElse(
                onWaiting: () => const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                orElse: (s) => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: OnReactive(
            () => DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    'Group Name',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                DataColumn(
                    label: Text(
                  'Account Number',
                  style: Theme.of(context).textTheme.headline6,
                )),
                DataColumn(
                  label: Text(
                    'Group Leader',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Telephone  Number',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date of Registration',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Action',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
              rows: [
                for (var group in appState.groups.state)
                  DataRow(
                    cells: [
                      DataCell(
                        Text(group.name),
                      ),
                      DataCell(
                        Text(group.accountNumber),
                      ),
                      DataCell(
                        Text(group.leaderName ?? ""),
                      ),
                      DataCell(
                        Text(group.phoneNumber ?? ""),
                      ),
                      DataCell(
                        Text(group.registrationDate != null
                            ? DateFormat.yMMMd().format(group.registrationDate!)
                            : ''),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editGroup(context, group);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _confirmDelete(context, group);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _editGroup(BuildContext context, Group group) {
    return showDialog(
      context: context,
      builder: (context) {
        return _buildGroupDialog(
          context,
          group: group,
        );
      },
    );
  }

  Future<dynamic> _confirmDelete(
    BuildContext context,
    Group group,
  ) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete Group'),
          content: Text(
            'Are you sure you want to delete this group: "${group.name}"?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                appState.removeGroup(group);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
