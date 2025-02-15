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
}
