clean:
	fvm flutter pub clean

dependencies:
	fvm flutter pub get

upgrade-dependencies:
	fvm flutter pub upgrade --major-versions

build-runner:
	fvm flutter packages pub run build_runner build

watch-runner:
	fvm flutter packages pub run build_runner watch

build-runner-delete:
	fvm flutter packages pub run build_runner build --delete-conflicting-outputs

watch-runner-delete:
	fvm flutter packages pub run build_runner watch --delete-conflicting-outputs

gen-l10n:
	fvm flutter gen-l10n

gen-flavor:
	fvm flutter pub run flutter_flavorizr

build-apk-dev:
	fvm flutter build apk --flavor dev
