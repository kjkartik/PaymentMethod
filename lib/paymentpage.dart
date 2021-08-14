import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  var paymentController = TextEditingController();

  @override
  static final String tokenizationKey = 'sandbox_8hxpnkht_kzdtzv2btm4p7s5j';

  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                controller: paymentController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  // border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 25.0),
                  prefixIcon: Icon(
                    Icons.payment,
                    color: Colors.green,
                  ),
                  hintText: 'Enter Payment',
                  //  hintStyle: kHintTExtStyle,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              var request = BraintreeDropInRequest(
                tokenizationKey: tokenizationKey,
                collectDeviceData: true,
                googlePaymentRequest: BraintreeGooglePaymentRequest(
                  totalPrice: '4',
                  currencyCode: '1',
                  billingAddressRequired: false,
                ),
                paypalRequest: BraintreePayPalRequest(
                  amount: '4.20',
                  displayName: 'company',
                ),
                applePayRequest: BraintreeApplePayRequest(
                  amount: 12,
                  appleMerchantID: "2",
                  countryCode: "4",
                  currencyCode: "6",
                  displayName: 'company2',
                ),
                cardEnabled: true,
              );
              final result = await BraintreeDropIn.start(request);
              if (result != null) {
                showNonce(result.paymentMethodNonce);
              }
              // var request = BraintreeDropInRequest(googlePaymentRequest: )
            },
            child: Text(
              'Pay Now',
              style: TextStyle(fontSize: 23, color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
