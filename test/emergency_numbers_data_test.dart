import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/EmergencyNumbers.dart';

Map<String, dynamic>? findEntryByName(
    List<Map<String, dynamic>> entries, String name) {
  for (final entry in entries) {
    if (entry['name'] == name) {
      return entry;
    }
  }
  return null;
}

void main() {
  test('country defaults and picker codes are stable', () {
    expect(defaultPickerCountry.id, 'israel');
    expect(defaultEmergencyCountry.id, 'eu');
    expect(countryPickerCodes, contains('US'));
    expect(countryPickerCodes, contains('GB'));
  });

  test('findCountryByCode is case-insensitive', () {
    expect(findCountryByCode('us')?.id, 'usa');
    expect(findCountryByCode('Gb')?.id, 'uk');
    expect(findCountryByCode('au')?.id, 'australia');
    expect(findCountryByCode('il')?.id, 'israel');
  });

  test('USA emergency numbers match expected details', () {
    final usa = countries['usa'];
    expect(usa, isNotNull);
    final entries = usa!.emergencyNumbers;

    final emergency = findEntryByName(entries, 'Emergency');
    expect(emergency, isNotNull);
    expect(emergency!['number'], '911');

    final veterans = findEntryByName(entries, 'Veterans Crisis Line');
    expect(veterans, isNotNull);
    expect(veterans!['number'], '18002738255');
    expect(veterans['description'], contains('Press 1'));
    expect(veterans['description'], contains('838255'));

    final trevor =
        findEntryByName(entries, 'The Trevor Project (for LGBTQ+ youth)');
    expect(trevor, isNotNull);
    expect(trevor!['number'], '18664887386');
    expect(trevor['description'], contains('START to 678678'));

    final lifeline =
        findEntryByName(entries, 'National Suicide Prevention Lifeline');
    expect(lifeline, isNotNull);
    expect(lifeline!['number'], '988');
    expect(lifeline['link'], 'https://988lifeline.org/chat');

    final crisisText = findEntryByName(entries, 'Crisis Text Line');
    expect(crisisText, isNotNull);
    expect(crisisText!['number'], '741741');
    expect(crisisText['description'], contains('HOME to 741741'));
    expect(crisisText['canCall'], false);
  });

  test('UK emergency numbers match expected details', () {
    final uk = countries['uk'];
    expect(uk, isNotNull);
    final entries = uk!.emergencyNumbers;

    final emergency = findEntryByName(entries, 'Emergency');
    expect(emergency, isNotNull);
    expect(emergency!['number'], '999');

    final shout = findEntryByName(entries, 'Shout');
    expect(shout, isNotNull);
    expect(shout!['number'], '85258');
    expect(shout['description'], contains('SHOUT'));

    final papyrus =
        findEntryByName(entries, 'Papyrus (for people under 35)');
    expect(papyrus, isNotNull);
    expect(papyrus!['number'], '08000684141');
    expect(papyrus['description'], contains('07860 039967'));
  });

  test('EU emergency numbers match expected details', () {
    final eu = countries['eu'];
    expect(eu, isNotNull);
    final entries = eu!.emergencyNumbers;

    final emergency =
        findEntryByName(entries, 'European Emergency Number');
    expect(emergency, isNotNull);
    expect(emergency!['number'], '112');

    final mhe = findEntryByName(entries, 'Mental Health Europe');
    expect(mhe, isNotNull);
    expect(mhe!['link'], 'https://mhe-sme.org/');
    expect(mhe['description'], contains('Provides links'));
  });

  test('Australia emergency numbers match expected details', () {
    final australia = countries['australia'];
    expect(australia, isNotNull);
    final entries = australia!.emergencyNumbers;

    final emergency = findEntryByName(entries, 'Emergency');
    expect(emergency, isNotNull);
    expect(emergency!['number'], '000');

    final lifeline = findEntryByName(entries, 'Lifeline Australia');
    expect(lifeline, isNotNull);
    expect(lifeline!['number'], '131114');
    expect(lifeline['description'], contains('0477 13 11 14'));

    final beyondBlue = findEntryByName(entries, 'Beyond Blue');
    expect(beyondBlue, isNotNull);
    expect(beyondBlue!['number'], '1300224636');
    expect(beyondBlue['link'], contains('get-immediate-support'));

    final kids =
        findEntryByName(entries, 'Kids Helpline (for people aged 5-25)');
    expect(kids, isNotNull);
    expect(kids!['number'], '1800551800');

    final mensLine = findEntryByName(entries, 'MensLine Australia');
    expect(mensLine, isNotNull);
    expect(mensLine!['number'], '1300789978');
  });
}
