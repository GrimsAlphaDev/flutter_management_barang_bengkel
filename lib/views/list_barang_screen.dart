import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_barang_bengkel/controllers/listbarangscreen_provider.dart';
import 'package:management_barang_bengkel/models/barang.dart';
import 'package:provider/provider.dart';

class ListBarangScreen extends StatefulWidget {
  const ListBarangScreen({super.key});

  @override
  State<ListBarangScreen> createState() => _ListBarangScreenState();
}

class _ListBarangScreenState extends State<ListBarangScreen> {
  @override
  void initState() {
    Provider.of<ListBarangScreenProvider>(context, listen: false).fetchBarang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController namaBarangController = TextEditingController();
    TextEditingController hargaBarangController = TextEditingController();
    TextEditingController jumlahBarangController = TextEditingController();
    final updatedAt = DateTime.now();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'List Barang.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // search bar
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  onChanged: (value) {
                    Provider.of<ListBarangScreenProvider>(context,
                            listen: false)
                        .searchBarang(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Search Barang',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
              const SizedBox(height: 20),
              // list barang
              Expanded(
                child: Consumer<ListBarangScreenProvider>(
                  builder: (context, listbarangscreenprovider, _) {
                    if (listbarangscreenprovider.listBarang.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada barang'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: listbarangscreenprovider.listBarang.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // display detail barang
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Detail Barang'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Nama Barang : ${listbarangscreenprovider.listBarang[index].namaBarang}'),
                                        Text(
                                            'Harga Barang : ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(listbarangscreenprovider.listBarang[index].hargaBarang)}'),
                                        Text(
                                            'Jumlah Barang : ${listbarangscreenprovider.listBarang[index].jmlBarang}'),
                                        Text(
                                            'Total Harga : ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(listbarangscreenprovider.listBarang[index].hargaBarang * listbarangscreenprovider.listBarang[index].jmlBarang)}'),
                                        Text(
                                            'Dibuat pada : ${DateFormat.yMMMMEEEEd().format(listbarangscreenprovider.listBarang[index].createdAt!)}'),
                                        Text(
                                            'Diupdate pada : ${DateFormat.yMMMMEEEEd().format(listbarangscreenprovider.listBarang[index].updatedAt)}'),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Tutup'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              child: ListTile(
                                  title: Row(
                                    // beetwen
                                    children: [
                                      Expanded(
                                        child: Text(
                                            listbarangscreenprovider
                                                .listBarang[index].namaBarang,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      const SizedBox(width: 10),
                                      // colored with text jml barang
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 253, 247, 215),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                            'Stok : ${listbarangscreenprovider.listBarang[index].jmlBarang}'),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                      // 'Rp. ${listbarangscreenprovider.listBarang[index].hargaBarang} Per Unit'),
                                      '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(listbarangscreenprovider.listBarang[index].hargaBarang)} Per Unit'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // return confirmation dialog
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Hapus Barang?'),
                                                content: const Text(
                                                    'Apakah anda yakin ingin menghapus barang ini?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Tidak'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      listbarangscreenprovider
                                                          .deleteBarang(
                                                              listbarangscreenprovider
                                                                  .listBarang[
                                                                      index]
                                                                  .id);
                                                      // send snackbar
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Barang berhasil dihapus'),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text('Ya'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // create a bottom sheet
                                          namaBarangController.text =
                                              listbarangscreenprovider
                                                  .listBarang[index].namaBarang;
                                          hargaBarangController.text =
                                              listbarangscreenprovider
                                                  .listBarang[index].hargaBarang
                                                  .toString();
                                          jumlahBarangController.text =
                                              listbarangscreenprovider
                                                  .listBarang[index].jmlBarang
                                                  .toString();
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.75,
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          'Edit Barang',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Form(
                                                          key: formKey,
                                                          child: Column(
                                                            children: [
                                                              TextFormField(
                                                                controller:
                                                                    namaBarangController,
                                                                // initialValue: listbarangscreenprovider
                                                                //     .listBarang[
                                                                //         index]
                                                                //     .namaBarang,
                                                                decoration:
                                                                    const InputDecoration(
                                                                        labelText:
                                                                            'Nama Barang'),
                                                              ),
                                                              // edit harga barang
                                                              TextFormField(
                                                                // initialValue: listbarangscreenprovider
                                                                //     .listBarang[
                                                                //         index]
                                                                //     .hargaBarang
                                                                //     .toString(),
                                                                controller:
                                                                    hargaBarangController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                        labelText:
                                                                            'Harga Barang'),
                                                                // onChanged:
                                                                //     (value) {
                                                                //   hargaBarangController
                                                                //           .text =
                                                                //       value;
                                                                // },
                                                              ),
                                                              // edit jumlah barang
                                                              TextFormField(
                                                                // initialValue: listbarangscreenprovider
                                                                //     .listBarang[
                                                                //         index]
                                                                //     .jmlBarang
                                                                //     .toString(),
                                                                controller:
                                                                    jumlahBarangController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                        labelText:
                                                                            'Jumlah Barang'),
                                                                // onChanged:
                                                                //     (value) {
                                                                //   jumlahBarangController
                                                                //           .text =
                                                                //       value;
                                                                // },
                                                              ),
                                                              const SizedBox(
                                                                  height: 20),
                                                              ElevatedButton(
                                                                // make a bigger button
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  minimumSize:
                                                                      const Size(
                                                                          double
                                                                              .infinity,
                                                                          40),
                                                                ),
                                                                onPressed: () {
                                                                  if (formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    var namaBarang =
                                                                        namaBarangController
                                                                            .text;
                                                                    var hargaBarang =
                                                                        hargaBarangController
                                                                            .text;
                                                                    var jumlahBarang =
                                                                        jumlahBarangController
                                                                            .text;

                                                                    var isExist = Provider.of<ListBarangScreenProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .listBarang
                                                                        .any((element) =>
                                                                            element.id != listbarangscreenprovider.listBarang[index].id && // Skip the item being edited
                                                                            element.namaBarang.toLowerCase() == namaBarang.toLowerCase());

                                                                    if (isExist) {
                                                                      Navigator.pop(
                                                                          context);
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Text('Barang sudah ada di list'),
                                                                        ),
                                                                      );
                                                                      return;
                                                                    }

                                                                    listbarangscreenprovider
                                                                        .updateBarang(
                                                                      Barang(
                                                                        id: listbarangscreenprovider
                                                                            .listBarang[index]
                                                                            .id,
                                                                        namaBarang:
                                                                            namaBarang,
                                                                        hargaBarang:
                                                                            int.parse(hargaBarang),
                                                                        jmlBarang:
                                                                            int.parse(jumlahBarang),
                                                                        updatedAt:
                                                                            updatedAt,
                                                                      ),
                                                                    );

                                                                    // snackbar
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        content:
                                                                            Text('Barang berhasil diupdate'),
                                                                      ),
                                                                    );

                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Edit'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
