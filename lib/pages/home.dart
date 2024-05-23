import 'package:flutter/material.dart';
import 'package:todo_share/widgets/admob_banner.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 64.0,
        backgroundColor: Color.fromARGB(255, 255, 247, 223),
        leading: Builder(
          builder: (context) {
            return Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () {
                  print('aaaaaaa');
                },
                splashColor: const Color(0xff000000).withAlpha(30),
                child: Image.asset('assets/images/humburger.png'),
              ),
            );
          },
        ),
        actions: [
          Stack(
            children: [
              TextButton(
                child: Text(
                  '\u{1F514}',
                  style: TextStyle(fontSize: 40),
                ),
                onPressed: () {},
                style: TextButton.styleFrom(
                  fixedSize: Size(40, 64),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 4,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    // '$notificationCount',
                    '99',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      drawer: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Handle the Home tap here
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
      body: AdMobBanner(),
    );
  }
}
