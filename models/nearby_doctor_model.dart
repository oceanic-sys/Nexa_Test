class NearbyDoctor {
  final int id;
  final String nama;
  final String jenis;
  final String tanggal;
  final String jadwal;
  final String jarak;

  NearbyDoctor({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.tanggal,
    required this.jadwal,
    required this.jarak,
  });

  factory NearbyDoctor.fromJson(Map<String, dynamic> json) {
    return NearbyDoctor(
      id: json['id'],
      nama: json['nama'],
      jenis: json['jenis'],
      tanggal: json['tanggal'],
      jadwal: json['jadwal'],
      jarak: json['jarak'],
    );
  }
}
