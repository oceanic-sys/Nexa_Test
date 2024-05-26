import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/doctor_model.dart';
import '../models/nearby_doctor_model.dart';
import '../widgets/doctor_card.dart';
import 'doctor_list_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Doctor> futureDoctor;
  late Future<NearbyDoctor> futureNearbyDoctor;
  int _selectedIndex = 0;
  String username = "";

  @override
  void initState() {
    super.initState();
    futureDoctor = fetchDoctor();
    futureNearbyDoctor = fetchNearbyDoctor();
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

// ambil hasil dari http request postman
  Future<Doctor> fetchDoctor() async {
    final response = await http.post(
      Uri.parse('https://nexacaresys.codeplay.id/api/doctor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RlcnVzZXIiLCJpYXQiOjE3MTYxOTg5MjcsImV4cCI6MTcxODc5MDkyN30.j-Sht7UewwJe1eMb3J-tY--GWMqocC-z9pPYtidDEDo',
      },
    );
// ambil data dokter list ke -1
    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body)['response']['data'][1]);
    } else {
      throw Exception('Failed to load doctor');
    }
  }

// ambil dokter dengan informasi tambahan jarak dan menyesuaikan jarak yang didapat dari postman
  Future<NearbyDoctor> fetchNearbyDoctor() async {
    final response = await http.post(
      Uri.parse('https://nexacaresys.codeplay.id/api/nearby'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RlcnVzZXIiLCJpYXQiOjE3MTYxOTg5MjcsImV4cCI6MTcxODc5MDkyN30.j-Sht7UewwJe1eMb3J-tY--GWMqocC-z9pPYtidDEDo',
      },
      body: jsonEncode({"lat": "25", "long": "30"}),
    );

    if (response.statusCode == 200) {
      return NearbyDoctor.fromJson(
          jsonDecode(response.body)['response']['dataResponse']);
    } else {
      throw Exception('Failed to load nearby doctor');
    }
  }

//pass username saat pindah halaman
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
    final String username =
        (ModalRoute.of(context)!.settings.arguments as String?) ??
            'Guest'; // sebagai guest jika username = null
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Hello, ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  username,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Icon(Icons.person_2_sharp),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              FutureBuilder<Doctor>(
                future: futureDoctor,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        DoctorCard(doctor: snapshot.data!),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.grey),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search...',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCircleIcon(Icons.person_add, 'Dokter'),
                            _buildCircleIcon(Icons.medication, 'Obat & Resep'),
                            _buildCircleIcon(
                                Icons.local_hospital, 'Rumah Sakit'),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
              SizedBox(height: 30),
              Text(
                'Doctor Terdekat',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              FutureBuilder<NearbyDoctor>(
                future: futureNearbyDoctor,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DoctorCard(
                      doctor: Doctor(
                        id: snapshot.data!.id,
                        nama: snapshot.data!.nama,
                        jenis: snapshot.data!.jenis,
                        tanggal: snapshot.data!.tanggal,
                        jadwal: snapshot.data!.jadwal,
                        jarak: snapshot.data!.jarak,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: '',
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

  Widget _buildCircleIcon(IconData icon, String text) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 20,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(fontSize: 8),
        ),
      ],
    );
  }
}
