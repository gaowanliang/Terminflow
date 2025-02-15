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

  @override
  String fileUploadFailed(Object msg) {
    return 'File upload failed: $msg';
  }

  @override
  String get fileUploadSuccess => 'File upload success';

  @override
  String fileDownloadFailed(Object msg) {
    return 'File download failed: $msg';
  }

  @override
  String get fileDownloadSuccess => 'File download success';

  @override
  String get configAlreadyPasteToClipboard => 'Config already paste to clipboard';

  @override
  String configPasteToClipboardFailed(Object msg) {
    return 'Config paste to clipboard failed: $msg';
  }

  @override
  String get syncWordsNotSet => 'Sync words not set';

  @override
  String get syncWordsError => 'Sync words error';

  @override
  String get configAlreadyRestore => 'Config already restore';

  @override
  String configRestoreFailed(Object msg) {
    return 'Config restore failed: $msg';
  }

  @override
  String get manualUpload => 'Manual upload';

  @override
  String get manualPull => 'Manual pull';

  @override
  String get preferences => 'Preferences';

  @override
  String get appearance => 'Appearance';

  @override
  String get privateKeyManagement => 'Private key management';

  @override
  String get syncManagement => 'Sync management';

  @override
  String get about => 'About';

  @override
  String get syncWords => 'Sync words';

  @override
  String get syncWordsTip => 'Your sync words can protect your data, when you sync on a new device, you can use the sync words to decrypt your data. Keep it in a safe place. During sync, your data will be encrypted and uploaded to the peer, but this sync words will not be uploaded. Click to show:';

  @override
  String get selectRemoteService => 'Select remote service';

  @override
  String get selectRemoteServiceTip => 'Start here to set up which service you want to connect to? Will support services such as S3, WebDAV, OneDrive, etc.';

  @override
  String get remoteService => 'Remote service';

  @override
  String get s3OrCompatible => 'S3 (or compatible S3 service)';
}
