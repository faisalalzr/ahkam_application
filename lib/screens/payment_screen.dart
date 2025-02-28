import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_functions/cloud_functions.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<void> _pay() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createPaymentIntent');
      final response = await callable.call({'amount': 1000}); // $10.00
      String clientSecret = response.data['clientSecret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Ahkam Legal Services',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Payment Successful")));
    } catch (e) {
      print("Payment error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: _pay,
          child: Text("Pay for Consultation"),
        ),
      ),
    );
  }
}
