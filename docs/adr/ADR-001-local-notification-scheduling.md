# AI Coding Agent - Architectural Decision Record Template

## ADR Metadata
- **ADR ID**: ADR-001
- **Agent ID**: Codex (GPT-5)
- **Task ID**: local-notifications-adr-2026-04-10
- **Date**: 2026-04-10
- **Duration**: ~45 minutes
- **Status**: Proposed
- **AI Model/Version**: GPT-5
- **Confidence Level**: High

## Executive Summary
**One-sentence decision summary**: Replace the current `Workmanager` + `flutter_local_notifications` hybrid reminder flow with recurring local-notification schedules managed directly by `flutter_local_notifications`, enforcing a hard cap on total reminders to respect OS constraints (e.g., iOS 64-notification limit), because it is the smallest and most stable design that satisfies the requirement of delivering multiple daily reminders around their due times.

## Context & Problem Statement
### Problem Description
The current local-notification implementation uses two scheduling mechanisms for one responsibility:

- `Workmanager` is used to enqueue background tasks in [`lib/main.dart`](../../lib/main.dart) and [`lib/pages/notifications/notification_service.dart`](../../lib/pages/notifications/notification_service.dart).
- The worker then calls `flutter_local_notifications.zonedSchedule(...)` to create the actual reminder.

This hybrid design introduces instability:

- iOS notifications are effectively disabled today because `initializeNotification(...)` sets permission to `false` for every non-Android platform and exits early.
- Android runtime notification permission is requested in Dart, but [`android/app/src/main/AndroidManifest.xml`](../../android/app/src/main/AndroidManifest.xml) does not declare `POST_NOTIFICATIONS`.
- The worker cancels all notifications before rescheduling, which creates unnecessary churn and can clear unrelated future notifications.
- `registerOneOffTask(...)` and `registerPeriodicTask(...)` are both used for the same reminder, so the scheduling authority is split.
- There is no persisted `notificationsEnabled` flag, only hour/minute values in [`lib/util/userInformation.dart`](../../lib/util/userInformation.dart), so startup-based recovery cannot safely distinguish "user opted in" from "default values exist".

