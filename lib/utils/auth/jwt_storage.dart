import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
const jwt_key = "auth_jwt_token";


Future<String?> get_token() async{
  return await storage.read(key: jwt_key);
}

set_token(String value) async{
  await storage.write(key: jwt_key, value: value);
}

delete_token() async{
  await storage.delete(key: jwt_key);
}