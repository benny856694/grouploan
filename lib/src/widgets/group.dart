import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_loan/src/app.dart';
import 'package:group_loan/src/helper.dart';
import 'package:group_loan/src/model/group.dart';
import 'package:group_loan/constants.dart';
import 'package:group_loan/src/model/group_repository.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../model/app.dart';

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
    final registrationDate =
        RM.injectFormField<DateTime>(group?.registrationDate ?? DateTime.now());

    Group _getGroup() {
      return Group(
        id: group?.id ?? appState.groups.getRepoAs<GroupRepository>().nextDocId,
        name: nameEditController.text,
        phoneNumber: phoneNumberEditController.text,
        leaderName: leaderNameEditController.text,
        accountNumber: accountNumberEditController.text,
        longitude: double.tryParse(longitudeEditController.text),
        latitude: double.tryParse(latitudeEditController.text),
        registrationDate: registrationDate.value,
      );
    }

    final form = RM.injectForm();
    final _isRequestingLocation = false.inj();

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
          OnFormFieldBuilder<DateTime>(
            listenTo: registrationDate,
            builder: (value, onChanged) {
              value.log();
              return DateTimePicker(
                key: ValueKey(value),
                type: DateTimePickerType.date,
                initialValue: value.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Registration Date',
                timeLabelText: "Hour",
                onChanged: (s) {
                  onChanged(DateTime.parse(s));
                },
              );
            },
          ),
          const SizedBox(
            height: 32,
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
                          onPressed: () async {
                            final gp = _getGroup();
                            await appState.groups.crud.create(gp);
                            myNavigator.back();
                          },
                          child: const Text('Add'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            form.submit(() async {
                              final gp = _getGroup();
                              await appState.groups.crud.update(
                                  where: (g) => g.id == group!.id,
                                  set: (g) => gp);
                              myNavigator.back();
                            });
                          },
                          child: const Text('OK'),
                        ),
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
                          child: const Text('Add More'),
                          onPressed: () async {
                            final gp = _getGroup();
                            await appState.groups.crud.create(gp);
                            form.reset();
                            registrationDate.value =
                                gp.registrationDate ?? DateTime.now();
                          })
                      : ElevatedButton(
                          child: const Text('Canel'),
                          onPressed: () {
                            myNavigator.back();
                          }),
                ),
              ),
              if (group == null) ...[
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () async {
                      myNavigator.back();
                    },
                  ),
                ),
              ],
            ],
          )
        ],
      ),
    );
  }
}
