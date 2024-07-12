import 'dart:convert';
import 'package:flutter/services.dart'; // To mock fetching data from a local JSON file
import '../models/user_model.dart';

class UserService {
  Future<User> fetchUserData() async {
    // Simulate fetching data from a database
    final response = await rootBundle.loadString('assets/user_data.json');
    final data = jsonDecode(response);

    return User.fromJson(data);
  }
}
