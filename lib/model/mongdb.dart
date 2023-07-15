import 'package:mongo_dart/mongo_dart.dart';
import 'package:zest_front_house/constants/constants.dart';
import 'package:zest_front_house/model/mongodbmodel.dart';

class MongoDatabase {
  MongoDatabase({this.admin = false});
  final bool admin;
  String MONGO_DB_URL = '';
  static dynamic db, userCollection;
  connect() async {
    if (admin) {
      MONGO_DB_URL = MONGO_DB_URL_ADMIN;
    } else {
      MONGO_DB_URL = MONGO_DB_URL_USER;
    }
    db = await Db.create(MONGO_DB_URL);
    await db.open();
    userCollection = db.collection(USER_COLLECTION);
  }

  disconnect() async {
    await db.close();
  }

  Future<String> insert(MongoDbModel data) async {
    try {
       dynamic result = await userCollection.insertOne(data.toJson());
       if (result.isSuccess) {
         return 'Data insert successfully!';
       } else {
         return 'Something is wrong while inserting the data.';
       }
    } catch(e) {
      return e.toString();
    }
  }

  Future<List<Map<String, dynamic>>> getData(var query) async {
    final dynamic arrData = await userCollection.find(query).toList();
    return arrData;
  }
}