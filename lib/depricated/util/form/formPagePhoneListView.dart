import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "package:mazilon/util/Form/formPagePhoneModel.dart";
import "package:mazilon/util/Form/PagePhoneItem.dart";

class MyListView extends StatefulWidget {
  PhonePageData phonePageData; // Add this line
  MyListView({required this.phonePageData});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class Phonedata {
  String name;
  String phoneDescription;
  String number;
  Phonedata(
      {required this.name,
      required this.number,
      required this.phoneDescription});
}

class _MyListViewState extends State<MyListView>
    with AutomaticKeepAliveClientMixin {
  List<Phonedata> phoneData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool _isDataLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataLoaded) {
      PhonePageData phonePageData = Provider.of<PhonePageData>(context);
      for (int i = 0; i < phonePageData.phoneNames.length; i++) {
        phoneData.add(Phonedata(
            name: phonePageData.phoneNames[i],
            number: phonePageData.phoneNumbers[i],
            phoneDescription: phonePageData.phoneDescription[i]));
      }
      _isDataLoaded = true;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: phoneData
              .asMap()
              .entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Column(
                      children: [
                        PagePhoneItem(
                          icon: entry.key == 2
                              ? Icons.chat
                              : Icons
                                  .phone, // Use text icon for the 3rd item, phone icon for the others
                          phoneNumber: entry.value.number,
                          phoneName: entry.value.name,
                          phoneDescription: entry.value.phoneDescription,
                        ),
                      ],
                    ),
                  ))
              .toList()
            ..forEach((widget) {
              var paddingWidget = widget as Padding;
              var column = paddingWidget.child as Column?;
              if (column != null) {
                var index = column.children.indexOf(widget);
                if (index != phoneData.length - 1) {
                  column.children.add(Divider(color: Colors.grey));
                }
              }
            }),
        ),
      ),
    );
  }
}
