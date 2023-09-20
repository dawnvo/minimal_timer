import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class DisplayOnAppExitDialog extends StatefulWidget {
  const DisplayOnAppExitDialog();

  @override
  DisplayOnAppExitDialogState createState() => DisplayOnAppExitDialogState();
}

class DisplayOnAppExitDialogState extends State<DisplayOnAppExitDialog> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  final String _adUnitId = kReleaseMode
      // Release
      ? "ca-app-pub-3368479970508752/2376612907"
      // Develop
      : "ca-app-pub-3940256099942544/2247696110";

  // final String _adUnitId = "ca-app-pub-3940256099942544/2247696110";

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  void _loadAd() {
    setState(() {
      _nativeAdIsLoaded = false;
    });

    final nativeTextStyle = NativeTemplateTextStyle(
      textColor: Colors.black,
    );

    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        primaryTextStyle: nativeTextStyle,
        secondaryTextStyle: nativeTextStyle,
        tertiaryTextStyle: nativeTextStyle,
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    const constraints = BoxConstraints(
      minWidth: 320,
      minHeight: 320,
      maxWidth: 400,
      maxHeight: 400,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //NativeAd
        Stack(children: [
          Container(constraints: constraints),
          if (_nativeAdIsLoaded && _nativeAd != null)
            ConstrainedBox(
              constraints: constraints,
              child: AdWidget(ad: _nativeAd!),
            ),
        ]),

        //AlertDialog
        CupertinoAlertDialog(
          title: const Text("앱을 종료하시겠습니까?"),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("취소"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("종료"),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ],
    );
  }
}
