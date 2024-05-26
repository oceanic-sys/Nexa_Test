import 'package:flutter/material.dart';
import 'package:doctor_app/models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 180,
        child: Card(
          margin: EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 35.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/doctor.png'),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.nama,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          '${doctor.jenis}',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: const Color.fromARGB(255, 208, 198, 198)),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(height: 20, thickness: 0.5, color: Colors.grey),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Color.fromARGB(255, 150, 149, 149),
                            size: 8,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${doctor.tanggal}',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: const Color.fromARGB(255, 150, 149, 149),
                            size: 8,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${doctor.jadwal}',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                if (doctor.jarak != null)
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        color: const Color.fromARGB(255, 150, 149, 149),
                        size: 8,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${doctor.jarak}',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 8),
                Center(
                  child: SimpleRoundedBoxWithText(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleRoundedBoxWithText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 30,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 228, 233, 237),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          'Details',
          style: TextStyle(
            color: Color.fromARGB(255, 53, 172, 236),
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
