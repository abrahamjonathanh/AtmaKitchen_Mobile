import 'package:atmakitchen_mobile/constants/constants.dart';
import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/data/user_client.dart';
import 'package:atmakitchen_mobile/domain/user.dart';
import 'package:atmakitchen_mobile/pdf_view.dart';
import 'package:atmakitchen_mobile/pdf_view_pemasukan_pengeluaran.dart';
import 'package:atmakitchen_mobile/pdf_view_transaksi_penitip.dart';
import 'package:atmakitchen_mobile/presentation/general/general.dart';
import 'package:atmakitchen_mobile/presentation/home/user_home.dart';
import 'package:atmakitchen_mobile/presentation/presence/presence.dart';
import 'package:atmakitchen_mobile/presentation/profile/user_transaction_history.dart';
import 'package:atmakitchen_mobile/presentation/report/report_bahan_baku.dart';
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
      Account accountData = Account.fromJson(data['akun']);

      if (accountData.role?.role == "Customer") {
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
              onTap: () => {box.remove('token'), Get.to(const GeneralScreen())},
            ),
          ],
        ),
      ),
      bottomNavigationBar: AtmaBottomBar(
        currentIndex: 2,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        routes: <Widget Function()>[
          () => const GeneralScreen(),
          () => const UserHomeScreen(),
          () => const UserProfileScreen(),
        ],
      ),
    );
  }
}

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  Future<Employee>? employee;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _yearController = TextEditingController();
  int _selectedMonth = 1;
  DateTimeRange? selectedDates = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now());

  void onGetCurrentUserHandler() async {
    var response = await UserClient.getCurrentUser(box.read("token"));

    if (response['data'] != null) {
      var data = response['data'];
      Account accountData = Account.fromJson(data['akun']);

      Employee employeeData = Employee(
          idAkun: data['id_akun'],
          idKaryawan: data['id_karyawan'],
          nama: data['nama'],
          akun: accountData);

      setState(() {
        employee = Future.value(employeeData);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: employee,
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
                title: "Informasi Umum",
                icon: Icons.info,
                onTap: () => Get.to(const GeneralScreen()),
              ),
              const SizedBox(
                height: 8.0,
              ),
              AtmaListTile(
                title: "Laporan Stok Bahan Baku",
                icon: Icons.file_copy,
                onTap: () => Get.to(const PdfView()),
              ),
              const SizedBox(
                height: 8.0,
              ),
              GestureDetector(
                onTap: () async {
                  final DateTimeRange? dateTimeRange =
                      await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now());

                  if (dateTimeRange != null) {
                    setState(() {
                      selectedDates = dateTimeRange;
                    });

                    Get.to(() => PDFBahanBakuUsageScreen(
                        startDate: selectedDates!.start.toString(),
                        endDate: selectedDates!.end.toString()));
                  }
                  debugPrint(selectedDates.toString());
                },
                child: const AtmaListTile(
                  title: "Laporan Penggunaan Bahan Baku",
                  icon: Icons.info,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _yearController,
                      decoration: const InputDecoration(labelText: 'Year'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a year';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedMonth,
                      decoration: const InputDecoration(labelText: 'Month'),
                      items: List.generate(12, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          _selectedMonth = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    int year = int.parse(_yearController.text);
                    int month = _selectedMonth;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewPemasukanPengeluaran(
                          year: year,
                          month: month,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_document),
                    SizedBox(width: 8),
                    Text(
                      "Cetak Laporan Pemasukan Pengeluaran",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    int year = int.parse(_yearController.text);
                    int month = _selectedMonth;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewTransaksiPenitip(
                          year: year,
                          month: month,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_document),
                    SizedBox(width: 8),
                    Text(
                      "Cetak Laporan Rekap Transaksi Penitip",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              AtmaListTile(
                title: "Keluar",
                icon: Icons.logout,
                onTap: () =>
                    {box.remove('token'), Get.to(const GeneralScreen())},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AtmaBottomBar(
        currentIndex: 3,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Presence',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        routes: <Widget Function()>[
          () => const GeneralScreen(),
          () => const UserHomeScreen(),
          () => const PresenceScreen(),
          () => const AdminProfileScreen(),
        ],
      ),
    );
  }
}
