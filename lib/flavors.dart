enum Flavor {
  dev,
  prod,
}

class F {
  const F._();

  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'VTN Base Flutter Dev';
      case Flavor.prod:
        return 'Example';
      case null:
        return 'title';
    }
  }
}
