# Arabic Translation Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add Arabic (`ar`) as a supported app locale with correct RTL behavior, language selection, and predictable fallbacks, without breaking the existing English/Hebrew flows.

**Architecture:** Keep all app-shell localization inside the existing Flutter `gen_l10n` boundary in `lib/l10n`, and reuse the current `LocaleService` -> `MaterialApp` -> `AppLocalizations` flow. Treat Arabic as work across three existing boundaries only: generated UI strings, locale selection/persistence, and localized content/data (in-repo constants plus Firestore-fed content). Do not introduce a new localization layer or a generic translation abstraction.

**Tech Stack:** Flutter, `flutter_localizations`, `intl`, Provider/GetIt, Firestore, widget tests.

---

### Task 0: Lock the delivery scope before implementation

**Files:**
- Modify: `docs/plans/2026-04-14-arabic-translation.md`
- Review: `lib/l10n/app_en.arb`
- Review: `lib/EmergencyNumbers.dart`
- Review: `lib/util/Firebase/firebase_functions.dart`

**Step 1: Get the human scope decision in writing**

Ask the product owner to choose one scope:

```text
A. UI shell only: Arabic for ARB-backed UI, RTL layout, and locale selection.
B. Full Arabic: Scope A plus Arabic content for emergency descriptions, wellness videos, share/PDF copy, and Firestore-fed content.
```

**Step 2: Record the approved scope in the ticket or PR**

Example note:

```text
Arabic v1 scope: UI shell + RTL + language picker. Data-driven content stays English fallback until Arabic content is supplied.
```

**Step 3: Stop if scope remains ambiguous**

This change crosses more than one boundary (`lib/l10n`, in-repo content, and Firestore-fed content). Per `AGENTS.md`, implementation must not silently choose that scope.

**Step 4: Commit**

```bash
git add docs/plans/2026-04-14-arabic-translation.md
git commit -m "docs: record arabic translation scope gate"
```

### Task 1: Add failing tests for Arabic locale support

**Files:**
- Create: `test/l10n/arabic_locale_test.dart`
- Modify: `test/country_selector_widget_test.dart`
- Modify: `test/MenuTest/Wellness/wellnessTools_test.dart`

**Step 1: Write the failing tests**

```dart
test('LocaleService keeps explicit Arabic locale', () {
  final service = LocaleServiceImpl();
  service.setLocale('ar');
  expect(service.getLocale(), 'ar');
});

testWidgets('AppLocalizations exposes Arabic as a supported locale',
    (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: Locale('ar'),
      home: SizedBox.shrink(),
    ),
  );

  expect(
    AppLocalizations.supportedLocales,
    contains(const Locale('ar')),
  );
});
```

**Step 2: Run the tests to verify they fail**

Run:

```bash
flutter test test/l10n/arabic_locale_test.dart test/country_selector_widget_test.dart
```

Expected: failure because `Locale('ar')` is not in `AppLocalizations.supportedLocales`, `LocaleServiceImpl` does not detect Arabic, and the language picker exposes only `en` and `he`.

**Step 3: Keep the failures focused**

Do not add UI assertions for translated copy yet. This task only proves the current app cannot register Arabic as a first-class locale.

**Step 4: Commit**

```bash
git add test/l10n/arabic_locale_test.dart test/country_selector_widget_test.dart test/MenuTest/Wellness/wellnessTools_test.dart
git commit -m "test: cover arabic locale registration"
```

### Task 2: Extend locale plumbing and language selection

**Files:**
- Modify: `lib/Locale/locale_service.dart`
- Modify: `lib/util/languages_util_functions.dart`
- Modify: `lib/util/disclaimerLanguageSelect.dart`
- Modify: `lib/pages/UserSettings.dart`
- Review: `lib/main.dart:311-382`

**Step 1: Write the failing widget test for language selection**

Add an assertion that Arabic appears anywhere the user can intentionally switch locales.

```dart
expect(find.text('العربية'), findsOneWidget);
```

**Step 2: Run the test to verify it fails**

Run:

```bash
flutter test test/country_selector_widget_test.dart
```

Expected: failure because `languageName()` only maps `en` and `he`, and `LanguageDropDown` only offers two locales.

**Step 3: Implement the minimal locale-plumbing changes**

Use language-code based logic instead of country-specific exact matches:

```dart
static String getLocaleName() {
  final raw = LanguageCode.rawLocale.toString().toLowerCase();
  if (raw.startsWith('he')) return 'he';
  if (raw.startsWith('ar')) return 'ar';
  return 'en';
}
```

Extend the language-name helpers:

```dart
case 'ar':
  return 'العربية';
```

```dart
case 'العربية':
  return 'ar';
```

Update the disclaimer picker to include Arabic. Do not represent Arabic with an arbitrary country flag unless product explicitly approves one; if no approved asset exists, render a text label for Arabic in the dropdown instead of a flag-only row.

