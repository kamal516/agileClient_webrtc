//
// import 'package:flutter/material.dart' hide ButtonStyle;
// import 'package:newagileapp/applisignin/apple_available.dart';
// import 'package:newagileapp/applisignin/authservice.dart';
// import 'package:provider/provider.dart';
// import 'package:the_apple_sign_in/the_apple_sign_in.dart';
//
// class SignInPage extends StatelessWidget {
//   Future<void> _signInWithApple(BuildContext context) async {
//     try {
//       final authService = Provider.of<AuthService>(context, listen: false);
//       final user = await authService.signInWithApple();
//       print('uid: ${user.uid}');
//     } catch (e) {
//       // TODO: Show alert here
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final appleSignInAvailable =
//         Provider.of<AppleSignInAvailable>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign In'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(6.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (appleSignInAvailable.isAvailable)
//               AppleSignInButton(
//                 style: ButtonStyle.black,
//                 // hwtpreetkamal1997@gmail.com Cathode345
//                 type: ButtonType.signIn,
//                 onPressed: () => _signInWithApple(context),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }