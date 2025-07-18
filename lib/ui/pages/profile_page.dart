import 'package:bc_phthalmoscopy/common/extensions/string_extensions.dart';
import 'package:bc_phthalmoscopy/repository/keycloak.dart';
import 'package:bc_phthalmoscopy/ui/widgets/my_app_bar.dart';
import 'package:bc_phthalmoscopy/ui/widgets/profile_tile_widget.dart';
import 'package:bc_phthalmoscopy/ui/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future? _future;
  static String userName = "";

  @override
  void initState() {
    super.initState();
    if (userName.isEmpty) {
      _future = FlutterSecureStorage().read(key: "user_name");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Профиль"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData && userName.isEmpty) {
                userName = snapshot.data as String;
              }
              return Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Theme.of(context).cardColor,
                    child: Image(
                      image: AssetImage("assets/images/doctor_icon.png"),
                    ),
                  ),
                  Text(
                    userName.truncateToWords(2),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  ProfileTileWidget(
                    image: "assets/images/device_icon.png",
                    title: "Устройства",
                    onTap: () {
                      context.go("/patients_list/profile/devices_list");
                    },
                  ),
                  ProfileTileWidget(
                    image: "assets/images/logout_icon.png",
                    title: "Выход",
                    onTap: () async {
                      Keycloak.instance.logout().then((value) {
                        if (value) {
                          userName = "";
                          if (context.mounted) {
                            context.replace("/");
                          }
                        } else {
                          if (context.mounted) {
                            showErrorSnackBar(
                              context,
                              "Ошибка выхода из аккаунта!",
                            );
                          }
                        }
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
