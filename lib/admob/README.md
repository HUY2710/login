
# Google Ad Mob

Thêm quảng cáo của google vào trong ứng dụng. Xem [tài liệu](https://developers.google.com/admob/flutter/quick-start) của Google Ad Mob


# Index
- [Cài đặt](#installation)
- [Thiết lập](#setup)
    - [Thiết lập cho từng nên tảng](#platform-specific-setup)
        - [Android](#for-android)
        - [IOS](#for-ios)
    - [Ad unit ID](#ad-unit-id)
    - [Khởi tạo trong flutter](#init-in-flutter)
- [Hướng dẫn sử dụng](#usage)
    - [App Open Ads](#app-open-ads)
    - [Banner Ads](#banner-ads)
        - [Anchored adaptive banners](#anchored-adaptive-banners)
        - [Inline adaptive banners](#inline-adaptive-banners)
    - [Interstitial Ads](#interstitial-ads)
    - [Native ads](#native-ads)
    - [Kiểm tra cấu hình trên Firebase](#check-setting)
# Cài đặt

Để cài đặt package `google_mobile_ads`, chạy lệnh dưới đây:

```console
flutter pub add google_mobile_ads 
```
Package sẽ được thêm vào trong `pubspec.yaml`

```yaml
dependencies:
  google_mobile_ads: ^3.0.0
```
Thêm package [firebase_core](https://pub.dev/packages/firebase_core) và [firebase_remote_config](https://pub.dev/packages/firebase_remote_config) và thiết lập firebase cho project để. Chúng ta cần xác định xem quảng cáo có được hiển thị hay không thông qua các thiết lập trên `firebase_remote_config`

```yaml
flutter pub add firebase_core 
flutter pub add firebase_remote_config 
```
Xem hướng dẫn cấu hình firebase cho project tạo [FlutterFire](https://firebase.google.com/docs)

# Thiết lập

## Thiết lập cho từng nền tảng

### Android
#### Update AndroidManifest.xml.

AdMob app ID cần phải được thêm vào trong `AndroidManifest.xml`, nếu không sẽ có lỗi xảy ra khi run app.

```xml
<manifest>
    <application>
        <!-- Sample AdMob app ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-3940256099942544~3347511713"/>
    <application>
<manifest>
```

### IOS
#### Update Info.plist
Trong file `ios/Runner/Info.plist`, thêm key `GADApplicationIdentifier` với giá trị là AdMob app ID :
```plish
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~3347511713</string>
```
Chú ý: `ca-app-pub-3940256099942544~3347511713` là AdMob app ID được cung cấp bơi Google để test quảng cáo trong quá trình phát triển
## Ad unit ID
Trong quá trình phát triển nên sử dụng các key test được cung cấp bởi Google, các key này đã được ghi trong file `/admob/constant/admob_key_constant.dart`. Lưu ý cập nhật lại các key này khi release app.

```dart
class AdmobKeyConstant {
  static const String appOpenAndroid = 'ca-app-pub-3940256099942544/3419835294';
  static const String appOpenIos = 'ca-app-pub-3940256099942544/5662855259';

  static const String bannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String bannerIos = 'ca-app-pub-3940256099942544/2934735716';

  static const String interstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String interstitialIos =
      'ca-app-pub-3940256099942544/4411468910';

  static const String nativeAndroid = 'ca-app-pub-3940256099942544/2247696110';
  static const String nativeIos = 'ca-app-pub-3940256099942544/3986624511';
}

```

## Khởi tạo trong Flutter
Thêm các đoạn code dưới đây:

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();// Khởi tạo Mobile Ads SDK
  await Firebase.initializeApp(); //Khởi tạo firebase

  await RemoteConfigManager.instance.initConfig(); // Lấy các thiết lập cho quảng cáo trên firebase
  runApp(MyApp());
}
```

# Hướng dẫn sử dụng

## App Open Ads

Tạo 1 instance cửa class `AppOpenAdManager`.
```dart
final AppOpenAdManager appOpenAdManager = AppOpenAdManager();
```
Sau đó hiển thị quảng cáo bằng lệnh dưới đây.

```dart
await appOpenAdManager.loadAd();
appOpenAdManager.showAdIfAvailable();
```

Ví dụ:

```dart
class _ExampleScreenState extends State<ExampleScreen> {
  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    loadAdOnStart();
    super.initState();
  }

  Future<void> loadAdOnStart() async {
    await appOpenAdManager.loadAd();
    appOpenAdManager.showAdIfAvailable();
  }
  ...
}
```

### Lắng nghe app state để hiển thị quảng cáo
Khi ứng dụng bị ẩn đi, mở lại ứng dụng sẽ hiển thị quảng cáo.

tạo 1 instance của class `AppLifecycleReactor`.

```dart
AppLifecycleReactor appLifecycleReactor = AppLifecycleReactor(
    appOpenAdManager: appOpenAdManager
);
```

Sử dụng hàm `listenToAppStateChanges` để lắng nghe app state .

```dart
appLifecycleReactor.listenToAppStateChanges();
```

Ví dụ:

```dart

class _ExampleScreenState extends State<ExampleScreen> {
  late AppLifecycleReactor _appLifecycleReactor;
  final AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  @override
  void initState() {
    loadAdOnStart();
    loadAdOnAppStateChange();
    super.initState();
  }

  Future<void> loadAdOnStart() async {
    await appOpenAdManager.loadAd();
    appOpenAdManager.showAdIfAvailable();
  }

  void loadAdOnAppStateChange() {
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }
  ...
}
```


## Banner Ads
### Anchored adaptive banners
Sử dụng `AdaptiveAdWidget` để hiển thị adaptive banner ad. Ví dụ:

```dart
class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ...
      body: Column(
        children: [
          Expanded(
            ...
          ),
          const AdaptiveAdWidget()
        ],
      ),
      ...
    );
  }
}
```
Parameters:

`inset`: Khoảng cách hai bên trái và phải của quảng cáo. Mặc định là `16`

### Inline adaptive banners
Sử dụng `InlineAdWidget` để hiển thị Inline adaptive banner ad. Ví dụ:
```dart

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: <Widget>[
            ...
            const InlineAdWidget(),
            ...
            
          ]),
    );
  }
}

```
Parameters:

`inset` (type: `double`): Khoảng cách 2 bên trái và phải của quảng cáo

`size` (type: [AdSize](https://developers.google.com/android/reference/com/google/android/gms/ads/AdSize)): Kích thước của quảng cáo


## Interstitial Ads
Tạo 1 instance của class `InterstitialAdManager`

```dart
final InterstitialAdManager interstitialAdManager = InterstitialAdManager();
```
Load quảng cáo:

```dart
interstitialAdManager.loadAd();
```

Hiển thị quảng cáo:
```dart
if (interstitialAdManager.interstitialAd != null) {
    interstitialAdManager.interstitialAd!.show();
}
```

Ví dụ:
```dart
class _ExampleState extends State<ExampleScreen> {
  final InterstitialAdManager interstitialAdManager = InterstitialAdManager();

  @override
  void initState() {
    interstitialAdManager.loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ...
      body: Column(
        children: [
          ElevatedButton(
            onPressed: (){
              if (interstitialAdManager.interstitialAd != null) {
                interstitialAdManager.interstitialAd!.show();
              }
            },
            child: const Text('Show Interstitial Ads')
          )
        ],
      ),
      ...
    );
  }
}
```
## Native ads
Sử `NativeAdWidget` để hiển thị quảng cáo native. ví dụ:

```dart
...
ListView(
  children: [
    NativeAdWidget(templateType: TemplateType.medium),
  ],
)
...
```
Parameters:

`templateType`: Xem  [TemplateType](https://developers.google.com/admob/flutter/native/templates#template_sizes)

## Kiểm tra cấu hình trên Firebase
Trước khi load 1 quảng cáo, cần kiểm tra xem cấu hình trên `Firebase Remote Config` xem có cho phép quảng cáo đó được load hay không.

Ví dụ kiểm tra cấu hình của App Open Ad:
```dart
final AppOpenAdManager appOpenAdManager = AppOpenAdManager();

bool isShowAppOpenAd = RemoteConfigManager.instance.isShowAd(AdKey.open_app);
if (isShowAppOpenAd) {
    await appOpenAdManager.loadAd();
    appOpenAdManager.showAdIfAvailable();
}
```