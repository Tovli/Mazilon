# Remove iPad Support Design

## Goal

Stop advertising iPad support from the iOS packaging configuration while leaving Flutter runtime behavior unchanged.

## Volatility

- Volatile: the set of Apple device families the app should be published for.
- Stable: the existing Flutter screens, business logic, and asset pipeline for iPhone.

This design keeps the change inside the iOS packaging boundary so the user-facing app behavior on iPhone remains stable.

## Approved Approach

Use the minimal target change:

1. Change the Runner target device family from `iPhone + iPad` to `iPhone` only.
2. Remove the iPad-only orientation declaration from the iOS plist.

## Boundaries

Modify only:

- `ios/Runner.xcodeproj/project.pbxproj`
- `ios/Runner/Info.plist`

Do not modify:

- Dart or Flutter UI code
- the app icon catalog
- iPad-related assets or filenames

## Expected Outcome

- The iOS target declares iPhone-only support.
- The plist no longer carries an iPad-specific orientation block.
- Any remaining iPad metadata outside these two files is intentionally left untouched.

## Verification

Verify by file inspection:

- `TARGETED_DEVICE_FAMILY = "1"` exists in the Runner build configurations.
- `UISupportedInterfaceOrientations~ipad` is absent from `ios/Runner/Info.plist`.

Native iOS build verification is out of scope in this Windows workspace.

## Risks

Risk is low because the change is limited to packaging metadata. The primary limitation is that `xcodebuild` cannot be run in this environment, so verification is configuration-level only.
