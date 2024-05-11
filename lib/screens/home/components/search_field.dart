import 'package:avatar_glow/avatar_glow.dart';
import 'package:e_commerce_app/providers/Theme.dart';
import 'package:e_commerce_app/screens/display_products/display.dart';
import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:e_commerce_app/utilities/searchQuery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_beep/flutter_beep.dart';

import '../../../size_config.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    this.themeProvider,
    Key? key,
  }) : super(key: key);

  final ThemeProvider? themeProvider;

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  // GlobalKey autoCompleteTextFieldKey =
  //     new GlobalKey<AutoCompleteTextFieldState<SearchCompleteField>>();
  String errorMsg = '';
  String status = '';

  final SpeechToText speech = SpeechToText();

  String queryString = '';

  bool _isListening = false;

  List<SearchCompleteField> suggest = [];
  void errorListener(SpeechRecognitionError error) {
    setState(() {
      errorMsg = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    setState(() {
      this.status = '$status';
    });
  }

  Future<void> initSpeechRecognizer() async {
    try {
      var hasSpeech = await speech.initialize(
          onError: errorListener, onStatus: statusListener, debugLogging: true);
      if (hasSpeech) {
        setState(() => _isListening = !_isListening);
        print("Suc");
        speech.listen(
          listenMode: ListenMode.search,
          listenFor: Duration(seconds: 10),
          pauseFor: Duration(seconds: 5),
          localeId: "en_US",
          onResult: ((val) {
            print("HI");
            // if (firstSpeech) {
            print("HIs");

            // firstSpeech = !firstSpeech;
            setState(() {
              SearchQuery.queryStringController.text = val.recognizedWords;
            });

            // }
            // if (!firstSpeech) {
            // }
          }),
        );
        // changeScreen();
        Future.delayed(Duration(seconds: 5)).then((_) async {
          await speech.stop();
          await FlutterBeep.beep();
          // await speech.
          setState(() => _isListening = !_isListening);
          if (SearchQuery.queryStringController.text.isNotEmpty) {
            changeScreen();
          }
        });
      } else {
        print("Error");
        speech.stop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(
                'You do not have given the microphone permissions! \nPlease enable it from settings.'),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          // content: Text(e.message),
          content: Text(e.message!),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Future<List> getPattern(String query) async {
    List newSuggestion = [];
    var url = '$autoCompleteUrl?term=$query';
    List res = await ApiCalls().fetchData(url: url);
    for (var result in res) {
      newSuggestion.add(SearchCompleteField.fromJson(result));
    }
    return newSuggestion;
  }

  void changeScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      DisplayScreen.routeName,
      ModalRoute.withName(HomeScreen.routeName),
    );
  }

  Future<void> getCalls(String query) async {
    if (suggest.length != 0) {
      suggest.clear();
    }
    var url = '$autoCompleteUrl?term=$query';
    List res = await (ApiCalls().fetchData(url: url) as Future<List<dynamic>>);
    for (var result in res) {
      suggest.add(SearchCompleteField.fromJson(result));
    }
  }

  Widget getTypeAheadTextField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        15,
      ),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            style: Theme.of(context).textTheme.headline4,
            textInputAction: TextInputAction.search,
            controller: SearchQuery.queryStringController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenWidth(9)),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "Search product",
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                color: widget.themeProvider!.darkTheme!
                    ? Colors.white
                    : Colors.black,
              ),
              suffixIcon: AvatarGlow(
                animate: _isListening,
                glowColor: Theme.of(context).buttonColor,
                endRadius: 20.0,
                duration: const Duration(milliseconds: 900),
                repeat: true,
                repeatPauseDuration: const Duration(milliseconds: 100),
                child: IconButton(
                  icon: Icon(
                    Icons.mic,
                    color: _isListening
                        ? Theme.of(context).buttonColor
                        : widget.themeProvider!.darkTheme!
                            ? Colors.white
                            : Colors.black,
                  ),
                  onPressed: () async {
                    await initSpeechRecognizer();
                  },
                ),
              ),
            ),
            onSubmitted: (value) {
              changeScreen();
            }),
        // key: autoCompleteTextFieldKey,
        // clearOnSubmit: false,
        suggestionsCallback: (pattern) async {
          if (pattern.length > 2) {
            return getPattern(pattern);
          }
          List list = [];
          return list;
        },
        hideOnEmpty: true,
        onSuggestionSelected: (dynamic item) {
          setState(() => SearchQuery.queryStringController.text = item.label);
          changeScreen();
        },
        itemBuilder: (context, dynamic suggestion) => Container(
          color: Theme.of(context).cardTheme.color,
          padding: EdgeInsets.all(4.0),
          child: ListTile(
            title: Text(
              suggestion.label,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline4!.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.6,
      child: getTypeAheadTextField(),
    );
  }
}

class SearchCompleteField {
  String? label;

  SearchCompleteField(this.label);

  SearchCompleteField.fromJson(dynamic obj) {
    this.label = obj['Label'];
  }
}
