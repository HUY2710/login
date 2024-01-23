import 'package:flutter/cupertino.dart';

class MemberMarkerData {
  MemberMarkerData({required this.index, required this.repaintKey});

  final int index;
  GlobalKey repaintKey;
}