**Step 4: Run the tests to verify they pass**

Run:

```bash
flutter test test/l10n/arabic_locale_test.dart test/country_selector_widget_test.dart
```

Expected: pass.

**Step 5: Commit**

```bash
git add lib/Locale/locale_service.dart lib/util/languages_util_functions.dart lib/util/disclaimerLanguageSelect.dart lib/pages/UserSettings.dart test/l10n/arabic_locale_test.dart test/country_selector_widget_test.dart
git commit -m "feat: add arabic locale plumbing"
```

### Task 3: Add the Arabic ARB catalog and regenerate localizations

**Files:**
- Create: `lib/l10n/app_ar.arb`
- Modify: `lib/l10n/app_en.arb`
- Generated: `lib/l10n/app_localizations.dart`
- Generated: `lib/l10n/app_localizations_ar.dart`
- Generated: `lib/l10n/app_localizations_en.dart`
- Generated: `lib/l10n/app_localizations_he.dart`
- Review only: `l10n.yaml`

**Step 1: Create the failing localization test**

Add one concrete assertion that requires Arabic copy to exist:

```dart
testWidgets('Arabic localization resolves textDirection to rtl', (tester) async {
  late AppLocalizations localization;

  await tester.pumpWidget(
    MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: const Locale('ar'),
      home: Builder(
        builder: (context) {
          localization = AppLocalizations.of(context)!;
          return const SizedBox.shrink();
        },
      ),
    ),
  );

  expect(localization.textDirection, 'rtl');
});
```

**Step 2: Run the test to verify it fails**

Run:

```bash
flutter test test/l10n/arabic_locale_test.dart
```

Expected: failure because `app_ar.arb` and generated Arabic localizations do not exist.

**Step 3: Implement the minimal localization catalog**

Create `lib/l10n/app_ar.arb` from the English template, starting with:

```json
{
  "language": "العربية",
  "textDirection": "rtl"
}
```

Translate every key that is already defined in `lib/l10n/app_en.arb`. Before adding Arabic, first audit parity between English and Hebrew; today Hebrew is materially incomplete relative to English, so Arabic must be created from English as the source of truth, not from the partial Hebrew file.

Run generation, do not hand-edit generated files:

```bash
flutter gen-l10n
```

**Step 4: Run the tests to verify they pass**

Run:

```bash
flutter test test/l10n/arabic_locale_test.dart
```

Expected: pass, and `lib/l10n/app_localizations.dart` now lists `Locale('ar')`.

**Step 5: Commit**

```bash
git add lib/l10n/app_ar.arb lib/l10n/app_en.arb lib/l10n/app_localizations.dart lib/l10n/app_localizations_ar.dart lib/l10n/app_localizations_en.dart lib/l10n/app_localizations_he.dart
git commit -m "feat: add arabic localization catalog"
```

### Task 4: Remove language-specific UI assumptions and hard-coded user-facing strings

