class Doctor {
  final int id;
  final String nama;
  final String jenis;
  final String tanggal;
  final String jadwal;
  final String? jarak;

  Doctor({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.tanggal,
    required this.jadwal,
    this.jarak,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      nama: json['nama'],
      jenis: json['jenis'],
      tanggal: json['tanggal'],
      jadwal: json['jadwal'],
      jarak: json['jarak'],
    );
  }
}

class ApiResponse {
  final List<Doctor> doctors;

  ApiResponse({required this.doctors});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['response']['data'] as List;
    List<Doctor> doctorList = list.map((i) => Doctor.fromJson(i)).toList();
    return ApiResponse(doctors: doctorList);
  }
}
