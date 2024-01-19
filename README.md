# Flutter Base

## Information

Flutter version: `3.13.9`

### Base Flutter with:

- State management: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- Asset management: [flutter_gen](https://pub.dev/packages/flutter_gen)
- Flavor management: [flutter_flavorizr](https://pub.dev/packages/flutter_flavorizr)
- Evironment management: [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- Route management: [auto_route](https://pub.dev/packages/auto_route)
- Dependencies
  Injection: [get_it](https://pub.dev/packages/get_it) + [injectable](https://pub.dev/packages/injectable)
- Responsiveness: [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
-
Localization: [flutter_localizations](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization)

### and Boilerplate code for:

- Screen: Splash, Intro, Language, Settings
- Firebase: Remote config, Analytics
- Admob intergration & meta ads mediation & mintegral + app lovin
- AppsFlyers SDK
- IAP (optional) --> later

## Usage

### Setup

```console
flutter pub get
flutter gen-l10n
flutter pub run build_runner build --delete-conflicting-outputs
```

### Set up firebase

- Tạo dự án Firebase mới, thay file config firebase tương ứng
- Vào Release & Monitor -> Remote config -> Copy nội dung như sau vào file json để import các
  parameters cần thiết (thêm các key tương tự nếu cần)

```json
{
  "parameters": {
    "multipleLoadIntroAd": {
      "defaultValue": {
        "value": "true"
      },
      "valueType": "BOOLEAN"
    },
    "adOffVersion": {
      "defaultValue": {
        "value": "0"
      },
      "valueType": "STRING"
    },
    "android_show": {
      "defaultValue": {
        "value": "false"
      },
      "valueType": "BOOLEAN"
    },
    "forceUpdate": {
      "defaultValue": {
        "value": "true"
      },
      "valueType": "BOOLEAN"
    },
    "ios_show": {
      "defaultValue": {
        "value": "true"
      },
      "valueType": "BOOLEAN"
    }
  },
  "version": {
    "versionNumber": "1",
    "updateTime": "2023-12-21T04:02:15.896021Z",
    "updateUser": {
      "email": "soncm@vtn-global.com"
    },
    "updateOrigin": "CONSOLE",
    "updateType": "INCREMENTAL_UPDATE"
  },
  "parameterGroups": {
    "ios": {
      "parameters": {
        "ios_interSplash": {
          "defaultValue": {
            "value": "true"
          },
          "valueType": "BOOLEAN"
        },
        "ios_showCollapsibleBanner": {
          "defaultValue": {
            "value": "true"
          },
          "valueType": "BOOLEAN"
        },
        "ios_showSkipIntroButton": {
          "defaultValue": {
            "value": "true"
          },
          "valueType": "BOOLEAN"
        }
      }
    },
    "android": {
      "parameters": {
        "android_interSplash": {
          "defaultValue": {
            "value": "true"
          },
          "valueType": "BOOLEAN"
        },
        "android_showCollapsibleBanner": {
          "defaultValue": {
            "value": "false"
          },
          "valueType": "BOOLEAN"
        },
        "android_showSkipIntroButton": {
          "defaultValue": {
            "value": "true"
          },
          "valueType": "BOOLEAN"
        }
      }
    }
  }
}
```

### Set up quảng cáo

- Meta ads: Android: thay ClientToken & ApplicationId trong Android Manifest, iOS: thay CLIENT-TOKEN và APP-ID tương ứng
- App lovin: cần thêm pub phía flutter
