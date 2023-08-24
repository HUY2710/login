enum Flavor {
  dev,
  prod,
}

class F {
  F._();
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Example Dev';
      case Flavor.prod:
        return 'Example';
      case null:
        return '____';
    }
  }
}
