import 'package:bc_phthalmoscopy/repository/keycloak.dart';
import 'package:bc_phthalmoscopy/ui/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // _revertProgressIndicator();
    login();
  }

  // void _revertProgressIndicator() {
  //   _showLoginButton = false;
  //   _future = Future.delayed(Duration(seconds: 5), () {
  //     _showLoginButton = true;
  //   });
  //   setState(() {});
  // }

  void login() {
    Keycloak.instance.isTokenExpired().then((value) {
      if (value) {
        Keycloak.instance.refreshToken().then((value) {
          if (value) {
            showSuccessSnackBar(context, "Token refreshed");
            Future.delayed(
              Duration(seconds: 1),
            ).then((value) => navigateToMainScreen());
          } else {
            showErrorSnackBar(context, "Refresh token error");
            Keycloak.instance.login().then((value) {
              if (value == null) {
                return showErrorSnackBar(context, "Login error");
              }
              showSuccessSnackBar(context, "Login successful");

              Future.delayed(
                Duration(seconds: 1),
              ).then((value) => navigateToMainScreen());
            });
          }
        });
      } else {
        showSuccessSnackBar(context, "Token is not expired");
        Future.delayed(
          Duration(seconds: 1),
        ).then((value) => navigateToMainScreen());
      }
    });
  }

  void navigateToMainScreen() {
    if (context.mounted) {
      context.replace("/patients_list");
    }
  }

  // bool _showLoginButton = false;
  // Future? _future;

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: FutureBuilder(
    //     future: _future,
    //     builder: (context, snapshot) {
    //       return Center(
    //         child:
    //             _showLoginButton
    //                 ? ElevatedButton(
    //                   onPressed: () {
    //                     _revertProgressIndicator();
    //                     login();
    //                   },
    //                   child: Text(
    //                     "Login",
    //                     style: Theme.of(context).textTheme.displaySmall,
    //                   ),
    //                 )
    //                 : CircularProgressIndicator(),
    //       );
    //     },
    //   ),
    // );

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
