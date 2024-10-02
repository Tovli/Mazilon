//this function is used in the form pages to get the correct information for each page
Map<String, String> retrieveInformation(appInfoProvider, name, gender) {
  String header;
  String subTitle;
  String midTitle;
  String midSubTitle;
  String nextButtonText;
  String showMoreButtonText;

  switch (name) {
    case 'PersonalPlan-DifficultEvents':
      header = appInfoProvider.formDifficultEventsTitles['header$gender']!;
      subTitle = appInfoProvider.formDifficultEventsTitles['subTitle$gender']!;
      midTitle = appInfoProvider.formDifficultEventsTitles['midTitle$gender']!;
      midSubTitle =
          appInfoProvider.formDifficultEventsTitles['midSubTitle$gender']!;

      nextButtonText = appInfoProvider.formDifficultEventsTitles['nextButton']!;
      showMoreButtonText =
          appInfoProvider.formDifficultEventsTitles['showMoreButton']!;

      break;
    case 'PersonalPlan-MakeSafer':
      header = appInfoProvider.formMakeSaferTitles['header$gender']!;
      subTitle = appInfoProvider.formMakeSaferTitles['subTitle$gender']!;
      midTitle = appInfoProvider.formMakeSaferTitles['midTitle$gender']!;
      midSubTitle = appInfoProvider.formMakeSaferTitles['midSubTitle$gender']!;

      nextButtonText = appInfoProvider.formMakeSaferTitles['nextButton']!;
      showMoreButtonText =
          appInfoProvider.formMakeSaferTitles['showMoreButton']!;
      break;
    case 'PersonalPlan-FeelBetter':
      header = appInfoProvider.formFeelBetterTitles['header$gender']!;
      subTitle = appInfoProvider.formFeelBetterTitles['subTitle$gender']!;
      midTitle = appInfoProvider.formFeelBetterTitles['midTitle$gender']!;
      midSubTitle = appInfoProvider.formFeelBetterTitles['midSubTitle$gender']!;

      nextButtonText = appInfoProvider.formFeelBetterTitles['nextButton']!;
      showMoreButtonText =
          appInfoProvider.formFeelBetterTitles['showMoreButton']!;
      break;
    case 'PersonalPlan-Distractions':
      header = appInfoProvider.formDistractionsTitles['header$gender']!;
      subTitle = appInfoProvider.formDistractionsTitles['subTitle$gender']!;
      midTitle = appInfoProvider.formDistractionsTitles['midTitle$gender']!;
      midSubTitle =
          appInfoProvider.formDistractionsTitles['midSubTitle$gender']!;

      nextButtonText = appInfoProvider.formDistractionsTitles['nextButton']!;
      showMoreButtonText =
          appInfoProvider.formDistractionsTitles['showMoreButton']!;
      break;
    default:
      throw Exception('Invalid collection name');
  }

  return {
    'header': header,
    'subTitle': subTitle,
    'midTitle': midTitle,
    'midSubTitle': midSubTitle,
    'nextButtonText': nextButtonText,
    'showMoreButtonText': showMoreButtonText
  };
}
