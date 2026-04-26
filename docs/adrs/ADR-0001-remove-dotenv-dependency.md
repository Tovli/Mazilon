# ADR-0001: Remove `dotenv` Library Usage

## ADR Metadata

- ADR ID: ADR-0001
- Agent ID: Codex
- Task ID: `user-2026-04-20-remove-dotenv-adr`
- Date: 2026-04-20
- Duration: Single working session
- Status: Proposed
- AI Model/Version: GPT-5 Codex
- Confidence Level: Medium

## Executive Summary

One-sentence decision summary: remove `flutter_dotenv` usage from the Flutter application path and move configuration injection to the build boundary by using Dart compile-time defines.

## Context & Problem Statement

### Problem Description

This ADR is scoped to the Flutter application and runtime path only.

The repository currently depends on `dotenv`-style configuration loading in the Flutter application:

- Flutter application code loads an asset file named `dotenv` through `flutter_dotenv`.

Current tracked usage:

- `lib/AnalyticsService.dart` loads `MIXPANEL_PROJECT_TOKEN` from `dotenv`.
- `lib/main.dart` loads `SENTRY_DSN` inside `callbackDispatcher`.
- `lib/util/logger_service.dart` loads `SENTRY_DSN` before app startup.
- `pubspec.yaml` declares the `flutter_dotenv` package and the `dotenv` asset.
- `.github/workflows/main.yml` creates a generated `dotenv` file during CI builds.

This adds dependency surface area and couples volatile configuration to a runtime file-loading convention. The volatile part of this problem is the deployment-specific value of configuration keys and whether they are present in a given environment. The stable part is the set of current consumers: Sentry initialization and Mixpanel initialization.

Keeping the volatility at the deployment boundary is preferable to distributing it through runtime asset loading.

### Out of Scope

- `createARBfile.py`
- Any local translation tooling
- Removal of `python-dotenv` from non-Flutter scripts

### Constraints & Requirements

- Functional Requirements:
  - The app must continue to initialize Sentry only when `SENTRY_DSN` is provided.
  - The app must continue to initialize Mixpanel only when `MIXPANEL_PROJECT_TOKEN` is provided.
  - The background worker path in `lib/main.dart` must continue to behave correctly when telemetry configuration is present or absent.
- Non-Functional Requirements:
  - Reduce third-party dependency count.
  - Keep configuration behavior explicit and reviewable.
  - Avoid checking secrets into the repository.
  - Preserve predictable local and CI workflows.
- Technical Constraints:
  - Existing architecture and consumer boundaries should remain intact.
  - No new cross-cutting configuration layer should be introduced unless implementation evidence requires it.
  - GitHub Actions already exports repository secrets and can pass them directly into build commands.
- Business Constraints:
  - Release automation must remain functional.
  - Monitoring and analytics should remain optional rather than block startup when values are missing.
  - Onboarding changes should be small enough to document in the existing developer setup material.

### Triggering Event

A user request on 2026-04-20 asked for an ADR whose goal is to remove `dotenv` library usage in order to reduce dependencies.

## Decision Drivers & Criteria

### Primary Decision Factors

1. Reduce direct and indirect dependency surface area.
2. Keep volatile configuration at the deployment or execution boundary.
3. Minimize risk to current application behavior.
4. Keep the resulting developer workflow explicit and maintainable.

### Evaluation Criteria & Weights

| Criteria | Weight (1-10) | Description |
| --- | ---: | --- |
| Dependency reduction | 10 | Removes unnecessary libraries and package maintenance overhead. |
| Volatility containment | 9 | Keeps changing values at the boundary that owns them rather than inside the app asset model. |
| Delivery risk | 8 | Limits the chance of breaking builds or telemetry during migration. |
| Developer clarity | 6 | Makes the required configuration path obvious for local work and CI. |

## Options Considered

### Option 1: Keep the current `dotenv`-based approach

- Description: retain `flutter_dotenv`, keep the `dotenv` asset in Flutter, and continue generating `dotenv` in CI.
- Pros:
  - No implementation work is required.
  - Current behavior is already understood by the repository.
  - Local developers can continue using the existing file-based flow.
- Cons:
  - Dependency count does not decrease.
  - Runtime behavior remains coupled to a generated asset file.
  - The workflow continues to encode a solution pattern rather than the real volatility boundary.
- Cost/Effort: Low
- Risk Level: Low

### Option 2: Remove `flutter_dotenv` and use native build injection

- Description: replace Flutter `dotenv` reads with Dart compile-time environment access such as `String.fromEnvironment` and pass values through `--dart-define` or `--dart-define-from-file`.
- Pros:
  - Removes the dependency that motivated the change.
  - Keeps volatile values at the build or execution boundary where they belong.
  - Eliminates the generated `dotenv` asset contract from CI and `pubspec.yaml`.