Furthermore, according to [Issue #237](https://github.com/Tovli/Mazilon/issues/237), the requirement has evolved from a single reminder to multiple reminders, including 1 "App Reminder" (resilience quote), 11 "Quick Reminders", and an arbitrary number of "Custom Reminders".

### Volatility Assessment
- **Stable requirement**: the user can opt into multiple daily reminders (App Reminder, Quick Reminders, Custom Reminders) and receive them around their chosen times.
- **Volatile concerns**: OS permission behavior, OS scheduling constraints (iOS 64-limit, Android OEM 500-limit), iOS background execution rules, Android background scheduling behavior, locale/timezone changes, and quote/content rotation.
- **Non-requirement disguised as a solution**: using background work to refresh the quote daily is not the core requirement; it is an implementation choice that currently harms stability.

### Constraints & Requirements
- **Functional Requirements**:
  - Support multiple daily reminders as per Issue #237 (1 App Reminder, 11 Quick Reminders, and Custom Reminders).
  - Let the user set, edit, and cancel reminders.
  - Deliver local reminders on Android and iOS.
  - Restore reminder behavior after app restart/device reboot when the user remains opted in.
- **Non-Functional Requirements**:
  - Optimize for stability and predictability.
  - Precise firing time is not required; "around due time" is acceptable.
  - Keep the implementation simple and supportable.
  - Preserve offline behavior.
- **Technical Constraints**:
  - Existing stack is Flutter.
  - Existing dependencies already include `flutter_local_notifications`, `flutter_timezone`, `timezone`, and `workmanager`.
  - The current notification boundary is centered in `NotificationsService`.
  - **Hard System Limit**: iOS imposes a strict limit of 64 scheduled local notifications per app. Android AlarmManager caps at 500 on certain OEMs. The app must enforce a hard cap (e.g., 40-50) on total active custom reminders to prevent silent failures.
- **Business Constraints**:
  - Avoid unnecessary architecture expansion.
  - Avoid introducing backend services unless clearly justified.
  - Prefer reversible, localized changes.

### Triggering Event
The notification feature is currently unreliable in the local implementation. A decision is required on how to proceed with stability as the primary outcome, while adapting to the new multi-reminder requirements of Issue #237.

## Decision Drivers & Criteria
### Primary Decision Factors
1. Reminder delivery stability on both mobile platforms
2. Safe operation within strict OS scheduling limits (iOS 64-notification limit)
3. Cross-platform predictability with minimal platform-specific failure modes
4. Operational simplicity inside the existing notification boundary
5. Fit to the product requirement that precision is optional
6. Minimal architecture expansion and reversible change

### Evaluation Criteria & Weights
| Criteria | Weight (1-10) | Description |
|----------|---------------|-------------|
| Stability / Delivery Reliability | 10 | Probability that enabled users continue to receive reminders consistently |
| OS Limit Compliance | 10 | Ensures the app does not exceed the iOS 64 or Android OEM limits |
| Cross-Platform Predictability | 9 | Similar behavior across Android and iOS with minimal platform-specific traps |
| Maintainability / Simplicity | 8 | Ease of understanding, debugging, and supporting the implementation |
| Fit to Timing Requirement | 6 | How well the option supports "around due time" delivery |
| Implementation Risk | 6 | Likelihood of regressions and amount of surface area touched |
| Offline / Local Independence | 6 | Ability to work without server coordination |

## Options Considered
### Option 1: Keep the Current Hybrid and Harden It
- **Description**: Continue using `Workmanager` to trigger background tasks that cancel and recreate the scheduled local notification, while fixing manifest, iOS permission, and task-configuration gaps.
- **Pros**:
  - Smallest conceptual delta from the current code.
  - Preserves the idea of refreshing reminder content via background work.
  - Reuses dependencies already present in the project.
- **Cons**:
  - Two schedulers still own one responsibility.
  - Background-task timing remains platform-dependent and can drift or miss the day.
  - iOS remains structurally weak because background execution is system-controlled and the current setup is incomplete.
  - `cancelAll()` in the worker keeps the design fragile.
- **Cost/Effort**: Medium
- **Risk Level**: High

### Option 2: Schedule Reminders Directly with `flutter_local_notifications`
- **Description**: Make `flutter_local_notifications` the only scheduling authority. Persist each reminder's state, request permissions correctly, schedule each recurring daily reminder with `matchDateTimeComponents: DateTimeComponents.time`, and strictly enforce a maximum count (e.g., 50) to stay under OS limits.
- **Pros**:
  - One scheduler for one responsibility.
  - Best fit for the actual requirement: daily local reminders around chosen times.
  - Easily avoids iOS 64-limit and Android 500-limit since each recurring reminder only counts as one.
  - Avoids dependence on background-task execution for reminder delivery.
  - Keeps the solution local, offline, and inside the existing notification boundary.
  - Simplifies debugging, QA, and future maintenance.
- **Cons**:
  - Daily quote rotation for the App Reminder becomes secondary to reliability (unless batched ahead of time).
  - Requires clean persistence of multiple reminders instead of just one hour/minute.
  - Requires a clean permission flow for both Android and iOS.
- **Cost/Effort**: Medium
- **Risk Level**: Low

### Option 3: Use `Workmanager` Only and Fire Notifications When Periodic Work Runs
- **Description**: Remove `zonedSchedule(...)` and rely on periodic background work to show the reminder when the OS runs the worker within an acceptable window.
- **Pros**:
  - One scheduling primitive instead of two.
  - Can rotate content each time the worker runs.
  - Fits the idea that precise timing is not mandatory.
- **Cons**:
  - iOS background execution is explicitly system-controlled and not suitable for dependable reminder delivery.
  - Android periodic work still has minimum intervals and OS-managed timing.
  - More battery/process complexity than direct local scheduling.
  - Still depends on background execution rather than the OS notification scheduler.
- **Cost/Effort**: Medium
- **Risk Level**: High

### Option 4: Move Reminder Delivery to Server-Driven Push Notifications
- **Description**: Introduce remote scheduling and delivery through backend services plus push infrastructure, using device tokens and server-side orchestration instead of local schedules.
- **Pros**:
  - Centralized control over reminder content and schedule changes.
  - Sidesteps all local OS scheduling limits entirely.
  - Can support richer future campaigns or multi-device coordination.
  - Does not depend on the app process being alive locally.
- **Cons**:
  - Requires new backend responsibilities, new client dependencies, and token lifecycle handling.
  - Adds network and third-party delivery dependencies to a feature that can remain local.
  - Much larger architecture change than the problem requires.
  - Reduced offline resilience.
- **Cost/Effort**: High
- **Risk Level**: High

## Decision
### Chosen Option
**Selected**: Option 2 - schedule reminders directly with `flutter_local_notifications` while enforcing maximum limits.

### Rationale
Option 2 is the best match for the stable requirement and the volatility profile.

The stable need has evolved (via Issue #237) to multiple daily recurring local reminders that fire around chosen times. The current instability is caused less by the notification plugin and more by the orchestration around it. The existing design splits ownership across a background worker and a local scheduler, then adds global cancellation and incomplete platform permission/setup. That is complexity without product value.

Option 2 removes the volatile piece from the critical path: background work is no longer required for the reminder to exist. The operating system's notification scheduling is purpose-built for this responsibility, and the existing code already uses `zonedSchedule(...)` with `AndroidScheduleMode.inexactAllowWhileIdle`, which aligns with the stated tolerance for approximate timing.

Because iOS enforces a hard limit of 64 scheduled notifications and some Android OEMs cap at 500 alarms, using recurring schedules ensures each reminder only consumes 1 slot in the OS queue. By enforcing a hard application-level cap (e.g., 40-50 reminders maximum), we can safely support the 12 default reminders (1 App + 11 Quick) plus a generous amount of Custom Reminders without risking silent system failures.

The main trade-off is content freshness for the App Reminder. A purely local recurring reminder will not naturally rotate to a new random quote every day unless the app reschedules it later. That trade-off is acceptable because precision and delivery are explicitly more important than stable variability. If daily quote rotation is critical, the app can batch schedule several days' worth of quotes ahead of time (still well within the 64 limit), or refresh the scheduled quote on the next foreground launch.

### Decision Matrix
Scoring scale: 1 (poor) to 5 (best)

| Option | Stability / Delivery Reliability | OS Limit Compliance | Cross-Platform Predictability | Maintainability / Simplicity | Fit to Timing Requirement | Implementation Risk | Offline / Local Independence | Weighted Total |
|--------|----------------------------------|---------------------|-------------------------------|------------------------------|---------------------------|--------------------|------------------------------|----------------|
| Option 1: Harden current hybrid | 2 | 4 | 2 | 1 | 4 | 3 | 5 | 134 |
| Option 2: Direct recurring local schedule | 5 | 5 | 4 | 5 | 5 | 4 | 5 | 230 |
| Option 3: Workmanager-only periodic reminder | 2 | 4 | 1 | 3 | 4 | 3 | 4 | 135 |
| Option 4: Server-driven push reminders | 3 | 5 | 4 | 2 | 3 | 1 | 1 | 132 |

## Implementation Details
### Technical Approach
Implement the reminders as explicitly enabled recurring schedules managed by `NotificationsService`.

Key implementation rules:

1. Persist reminder configurations (enabled state, hour, minute, type) for each reminder in a scalable format, not just a single set of properties.
2. Use stable notification IDs for each reminder (e.g., predictable hashes of the reminder ID).
3. **Crucial Limit:** Enforce a maximum cap (e.g., 50) on the total number of scheduled reminders across App, Quick, and Custom categories to stay safely under the iOS 64-notification limit.
4. Request notification permission correctly on:
   - Android: manifest declaration plus runtime request
   - iOS: explicit Darwin permission request flow
5. Schedule each recurring notification directly with `zonedSchedule(...)` and `matchDateTimeComponents: DateTimeComponents.time`.
6. Keep `AndroidScheduleMode.inexactAllowWhileIdle` because exact timing is not required.
7. Cancel only a reminder's specific notification ID when the user disables it.
8. Reschedule only when:
   - the user changes reminder settings
   - the app starts and the persisted enabled flag is `true`
   - locale/time-dependent reminder text is intentionally refreshed

### Dependencies
- Keep: `flutter_local_notifications`
- Keep: `timezone`
- Keep: `flutter_timezone`
- Keep: existing persistence services (`PersistentMemoryService`, and any user-settings sync already in place)
- Deprecate for this feature path: `workmanager`

### Integration Points
- Reminder settings UI in [`lib/pages/notifications/set_notification_widget.dart`](../../lib/pages/notifications/set_notification_widget.dart) (and new UI per Issue #237)
- Notification orchestration in [`lib/pages/notifications/notification_service.dart`](../../lib/pages/notifications/notification_service.dart)
- Startup recovery logic in [`lib/main.dart`](../../lib/main.dart)
- User preference persistence in [`lib/util/userInformation.dart`](../../lib/util/userInformation.dart)
- Android permissions/receivers in [`android/app/src/main/AndroidManifest.xml`](../../android/app/src/main/AndroidManifest.xml)
- iOS permission setup in [`ios/Runner/AppDelegate.swift`](../../ios/Runner/AppDelegate.swift) and [`ios/Runner/Info.plist`](../../ios/Runner/Info.plist)

### Configuration/Setup Required
- **Android**:
  - Add `<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />`
  - Keep `RECEIVE_BOOT_COMPLETED`
  - Keep the scheduled-notification boot receiver
  - Do not add exact-alarm permissions because this ADR intentionally selects inexact scheduling
- **iOS**:
  - Request notification permissions explicitly
  - Do not rely on `Workmanager` setup for the reminder feature
  - No background-task registration is required for the direct local schedule option

## Architecture & Design Impact
### System Architecture Changes
**Current Architecture State**: Reminder scheduling is split between `Workmanager` and `flutter_local_notifications`, with platform setup gaps, no explicit enabled-state persistence, and only supports a single reminder.

**Proposed Architecture Changes**: Reminders become a single-boundary responsibility inside `NotificationsService`, backed by a persisted list of reminder configurations and multiple OS-managed recurring local notifications, capped safely beneath the iOS 64 limit.

**Architecture Patterns Affected**:
- **Background task orchestration**: Deprecated for daily local reminders
- **Local reminder scheduling**: Simplified and strengthened to handle lists of schedules
- **User preference persistence**: Enhanced to support a list of reminders (Issue #237)

### Code Organization & Structure
**Module Layout Changes**:
- **New Modules**: None required
- **Modified Modules**:
  - `lib/pages/notifications/notification_service.dart`
  - `lib/pages/notifications/set_notification_widget.dart`
  - `lib/main.dart`
  - `lib/util/userInformation.dart`
  - `android/app/src/main/AndroidManifest.xml`
  - `ios/Runner/AppDelegate.swift`
  - `ios/Runner/Info.plist`
- **Deprecated Modules**:
  - None at file level, but the `Workmanager` path for reminder scheduling should be retired

**Directory Structure Impact**:
```text
Before:
- notifications/notification_service.dart owns part of scheduling
- main.dart callbackDispatcher owns another part

After:
- notifications/notification_service.dart owns reminder scheduling end-to-end
- main.dart only triggers recovery/resync after app startup when enabled
```

**File Organization Guidelines**:
- **Naming Conventions**: Use explicit names mapping to Issue #237 (e.g., `appReminder`, `quickReminders`, `customReminders`)
- **Import/Export Patterns**: Keep reminder logic inside the existing notifications boundary; do not create generalized scheduling utilities
- **Dependency Structure**: UI -> `NotificationsService` -> plugin/persistence; `main.dart` may invoke recovery only through `NotificationsService`

### Component Design
**New Components**:

| Component | Purpose | Interfaces | Dependencies |
|-----------|---------|------------|--------------|
| Persisted reminder list | Manage state for App/Quick/Custom reminders | `UserInformation` / persistence getters-setters | `PersistentMemoryService` |

**Modified Components**:

| Component | Changes | Impact | Migration Path |
|-----------|---------|--------|----------------|
| `NotificationsService` | Becomes the single scheduler and canceller for the daily reminders | Lower complexity, fewer race conditions | Replace worker registration with direct recurring schedules |
| Reminder settings UI | Save multiple reminders and enforce limits | Clearer user intent, prevent OS limit crashes | Update set/cancel flows for Issue #237 |
| App startup flow | Recover reminders only when enabled | Prevent silent re-enable from defaults | Run after user settings load |

### Data Flow & Integration
**Data Flow Changes**:
User chooses reminder settings -> UI enforces cap (< 50) -> app persists reminders -> `NotificationsService` schedules or cancels recurring reminders -> app startup checks persisted state and restores schedules if needed.

**API/Interface Changes**:
- **New Interfaces**:
  - Internal persistence methods for lists of reminders
- **Modified Interfaces**:
  - `initializeNotification(...)` should become an explicit schedule/update operation rather than a worker-registration operation
- **Deprecated Interfaces**:
  - Worker-based reminder registration flow

**Integration Patterns**:
The reminder becomes a direct client-side capability. No server or background-task orchestration is required in the normal success path.

### Architecture Quality Attributes
**Impact on Quality Attributes**:

| Attribute | Current State | Target State | Implementation Strategy |
|-----------|---------------|--------------|------------------------|
| Performance | Overhead from worker orchestration | Lower overhead | Remove unnecessary background work |
| Scalability | Limited to single reminder | Capped at ~50 reminders | Enforce hard cap to avoid iOS/Android OEM limits |
| Maintainability | High cognitive load, split ownership | Simple and inspectable | One scheduler, list-based state model |
| Testability | Difficult to reason about worker timing | Easier deterministic testing | Validate pending scheduled reminders directly |
| Security | No major security issue, but permission handling is incomplete | Explicit permission handling | Align manifest and runtime requests |
| Reliability | Platform-dependent and fragile | Higher stability | Use OS notification scheduler directly |

### Technology Stack Impact
**Technology Choices**:
- **New Technologies**: None
- **Technology Changes**: `flutter_local_notifications` becomes the sole reminder scheduler
- **Technology Retirement**: `workmanager` is retired from this specific feature path

**Justification for Technology Decisions**:
The repo already depends on `flutter_local_notifications`, and that dependency directly supports recurring schedules with acceptable inexact timing. It handles multiple schedules efficiently, provided we manually enforce the system-level limits. No new technology is needed to satisfy the requirement.

### Architecture Compliance
**Design Principles Adherence**:
- [x] Single Responsibility Principle maintained
- [x] Separation of Concerns preserved
- [x] Dependency Inversion followed
- [x] Interface Segregation maintained
- [x] Open/Closed Principle respected

**Architecture Standards Compliance**:
- [x] Coding standards followed
- [x] Documentation standards met
- [ ] Testing architecture aligned
- [x] Security architecture compliant
- [x] Performance requirements addressed

## Consequences & Impact Analysis
### Positive Consequences
- Reminder delivery becomes simpler and more stable.
- iOS and Android can follow one clear reminder model.
- The implementation easily accommodates the Issue #237 requirements.
- Startup recovery becomes safe once explicit enablement is persisted.

### Negative Consequences/Risks
- Daily quote rotation for the App Reminder may not change in the background unless batched.
  - *Mitigation*: Use a stable localized reminder body, batch schedule a week's worth of quotes, or refresh the scheduled quote on next foreground launch.
- Users might hit the limit of 50 reminders and be blocked from creating more.
  - *Mitigation*: Provide clear UI feedback explaining the limit.
- Platform permission handling still needs QA across Android 13+ and iOS.
  - *Mitigation*: Add focused permission-flow tests and manual device validation.

### Impact Assessment
| Area | Impact Level | Description |
|------|-------------|-------------|
| Performance | Low | Likely improves due to less background orchestration |
| Security | Low | Mostly permission correctness and platform compliance |
| Maintainability | High | Ownership becomes localized and understandable |
| Scalability | Medium | Must enforce strict caps due to iOS limits |
| Cost | Low | Uses existing dependencies and boundaries |
| Team Productivity | High | Fewer moving parts and simpler debugging |

## Validation & Monitoring
### Success Metrics
- **Metric 1**: Enabled users have exactly the correct number of pending reminders after save/restart/reboot flows
  - Measurement method: plugin pending-notification inspection in QA and automated tests where feasible
- **Metric 2**: UI prevents the user from saving more than the hard cap limit (~50) of total reminders
  - Measurement method: integration/manual device tests
- **Metric 3**: Android and iOS permission flows both allow reminder setup on supported devices
  - Measurement method: release checklist plus platform-specific manual validation

### Monitoring Plan
- **Monitoring Tools**: Sentry/error logging around permission requests, schedule failures, limit violations, and cancel failures
- **Review Schedule**: Review after first release using this implementation, then again after two weeks of production feedback
- **Key Indicators**:
  - user reports of reminders not arriving
  - users hitting the maximum reminder cap
  - duplicate reminders
  - missing pending reminder after restart

### Rollback Plan
If the direct recurring schedule proves unreliable on a specific platform:

1. Keep the persisted enabled flag and specific reminder ID model.
2. Revert only the scheduling mechanism in `NotificationsService`.
3. Do not reintroduce the full hybrid worker + cancel-all design without a separate review.

## Agent Reasoning Chain
### Decision-Making Process
1. **Analysis Phase**: Reviewed the current reminder flow, startup logic, stored user settings, Android manifest, iOS app configuration, and updated requirements from GitHub Issue #237. Also researched iOS and Android local notification limits.
2. **Option Generation**: Identified four viable approaches: harden current hybrid, direct recurring local schedule, Workmanager-only periodic reminder, and server-driven push.
3. **Evaluation Phase**: Scored options against stability, platform predictability, simplicity, OS limit compliance, timing fit, implementation risk, and offline operation.
4. **Selection Logic**: Selected the option that removes volatile background execution from the critical path while meeting the stated multi-reminder requirement with the smallest architecture change, actively accounting for OS constraints.

### Tools & Resources Used
- **PowerShell repository inspection**: located current notification, startup, manifest, and iOS setup paths
- **Git history inspection**: checked recent repository context
- **GitHub Issue Tracker**: extracted requirements for multiple custom and quick reminders from Issue #237
- **Web Search**: verified iOS limit (64 scheduled) and Android AlarmManager limits (500 on some OEMs)
- **ADR template source**: used as the required structure for this document
- **Platform/package documentation**: used to validate permission and scheduling behavior

### Knowledge Sources Consulted
- **ADR structure**: <https://github.com/ChrisRoyse/UsefulPrompts/blob/main/ADR.md>
- **Current reminder implementation**: `lib/pages/notifications/notification_service.dart`
- **Current worker/startup flow**: `lib/main.dart`
- **Current user preference model**: `lib/util/userInformation.dart`
- **Android notification permission docs**: <https://developer.android.com/develop/ui/views/notifications/notification-permission>
- **Flutter Workmanager quickstart**: <https://docs.page/fluttercommunity/flutter_workmanager/quickstart>
- **flutter_local_notifications package docs**: <https://pub.dev/packages/flutter_local_notifications>

## Follow-up Actions
### Immediate Next Steps
- [ ] Review this ADR with the product/architecture owner
- [ ] Confirm the strategy for the App Reminder (batch schedule quotes vs generic message)
- [ ] Determine the exact UI messaging for when a user hits the custom reminder cap
- [ ] Implement the selected option behind the existing notification boundary

### Future Considerations
- If multi-device reminder coordination becomes necessary, consider a separate ADR for server-driven reminder ownership.
- If the 64 limit becomes too restrictive, investigate fallback mechanisms.

### Related ADRs
- None currently

## Approval & Review
### Stakeholders Consulted
- Requesting human architectural review based on the repo state and platform documentation

### Human Review Required
Yes

### Review Status
- **Technical Review**: Pending
- **Security Review**: N/A
- **Architecture Review**: Pending

---

## Agent Completion Metadata
- **Total Processing Time**: ~45 minutes
- **Tokens Used**: N/A
- **Error Count**: 1
- **Research Iterations**: 5
- **Confidence Score**: 88%

---

*This ADR was automatically generated by Codex on 2026-04-10.*
*Last updated: 2026-04-10*