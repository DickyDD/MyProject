import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:tes_database/app/data/widgets/button.dart';
import 'package:tes_database/app/modules/guru/controllers/guru_controller.dart';

class ViewDataSiswa extends StatelessWidget {
  const ViewDataSiswa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GuruController>();
    return StreamBuilder(
      stream: controller.users
          .collection(controller.tahunAjaran)
          .doc(controller.jurusan)
          .collection(controller.semester)
          .doc(controller.kelas)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<DocumentSnapshot> asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return Text('Error: ${asyncSnapshot.error}');
        }
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.none:
            return Text('No data');
          case ConnectionState.waiting:
            return Text('Awaiting...');
          case ConnectionState.active:
            var dataMap = asyncSnapshot.data!.data()! as Map;
            var data = dataMap["siswa"] as List;
            return GridView.extent(
              // crossAxisCount: 2,
              maxCrossAxisExtent: 500,
              // childAspectRatio: ,
              // mainAxisSpacing: 50,
              // crossAxisSpacing: 50,
              children: [
                ...data.map((value) {
                  var nilai = value['nilai'] as List;
                  var dataKososng = "Belum di Isi";
                  return Card(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          // Image.network(
                          //   value['imageSiswa'],
                          //   height: 300,
                          //   width: 300,
                          // ),
                          ProgressiveImage(
                            placeholder: AssetImage('assets/person.png'),
                            // size: 1.87KB
                            thumbnail: AssetImage('assets/person.png'),
                            // size: 1.29MB
                            image: NetworkImage(value['imageSiswa']),
                            height: 230,
                            width: 240,
                          ),
                          Text(
                            value['nama'] ?? dataKososng,
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            value['nis'] ?? dataKososng,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(value['komentar'] ?? dataKososng),
                          // ...nilai.map((e) {
                          //   var dataNilai = e as Map;
                          //   var keys = '';
                          //   var values;
                          //   dataNilai.forEach((key, value) {
                          //     keys = key;
                          //     values = value;
                          //   });
                          //   return Column(
                          //     children: [
                          //       Text(
                          //         "$keys ",
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //       Text(
                          //         "${values['nama'].toString()} : ",
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //       Text(
                          //         values['nilai'].toString(),
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //     ],
                          //   );
                          // })
                          ButtonCustom(
                            nama: "Lihat Data",
                            onTap: () async {
                              // controller.indexList.value = 3;
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          // return ListView(children: [
          //   ...data.map((value) {
          //     var nilai = value['nilai'] as List;
          //     return Card(
          //       child: Column(
          //         children: [
          //           Text(value['nis']),
          //           Text(value['nama']),
          //           Image.network(value['imageSiswa']),
          //           ...nilai.map((e) {
          //             var dataNilai = e as Map;
          //             var keys = '';
          //             var values;
          //             dataNilai.forEach((key, value) {
          //               keys = key;
          //               values = value;
          //             });
          //             return Row(
          //               children: [
          //                 Text("$keys : "),
          //                 Text("${values['nama'].toString()} : "),
          //                 Text(values['nilai'].toString()),
          //               ],
          //             );
          //           })
          //         ],
          //       ),
          //     );
          //   }).toList(),
          // ]);

          case ConnectionState.done:
            var dataMap = asyncSnapshot.data!.data()! as Map;
            var data = dataMap["siswa"] as List;
            print(data);
            return ListView(children: [
              ...data.map(
                (value) => Column(
                  children: [
                    Text(value.toString()),
                  ],
                ),
              ),
            ]);
        }
      },
    );
  }
}
