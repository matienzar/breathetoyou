import 'package:breathetoyou/configmodel.dart';
import 'package:flutter/material.dart';

class GlowCircle extends StatefulWidget {
  final double tamanyo;

  final ValueNotifier<ConfigModel> _configNotifier;

  const GlowCircle(this._configNotifier, this.tamanyo, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _GlowCircleState();
  }
}

class _GlowCircleState extends State<GlowCircle>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //use "with SingleThickerProviderStateMixin" at last of class declaration
  //where you have to pass "vsync" argument, add this

  late Animation<double> animation; //animation variable for circle 1
  late AnimationController
  animationcontroller; //animation controller variable circle 1

  late int secondsInspire = 3;
  late int secondsExpire = 3;
  late int secondsHold = 1;

  Color color1 = Colors.blueAccent;
  Color color2 = Colors.indigo;

  late Duration _holdDuration;
  bool isStarted = false;

  BoxDecoration boxDecoration = const BoxDecoration(
      shape: BoxShape.circle, //making box to circle
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.blueAccent,
          Colors.indigo,
        ],
      ) //background of container
  );

  @override
  void initState() {
    super.initState();

    debugPrint("INIT STATE DEL CIRCULO");
    animationcontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _getSecondsInspire()),
      reverseDuration: Duration(seconds: _getSecondsExpire()),
    );

    animation = Tween<double>(begin: 0, end: widget.tamanyo)
        .animate(animationcontroller)
      ..addListener(() {
        setState(() {});
        //set animation listener and set state to update UI on every animation value change
      })
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(_holdDuration);
          color1 = Colors.blueAccent;
          color2 = Colors.orange;
          animationcontroller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          color1 = Colors.blueAccent;
          color2 = Colors.indigo;
          animationcontroller.forward();
        }
      });

    // animationcontroller.forward();
  }

  @override
  void dispose() {
    animationcontroller.dispose(); //destroy animation to free memory on last
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _refreshConfig() {
    if (animationcontroller.duration?.inSeconds != secondsInspire) {
      debugPrint("Refresh del config inspire...$secondsInspire");
      animationcontroller.duration = Duration(seconds: secondsInspire);
    }
    if (animationcontroller.reverseDuration?.inSeconds != secondsExpire) {
      debugPrint("Refresh del config expire...$secondsExpire");
      animationcontroller.reverseDuration = Duration(seconds: secondsExpire);
    }
    if (_holdDuration.inSeconds != secondsHold) {
      debugPrint("Refresh del config hold...$secondsHold");
      _holdDuration = Duration(seconds: secondsHold);
    }
  }

  int _getSecondsInspire() {
    return secondsInspire;
  }

  int _getSecondsExpire() {
    return secondsExpire;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _holdDuration = Duration(seconds: secondsHold);
    final double tamanyo = MediaQuery
        .of(context)
        .size
        .width;

    return ValueListenableBuilder<ConfigModel>(
        valueListenable: widget._configNotifier,
        builder: (context, value, child) {
          secondsInspire = value.secondsInspire;
          secondsExpire = value.secondsExpire;
          secondsHold = value.secondsHold;

          _refreshConfig();

          return GestureDetector(
              onTap: () {
                setState(() {
                  // Toggle light when tapped.
                  debugPrint("ON TAP");
                  if (isStarted) {
                    debugPrint("ON TAP - STOP");
                    animationcontroller.stop();
                  } else {
                    debugPrint("ON TAP - CONTINUE");
                    animationcontroller.forward();
                  }
                  isStarted = !isStarted;
                });
              },
              onLongPress: (){
                setState(() {
                  // Toggle light when tapped.
                  debugPrint("ON LONG TAP");
                  isStarted = false;
                  animationcontroller.reset();
                  animationcontroller.stop();
                });
              },
              child: SizedBox(
                  width: tamanyo - 170,
                  height: tamanyo - 170,
                  child: Stack(children: <Widget>[
                    Positioned(
                      child: Container(
                          alignment: Alignment.center,
                          height: tamanyo - 170,
                          width: tamanyo - 170,
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            shape: BoxShape.circle,
                          )),
                    ),
                    Container(
                      alignment:Alignment.center,
                      height: tamanyo - 170,
                      width: tamanyo - 170,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, //making box to circle
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                color1,
                                color2,
                              ],
                            ) //background of container
                        ),
                        height: animation.value,
                        //value from animation controller
                        width:
                        animation.value, //value from animation controller
                      ),
                    )
                  ])));
        });
  }
}
