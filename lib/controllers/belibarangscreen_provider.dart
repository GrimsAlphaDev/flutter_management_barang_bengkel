import 'package:flutter/material.dart';
import 'package:management_barang_bengkel/helper/db_helper.dart';
import 'package:management_barang_bengkel/models/barang.dart';

class BeliBarangScreenProvider extends ChangeNotifier {
  late DBHelper dbHelper;

  List<Barang> _listBarang = [];
  List<Barang> get listBarang => _listBarang;

  BeliBarangScreenProvider() {
    dbHelper = DBHelper();
    getListBarang();
  }

  void getListBarang() async {
    _listBarang = await dbHelper.getBarang();
    notifyListeners();
  }
}
