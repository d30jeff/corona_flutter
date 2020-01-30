import 'package:ant_icons/ant_icons.dart';
import 'package:corona_flutter/core/api.dart';
import 'package:corona_flutter/utils/constants.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static void openArticle({
    String url,
    BuildContext context,
  }) async {
    try {
      await launch(
        url,
        option: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static String formatDate(String timestamp) {
    return DateFormat.yMMMEd().add_jm().format(DateTime.parse(timestamp));
  }

  static String mapNewsFeedTypeEnumToString(NewsFeedType feedType) {
    switch (feedType) {
      case NewsFeedType.trending:
        return 'Trending';
      case NewsFeedType.latest:
        return 'Latest';
      default:
        return '';
    }
  }

  static NewsFeedType mapStringToNewsFeedTypeEnum(String value) {
    if (value == 'Trending') {
      return NewsFeedType.trending;
    } else {
      return NewsFeedType.latest;
    }
  }

  static updateUserPref(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static getUserPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Widget getFlagIcon({
    String countryCode,
    double width,
    double height,
    Color color = Colors.black,
  }) {
    if (countryCode == "GLOBAL") {
      return Icon(
        AntIcons.global,
        size: width,
        color: color,
      );
    }

    return Flags.getMiniFlag(countryCode, width, height);
  }

  static String getCountryName(String countryCode) {
    assert(countryCode != null);
    print('getCountryName::: $countryCode');

    try {
      String countryName = AppConstants.countriesList
          .firstWhere((country) => country["code"] == countryCode)["name"];

      return countryName == 'GLOBAL' ? '' : countryName;
    } catch (e) {
      return 'GLOBAL';
    }
  }
}
