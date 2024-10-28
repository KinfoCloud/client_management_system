class Client {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required String agent,
    required String location,
    String? requiredImage,
    String? optionalImage,
    required List<String> projects,
    required List<String> masterStores,
    required Map<String, double> kpis,
    required List<String> skus,
  });
}
