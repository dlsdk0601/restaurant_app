import 'dart:io';

import '../../ex/config.dart';

const ACCESS_TOKEN_KEY = "ACCESS_TOKEN";
const REFRESH_TOKEN_KEY = "REFRESH_TOKEN";

final ip = Platform.isIOS ? config.simulatorIp : config.emulatorIp;
