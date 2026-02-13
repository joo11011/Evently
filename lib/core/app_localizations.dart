import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static final LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString(
      'assets/translation/${locale.languageCode}.json',
    );
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  String get logo => translate('logo');
  String get onBoardingTitle1 => translate('onBoardingTitle_1');
  String get onBoardingDesc1 => translate('onBoardingDesc_1');
  String get onBoardingTitle2 => translate('onBoardingTitle_2');
  String get onBoardingDesc2 => translate('onBoardingDesc_2');
  String get onBoardingTitle3 => translate('onBoardingTitle_3');
  String get onBoardingDesc3 => translate('onBoardingDesc_3');
  String get onBoardingTitle4 => translate('onBoardingTitle_4');
  String get onBoardingDesc4 => translate('onBoardingDesc_4');
  String get language => translate('language');
  String get theme => translate('theme');
  String get startButton => translate('startButton');
  String get loginButton => translate('loginButton');
  String get createAccountButton => translate('createAccountButton');
  String get resetPasswordButton => translate('resetPasswordButton');
  String get logoutButton => translate('logoutButton');
  String get addEventButton => translate('addEventButton');
  String get editEventButton => translate('editEventButton');
  String get googleButton => translate('googleButton');
  String get nameTextField => translate('nameTextField');
  String get emailTextField => translate('emailTextField');
  String get passwordTextField => translate('passwordTextField');
  String get confirmPasswordTextField => translate('confirmPasswordTextField');
  String get forgotPasswordTextField => translate('forgotPasswordTextField');
  String get loginText1 => translate('loginText_1');
  String get or => translate('or');
  String get registerText1 => translate('registerText_1');
  String get registerText2 => translate('registerText_2');
  String get home => translate('home');
  String get location => translate('location');
  String get favorites => translate('favorites');
  String get profile => translate('profile');
  String get welcomeBack => translate('welcomeBack');
  String get cairoEgypt => translate('cairoEgypt');
  String get searchForEvent => translate('searchForEvent');
  String get noFavoriteEvents => translate('noFavoriteEvents');
  String get noEventsMatch => translate('noEventsMatch');
  String get english => translate('english');
  String get arabic => translate('arabic');
  String get light => translate('light');
  String get dark => translate('dark');
  String get logout => translate('logout');
  String get createEvent => translate('createEvent');
  String get title => translate('title');
  String get eventTitle => translate('eventTitle');
  String get description => translate('description');
  String get eventDescription => translate('eventDescription');
  String get eventDate => translate('eventDate');
  String get chooseDate => translate('chooseDate');
  String get eventTime => translate('eventTime');
  String get chooseTime => translate('chooseTime');
  String get updateEvent => translate('updateEvent');
  String get eventDetails => translate('eventDetails');
  String get forgetPassword => translate('forgetPassword');
  String get email => translate('email');
  String get pleaseEnterEmail => translate('pleaseEnterEmail');
  String get pleaseEnterValidEmail => translate('pleaseEnterValidEmail');
  String get nameNotFound => translate('nameNotFound');
  String get emailNotFound => translate('emailNotFound');
  String get all => translate('all');
  String get birthday => translate('birthday');
  String get bookClub => translate('bookClub');
  String get eating => translate('eating');
  String get exhibition => translate('exhibition');
  String get gaming => translate('gaming');
  String get sport => translate('sport');
  String get meeting => translate('meeting');
  String get workShop => translate('workShop');
  String get holiday => translate('holiday');

  String translateCategory(String? categoryId) {
    switch (categoryId) {
      case 'All':
        return all;
      case 'Birthday':
        return birthday;
      case 'Book Club':
        return bookClub;
      case 'Eating':
        return eating;
      case 'Exhibition':
        return exhibition;
      case 'Gaming':
        return gaming;
      case 'Sport':
        return sport;
      case 'Meeting':
        return meeting;
      case 'Work Shop':
        return workShop;
      case 'Holiday':
        return holiday;
      default:
        return categoryId ?? '';
    }
  }

  // Countdown
  String get days => translate('days');
  String get hours => translate('hours');
  String get minutes => translate('minutes');
  String get seconds => translate('seconds');
  String get eventStarted => translate('eventStarted');

  // Share
  String get shareEvent => translate('shareEvent');
  String get eventCopied => translate('eventCopied');

  // Confirmation Dialog
  String get deleteConfirmTitle => translate('deleteConfirmTitle');
  String get deleteConfirmMessage => translate('deleteConfirmMessage');
  String get cancel => translate('cancel');
  String get deleteText => translate('delete');

  // Snackbar
  String get eventAdded => translate('eventAdded');
  String get eventUpdated => translate('eventUpdated');
  String get eventDeleted => translate('eventDeleted');
  String get addedToFavorites => translate('addedToFavorites');
  String get removedFromFavorites => translate('removedFromFavorites');

  // Validation
  String get pleaseFillAllFields => translate('pleaseFillAllFields');
  String get pleaseEnterTitle => translate('pleaseEnterTitle');
  String get pleaseEnterDescription => translate('pleaseEnterDescription');
  String get pleaseSelectDate => translate('pleaseSelectDate');
  String get pleaseSelectTime => translate('pleaseSelectTime');
  String get pleaseSelectLocation => translate('pleaseSelectLocation');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
