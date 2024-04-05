class ThongBao {
  final int maThongBao;
  final String tieuDe;
  final String noiDung;
  final bool trangThaiXem;
  final DateTime ngayTao;
  final String tenLoai;
  final String moTa;

  ThongBao({
    required this.maThongBao,
    required this.tieuDe,
    required this.noiDung,
    required this.trangThaiXem,
    required this.ngayTao,
    required this.tenLoai,
    required this.moTa,
  });

  factory ThongBao.fromJson(Map<String, dynamic> json) {
    return ThongBao(
      maThongBao: json['ma_thong_bao'],
      tieuDe: json['tieu_de'],
      noiDung: json['noi_dung'],
      trangThaiXem: json['trang_thai_xem'] == 1,
      ngayTao: DateTime.parse(json['ngay_tao']),
      tenLoai: json['ten_loai'],
      moTa: json['mo_ta'],
    );
  }
}
