import 'package:cloud_functions/cloud_functions.dart';
import 'package:cortado_admin_ios/src/data/custom_account.dart';

class StripeService {
  StripeService(this.live);

  final bool live;

  final HttpsCallable createCustomAccountCallable =
      CloudFunctions.instance.getHttpsCallable(
    functionName: 'createCustomAccount',
  );

  final HttpsCallable createCustomAccountLinkCallable =
      CloudFunctions.instance.getHttpsCallable(
    functionName: 'createCustomAccountLink',
  );
  final HttpsCallable createCustomAccountUpdateLinkCallable =
      CloudFunctions.instance.getHttpsCallable(
    functionName: 'createCustomAccountUpdateLink',
  );

  final HttpsCallable retrieveCustomAccountCallable =
      CloudFunctions.instance.getHttpsCallable(
    functionName: 'retrieveCustomAccount',
  );

  createCustomAccountUpdateLink(String account) async {
    final data = <String, dynamic>{
      'account': account,
      'refresh_url': 'http://localhost:5000/#/payment/reauth',
      'return_url': 'http://localhost:5000/#/payment/return',
      'live': live
    };

    HttpsCallableResult response =
        await createCustomAccountUpdateLinkCallable.call(data);

    return response.data;
  }

  createCustomAccount(
      String businessEmail,
      String accountHolderName,
      String accountHolderType,
      String routingNumber,
      String accountNumber) async {
    final data = <String, dynamic>{
      'email': businessEmail,
      'account_holder_name': accountHolderName,
      'account_holder_type': accountHolderType,
      'routing_number': routingNumber,
      'account_number': accountNumber,
      'live': live
    };

    HttpsCallableResult response = await createCustomAccountCallable.call(data);
    return response.data["id"];
  }

  createCustomAccountLink(String account) async {
    final data = <String, dynamic>{
      'account': account,
      'refresh_url': 'http://localhost:5000/#/payment/reauth',
      'return_url': 'http://localhost:5000/#/payment/return',
      'live': live
    };

    HttpsCallableResult response =
        await createCustomAccountLinkCallable.call(data);

    return response.data;
  }

  retrieveCustomAccount(String account) async {
    final data = <dynamic, dynamic>{'account': account, 'live': live};
    HttpsCallableResult response =
        await retrieveCustomAccountCallable.call(data);

    if (response.data != null) {
      return CustomAccount.fromJson(response.data);
    }
    return null;
  }
}
