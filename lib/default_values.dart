import 'package:cloud_firestore/cloud_firestore.dart';

const String defaultMerchantImageUrl =
    'https://firebasestorage.googleapis.com/v0/b/towndash-dev.appspot.com/o/Default_Images%2FLogo_Primary%2C%20Merchant_Default.png?alt=media&token=cd259a04-8a06-4c5e-aa39-102d14ad2044';
DateTime defaultDateTime = DateTime.fromMillisecondsSinceEpoch(0);
Timestamp defaultTimeStamp = Timestamp.fromDate(defaultDateTime);