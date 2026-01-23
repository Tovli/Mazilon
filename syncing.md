# Syncing Across Devices (Technical Brainstorm)

## Scope and goals
- Recover user data on a new device after loss or reinstall.
- Keep multiple devices consistent without manual export/import.
- Work offline and converge when connectivity returns.
- Avoid data loss and avoid leaking sensitive data.
- Keep changes minimal and incremental in code once implemented.

## Existing storage surfaces (from code)
- Local key/value: `PersistentMemoryService` wraps SharedPreferences in `lib/util/persistent_memory_service.dart`.
- User state: `UserInformation` in `lib/util/userInformation.dart`.
- Local files: `lib/file_service.dart` and `lib/util/PDF/create_pdf.dart`.
- Firebase already in use: Auth + Firestore access in `lib/util/Firebase/firebase_functions.dart`.

### Local keys currently stored (examples)
- Identity and profile: `name`, `gender`, `binary`, `age`, `userId`, `loggedIn`.
- Locale and location: `localeName`, `location`.
- Flags: `enteredBefore`, `hasFilled`, `disclaimerConfirmed`.
- Notifications: `notificationHour`, `notificationMinute`.
- Personal plan lists:
  - `userSelectionPersonalPlan-DifficultEvents`
  - `userSelectionPersonalPlan-MakeSafer`
  - `userSelectionPersonalPlan-FeelBetter`
  - `userSelectionPersonalPlan-Distractions`
- Other lists: `positiveTraits`, `thankYous`, `dates`.
- Phone page:
  - `PhonePageSavedPhoneNames`, `PhonePageSavedPhoneNumbers`
  - `*SavedPhoneNames`, `*SavedPhoneNumbers` in `lib/util/Form/formPagePhoneModel.dart`.

## Identity and account model
1) Firebase Auth (recommended for recovery)
   - Email/password, phone, Google/Apple as providers.
   - Stable `uid` is the primary key for all sync.
2) Anonymous first, upgrade later
   - Anonymous `uid` to store data on day 1.
   - On upgrade, migrate user doc to permanent account.
3) Device pairing (optional, layered on top)
   - QR code or one-time code to link a new device to an existing `uid`.
   - Can be used even without full login if privacy requirements allow it.

## Data model (Firestore + Storage)
Store structured data in Firestore and large files in Firebase Storage.

### Core user document
```
users/{uid}
  schemaVersion: 1
  createdAt: serverTimestamp
  updatedAt: serverTimestamp
  profile:
    name, gender, binary, age, localeName, location
  settings:
    notificationHour, notificationMinute
  flags:
    hasFilled, enteredBefore, disclaimerConfirmed
  deviceState:
    lastDeviceId, lastAppVersion, lastSyncAt
```

### Lists as subcollections (merge-friendly)
```
users/{uid}/lists/{listId}
  listType: "makeSafer" | "difficultEvents" | ...
  updatedAt: serverTimestamp

users/{uid}/lists/{listId}/items/{itemId}
  value: string
  createdAt: serverTimestamp
  updatedAt: serverTimestamp
  deletedAt: timestamp | null
  sourceDeviceId: string
```

### Phone page custom contacts
```
users/{uid}/phones/{phoneId}
  name: string
  number: string
  createdAt, updatedAt, deletedAt
```

### Files (PDFs, images)
```
users/{uid}/files/{fileId}
  storagePath: "users/{uid}/files/{fileId}"
  fileType: "pdf" | "image"
  createdAt, updatedAt, deletedAt
  metadata: sizeBytes, mimeType, originalName
```

## Sync engine and flow
### Local first, remote second
- Always write to local storage immediately.
- Enqueue a sync event for remote.
- If offline, keep the queue; retry with exponential backoff.

### Pull and merge
- On sign-in, pull remote data.
- Merge into local using conflict rules (below).
- Save merged state locally and update UI.

### Push
- Process queued changes with batched writes.
- Use Firestore transactions when needed for per-item merges.

### Suggested SyncEvent shape
```
SyncEvent {
  id: string,
  type: "set" | "add" | "remove",
  entity: "profile" | "listItem" | "phone" | "file",
  path: string,
  payload: map,
  localUpdatedAt: iso8601
}
```

## Conflict resolution
- Primitive fields: last-write-wins using `updatedAt`.
- Lists:
  - Each item has stable `itemId`.
  - Use `updatedAt` to resolve per-item conflicts.
  - Deletions use `deletedAt` tombstones.
- If there is no matching country or list definition, log and keep local state.
- Keep a `schemaVersion` for future migrations.

## Offline and connectivity
- Use Firestore offline persistence for structured data.
- Local queue is the source of truth for unsynced writes.
- On web, offline persistence is limited; keep local cache in memory + local storage.

## Security and privacy
- Firestore rules: users can only read/write their own data.
- Optional client-side encryption for sensitive fields.
  - Store encryption key in `flutter_secure_storage`.
  - If key is lost, recovery is not possible; decide policy early.
- Allow user to opt out of sync or select which data to sync.

## Observability
- Log sync failures to Sentry with `uid`, event id, and error code.
- Store `lastSyncAt` and show it in Settings.
- Add "Sync now" button for manual retries.

## Recovery and restore flows
- "Restore from account" option on first launch.
- Offer a one-time merge: choose remote, local, or merge.
- Optional export to encrypted JSON for offline backup.

## Incremental implementation plan (minimal changes)
1) Add a SyncService that mirrors existing `PersistentMemoryService` keys to Firestore.
2) Implement basic pull on login (profile + flags + settings).
3) Add list item sync with per-item IDs and tombstones.
4) Add file sync via Firebase Storage.
5) Add UI surface in Settings (status, manual sync, sign out).

## Testing plan
- Two emulators on same account; verify data propagates.
- Offline edits on device A, then online; ensure merge on device B.
- Conflict test: edit same list item on two devices; verify LWW rule.
- Delete propagation: delete on A, verify deletion on B.

## Open questions
- Which data is too sensitive to sync (or should be opt-in)?
- Should sync require login or allow anonymous + recovery code?
- What is the expected maximum size of lists and files?
- Do we need full audit history or only latest state?
