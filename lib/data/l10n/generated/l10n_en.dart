// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get host => 'Host';

  @override
  String get snippets => 'Snippets';

  @override
  String get settings => 'Settings';

  @override
  String get newHost => 'New Host';

  @override
  String get name => 'Name';

  @override
  String get address => 'Address';

  @override
  String get addTag => 'Add Tag';

  @override
  String get comment => 'Comment';

  @override
  String get port => 'Port';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get setAKey => 'Set a key';

  @override
  String get setAnIdentify => 'Set an identify';

  @override
  String get jumpServer => 'Jump Server';

  @override
  String get defaultText => 'Default';

  @override
  String get group => 'Group';

  @override
  String get allHosts => 'All Hosts';

  @override
  String get search => 'Search';

  @override
  String get hostList => 'Host List';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get saveSuccess => 'Save Success';

  @override
  String get saveFailed => 'Save Failed';

  @override
  String get nameAndPrivateKeyCannotBeEmpty => 'Name and private key cannot be empty';

  @override
  String get selectPrivateKey => 'Select private key';

  @override
  String get privateKeyText => 'Private key text';

  @override
  String pathIsNotExists(Object path) {
    return '$path is not exists';
  }

  @override
  String get importFromFile => 'Import from file';

  @override
  String get selectFromExistPK => 'Select from exist';

  @override
  String get createNewPK => 'Create new';

  @override
  String get fileSizeIsTooLarge => 'File size is too large';

  @override
  String get usePrivateKey => 'Use private key';

  @override
  String get noHosts => 'No hosts';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get nameAndAddressCannotBeEmpty => 'Name and address cannot be empty';
}
