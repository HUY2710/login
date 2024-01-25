import 'dart:math';

extension IntExt on int {
  String randomString() {
    const String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final Random rnd = Random();

    // ignore: always_specify_types
    return String.fromCharCodes(Iterable.generate(
        this, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  String randomUpperCaseString() {
    const String chars = 'ABCDEFGHIJKLMNOPQrSTUVWXYZ1234567890';
    final Random rnd = Random();

    // ignore: always_specify_types
    return String.fromCharCodes(Iterable.generate(
        this, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
