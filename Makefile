clean:
	flutter pub clean

dependencies:
	flutter pub get

upgrade-dependencies:
	flutter pub upgrade --major-versions

build-runner:
	flutter packages pub run build_runner build

watch-runner:
	flutter packages pub run build_runner watch

build-runner-delete:
	flutter packages pub run build_runner build --delete-conflicting-outputs

watch-runner-delete:
	flutter packages pub run build_runner watch --delete-conflicting-outputs

gen-l10n:
	flutter gen-l10n

gen-flavor:
	flutter pub run flutter_flavorizr

build-apk-dev:
	flutter build apk --flavor dev
