
import 'package:cloud_firestore/cloud_firestore.dart';


enum AccountType {
  free, premium
}

class FuelerUser {

  String userUid;
  String email;
  AccountType? accountType;

  FuelerUser({required this.userUid, required this.email, this.accountType = AccountType.free});


  factory FuelerUser.fromFirestore(DocumentSnapshot<Map<String,dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return FuelerUser(
      userUid: data?["userUid"], 
      email: data?["email"],
      accountType: data?["isPremium"] == true ? AccountType.premium : AccountType.free,
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      "userUid": userUid,
      "email": email,
      "isPremium": accountType == AccountType.free ? false: true,
    };
  }


  

}