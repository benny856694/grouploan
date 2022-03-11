import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:group_loan/src/app.dart';
import 'package:group_loan/src/auth/signin.dart';
import 'package:group_loan/src/staffs/staffs.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';
import '../../main.dart';
import '../groups/group_list.dart';
import '../helper.dart';
import '../widgets/navlink.dart';

class WebHome extends StatelessWidget {
  const WebHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceType = getDeviceType(MediaQuery.of(context).size);
    var navMenu = createNavMenus(context, selectedButton: Constants.groups);
    return Scaffold(
      appBar: createAppBar(deviceType, navMenu),
      drawer: deviceType == DeviceScreenType.mobile
          ? createEndDrawer(navMenu, context)
          : null,
      body: context.routerOutlet,
    );
  }
}
