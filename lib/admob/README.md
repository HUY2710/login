
# Google Ad Mob

Add google ads into project. See [document](https://developers.google.com/admob/flutter/quick-start) of Google Ad Mob


# Index
- [Installation](#installation)
- [Setup](#setup)
    - [Platform specific setup](#platform-specific-setup)
        - [For Android](#for-android)
        - [For IOS](#for-ios)
    - [Ad unit ID](#ad-unit-id)
- [Usage](#usage)
    - [App Open Ads](#app-open-ads)
    - [Banner Ads](#banner-ads)
        - [Anchored adaptive banners](#anchored-adaptive-banners)
        - [Inline adaptive banners](#inline-adaptive-banners)
    - [Interstitial Ads](#interstitial-ads)
    - [Native ads](#native-ads)

# Installation

To install `google_mobile_ads` package, run this command:

```console
flutter pub add google_mobile_ads 
```
This will add a line like this to your package's pubspec.yaml

```yaml
dependencies:
  google_mobile_ads: ^3.0.0
```

# Setup

## Platform specific setup

### For Android
#### Update AndroidManifest.xml.

The AdMob app ID must be included in the `AndroidManifest.xml`. Failure to do so results in a crash on app launch.

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

### For IOS
#### Update your Info.plist
In your app's ios/Runner/Info.plist file, add a `GADApplicationIdentifier` key with a string value of your AdMob app ID :
```plish
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~3347511713</string>
```
Note: `ca-app-pub-3940256099942544~3347511713` is a AdMob app ID provided by Google for testing
## Ad unit ID
During the development process, it is recommended to use the test keys provided in the */admob/constant/admob_key_constant.dart* file. Just make sure you replace them with your own ad unit ID before publishing your app.
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
# Usage

## App Open Ads

Create an instance of `AppOpenAdManager` class.
```dart
final AppOpenAdManager appOpenAdManager = AppOpenAdManager();
```
Then load and show available Ads.

```dart
await appOpenAdManager.loadAd();
appOpenAdManager.showAdIfAvailable();
```

Full example:

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

### Listen for app foregrounding events

Create an instance of `AppLifecycleReactor` class.

```dart
AppLifecycleReactor appLifecycleReactor = AppLifecycleReactor(
    appOpenAdManager: appOpenAdManager
);
```

Using `listenToAppStateChanges` to listen app state.

```dart
appLifecycleReactor.listenToAppStateChanges();
```

Full example:

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
Using `AdaptiveAdWidget` to display Anchored adaptive banner ad. For example:

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

`inset`: The distance between the left and right sides of advertisement

### Inline adaptive banners
Using `InlineAdWidget` to display Inline adaptive banner ad. For example:
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

`inset` (type: `double`): The distance between the left and right sides of advertisement

`size` (type: [AdSize](https://developers.google.com/android/reference/com/google/android/gms/ads/AdSize)): Size of advertisement


## Interstitial Ads
Example:
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
Using `NativeAdWidget` to display native advertisement. For Example:

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

`templateType`: see [TemplateType](https://developers.google.com/admob/flutter/native/templates#template_sizes) 