import 'package:atmakitchen_mobile/data/presence_client.dart';
import 'package:atmakitchen_mobile/domain/presence.dart';
import 'package:atmakitchen_mobile/widgets/atma_bottom_bar.dart';
import 'package:flutter/material.dart';

class PresenceScreen extends StatefulWidget {
  const PresenceScreen({super.key});

  @override
  State<PresenceScreen> createState() => _PresenceScreenState();
}

class _PresenceScreenState extends State<PresenceScreen> {
  Future<List<Presence>>? presences;

  void getAllPresences() async {
    var response = await PresenceClient.getAllPresence();

    if (response['data'] != null) {
      List<Presence> presenceData = (response['data'] as List)
          .map((item) => Presence(
                // idPresensi: int.tryParse(item['id_presensi']),
                idKaryawan: int.parse(item['id_karyawan'].toString()),
                nama: item['nama'],
                jumlahAbsent: int.parse(item['jumlah_absent'].toString()),
                jumlahHadir: int.parse(item['jumlah_hadir'].toString()),
              ))
          .toList();
      setState(() {
        presences = Future.value(presenceData);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPresences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Presensi"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Presensi"),
              SizedBox(
                height: 255,
                child: FutureBuilder<List<Presence>>(
                    future: presences,
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

                        return ListView.separated(
                            scrollDirection: Axis.vertical,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 16.0),
                            itemCount: data.length,
                            itemBuilder: (_, index) {
                              return PresenceCard(presence: data[index]);
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AtmaBottomBar(
        currentIndex: 0,
      ),
    );
  }
}

class PresenceCard extends StatelessWidget {
  final Presence presence;
  const PresenceCard({Key? key, required this.presence}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(presence.nama!),
          Text(presence.jumlahAbsent!.toString()),
          Text(presence.jumlahHadir!.toString()),
        ],
      ),
    );
  }
}
