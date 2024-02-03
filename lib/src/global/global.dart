import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/models/store_group/store_group.dart';
import '../data/models/store_user/store_user.dart';

class Global {
  Global._privateConstructor();

  static final Global instance = Global._privateConstructor();
  String documentPath = '';
  String temporaryPath = '';
  int androidSdkVersion = 0;
  bool isExitApp = false;
  StoreUser? user;
  StoreGroup? group;
  LatLng location = const LatLng(0, 0);
}
