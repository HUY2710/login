import 'dart:isolate';

import '../../../../../data/models/store_user/store_user.dart';
import 'isolate_tracking_response.dart';

void entryPoint(SendPort sendPort) {
  // Tạo một ReceivePort để nhận dữ liệu từ main isolate
  final ReceivePort receivePort = ReceivePort();
  // Gửi sendPort của receivePort để main isolate có thể gửi dữ liệu cho isolate này
  sendPort.send(receivePort.sendPort);

  // Lắng nghe dữ liệu từ main isolate
  receivePort.listen((message) {
    if (message is StoreUser) {
      sendPort.send(IsolateTrackingResponse(
        allMember: [],
      ));
    }
  });
}