- Cons:
  - Build and run commands must be updated.
  - Local developer setup becomes more explicit and may feel less convenient until documentation is updated.
  - Missing values must be handled carefully to preserve current optional behavior.
- Cost/Effort: Medium
- Risk Level: Medium

### Option 3: Replace `flutter_dotenv` with a custom parser or a different configuration package

- Description: remove the current library but preserve the same overall file-loading model by introducing another package or custom configuration parser.
- Pros:
  - Can preserve a familiar local file-based workflow.
  - Can remove the specific current library names from the dependency graph.
- Cons:
  - Does not address the core design issue of keeping volatility in the wrong place.
  - Either adds a new dependency or adds custom code that replicates a solved problem.
  - Retains a repository-level file contract that is not required by the actual consumers.
- Cost/Effort: Medium
- Risk Level: Medium

## Decision

### Chosen Option

Selected: Option 2 - Remove `flutter_dotenv` and use native build injection.

### Rationale

This option best matches the stated goal and the repository rules.

The key volatile element is not "a `.env` file"; it is the presence and value of environment-specific configuration at build time. The stable elements are the consumers that need those values: Sentry and Mixpanel. Therefore the decision is to keep the consumer boundaries as they are and move the volatile input mechanism to the edge that already owns deployment concerns.

Why this option was selected:

- It removes the targeted dependency instead of renaming it.
- It avoids inventing a new architectural layer or shared configuration service.
- It localizes change to the current consumers and build pipeline.
- It makes CI behavior more direct because the workflow can pass values into the build instead of creating a temporary runtime asset.

Accepted trade-offs:

- Developers will need explicit launch configuration.
- CI commands become slightly more verbose.
- The implementation must preserve today's "feature is disabled when value is absent" behavior.

Specific benefits that outweighed the drawbacks:

- Fewer dependencies to audit, upgrade, and troubleshoot.
- Clearer ownership of configuration volatility.
- Better alignment with the existing architectural boundaries in the codebase.

### Decision Matrix

| Option | Dependency Reduction (10) | Volatility Containment (9) | Delivery Risk (8) | Developer Clarity (6) | Weighted Total |
| --- | ---: | ---: | ---: | ---: | ---: |
| Option 1: Keep current approach | 1 | 3 | 9 | 6 | 145 |
| Option 2: Native build injection | 10 | 9 | 7 | 7 | 279 |
| Option 3: Custom parser or replacement package | 4 | 4 | 5 | 5 | 146 |

## Implementation Details

### Technical Approach

Implementation should follow these steps:

1. Replace `dotenv.load(...)` and `dotenv.env[...]` usage in Flutter consumers with compile-time values accessed through Dart's native environment mechanism.
2. Pass those values through build and run commands using `--dart-define` or `--dart-define-from-file`.
3. Remove the `flutter_dotenv` dependency and the `dotenv` asset from `pubspec.yaml`.
4. Remove CI steps that generate a `dotenv` file and replace them with direct build argument injection.
5. Update developer documentation so local setup remains discoverable.

Implementation notes:

- Flutter code should keep configuration access near the existing consumers unless duplication becomes materially harmful.
- This ADR does not authorize a new global configuration service.
- This ADR does not cover local tooling scripts such as `createARBfile.py`.
- For client-side builds, `SENTRY_DSN` and `MIXPANEL_PROJECT_TOKEN` should be treated as deploy-time configuration values, not as confidential server-side secrets.

### Dependencies

- Removed:
  - `flutter_dotenv`
- Retained:
  - GitHub Actions secrets
  - Dart compile-time environment support

### Integration Points

- `.github/workflows/main.yml`
- `pubspec.yaml`
- `lib/AnalyticsService.dart`
- `lib/main.dart`
- `lib/util/logger_service.dart`
- Developer setup documentation such as `environment-setup.md`

### Configuration/Setup Required

- CI:
  - Pass `SENTRY_DSN` and `MIXPANEL_PROJECT_TOKEN` to Flutter builds through `--dart-define` or `--dart-define-from-file`.
- Local Flutter development:
  - Provide telemetry values only when needed through launch configuration or CLI arguments.
- Repository:
  - Do not require a tracked or generated `dotenv` runtime asset.

## Architecture & Design Impact

### System Architecture Changes

Current Architecture State: configuration values are loaded through a generated runtime asset for Flutter.

Proposed Architecture Changes: configuration values move to the build boundary while the existing consumer responsibilities remain where they are.

Architecture Patterns Affected:

