import 'package:atmakitchen_mobile/constants/constants.dart';
import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/data/user_client.dart';
import 'package:atmakitchen_mobile/domain/user.dart';
import 'package:atmakitchen_mobile/presentation/general/general.dart';
import 'package:atmakitchen_mobile/presentation/home/user_home.dart';
import 'package:atmakitchen_mobile/presentation/profile/user_transaction_history.dart';
import 'package:atmakitchen_mobile/widgets/atma_bottom_bar.dart';
import 'package:atmakitchen_mobile/widgets/atma_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<Customer>? customer;

  void onGetCurrentUserHandler() async {
    var response = await UserClient.getCurrentUser(box.read("token"));

    if (response['data'] != null) {
      var data = response['data'];
      Account accountData = Account(
          idAkun: data['akun']['id_akun'],
          email: data['akun']['email'],
          idRole: data['akun']['id_role'],
          profileImage: data['akun']['profile_image']);

      Customer customerData = Customer(
          idAkun: data['id_akun'],
          idPelanggan: data['id_pelanggan'],
          nama: data['nama'],
          akun: accountData);
      debugPrint(customerData.idPelanggan.toString());
      box.write("id_user", customerData.idPelanggan.toString());

      setState(() {
        customer = Future.value(customerData);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onGetCurrentUserHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AStyle.textStyleTitleLg,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
                future: customer,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  if (snapshot.hasData) {
                    final data = snapshot.data!;

                    return Column(
                      children: [
                        CircleAvatar(
                            radius: 48.0,
                            backgroundImage: NetworkImage(
                                data.akun!.profileImage!,
                                scale: 1.0)),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          data.nama,
                          style: AStyle.textStyleTitleMd,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          data.akun!.email,
                          style: AStyle.textStyleNormal,
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            const SizedBox(
              height: 16.0,
            ),
            const AtmaListTile(
              title: "Informasi Pengguna",
              icon: Icons.person,
            ),
            const SizedBox(
              height: 8.0,
            ),
            AtmaListTile(
              title: "Riwayat Transaksi",
              icon: Icons.shopping_bag_rounded,
              onTap: () => Get.to(const UserTransactionHistory()),
            ),
            const SizedBox(
              height: 8.0,
            ),
            AtmaListTile(
              title: "Informasi Umum",
              icon: Icons.info,
              onTap: () => Get.to(const GeneralScreen()),
            ),
            const SizedBox(
              height: 8.0,
            ),
            AtmaListTile(
              title: "Keluar",
              icon: Icons.logout,
              onTap: () => Get.to(const GeneralScreen()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AtmaBottomBar(
        currentIndex: 1,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        routes: <Widget Function()>[
          () => const UserHomeScreen(),
          () => const UserProfileScreen(),
        ],
      ),
    );
  }
}
