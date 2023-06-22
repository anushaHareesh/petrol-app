
import 'package:path/path.dart';
import 'package:petrol/model/registration_model.dart';
import 'package:sqflite/sqflite.dart';


class PetrolApp {
  static final PetrolApp instance = PetrolApp._init();
  static Database? _database;
  PetrolApp._init();
  //////////////////////////////////////

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("serviceapp.db");
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(
      path,
      version: 1, onCreate: _createDB,
      // onUpgrade: _upgradeDB
    );
  }

  Future _createDB(Database db, int version) async {
    ///////////////barcode store table ////////////////

    await db.execute('''
          CREATE TABLE companyRegistrationTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cid TEXT NOT NULL,
            fp TEXT NOT NULL,
            os TEXT NOT NULL,
            type TEXT,
            app_type TEXT,
            cpre TEXT,
            ctype TEXT,
            cnme TEXT,
            ad1 TEXT,
            ad2 TEXT,
            ad3 TEXT,
            pcode TEXT,
            land TEXT,
            mob TEXT,
            em TEXT,
            gst TEXT,
            ccode TEXT,
            scode TEXT,
            msg TEXT
          )
          ''');

// ////////////// registration table ////////////
    await db.execute('''
          CREATE TABLE staffDetailsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sid TEXT NOT NULL,
            sname TEXT,
            uname TEXT,
            pwd TEXT,
            ad1 TEXT,
            ad2 TEXT,
            ad3 TEXT,
            ph TEXT,
            area TEXT    
          )
          ''');
    await db.execute('''
          CREATE TABLE settingsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            set_id INTEGER NOT NULL,
            set_code TEXT,
            set_value TEXT,
            set_type INTEGER  
          )
          ''');
    await db.execute('''
          CREATE TABLE enquiryTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itemName TEXT NOT NULL,
            code TEXT,
            qty REAL,
            rate REAL,
            totalamount REAL,
            enqdate TEXT,
            enqtime TEXT,
            cartrowno INTEGER
          )
          ''');
  }

/////////////////////////////////////////////////////////////////////////
  Future insertRegistrationDetails(RegistrationData data) async {
    final db = await database;
    var query1 =
        'INSERT INTO companyRegistrationTable(cid, fp, os, type, app_type, cpre, ctype, cnme, ad1, ad2, ad3, pcode, land, mob, em, gst, ccode, scode, msg) VALUES("${data.cid}", "${data.fp}", "${data.os}","${data.type}","${data.apptype}","${data.c_d![0].cpre}", "${data.c_d![0].ctype}", "${data.c_d![0].cnme}", "${data.c_d![0].ad1}", "${data.c_d![0].ad2}", "${data.c_d![0].ad3}", "${data.c_d![0].pcode}", "${data.c_d![0].land}", "${data.c_d![0].mob}", "${data.c_d![0].em}", "${data.c_d![0].gst}", "${data.c_d![0].ccode}", "${data.c_d![0].scode}", "${data.msg}" )';
    var res = await db.rawInsert(query1);
    print(query1);
    print("registered ----$res");
    return res;
  }

