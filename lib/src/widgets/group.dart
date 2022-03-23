import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_loan/src/model/group.dart';
import 'package:group_loan/constants.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class GroupEdit extends StatelessWidget {
  const GroupEdit({
    Key? key,
    this.group,
  }) : super(key: key);
  final Group? group;

  @override
  Widget build(BuildContext context) {
    final nameEditController = RM.injectTextEditing(text: group?.name ?? '');
    final phoneNumberEditController =
        RM.injectTextEditing(text: group?.phoneNumber ?? '');
    final leaderNameEditController =
        RM.injectTextEditing(text: group?.leaderName ?? '');
    final accountNumberEditController =
        RM.injectTextEditing(text: group?.accountNumber ?? '');
    final longitudeEditController =
        RM.injectTextEditing(text: group?.longitude?.toString() ?? '');
    final latitudeEditController =
        RM.injectTextEditing(text: group?.latitude?.toString() ?? '');
    final form = RM.injectForm();
    final _isRequestingLocation = false.inj();
    DateTime? registrationDate = DateTime.now();
    var nameFocusNode = FocusNode();
    return OnFormBuilder(
      listenTo: form,
      builder: () => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            focusNode: nameFocusNode,
            autofocus: true,
            controller: nameEditController.controller,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: accountNumberEditController.controller,
            decoration: const InputDecoration(
              labelText: 'Account No.',
            ),
          ),
          TextField(
            controller: leaderNameEditController.controller,
            decoration: const InputDecoration(
              labelText: 'Leader Name',
            ),
          ),
          TextField(
            controller: phoneNumberEditController.controller,
            decoration: const InputDecoration(
              labelText: Constants.labelTel,
            ),
          ),
          Row(
            children: [
              //latitude text field
              Expanded(
                child: TextField(
                  controller: latitudeEditController.controller,
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              //longitude text field
              Expanded(
                child: TextField(
                  controller: longitudeEditController.controller,
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                  ),
                ),
              ),
              OnReactive(() {
                if (_isRequestingLocation.state) {
                  return const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                } else {
                  return IconButton(
                    icon: const FaIcon(FontAwesomeIcons.locationArrow),
                    onPressed: () async {
                      _isRequestingLocation.toggle();

                      try {
                        var location = await appState.getLocation();

                        if (location?.longitude != null) {
                          longitudeEditController.controller.text =
                              //4 digit precision
                              location!.longitude!.toStringAsFixed(4);
                          latitudeEditController.controller.text =
                              location.latitude!.toStringAsFixed(4);
                        }
                      } catch (e) {
                        RM.scaffold.showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      } finally {
                        _isRequestingLocation.toggle();
                      }
                    },
                  );
                }
              }),

              //icon button to show in map
              if (longitudeEditController.text.isNotEmpty)
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.mapMarkedAlt),
                  onPressed: () async {
                    var url =
                        'https://www.google.com/maps/search/?api=1&query=${latitudeEditController.text},${longitudeEditController.text}';
                    await launch(url);
                  },
                ),
            ],
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
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: OnFormSubmissionBuilder(
                  listenTo: form,
                  onSubmitting: () => const CircularProgressIndicator(),
                  child: group == null
                      ? ElevatedButton(
                          onPressed: () {}, child: const Text('Create'))
                      : ElevatedButton(
                          onPressed: () {}, child: const Text('OK')),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: OnFormSubmissionBuilder(
                  listenTo: form,
                  onSubmitting: () => const CircularProgressIndicator(),
                  child: group == null
                      ? ElevatedButton(
                          child: const Text('Create & More'),
                          onPressed: () {
                            form.submit();
                          })
                      : ElevatedButton(
                          child: const Text('Canel'), onPressed: () {}),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
