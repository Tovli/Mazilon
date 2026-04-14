# Language Selector And RTL Compliance Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Align the app with the product guidelines by removing country flags from language selection, preserving text-only autonyms, and validating/fixing Arabic RTL mirroring across the app shell.

**Architecture:** Keep the work inside the existing Flutter localization path: `LocaleService` -> `MaterialApp` -> `AppLocalizations`, plus the current language selector in `lib/util/disclaimerLanguageSelect.dart`. Treat this as a UI-compliance change, not a localization-architecture change: no new locale layer, no country-language asset system, and no redesign of `gen_l10n`.

**Tech Stack:** Flutter, `flutter_localizations`, Material icons, Provider/GetIt, widget tests.

---

### Task 1: Codify the language-selector guidelines with failing tests

**Files:**
- Create: `test/l10n/language_selector_guidelines_test.dart`
- Review: `lib/util/disclaimerLanguageSelect.dart`
- Review: `test/l10n/arabic_locale_test.dart`

**Step 1: Write the failing test for text-only autonyms**

Add a focused widget test that pumps `LanguageDropDown` and asserts:

```dart
expect(find.text('English'), findsOneWidget);
expect(find.text('עברית'), findsOneWidget);
expect(find.text('العربية'), findsOneWidget);
```

**Step 2: Write the failing test for “no flags”**

Assert that the selector does not render country-flag images and instead renders a neutral language icon:

```dart
expect(find.byType(Image), findsNothing);
expect(find.byIcon(Icons.language), findsWidgets);
```

**Step 3: Run the test to verify it fails**

Run:

```bash
flutter test test/l10n/language_selector_guidelines_test.dart -r expanded
```

Expected: failure because `LanguageDropDown` still references `assets/images/united-states.png` and `assets/images/israel.png` and renders `Image.asset(...)`.

**Step 4: Keep scope narrow**

Do not touch RTL or unrelated translations in this task. This task exists only to lock down the selector requirements:
- no flags
- clean autonyms
- neutral language icon

**Step 5: Commit**

```bash
git add test/l10n/language_selector_guidelines_test.dart
git commit -m "test: codify language selector compliance rules"
```

### Task 2: Remove country flags and switch the selector to a neutral language icon

**Files:**
- Modify: `lib/util/disclaimerLanguageSelect.dart`
- Review: `lib/disclaimerPage.dart`
- Test: `test/l10n/language_selector_guidelines_test.dart`
- Test: `test/l10n/arabic_locale_test.dart`

**Step 1: Re-run the failing selector test**

Run:

```bash
flutter test test/l10n/language_selector_guidelines_test.dart -r expanded
```

Expected: fail.

**Step 2: Remove the country-image data model**

Replace the current selector config:

```dart
{
  'locale': 'en',
  'label': 'English',
  'image': 'assets/images/united-states.png'
}
```

with a label-only structure:

```dart
{
  'locale': 'en',
  'label': 'English'
}
```

Do the same for Hebrew and Arabic. Do not add any replacement flag asset.

**Step 3: Add a neutral icon**

Render a generic language icon in the dropdown rows instead of per-locale images:

```dart
const Icon(Icons.language, size: 20)
```

