import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:management_barang_bengkel/controllers/mainscreen_provider.dart';
import 'package:management_barang_bengkel/views/beli_barang_screen.dart';
import 'package:management_barang_bengkel/views/jual_barang_screen.dart';
import 'package:management_barang_bengkel/views/list_barang_screen.dart';
import 'package:management_barang_bengkel/views/widget/bottom_nav_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  List<Widget> pageList = const [
    ListBarangScreen(),
    JualBarangScreen(),
    BeliBarangScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenProvider>(
        builder: (context, mainscreenprovider, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Image(
            image: AssetImage('assets/logo.png'),
            width: 250,
          ),
          centerTitle: true,
        ),
        body: pageList[mainscreenprovider.currentIndex],
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BottomNavWidget(
                    onTap: () {
                      mainscreenprovider.setIndex(0);
                    },
                    icon: mainscreenprovider.currentIndex == 0
                        ? Ionicons.home
                        : Ionicons.home_outline,
                  ),
                  BottomNavWidget(
                    onTap: () {
                      mainscreenprovider.setIndex(1);
                    },
                    icon: mainscreenprovider.currentIndex == 1
                        ? Ionicons.cart
                        : Ionicons.cart_outline,
                  ),
                  BottomNavWidget(
                    onTap: () {
                      mainscreenprovider.setIndex(2);
                    },
                    icon: mainscreenprovider.currentIndex == 2
                        ? Ionicons.add_circle
                        : Ionicons.add,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
