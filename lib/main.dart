import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gd6_c_2027/database/sql_helper.dart';
import 'package:gd6_c_2027/input_office.dart';
import 'package:gd6_c_2027/inputPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFLITE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(
        title: 'SQFLITE',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> employee = [];
  List<Map<String, dynamic>> office = [];

  void refreshEmployee() async {
    final data = await SQLHelper.getEmployee();
    setState(() {
      employee = data;
    });
  }

  void refreshOffice() async {
    final data = await SQLHelper.getOffice();
    setState(() {
      office = data;
    });
  }

  @override
  void initState() {
    refreshEmployee();
    refreshOffice();
    super.initState();
  }

  Widget _getPage(int index) {
    if (index == 0) {
      return ListView.builder(
        itemCount: employee.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(employee[index]['id']),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InputPage(
                              title: 'INPUT EMPLOYEE',
                              id: employee[index]['id'],
                              name: employee[index]['name'],
                              email: employee[index]['email'])),
                    ).then((_) => refreshEmployee());
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.update,
                  label: 'Update',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await deleteEmployee(employee[index]['id']);
                    refreshEmployee();
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              title: Text(employee[index]['name']),
              subtitle: Text(employee[index]['email']),
            ),
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: office.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(office[index]['officeName']),
            subtitle: Text(office[index]['officeEmail']),
            subtitle: Text(office[index]['officeAddress']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InputOffice(
                        title: 'INPUT OFFICE',
                        id: office[index]['id'],
                        officeName: office[index]['officeName'],
                        officeEmail: office[index]['officeEmail'],
                        officeAddress: office[index]['officeAddress'])),
              ).then((_) => refreshOffice());
            },
          );
        },
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "EMPLOYEE" : "OFFICE"),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => _selectedIndex == 0
                          ? const InputPage(
                              title: 'INPUT EMPLOYEE',
                              id: null,
                              name: null,
                              email: null)
                          : const InputOffice(
                              title: 'INPUT OFFICE',
                              id: null,
                              officeName: null,
                              officeEmail: null,
                              officeAddress: null)),
                ).then((_) =>
                    _selectedIndex == 0 ? refreshEmployee() : refreshOffice());
              }),
        ],
      ),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Employee',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Office',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> deleteEmployee(int id) async {
    await SQLHelper.deleteEmployee(id);
    refreshEmployee();
  }
}
