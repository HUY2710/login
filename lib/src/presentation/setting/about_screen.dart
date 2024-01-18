import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  Future<String> getVersionNumber() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    return version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * (1 / 8),
          ),
          // Image.asset(Assets.images.logo.path),
          Padding(
            padding: EdgeInsets.only(top: 30.h, bottom: 40.h),
            child: Text(
              'GPS Flutter',
              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700),
            ),
          ),
          FutureBuilder<String>(
            future: getVersionNumber(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  'Version ${snapshot.data}',
                  style: TextStyle(fontSize: 16.sp),
                );
              }
              return const Text('Version 1.0.0');
            },
          )
        ],
      ),
    );
  }
}
