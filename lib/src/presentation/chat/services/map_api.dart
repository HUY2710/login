import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../global/global.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/helpers/logger_utils.dart';

class MapApi {
  MapApi._();

  final double lat = Global.instance.currentLocation.latitude;
  final double long = Global.instance.currentLocation.longitude;

  static Future<List<Map<String, dynamic>>> getNearByLocation() async {
    List<Map<String, dynamic>> result = [];
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${Global.instance.currentLocation.latitude},${Global.instance.currentLocation.longitude}&radius=1500&type=restaurant&key=${AppConstants.apiMapKey}';
    try {
      final response = await http.get(Uri.parse(url));
      logger.e(response.body);
      if (response.statusCode == 200) {
        result = (jsonDecode(response.body) as Map<String, dynamic>)['result'];
      }
    } catch (e) {
      logger.e('Get NearByLocation Fail: $e');
    }
    return result;
  }
}
