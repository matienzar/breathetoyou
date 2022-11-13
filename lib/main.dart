import 'package:audioplayers/audioplayers.dart';
import 'package:breathetoyou/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const BreatheApp());
}

class BreatheApp extends StatelessWidget {
  const BreatheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: "BreatheToYou",
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const BreatheHomePage(), //AppLocalizations.of(context)!.helloWorld
    );
  }
}

class BreatheHomePage extends StatefulWidget {
  const BreatheHomePage({super.key});

  @override
  State<BreatheHomePage> createState() => _BreatheHomePageState();
}

class _BreatheHomePageState extends State<BreatheHomePage> {
  ValueNotifier<bool> refreshNotifier = ValueNotifier(true);
  final player = AudioPlayer();
  bool isPlaying = true;
  late String playtooltip = AppLocalizations.of(context)!.stop;
  IconData iconPlay = Icons.volume_off;

  void playsound() async {
    player.setReleaseMode(ReleaseMode.loop);
    player.play(AssetSource('audio/meditation.mp3'));
  }

  void _play() {
    setState(() {
      debugPrint("_play");
      if (isPlaying) {
        debugPrint("_play: stop");
        player.pause();
        playtooltip = AppLocalizations.of(context)!.play;
        iconPlay = Icons.volume_up;
      } else {
        debugPrint("_play: resume");
        player.resume();
        playtooltip = AppLocalizations.of(context)!.stop;
        iconPlay = Icons.volume_off;
      }

      isPlaying = !isPlaying;

    });

  }

  @override
  void dispose() {
    refreshNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    playsound();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(AppLocalizations.of(context)!.title),
      ),
      body: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[BreatheConfig(refreshNotifier)],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _play,
        tooltip: playtooltip,
        child: Icon(iconPlay),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
