# Modernization log

## 2026-11-17 — baseline and red/green changes

- Cloned the real repository; confirmed clean `master`, `origin/HEAD -> origin/master`, HTTPS remote and baseline `927232d`. No existing local work or project-specific instructions were present.
- Read the shared modernization standard and reduced-principles instructions. Inspected the original app, lockfile, README and both native hosts.
- Verified Flutter 3.50.0 stable against official release notes and local revision `ab2912035e160d9cad6306df307576da6128ebdb` / Dart 3.14.0. Created an isolated APFS copy at `/private/tmp/imc-aulas-sdk-3.50.0`; did not update the shared SDK.
- Verified CDC formula and adult 20+ categories. Removed the old 18.6 cutoff, excessive significant-digit rounding, stigmatizing conclusions and unsupported gender-based calculation exercise.
- Wrote domain tests first. Observed the expected missing-domain compilation failure in `/private/tmp/imc-aulas-red-domain.log`, then implemented the validated immutable domain. A later test launch hit a local socket permission restriction; this was an environment failure, not a behavioral red result.
- Wrote widget behavior tests against a minimal compilable app, observed missing controls in `/private/tmp/imc-aulas-red-ui.log`, then implemented the form and responsive interface. Subsequent tests found that changing units reset weight too; preserved weight while clearing height and result. Fixed test synchronization and disposed the semantics handle within the test body.
- Nine domain/widget tests passed, including exact thresholds, parsing, range endpoints, unit errors, recovery, reset, keyboard actions, a 360px viewport with 200% text, and Flutter contrast/label/Android tap-target guidelines. These are automated widget checks, not a physical Android-device test.
- `flutter pub outdated` verified all direct packages current and all resolved transitives at the latest compatible versions; two newer catalog versions are incompatible SDK pins (see dependencies.md).
- Confirmed installed crapper, dryer and mutator help: none supports Dart. No CRAP, duplication or mutation score is claimed.
- Replaced obsolete Android v1 embedding/Groovy and Objective-C host templates with Flutter 3.50 generated Android Kotlin/iOS Swift hosts, preserving both application identifiers. Added web as the primary executable validation target.
- Read the correct Medium page and confirmed its author account exposes Edit story; opened the existing editor without changing article identity.
- Generated a new conceptual cover using the built-in image tool and copied it into `images/cover-2026.png`. It is an illustration, not an app screenshot. Prompt recorded in images/README.md.
