class AdminService {
  Future<List<Map<String, dynamic>>> getUsers() async {
    return [
      {
        'id': '1',
        'email': 'admin@gmail.com',
        'role': 'admin',
      },
      {
        'id': '2',
        'email': 'user@gmail.com',
        'role': 'user',
      },
    ];
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    return [
      {
        'id': 't1',
        'user': 'user@gmail.com',
        'amount': 500000,
        'status': 'Pending',
      },
      {
        'id': 't2',
        'user': 'user@gmail.com',
        'amount': 200000,
        'status': 'Completed',
      },
    ];
  }
}
