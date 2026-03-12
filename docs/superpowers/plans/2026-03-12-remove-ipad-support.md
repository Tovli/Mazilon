# Remove iPad Support Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the iOS app target iPhone-only without changing Flutter runtime code or cleaning up unrelated iPad metadata.

**Architecture:** Keep the change inside the existing iOS packaging boundary. Update the Xcode project device-family setting and remove the dead iPad orientation plist block, then verify both file-level outcomes directly.

**Tech Stack:** Flutter, iOS Xcode project configuration, plist metadata

---

## Chunk 1: iPhone-only packaging

### Task 1: Remove iPad support from the iOS target metadata

**Files:**
- Modify: `ios/Runner.xcodeproj/project.pbxproj`
- Modify: `ios/Runner/Info.plist`
- Reference: `docs/superpowers/specs/2026-03-12-remove-ipad-support-design.md`

- [ ] **Step 1: Verify the current iPad support markers exist**

Run:
```powershell
Select-String -Path 'C:\Code\Mallshoplink\Mazilon\ios\Runner.xcodeproj\project.pbxproj' -Pattern 'TARGETED_DEVICE_FAMILY = "1,2"'
Select-String -Path 'C:\Code\Mallshoplink\Mazilon\ios\Runner\Info.plist' -Pattern 'UISupportedInterfaceOrientations~ipad'
```

Expected:
- `project.pbxproj` shows `TARGETED_DEVICE_FAMILY = "1,2"` in the Runner build configurations.
- `Info.plist` shows the iPad orientation key.

- [ ] **Step 2: Change the Runner target to iPhone-only**

Update every Runner `TARGETED_DEVICE_FAMILY` assignment from `"1,2"` to `"1"`.

- [ ] **Step 3: Remove the iPad orientation plist block**

Delete the `UISupportedInterfaceOrientations~ipad` key and its array from `ios/Runner/Info.plist`.

- [ ] **Step 4: Verify the new configuration**

Run:
```powershell
Select-String -Path 'C:\Code\Mallshoplink\Mazilon\ios\Runner.xcodeproj\project.pbxproj' -Pattern 'TARGETED_DEVICE_FAMILY = "1"'
Select-String -Path 'C:\Code\Mallshoplink\Mazilon\ios\Runner\Info.plist' -Pattern 'UISupportedInterfaceOrientations~ipad'
```

Expected:
- `project.pbxproj` shows `TARGETED_DEVICE_FAMILY = "1"`.
- `Info.plist` returns no match for `UISupportedInterfaceOrientations~ipad`.

- [ ] **Step 5: Inspect the resulting diff**

Run:
```powershell
git -c safe.directory=C:/Code/Mallshoplink/Mazilon diff -- ios/Runner.xcodeproj/project.pbxproj ios/Runner/Info.plist docs/superpowers/specs/2026-03-12-remove-ipad-support-design.md docs/superpowers/plans/2026-03-12-remove-ipad-support.md
```

Expected:
- Only the approved spec, plan, and the two iOS packaging files are changed.
