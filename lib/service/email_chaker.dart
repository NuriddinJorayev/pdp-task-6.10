import 'package:email_auth/email_auth.dart';

class EmailChaker {
  static Future<bool> exist(String email_url) async {
    var email = EmailAuth(sessionName: "Your code");
    var res = await email.sendOtp(recipientMail: email_url);
    return res;
  }

  static bool chack(String email, String code) {
    try{
      var res = EmailAuth(sessionName: 'Your code')
        .validateOtp(recipientMail: email, userOtp: code);
        return res;
    }catch(e){
      return false;
    }    
  }
}
