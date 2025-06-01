import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../helper/ads_helper.dart';

class AdsService {
  RewardedAd? rewardedAds;
  void loadRewardedAds() {
    if (rewardedAds != null) {
      rewardedAds!.dispose();
      rewardedAds = null; // <- thêm dòng này
    }

    print("Loading ads");
    RewardedAd.load(
      adUnitId: AdsHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              rewardedAds = null;
              loadRewardedAds();
            },
          );
          rewardedAds = ad;
          print('Rewarded ad loaded.');
        },
        onAdFailedToLoad: (error) {
          print('Failed to load rewarded ad: $error');
          Future.delayed(const Duration(seconds: 10), loadRewardedAds);
        },
      ),
    );
  }
  void initAds() {
    loadRewardedAds();
  }
}
