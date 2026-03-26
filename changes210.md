# SOS Country Localization Changes

This document explains the technical changes introduced for issue `#210` on branch `issue-210-countries`.

## Scope

The work was intentionally limited to the existing SOS/settings boundary.

The reported symptoms were:

- the SOS flow could expose country-specific resources that were incomplete or stale
- some entries needed `chat` or `text` actions, but the SOS dialog only supported `call`, `WhatsApp`, and `website`
- EU and Australia SOS actions were reported as unavailable or not working as expected

The implementation was constrained to:

- existing SOS country data in `lib/EmergencyNumbers.dart`
- existing SOS card/dialog widgets
- existing URL launch helpers
- focused regression coverage

The settings UI itself was not expanded because a country selector already exists in `UserSettings` and the SOS page already reads the saved country from `UserInformation.location`.

## Files Changed

- `lib/EmergencyNumbers.dart`
- `lib/util/Phone/EmergencyPhones.dart`
- `lib/util/Phone/emergencyDialogBox.dart`
- `lib/util/Phone/phoneTextAndIcon.dart`
- `test/emergency_whatsapp_test.dart`

## Root Cause Analysis

### 1. The SOS action model was too narrow

The SOS dialog could only render three action types:

- phone call
- WhatsApp
- website link

That was enough for the original Israel-focused entries, but it was not enough for country datasets that required:

- SMS/text actions, such as Papyrus, Shout, Crisis Text Line, and Lifeline Australia
- chat-link actions, such as Veterans Crisis Line, The Trevor Project, 988 Lifeline, and Beyond Blue

As a result, some services could only be partially represented, and some requested actions were missing entirely.

### 2. Some country data was outdated or incomplete

Several entries in the non-Israel datasets were missing actionable fields or used older contact details.

Examples:

- Papyrus previously exposed a website instead of a direct text action
- Veterans Crisis Line still used the older 1-800 number rather than the current `988` + press `1` flow
- Trevor and 988 had no explicit chat action metadata
- EU emergency data did not define a `link` field, which made it inconsistent with the rest of the SOS dialog contract

### 3. Launch helpers relied on `canLaunchUrl(...)` pre-checks

The shared SOS launch helpers gated actions behind `canLaunchUrl(...)`.

That pattern can be unreliable for `tel:` and `sms:` flows, and it adds an unnecessary failure branch before attempting the actual launch.

## Detailed Implementation

### `lib/EmergencyNumbers.dart`

The existing country map was kept in place and only the affected SOS entries were updated.

Small data extensions were added where needed:

- `textNumber`
- `textMessage`
- `linkType`

These keys are optional and local to the SOS data boundary.

Updated datasets:

- USA:
  - Veterans Crisis Line now uses `988`, adds `838255` text, and exposes the official chat URL
  - The Trevor Project now exposes call, text, and chat metadata
  - `988 Suicide & Crisis Lifeline` now exposes both text and chat metadata
  - Crisis Text Line now exposes an actionable SMS path with `HOME`
- UK:
  - Shout now exposes an actionable SMS path
  - Papyrus now exposes call + text directly and removes the website action
- EU:
  - `112` now has an explicit empty `link` field so the SOS dialog can treat it consistently as a call-only entry
- Australia:
  - Lifeline Australia now exposes both SMS and chat metadata
  - Beyond Blue now points to the current support/chat page

### `lib/util/Phone/EmergencyPhones.dart`

The SOS grid still resolves country data exactly as before.

The only change here was to pass the new optional SOS action fields into the existing dialog:

- `textNumber`
- `textMessage`
- `linkType`

No routing, selection, or provider behavior was changed.

### `lib/util/Phone/emergencyDialogBox.dart`

The dialog was extended in place rather than replaced.

Changes:

- added optional dialog inputs for `textNumber`, `textMessage`, and `linkType`
- added a `Text` action button when `textNumber` exists
- allowed website links to be labeled as `Chat` when `linkType == 'chat'`
- changed the action layout from `Row` to `Wrap` so the dialog can handle the extra action without overflow

The existing `call` and `WhatsApp` behavior was preserved.

### `lib/util/Phone/phoneTextAndIcon.dart`

The shared SOS launch helpers were updated to attempt the launch directly and only log if the launch itself fails.

Changes:

- `dialPhone(...)` now launches a `tel:` URI directly
- `openSite(...)` now launches the site directly
- `openWhatsApp(...)` now launches the WhatsApp URL directly
- added `openTextMessage(...)` for `sms:` URIs with optional message bodies

This keeps all action launching inside the existing phone helper file.

## Test Coverage

### `test/emergency_whatsapp_test.dart`

The test file was extended to cover:

- updated SOS data for USA, UK, EU, and Australia
- WhatsApp launch behavior
- SMS launch behavior
- chat-link labeling in the SOS dialog
- saved country overriding locale fallback in `EmergencyPhonesGrid`

### Existing coverage still used

`test/country_selector_widget_test.dart` still verifies that country data defaults from locale when no explicit saved country exists.

## What Was Not Changed

To keep the fix reviewable and localized, the following were intentionally left unchanged:

- settings navigation and page structure
- provider shape and persistence model
- localization keys and translations
- onboarding flow structure
- unrelated SOS styling outside the action dialog/card path

## Verification Performed

Targeted verification was run with:

```bash
flutter test test/emergency_whatsapp_test.dart test/country_selector_widget_test.dart
```

Result:

- all tests passed

## Notes On Current Official Data

Because this issue touches crisis-support contacts, the updated USA, UK, and Australia entries were aligned with current official service pages checked during implementation.

Two screenshot values were intentionally replaced with current official details:

- Papyrus text support now uses `88247`
- Veterans Crisis Line now uses `988` then press `1`

## Summary

This fix keeps the existing country-selection architecture and narrows the implementation to the SOS data + action path.

The result is:

- country-specific SOS resources remain driven by the saved country setting
- services that require `text` or `chat` actions can now be represented directly
- the requested USA, UK, EU, and Australia SOS issues are addressed without introducing new layers or changing app structure
