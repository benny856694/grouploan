import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_loan/src/model/group.dart';
import 'package:group_loan/constants.dart';

class GroupEdit extends StatelessWidget {
  const GroupEdit({
    Key? key,
    this.group,
    this.onSave,
  })  : _isEdit = group != null,
        super(key: key);
  final Group? group;
  final bool _isEdit;
  final void Function(Group)? onSave;

  @override
  Widget build(BuildContext context) {
    var nameEditController = TextEditingController();
    var phoneNumberEditController = TextEditingController();
    var leaderNameEditController = TextEditingController();
    var accountNumberEditController = TextEditingController();
    var longitudeEditController = TextEditingController();
    var latitudeEditController = TextEditingController();
    DateTime? registrationDate = DateTime.now();
    var nameFocusNode = FocusNode();
    return Column(
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
            if (false) // (!_isGettingLocation)
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.locationArrow),
                onPressed: () async {
                  // setState(() {
                  //   _isGettingLocation = true;
                  // });
                  // try {
                  //   var location = await appState.getLocation();
                  //   setState(() {
                  //     _isGettingLocation = false;
                  //     if (location?.longitude != null) {
                  //       longitudeEditController.text =
                  //           //4 digit precision
                  //           location!.longitude!.toStringAsFixed(4);
                  //       latitudeEditController.text =
                  //           location.latitude!.toStringAsFixed(4);
                  //     }
                  //   });
                  // } catch (e) {
                  //   RM.scaffold.showSnackBar(SnackBar(
                  //     content: Text(e.toString()),
                  //   ));
                  // } finally {
                  //   setState(() {
                  //     _isGettingLocation = false;
                  //   });
                  // }
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
                icon: const FaIcon(FontAwesomeIcons.locationArrow),
                onPressed: () async {
                  var url =
                      'https://www.google.com/maps/search/?api=1&query=${latitudeEditController.text},${longitudeEditController.text}';
                  //await launch(url);
                },
              ),
          ],
        )
      ],
    );
  }
}
