//
// Generated file. Do not edit.
//

// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_keyboard_visibility_web/flutter_keyboard_visibility_web.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:speech_to_text/speech_to_text_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  FlutterKeyboardVisibilityPlugin.registerWith(registrar);
  ImagePickerPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  SpeechToTextPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
