# AI Coding Agent - Architectural Decision Record Template

## ADR Metadata
- **ADR ID**: ADR-001
- **Agent ID**: Claude Opus 4.6
- **Task ID**: chore/upgrade-dependencies
- **Date**: 2026-04-16
- **Duration**: N/A (proposed, not yet implemented)
- **Status**: Proposed
- **AI Model/Version**: Claude Opus 4.6
- **Confidence Level**: High - Agent's confidence in this decision

## Executive Summary
**One-sentence decision summary**: Upgrade all 43 direct and 4 dev Flutter/Dart dependencies to their latest compatible versions using a phased, risk-stratified approach with individual commits per phase for safe rollback.

## Context & Problem Statement
### Problem Description
The Mazilon Flutter app's dependencies in `pubspec.yaml` have drifted behind their latest releases. Stale dependencies accumulate security vulnerabilities, miss performance improvements, and make future upgrades harder as the delta grows. Several dependency declarations are also misconfigured: two packages are exact-pinned without caret ranges blocking even patch updates, three transitive platform-interface packages are listed explicitly causing version-resolution conflicts, and `intl` uses the dangerously unconstrained `any` version specifier.

### Constraints & Requirements
- **Functional Requirements**: All existing app functionality must continue working across Android, iOS, Web, Windows, macOS, and Linux
- **Non-Functional Requirements**: CI must remain green; build sizes and startup times must not regress significantly
- **Technical Constraints**: CI pins Flutter 3.35.6; Dart SDK constraint is `>=3.2.5 <4.0.0`; Firebase packages must be mutually compatible
- **Business Constraints**: No downtime or broken deployments; the app is live on Google Play and Azure-hosted web

### Triggering Event
Routine maintenance request to bring all packages to their latest versions.

## Decision Drivers & Criteria
### Primary Decision Factors
1. Minimizing risk of breaking the live app
2. Maintaining CI compatibility (Flutter 3.35.6)
3. Keeping Firebase ecosystem packages mutually compatible
4. Enabling future upgrades by fixing misconfigured version constraints

### Evaluation Criteria & Weights
| Criteria | Weight (1-10) | Description |
|----------|---------------|-------------|
| Safety / rollback-ability | 10 | Each change must be independently revertible |
| CI compatibility | 9 | All changes must pass the existing GitHub Actions pipeline |
| Completeness | 7 | All packages should reach their latest compatible version |
| Minimal code churn | 6 | Avoid unnecessary API migration if the current version is close to latest |
| Cleanup of misconfigurations | 5 | Fix pinned versions, remove transitive deps, constrain `intl` |

## Options Considered
### Option 1: Phased, risk-stratified upgrade (Recommended)
- **Description**: Break the upgrade into 8 phases ordered by risk level (cleanup first, then constraint fixes, then bulk upgrades, then Firebase, then dev deps), each producing its own commit. Run tests and analysis after every phase.
- **Pros**:
  - Each phase is independently revertible via `git revert`
  - Failures are isolated — a Firebase conflict doesn't block unrelated UI package upgrades
  - Cleanup phases (removing transitive deps, fixing `intl`) reduce resolution conflicts before the bulk upgrade
  - Clear verification checkpoints
- **Cons**:
  - More commits and slightly more manual work than a single-shot approach
  - Intermediate states may not represent the final dependency resolution
- **Cost/Effort**: Medium — 8 focused phases, each straightforward
- **Risk Level**: Low to Medium (per phase)

### Option 2: Single-shot `flutter pub upgrade --major-versions`
- **Description**: Run `flutter pub upgrade --major-versions` once, fix all resulting errors, commit everything together.
- **Pros**:
  - Fastest to execute
  - Single commit
- **Cons**:
  - If it fails (likely due to Firebase conflicts or pinned packages), debugging is harder
  - No rollback granularity — must revert everything or nothing
  - Doesn't fix the underlying misconfigurations (exact pins, transitive deps listed explicitly)
  - `intl: any` remains dangerous
- **Cost/Effort**: Low initial effort, potentially high debugging effort
- **Risk Level**: High

### Option 3: Upgrade only patch/minor versions, skip major bumps
- **Description**: Only upgrade within existing caret ranges; don't bump any major versions.
- **Pros**:
  - Lowest risk of API breakage
  - No code changes needed beyond `pubspec.yaml`
- **Cons**:
  - Doesn't achieve the goal — many packages are multiple major versions behind
  - Leaves the growing upgrade debt in place
  - Doesn't fix misconfigured constraints
- **Cost/Effort**: Low
- **Risk Level**: Low

## Decision
### Chosen Option
**Selected**: Option 1 — Phased, risk-stratified upgrade

