import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:midterm/pages/home.dart';
import 'package:midterm/pages/order.dart';
import 'package:midterm/pages/profile.dart';
import 'package:midterm/pages/orderinf.dart';


class BottomNav extends StatefulWidget {
  BottomNav({super.key, required this.userId, required this.name, required this.phone, required this.email});
  final String userId;
  final String name;
  final String phone;
  final String email;
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late Order order;
  late OrderInfor orderInfor;

  @override
  void initState() {
    homepage = Home(name: widget.name, userId: widget.userId, phone: widget.phone,);
    order = Order(userId: widget.userId, name: widget.name, phone: widget.phone,);
    profile = Profile( userId: widget.userId, name: widget.name, phone: widget.phone, email: widget.email);
    orderInfor = OrderInfor(userId: widget.userId);
    pages = [homepage, order, orderInfor, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.white,
          color: Colors.black,
          animationDuration: const Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: const [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.list_alt_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.person_outline,
              color: Colors.white,
            )
          ]),
      body: pages[currentTabIndex],
    );
  }
}