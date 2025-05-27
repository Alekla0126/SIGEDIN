class DashboardStatsModel {
  final bool success;
  final String message;
  final DashboardStatsDataModel data;

  DashboardStatsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DashboardStatsDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class DashboardStatsDataModel {
  final int documentosRegistrados;
  final int turnadosPendientes;
  final int conAcuse;

  DashboardStatsDataModel({
    required this.documentosRegistrados,
    required this.turnadosPendientes,
    required this.conAcuse,
  });

  factory DashboardStatsDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsDataModel(
      documentosRegistrados: json['documentos_registrados'] ?? 0,
      turnadosPendientes: json['turnados_pendientes'] ?? 0,
      conAcuse: json['con_acuse'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentos_registrados': documentosRegistrados,
      'turnados_pendientes': turnadosPendientes,
      'con_acuse': conAcuse,
    };
  }
}
