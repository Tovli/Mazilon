import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/main.dart';

void main() {
  test('skips notification refresh when reminders are unsupported', () async {
    var initCalls = 0;
    var updateCalls = 0;

    await refreshReminderForLocaleChange(
      remindersSupported: false,
      initializeNotifications: () async {
        initCalls++;
      },
      updateNotifications: () async {
        updateCalls++;
      },
    );

    expect(initCalls, 0);
    expect(updateCalls, 0);
  });

  test('refreshes notification state when reminders are supported', () async {
    var initCalls = 0;
    var updateCalls = 0;

    await refreshReminderForLocaleChange(
      remindersSupported: true,
      initializeNotifications: () async {
        initCalls++;
      },
      updateNotifications: () async {
        updateCalls++;
      },
    );

    expect(initCalls, 1);
    expect(updateCalls, 1);
  });
}
