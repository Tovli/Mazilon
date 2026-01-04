import 'package:flutter/material.dart';

class Country {
  final String id;
  final List<String> countryCodes;
  final List<Map<String, dynamic>> emergencyNumbers;
  final bool isDefaultPicker;
  final bool isDefaultEmergency;

  const Country({
    required this.id,
    required this.countryCodes,
    required this.emergencyNumbers,
    this.isDefaultPicker = false,
    this.isDefaultEmergency = false,
  });
}

const List<String> euCountryCodes = [
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

final Map<String, Country> countries = {
  "israel": Country(
    id: "israel",
    countryCodes: ["IL"],
    isDefaultPicker: true,
    emergencyNumbers: [
    {
      "name": "105",
      "number": "105",
      "whatsappNumber": "0521210105",
      "link": "",
      "description": "המטה הלאומי להגנת ילדים ברשת",
      "icon": Icons.phone,
      "whatsapp": true,
      "canCall": true,
    },
    {
      "name": "ער\"ן",
      "number": "1201",
      "link": "",
      "description": "טלפון-1201/מחו\"ל-*2201 | שלוחה 5",
      "icon": Icons.phone,
      "whatsapp": false,
      "canCall": true,
    },
    {
      "name": "סה\"ר",
      "number": "0559571399",
      "link": "",
      "description": "סיוע והקשבה ברשת",
      "icon": Icons.phone,
      "whatsapp": true,
      "canCall": false,
    },
    {
      "name": "משטרה",
      "number": "100",
      "link": "",
      "description": "",
      "icon": Icons.phone,
      "whatsapp": false,
      "canCall": true,
    }
    ],
  ),
  "usa": Country(
    id: "usa",
    countryCodes: ["US"],
    emergencyNumbers: [
    {
      "name": "Police",
      "number": "911",
      "link": "",
      "description": "",
      "whatsapp": false,
      "icon": Icons.phone,
      "canCall": true,
    },
    {
      "name": "Vetern Crisis Line",
      "number": "18002738255",
      "link": "",
      "description": "",
      "whatsapp": false,
      "canCall": true,
      "icon": Icons.phone
    },
    {
      "name": "The Trevor Project",
      "number": "18664887386",
      "link": "",
      "description": "Center for LTBTQ+ youth",
      "descriptionHe": "מרכז לנוער להטב\"ק+",
      "whatsapp": false,
      "canCall": true,
      "icon": Icons.phone
    },
    {
      "name": "National Suicide Prevention Lifeline",
      "number": "988",
      "link": "988lifeline.org/chat",
      "description": "",
      "whatsapp": false,
      "canCall": true,
      "icon": Icons.chat
    }
    ],
  ),
  "uk": Country(
    id: "uk",
    countryCodes: ["GB"],
    emergencyNumbers: [
    {
      "name": "Samaritans",
      "number": "116123",
      "link": "http://samaritans.org/how-we-can-help/contact-samaritan/",
      "email": "jo@samaritans.org",
      "description":
          "Samaritans is the charity that prevents suicide.",
      "descriptionHe": "סמריטנס היא עמותה למניעת התאבדות.",
      "whatsapp": false,
      "canCall": true,
      "icon": Icons.chat
    },
    {
      "name": "CALM",
      "number": "0800585858",
      "link": "https://www.thecalmzone.net/",
      "description": "A leading movement against male suicide.",
      "descriptionHe": "תנועה מובילה למאבק בהתאבדות בקרב גברים.",
      "whatsapp": false,
      "canCall": true,
      "icon": Icons.chat
    },
    {
      "name": "Papyrus",
      "number": "08000684141",
      "link": "https://www.papyrus-uk.org/",
      "description": "Papyrus is dedicated to the prevention of young suicide.",
      "descriptionHe": "פאפירוס מוקדשת למניעת התאבדות בקרב צעירים.",
      "whatsapp": false,
      "canCall": true,
      "icon": Icons.chat
    }
    ],
  ),
  "eu": Country(
    id: "eu",
    countryCodes: euCountryCodes,
    isDefaultEmergency: true,
    emergencyNumbers: [
    {
      "name": "Emergency",
      "number": "112",
      "description":
          "Need help? 112 is your life-saving number!",
      "descriptionHe": "צריך עזרה? 112 הוא מספר החירום שלך להצלת חיים!",
      "whatsapp": false,
      "canCall": true,
      "icon": Icons.phone
    },
    {
      "name": "Mental Health",
      "link": "https://mhe-sme.org/",
      "description":
          "The leading NGO for mental health and well-being.",
      "descriptionHe": "הארגון המוביל לבריאות הנפש ולרווחה.",
      "whatsapp": false,
      "number": "",
      "canCall": false,
      "icon": Icons.link
    }
    ],
  ),
  "australia": Country(
    id: "australia",
    countryCodes: ["AU"],
    emergencyNumbers: [
    {
      "name": "Lifeline",
      "number": "131114",
      "link": "https://www.lifeline.org.au/",
      "description": "24 hour crisis support and suicide prevention.",
      "descriptionHe": "תמיכה במשברים ומניעת התאבדות 24/7.",
      "canCall": false,
      "icon": Icons.chat
    },
    {
      "name": "Beyond Blue",
      "number": "1300224636",
      "link": "https://www.beyondblue.org.au/get-support/urgent-help",
      "description":
          "A reliable source of mental health information.",
      "descriptionHe": "מקור מידע אמין לבריאות הנפש.",
      "canCall": false,
      "icon": Icons.chat
    },
    {
      "name": "Kids Helpline",
      "number": "1800551800",
      "link": "https://kidshelpline.com.au/",
      "description":
          "24 hour counseling for young people aged 5 to 25.",
      "descriptionHe": "ייעוץ 24/7 לצעירים בגילאי 5 עד 25.",
      "canCall": true,
      "icon": Icons.chat
    },
    {
      "name": "Men's Line",
      "number": "1300789978",
      "link": "https://mensline.org.au/",
      "description":
          "A telephone and online counseling service for men.",
      "descriptionHe": "שירות ייעוץ טלפוני ומקוון לגברים.",
      "canCall": true,
      "icon": Icons.chat
    }
    ],
  )
};

List<String> get countryPickerCodes => countries.values
    .expand((country) => country.countryCodes)
    .toList();

Country get defaultPickerCountry => countries.values.firstWhere(
    (country) => country.isDefaultPicker,
    orElse: () => countries.values.first);

Country get defaultEmergencyCountry => countries.values.firstWhere(
    (country) => country.isDefaultEmergency,
    orElse: () => countries.values.first);

Country? findCountryByCode(String code) {
  final normalized = code.trim().toUpperCase();
  if (normalized.isEmpty) {
    return null;
  }
  for (final country in countries.values) {
    if (country.countryCodes.contains(normalized)) {
      return country;
    }
  }
  return null;
}
//{"name":, "number":, "link":,"description":,"icon":}
