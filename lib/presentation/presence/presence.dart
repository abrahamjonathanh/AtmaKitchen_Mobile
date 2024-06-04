import 'dart:convert';

import 'package:atmakitchen_mobile/constants/constants.dart';
import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/data/presence_client.dart';
import 'package:atmakitchen_mobile/domain/user.dart';
import 'package:atmakitchen_mobile/presentation/profile/profile.dart';
import 'package:atmakitchen_mobile/widgets/atma_bottom_bar.dart';
import 'package:atmakitchen_mobile/widgets/atma_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class PresenceScreen extends StatefulWidget {
  const PresenceScreen({super.key});

  @override
  State<PresenceScreen> createState() => _PresenceScreenState();
}

class _PresenceScreenState extends State<PresenceScreen> {
  // Future<List<Presence>>? presences;
  Future<List<Employee>>? employees;
  List<Employee> filteredEmployee = [];

  DateTime now = DateTime.now();

  TextEditingController searchController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  void getAllEmployee() async {
    var response =
        await PresenceClient.getAllPresenceByDate(box.read("token"), now);

    // var response = await UserClient.getAllEmployee(box.read("token"));

    Map<String, dynamic> data = jsonDecode(response.body);
    debugPrint(data['data'][0].toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<Employee> employeeData = (data['data'] as List)
          .map((item) => Employee(
              idKaryawan: item['id_karyawan'],
              nama: item['nama'],
              presensi: item['presensi'],
              akun: Account.fromJson(item['akun']),
              idPresensi: item['id_presensi']))
          .toList();

      setState(() {
        employees = Future.value(employeeData);
        filteredEmployee = employeeData;
      });
    }
  }

  List<Employee> filterPresences(String query, List<Employee> presences) {
    if (query.isEmpty) {
      return presences; // Return all presences if the query is empty
    }
    return presences.where((presences) {
      return presences.nama.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getAllEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: TW3Colors.slate.shade200,
      appBar: AppBar(
        title: const Text("Presensi"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16.0,
              ),
              FutureBuilder<List<Employee>>(
                  future: employees,
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
                          AtmaTextField(
                            key: const ValueKey("searchKey"),
                            title: "Cari nama karyawan....",
                            controller: searchController,
                            onSubmitted: (value) {
                              setState(() {
                                filteredEmployee = filterPresences(
                                    searchController.text, data);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tanggal",
                                style: AStyle.textStyleTitleMd,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: now, //get today's date
                                      firstDate: DateTime(
                                          2020), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime.now());
                                  setState(() {
                                    dateController.text = pickedDate.toString();
                                    now = pickedDate!;
                                  });
                                  getAllEmployee();
                                  debugPrint(dateController.text);
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_month_rounded),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    Text(DateFormat('d MMMM y').format(now)),
                                  ],
                                ),
                              )
                            ],
                          ),
                          // const SizedBox(
                          //   height: 16.0,
                          // ),
                          // const Text(
                          //     "Tekan Tombol 'Tidak Hadir' untuk membuat karyawan absen."),
                          const SizedBox(
                            height: 24.0,
                          ),
                          ...filteredEmployee.map((e) => Column(
                                children: [
                                  PresenceCard(
                                      employee: e,
                                      idPresence: e.idPresensi!,
                                      date: now,
                                      onSubmit: () {
                                        getAllEmployee();
                                      }),
                                  // const SizedBox(
                                  //   height: 8.0,
                                  // )
                                ],
                              ))
                        ],
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })
            ],
          ),
        ),
      ),
      bottomNavigationBar: AtmaBottomBar(
        currentIndex: 0,
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
          () => const PresenceScreen(),
          () => const AdminProfileScreen(),
        ],
      ),
    );
  }
}

class PresenceCard extends StatefulWidget {
  final Employee employee;
  final int idPresence;
  final VoidCallback onSubmit;
  final DateTime date;
  const PresenceCard(
      {Key? key,
      required this.employee,
      required this.idPresence,
      required this.onSubmit,
      required this.date})
      : super(key: key);

  @override
  State<PresenceCard> createState() => _PresenceCardState();
}

class _PresenceCardState extends State<PresenceCard> {
  @override
  Widget build(BuildContext context) {
    void onUpdateHandler() async {
      var response = await PresenceClient.updatePresenceByEmployeeId(
          box.read("token"), widget.date, widget.employee);
      if (response.statusCode == 200 || response.statusCode == 201) {
        widget.onSubmit();
      }
    }

    void onDeleteHandler() async {
      debugPrint("Delete");
      var response = await PresenceClient.deletePresenceByEmployeeId(
          box.read("token"), widget.idPresence);
      if (response.statusCode == 200 || response.statusCode == 201) {
        widget.onSubmit();
      }
    }

    return ListTile(
        title: Text(
          widget.employee.nama,
          style: AStyle.textStyleNormal,
        ),
        subtitle: Text(widget.employee.akun?.role?.role.toString() ?? "0000"),
        contentPadding: const EdgeInsets.all(0),
        tileColor: Colors.white,
        trailing: TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'Apakah anda yakin bahwa ${widget.employee.nama} ${!widget.employee.presensi! ? "tidak hadir" : "akan diperbarui menjadi hadir"}?'),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        if (widget.employee.presensi! == false) {
                          onUpdateHandler();
                        } else {
                          onDeleteHandler();
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                          'Ubah menjadi ${!widget.employee.presensi! ? "Tidak Hadir" : "Hadir"}'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(TW3Colors.orange.shade600),
              foregroundColor: MaterialStatePropertyAll(Colors.white)),
          child: !widget.employee.presensi!
              ? const Text("Tidak Hadir")
              : const Text("Hadir"),
        ));
  }
}
