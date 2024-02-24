import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../shared/constants/url_constants.dart';
import '../shared/helpers/env_params.dart';

class HTTPService {
  HTTPService._privateConstructor();
  static final HTTPService instance = HTTPService._privateConstructor();
  String searchNearByUrl = UrlConstants.nearBy;
  String routeDirectionUrl = UrlConstants.routeDirection;
  String autoCompleteAPI =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  String detailPlaceApiUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';
  final String _apiKey = EnvParams.apiKey;

  Future<http.Response> postRequestPlaces(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(searchNearByUrl),
        headers: {
          'X-Goog-Api-Key': _apiKey,
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
          'X-Goog-Api-Key': _apiKey,
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

  Future<http.Response> requestPlaceAutoComplete(
      {required String placeInput}) async {
    try {
      final Map<String, dynamic> querys = {'input': placeInput, 'key': _apiKey};
      final url = Uri.https(
          'maps.googleapis.com', 'maps/api/place/autocomplete/json', querys);
      final response = await http.post(url);
      return response;
    } on Exception catch (e) {
      throw Exception('Failed to requestDetailPlace: $e');
    }
  }

  Future<http.Response> requestDetailPlace(String placeId) async {
    try {
      final String request =
          '$detailPlaceApiUrl?place_id=$placeId&key=$_apiKey';
      final response = await http.get(Uri.parse(request));

      debugPrint('response:${response.body}');
      return response;
    } catch (e) {
      throw Exception('Failed to requestDetailPlace: $e');
    }
  }
}
