import 'dart:async';

import 'package:breathetoyou/glowcirclebreathe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'configmodel.dart';

class BreatheConfig extends StatefulWidget {
  final ValueNotifier<bool> _configNotifier;

  const BreatheConfig(this._configNotifier, {super.key});

  @override
  State<BreatheConfig> createState() => _BreatheConfigState();
}

enum StatusEnum { inspire, hold, expire }

class _BreatheConfigState extends State<BreatheConfig> {
  static const double DEFAULT_INSPIRED = 4;
  static const double DEFAULT_HOLD = 7;
  static const double DEFAULT_EXPIRED = 8;

  late ValueNotifier<ConfigModel> refreshNotifier;
  late Timer _timer;

  StatusEnum status = StatusEnum.inspire;

  double _inspiracion = DEFAULT_INSPIRED;
  double _retencion = DEFAULT_HOLD;
  double _expiracion = DEFAULT_EXPIRED;

  StatusEnum nextStatus() {
    final nextIndex = (status.index + 1) % StatusEnum.values.length;
    return StatusEnum.values[nextIndex];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    refreshNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    refreshNotifier = ValueNotifier(ConfigModel(
        _inspiracion.round(), _retencion.round(), _expiracion.round()));

    final double tamanyo = MediaQuery.of(context).size.width;

    final GlowCircle circuloRespiracion =
        GlowCircle(refreshNotifier, tamanyo - 170);

    return ValueListenableBuilder<bool>(
        valueListenable: widget._configNotifier,
        builder: (context, value, child) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("", style: Theme.of(context).textTheme.headlineMedium),
                Text(
                    "${AppLocalizations.of(context)!.inspire}(${_inspiracion.round()} ${AppLocalizations.of(context)!.seconds})",
                    style: Theme.of(context).textTheme.headline6),
                Slider(
                  min: 4.0,
                  max: 10.0,
                  value: _inspiracion,
                  divisions: 6,
                  label: '${_inspiracion.round()}',
                  onChanged: (value) {
                    setState(() {
                      _inspiracion = value;
                    });
                  },
                ),
                Text(
                    "${AppLocalizations.of(context)!.hold}(${_retencion.round()} ${AppLocalizations.of(context)!.seconds})",
                    style: Theme.of(context).textTheme.headline6),
                Slider(
                  min: 0.0,
                  max: 10.0,
                  value: _retencion,
                  divisions: 10,
                  label: '${_retencion.round()}',
                  onChanged: (value) {
                    setState(() {
                      _retencion = value;
                    });
                  },
                ),
                Text(
                    "${AppLocalizations.of(context)!.expire}(${_expiracion.round()} ${AppLocalizations.of(context)!.seconds})",
                    style: Theme.of(context).textTheme.headline6),
                Slider(
                  min: 4.0,
                  max: 10.0,
                  value: _expiracion,
                  divisions: 6,
                  label: '${_expiracion.round()}',
                  onChanged: (value) {
                    setState(() {
                      _expiracion = value;
                    });
                  },
                ),
                circuloRespiracion,
                const Text(''),
                Text('Sound Effect by SamuelFrancisJohnson from Pixabay',
                    style: Theme.of(context).textTheme.bodySmall)
              ]);
        });
  }
}
