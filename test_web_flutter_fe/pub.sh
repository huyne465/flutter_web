fvm flutter pub get
#rm -rf lib/gen
rm -r -fo lib\gen
rm lib/injector.config.dart
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart
fvm dart format  lib/* test/* -l 150
#fvm dart pub global activate flutterfire_cli
#flutterfire configure