////////////////////////////////////////////////////////////////////////
  // Future insertsettingsTable(SettingsModel model) async {
  //   final db = await database;
  //   // deleteFromTableCommonQuery('menuTable', "");
  //   var query1 =
  //       'INSERT INTO settingsTable(set_id,set_code,set_value,set_type) VALUES(${model.setId},"${model.setCode}","${model.setValue}",${model.setType})';
  //   var res = await db.rawInsert(query1);
  //   // print("menu----${query1}");
  //   print("settingzz---${query1}");
  //   // print(res);
  //   return res;
  // }

  //////////////////////////////////////////////////////////////
  // Future insertStaffDetails(StaffDetails sdata) async {
  //   final db = await database;
  //   var query2 =
  //       'INSERT INTO staffDetailsTable(sid, sname, uname, pwd, ad1, ad2, ad3, ph, area) VALUES("${sdata.sid}", "${sdata.sname}", "${sdata.unme}", "${sdata.pwd}", "${sdata.ad1}", "${sdata.ad2}", "${sdata.ad3}", "${sdata.ph}", "${sdata.area}")';
  //   var res = await db.rawInsert(query2);
  //   print(query2);
  //   // print(res);
  //   return res;
  // }

  //////////////////////////////////////////////////////////////////////////////
  Future insertEnqTable(
    String itemName,
    String code,
    double qty,
    double rate,
    double totalamount,
    String enqdate,
    String enqtime,
    int cartrowno,
  ) async {
    print("qty--$qty");
    print("code...........$code");
    final db = await database;
    var res;

    List<Map<String, dynamic>> res1 =
        await db.rawQuery('SELECT  * FROM enquiryTable WHERE code="$code"');
    print("SELECT from ---$res1");

    if (res1.length == 1) {
      int qty1 = res1[0]["qty"];
      double updatedQty = qty1 + qty;
      double amount = res1[0]["totalamount"];
      double updatedAmount = amount + totalamount;
      var quer =
          'UPDATE enquiryTable SET qty=$updatedQty , totalamount="$updatedAmount" WHERE code="$code"';
      // ignore: avoid_print
      print("updateion query-------$quer");
      res = await db.rawUpdate(quer);
    } else {
      var query2 =
          'INSERT INTO enquiryTable (itemName, code, qty, rate, totalamount, cartdate, carttime ,cartrowno) VALUES ("$itemName","$code", $qty, $rate, $totalamount, "$enqdate}","$enqtime",  $cartrowno, )';
      res = await db.rawInsert(query2);
      // ignore: avoid_print
      print("updateion query-------$query2");
    }
    return res;
  }

////////////////////////////////////////////////////////////////////////////////
  deleteFromTableCommonQuery(String table, String? condition) async {
    // ignore: avoid_print
    print("table--condition -$table---$condition");
    Database db = await instance.database;
    if (condition == null || condition.isEmpty || condition == "") {
      // ignore: avoid_print
      print("no condition");
      await db.delete('$table');
    } else {
      // ignore: avoid_print
      print("condition");

      await db.rawDelete('DELETE FROM "$table" WHERE $condition');
    }
  }

////////////////////////////////////////////////////////////////////////////////
  selectStaff(String uname, String pwd) async {
    String result = "";
    List<String> resultList = [];
    String? sid;
    print("uname---Password----$uname--$pwd");
    resultList.clear();
    print("before kkkk $resultList");
    Database db = await instance.database;
    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT * FROM staffDetailsTable');
    for (var staff in list) {
      // print(
      //     "staff['uname'] & staff['pwd']------------------${staff['uname']}--${staff['pwd']}");
      if (uname.toLowerCase() == staff["uname"].toLowerCase() &&
          pwd == staff["pwd"]) {
        print("match");
        sid = staff['sid'];
        result = "success";

        resultList.add(result);
        resultList.add(sid!);
        break;
      } else {
        // ignore: avoid_print
        print("No match");
        result = "failed";
        sid = "";
      }
    }
    print("res===${resultList}");

    print("all data ${list}");

    return resultList;
  }

///////////////////////////////////////////////////////////////////////////////
  selectCommonQuery(String table, String? condition, String fields) async {
    List<Map<String, dynamic>> result;
    Database db = await instance.database;
    var query = "SELECT $fields FROM '$table'";
    result = await db.rawQuery(query);
    print("naaknsdJK-----$result");
    return result;
  }

  ///////////////////////////////////////////////////////////////////////////
  updateCommonQuery(String table, String fields, String condition) async {
    Database db = await instance.database;
    var query = 'UPDATE $table SET $fields WHERE $condition ';
    var res = await db.rawUpdate(query);
    return res;
  }

  ///////////////////////////////////////////////////////////////////////////
  getMaxCommonQuery(String table, String field, String? condition) async {
    var res;
    int max;
    Database db = await instance.database;
    var result = await db.rawQuery("SELECT * FROM '$table'");
    if (result != null && result.isNotEmpty) {
      var query = "SELECT MAX($field) max_val FROM '$table'";

      res = await db.rawQuery(query);

      // int convertedMax = int.parse(res[0]["max_val"]);
      max = res[0]["max_val"] + 1;
    } else {
      max = 1;
    }

    return max;
  }
}
