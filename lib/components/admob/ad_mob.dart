import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo_share/components/admob/ad_helper.dart';

class AdMob {
  BannerAd? _bannerAd;

  AdMob() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );
  }

  void load() {
    _bannerAd!.load();
  }

  void dispose() {
    _bannerAd!.dispose();
  }

  Widget getAdBanner() {
    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  double getAdBannerHeight() {
    return _bannerAd!.size.height.toDouble();
  }
}

class AdMobNotifier extends ChangeNotifier {
  final AdMob _adMob = AdMob();

  AdMobNotifier() {
    _adMob.load();
  }

  @override
  void dispose() {
    _adMob.dispose();
    super.dispose();
  }

  Widget getAdBanner() {
    return _adMob.getAdBanner();
  }

  double getAdBannerHeight() {
    return _adMob.getAdBannerHeight();
  }
}