Recommended row shape:

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Icon(Icons.language),
    SizedBox(width: 8),
  ],
)
```

then append the autonym `Text(...)`.

**Step 4: Preserve the exact autonym labels**

The visible labels must remain:

```text
English
עברית
العربية
```

Do not replace them with translated language names, country names, abbreviations, or mixed-script labels.

**Step 5: Run the tests to verify they pass**

Run:

```bash
flutter test test/l10n/language_selector_guidelines_test.dart test/l10n/arabic_locale_test.dart -r expanded
```

Expected: pass.

**Step 6: Commit**

```bash
git add lib/util/disclaimerLanguageSelect.dart test/l10n/language_selector_guidelines_test.dart test/l10n/arabic_locale_test.dart
git commit -m "refactor: remove flags from language selector"
```

### Task 3: Add failing RTL compliance tests for representative app-shell widgets

**Files:**
- Create: `test/l10n/rtl_layout_compliance_test.dart`
- Review: `lib/main.dart`
- Review: `lib/menu.dart`
- Review: `lib/form/formpagetemplate.dart`
- Review: `lib/initialForm/CountrySelectorWidget.dart`
- Review: `lib/pages/UserSettings.dart`
- Review: `lib/pages/WellnessTools/wellnessTools.dart`
- Review: `lib/pages/about.dart`

**Step 1: Create one framework-level RTL smoke test**

Assert that the app-level locale wiring still resolves RTL:

```dart
expect(Directionality.of(context), TextDirection.rtl);
```

under:

```dart
MaterialApp(
  locale: const Locale('ar'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
)
```

**Step 2: Create representative widget RTL tests**

Add focused tests for a few app-shell widgets rather than every screen at once. Cover:
- `CountrySelectorWidget`
- `Menu`
- one form-style widget (`FormPageTemplate` or `UserSettings`)

Use assertions around directional behavior, for example:

```dart
expect(Directionality.of(tester.element(find.byType(Text))), TextDirection.rtl);
```

and targeted layout expectations where possible:

```dart
expect(text.textAlign, TextAlign.start);
expect(container.alignment, AlignmentDirectional.centerStart);
```

**Step 3: Run the tests to verify at least one fails**

Run:

```bash
flutter test test/l10n/rtl_layout_compliance_test.dart -r expanded
```

Expected: failure on widgets that still rely on absolute `left`/`right` layout instead of directional APIs or explicit RTL branches.

**Step 4: Build the audit list before implementation**

Use this code search to inventory candidates:

```bash
Get-ChildItem lib -Recurse -Filter *.dart | Select-String -Pattern 'TextAlign.left|TextAlign.right|Alignment.centerLeft|Alignment.centerRight|EdgeInsets.only\\(left|EdgeInsets.only\\(right|Positioned\\(left|Positioned\\(right'
```

Start from the files already known to contain left/right logic:
- `lib/menu.dart`
- `lib/form/formpagetemplate.dart`
- `lib/initialForm/CountrySelectorWidget.dart`
- `lib/pages/UserSettings.dart`
- `lib/pages/WellnessTools/wellnessTools.dart`
- `lib/pages/about.dart`
- `lib/disclaimerPage.dart`

**Step 5: Commit**

```bash
git add test/l10n/rtl_layout_compliance_test.dart
git commit -m "test: add rtl compliance smoke coverage"
```

### Task 4: Replace absolute left/right layout with directional layout where appropriate

**Files:**
- Modify: `lib/menu.dart`
- Modify: `lib/form/formpagetemplate.dart`
- Modify: `lib/initialForm/CountrySelectorWidget.dart`
- Modify: `lib/pages/UserSettings.dart`
- Modify: `lib/pages/WellnessTools/wellnessTools.dart`
- Modify: `lib/disclaimerPage.dart`
- Review carefully: `lib/pages/about.dart`

**Step 1: Re-run the RTL compliance test**

Run:

```bash
flutter test test/l10n/rtl_layout_compliance_test.dart -r expanded
```

Expected: fail.

**Step 2: Convert generic UI layout to directional APIs**

Prefer framework-directional primitives over repeated locale conditionals:

```dart
TextAlign.start
TextAlign.end
AlignmentDirectional.centerStart
AlignmentDirectional.centerEnd
EdgeInsetsDirectional.fromSTEB(...)
```

Use directional APIs anywhere the content should mirror between English/Hebrew/Arabic automatically.

**Step 3: Keep explicit LTR only for approved exceptions**

Do not blindly convert these cases:
- English-only legal/credit text in `about.dart`
- version/build strings
- URLs
- phone numbers
- any intentionally Latin-script payload

For those, keep explicit LTR wrappers such as:

```dart
Directionality(
  textDirection: TextDirection.ltr,
  child: ...
)
```

Document each exception inline with a short comment if the reason is not obvious.

**Step 4: Run the tests to verify they pass**

Run:

```bash
flutter test test/l10n/rtl_layout_compliance_test.dart test/l10n/arabic_locale_test.dart -r expanded
```

Expected: pass.

**Step 5: Commit**

```bash
git add lib/menu.dart lib/form/formpagetemplate.dart lib/initialForm/CountrySelectorWidget.dart lib/pages/UserSettings.dart lib/pages/WellnessTools/wellnessTools.dart lib/disclaimerPage.dart lib/pages/about.dart test/l10n/rtl_layout_compliance_test.dart
git commit -m "refactor: align app shell with rtl layout rules"
```

### Task 5: Verify guideline compliance end-to-end

**Files:**
- Review: `lib/util/disclaimerLanguageSelect.dart`
- Review: `test/l10n/language_selector_guidelines_test.dart`
- Review: `test/l10n/rtl_layout_compliance_test.dart`
- Review: `test/l10n/arabic_locale_test.dart`

**Step 1: Run the focused automated verification**

Run:

```bash
flutter gen-l10n
flutter test test/l10n/language_selector_guidelines_test.dart -r expanded
flutter test test/l10n/rtl_layout_compliance_test.dart -r expanded
flutter test test/l10n/arabic_locale_test.dart -r expanded
```

Expected:
- locale generation succeeds
- selector guideline test passes
- RTL compliance smoke test passes
- Arabic locale/autonym/RTL baseline test passes

**Step 2: Run a manual QA checklist**

Verify on device or emulator:

```text
1. The disclaimer language selector shows a neutral language icon, not country flags.
2. The visible choices are exactly: עברית / English / العربية.
3. Arabic selection persists and reopens correctly after app restart.
4. Arabic screens read right-to-left in the selector, menu, onboarding, and form flows.
5. No obvious left-anchored components remain on representative Arabic screens.
6. Explicitly LTR content (English paragraphs, version strings, URLs, phone numbers) still reads correctly.
```

**Step 3: Record the final compliance result**

Document the result in the PR or ticket using this checklist:

```text
[ ] Flags removed
[ ] Autonyms preserved
[ ] RTL smoke tests added
[ ] RTL representative widgets verified
[ ] Manual QA completed
```

**Step 4: Commit**

```bash
git add test/l10n/language_selector_guidelines_test.dart test/l10n/rtl_layout_compliance_test.dart
git commit -m "test: verify language selector and rtl compliance"
```
