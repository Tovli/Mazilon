import 'package:mazilon/lists.dart';

//this function is used in the form pages to get the correct information for each page
Map<String, dynamic> retrieveInformation(name, gender, textLocalization) {
  String header;
  String subTitle;
  String midTitle;
  String midSubTitle;
  String nextButtonText;
  String showMoreButtonText;
  List<String> list;

  switch (name) {
    case 'PersonalPlan-DifficultEvents':
      header = textLocalization.difficultEventsHeader(gender);
      subTitle = textLocalization.difficultEventsSubTitle(gender);
      midTitle = textLocalization.difficultEventsMidTitle(gender);
      midSubTitle = textLocalization.difficultEventsMidSubTitle(gender);
      list = difficultEventsList[textLocalization.localeName]![
              gender == "" ? "other" : gender] ??
          [];

      break;
    case 'PersonalPlan-MakeSafer':
      header = textLocalization.makeSaferHeader(gender);
      subTitle = textLocalization.makeSaferSubTitle(gender);
      midTitle = textLocalization.makeSaferMidTitle(gender);
      midSubTitle = textLocalization.makeSaferMidSubTitle(gender);
      list = makeSaferList[textLocalization.localeName]![
              gender == "" ? "other" : gender] ??
          [];
      break;
    case 'PersonalPlan-FeelBetter':
      header = textLocalization.feelBetterHeader(gender);
      subTitle = textLocalization.feelBetterSubTitle(gender);
      midTitle = textLocalization.feelBetterMidTitle(gender);
      midSubTitle = textLocalization.feelBetterMidSubTitle(gender);
      list = feelBetterList[textLocalization.localeName]![
              gender == "" ? "other" : gender] ??
          [];
      break;
    case 'PersonalPlan-Distractions':
      header = textLocalization.distractionsHeader(gender);
      subTitle = textLocalization.distractionsSubTitle(gender);
      midTitle = textLocalization.distractionsMidTitle(gender);
      midSubTitle = textLocalization.distractionsMidSubTitle(gender);
      list = distractionsList[textLocalization.localeName]![
              gender == "" ? "other" : gender] ??
          [];
      break;
    default:
      throw Exception('Invalid collection name');
  }
  nextButtonText = textLocalization.nextButton(gender);
  showMoreButtonText = textLocalization.showMoreButton(gender);
  print(list);
  return {
    'header': header,
    'subTitle': subTitle,
    'midTitle': midTitle,
    'midSubTitle': midSubTitle,
    'nextButtonText': nextButtonText,
    'showMoreButtonText': showMoreButtonText,
    'list': list,
  };
}
