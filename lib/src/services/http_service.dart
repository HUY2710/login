import 'dart:convert';
import 'package:http/http.dart' as http;

import '../shared/constants/url_constants.dart';
import '../shared/helpers/env_params.dart';

class HTTPService {
  String searchNearByUrl = UrlConstants.nearBy;
  String routeDirectionUrl = UrlConstants.routeDirection;
  static String apiPlaceKey = EnvParams.apiPlaceKey;

  Future<http.Response> postRequestPlaces(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(searchNearByUrl),
        headers: {
          'X-Goog-Api-Key': apiPlaceKey,
          'Content-Type': 'application/json',
          'X-Goog-FieldMask':
              'places.displayName,places.formattedAddress,places.location',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  Future<http.Response> postRequestRoutes(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(routeDirectionUrl),
        headers: {
          'X-Goog-Api-Key': apiPlaceKey,
          'Content-Type': 'application/json',
          'X-Goog-FieldMask':
              'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }
}