- Runtime asset configuration loading: Deprecated
- Build-time configuration injection: Enhanced
- Consumer-local initialization: Preserved

### Code Organization & Structure

Module Layout Changes:

- New Modules: None required by the decision
- Modified Modules:
  - Flutter telemetry consumers
  - CI workflow
  - Developer documentation
- Deprecated Modules:
  - None

Directory Structure Impact:

Before:

- `pubspec.yaml` includes a `dotenv` asset.
- CI creates a `dotenv` file before builds.

After:

- No `dotenv` asset is required for app startup.
- No generated `dotenv` file is required in CI.

File Organization Guidelines:

- Naming Conventions:
  - Keep existing variable names: `SENTRY_DSN`, `MIXPANEL_PROJECT_TOKEN`.
- Import/Export Patterns:
  - Prefer native language or platform access over a repository-specific configuration abstraction.
- Dependency Structure:
  - Configuration provider -> build or execution boundary -> existing consumer.

### Component Design

New Components:

| Component | Purpose | Interfaces | Dependencies |
| --- | --- | --- | --- |
| None | No new component is required by this ADR. | N/A | N/A |

Modified Components:

| Component | Changes | Impact | Migration Path |
| --- | --- | --- | --- |
| `MixPanelService` | Replace runtime asset lookup with compile-time value access. | Localized to analytics initialization. | Update token lookup and preserve no-token behavior. |
| `callbackDispatcher` in `lib/main.dart` | Replace runtime asset lookup for Sentry DSN. | Localized to background notification flow. | Read compile-time value and keep conditional init. |
| `SentryServiceImpl` | Replace runtime asset lookup before `runApp`. | Localized to app startup. | Read compile-time value and preserve fallback startup path. |

### Data Flow & Integration

Data Flow Changes: configuration values will flow from GitHub secrets or local launch settings directly into the Flutter build instead of being written into an intermediate `dotenv` file.

API/Interface Changes:

- New Interfaces: None
- Modified Interfaces:
  - Flutter build and run commands
- Deprecated Interfaces:
  - The generated `dotenv` asset contract

Integration Patterns: the deployment pipeline remains the integration point for deploy-specific values, while application modules keep ownership of their own optional initialization rules.

### Architecture Quality Attributes

| Attribute | Current State | Target State | Implementation Strategy |
| --- | --- | --- | --- |
| Performance | Minor runtime overhead for loading and parsing an asset file. | No runtime file parse for configuration values. | Read compile-time values directly. |
| Scalability | Neutral. | Neutral. | No architectural scale change is required. |
| Maintainability | Extra dependency and asset convention must be maintained. | Fewer moving parts and more direct configuration flow. | Remove `dotenv` dependencies and document the new path. |
| Testability | Tests and builds can rely on implicit file behavior. | Tests can set values explicitly via build config or mocks. | Keep consumer logic local and deterministic. |
| Security | Configuration file handling exists in CI. | Fewer intermediate files and clearer boundary ownership. | Pass values directly where possible and avoid tracked assets. |
| Reliability | App behavior depends on runtime file presence and load order. | App behavior depends on explicit build inputs. | Validate missing values and preserve optional startup behavior. |

### Technology Stack Impact

Technology Choices:

- New Technologies: None
- Technology Changes:
  - Use Dart compile-time environment access for Flutter
- Technology Retirement:
  - `flutter_dotenv`

Justification for Technology Decisions: the chosen mechanisms are already part of the platform stack, reduce package maintenance burden, and better align configuration volatility with the boundaries that already own deployment and execution.

### Architecture Compliance

Design Principles Adherence:

- Single Responsibility Principle maintained inside existing consumers.
- Separation of concerns preserved by keeping configuration volatility at the boundary.
- Dependency inversion is not expanded without volatility evidence.
- Interface segregation is unchanged because no new interfaces are introduced.
- Open/closed concerns are handled through localized replacement rather than speculative extensibility.

Architecture Standards Compliance:

- Coding standards can remain unchanged.
- Documentation standards are addressed through this ADR.
- Testing should remain focused on present or absent configuration behavior.
- Security handling improves by reducing intermediate files.
- Performance requirements are met with a simpler startup path.

## Consequences & Impact Analysis

### Positive Consequences

- Removes the targeted dependency from the Flutter application path.
- Makes configuration flow more explicit in CI and local development.
- Reduces coupling to a generated runtime asset file.

### Negative Consequences/Risks

- Missing build defines may disable telemetry unintentionally.
  - Mitigation: keep explicit debug logging and add CI checks for required release inputs.
- Local developer setup becomes more explicit and may cause short-term friction.
  - Mitigation: update documentation and, if needed, provide local launch examples.
