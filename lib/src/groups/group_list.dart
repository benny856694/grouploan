import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:download/download.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_loan/constants.dart';
import 'package:group_loan/main.dart';
import 'package:group_loan/src/app.dart';
import 'package:group_loan/src/model/group.dart';
import 'package:group_loan/src/widgets/empty.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);
  static const String routeName = Constants.groupRoute;
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  var nameEditController = TextEditingController();
  var phoneNumberEditController = TextEditingController();
  var leaderNameEditController = TextEditingController();
  var accountNumberEditController = TextEditingController();
  var longitudeEditController = TextEditingController();
  var latitudeEditController = TextEditingController();
  DateTime? registrationDate = DateTime.now();
  var nameFocusNode = FocusNode();
  var isEdit = false;
  var _isGettingLocation = false;
  final selectedGroup = <Group>[].inj();

  void clear() {
    nameEditController.clear();
    accountNumberEditController.clear();
    leaderNameEditController.clear();
    phoneNumberEditController.clear();
    latitudeEditController.clear();
    longitudeEditController.clear();
    _isGettingLocation = false;
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
      if (group.latitude != null) {
        latitudeEditController.text = group.latitude.toString();
      }
      if (group.longitude != null) {
        longitudeEditController.text = group.longitude.toString();
      }
    }

    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Row(
          children: [
            Text(
              isEdit ? Constants.labelEditGroup : Constants.labelAddGroup,
            ),
          ],
        ),
        content: Stack(
          children: [
            SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      focusNode: nameFocusNode,
                      autofocus: true,
                      controller: nameEditController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      controller: accountNumberEditController,
                      decoration: const InputDecoration(
                        labelText: 'Account No.',
                      ),
                    ),
                    TextField(
                      controller: leaderNameEditController,
                      decoration: const InputDecoration(
                        labelText: 'Leader Name',
                      ),
                    ),
                    TextField(
                      controller: phoneNumberEditController,
                      decoration: const InputDecoration(
                        labelText: Constants.labelTel,
                      ),
                    ),
                    DateTimePicker(
                      type: DateTimePickerType.date,
                      initialValue: registrationDate.toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Registration Date',
                      timeLabelText: "Hour",
                      onChanged: (value) {
                        registrationDate = DateTime.parse(value);
                      },
                      onSaved: (val) {
                        registrationDate = DateTime.parse(val!);
                      },
                    ),
                    Row(
                      children: [
                        //latitude text field
                        Expanded(
                          child: TextField(
                            controller: latitudeEditController,
                            decoration: const InputDecoration(
                              labelText: 'Latitude',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        //longitude text field
                        Expanded(
                          child: TextField(
                            controller: longitudeEditController,
                            decoration: const InputDecoration(
                              labelText: 'Longitude',
                            ),
                          ),
                        ),
                        //icon button to get location
                        if (!_isGettingLocation)
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.locationArrow),
                            onPressed: () async {
                              setState(() {
                                _isGettingLocation = true;
                              });
                              try {
                                var location = await appState.getLocation();
                                setState(() {
                                  _isGettingLocation = false;
                                  if (location?.longitude != null) {
                                    longitudeEditController.text =
                                        //4 digit precision
                                        location!.longitude!.toStringAsFixed(4);
                                    latitudeEditController.text =
                                        location.latitude!.toStringAsFixed(4);
                                  }
                                });
                              } catch (e) {
                                RM.scaffold.showSnackBar(SnackBar(
                                  content: Text(e.toString()),
                                ));
                              } finally {
                                setState(() {
                                  _isGettingLocation = false;
                                });
                              }
                            },
                          )
                        else
                          const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        //icon button to show in map
                        if (longitudeEditController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.mapMarkedAlt),
                            onPressed: () async {
                              var url =
                                  'https://www.google.com/maps/search/?api=1&query=${latitudeEditController.text},${longitudeEditController.text}';
                              await launch(url);
                            },
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            OnReactive(
              () {
                if (appState.groups.isWaiting) {
                  return Positioned.fill(
                    child: Container(
                      color: Theme.of(context)
                          .dialogBackgroundColor
                          .withOpacity(0.8),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        actions: <Widget>[
          if (!isEdit)
            _buildCreateButton(
              onPressed: () async {
                var group = _getGroup()..id = appState.nextGroupId;
                await appState.groups.crud.create(
                  group,
                );
                if (!appState.groups.hasError) {
                  Navigator.pop(context);
                }
              },
            ),
          if (!isEdit)
            _buildCreateButton(
              isCreateMore: true,
              onPressed: () async {
                var group = _getGroup()..id = appState.nextGroupId;
                await appState.groups.crud.create(
                  group,
                );
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
                appState.groups.crud.update(
                  where: (gp) => gp.id == group.id,
                  set: (gp) => gp.copyWith(
                    name: g.name,
                    accountNumber: g.accountNumber,
                    leaderName: g.leaderName,
                    phoneNumber: g.phoneNumber,
                    registrationDate: g.registrationDate,
                    latitude: g.latitude,
                    longitude: g.longitude,
                  ),
                );
              }
              myNavigator.back();
            },
          ),
          if (isEdit)
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                myNavigator.back();
              },
            ),
        ],
      ),
    );
  }

  Group _getGroup() {
    return Group(
      id: "",
      name: nameEditController.text,
      accountNumber: accountNumberEditController.text,
      registrationDate: registrationDate ?? DateTime.now(),
      leaderName: leaderNameEditController.text,
      phoneNumber: phoneNumberEditController.text,
      latitude: latitudeEditController.text.isNotEmpty
          ? double.parse(latitudeEditController.text)
          : null,
      longitude: longitudeEditController.text.isNotEmpty
          ? double.parse(longitudeEditController.text)
          : null,
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
  }

  @override
  Widget build(BuildContext context) {
    var deviceType = getDeviceType(MediaQuery.of(context).size);
    var navMenu = createNavMenus(context, selectedButton: Constants.groups);
    return Scaffold(
      // appBar: createAppBar(navMenu),
      // drawer: deviceType == DeviceScreenType.mobile
      //     ? createEndDrawer(navMenu, context)
      //     : null,
      body: ResponsiveBuilder(builder: (context, size) {
        if (size.isMobile) {
          return _groupListMobile(context);
        } else {
          return _groupListDesktop(context);
        }
      }),
      floatingActionButton: deviceType == DeviceScreenType.mobile
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return _buildGroupDialog(context);
                  },
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _groupListMobile(BuildContext context) {
    final ctx = context;
    return OnBuilder(
        listenTo: appState.groups,
        builder: () {
          //if empty
          if (appState.groups.state.isEmpty) {
            return const EmptyIndiator();
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                var group = appState.groups.state[index];
                var titleRow = <Widget>[];
                var name = group.name;
                if (group.accountNumber.isNotEmpty) {
                  name += ' | ${group.accountNumber}';
                }

                titleRow.add(
                  Text(
                    name,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                );
                var subtitle = <Widget>[];
                if (group.leaderName?.isNotEmpty == true) {
                  subtitle.add(
                    FaIcon(
                      FontAwesomeIcons.user,
                      color: Theme.of(context).hintColor,
                      size: 14,
                    ),
                  );
                  subtitle.add(const SizedBox(width: 4));
                  subtitle.add(
                    Text(group.leaderName!,
                        style: Theme.of(context).textTheme.subtitle2),
                  );
                }
                if (group.phoneNumber?.isNotEmpty == true) {
                  subtitle.add(
                    const SizedBox(
                      width: 8,
                    ),
                  );
                  subtitle.add(
                    FaIcon(
                      FontAwesomeIcons.phone,
                      color: Theme.of(context).hintColor,
                      size: 14,
                    ),
                  );
                  subtitle.add(const SizedBox(width: 4));
                  subtitle.add(
                    Text(group.phoneNumber!,
                        style: Theme.of(context).textTheme.subtitle2),
                  );
                }
                var subtitle2 = <Widget>[];
                if (group.registrationDate != null) {
                  subtitle2.add(
                    const SizedBox(
                      width: 4,
                    ),
                  );
                  subtitle2.add(
                    Text(Constants.dateFormat.format(group.registrationDate!),
                        style: Theme.of(context).textTheme.subtitle2),
                  );
                }

                if (group.latitude != null && group.longitude != null) {
                  subtitle2.add(
                    const SizedBox(
                      width: 8,
                    ),
                  );
                  subtitle2.add(
                    FaIcon(
                      FontAwesomeIcons.mapMarkerAlt,
                      color: Theme.of(context).hintColor,
                      size: 14,
                    ),
                  );
                }

                return InkWell(
                  onTap: () {},
                  child: Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        if (group.latitude != null && group.longitude != null)
                          SlidableAction(
                            icon: FontAwesomeIcons.mapMarkedAlt,
                            onPressed: (context) async {
                              var url = _getGoogleMapUrl(group);
                              await launch(url);
                            },
                          ),
                        SlidableAction(
                          icon: FontAwesomeIcons.edit,
                          onPressed: (context) {
                            _editGroup(context, group);
                          },
                        ),
                        SlidableAction(
                          foregroundColor: Colors.red,
                          icon: FontAwesomeIcons.trash,
                          onPressed: (context) async {
                            await _confirmDelete(ctx, [group], () {
                              appState.groups.crud
                                  .delete(where: (gp) => gp.id == group.id);
                              Navigator.of(ctx).pop();
                              RM.scaffold.showSnackBar(SnackBar(
                                content: Text('Group "${group.name}" deleted'),
                              ));
                            });
                          },
                        ),

                        //edit
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: titleRow,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: subtitle,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: appState.groups.state.length,
            );
          }
        });
  }

  Widget _groupListDesktop(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
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
                label: const Text(Constants.labelAddGroup),
                icon: const FaIcon(
                  FontAwesomeIcons.plus,
                  size: 16.0,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _downloadAsCsv(appState.groups.state);
                },
                label: const Text(Constants.labelDownloadAsCsv),
                icon: const FaIcon(
                  FontAwesomeIcons.fileDownload,
                  size: 16.0,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              OnBuilder(
                listenTo: selectedGroup,
                builder: () {
                  return ElevatedButton.icon(
                    onPressed: selectedGroup.state.isEmpty
                        ? null
                        : () async {
                            await _confirmDelete(context, selectedGroup.state,
                                () {
                              appState.groups.crud.delete(
                                where: (gp) => selectedGroup.state.contains(gp),
                              );
                              selectedGroup.setState((s) => <Group>[]);
                              myNavigator.back();
                            });
                          },
                    icon: const FaIcon(
                      FontAwesomeIcons.trash,
                      size: 16.0,
                      color: Colors.red,
                    ),
                    label: const Text("Delete"),
                  );
                },
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
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: OnBuilder(
              listenTo: appState.groups,
              builder: () {
                if (appState.groups.state.isEmpty) {
                  return const EmptyIndiator();
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: OnReactive(
                      () => DataTable(
                        showCheckboxColumn: true,
                        columns: [
                          DataColumn(
                            label: Text(
                              'Name',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                          DataColumn(
                              label: Text(
                            'Account No.',
                            style: Theme.of(context).textTheme.button,
                          )),
                          DataColumn(
                            label: Text(
                              'Leader Name',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              Constants.labelTel,
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Registration Date',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Action',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ],
                        rows: [
                          for (var group in appState.groups.state)
                            DataRow(
                              onSelectChanged: (b) {
                                if (b != null) {
                                  b
                                      ? selectedGroup.state.add(group)
                                      : selectedGroup.state.remove(group);
                                  selectedGroup.notify();
                                }
                              },
                              selected: selectedGroup.state.contains(group),
                              key: ValueKey(group.id),
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
                                      ? Constants.dateFormat
                                          .format(group.registrationDate!)
                                      : ''),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      if (group.latitude != null &&
                                          group.longitude != null)
                                        IconButton(
                                          icon: const FaIcon(
                                            FontAwesomeIcons.mapMarkedAlt,
                                            size: 16,
                                          ),
                                          onPressed: () async {
                                            String url =
                                                _getGoogleMapUrl(group);
                                            await launch(url);
                                          },
                                        ),
                                      IconButton(
                                        icon: const FaIcon(
                                          FontAwesomeIcons.edit,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          _editGroup(context, group);
                                        },
                                      ),
                                      IconButton(
                                        icon: const FaIcon(
                                          FontAwesomeIcons.trash,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _confirmDelete(context, [group], () {
                                            appState.groups.crud.delete(
                                              where: (gp) => gp == group,
                                            );
                                            selectedGroup.setState(
                                              (s) => s
                                                  .where((element) =>
                                                      element.id != group.id)
                                                  .toList(),
                                            );
                                            myNavigator.back();
                                          });
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getGoogleMapUrl(Group group) {
    var url =
        'https://www.google.com/maps/search/?api=1&query=${group.latitude},${group.longitude}';
    return url;
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
    List<Group> groups,
    void Function()? onConfirm,
  ) {
    return RM.navigate.toDialog(AlertDialog(
      title: const Text('Delete Group'),
      content: Text(
        groups.length == 1
            ? 'Are you sure you want to delete this group: "${groups.first.name}"?'
            : 'Are you sure you want to delete these groups?',
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Delete'),
          onPressed: onConfirm,
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            myNavigator.back();
          },
        ),
      ],
    ));
  }

  void _downloadAsCsv(List<Group> state) {
    //create title row
    var titleRow = List<String>.from([
      'Name',
      'Account Number',
      'Leader Name',
      'Phone Number',
      'Registration Date'
    ]);
    var lines = state.map((e) {
      //convert to list of string
      return [
        e.name,
        '="${e.accountNumber}"',
        e.leaderName,
        '="${e.phoneNumber}"',
        e.registrationDate != null
            ? Constants.dateFormat.format(e.registrationDate!)
            : ''
      ];
    }).toList();
    lines.insert(0, titleRow);

    var csv = const ListToCsvConverter().convert(lines);

    final stream = Stream.fromIterable(utf8.encode(csv));
    download(stream, 'Groups-Export.csv');
  }
}
