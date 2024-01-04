import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/registration/authentication/auth_cubit.dart';

import '../registration/authentication/auth_state.dart';
import 'fragments/home_fragment/home_fragment.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  final drawerItems = [
    DrawerItem("Home", Icons.home),
    DrawerItem("My orders", Icons.shopping_bag),
    DrawerItem("My Cart", Icons.shopping_cart),
    DrawerItem("My Wishlist", Icons.favorite_outlined),
    DrawerItem("My Account", Icons.account_circle)
  ];

  //declare fragments here
  final HomeFragment _homeFragment = const HomeFragment();
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: _selectedDrawerIndex == 0
            ? Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 50,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text('My Smart Store'),
                ],
              )
            : Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: _createDrawerOptions(),
          ),
        ),
      ),
      body: _getDrawerItemFragment(_selectedDrawerIndex),
    );
  }

  _createDrawerOptions() {
    String email = 'Email', name = "Full Name";
    AuthState authState = BlocProvider.of<AuthCubit>(context).state;
    if (authState is Authenticated) {
      email = authState.userdata.email!;
      name = authState.userdata.fullName!;
    } else {
      widget.drawerItems.add(DrawerItem("Login", Icons.login));
    }
    var drawerOptions = <Widget>[
      UserAccountsDrawerHeader(
        accountName: Text(name),
        accountEmail: Text(email),
      ),
    ];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
        ListTile(
          leading: Icon(d.icon),
          title: Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () {
            setState(() {
              _selectedDrawerIndex = i;
              Navigator.of(context).pop();
            });
          },
        ),
      );
    }
    return drawerOptions;
  }

  _getDrawerItemFragment(int pos) {
    switch (pos) {
      case 0:
        return widget._homeFragment;
      case 1:
        return widget._homeFragment;
      case 2:
        return widget._homeFragment;
      case 3:
        return widget._homeFragment;
      case 4:
        return widget._homeFragment;
      default:
        return widget._homeFragment;
    }
  }
}