**Files:**
- Modify: `lib/menu.dart`
- Modify: `lib/pages/UserSettings.dart`
- Modify: `lib/pages/PersonalPlan/myPlanPageFull.dart`
- Modify: `lib/pages/WellnessTools/wellnessTools.dart`
- Modify: `lib/pages/about.dart`
- Modify: `lib/form/formpagetemplate.dart`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_ar.arb`
- Modify: `lib/l10n/app_he.arb`

**Step 1: Write failing tests around Arabic rendering**

Add focused assertions for:

```dart
expect(find.text('No videos available for your locale, sorry.'), findsNothing);
expect(find.text('Are you sure?'), findsNothing);
```

These should fail once the widgets are pumped under `Locale('ar')`.

**Step 2: Run the tests to verify they fail**

Run:

```bash
flutter test test/MenuTest/Wellness/wellnessTools_test.dart test/UserSettings/UserSettings_test.dart
```

Expected: failure because those screens still contain direct English literals and language-name based branching.

**Step 3: Implement the minimal UI cleanup**

Replace display-name checks with locale or direction checks:

```dart
final isRtl = appLocale.textDirection == 'rtl';
```

Use `isRtl` instead of comparisons like:

```dart
appLocale.language == 'English'
appLocale.language != 'עברית'
```

Move hard-coded user-facing strings into ARB keys, including at least:

```json
"noVideosForLocale": "No videos available for your locale, sorry.",
"confirmResetTitle": "Are you sure?",
"emptyValueValidation": "Value Can't Be Empty",
"aboutVersionLabel": "Living Positively App Version : {version}"
```

Keep non-user-facing debug logs in code; only localize strings the user actually sees.

**Step 4: Run the tests to verify they pass**

Run:

```bash
flutter test test/MenuTest/Wellness/wellnessTools_test.dart test/UserSettings/UserSettings_test.dart
```

Expected: pass under Arabic, with no dependence on `English`/`עברית` display names.

**Step 5: Commit**

```bash
git add lib/menu.dart lib/pages/UserSettings.dart lib/pages/PersonalPlan/myPlanPageFull.dart lib/pages/WellnessTools/wellnessTools.dart lib/pages/about.dart lib/form/formpagetemplate.dart lib/l10n/app_en.arb lib/l10n/app_ar.arb lib/l10n/app_he.arb
git commit -m "refactor: remove language-specific UI assumptions"
```

### Task 5: Handle Arabic content and fallback rules at the data boundary

**Files:**
- Modify: `lib/EmergencyNumbers.dart`
- Modify: `lib/util/Phone/EmergencyPhones.dart`
- Modify: `lib/menu.dart`
- Review: `lib/util/Firebase/firebase_functions.dart:1343-1371`
- Review: `lib/util/appInformation.dart`

**Step 1: Write the failing tests for Arabic content behavior**

Cover two rules:

```dart
expect(descriptionShownForArabic, isNot(contains('עברית')));
expect(videoLocaleFallbackForArabic, equals('en'));
```

Use English as the fallback expectation for Arabic unless scope B explicitly supplies Arabic content.

**Step 2: Run the tests to verify they fail**

Run:

```bash
flutter test test/EmergencyPhonesTest.dart test/MenuTest/Wellness/wellnessTools_test.dart
```

Expected: failure because emergency descriptions currently branch only between `descriptionHe` and `description`, and wellness video filtering defaults missing locale entries to `"he"`.

**Step 3: Implement the minimal content-boundary changes**

For in-repo emergency data, add an Arabic field only where product approved Arabic content:

```dart
final descriptionText = switch (Localizations.localeOf(context).languageCode) {
  'he' => number['descriptionHe'] ?? number['description'] ?? '',
  'ar' => number['descriptionAr'] ?? number['description'] ?? '',
  _ => number['description'] ?? '',
};
```

For wellness videos, stop defaulting missing locale metadata to Hebrew:

```dart
var videoLocale = videos['videoLocale']![i] ?? 'en';
```

If scope A was approved, Arabic must fall back to English content and must not show Hebrew-only content by accident.

If scope B was approved, coordinate Firestore updates for:

```text
Wellness-Videos.videoLocal = "ar"
SharePDFtexts Arabic copy
Any CMS collections that currently store only general/male/female text without locale variants
```

Do not redesign the Firestore schema inside this task. If Arabic requires a schema-level locale dimension in CMS content, stop and write a separate plan before changing that contract.

**Step 4: Run the tests to verify they pass**

Run:

```bash
flutter test test/EmergencyPhonesTest.dart test/MenuTest/Wellness/wellnessTools_test.dart
```

Expected: pass, with Arabic showing Arabic content where supplied and English fallback otherwise.

**Step 5: Commit**

```bash
git add lib/EmergencyNumbers.dart lib/util/Phone/EmergencyPhones.dart lib/menu.dart
git commit -m "feat: add arabic content fallbacks"
```

### Task 6: Fix the translation maintenance workflow and verify end-to-end

**Files:**
- Modify: `createARBfile.py`
- Review: `app_en.arb`
- Review: `app_he.arb`
- Modify: `ios/Runner/Info.plist`

**Step 1: Make the helper workflow fail loudly instead of writing stale files**

Today `createARBfile.py` writes to obsolete root files:

```python
append_to_arb_file('D:/Git/Mazilon/app_he.arb', arbsentenceHeb)
append_to_arb_file('D:/Git/Mazilon/app_en.arb', arbsentenceEng)
```

Either update it to target `lib/l10n/*.arb`, or make the script raise until it is corrected. Do not let Arabic work land while the helper still writes to dead files.

**Step 2: Update iOS locale metadata if required**

Add supported localizations explicitly if the iOS build does not pick them up automatically:

```xml
<key>CFBundleLocalizations</key>
<array>
  <string>en</string>
  <string>he</string>
  <string>ar</string>
</array>
```

**Step 3: Run the full verification suite**

Run:

```bash
flutter gen-l10n
flutter analyze
flutter test
```

Expected:
- `flutter gen-l10n` succeeds and regenerates Arabic localizations
- `flutter analyze` reports no new issues
- widget and unit tests pass under English, Hebrew, and Arabic

**Step 4: Manual QA checklist**

Verify on device or emulator:

```text
1. First-launch language picker can switch to Arabic.
2. The app restarts into Arabic after persisting localeName = "ar".
3. Core flows render RTL correctly: disclaimer, onboarding, menu, personal plan, user settings, wellness tools.
4. Arabic users never see unintended Hebrew fallback copy.
5. Notifications still schedule and refresh after changing locale.
```

**Step 5: Commit**

```bash
git add createARBfile.py ios/Runner/Info.plist
git commit -m "chore: align translation tooling with arabic support"
```
