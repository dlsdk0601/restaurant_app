import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  final String simulatorIp = dotenv.get("SIMULATOR_IP", fallback: "");

  final String emulatorIp = dotenv.get("EMULATOR_IP", fallback: "");
}

final config = Config();
