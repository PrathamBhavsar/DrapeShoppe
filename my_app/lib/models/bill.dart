class Bill {
  final String salespersonName;
  final String customerName;
  final String agentName;
  final String salesRemarks;
  final String dealNo;
  String? agentRemarks;
  String? agentCost;
  final String status;


  Bill({
    required this.salespersonName,
    required this.customerName,
    required this.agentName,
    required this.salesRemarks,
    required this.dealNo,
    this.agentRemarks,
    this.agentCost,
    required this.status,

  });

  Map<String, dynamic> toMap() {
    return {
      'salespersonName': salespersonName,
      'customerName': customerName,
      'agentName': agentName,
      'salesRemarks': salesRemarks,
      'dealNo': dealNo,
      'agentRemarks': agentRemarks,
      'agentCost': agentCost,
      'status': status,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      salespersonName: map['salespersonName'],
      customerName: map['customerName'],
      agentName: map['agentName'],
      salesRemarks: map['salesRemarks'],
      dealNo: map['dealNo'],
      agentRemarks: map['agentRemarks'],
      agentCost: map['agentCost'],
      status: map['status'],
    );
  }
}
