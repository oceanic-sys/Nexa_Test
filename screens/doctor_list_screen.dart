import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:doctor_app/models/doctor_model.dart';
import 'package:doctor_app/widgets/doctor_card.dart';
import 'home_screen.dart';

class DoctorListScreen extends StatefulWidget {
  static const String routeName = '/doctor_list';

  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  late Future<ApiResponse> futureApiResponse;
  int _selectedIndex = 1;
  int _selectedButtonIndex = 0;
  late String username;

  @override
  void initState() {
    super.initState();
    futureApiResponse = fetchDoctors();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    if (args != null) {
      setState(() {
        username = args;
      });
    }
  }

//ambil hasil dari http request postman
  Future<ApiResponse> fetchDoctors() async {
    final response = await http.post(
      Uri.parse('https://nexacaresys.codeplay.id/api/doctor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RlcnVzZXIiLCJpYXQiOjE3MTYxOTg5MjcsImV4cCI6MTcxODc5MDkyN30.j-Sht7UewwJe1eMb3J-tY--GWMqocC-z9pPYtidDEDo',
      },
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load doctors');
    }
  }

// saat pindah halaman, username tetap sama
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(
        context,
        HomeScreen.routeName,
        arguments: username,
      );
    } else if (index == 1) {
      Navigator.pushReplacementNamed(
        context,
        DoctorListScreen.routeName,
        arguments: username,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _buildMenuButton(0, 'Dibatalkan'),
                _buildMenuButton(1, 'Jadwal Dokter'),
                _buildMenuButton(2, 'Semua'),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<ApiResponse>(
        future: futureApiResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.doctors.length,
              itemBuilder: (context, index) {
                return DoctorCard(doctor: snapshot.data!.doctors[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'Doctors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(color: Colors.blue, size: 30),
        unselectedIconTheme: IconThemeData(color: Colors.grey, size: 30),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildMenuButton(int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedButtonIndex = index;
        });
      },
      child: Container(
        width: 150.0,
        height: 20.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: _selectedButtonIndex == index
              ? Color.fromARGB(255, 167, 211, 229)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: _selectedButtonIndex == index
                  ? Color.fromARGB(245, 14, 150, 228)
                  : Color.fromARGB(255, 53, 172, 236),
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
