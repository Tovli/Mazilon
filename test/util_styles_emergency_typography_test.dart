import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/util/styles.dart';

void main() {
  test('Emergency phone typography presets keep expected desktop values', () {
    expect(emergencyDesktopPhoneTypography.titleMaxFont, 28.0);
    expect(emergencyDesktopPhoneTypography.descriptionMaxFont, 22.0);
    expect(emergencyDesktopPhoneTypography.descriptionMaxLines, 6);
    expect(emergencyDesktopPhoneTypography.nameFontSize, 22.0);
    expect(emergencyDesktopPhoneTypography.descriptionFontSize, 18.0);
    expect(emergencyDesktopPhoneTypography.phoneFontSize, 18.0);
    expect(emergencyDesktopPhoneTypography.phoneMaxFont, 24.0);
  });

  test('Emergency phone typography presets keep expected mobile values', () {
    expect(emergencyMobilePhoneTypography.titleMaxFont, 20.0);
    expect(emergencyMobilePhoneTypography.descriptionMaxFont, 16.0);
    expect(emergencyMobilePhoneTypography.descriptionMaxLines, 8);
    expect(emergencyMobilePhoneTypography.nameFontSize, 15.0);
    expect(emergencyMobilePhoneTypography.descriptionFontSize, 13.0);
    expect(emergencyMobilePhoneTypography.phoneFontSize, 14.0);
    expect(emergencyMobilePhoneTypography.phoneMaxFont, 20.0);
  });
}
