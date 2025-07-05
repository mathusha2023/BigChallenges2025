import 'package:bc_phthalmoscopy/common/extensions/string_extensions.dart';
import 'package:bc_phthalmoscopy/ui/widgets/my_app_bar.dart';
import 'package:bc_phthalmoscopy/ui/widgets/profile_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Профиль"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Theme.of(context).cardColor,
                child: Image(
                  image: AssetImage("assets/images/doctor_icon.png"),
                ),
              ),
              Text(
                "Базин Алексей Сергеевич".truncateToWords(2),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 20),
              ProfileTileWidget(
                image: "assets/images/device_icon.png",
                title: "Устройства",
                onTap: () {
                  context.go("/profile/devices_list");
                },
              ),
              ProfileTileWidget(
                image: "assets/images/logout_icon.png",
                title: "Выход",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
