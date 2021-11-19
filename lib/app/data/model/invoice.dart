class Invoice {
  final Info info;
  final String catatanAkademik;
  final String namaOrangTua;
  final String namaWalikelas;
  final String namaKepalaSekolah;
  final String nipWalikelas;
  final String nipKepalaSekolah;
  final List<InvoiceItem> itemsA;
  final List<InvoiceItem> itemsB;
  final List<InvoiceItem> itemsC;
  final List<InvoiceItem> itemsD;

  const Invoice({
    required this.info,
    required this.itemsA,
    required this.itemsB,
    required this.itemsC,
    required this.itemsD,
    required this.catatanAkademik,
    required this.namaOrangTua,
    required this.namaWalikelas,
    required this.namaKepalaSekolah,
    required this.nipWalikelas,
    required this.nipKepalaSekolah,
  });
}

class Info {
  final String nama;
  final String nik;
  final String namaSekolah;
  final String alamat;
  final String kelas;
  final String semester;
  final String tahunPelajaran;

  const Info({
    required this.kelas,
    required this.semester,
    required this.tahunPelajaran,
    required this.nama,
    required this.nik,
    required this.namaSekolah,
    required this.alamat,
  });
}

class InvoiceItem {
  final int no;
  final String mP;
  final int pengetahuan;
  final int keterampilan;
  final String predikat;

  const InvoiceItem({
    required this.no,
    required this.mP,
    required this.pengetahuan,
    required this.keterampilan,
    required this.predikat,
  });
}
