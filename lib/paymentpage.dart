import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:paymentmethod/paymentpage.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final paymentUrl = "yourcarlocator.ouctus-platform.com/Api/AppService";
  static final String tokenizationKey = 'sandbox_8hxpnkht_kzdtzv2btm4p7s5j';

   var paymentController = TextEditingController();

  void showNonce(BraintreePaymentMethodNonce nonce) {
    print('enter');
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Payment Method'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
              ),),
            TextButton(
              onPressed: () async {
                var request = BraintreeDropInRequest(
                  tokenizationKey: tokenizationKey,
                  collectDeviceData: true,
                  googlePaymentRequest: BraintreeGooglePaymentRequest(
                    cardnumber: "4111111111111111",
                    cvc: '123',
                    expirationYear: '22',
                    expirationMonth: '12',
                    totalPrice: '4',
                    currencyCode: 'USD',
                    billingAddressRequired: false,
                  ),
                  paypalRequest: BraintreePayPalRequest(
                    amount: '4.20',
                    displayName: 'Example company',
                  ),
                  cardEnabled: true,
                );
                final result = await BraintreeDropIn.start(request);
                if (result != null) {
                  showNonce(result.paymentMethodNonce);
                  var body = ({
                    "ordeid": '190',
                    "userid" : '3',

                    "nonce": "tokencc_bh_rfx992_qp849n_8wss5t_t6r9w8_pry",
                    "deviceData": "correlation_id\":\"5fff9719179e4f06979c41fcff38c576\"}",
                  });
                  final http.Response response = await http.post(Uri.parse(paymentUrl), body: body);
                  final payresult = jsonDecode(response.body);


                  print(payresult);
                  if (payresult["success"] == true) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PaymentMethod()));
                    setState(() {
                      var  loading= true;
                    });
                    print(payresult["message"]);
                    print(payresult["data"]);
                    print("payment done");
                  } else {
                    setState(() {
                      var loading = true;
                    });
                    print("fail");
                    print(payresult["message"]);
                    print(payresult["data"]);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PaymentMethod()));
                  }
                }
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
              ),),
          ],
        ),
      ),
    );

  }
}
