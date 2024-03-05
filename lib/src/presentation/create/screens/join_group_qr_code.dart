import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as google_mlkit_barcode_scanning;
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../gen/gens.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/mixin/permission_mixin.dart';
import '../../../shared/widgets/custom_alter_dialog.dart';
import '../../home/cubit/validate_code/code_validation_cubit.dart';

@RoutePage()
class JoinQrCodeScreen extends StatefulWidget {
  const JoinQrCodeScreen({super.key});

  @override
  State<JoinQrCodeScreen> createState() => _JoinQrCodeScreenState();
}

class _JoinQrCodeScreenState extends State<JoinQrCodeScreen>
    with PermissionMixin {
  XFile? qrCodeFile;
  CodeValidationCubit codeValidationCubit = getIt<CodeValidationCubit>();
  QRViewController? qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final google_mlkit_barcode_scanning.BarcodeScanner _barcodeScanner =
      google_mlkit_barcode_scanning.BarcodeScanner();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CodeValidationCubit, CodeValidationState>(
        bloc: codeValidationCubit,
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            inValid: (error) async {
              await _buildDialogQrCodeEmpty(context, messageError: error);
            },
            valid: (group) async {
              await SharedPreferencesManager.saveIsCreateInfoFistTime(false);
              final bool statusLocation = await checkPermissionLocation();
              if (!statusLocation && context.mounted) {
                getIt<AppRouter>()
                    .replaceAll([PermissionRoute(fromMapScreen: false)]);
                return;
              } else if (context.mounted) {
                getIt<AppRouter>().replaceAll([HomeRoute()]);
              }
            },
          );
        },
        builder: (context, state) {
          return Stack(
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: (QRViewController controller) async {
                  qrController = controller;
                  controller.scannedDataStream.listen((event) async {
                    if (event.code != null) {
                      controller.pauseCamera();
                      await codeValidationCubit.submit(event.code!, context);
                    }
                  });
                },
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.white,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.55),
                child: FilledButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color(0xffEAEAEA).withOpacity(0.3)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              side:
                                  const BorderSide(color: Color(0xffEAEAEA)))),
                    ),
                    onPressed: () async {
                      qrController!.pauseCamera();
                      final result = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (result != null) {
                        qrCodeFile = result;
                        if (qrCodeFile != null) {
                          // loadingDialog(context);
                          final inputImage = google_mlkit_barcode_scanning
                              .InputImage.fromFilePath(qrCodeFile!.path);

                          final dataQrCode =
                              await _barcodeScanner.processImage(inputImage);
                          if (dataQrCode.isEmpty) {
                            if (context.mounted) {
                              await _buildDialogQrCodeEmpty(context);
                            }
                            return;
                          }
                          String resultQrCode = '';

                          for (final data in dataQrCode) {
                            resultQrCode += '${data.rawValue}';
                          }
                          if (mounted) {
                            await codeValidationCubit.submit(
                                resultQrCode, context);
                          }
                        }
                      } else {
                        qrController!.resumeCamera();
                      }
                    },
                    icon: Assets.icons.icUpload.svg(
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn)),
                    label: Text(
                      context.l10n.uploadPhoto,
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w500),
                    )),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin:
                      EdgeInsets.only(top: ScreenUtil().statusBarHeight + 10),
                  height: 30.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: GestureDetector(
                          onTap: () {
                            context.popRoute();
                          },
                          child: Assets.icons.icBack.svg(
                            height: 28.h,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          context.l10n.joinAGroup,
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Future<dynamic> _buildDialogQrCodeEmpty(BuildContext context,
      {String? messageError}) {
    bool willPop = false;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context1) => WillPopScope(
        onWillPop: () async => willPop,
        child: CustomAlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    willPop = true;
                    context.popRoute();
                    qrController!.resumeCamera();
                  },
                  child: Text(
                    context.l10n.ok,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff8E52FF)),
                  ))
            ],
            content: Column(
              children: [
                Text(
                  messageError == null
                      ? context.l10n.invalidQrCode
                      : context.l10n.error,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffFF3B30)),
                ),
                8.verticalSpace,
                Text(
                  messageError ?? context.l10n.pleaseCheckQrCode,
                  style: TextStyle(
                      fontSize: 13.sp, color: const Color(0xff6C6C6C)),
                ),
              ],
            )),
      ),
    );
  }
}
