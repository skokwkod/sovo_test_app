import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService{

  static String? get rewardedAdUnitId {

    // MobileAds.instance.updateRequestConfiguration(
    //     RequestConfiguration(testDeviceIds: ['40615080C49BDD7EAC4980F36A4B55A3']));
      if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/1712485313';
      } else if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/5224354911';
      }
      return null;
    }
    
    

}