### Rationale
A phased approach provides the best balance of completeness and safety. The Mazilon app is live on Google Play and Azure web hosting, making rollback-ability critical. By fixing misconfigurations first (removing transitive deps, un-pinning exact versions), the subsequent bulk upgrade via `flutter pub upgrade --major-versions` is far more likely to resolve cleanly. Upgrading Firebase packages as a separate, atomic unit prevents the most common Flutter dependency-resolution failure from contaminating the rest of the upgrade. Each phase commits independently, so if Phase 5 (Firebase) fails in CI, Phases 1-4 are already landed and safe.

### Decision Matrix
| Option | Safety (10) | CI Compat (9) | Completeness (7) | Min Churn (6) | Cleanup (5) | Weighted Total |
|--------|-------------|---------------|-------------------|---------------|-------------|----------------|
| Option 1: Phased | 9 | 9 | 9 | 7 | 9 | **316** |
| Option 2: Single-shot | 4 | 6 | 9 | 8 | 3 | 218 |
| Option 3: Patch only | 9 | 9 | 3 | 10 | 2 | 241 |

## Implementation Details
### Technical Approach

**Phase 0 — Pre-flight** (no changes):
- Run `flutter pub outdated` to record current vs latest versions
- Run `flutter test` to confirm baseline passes
- Confirm local Flutter version matches CI (3.35.6)

**Phase 1 — Remove explicit platform interface packages** (LOW RISK):
Remove from `pubspec.yaml`:
- `cloud_firestore_web: ^5.0.3` — zero direct imports, transitive dep of `cloud_firestore`
- `cloud_firestore_platform_interface: ^7.0.3` — zero direct imports, transitive dep
- `url_launcher_platform_interface: ^2.3.2` — zero direct imports, transitive dep

These block upgrades of their parent packages by creating version-constraint conflicts. Verify with `flutter pub get` + `flutter test`. Commit.

**Phase 2 — Constrain `intl`** (LOW RISK):
Change `intl: any` to a proper caret range (e.g. `intl: ^0.19.0`) matching what Flutter 3.35.6's `flutter_localizations` expects. Check resolved version from `flutter pub outdated`. Commit.

**Phase 3 — Un-pin exact-version packages** (MEDIUM RISK):
- `url_launcher: 6.3.2` -> `url_launcher: ^6.3.2`
- `file_picker: 10.3.3` -> `file_picker: ^10.3.3`

Adding carets allows minor/patch updates. Both packages have stable APIs within their major version. Verify with `flutter pub get` + `flutter test`. Commit.

**Phase 4 — Bulk upgrade non-Firebase packages** (MEDIUM RISK):
Run `flutter pub upgrade --major-versions`. Review diff carefully. Packages needing extra attention:
- `share_plus` — verify `SharePlus.instance.share(ShareParams(...))` API
- `flutter_screenutil` — check `ScreenUtilInit` constructor
- `sentry_flutter` — check changelog for breaking changes
- `permission_handler` — verify `Permission.contacts.request()` pattern
- `flutter_local_notifications` — check API stability on high major version
- `workmanager` — pre-1.0, minor bumps can break
- `youtube_player_flutter` — verify `YoutubePlayerController` API

Run `flutter analyze` + `flutter test`. Fix compile errors. Commit.

**Phase 5 — Upgrade Firebase ecosystem as a unit** (HIGH RISK):
Update all Firebase packages simultaneously (they share internal version constraints):
- `firebase_core: ^4.2.0`
- `firebase_auth: ^6.1.1`
- `cloud_firestore: ^6.0.3`
- `firebase_database: ^12.0.3`

Check `flutter pub outdated` for the latest compatible set. If resolution fails, adjust versions. Commit.

**Phase 6 — Update Dart SDK constraint** (MEDIUM RISK):
Check Dart SDK bundled with Flutter 3.35.6 and tighten the lower bound from `>=3.2.5` to match what newest dependencies actually require. Commit.

**Phase 7 — Dev dependency upgrades** (LOW RISK):
- `mockito: ^5.4.4` — check for 6.x
- `build_runner: ^2.4.15` — upgrade, regenerate mocks
- `flutter_lints: ^6.0.0` — check for newer version

Run `flutter analyze` + `flutter test`. Commit.

**Phase 8 — Full verification**:
1. `flutter test --reporter=expanded`
2. `flutter analyze`
3. `flutter build appbundle --release`
4. `flutter build web --release`
5. `flutter pub outdated` — confirm nothing remains
6. Push branch, confirm CI passes

### Dependencies
- Flutter SDK 3.35.6 (must match CI)
- Dart SDK bundled with Flutter 3.35.6
- pub.dev package registry (for version resolution)
- Firebase BoM compatibility matrix

