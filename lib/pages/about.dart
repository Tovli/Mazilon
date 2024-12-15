import 'package:flutter/material.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/styles.dart';

//the about page , it shows the about page text and the logos of the social hub and the clubhouse
//the text is fetched from the appInformation provider, which fetches the text from the firebase database.
//the logos are in the assets/images folder
class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: SafeArea(
          child: Container(
            height: 130.0,
            // Mazilon Logo in the app bar
            child: Image.asset(
              'assets/images/Logo.png',
              width: MediaQuery.of(context).size.width * 0.4 > 1000
                  ? 500
                  : MediaQuery.of(context).size.width * 0.2, // Adjust as needed
            ),
          ),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  //the first title of the about page
                  child: myAutoSizedText(
                      appInfoProvider.aboutPageText['aboutPageTitle1'] ?? '',
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      TextAlign.center,
                      60),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  //the first text of the about page
                  child: myAutoSizedText(
                      appInfoProvider.aboutPageText['aboutPageText1'] ?? '',
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                      TextAlign.justify,
                      35),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: myAutoSizedText(
                      appInfoProvider.aboutPageText['englishText'] ?? '',
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                      TextAlign.justify,
                      35),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  //the second title of the about page
                  child: myAutoSizedText(
                      appInfoProvider.aboutPageText['aboutPageTitle2'] ?? '',
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      TextAlign.center,
                      60),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  //the second text of the about page
                  child: myAutoSizedText(
                      appInfoProvider.aboutPageText['aboutPageText2'] ?? '',
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                      TextAlign.justify,
                      35),
                ),
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/images/SocialHub-Logo.png',
                      width: MediaQuery.of(context).size.width *
                          0.4, // Adjust as needed
                      // Optional: if you want to specify the height
                      // height: MediaQuery.of(context).size.height * 0.2, // Adjust as needed
                    ),
                  ),
                  const SizedBox(
                      width: 20), // Adds space between the two images
                  Flexible(
                    child: Image.asset(
                      'assets/images/clubhouse-Logo.png',
                      width: MediaQuery.of(context).size.width *
                          0.4, // Adjust as needed
                      // Optional: if you want to specify the height
                      // height: MediaQuery.of(context).size.height * 0.2, // Adjust as needed
                    ),
                  ),
                  // you can add more images here to show them in the same row as the above two images,
                  // just copy the Flexible widget and change the image path and width as needed.
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
