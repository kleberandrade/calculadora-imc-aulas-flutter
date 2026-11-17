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

## Build and runtime verification

- `flutter analyze` passed with no issues after removing one redundant test import. `flutter build web --release` passed; Wasm compatibility dry run also succeeded, but Wasm was not claimed as an executed target.
- Served only the project's release build on 127.0.0.1:8768. Used a dedicated Chrome tab to validate decimal comma, calculation, empty-field errors, reset, unit change preserving weight, metre input and keyboard submit. Inspected the responsive layout at 390×844 and saved four real screenshots. Restored the browser viewport after validation.
- Rewrote the English README with actual setup, architecture, examples, operational/medical limits and explicitly unvalidated native targets. Preserved MIT and 2019 authorship.
- Added reproducible CI for master with Flutter/lockfile pins. Checked current GitHub action releases and pinned their exact commits: checkout v7.0.1, flutter-action v2.23.0, upload-artifact v7.0.2. CI uploads artifacts only; no hosting deployment.

## Publication and repository metadata

- Pushed validated implementation and lesson/assets preparation to `origin/master` without force: `52c2465` and `843d6d1`. CI for `843d6d12cd50d7f088a1ac83ae085308f96c1f6a` passed: https://github.com/kleberandrade/calculadora-imc-aulas-flutter/actions/runs/44150751819 .
- Revised the entire correct Medium article, preserving identity/title/author/publication. The importer split code at blank lines and ignored pasted captions/alt text. Removed only empty source lines in the editorial code, then used complete real content and the UI to set all captions, alt texts and code languages. Auto-review declined a temporary-placeholder approach; no placeholders were applied and no approval remained necessary for the safe complete-content edit.
- Selected the conceptual cover as featured image, clicked Save and publish, and verified the public `postPublishedType=repub` page: original title, correct og:image, four loaded images, four captions/alt descriptions, current versions, eight exactly matching code blocks and exactly five final exercises. Saved public screenshots and structured evidence. Sent no subscriber/follower communication.
- Extracted and ran the lesson's additional test example successfully. Confirmed the published complete domain equals the source after removing empty lines only; removed the temporary example test afterward. The permanent project suite remains nine tests.
- Updated About description in English and linked the lesson. Confirmed eight public topics: accessibility, bmi, calculator, dart, education, flutter, forms, validation. GitHub connector lacked metadata-edit capability, so used the dedicated repository browser tab, then confirmed public REST metadata.
- Restored temporary browser viewport settings and kept only the published Medium page as a browser deliverable. Final documentation/evidence commit is pushed separately, and its exact CI result is reported in the completion message after it finishes.
