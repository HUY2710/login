import 'dart:convert';
import 'package:http/http.dart' as http;

import '../shared/constants/url_constants.dart';
import '../shared/helpers/env_params.dart';

class HTTPService {
  String searchNearByUrl = UrlConstants.nearBy;
  String routeDirectionUrl = UrlConstants.routeDirection;
  String autoCompleteAPI =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static String apiKey = EnvParams.apiKey;

  Future<http.Response> postRequestPlaces(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(searchNearByUrl),
        headers: {
          'X-Goog-Api-Key': apiKey,
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
          'X-Goog-Api-Key': apiKey,
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

  Future<void> placeAutoComplete({required String placeInput}) async {
    try {
      final Map<String, dynamic> querys = {'input': placeInput, 'key': apiKey};
      final url = Uri.https(
          'maps.googleapis.com', 'maps/api/place/autocomplete/json', querys);
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        debugPrint('result:$result');
      } else {
        response.body;
      }
    } on Exception catch (e) {
      print(e);
    }
    return;
  }

  Future<http.Response> placeAutoCompleteRequest(String placeInput) async {
    try {
      final Map<String, dynamic> body = {
        'input': placeInput,
        'key': apiKey,
      };

      final response = await http.post(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/place/autocomplete/json'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }
}
