import 'dart:async';
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../app/cubit/loading_cubit.dart';
import '../../../data/models/autocomplete_place/autocomplete_place_model.dart';
import '../../../data/models/places/place_model.dart';
import '../../../gen/assets.gen.dart';
import '../../../services/http_service.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/cubit/value_cubit.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/widgets/my_drag.dart';
import '../../../shared/widgets/text_field/main_text_form_field.dart';
import '../cubit/select_place_cubit.dart';
import '../widgets/item_near_by_place.dart';

class SearchPlaceBottomSheet extends StatefulWidget {
  const SearchPlaceBottomSheet(
      {super.key,
      required this.selectPlaceCubit,
      required this.addressCubit,
      required this.placeLatLngCubit,
      required this.requestApi});
  final SelectPlaceCubit selectPlaceCubit;
  final ValueCubit<String> addressCubit;
  final ValueCubit<LatLng> placeLatLngCubit;
  final ValueCubit<bool> requestApi;
  @override
  State<SearchPlaceBottomSheet> createState() => _SearchPlaceBottomSheetState();
}

class _SearchPlaceBottomSheetState extends State<SearchPlaceBottomSheet> {
  final TextEditingController searchPlaceCtrl = TextEditingController();
  List<Place> listPlaceNearBy = [];
  AutoCompletePlaceModel? autoCompletePlaceModel;
  Timer? _typingTimer;
  String _selectedPlaceId = '';
  @override
  void initState() {
    super.initState();
    searchPlaceCtrl.addListener(() {
      _onChanged();
    });
  }

  void _onChanged() {
    if (_typingTimer != null && _typingTimer!.isActive) {
      _typingTimer!.cancel();
    }

    _typingTimer = Timer(const Duration(milliseconds: 700), () {
      if (searchPlaceCtrl.text.isNotEmpty) {
        getSuggestion(searchPlaceCtrl.text);
      }
    });
  }

  Future<void> getSuggestion(String input) async {
    final response =
        await HTTPService.instance.requestPlaceAutoComplete(placeInput: input);
    if (response.statusCode == 200) {
      final AutoCompletePlaceModel decodedResponse =
          AutoCompletePlaceModel.fromJson(json.decode(response.body));
      debugPrint('resonse:${json.decode(response.body)}');
      setState(() {
        autoCompletePlaceModel = decodedResponse;
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  String placeId = '';
  Future<void> _selectPlace(String placeId, String description) async {
    // EasyLoading.show();
    showLoading();
    try {
      final response = await HTTPService.instance.requestDetailPlace(placeId);
      final result = jsonDecode(response.body);
      final location = result['result']['geometry']['location'];
      final double latitude = location['lat'];
      final double longitude = location['lng'];
      widget.requestApi.update(true);
      widget.placeLatLngCubit.update(LatLng(latitude, longitude));
      widget.addressCubit.update(description);
      setState(() {
        _selectedPlaceId = placeId;
      });
      debugPrint('placeId: $_selectedPlaceId');
      if (context.mounted) {
        context.popRoute();
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
    // EasyLoading.dismiss();
    hideLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.containerBorder).r,
        ),
        constraints:
            BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.35),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MyDrag(),
            14.verticalSpace,
            MainTextFormField(
              controller: searchPlaceCtrl,
              prefixIcon: SvgPicture.asset(Assets.icons.icSearch.path),
              hintText: context.l10n.search,
            ),
            16.verticalSpace,
            if (autoCompletePlaceModel != null)
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: autoCompletePlaceModel!.predictions.length,
                  itemBuilder: (context, index) {
                    final Prediction item =
                        autoCompletePlaceModel!.predictions[index];
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () =>
                          _selectPlace(item.place_id, item.description),
                      child: ItemNearByPlace(
                        namePlace: item.description,
                        isSelect: placeId == item.place_id,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                ),
              )
          ],
        ),
      ),
    );
  }
}