- Client-side values remain visible in client artifacts.
  - Mitigation: treat `SENTRY_DSN` and `MIXPANEL_PROJECT_TOKEN` as client configuration identifiers, not confidential server-side secrets.

### Impact Assessment

| Area | Impact Level | Description |
| --- | --- | --- |
| Performance | Low | Slightly improves startup path by removing file load and parse work. |
| Security | Medium | Improves boundary clarity and reduces intermediate files, but does not change the public nature of client-side identifiers. |
| Maintainability | High | Removes dependency management and hidden file conventions. |
| Scalability | None | Does not materially change system scale characteristics. |
| Cost | Low | Work is localized to a few consumers and build scripts. |
| Team Productivity | Medium | Short-term workflow change, long-term simplification. |

## Validation & Monitoring

### Success Metrics

The decision is successful if the Flutter application path no longer requires `flutter_dotenv` while preserving current optional behavior for telemetry.

- Metric 1: `flutter_dotenv` no longer appears in `pubspec.yaml` or `pubspec.lock`.
- Metric 2: `pubspec.yaml` no longer declares the `dotenv` asset and CI no longer generates it.
- Metric 3: Android and web builds succeed with explicit build inputs.

### Monitoring Plan

The repository should monitor the migration through existing operational and build signals.

- Monitoring Tools:
  - GitHub Actions build results
  - Sentry event ingestion
  - Mixpanel event ingestion
- Review Schedule:
  - Review after the first release that includes the migration, then again after one normal development cycle.
- Key Indicators:
  - Unexpected loss of telemetry after deployment
  - Build failures caused by missing defines
  - Developer confusion around local setup

### Rollback Plan

If the migration proves too disruptive, rollback can be performed by restoring the old file-based loading path:

1. Reintroduce `flutter_dotenv` in `pubspec.yaml`.
2. Restore the `dotenv` asset declaration.
3. Restore CI generation of the `dotenv` file.
4. Keep existing variable names unchanged so rollback remains mechanical.

## Agent Reasoning Chain

### Decision-Making Process

1. Analysis Phase: inspected the referenced ADR template, reviewed repository documentation structure, and identified current `dotenv` usage in Flutter and CI.
2. Option Generation: considered retaining the current approach, replacing it with native platform mechanisms, or substituting another parser or package.
3. Evaluation Phase: compared options primarily on dependency reduction, volatility containment, migration risk, and workflow clarity.
4. Selection Logic: selected the option that removes the dependency while preserving existing consumer boundaries and avoiding a new architecture layer.

### Tools & Resources Used

- GitHub ADR template:
  - `https://github.com/ChrisRoyse/UsefulPrompts/blob/main/ADR.md`
- Repository files:
  - `AGENTS.md`
  - `.github/workflows/main.yml`
  - `pubspec.yaml`
  - `lib/AnalyticsService.dart`
  - `lib/main.dart`
  - `lib/util/logger_service.dart`
  - `environment-setup.md`

### Knowledge Sources Consulted

- `AGENTS.md`: repository-specific engineering constraints and stop conditions.
- `.github/workflows/main.yml`: current CI handling of the generated `dotenv` file.
- `pubspec.yaml`: current dependency and asset declarations.
- `lib/AnalyticsService.dart`, `lib/main.dart`, `lib/util/logger_service.dart`: current Flutter consumer boundaries for configuration values.

## Follow-up Actions

### Immediate Next Steps

- Obtain human review and approval for the proposed decision.
- Implement the localized migration in the identified Flutter consumers and workflow.
- Update developer setup documentation to describe the new configuration flow.

### Future Considerations

- Reassess only if new configuration consumers appear and repeated access becomes materially duplicated.
- Do not introduce a shared configuration abstraction unless real volatility and duplication evidence justify it.
- If local developer ergonomics become a recurring issue, prefer native build tooling such as `--dart-define-from-file` over reintroducing a runtime parser dependency.

### Related ADRs

No related ADRs currently exist in this repository.

## Approval & Review

### Stakeholders Consulted

- Current repository state
- User request for this ADR

No human architectural review has occurred yet.

### Human Review Required

Yes. This decision affects multiple existing boundaries and changes a repository-wide configuration pattern.

### Review Status

- Technical Review: Pending
- Security Review: Pending
- Architecture Review: Pending

* * *

## Agent Completion Metadata

- Total Processing Time: Approximately 20 minutes
- Tokens Used: N/A
- Error Count: 0
- Research Iterations: 2
- Confidence Score: 84%

* * *

This ADR was generated by Codex on 2026-04-20. Last updated: 2026-04-20.

## Footer

Repository: `Mazilon`
