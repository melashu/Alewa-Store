// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class Ads {
//   BannerAd _bannerAd;
//   // InterstitialAd? _interstitialAd;

//   BannerAd setAd1() {
//     _bannerAd = BannerAd(
//         adUnitId: "ca-app-pub-4486573175271410/9543698045",
//         // adUnitId: "ca-app-pub-3940256099942544/6300978111",
//         //ca-app-pub-4486573175271410/9543698045
// //paul 12345678 pau-398614
//         listener: BannerAdListener(
//             onAdLoaded: (ad) {},
//             onAdFailedToLoad: (ad, error) {
//               print("Error -located");
//               _bannerAd = null;
//               ad.dispose();
//             }),
//         size: AdSize.banner,
//         request: const AdRequest());
//     _bannerAd.load();
//     return _bannerAd;
//   }

//   BannerAd setAd2() {
//     _bannerAd = BannerAd(
//         adUnitId: "ca-app-pub-4486573175271410/3092155555",
//         listener: BannerAdListener(
//             onAdLoaded: (ad) {},
//             onAdFailedToLoad: (ad, error) {
//               _bannerAd = null;
//               ad.dispose();
//             }),
//         size: AdSize.banner,
//         request: const AdRequest());
//     _bannerAd.load();
//     return _bannerAd;
//   }

//   BannerAd setAd3() {
//     _bannerAd = BannerAd(
//         adUnitId: "ca-app-pub-4486573175271410/4952032131",
//         listener: BannerAdListener(
//             onAdLoaded: (ad) {},
//             onAdFailedToLoad: (ad, error) {
//               _bannerAd = null;
//               ad.dispose();
//             }),
//         size: AdSize.banner,
//         request: const AdRequest());
//     _bannerAd.load();
//     return _bannerAd;
//   }

//   BannerAd setAd4() {
//     _bannerAd = BannerAd(
//         adUnitId: "ca-app-pub-4486573175271410/9821215432",
//         listener: BannerAdListener(
//             onAdLoaded: (ad) {},
//             onAdFailedToLoad: (ad, error) {
//               _bannerAd = null;
//               ad.dispose();
//             }),
//         size: AdSize.banner,
//         request: const AdRequest());
//     _bannerAd.load();
//     return _bannerAd;
//   }
//   // void initInterstitalAdds() {
//   //   InterstitialAd.load(
//   //       adUnitId: 'ca-app-pub-3940256099942544/1033173712',
//   //       request: const AdRequest(),
//   //       adLoadCallback: InterstitialAdLoadCallback(onAdFailedToLoad: (err) {
//   //         _interstitialAd = null;
//   //       }, onAdLoaded: (InterstitialAd ad) {
//   //         _interstitialAd = ad;
//   //       }));

//   //   _interstitialAd!.show();
//   // }

//   // void showIntAds() {
//   //   // print("=================================================val==$_interstitialAd");
//   //   // _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//   //   //   onAdShowedFullScreenContent: (InterstitialAd ad) =>
//   //   //       print('ad onAdShowedFullScreenContent.'),
//   //   //   onAdDismissedFullScreenContent: (InterstitialAd ad) {
//   //   //     print('$ad onAdDismissedFullScreenContent.');
//   //   //     ad.dispose();
//   //   //     initInterstitalAdds();
//   //   //   },
//   //   //   onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//   //   //     print('$ad onAdFailedToShowFullScreenContent: $error');
//   //   //     ad.dispose();
//   //   //     initInterstitalAdds();
//   //   //   },
//   //   // );
//   //   _interstitialAd!.show();
//   // }
// }
