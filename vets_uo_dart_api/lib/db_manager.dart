import 'package:mongo_dart/mongo_dart.dart';

class DbManager {
  String _dbName = "vets-dart-api";
  String _collectionName = "users";
  late dynamic _collection;
  late Db _db;

  DbManager(String dbName, String collectionName) {
    _dbName = dbName;
    _collectionName = collectionName;
  }

  DbManager.collection(String collectionName) {
    _collectionName = collectionName;
  }

  Future<void> connect() async {
  final dbUrl =
        'mongodb+srv://admin:admin@vets-dart-api.yjztzn4.mongodb.net/$_dbName?retryWrites=true&w=majority';
   
    _db = await Db.create(dbUrl);
    await _db.open();
    _collection = _db.collection(_collectionName);
    //return _db.collection(_collectionName);
  }

  Future<void> close() async {
    await _db.close();
  }

  Future<List<Map<String, dynamic>>> findAll() async {
    try {
      await connect();
      final data = await _collection.find().toList();
      return data;
    } catch (error) {
      List<Map<String, dynamic>> errorList = [];
      Map<String, dynamic> error = {
        "error": "Se ha producido un error al recupera  los datos"
      };
      errorList.add(error);
      return errorList;
    } finally {
      await close();
    }
  }

  Future<dynamic> findOne(filter) async {
    await connect();
    final result = await _collection.findOne(filter);
    return result;
  }

  Future<dynamic> edit(filter, Map<String, dynamic> data) async {
      await connect();
       var update = {};

        if (data.containsKey('name')) {
          update['name'] = data['name'];
        }

        if (data.containsKey('surname')) {
          update['surname'] = data['surname'];
        }

        if (data.containsKey('email')) {
          update['email'] = data['email'];
        }

        if (data.containsKey('birthDate')) {
          update['birthDate'] = data['birthDate'];
        }

        if (data.containsKey('password')) {
          update['password'] = data['password'];
        }
      final result = await _collection.update(filter,{'\$set': update});
      return result;
  }


  Future<dynamic> deleteUser(filter) async {
    await connect();
    final result = await _collection.findOne(filter);
    await _collection.remove(filter);
    return result;


}

Future<dynamic> insertOne(Map<String, dynamic> data) async {
    try {
      await connect();
      final result = await _collection.insertOne(data);
      if (result.isSuccess) {
        return {"insertedId": result.id};
      } else {
        return {"error": result.writeError.errmsg};
      }
    } catch (error) {
      return {"error": "Se ha produciondo error inesperado"};
    } finally {
      await close();
    }
  }


}