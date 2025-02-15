import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @snippets.
  ///
  /// In en, this message translates to:
  /// **'Snippets'**
  String get snippets;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @newHost.
  ///
  /// In en, this message translates to:
  /// **'New Host'**
  String get newHost;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add Tag'**
  String get addTag;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @setAKey.
  ///
  /// In en, this message translates to:
  /// **'Set a key'**
  String get setAKey;

  /// No description provided for @setAnIdentify.
  ///
  /// In en, this message translates to:
  /// **'Set an identify'**
  String get setAnIdentify;

  /// No description provided for @jumpServer.
  ///
  /// In en, this message translates to:
  /// **'Jump Server'**
  String get jumpServer;

  /// No description provided for @defaultText.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultText;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @allHosts.
  ///
  /// In en, this message translates to:
  /// **'All Hosts'**
  String get allHosts;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @hostList.
  ///
  /// In en, this message translates to:
  /// **'Host List'**
  String get hostList;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfo;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Save Success'**
  String get saveSuccess;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save Failed'**
  String get saveFailed;

  /// No description provided for @nameAndPrivateKeyCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name and private key cannot be empty'**
  String get nameAndPrivateKeyCannotBeEmpty;

  /// No description provided for @selectPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Select private key'**
  String get selectPrivateKey;

  /// No description provided for @privateKeyText.
  ///
  /// In en, this message translates to:
  /// **'Private key text'**
  String get privateKeyText;

  /// No description provided for @pathIsNotExists.
  ///
  /// In en, this message translates to:
  /// **'{path} is not exists'**
  String pathIsNotExists(Object path);

  /// No description provided for @importFromFile.
  ///
  /// In en, this message translates to:
  /// **'Import from file'**
  String get importFromFile;

  /// No description provided for @selectFromExistPK.
  ///
  /// In en, this message translates to:
  /// **'Select from exist'**
  String get selectFromExistPK;

  /// No description provided for @createNewPK.
  ///
  /// In en, this message translates to:
  /// **'Create new'**
  String get createNewPK;

  /// No description provided for @fileSizeIsTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File size is too large'**
  String get fileSizeIsTooLarge;

  /// No description provided for @usePrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Use private key'**
  String get usePrivateKey;

  /// No description provided for @noHosts.
  ///
  /// In en, this message translates to:
  /// **'No hosts'**
  String get noHosts;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @nameAndAddressCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name and address cannot be empty'**
  String get nameAndAddressCannotBeEmpty;

  /// No description provided for @fileUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'File upload failed: {msg}'**
  String fileUploadFailed(Object msg);

  /// No description provided for @fileUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'File upload success'**
  String get fileUploadSuccess;

  /// No description provided for @fileDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'File download failed: {msg}'**
  String fileDownloadFailed(Object msg);

  /// No description provided for @fileDownloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'File download success'**
  String get fileDownloadSuccess;

  /// No description provided for @configAlreadyPasteToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Config already paste to clipboard'**
  String get configAlreadyPasteToClipboard;

  /// No description provided for @configPasteToClipboardFailed.
  ///
  /// In en, this message translates to:
  /// **'Config paste to clipboard failed: {msg}'**
  String configPasteToClipboardFailed(Object msg);

  /// No description provided for @syncWordsNotSet.
  ///
  /// In en, this message translates to:
  /// **'Sync words not set'**
  String get syncWordsNotSet;

  /// No description provided for @syncWordsError.
  ///
  /// In en, this message translates to:
  /// **'Sync words error'**
  String get syncWordsError;

  /// No description provided for @configAlreadyRestore.
  ///
  /// In en, this message translates to:
  /// **'Config already restore'**
  String get configAlreadyRestore;

  /// No description provided for @configRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Config restore failed: {msg}'**
  String configRestoreFailed(Object msg);

  /// No description provided for @manualUpload.
  ///
  /// In en, this message translates to:
  /// **'Manual upload'**
  String get manualUpload;

  /// No description provided for @manualPull.
  ///
  /// In en, this message translates to:
  /// **'Manual pull'**
  String get manualPull;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @privateKeyManagement.
  ///
  /// In en, this message translates to:
  /// **'Private key management'**
  String get privateKeyManagement;

  /// No description provided for @syncManagement.
  ///
  /// In en, this message translates to:
  /// **'Sync management'**
  String get syncManagement;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @syncWords.
  ///
  /// In en, this message translates to:
  /// **'Sync words'**
  String get syncWords;

  /// No description provided for @syncWordsTip.
  ///
  /// In en, this message translates to:
  /// **'Your sync words can protect your data, when you sync on a new device, you can use the sync words to decrypt your data. Keep it in a safe place. During sync, your data will be encrypted and uploaded to the peer, but this sync words will not be uploaded. Click to show:'**
  String get syncWordsTip;

  /// No description provided for @selectRemoteService.
  ///
  /// In en, this message translates to:
  /// **'Select remote service'**
  String get selectRemoteService;

  /// No description provided for @selectRemoteServiceTip.
  ///
  /// In en, this message translates to:
  /// **'Start here to set up which service you want to connect to? Will support services such as S3, WebDAV, OneDrive, etc.'**
  String get selectRemoteServiceTip;

  /// No description provided for @remoteService.
  ///
  /// In en, this message translates to:
  /// **'Remote service'**
  String get remoteService;

  /// No description provided for @s3OrCompatible.
  ///
  /// In en, this message translates to:
  /// **'S3 (or compatible S3 service)'**
  String get s3OrCompatible;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
