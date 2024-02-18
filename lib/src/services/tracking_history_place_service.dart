import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/models/store_place/store_place.dart';
import '../data/remote/firestore_client.dart';
import '../global/global.dart';
import '../shared/helpers/map_helper.dart';
import 'firebase_message_service.dart';

class TrackingHistoryPlaceService {
  final fireStoreClient = FirestoreClient.instance;
//tracking history place
  Future<void> trackingHistoryPlace() async {
    //lấy ra toàn bộ id group mà mình join
    final List<String>? listIdGroup = await fireStoreClient.listIdGroup();
    final List<Map<String, List<StorePlace>?>> listPlaces = [];
    if (listIdGroup != null && listIdGroup.isNotEmpty) {
      //lấy toàn bộ place trong từng group
      listIdGroup.map((id) async {
        final listPlace = await fireStoreClient.listPlaces(id);
        listPlaces.add({id: listPlace});
      });
    }

    //sau khi lấy được toàn bộ thông tin place
    listPlaces.map((e) {
      e.values.map((places) {
        places?.map((place) {
          //check xem vị trí hiện tại đã đi vào bán kính hay đi ra bán kính với vị trí của place hay chưa
          final inRadius = MapHelper.isWithinRadius(
            LatLng(place.location?['lat'], place.location?['lng']),
            Global.instance.currentLocation,
            100,
          );

          //nếu trong bán kính và chưa gửi thôn báo thì có nghĩa là mới vào place này
          // còn nếu đã gửi thông báo thì có nghĩa là user đã vào place này vào vẫn còn ở trong bán kính thì ko cần kiểm tra gì thêm
          if (inRadius && !place.isSendArrived) {
            //gửi thông báo đến cho những member khác
            FirebaseMessageService().sendCheckInNotification(
                e.keys.first, place.location?['address']);
          } else {}
        });
      });
    });
  }
}
