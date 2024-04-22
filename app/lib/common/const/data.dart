import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../ex/config.dart';

const ACCESS_TOKEN_KEY = "ACCESS_TOKEN";
const REFRESH_TOKEN_KEY = "REFRESH_TOKEN";

const storage = FlutterSecureStorage();

final ip = Platform.isIOS ? config.simulatorIp : config.emulatorIp;
