import 'package:client_management_system/models/client.dart';

class ClientService {
  final List<Client> _clients = [];

  Future<List<Client>> getClients() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    return _clients;
  }

  Future<void> addClient(Client client) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    _clients.add(client);
  }
}
