// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get host => '主机';

  @override
  String get snippets => '代码片段';

  @override
  String get settings => '设置';

  @override
  String get newHost => '新建主机';

  @override
  String get name => '名称';

  @override
  String get address => '地址';

  @override
  String get addTag => '添加标签';

  @override
  String get comment => '备注';

  @override
  String get port => '端口';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get setAKey => '设置密钥';

  @override
  String get setAnIdentify => '设置标识';

  @override
  String get jumpServer => '跳板机';

  @override
  String get defaultText => '默认';

  @override
  String get group => '分组';

  @override
  String get allHosts => '所有主机';

  @override
  String get search => '搜索';

  @override
  String get hostList => '主机列表';

  @override
  String get basicInfo => '基本信息';

  @override
  String get saveSuccess => '保存成功';

  @override
  String get saveFailed => '保存失败';

  @override
  String get nameAndPrivateKeyCannotBeEmpty => '名称和私钥不能为空';

  @override
  String get selectPrivateKey => '选择私钥';

  @override
  String get privateKeyText => '私钥文本';

  @override
  String pathIsNotExists(Object path) {
    return '$path 不存在';
  }

  @override
  String get importFromFile => '从文件导入';

  @override
  String get selectFromExistPK => '从已有私钥中选择';

  @override
  String get createNewPK => '新建私钥';

  @override
  String get fileSizeIsTooLarge => '文件大小过大';

  @override
  String get usePrivateKey => '使用私钥';

  @override
  String get noHosts => '没有主机';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get nameAndAddressCannotBeEmpty => '名称和地址不能为空';

  @override
  String fileUploadFailed(Object msg) {
    return '文件上传失败：$msg';
  }

  @override
  String get fileUploadSuccess => '文件上传成功';

  @override
  String fileDownloadFailed(Object msg) {
    return '文件下载失败：$msg';
  }

  @override
  String get fileDownloadSuccess => '文件下载成功';

  @override
  String get configAlreadyPasteToClipboard => '配置已经复制到剪贴板';

  @override
  String configPasteToClipboardFailed(Object msg) {
    return '配置复制到剪贴板失败：$msg';
  }

  @override
  String get syncWordsNotSet => '同步短语未设置';

  @override
  String get syncWordsError => '同步短语错误';

  @override
  String get configAlreadyRestore => '配置已经恢复';

  @override
  String configRestoreFailed(Object msg) {
    return '配置恢复失败：$msg';
  }

  @override
  String get manualUpload => '手动上传';

  @override
  String get manualPull => '手动拉取';

  @override
  String get preferences => '偏好设置';

  @override
  String get appearance => '外观';

  @override
  String get privateKeyManagement => '私钥管理';

  @override
  String get syncManagement => '同步管理';

  @override
  String get about => '关于';

  @override
  String get syncWords => '同步短语';

  @override
  String get syncWordsTip => '您的同步短语可以保护您的数据，当您在新设备上同步时，您可以使用同步短语来解密您的数据。将其保存在安全的地方。在同步时，您的数据将被加密并上传到对端，但此同步短语将不会上传。点击显示：';

  @override
  String get selectRemoteService => '选择远程服务';

  @override
  String get selectRemoteServiceTip => '从这里开始设置，你想连接到哪个服务？将会支持S3、WebDAV、OneDrive等服务。';

  @override
  String get remoteService => '远程服务';

  @override
  String get s3OrCompatible => 'S3 (或兼容S3的服务)';
}
