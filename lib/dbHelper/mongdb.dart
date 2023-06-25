import 'package:mongo_dart/mongo_dart.dart';
import 'package:zest_front_house/constants/constants.dart';

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_DB_URL);
    await db.open();
    userCollection = db.collection(USER_COLLECTION);
  }
}