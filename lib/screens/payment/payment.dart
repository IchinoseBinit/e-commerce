// import 'package:credit_card/credit_card_form.dart';
// import 'package:credit_card/credit_card_model.dart';
// import 'package:credit_card/credit_card_widget.dart';
// import 'package:e_commerce_app/components/default_button.dart';
// import 'package:e_commerce_app/screens/invoice/invoice.dart';
// import 'package:e_commerce_app/size_config.dart';
// import 'package:flutter/material.dart';

// class PaymentScreen extends StatefulWidget {
//   static const routeName = '/payment';

//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;

//   String esewaId = '';
//   String username = '';

//   bool _isCard = true;

//   bool validate() {
//     if (_isCard) {
//       if (cardNumber.length != 16 &&
//           expiryDate.length != 5 &&
//           cardHolderName.isEmpty &&
//           cvvCode.length < 3) {
//         return false;
//       } else {
//         return true;
//       }
//     } else {
//       if (esewaId.isEmpty || username.isEmpty) {
//         return false;
//       }
//       return true;
//     }
//   }

//   checkValidation() {
//     if (validate()) {
//       Navigator.of(context).pushNamedAndRemoveUntil(
//           InvoiceScreen.routeName, (Route<dynamic> route) => false);

//       // Navigator
//     } else {
//       _scaffoldKey.currentState.showSnackBar(
//         SnackBar(
//           content:
//               Text("Please enter your ${_isCard ? "card" : "E-sewa"} details"),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: Text(
//           "Payment",
//           style: Theme.of(context).textTheme.headline4,
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(
//               top: getProportionateScreenHeight(15.0),
//             ),
//             child: Text(
//               "Pay by ${_isCard ? "Esewa" : "Card"}",
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ),
//           Switch(
//             value: _isCard,
//             onChanged: (value) {
//               setState(() {
//                 _isCard = value;
//               });
//             },
//             activeColor: Colors.white,
//             activeTrackColor: Colors.grey,
//           ),
//         ],
//       ),
//       body: _isCard ? getCardWidgets() : getEsewaWidgets(),
//     );
//   }

//   Widget getCardWidgets() {
//     return Column(
//       children: [
//         Expanded(
//           child: CreditCardWidget(
//             cardNumber: cardNumber,
//             expiryDate: expiryDate,
//             cardHolderName: cardHolderName,
//             cvvCode: cvvCode,
//             showBackView: isCvvFocused,
//             height: 200,
//             width: MediaQuery.of(context).size.width,
//             animationDuration: Duration(milliseconds: 1000),
//           ),
//         ),
//         Expanded(
//           child: SingleChildScrollView(
//             child: CreditCardForm(
//               onCreditCardModelChange: onModelChanged,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: DefaultButton(
//             text: "Order",
//             press: () {
//               checkValidation();
//             },
//             icon: Icons.local_shipping,
//           ),
//         ),
//         SizedBox(
//           height: getProportionateScreenHeight(40),
//         ),
//       ],
//     );
//   }

//   Widget getEsewaWidgets() {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: getProportionateScreenWidth(11),
//       ),
//       child: Column(
//         children: [
//           SizedBox(
//             height: getProportionateScreenHeight(20),
//           ),
//           TextFormField(
//             style: Theme.of(context).textTheme.headline4,
//             initialValue: esewaId,
//             textInputAction: TextInputAction.next,
//             keyboardType: TextInputType.emailAddress,
//             onChanged: (newValue) => esewaId = newValue,
//             decoration: InputDecoration(
//               labelText: "Esewa ID",
//               hintText: "Enter your Esewa ID",
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               suffixIcon: Padding(
//                 padding: const EdgeInsets.only(right: 23.0),
//                 child: Icon(
//                   Icons.perm_identity_outlined,
//                   color: Theme.of(context).iconTheme.color,
//                   size: getProportionateScreenWidth(25),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: getProportionateScreenHeight(30),
//           ),
//           TextFormField(
//             style: Theme.of(context).textTheme.headline4,
//             initialValue: username,
//             textInputAction: TextInputAction.next,
//             keyboardType: TextInputType.name,
//             onChanged: (newValue) => username = newValue,
//             decoration: InputDecoration(
//               labelText: "Esewa Username",
//               hintText: "Enter your Esewa Username",
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               suffixIcon: Padding(
//                 padding: const EdgeInsets.only(right: 23.0),
//                 child: Icon(
//                   Icons.contact_mail,
//                   color: Theme.of(context).iconTheme.color,
//                   size: getProportionateScreenWidth(25),
//                 ),
//               ),
//             ),
//           ),
//           Spacer(),
//           DefaultButton(
//             text: "Order",
//             press: () {
//               checkValidation();
//             },
//             icon: Icons.local_shipping,
//           ),
//           SizedBox(
//             height: getProportionateScreenHeight(52),
//           ),
//         ],
//       ),
//     );
//   }

//   void onModelChanged(CreditCardModel cardModel) {
//     setState(() {
//       cardNumber = cardModel.cardNumber;
//       expiryDate = cardModel.expiryDate;
//       cardHolderName = cardModel.cardHolderName;
//       cvvCode = cardModel.cvvCode;
//       isCvvFocused = cardModel.isCvvFocused;
//     });
//   }
// }
