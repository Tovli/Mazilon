const List<String> emergencyCountryCodes = [
  'IL',
  'US',
  'GB',
  'AU',
  'AT',
  'BE',
  'BG',
  'HR',
  'CY',
  'CZ',
  'DK',
  'EE',
  'FI',
  'FR',
  'DE',
  'GR',
  'HU',
  'IE',
  'IT',
  'LV',
  'LT',
  'LU',
  'MT',
  'NL',
  'PL',
  'PT',
  'RO',
  'SK',
  'SI',
  'ES',
  'SE',
];

const String defaultEmergencyCountryCode = 'IL';

const Map<String, String> emergencyCountryGroupByCode = {
  'AT': 'eu',
  'BE': 'eu',
  'BG': 'eu',
  'HR': 'eu',
  'CY': 'eu',
  'CZ': 'eu',
  'DK': 'eu',
  'EE': 'eu',
  'FI': 'eu',
  'FR': 'eu',
  'DE': 'eu',
  'GR': 'eu',
  'HU': 'eu',
  'IE': 'eu',
  'IT': 'eu',
  'LV': 'eu',
  'LT': 'eu',
  'LU': 'eu',
  'MT': 'eu',
  'NL': 'eu',
  'PL': 'eu',
  'PT': 'eu',
  'RO': 'eu',
  'SK': 'eu',
  'SI': 'eu',
  'ES': 'eu',
  'SE': 'eu',
  'US': 'usa',
  'IL': 'israel',
  'GB': 'uk',
  'AU': 'australia',
};

String emergencyGroupForCountryCode(String? countryCode) {
  if (countryCode == null || countryCode.isEmpty) {
    return 'eu';
  }

  final normalized = countryCode.trim().toUpperCase();
  if (normalized.isEmpty) {
    return 'eu';
  }

  return emergencyCountryGroupByCode[normalized] ?? 'eu';
}