### Integration Points
- GitHub Actions CI pipeline (`.github/workflows/main.yml`) — validates builds and tests
- Firebase backend — upgraded Firebase SDK must remain compatible with the Firebase project config
- Google Play Store — Android app bundle must build successfully
- Azure Storage — Web build must deploy successfully

### Configuration/Setup Required
- Local Flutter SDK must be 3.35.6 to match CI
- After `build_runner` upgrade, regenerate mocks: `dart run build_runner build --delete-conflicting-outputs`

## Architecture & Design Impact
### System Architecture Changes
**Current Architecture State**: Flutter cross-platform app with Provider state management, Firebase backend, Sentry error tracking, Mixpanel analytics. 43 direct deps + 4 dev deps in `pubspec.yaml`.

**Proposed Architecture Changes**: No architectural changes. This is a dependency version bump only. The app's architecture, patterns, and code organization remain the same.

**Architecture Patterns Affected**:
- None — this is a dependency maintenance task, not an architectural change

### Code Organization & Structure
**Module Layout Changes**:
- **New Modules**: None
- **Modified Modules**: Only `pubspec.yaml` (version constraints) and potentially files with changed APIs
- **Deprecated Modules**: None

**File Organization Guidelines**:
- No changes to naming conventions, import patterns, or dependency structure

### Component Design
**New Components**: None

**Modified Components**:
| Component | Changes | Impact | Migration Path |
|-----------|---------|--------|----------------|
| `pubspec.yaml` | Version constraint updates, removal of 3 transitive deps | Dependency resolution | Edit version numbers |
| Files using changed APIs | Adapt to new API signatures if any | Compile errors | Fix per package changelog |

### Data Flow & Integration
**Data Flow Changes**: None expected — dependency upgrades don't alter app data flow.

**API/Interface Changes**:
- **New Interfaces**: None
- **Modified Interfaces**: Possible minor API signature changes in upgraded packages (handled in Phase 4)
- **Deprecated Interfaces**: None from our code; some package APIs may be deprecated by their maintainers

### Architecture Quality Attributes
**Impact on Quality Attributes**:
| Attribute | Current State | Target State | Implementation Strategy |
|-----------|---------------|--------------|------------------------|
| Performance | Baseline | Equal or improved | Newer packages often include perf fixes |
| Scalability | N/A | N/A | No change |
| Maintainability | Degrading (stale deps) | Improved | Latest deps are easier to maintain and have more community support |
| Testability | Baseline | Equal | Test infrastructure upgraded alongside |
| Security | At risk (stale deps) | Improved | Latest versions include security patches |
| Reliability | Baseline | Equal or improved | Bug fixes in newer versions |

### Technology Stack Impact
**Technology Choices**:
- **New Technologies**: None
- **Technology Changes**: Version bumps only
- **Technology Retirement**: 3 unnecessary transitive dependency declarations removed

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
- [x] Testing architecture aligned
- [x] Security architecture compliant
- [x] Performance requirements addressed

## Consequences & Impact Analysis
### Positive Consequences
- All dependencies at latest compatible versions, reducing security vulnerability surface
- Future upgrades become smaller and easier (less version delta to bridge)
- Misconfigured constraints fixed (exact pins, transitive deps, unconstrained `intl`)
- Access to latest bug fixes and performance improvements in all packages

### Negative Consequences/Risks
- **Firebase version conflict** — *Mitigation*: Upgrade all Firebase packages atomically in Phase 5; revert the single commit if resolution fails
- **Breaking API changes in upgraded packages** — *Mitigation*: Review changelogs for flagged packages; fix compile errors immediately; each phase is independently revertible
- **Subtle runtime behavior changes** — *Mitigation*: Full test suite + manual smoke testing + CI verification; Sentry will catch runtime errors post-deploy
- **`workmanager` pre-1.0 instability** — *Mitigation*: Test background task functionality carefully; pin to working version if 1.0 introduces breaking changes

### Impact Assessment
| Area | Impact Level | Description |
|------|-------------|-------------|
| Performance | Low | Newer packages may include minor perf improvements |
| Security | Medium | Latest versions include security patches for known CVEs |
| Maintainability | High | Up-to-date deps are easier to maintain and have active community support |
| Scalability | None | No scalability changes |
| Cost | None | All packages are open-source/free |
| Team Productivity | Medium | Developers work with current APIs and documentation |

## Validation & Monitoring
### Success Metrics
- **Metric 1**: `flutter pub outdated` shows 0 resolvable upgrades — run after implementation
- **Metric 2**: CI pipeline passes (tests + Android build + Web build) — GitHub Actions
- **Metric 3**: `flutter analyze` reports 0 errors — run locally and in CI
- **Metric 4**: Sentry error rate does not spike post-deploy — monitor for 48 hours

