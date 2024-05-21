import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo_share/components/ad_mob.dart';

class AdMobBanner extends StatefulWidget {
  AdMobBanner({Key? key}) : super(key: key);

  @override
  _AdMobBannerState createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {

  final AdMob _adMob = AdMob();

  @override
  void initState() {
    super.initState();
    _adMob.load();
  }

  //画面消失時動作
  @override
  void dispose() {
    super.dispose();
    _adMob.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AdSize.getAnchoredAdaptiveBannerAdSize(
          Orientation.portrait, MediaQuery.of(context).size.width.truncate()),
      builder: (BuildContext context,
          AsyncSnapshot<AnchoredAdaptiveBannerAdSize?> snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: double.infinity,
            child: _adMob.getAdBanner(),
          );
        } else {
          return Container(
            height: _adMob.getAdBannerHeight(),
            color: Colors.white,
          );
        }
      },
    );
  }
}
