import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
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
  var loading;
  final paymentUrl = "yourcarlocator.ouctus-platform.com/Api/AppService";

  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
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
              try {
                var request = BraintreeDropInRequest(
                  tokenizationKey: 'sandbox_tvgvxb38_wz53xwgqk5sb42gm',
                  collectDeviceData: true,
                  googlePaymentRequest: BraintreeGooglePaymentRequest(
                    totalPrice: '4.20',
                    currencyCode: 'USD',
                    billingAddressRequired: false,
                  ),
                    paypalRequest: BraintreePayPalRequest(
                    amount: '4.20',
                    displayName: 'Example company',
                  ),
                  cardEnabled: true,
                );

                BraintreeDropInResult? result =
                await BraintreeDropIn.start(request);
                if (result != null) {
                  print("description" + result.paymentMethodNonce.description);
                  print("nonce" + result.paymentMethodNonce.nonce);
                  var body = ({
                    "orderId": '200',
                    "userId": 'userid',
                    "nonce": result.paymentMethodNonce.nonce,
                    "deviceData": result.deviceData
                  });
                  http.Response response =
                  await http.post(Uri.parse(paymentUrl), body: body);
                  final payresult = jsonDecode(response.body);

                  print(payresult);
                  if (payresult["success"] == true) {
                    setState(() {
                      loading = true;
                    });
                    print(payresult["message"]);
                    print(payresult["data"]);
                    print("payment done");
                  } else {
                    setState(() {
                      // loading=true;
                    });
                    print("fail");
                    print(payresult["message"]);
                    print(payresult["data"]);
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>PayPopUp1()));
                  }
                }
              } catch (e) {
                print(e);
                print('error');
              }
              ;
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