### Monitoring Plan
- **Monitoring Tools**: Sentry (error tracking), Mixpanel (analytics), GitHub Actions (CI)
- **Review Schedule**: Monitor Sentry for 48 hours post-deploy; run `flutter pub outdated` monthly
- **Key Indicators**: Crash rate increase, CI failures, user-reported bugs

### Rollback Plan
Each phase produces its own git commit. To rollback:
- **Single phase**: `git revert <commit-hash>` for the specific phase
- **All changes**: `git revert` the entire series of commits in reverse order
- **Emergency**: Reset branch to pre-upgrade commit and force-push (requires team coordination)

| Phase | Risk | Rollback |
|-------|------|----------|
| 1: Remove platform interfaces | Low | `git revert` — re-adds the 3 lines |
| 2: Constrain `intl` | Low | `git revert` — restores `any` |
| 3: Un-pin exact versions | Medium | `git revert` — restores exact pins |
| 4: Bulk upgrade | Medium | `git revert` — restores old caret ranges |
| 5: Firebase upgrade | High | `git revert` — must revert atomically |
| 6: SDK constraint | Medium | `git revert` — restores old constraint |
| 7: Dev deps | Low | `git revert` + regenerate mocks |

## Agent Reasoning Chain
### Decision-Making Process
1. **Analysis Phase**: Read `pubspec.yaml` to inventory all 47 dependencies. Read `.github/workflows/main.yml` to identify CI constraints (Flutter 3.35.6). Searched codebase for imports of each dependency to identify unused packages and validate that platform-interface packages have zero direct imports.
2. **Option Generation**: Identified three approaches — phased upgrade (Option 1), single-shot upgrade (Option 2), and patch-only upgrade (Option 3).
3. **Evaluation Phase**: Scored each option against weighted criteria (safety, CI compatibility, completeness, minimal churn, cleanup). Option 1 scored highest at 316 vs 241 and 218.
4. **Selection Logic**: Option 1 chosen because it uniquely combines full completeness with per-phase rollback safety, which is critical for a live production app deployed to Google Play and Azure.

### Tools & Resources Used
- **Glob/Grep**: Searched codebase for import statements of each dependency to audit usage
- **Read**: Read `pubspec.yaml`, `.github/workflows/main.yml`, `analysis_options.yaml`
- **Explore agent**: Deep codebase exploration for dependency usage, project structure, and CI configuration

### Knowledge Sources Consulted
- `pubspec.yaml` — dependency declarations and version constraints
- `.github/workflows/main.yml` — CI pipeline configuration and Flutter version pin
- Flutter pub documentation — `flutter pub upgrade --major-versions` behavior
- Flutter/Dart package management conventions — caret syntax, transitive dependencies

## Follow-up Actions
### Immediate Next Steps
- [ ] Phase 0: Run `flutter pub outdated` and `flutter test` to establish baseline
- [ ] Phase 1: Remove 3 explicit platform-interface packages
- [ ] Phase 2: Constrain `intl` with proper caret range
- [ ] Phase 3: Un-pin `url_launcher` and `file_picker`
- [ ] Phase 4: Run `flutter pub upgrade --major-versions` for non-Firebase packages
- [ ] Phase 5: Upgrade Firebase packages atomically
- [ ] Phase 6: Tighten Dart SDK lower bound
- [ ] Phase 7: Upgrade dev dependencies and regenerate mocks
- [ ] Phase 8: Full verification (tests, analysis, builds, CI)

### Future Considerations
- Investigate unused packages found during audit (`firebase_database`, `device_preview`, `encrypt`, `getwidget`, `googleapis`, `googleapis_auth`, `uuid`, `mobile_scanner`, `qr_flutter`, `font_awesome_flutter`, `devicelocale`) for potential removal
- Set up Dependabot or Renovate for automated dependency update PRs
- Consider running `flutter pub outdated` as a CI check to catch drift early

### Related ADRs
- None (first ADR in this project)

## Approval & Review
### Stakeholders Consulted
- Project maintainer (Tovli) — requested the upgrade

### Human Review Required
Yes — plan must be approved before implementation begins.

### Review Status
- **Technical Review**: Pending
- **Security Review**: N/A
- **Architecture Review**: Pending

---

## Agent Completion Metadata
- **Total Processing Time**: ~3 minutes (exploration + plan design)
- **Tokens Used**: N/A
- **Error Count**: 0
- **Research Iterations**: 2 (initial exploration + detailed plan design)
- **Confidence Score**: 85% — high confidence in the phased approach; moderate uncertainty on exact latest versions and whether any packages have breaking API changes that require code modifications

---

*This ADR was automatically generated by Claude Opus 4.6 on 2026-04-16*
*Last updated: 2026-04-16*
