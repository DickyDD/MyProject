class Invoice {
  final Info info;
  final String catatanAkademik;
  final String kenaikanKelas;
  final String namaOrangTua;
  final String namaWalikelas;
  final String namaKepalaSekolah;
  final String nipWalikelas;
  final String nipKepalaSekolah;
  final String dpk;
  // final String lulus;
  final List<InvoiceItem> itemsA;
  final List<InvoiceItem> itemsB;
  final List<InvoiceItem> itemsC;
  final List<InvoiceItem> itemsD;
  final List<InvoiceItemPKL> itemsPkl;
  final List<InvoiceItemExtra> itemsExtra;
  final List<InvoiceItemKehadiran> itemsKehadiran;
  final List<InvoiceItemKehadiran> itemsDPK;

  const Invoice({
    required this.info,
    required this.itemsA,
    required this.itemsDPK,
    required this.itemsExtra,
    required this.itemsB,
    required this.itemsC,
    required this.itemsKehadiran,
    required this.itemsD,
    required this.catatanAkademik,
    required this.namaOrangTua,
    required this.namaWalikelas,
    required this.namaKepalaSekolah,
    required this.dpk,
    // required this.lulus,
    required this.nipWalikelas,
    required this.nipKepalaSekolah,
    required this.itemsPkl,
    required this.kenaikanKelas,
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

  const InvoiceItem({
    required this.no,
    required this.mP,
    required this.pengetahuan,
    required this.keterampilan,
  });
}

class InvoiceItemPKL {
  final String no;
  final String lokasi;
  final String mitra;
  final String lama;
  final String keterangan;

  const InvoiceItemPKL({
    required this.mitra,
    required this.no,
    required this.lokasi,
    required this.lama,
    required this.keterangan,
  });
}

class InvoiceItemExtra {
  final int no;
  final String nama;
  final String nilai;
  final String keterangan;

  const InvoiceItemExtra({
    required this.no,
    required this.nilai,
    required this.nama,
    required this.keterangan,
  });
}

class InvoiceItemKehadiran {
  final String nama;
  final String nilai;

  const InvoiceItemKehadiran({
    required this.nama,
    required this.nilai,
  });
}
