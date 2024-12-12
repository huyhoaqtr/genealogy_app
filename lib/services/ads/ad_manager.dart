import 'dart:math';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static late InterstitialAd _interstitialAd;
  static bool _isInterstitialAdLoaded = false;

  /// Load Interstitial Ad
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          print('Interstitial Ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('Failed to load Interstitial Ad: $error');
          _isInterstitialAdLoaded = false;
        },
      ),
    );
  }

  /// Show Interstitial Ad
  static void showInterstitialAd({required Function onAdClosed}) {
    // Xác định xác suất (ví dụ: 50% cơ hội hiển thị quảng cáo)
    var random = Random();
    if (random.nextDouble() <= 0.75) {
      // 50% khả năng hiển thị quảng cáo
      if (_isInterstitialAdLoaded) {
        _interstitialAd.show();
        _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            loadInterstitialAd(); // Tải lại quảng cáo sau khi quảng cáo bị đóng
            onAdClosed(); // Gọi callback khi quảng cáo bị đóng
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            loadInterstitialAd(); // Tải lại quảng cáo nếu thất bại khi hiển thị
            onAdClosed(); // Gọi callback khi có lỗi
          },
        );
      } else {
        print('Interstitial ad not loaded yet.');
        onAdClosed(); // Gọi callback ngay cả khi quảng cáo chưa tải xong
      }
    } else {
      print('Ad not shown due to random chance.');
      onAdClosed(); // Gọi callback nếu không hiển thị quảng cáo
    }
  }
}
