# Dependencies and toolchain

Verified on 2026-11-17 with `flutter --version`, `flutter pub outdated`, the resolved lockfile and official release/package pages.

- Flutter **3.50.0**, stable release, framework revision **ab2912035e160d9cad6306df307576da6128ebdb**; Dart **3.14.0**.
- App constraint: Dart `>=3.14.0 <4.0.0`, Flutter `>=3.50.0`. CI pins Flutter 3.50.0; future SDKs are not implicitly certified.
- Runtime: Flutter SDK and official **material_ui 1.11.1**. Removed unused `cupertino_icons` 0.1.2. Material moved from the deprecated `flutter/material.dart` compatibility import to `material_ui/material_ui.dart`.
- Development: Flutter test SDK and **flutter_lints 6.0.0**.
- `pubspec.lock` records exact transitive versions; use `flutter pub get --enforce-lockfile` in verification.
- Flutter pins **material_color_utilities 0.13.0** in `packages/flutter/pubspec.yaml`. Catalog 0.13.1 is not compatible with that exact SDK constraint.
- Flutter test pins **test_api 0.7.14** in `packages/flutter_test/pubspec.yaml`. Catalog 0.7.15 is not compatible with that exact constraint.
- No dependency overrides. All other resolved dependencies were current in `flutter pub outdated`; no fabricated upgrade/coverage/mutation score.
- Native hosts use the SDK's generated Gradle 9.5.0 / Android Gradle Plugin 9.3.1 / Kotlin 2.4.20 configuration. Native templates are not a claim of a validated mobile build. Android licenses were not accepted automatically.

Sources: [Flutter releases](https://docs.flutter.dev/release/release-notes), [material_ui](https://pub.dev/packages/material_ui), [flutter_lints](https://pub.dev/packages/flutter_lints).
