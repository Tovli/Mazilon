// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get language => 'العربية';

  @override
  String get textDirection => 'rtl';

  @override
  String pageHomeWelcomeGender(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'مرحباً يا رجل!',
        'female': 'مرحباً يا امرأة!',
        'other': 'أهلاً!',
      },
    );
    return '$_temp0';
  }

  @override
  String greetings(Object username) {
    return 'مرحبًا، $username';
  }

  @override
  String otherSuggestions(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اقتراحات أخرى',
        'female': 'اقتراحات أخرى',
        'other': 'اقتراحات أخرى',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionRestartGreeting(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'مرحبا بكم في العيش بشكل إيجابي',
        'female': 'مرحبا بكم في العيش بشكل إيجابي',
        'other': 'مرحبا بكم في العيش بشكل إيجابي',
      },
    );
    return '$_temp0';
  }

  @override
  String addFormPageTemplateAdd(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إضافة',
        'female': 'إضافة',
        'other': 'إضافة',
      },
    );
    return '$_temp0';
  }

  @override
  String addThanksFormThank(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرًا',
        'female': 'شكرًا',
        'other': 'شكرًا',
      },
    );
    return '$_temp0';
  }

  @override
  String addFormEdit(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تعديل',
        'female': 'تعديل',
        'other': 'تعديل',
      },
    );
    return '$_temp0';
  }

  @override
  String signupLoginLoginTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تسجيل الدخول للعيش بشكل إيجابي',
        'female': 'تسجيل الدخول للعيش بشكل إيجابي',
        'other': 'تسجيل الدخول للعيش بشكل إيجابي',
      },
    );
    return '$_temp0';
  }

  @override
  String signupLoginLoginButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تسجيل الدخول',
        'female': 'تسجيل الدخول',
        'other': 'تسجيل الدخول',
      },
    );
    return '$_temp0';
  }

  @override
  String signupLoginLoginGoogleButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تسجيل الدخول باستخدام جوجل',
        'female': 'تسجيل الدخول باستخدام جوجل',
        'other': 'تسجيل الدخول باستخدام جوجل',
      },
    );
    return '$_temp0';
  }

  @override
  String signupLoginLoginNoAccount(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'ليس لديك حساب حتى الآن؟',
        'female': 'ليس لديك حساب حتى الآن؟',
        'other': 'ليس لديك حساب حتى الآن؟',
      },
    );
    return '$_temp0';
  }

  @override
  String signupLoginLoginToSignup(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اشتراك',
        'female': 'اشتراك',
        'other': 'اشتراك',
      },
    );
    return '$_temp0';
  }

  @override
  String signupLoginLoginSkip(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تخطي الاشتراك',
        'female': 'تخطي الاشتراك',
        'other': 'تخطي الاشتراك',
      },
    );
    return '$_temp0';
  }

  @override
  String signupLoginSignUpTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الاشتراك في العيش بشكل إيجابي',
        'female': 'الاشتراك في العيش بشكل إيجابي',
        'other': 'الاشتراك في العيش بشكل إيجابي',
      },
    );
    return '$_temp0';
  }

  @override
  String signupLoginSignUpButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اشتراك',
        'female': 'اشتراك',
        'other': 'اشتراك',
      },
    );
    return '$_temp0';
  }

  @override
  String signupLoginSignUpExists(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'هل لديك حساب بالفعل؟',
        'female': 'هل لديك حساب بالفعل؟',
        'other': 'هل لديك حساب بالفعل؟',
      },
    );
    return '$_temp0';
  }

  @override
  String signupLoginSignUpToLogin(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تسجيل الدخول',
        'female': 'تسجيل الدخول',
        'other': 'تسجيل الدخول',
      },
    );
    return '$_temp0';
  }

  @override
  String personalPlanPageMyPlan(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'خطتي',
        'female': 'خطتي',
        'other': 'خطتي',
      },
    );
    return '$_temp0';
  }

  @override
  String personalPlanPageAllPlan(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لرؤية خطتي',
        'female': 'لرؤية خطتي',
        'other': 'لرؤية خطتي',
      },
    );
    return '$_temp0';
  }

  @override
  String personalPlanPageTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'خطتي الشخصية',
        'female': 'خطتي الشخصية',
        'other': 'خطتي الشخصية',
      },
    );
    return '$_temp0';
  }

  @override
  String personalPlanPageStartedDownload(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'بدأ التنزيل',
        'female': 'بدأ التنزيل',
        'other': 'بدأ التنزيل',
      },
    );
    return '$_temp0';
  }

  @override
  String personalPlanPageFinishDownload(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تم حفظ خطتك في \"التنزيلات\"',
        'female': 'تم حفظ خطتك في \"التنزيلات\"',
        'other': 'تم حفظ خطتك في \"التنزيلات\"',
      },
    );
    return '$_temp0';
  }

  @override
  String personalPlanPageFinish(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إنهاء',
        'female': 'إنهاء',
        'other': 'إنهاء',
      },
    );
    return '$_temp0';
  }

  @override
  String personalPlanPageHasFilled(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لتحديث الخطة',
        'female': 'لتحديث الخطة',
        'other': 'لتحديث الخطة',
      },
    );
    return '$_temp0';
  }

  @override
  String personalPlanPageDidNotFill(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لملء الخطة',
        'female': 'لملء الخطة',
        'other': 'لملء الخطة',
      },
    );
    return '$_temp0';
  }

  @override
  String homePagePersonalPlanMainTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'خطتي',
        'female': 'خطتي',
        'other': 'خطتي',
      },
    );
    return '$_temp0';
  }

  @override
  String homePagePersonalPlanSecondaryTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الأشياء التي سوف تجعلني أشعر بالتحسن الآن',
        'female': 'الأشياء التي سوف تجعلني أشعر بالتحسن الآن',
        'other': 'الأشياء التي سوف تجعلني أشعر بالتحسن الآن',
      },
    );
    return '$_temp0';
  }

  @override
  String homePageTraitsMainTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'قائمة الصفات',
        'female': 'قائمة الصفات',
        'other': 'قائمة الصفات',
      },
    );
    return '$_temp0';
  }

  @override
  String homePageTraitsSecondaryTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'ما أجيده، أنصح بقراءته مرة واحدة في اليوم',
        'female': 'ما أجيده، أنصح بقراءته مرة واحدة في اليوم',
        'other': 'ما أجيده، أنصح بقراءته مرة واحدة في اليوم',
      },
    );
    return '$_temp0';
  }

  @override
  String homePageThanksMainTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'مجلة الامتنان',
        'female': 'مجلة الامتنان',
        'other': 'مجلة الامتنان',
      },
    );
    return '$_temp0';
  }

  @override
  String homePageThanksSecondaryTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'ما أنا ممتن ل',
        'female': 'ما أنا ممتن ل',
        'other': 'ما أنا ممتن ل',
      },
    );
    return '$_temp0';
  }

  @override
  String homePageThankyouPopup(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'هذه هي الطريقة لتقوية عضلة السعادة الإيجابية لديك.\nالتوصية هي أن تكون شاكراً لخمسة أشياء على الأقل كل يوم.\nاستمروا في العمل الجيد، وسنلتقي مرة أخرى غدًا.',
        'female':
            'هذه هي الطريقة لتقوية عضلة السعادة الإيجابية لديك.\nالتوصية هي أن تكون شاكراً لخمسة أشياء على الأقل كل يوم.\nاستمروا في العمل الجيد، وسنلتقي مرة أخرى غدًا.',
        'other':
            'هذه هي الطريقة لتقوية عضلة السعادة الإيجابية لديك.\nالتوصية هي أن تكون شاكراً لخمسة أشياء على الأقل كل يوم.\nاستمروا في العمل الجيد، وسنلتقي مرة أخرى غدًا.',
      },
    );
    return '$_temp0';
  }

  @override
  String homePagePositiveTraitPopup(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'تحقق من قائمة الفضائل الخاصة بك كل يوم.\nلا تتردد في إضافة المزيد، لا تخجل - أضف المزيد بقلب كامل.',
        'female':
            'تحقق من قائمة الفضائل الخاصة بك كل يوم.\nلا تتردد في إضافة المزيد، لا تخجل - أضف المزيد بقلب كامل.',
        'other':
            'تحقق من قائمة الفضائل الخاصة بك كل يوم.\nلا تتردد في إضافة المزيد، لا تخجل - أضف المزيد بقلب كامل.',
      },
    );
    return '$_temp0';
  }

  @override
  String homePageGreetings(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'من الجيد عودتك :)',
        'female': 'من الجيد عودتك :)',
        'other': 'من الجيد عودتك :)',
      },
    );
    return '$_temp0';
  }

  @override
  String homePageAbout(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'عن',
        'female': 'عن',
        'other': 'عن',
      },
    );
    return '$_temp0';
  }

  @override
  String homePageWellnessTools(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أدوات العافية',
        'female': 'أدوات العافية',
        'other': 'أدوات العافية',
      },
    );
    return '$_temp0';
  }

  @override
  String homePageFeelGood(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أشعر أنني بحالة جيدة',
        'female': 'أشعر أنني بحالة جيدة',
        'other': 'أشعر أنني بحالة جيدة',
      },
    );
    return '$_temp0';
  }

  @override
  String homePageSync(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'مزامنة الحسابات',
        'female': 'مزامنة الحسابات',
        'other': 'مزامنة الحسابات',
      },
    );
    return '$_temp0';
  }

  @override
  String homePageBack(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إغلاق',
        'female': 'إغلاق',
        'other': 'إغلاق',
      },
    );
    return '$_temp0';
  }

  @override
  String sharePageHeader(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'عظيم!',
        'female': 'عظيم!',
        'other': 'عظيم!',
      },
    );
    return '$_temp0';
  }

  @override
  String sharePageSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'لقد قمت بإنشاء دليل يساعدك خلال لحظات الأزمات!\nدعونا نستكشف المزيد من الأدوات للمساعدة الذاتية والمرونة العقلية',
        'female':
            'لقد قمت بإنشاء دليل يساعدك خلال لحظات الأزمات!\nدعونا نستكشف المزيد من الأدوات للمساعدة الذاتية والمرونة العقلية',
        'other':
            'لقد قمت بإنشاء دليل يساعدك خلال لحظات الأزمات!\nدعونا نستكشف المزيد من الأدوات للمساعدة الذاتية والمرونة العقلية',
      },
    );
    return '$_temp0';
  }

  @override
  String sharePageMidTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'يمكنك الآن مشاركة خطتك مع الأشخاص المقربين منك، أو تنزيلها على هاتفك',
        'female':
            'يمكنك الآن مشاركة خطتك مع الأشخاص المقربين منك، أو تنزيلها على هاتفك',
        'other':
            'يمكنك الآن مشاركة خطتك مع الأشخاص المقربين منك، أو تنزيلها على هاتفك',
      },
    );
    return '$_temp0';
  }

  @override
  String sharePageFinishButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا انتهيت!',
        'female': 'أنا انتهيت!',
        'other': 'أنا انتهيت!',
      },
    );
    return '$_temp0';
  }

  @override
  String sharePageShareTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'كيف تريد مشاركة خطتك؟',
        'female': 'كيف تريد مشاركة خطتك؟',
        'other': 'كيف تريد مشاركة خطتك؟',
      },
    );
    return '$_temp0';
  }

  @override
  String sharePageEmergencySendButtonText(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'طارئ',
        'female': 'طارئ',
        'other': 'طارئ',
      },
    );
    return '$_temp0';
  }

  @override
  String sharePageRoutineSendButtonText(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'روتين',
        'female': 'روتين',
        'other': 'روتين',
      },
    );
    return '$_temp0';
  }

  @override
  String userSettingsTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تحديث الإعدادات',
        'female': 'تحديث الإعدادات',
        'other': 'تحديث الإعدادات',
      },
    );
    return '$_temp0';
  }

  @override
  String userSettingsHeader(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إعدادات المستخدم',
        'female': 'إعدادات المستخدم',
        'other': 'إعدادات المستخدم',
      },
    );
    return '$_temp0';
  }

  @override
  String userSettingsReset(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إعادة ضبط البيانات',
        'female': 'إعادة ضبط البيانات',
        'other': 'إعادة ضبط البيانات',
      },
    );
    return '$_temp0';
  }

  @override
  String userSettingsName(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'ماذا يجب أن نسميك؟ (لا تتردد في استخدام اللقب)',
        'female': 'ماذا يجب أن نسميك؟ (لا تتردد في استخدام اللقب)',
        'other': 'ماذا يجب أن نسميك؟ (لا تتردد في استخدام اللقب)',
      },
    );
    return '$_temp0';
  }

  @override
  String userSettingsGender(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'كيف تفضل أن نخاطبك؟',
        'female': 'كيف تفضلين أن نخاطبك؟',
        'other': 'كيف تفضل أن نخاطبك؟',
      },
    );
    return '$_temp0';
  }

  @override
  String userSettingsAge(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'ما هو عمرك؟',
        'female': 'ما هو عمرك؟',
        'other': 'ما هو عمرك؟',
      },
    );
    return '$_temp0';
  }

  @override
  String settings(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إعدادات',
        'female': 'إعدادات',
        'other': 'إعدادات',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionFormFirstPageMainTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'ما الذي يبقيني آمنًا؟',
        'female': 'ما الذي يبقيني آمنًا؟',
        'other': 'ما الذي يبقيني آمنًا؟',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionFormFirstPageSubTitle1(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'العيش بإيجابية - من أجل السعادة وزيادة المرونة وتحسين نوعية الحياة',
        'female':
            'العيش بإيجابية - من أجل السعادة وزيادة المرونة وتحسين نوعية الحياة',
        'other':
            'العيش بإيجابية - من أجل السعادة وزيادة المرونة وتحسين نوعية الحياة',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionFormFirstPageSubTitle2(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أدوات ممتازة للمساعدة الذاتية وتطوير المرونة العقلية.',
        'female': 'أدوات ممتازة للمساعدة الذاتية وتطوير المرونة العقلية.',
        'other': 'أدوات ممتازة للمساعدة الذاتية وتطوير المرونة العقلية.',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionFormFirstPageSkip(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تخطي',
        'female': 'تخطي',
        'other': 'تخطي',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionFormLastPageSkip(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تخطي الاستبيان',
        'female': 'تخطي الاستبيان',
        'other': 'تخطي الاستبيان',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionFormLastPageMainTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'خطتي الشخصية',
        'female': 'خطتي الشخصية',
        'other': 'خطتي الشخصية',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionFormLastPageSubTitle1(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'أنت مدعو لإنشاء خطة شخصية تقدم الدعم خلال اللحظات الصعبة، لك ولمن حولك.',
        'female':
            'أنت مدعو لإنشاء خطة شخصية تقدم الدعم خلال اللحظات الصعبة، لك ولمن حولك.',
        'other':
            'أنت مدعو لإنشاء خطة شخصية تقدم الدعم خلال اللحظات الصعبة، لك ولمن حولك.',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionFormLastPageSubTitle2(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'يوصى بقضاء بضع دقائق الآن للتعامل بشكل أفضل مع الأزمات المستقبلية.',
        'female':
            'يوصى بقضاء بضع دقائق الآن للتعامل بشكل أفضل مع الأزمات المستقبلية.',
        'other':
            'يوصى بقضاء بضع دقائق الآن للتعامل بشكل أفضل مع الأزمات المستقبلية.',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionFormSecondPageMainTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'دعونا نتعرف عليك!',
        'female': 'دعونا نتعرف عليك!',
        'other': 'دعونا نتعرف عليك!',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionFormSecondPageSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'أهلاً! جيد جدًا أنك هنا!\nنريد أن نتعرف عليك بشكل أفضل حتى نتمكن من دعمك.',
        'female':
            'أهلاً! جيد جدًا أنك هنا!\nنريد أن نتعرف عليك بشكل أفضل حتى نتمكن من دعمك.',
        'other':
            'أهلاً! جيد جدًا أنك هنا!\nنريد أن نتعرف عليك بشكل أفضل حتى نتمكن من دعمك.',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsHeader(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تذكير بالمحفزات الشائعة وعوامل التصعيد',
        'female': 'تذكير بالمحفزات الشائعة وعوامل التصعيد',
        'other': 'تذكير بالمحفزات الشائعة وعوامل التصعيد',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'العوامل والأحداث التي شكلت تحديًا بالنسبة لي في الماضي',
        'female': 'العوامل والأحداث التي شكلت تحديًا بالنسبة لي في الماضي',
        'other': 'العوامل والأحداث التي شكلت تحديًا بالنسبة لي في الماضي',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsMidTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لا فكرة؟ وهنا بعض الاقتراحات',
        'female': 'لا فكرة؟ وهنا بعض الاقتراحات',
        'other': 'لا فكرة؟ وهنا بعض الاقتراحات',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsMidSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'انقر لإضافة الخيارات التي تناسب خطتك الشخصية',
        'female': 'انقر لإضافة الخيارات التي تناسب خطتك الشخصية',
        'other': 'انقر لإضافة الخيارات التي تناسب خطتك الشخصية',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsHeader(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الأعراض والعلامات التحذيرية، سلوكيات غير عادية بالنسبة لي',
        'female': 'الأعراض والعلامات التحذيرية، سلوكيات غير عادية بالنسبة لي',
        'other': 'الأعراض والعلامات التحذيرية، سلوكيات غير عادية بالنسبة لي',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تذكير بأشياء ظهرت لي شخصيا في الماضي',
        'female': 'تذكير بأشياء ظهرت لي شخصيا في الماضي',
        'other': 'تذكير بأشياء ظهرت لي شخصيا في الماضي',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsMidTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لا فكرة؟ وهنا بعض الاقتراحات',
        'female': 'لا فكرة؟ وهنا بعض الاقتراحات',
        'other': 'لا فكرة؟ وهنا بعض الاقتراحات',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsMidSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'انقر لإضافة خيارات تناسب خطتك الشخصية',
        'female': 'انقر لإضافة خيارات تناسب خطتك الشخصية',
        'other': 'انقر لإضافة خيارات تناسب خطتك الشخصية',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterHeader(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'لتحقيق التوازن ونمط حياة صحي - أدوات العافية - الأدوية الشخصية',
        'female':
            'لتحقيق التوازن ونمط حياة صحي - أدوات العافية - الأدوية الشخصية',
        'other':
            'لتحقيق التوازن ونمط حياة صحي - أدوات العافية - الأدوية الشخصية',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'ما الذي يساعدني على تحسين حالتي المزاجية والاسترخاء والشعور بقدر أقل من التوتر؟\nطرق الصيانة الوقائية، وحتى زيادة الجرعات - في حالات الطوارئ.',
        'female':
            'ما الذي يساعدني على تحسين حالتي المزاجية والاسترخاء والشعور بقدر أقل من التوتر؟\nطرق الصيانة الوقائية، وحتى زيادة الجرعات - في حالات الطوارئ.',
        'other':
            'ما الذي يساعدني على تحسين حالتي المزاجية والاسترخاء والشعور بقدر أقل من التوتر؟\nطرق الصيانة الوقائية، وحتى زيادة الجرعات - في حالات الطوارئ.',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterMidTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لا فكرة؟ وهنا بعض الاقتراحات',
        'female': 'لا فكرة؟ وهنا بعض الاقتراحات',
        'other': 'لا فكرة؟ وهنا بعض الاقتراحات',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterMidSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'انقر لإضافة خيارات تناسب خطتك الشخصية',
        'female': 'انقر لإضافة خيارات تناسب خطتك الشخصية',
        'other': 'انقر لإضافة خيارات تناسب خطتك الشخصية',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferHeader(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'الدعم من بيئتي عندما ألاحظ علامات الإنذار المبكر، وكيف أرغب في الحصول على المساعدة',
        'female':
            'الدعم من بيئتي عندما ألاحظ علامات الإنذار المبكر، وكيف أرغب في الحصول على المساعدة',
        'other':
            'الدعم من بيئتي عندما ألاحظ علامات الإنذار المبكر، وكيف أرغب في الحصول على المساعدة',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الطرق التي يمكن أن يساعدني بها محيطي في التأقلم',
        'female': 'الطرق التي يمكن أن يساعدني بها محيطي في التأقلم',
        'other': 'الطرق التي يمكن أن يساعدني بها محيطي في التأقلم',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferMidTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لا فكرة؟ وهنا بعض الاقتراحات',
        'female': 'لا فكرة؟ وهنا بعض الاقتراحات',
        'other': 'لا فكرة؟ وهنا بعض الاقتراحات',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferMidSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'انقر لإضافة خيارات تناسب خطتك الشخصية',
        'female': 'انقر لإضافة خيارات تناسب خطتك الشخصية',
        'other': 'انقر لإضافة خيارات تناسب خطتك الشخصية',
      },
    );
    return '$_temp0';
  }

  @override
  String phonesPagePhone(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'هاتف',
        'female': 'هاتف',
        'other': 'هاتف',
      },
    );
    return '$_temp0';
  }

  @override
  String phonesPageName(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اسم',
        'female': 'اسم',
        'other': 'اسم',
      },
    );
    return '$_temp0';
  }

  @override
  String phonesPageHeader(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'من هم الأشخاص الذين يدعمونني والذين يمكنني اللجوء إليهم إذا شعرت بالضيق أو فكرت في إيذاء نفسي؟',
        'female':
            'من هم الأشخاص الذين يدعمونني والذين يمكنني اللجوء إليهم إذا شعرت بالضيق أو فكرت في إيذاء نفسي؟',
        'other':
            'من هم الأشخاص الذين يدعمونني والذين يمكنني اللجوء إليهم إذا شعرت بالضيق أو فكرت في إيذاء نفسي؟',
      },
    );
    return '$_temp0';
  }

  @override
  String phonesPageSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الأشخاص الذين يحبونني وسيساعدونني في تجاوز اللحظات الصعبة هم:',
        'female':
            'الأشخاص الذين يحبونني وسيساعدونني في تجاوز اللحظات الصعبة هم:',
        'other':
            'الأشخاص الذين يحبونني وسيساعدونني في تجاوز اللحظات الصعبة هم:',
      },
    );
    return '$_temp0';
  }

  @override
  String phonesPageManualTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أضف يدويًا',
        'female': 'أضف يدويًا',
        'other': 'أضف يدويًا',
      },
    );
    return '$_temp0';
  }

  @override
  String phonesPageContactImportTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إضافة من قائمة جهات الاتصال',
        'female': 'إضافة من قائمة جهات الاتصال',
        'other': 'إضافة من قائمة جهات الاتصال',
      },
    );
    return '$_temp0';
  }

  @override
  String saveButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'حفظ',
        'female': 'حفظ',
        'other': 'حفظ',
      },
    );
    return '$_temp0';
  }

  @override
  String closeButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إلغاء',
        'female': 'إلغاء',
        'other': 'إلغاء',
      },
    );
    return '$_temp0';
  }

  @override
  String nextButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'متابعة',
        'female': 'متابعة',
        'other': 'متابعة',
      },
    );
    return '$_temp0';
  }

  @override
  String showMoreButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'عرض المزيد',
        'female': 'عرض المزيد',
        'other': 'عرض المزيد',
      },
    );
    return '$_temp0';
  }

  @override
  String introductionFormLastPageNext(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إلى الاستبيان',
        'female': 'إلى الاستبيان',
        'other': 'إلى الاستبيان',
      },
    );
    return '$_temp0';
  }

  @override
  String saveAndQuitButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إلى القائمة',
        'female': 'إلى القائمة',
        'other': 'إلى القائمة',
      },
    );
    return '$_temp0';
  }

  @override
  String confirmButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تأكيد',
        'female': 'تأكيد',
        'other': 'تأكيد',
      },
    );
    return '$_temp0';
  }

  @override
  String deleteButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'حذف',
        'female': 'حذف',
        'other': 'حذف',
      },
    );
    return '$_temp0';
  }

  @override
  String menu(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'القائمة',
        'female': 'القائمة',
        'other': 'القائمة',
      },
    );
    return '$_temp0';
  }

  @override
  String notifications(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تذكيرات',
        'female': 'تذكيرات',
        'other': 'تذكيرات',
      },
    );
    return '$_temp0';
  }

  @override
  String home(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الرئيسية',
        'female': 'الرئيسية',
        'other': 'الرئيسية',
      },
    );
    return '$_temp0';
  }

  @override
  String skipButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تخطي',
        'female': 'تخطي',
        'other': 'تخطي',
      },
    );
    return '$_temp0';
  }

  @override
  String select(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اختيار',
        'female': 'اختيار',
        'other': 'اختيار',
      },
    );
    return '$_temp0';
  }

  @override
  String backButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'عُد',
        'female': 'عُد',
        'other': 'عُد',
      },
    );
    return '$_temp0';
  }

  @override
  String dialButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اتصال',
        'female': 'اتصال',
        'other': 'اتصال',
      },
    );
    return '$_temp0';
  }

  @override
  String yourContacts(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'جهات الاتصال الخاصة بك',
        'female': 'جهات الاتصال الخاصة بك',
        'other': 'جهات الاتصال الخاصة بك',
      },
    );
    return '$_temp0';
  }

  @override
  String emergencyNumbers(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أرقام الطوارئ',
        'female': 'أرقام الطوارئ',
        'other': 'أرقام الطوارئ',
      },
    );
    return '$_temp0';
  }

  @override
  String phonePageTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'أنت لست وحدك! إذا كنت في محنة الآن، يرجى التواصل مع إحدى جهات الاتصال المذكورة هنا',
        'female':
            'أنت لست وحدك! إذا كنت في محنة الآن، يرجى التواصل مع إحدى جهات الاتصال المذكورة هنا',
        'other':
            'أنت لست وحدك! إذا كنت في محنة الآن، يرجى التواصل مع إحدى جهات الاتصال المذكورة هنا',
      },
    );
    return '$_temp0';
  }

  @override
  String get whatsApp => 'واتساب';

  @override
  String get thanks => 'شكرًا';

  @override
  String get trait => 'سمة';

  @override
  String get link => 'رابط إلى الموقع';

  @override
  String get gallery => 'معرض';

  @override
  String get camera => 'كاميرا';

  @override
  String addImageButton(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إضافة صورة',
        'female': 'إضافة صورة',
        'other': 'إضافة صورة',
      },
    );
    return '$_temp0';
  }

  @override
  String addImageTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'من أين تضيف',
        'female': 'من أين تضيف',
        'other': 'من أين تضيف',
      },
    );
    return '$_temp0';
  }

  @override
  String feelGoodTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'صور مشجعة ورفعة',
        'female': 'صور مشجعة ورفعة',
        'other': 'صور مشجعة ورفعة',
      },
    );
    return '$_temp0';
  }

  @override
  String feelGoodSubTitle(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'يوصى بإضافة صور مشجعة وملهمة ومبهجة. صور مبتسمة للعائلة والأصدقاء والهوايات والرحلات الناجحة والمزيد',
        'female':
            'يوصى بإضافة صور مشجعة وملهمة ومبهجة. صور مبتسمة للعائلة والأصدقاء والهوايات والرحلات الناجحة والمزيد',
        'other':
            'يوصى بإضافة صور مشجعة وملهمة ومبهجة. صور مبتسمة للعائلة والأصدقاء والهوايات والرحلات الناجحة والمزيد',
      },
    );
    return '$_temp0';
  }

  @override
  String get male => 'ذكر';

  @override
  String get notWillingToSay => 'أفضل عدم الإفصاح';

  @override
  String get noPermissionAllowedText => 'لم يتم منح الإذن';

  @override
  String get female => 'أنثى';

  @override
  String get nonBinary => 'غير ثنائي';

  @override
  String showAll(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إظهار الكل',
        'female': 'إظهار الكل',
        'other': 'إظهار الكل',
      },
    );
    return '$_temp0';
  }

  @override
  String notificationPageHeader(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أضف تذكيرًا لاستخدام \"العيش بشكل إيجابي\".',
        'female': 'أضف تذكيرًا لاستخدام \"العيش بشكل إيجابي\".',
        'other': 'أضف تذكيرًا لاستخدام \"العيش بشكل إيجابي\".',
      },
    );
    return '$_temp0';
  }

  @override
  String notificationSetTimeText(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'جدولة تذكير للوقت المحدد',
        'female': 'جدولة تذكير للوقت المحدد',
        'other': 'جدولة تذكير للوقت المحدد',
      },
    );
    return '$_temp0';
  }

  @override
  String notificationShowExampleNotification(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'عرض مثال للتذكير',
        'female': 'عرض مثال للتذكير',
        'other': 'عرض مثال للتذكير',
      },
    );
    return '$_temp0';
  }

  @override
  String notificationCancelNotification(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إلغاء الإخطار الحالي',
        'female': 'إلغاء الإخطار الحالي',
        'other': 'إلغاء الإخطار الحالي',
      },
    );
    return '$_temp0';
  }

  @override
  String finishedDownloading(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'انتهى التنزيل',
        'female': 'انتهى التنزيل',
        'other': 'انتهى التنزيل',
      },
    );
    return '$_temp0';
  }

  @override
  String downloadFailed(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'فشل التنزيل',
        'female': 'فشل التنزيل',
        'other': 'فشل التنزيل',
      },
    );
    return '$_temp0';
  }

  @override
  String selectLanguage(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اختر اللغة',
        'female': 'اختاري اللغة',
        'other': 'اختر/ي اللغة',
      },
    );
    return '$_temp0';
  }

  @override
  String get validateEmpty => 'لا يمكن أن يكون الحقل فارغًا';

  @override
  String get moreVideos => 'مقاطع فيديو إضافية';

  @override
  String get noVideosAvailableForLocale =>
      'لا توجد مقاطع فيديو متاحة للغتك، عذرًا.';

  @override
  String get confirmResetTitle => 'هل أنت متأكد؟';

  @override
  String get shareRoutineMessage =>
      'هذه هي خطتي الشخصية التي تهدف إلى المساعدة في الحفاظ على سلامتي. أرسلها إليك لأنه، من وجهة نظري، لديك أيضًا دور فيها. آمل أن يكون هذا مناسبا لك. وسأكون ممتنًا جدًا لموافقتك على المشاركة فيه إذا لزم الأمر. شكرا جزيلا مقدما، وأنا أتطلع إلى ردكم.';

  @override
  String get shareOptions => 'خيارات المشاركة';

  @override
  String get shareFile => 'مشاركة ملف الخطة الشخصية';

  @override
  String get shareRoutine => 'مشاركة النص لإشراك المؤيدين';

  @override
  String get shareEmergency => 'مشاركة النص في حالة الأزمات';

  @override
  String get shareEmergencyMessage =>
      'أنا لست بخير وأحتاج إلى المساعدة. سأكون ممتنًا لدعمكم في تفعيل خطتي الشخصية. شكرا لكم مقدما.';

  @override
  String get informationCollectionDisclaimer =>
      'المعلومات التي تم جمعها:\n\nيقوم التطبيق فقط بجمع البيانات مجهولة المصدر والإحصائية لغرض التحليل وتحسين الخدمة. لا يمكن لهذه البيانات تحديد أي مستخدم فردي. ومن بين البيانات التي تم جمعها:\n• بيانات استخدام التطبيق العامة (على سبيل المثال، الصفحات التي تم عرضها، وتكرار الاستخدام).\n• معلومات فنية عن الجهاز والنظام (نوع الجهاز، إصدار نظام التشغيل).\n• بيانات الموقع مجهولة المصدر - يتم جمعها فقط لتحليل الاتجاهات وأنماط الاستخدام، دون الارتباط بأي مستخدم يمكن تحديده.';

  @override
  String get addingContactDisclaimer =>
      'نحن لا نحفظ جهات الاتصال الخاصة بك، بل لاستخدامك الخاص.';

  @override
  String notifyOnscheduledNotification(Object time) {
    return 'تم ضبط التذكير على $time';
  }

  @override
  String newTraitOrThanks(Object item) {
    return '$item جديد';
  }

  @override
  String todoListName(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'مجلة الامتنان',
        'female': 'مجلة الامتنان',
        'other': 'مجلة الامتنان',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo0(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'ما سيساعدني الآن، حتى الخطوات الصغيرة هي التقدم',
        'female': 'ما سيساعدني الآن، حتى الخطوات الصغيرة هي التقدم',
        'other': 'ما سيساعدني الآن، حتى الخطوات الصغيرة هي التقدم',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo1(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لدي نقاط القوة',
        'female': 'لدي نقاط القوة',
        'other': 'لدي نقاط القوة',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo2(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لقد واجهت بالفعل تحديات في الماضي',
        'female': 'لقد واجهت بالفعل تحديات في الماضي',
        'other': 'لقد واجهت بالفعل تحديات في الماضي',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo3(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'يتغير المزاج مثل الطقس، وهو ليس ثابتًا',
        'female': 'يتغير المزاج مثل الطقس، وهو ليس ثابتًا',
        'other': 'يتغير المزاج مثل الطقس، وهو ليس ثابتًا',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo4(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'العواطف عابرة وتتغير',
        'female': 'العواطف عابرة وتتغير',
        'other': 'العواطف عابرة وتتغير',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo5(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا قادر',
        'female': 'أنا قادر',
        'other': 'أنا قادر',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo6(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لدي القوة',
        'female': 'لدي القوة',
        'other': 'لدي القوة',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo7(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا أتعلم الاسترخاء',
        'female': 'أنا أتعلم الاسترخاء',
        'other': 'أنا أتعلم الاسترخاء',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo8(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'وبعد الانخفاضات يأتي الصعود',
        'female': 'وبعد الانخفاضات يأتي الصعود',
        'other': 'وبعد الانخفاضات يأتي الصعود',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo9(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لا بأس في البكاء',
        'female': 'لا بأس في البكاء',
        'other': 'لا بأس في البكاء',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo10(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا للمساعدة',
        'female': 'شكرا للمساعدة',
        'other': 'شكرا للمساعدة',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo11(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'خذ لحظة لتبتسم',
        'female': 'خذ لحظة لتبتسم',
        'other': 'خذ لحظة لتبتسم',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo12(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تذكر أن تتنفس',
        'female': 'تذكر أن تتنفس',
        'other': 'تذكر أن تتنفس',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo13(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الروتين يخلق الاستقرار',
        'female': 'الروتين يخلق الاستقرار',
        'other': 'الروتين يخلق الاستقرار',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo14(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الحركة تطلق التوتر',
        'female': 'الحركة تطلق التوتر',
        'other': 'الحركة تطلق التوتر',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo15(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لا بأس في طلب المساعدة',
        'female': 'لا بأس في طلب المساعدة',
        'other': 'لا بأس في طلب المساعدة',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo16(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لا بأس أن لا تكون بخير',
        'female': 'لا بأس أن لا تكون بخير',
        'other': 'لا بأس أن لا تكون بخير',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo17(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'حافظ على الوتيرة المناسبة لك',
        'female': 'حافظ على الوتيرة المناسبة لك',
        'other': 'حافظ على الوتيرة المناسبة لك',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo18(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'ما الذي يمنحك القوة للاستمرار؟',
        'female': 'ما الذي يمنحك القوة للاستمرار؟',
        'other': 'ما الذي يمنحك القوة للاستمرار؟',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo19(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا قادر على التغلب على تحدياتي',
        'female': 'أنا قادر على التغلب على تحدياتي',
        'other': 'أنا قادر على التغلب على تحدياتي',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo20(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا قادر على تهدئة جسدي وعقلي',
        'female': 'أنا قادر على تهدئة جسدي وعقلي',
        'other': 'أنا قادر على تهدئة جسدي وعقلي',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo21(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لدي التعاطف مع الذات',
        'female': 'لدي التعاطف مع الذات',
        'other': 'لدي التعاطف مع الذات',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo22(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا قوي وقادر',
        'female': 'أنا قوي وقادر',
        'other': 'أنا قوي وقادر',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo23(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا أتعلم قبول نفسي',
        'female': 'أنا أتعلم قبول نفسي',
        'other': 'أنا أتعلم قبول نفسي',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo24(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا أقبل نفسي كما أنا',
        'female': 'أنا أقبل نفسي كما أنا',
        'other': 'أنا أقبل نفسي كما أنا',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo25(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أتعلم أن ألاحظ صفاتي الإيجابية',
        'female': 'أتعلم أن ألاحظ صفاتي الإيجابية',
        'other': 'أتعلم أن ألاحظ صفاتي الإيجابية',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo26(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أتعرف على مشاعري وأسمح لها بالمرور',
        'female': 'أتعرف على مشاعري وأسمح لها بالمرور',
        'other': 'أتعرف على مشاعري وأسمح لها بالمرور',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo27(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'يمكن أن تتغير العواطف بشكل طبيعي',
        'female': 'يمكن أن تتغير العواطف بشكل طبيعي',
        'other': 'يمكن أن تتغير العواطف بشكل طبيعي',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo28(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الحديث الإيجابي عن النفس يؤدي إلى احترام الذات',
        'female': 'الحديث الإيجابي عن النفس يؤدي إلى احترام الذات',
        'other': 'الحديث الإيجابي عن النفس يؤدي إلى احترام الذات',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo29(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الممارسة اليومية تؤدي إلى التحسن',
        'female': 'الممارسة اليومية تؤدي إلى التحسن',
        'other': 'الممارسة اليومية تؤدي إلى التحسن',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo30(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنت لست وحدك!',
        'female': 'أنت لست وحدك!',
        'other': 'أنت لست وحدك!',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo31(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الممارسة اليومية تحسن مزاجي، والاستمرار يستحق كل هذا العناء',
        'female': 'الممارسة اليومية تحسن مزاجي، والاستمرار يستحق كل هذا العناء',
        'other': 'الممارسة اليومية تحسن مزاجي، والاستمرار يستحق كل هذا العناء',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo32(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا ذو قيمة',
        'female': 'أنا ذو قيمة',
        'other': 'أنا ذو قيمة',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo33(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا أؤمن بقدراتي',
        'female': 'أنا أؤمن بقدراتي',
        'other': 'أنا أؤمن بقدراتي',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo34(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا أستحق ذلك',
        'female': 'أنا أستحق ذلك',
        'other': 'أنا أستحق ذلك',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo35(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا أعمل على الشعور بالتحسن',
        'female': 'أنا أعمل على الشعور بالتحسن',
        'other': 'أنا أعمل على الشعور بالتحسن',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo36(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الحياة تستحق العناء',
        'female': 'الحياة تستحق العناء',
        'other': 'الحياة تستحق العناء',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo37(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تشير الدراسات إلى أن الأفكار تؤثر على العواطف',
        'female': 'تشير الدراسات إلى أن الأفكار تؤثر على العواطف',
        'other': 'تشير الدراسات إلى أن الأفكار تؤثر على العواطف',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo38(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا أستحق أن أكون سعيدا',
        'female': 'أنا أستحق أن أكون سعيدا',
        'other': 'أنا أستحق أن أكون سعيدا',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo39(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أستطيع وسأفعل',
        'female': 'أستطيع وسأفعل',
        'other': 'أستطيع وسأفعل',
      },
    );
    return '$_temp0';
  }

  @override
  String inspirationalQuotesNo40(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنت عظيم كما أنت',
        'female': 'أنت عظيم كما أنت',
        'other': 'أنت عظيم كما أنت',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo0(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا لقضاء لحظات أسهل',
        'female': 'شكرا لقضاء لحظات أسهل',
        'other': 'شكرا لقضاء لحظات أسهل',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo1(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا لك على الوجبة الجيدة',
        'female': 'شكرا لك على الوجبة الجيدة',
        'other': 'شكرا لك على الوجبة الجيدة',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo2(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا لك على قدرتك على التدريب',
        'female': 'شكرا لك على قدرتك على التدريب',
        'other': 'شكرا لك على قدرتك على التدريب',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo3(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا لمحادثة جيدة',
        'female': 'شكرا لمحادثة جيدة',
        'other': 'شكرا لمحادثة جيدة',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo4(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا لك على النوم جيدا',
        'female': 'شكرا لك على النوم جيدا',
        'other': 'شكرا لك على النوم جيدا',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo5(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا لك على النجاح',
        'female': 'شكرا لك على النجاح',
        'other': 'شكرا لك على النجاح',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo6(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا لقضاء الوقت مع',
        'female': 'شكرا لقضاء الوقت مع',
        'other': 'شكرا لقضاء الوقت مع',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo7(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا على الطقس',
        'female': 'شكرا على الطقس',
        'other': 'شكرا على الطقس',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo8(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا لك على وجود منزل',
        'female': 'شكرا لك على وجود منزل',
        'other': 'شكرا لك على وجود منزل',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo9(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا لك على الصحة الجيدة',
        'female': 'شكرا لك على الصحة الجيدة',
        'other': 'شكرا لك على الصحة الجيدة',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo10(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا للعائلة',
        'female': 'شكرا للعائلة',
        'other': 'شكرا للعائلة',
      },
    );
    return '$_temp0';
  }

  @override
  String thanksListNo11(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'شكرا للأصدقاء',
        'female': 'شكرا للأصدقاء',
        'other': 'شكرا للأصدقاء',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo0(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أعرف كيف أطلب المساعدة',
        'female': 'أعرف كيف أطلب المساعدة',
        'other': 'أعرف كيف أطلب المساعدة',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo1(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا ودود',
        'female': 'أنا ودود',
        'other': 'أنا ودود',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo2(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا صديق جيد',
        'female': 'أنا صديق جيد',
        'other': 'أنا صديق جيد',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo3(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا مستعد للاستثمار',
        'female': 'أنا مستعد للاستثمار',
        'other': 'أنا مستعد للاستثمار',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo4(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا مبدع',
        'female': 'أنا مبدع',
        'other': 'أنا مبدع',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo5(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا قادر',
        'female': 'أنا قادر',
        'other': 'أنا قادر',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo6(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لدي نقاط القوة',
        'female': 'لدي نقاط القوة',
        'other': 'لدي نقاط القوة',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo7(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا أعرف كيف أقود',
        'female': 'أنا أعرف كيف أقود',
        'other': 'أنا أعرف كيف أقود',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo8(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا منفتح على التجارب',
        'female': 'أنا منفتح على التجارب',
        'other': 'أنا منفتح على التجارب',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo9(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لدي المثابرة والصبر',
        'female': 'لدي المثابرة والصبر',
        'other': 'لدي المثابرة والصبر',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo10(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا صبور',
        'female': 'أنا صبور',
        'other': 'أنا صبور',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo11(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا رياضي',
        'female': 'أنا رياضي',
        'other': 'أنا رياضي',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo12(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا قادر',
        'female': 'أنا قادر',
        'other': 'أنا قادر',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo13(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا جيد في التنظيم',
        'female': 'أنا جيد في التنظيم',
        'other': 'أنا جيد في التنظيم',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo14(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا أعرف كيف ألعب',
        'female': 'أنا أعرف كيف ألعب',
        'other': 'أنا أعرف كيف ألعب',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo15(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا أعرف كيف أطبخ',
        'female': 'أنا أعرف كيف أطبخ',
        'other': 'أنا أعرف كيف أطبخ',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo16(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا أب جيد',
        'female': 'أنا أب جيد',
        'other': 'أنا أب جيد',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo17(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا قوي',
        'female': 'أنا قوي',
        'other': 'أنا قوي',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo18(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا ذكي',
        'female': 'أنا ذكي',
        'other': 'أنا ذكي',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo19(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا جميلة',
        'female': 'أنا جميلة',
        'other': 'أنا جميلة',
      },
    );
    return '$_temp0';
  }

  @override
  String traitsListNo20(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنا مضحك',
        'female': 'أنا مضحك',
        'other': 'أنا مضحك',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo0(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'مشاهدة الأخبار',
        'female': 'مشاهدة الأخبار',
        'other': 'مشاهدة الأخبار',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo1(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'التوتر مع المقربين مني',
        'female': 'التوتر مع المقربين مني',
        'other': 'التوتر مع المقربين مني',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo2(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'حجج أو نزاعات متعددة',
        'female': 'حجج أو نزاعات متعددة',
        'other': 'حجج أو نزاعات متعددة',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo3(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لقد واجهت بالفعل تحديات في الماضي',
        'female': 'لقد واجهت بالفعل تحديات في الماضي',
        'other': 'لقد واجهت بالفعل تحديات في الماضي',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo4(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الظلم والإجحاف وانعدام الإنصاف',
        'female': 'الظلم والإجحاف وانعدام الإنصاف',
        'other': 'الظلم والإجحاف وانعدام الإنصاف',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo5(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'البطالة',
        'female': 'البطالة',
        'other': 'البطالة',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo6(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'خسارة',
        'female': 'خسارة',
        'other': 'خسارة',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo7(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تسريح العمال والبطالة',
        'female': 'تسريح العمال والبطالة',
        'other': 'تسريح العمال والبطالة',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo8(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الحمل الزائد',
        'female': 'الحمل الزائد',
        'other': 'الحمل الزائد',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo9(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الشعور بالنقص المالي',
        'female': 'الشعور بالنقص المالي',
        'other': 'الشعور بالنقص المالي',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo10(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الإجهاد، وتعدد المهام',
        'female': 'الإجهاد، وتعدد المهام',
        'other': 'الإجهاد، وتعدد المهام',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo11(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أشياء غير مكتملة',
        'female': 'أشياء غير مكتملة',
        'other': 'أشياء غير مكتملة',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo12(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'نظام غذائي غير منتظم',
        'female': 'نظام غذائي غير منتظم',
        'other': 'نظام غذائي غير منتظم',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo13(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'حرب',
        'female': 'حرب',
        'other': 'حرب',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo14(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'مغلق',
        'female': 'مغلق',
        'other': 'مغلق',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo15(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الحرمان من النوم',
        'female': 'الحرمان من النوم',
        'other': 'الحرمان من النوم',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo16(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'وفاة أحبائهم',
        'female': 'وفاة أحبائهم',
        'other': 'وفاة أحبائهم',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo17(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'فقدان الاستقرار والروتين',
        'female': 'فقدان الاستقرار والروتين',
        'other': 'فقدان الاستقرار والروتين',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo18(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'عندما لا يكون لدي الوقت لإطلاق الطاقة والعدوان',
        'female': 'عندما لا يكون لدي الوقت لإطلاق الطاقة والعدوان',
        'other': 'عندما لا يكون لدي الوقت لإطلاق الطاقة والعدوان',
      },
    );
    return '$_temp0';
  }

  @override
  String difficultEventsListNo19(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'التحفيز الزائد، وعدم اليقين، والتحولات',
        'female': 'التحفيز الزائد، وعدم اليقين، والتحولات',
        'other': 'التحفيز الزائد، وعدم اليقين، والتحولات',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo0(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'ساعدني في المشاريع المشتركة التي تعطي معنى',
        'female': 'ساعدني في المشاريع المشتركة التي تعطي معنى',
        'other': 'ساعدني في المشاريع المشتركة التي تعطي معنى',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo1(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لمعرفة ما يحدث لي والتفكير معي في طريقة للتعامل معه',
        'female': 'لمعرفة ما يحدث لي والتفكير معي في طريقة للتعامل معه',
        'other': 'لمعرفة ما يحدث لي والتفكير معي في طريقة للتعامل معه',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo2(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اسمحوا لي أن أدرج في العمل التعاوني',
        'female': 'اسمحوا لي أن أدرج في العمل التعاوني',
        'other': 'اسمحوا لي أن أدرج في العمل التعاوني',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo3(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'دعهم يزورونني',
        'female': 'دعهم يزورونني',
        'other': 'دعهم يزورونني',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo4(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'دعهم يدعوني للعب أو ممارسة لعبة',
        'female': 'دعهم يدعوني للعب أو ممارسة لعبة',
        'other': 'دعهم يدعوني للعب أو ممارسة لعبة',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo5(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اسمحوا لي أن تتم دعوتي إلى نشاط مشترك',
        'female': 'اسمحوا لي أن تتم دعوتي إلى نشاط مشترك',
        'other': 'اسمحوا لي أن تتم دعوتي إلى نشاط مشترك',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo6(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'يشجعونني على النوم بما فيه الكفاية',
        'female': 'يشجعونني على النوم بما فيه الكفاية',
        'other': 'يشجعونني على النوم بما فيه الكفاية',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo7(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لا تبقى وحيدا',
        'female': 'لا تبقى وحيدا',
        'other': 'لا تبقى وحيدا',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo8(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'دعهم يدعوني لتناول وجبة',
        'female': 'دعهم يدعوني لتناول وجبة',
        'other': 'دعهم يدعوني لتناول وجبة',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo9(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'للحصول على الغذاء المغذي',
        'female': 'للحصول على الغذاء المغذي',
        'other': 'للحصول على الغذاء المغذي',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo10(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أن أطلب من شخص أثق به أن يبقى معي',
        'female': 'أن أطلب من شخص أثق به أن يبقى معي',
        'other': 'أن أطلب من شخص أثق به أن يبقى معي',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo11(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اسمح لي بدعوتي للمشي أو التنزه أو ممارسة النشاط البدني',
        'female': 'اسمح لي بدعوتي للمشي أو التنزه أو ممارسة النشاط البدني',
        'other': 'اسمح لي بدعوتي للمشي أو التنزه أو ممارسة النشاط البدني',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo12(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تجنب الأماكن التي تجعلني أشعر بعدم الأمان',
        'female': 'تجنب الأماكن التي تجعلني أشعر بعدم الأمان',
        'other': 'تجنب الأماكن التي تجعلني أشعر بعدم الأمان',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo13(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أن أترك فقط كمية صغيرة من أدويتي معي',
        'female': 'أن أترك فقط كمية صغيرة من أدويتي معي',
        'other': 'أن أترك فقط كمية صغيرة من أدويتي معي',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo14(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'والباقي يجب أن أعهد به إلى شخص أثق به',
        'female': 'والباقي يجب أن أعهد به إلى شخص أثق به',
        'other': 'والباقي يجب أن أعهد به إلى شخص أثق به',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo15(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'أن أطلب من شخص آخر أن يزيل عني أشياء يمكن استخدامها لإيذاء نفسي',
        'female':
            'أن أطلب من شخص آخر أن يزيل عني أشياء يمكن استخدامها لإيذاء نفسي',
        'other':
            'أن أطلب من شخص آخر أن يزيل عني أشياء يمكن استخدامها لإيذاء نفسي',
      },
    );
    return '$_temp0';
  }

  @override
  String makeSaferListNo16(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أنهم سوف يسألونني',
        'female': 'أنهم سوف يسألونني',
        'other': 'أنهم سوف يسألونني',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo0(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اليقظه',
        'female': 'اليقظه',
        'other': 'اليقظه',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo1(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'وقت منتظم للزوجين / الاجتماعي خلال الأسبوع',
        'female': 'وقت منتظم للزوجين / الاجتماعي خلال الأسبوع',
        'other': 'وقت منتظم للزوجين / الاجتماعي خلال الأسبوع',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo2(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'قائمة نقاط القوة والمزايا',
        'female': 'قائمة نقاط القوة والمزايا',
        'other': 'قائمة نقاط القوة والمزايا',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo3(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'مجلة الامتنان',
        'female': 'مجلة الامتنان',
        'other': 'مجلة الامتنان',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo4(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لأقول عندما يكون لدي الوقت للاستماع',
        'female': 'لأقول عندما يكون لدي الوقت للاستماع',
        'other': 'لأقول عندما يكون لدي الوقت للاستماع',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo5(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تمهل وحاول ألا تثقل كاهلي أكثر من اللازم',
        'female': 'تمهل وحاول ألا تثقل كاهلي أكثر من اللازم',
        'other': 'تمهل وحاول ألا تثقل كاهلي أكثر من اللازم',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo6(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'قطع الاتصال بالمهام والشاشات اليومية',
        'female': 'قطع الاتصال بالمهام والشاشات اليومية',
        'other': 'قطع الاتصال بالمهام والشاشات اليومية',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo7(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لرؤية ضوء الشمس',
        'female': 'لرؤية ضوء الشمس',
        'other': 'لرؤية ضوء الشمس',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo8(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اخرج إلى الطبيعة',
        'female': 'اخرج إلى الطبيعة',
        'other': 'اخرج إلى الطبيعة',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo9(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'استراحة',
        'female': 'استراحة',
        'other': 'استراحة',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo10(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'وقت هادئ لنفسي',
        'female': 'وقت هادئ لنفسي',
        'other': 'وقت هادئ لنفسي',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo11(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'نظف أسنانك لتحصل على طعم جديد في فمك',
        'female': 'نظف أسنانك لتحصل على طعم جديد في فمك',
        'other': 'نظف أسنانك لتحصل على طعم جديد في فمك',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo12(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أو أن تأخذ العلكة',
        'female': 'أو أن تأخذ العلكة',
        'other': 'أو أن تأخذ العلكة',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo13(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أن أتلقى عناقاً من شخص أثق به',
        'female': 'أن أتلقى عناقاً من شخص أثق به',
        'other': 'أن أتلقى عناقاً من شخص أثق به',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo14(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لأقول لنفسي: \"أنا مهم\"',
        'female': 'لأقول لنفسي: \"أنا مهم\"',
        'other': 'لأقول لنفسي: \"أنا مهم\"',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo15(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'هناك أشخاص يحبونني',
        'female': 'هناك أشخاص يحبونني',
        'other': 'هناك أشخاص يحبونني',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo16(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'التركيز على التنفس / الأحاسيس الجسدية',
        'female': 'التركيز على التنفس / الأحاسيس الجسدية',
        'other': 'التركيز على التنفس / الأحاسيس الجسدية',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo17(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'أخذ قسط من الراحة عن طريق تغيير موقعي (على سبيل المثال، الانتقال إلى غرفة أخرى في المنزل)',
        'female':
            'أخذ قسط من الراحة عن طريق تغيير موقعي (على سبيل المثال، الانتقال إلى غرفة أخرى في المنزل)',
        'other':
            'أخذ قسط من الراحة عن طريق تغيير موقعي (على سبيل المثال، الانتقال إلى غرفة أخرى في المنزل)',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo18(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'للذهاب في نزهة قصيرة بالخارج',
        'female': 'للذهاب في نزهة قصيرة بالخارج',
        'other': 'للذهاب في نزهة قصيرة بالخارج',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo19(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male':
            'الخروج لاستنشاق بعض الهواء النقي (خارج المنزل أو حتى من الشرفة)',
        'female':
            'الخروج لاستنشاق بعض الهواء النقي (خارج المنزل أو حتى من الشرفة)',
        'other':
            'الخروج لاستنشاق بعض الهواء النقي (خارج المنزل أو حتى من الشرفة)',
      },
    );
    return '$_temp0';
  }

  @override
  String feelBetterListNo20(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'لمشاهدة المقاطع',
        'female': 'لمشاهدة المقاطع',
        'other': 'لمشاهدة المقاطع',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo0(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أفكار انتحارية',
        'female': 'أفكار انتحارية',
        'other': 'أفكار انتحارية',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo1(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'احترام الذات متدني',
        'female': 'احترام الذات متدني',
        'other': 'احترام الذات متدني',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo2(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الشعور وكأنني لا يهم',
        'female': 'الشعور وكأنني لا يهم',
        'other': 'الشعور وكأنني لا يهم',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo3(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الرغبة في الانزواء أو الاختباء أو الاختفاء',
        'female': 'الرغبة في الانزواء أو الاختباء أو الاختفاء',
        'other': 'الرغبة في الانزواء أو الاختباء أو الاختفاء',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo4(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'التعب الشديد',
        'female': 'التعب الشديد',
        'other': 'التعب الشديد',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo5(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'انخفاض في الوظيفة',
        'female': 'انخفاض في الوظيفة',
        'other': 'انخفاض في الوظيفة',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo6(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'فقدان أو نقصان القوة',
        'female': 'فقدان أو نقصان القوة',
        'other': 'فقدان أو نقصان القوة',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo7(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'القلق',
        'female': 'القلق',
        'other': 'القلق',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo8(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'انخفاض النشاط الجنسي',
        'female': 'انخفاض النشاط الجنسي',
        'other': 'انخفاض النشاط الجنسي',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo9(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اللامبالاة أو عدم الاكتراث',
        'female': 'اللامبالاة أو عدم الاكتراث',
        'other': 'اللامبالاة أو عدم الاكتراث',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo10(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الحساسية المفرطة',
        'female': 'الحساسية المفرطة',
        'other': 'الحساسية المفرطة',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo11(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'اللوم الذاتي',
        'female': 'اللوم الذاتي',
        'other': 'اللوم الذاتي',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo12(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'انتشار وتصاعد التسوق',
        'female': 'انتشار وتصاعد التسوق',
        'other': 'انتشار وتصاعد التسوق',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo13(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'إهمال الذات',
        'female': 'إهمال الذات',
        'other': 'إهمال الذات',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo14(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الثقة المفرطة',
        'female': 'الثقة المفرطة',
        'other': 'الثقة المفرطة',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo15(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'للقيام بالحد الأدنى من الحد الأدنى - وحتى ذلك بجهد كبير',
        'female': 'للقيام بالحد الأدنى من الحد الأدنى - وحتى ذلك بجهد كبير',
        'other': 'للقيام بالحد الأدنى من الحد الأدنى - وحتى ذلك بجهد كبير',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo16(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'سوء الأداء',
        'female': 'سوء الأداء',
        'other': 'سوء الأداء',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo17(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'العقل يتسابق',
        'female': 'العقل يتسابق',
        'other': 'العقل يتسابق',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo18(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الأفكار تتسابق وبسرعة',
        'female': 'الأفكار تتسابق وبسرعة',
        'other': 'الأفكار تتسابق وبسرعة',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo19(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'عدم الثقة',
        'female': 'عدم الثقة',
        'other': 'عدم الثقة',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo20(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تردد',
        'female': 'تردد',
        'other': 'تردد',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo21(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'أفكار بطيئة ومربكة',
        'female': 'أفكار بطيئة ومربكة',
        'other': 'أفكار بطيئة ومربكة',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo22(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'زيادة الانبساط',
        'female': 'زيادة الانبساط',
        'other': 'زيادة الانبساط',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo23(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'المشاركة',
        'female': 'المشاركة',
        'other': 'المشاركة',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo24(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'تجمع',
        'female': 'تجمع',
        'other': 'تجمع',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo25(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'العزلة',
        'female': 'العزلة',
        'other': 'العزلة',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo26(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'ملء كل مساحة من الزمن',
        'female': 'ملء كل مساحة من الزمن',
        'other': 'ملء كل مساحة من الزمن',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo27(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الخوف من البقاء وحيدا',
        'female': 'الخوف من البقاء وحيدا',
        'other': 'الخوف من البقاء وحيدا',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo28(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الخوف من الفراغ',
        'female': 'الخوف من الفراغ',
        'other': 'الخوف من الفراغ',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo29(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الاستخدام المكثف للوسائط المختلفة',
        'female': 'الاستخدام المكثف للوسائط المختلفة',
        'other': 'الاستخدام المكثف للوسائط المختلفة',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo30(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'المزيد من الصداع',
        'female': 'المزيد من الصداع',
        'other': 'المزيد من الصداع',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo31(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الإفراط في تناول الطعام',
        'female': 'الإفراط في تناول الطعام',
        'other': 'الإفراط في تناول الطعام',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo32(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'النوم غير المنتظم',
        'female': 'النوم غير المنتظم',
        'other': 'النوم غير المنتظم',
      },
    );
    return '$_temp0';
  }

  @override
  String distractionsListNo33(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الأرق أو النوم الخفيف',
        'female': 'الأرق أو النوم الخفيف',
        'other': 'الأرق أو النوم الخفيف',
      },
    );
    return '$_temp0';
  }

  @override
  String get aboutPage1 =>
      'Living Positively عبارة عن منصة مصممة لتعزيز المرونة العقلية، والمساعدة في التعامل مع حالات الأزمات الانتحارية، وتشجيع الإدارة الذاتية، وإنشاء شبكة دعم شخصية، وتعزيز حياة أفضل وذات جودة أعلى. تم تطويره من قبل منظمة النادي التابعة لجمعية أميت.\n\nيستخدم هذا التطبيق أدوات من مجال علم النفس الإيجابي وإدارة المرض والتعافي وأبحاث الوقاية من الانتحار.\n\nيجمع البرنامج الشخصي بين خطة الوقاية من الانتكاسات من دورة IMR (إدارة المرض والتعافي) بالإضافة إلى خطة السلامة من ستانلي وبراون.\n\nمصطلح \"قائمة الامتنان\" قدمته لنا الدكتورة شيرلي يوفال يائير لمجلة الامتنان وتم نشره هنا بموافقتها.\n\nيتم تطوير المنتج بالتعاون والإثراء المتبادل مع الحاضنة الاجتماعية في التخنيون، بمساعدة فريق التطوير.';

  @override
  String get aboutPage2 =>
      'التطبيق مخصص للاستخدام الشخصي لتحسين المرونة العقلية وتقديم الدعم والمساعدة عند الحاجة في حالات الأزمات.\n\nلا يمكن للتطبيق، وليس مصممًا، أن يحل محل مقدمي خدمات الصحة العقلية المحترفين. ولا يحل محل التشخيص المهني أو العلاج النفسي. الغرض من الأدوات المتكاملة هو مساعدتك ومساعدة بيئتك على تحسين نوعية الحياة وتقديم الدعم أثناء الأزمات.\n\nيمكنك استخدام التطبيق لأغراض المساعدة الذاتية و/أو دمجه كجزء من عملية علاجية مع أحد المتخصصين. إذا كنت بحاجة إلى تشخيص أو علاج شخصي، فمن المهم استشارة معالج متخصص. استخدام التطبيق هو على مسؤوليتك الشخصية.\n\nلاهتمامك: يتم تخزين بياناتك الشخصية في التطبيق على جهازك فقط! لا يقوم التطبيق بجمع أو نقل المعلومات الشخصية، ولن يتم استخدامها أبدًا. لديك خيار تحديد ما تريد مشاركته من الداخل، مثل الخطة الشخصية، التي يوصى بمشاركتها مع شبكتك الاجتماعية المقربة و/أو المتخصصين العلاجيين. إذا كنت لا توافق على شروط الاستخدام، يرجى إلغاء تثبيت التطبيق.';

  @override
  String get aboutTitle1 => 'حول والاعتمادات';

  @override
  String get aboutTitle2 => 'شروط الاستخدام والخصوصية';

  @override
  String aboutVersionLabel(String version) {
    return 'إصدار تطبيق Living Positively: $version';
  }

  @override
  String locationSelect(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'الرجاء تحديد موقعك:',
        'female': 'الرجاء تحديد موقعك:',
        'other': 'الرجاء تحديد موقعك:',
      },
    );
    return '$_temp0';
  }

  @override
  String get disclaimerText =>
      'تم تصميم التطبيق للاستخدام الشخصي لتحسين المرونة العقلية وتقديم الدعم في أوقات الأزمات.\n\nولا يمكن ولا يهدف إلى استبدال مقدمي خدمات الصحة العقلية المحترفين. ولا يحل محل التشخيص المهني أو العلاج النفسي. تهدف الأدوات المدمجة في التطبيق إلى مساعدتك ومساعدة بيئتك في تحسين نوعية الحياة وتقديم الدعم خلال الأوقات الصعبة.\n\nيمكنك استخدام التطبيق لأغراض المساعدة الذاتية و/أو كجزء من عملية علاجية مع مقدم خدمة محترف. إذا كنت بحاجة إلى تشخيص أو علاج شخصي، فمن المهم استشارة معالج متخصص. استخدام التطبيق هو على مسؤوليتك الشخصية.\n\nيرجى ملاحظة: يتم تخزين بياناتك الشخصية داخل التطبيق على جهازك فقط! لا يقوم التطبيق بجمع أو نقل أي معلومات شخصية، ولن يتم استخدام هذه البيانات أبدًا. لديك خيار تحديد ما تريد مشاركته، مثل خطتك الشخصية، والتي يمكن مشاركتها مع جهات الاتصال الاجتماعية الوثيقة و/أو المتخصصين العلاجيين.\n\nإذا كنت لا توافق على شروط الاستخدام، يرجى إزالة التطبيق. إذا قبلت هذه الشروط، يرجى النقر على زر \"قبول\".';

  @override
  String get shareButtonText => 'مشاركة';

  @override
  String get shareAppMessage =>
      'هنا هو التطبيق LP (العيش بشكل إيجابي). أستخدمه وأوصي به، ربما سيكون مفيدًا لك أيضًا.';

  @override
  String locationDisclaimer(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'يتم استخدام موقعك فقط من أجل تخصيص أرقام SOS لبلدك.',
        'female': 'يتم استخدام موقعك فقط من أجل تخصيص أرقام SOS لبلدك.',
        'other': 'يتم استخدام موقعك فقط من أجل تخصيص أرقام SOS لبلدك.',
      },
    );
    return '$_temp0';
  }
}
