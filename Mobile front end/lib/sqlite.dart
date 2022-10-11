import "dart:io" as io;
import 'package:flutter/services.dart';
import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:UIKit/Student.dart';
import 'package:UIKit/CommbookWeekly.dart';
import 'package:UIKit/CommbookMonthly.dart';
import 'package:UIKit/Subject.dart';
import 'package:UIKit/Quotes.dart';
import 'package:UIKit/Notice.dart';
import 'package:UIKit/Payment.dart';
import 'package:UIKit/Result.dart';
import 'package:UIKit/Address.dart';
import 'package:UIKit/distnictdata.dart';
import 'package:dio/dio.dart';
import 'dart:core';
import 'package:image_downloader/image_downloader.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
class SqliteDB {
  static final SqliteDB _instance = new SqliteDB.internal();
  final Connectivity _connectivity = Connectivity();
  factory SqliteDB() => _instance;
  static Database? _db;

  Future<Database?> get db async {
   if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  SqliteDB.internal();

  /// Initialize DB
  Future initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "progress.db");
    String path2 = join(documentDirectory.path, "done.db");
    var exists = await databaseExists(path2);
    var existsdb = await databaseExists(path);
    var taskDb;
    print("i am here"+exists.toString());
    if(!exists)
    {
      await  deleteDatabase(path);
    taskDb = await openDatabase(path, version: 1);
    await createTables(taskDb);
    //await getQuotes();
    }
    else{
      taskDb = await openDatabase(path, version: 1);
      //String path2 = join(documentDirectory.path, "done.db");
      //await openDatabase(path2, version: 1);
    }
    return taskDb;
  }
  Future createTables(Database dbClient) async {
    await dbClient.execute('CREATE TABLE student(StudentID INTEGER PRIMARY KEY,img TEXT,Name TEXT,Gender TEXT,GradeName TEXT,Section TEXT)');
    await dbClient.execute('CREATE TABLE address(AddID INTEGER PRIMARY KEY,FathersMobile TEXT,MothersMobile TEXT,Address TEXT,KifleKetema TEXT,Woreda TEXT,HouseNum TEXT,StudentID INTEGER,FOREIGN KEY(StudentID) REFERENCES student(StudentID))');
    await dbClient.execute('CREATE TABLE result(ResultID INTEGER PRIMARY KEY,AssesmentID INTEGER,SubjectName TEXT,Name TEXT,Value TEXT,Result TEXT,StudentID INTEGER,FOREIGN KEY(StudentID) REFERENCES student(StudentID))');
    await dbClient.execute('CREATE TABLE notice(NotificationID INTEGER PRIMARY KEY,Title TEXT,Value TEXT,Type TEXT,AssignedTo TEXT,StudentID INTEGER,Seen TEXT,FOREIGN KEY(StudentID) REFERENCES student(StudentID))');
    await dbClient.execute('CREATE TABLE commbookweekly(CommbookID INTEGER PRIMARY KEY,CommitemID TEXT,StudentID INTEGER,Value TEXT,WeekID TEXT,WeekName TEXT,commitem TEXT,FOREIGN KEY(StudentID) REFERENCES student(StudentID))');
    await dbClient.execute('CREATE TABLE commbookmonthly(CommbookID INTEGER PRIMARY KEY,CommitemID TEXT,StudentID INTEGER,Value TEXT,Month TEXT,MonthName TEXT,commitem TEXT,FOREIGN KEY(StudentID) REFERENCES student(StudentID))');
    await dbClient.execute('CREATE TABLE payment(PaymentID INTEGER PRIMARY KEY,AcYear TEXT,Month TEXT,Bank TEXT,Amount TEXT,Payment TEXT,Stamp TEXT,StudentID INTEGER,FOREIGN KEY(StudentID) REFERENCES student(StudentID))');
    await dbClient.execute('CREATE TABLE quote(QuoteID INTEGER PRIMARY KEY,Author TEXT,Quote TEXT)');
    //print("Db Created:");
  }
  /// Count number of tables in DB
    iniData(mobNum,permissionGranted) async{
    //ConnectivityResult connectivityResult = await _connectivity.checkConnectivity();
   // if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
   // {
      /*io.Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, "progress.db");
      var existsdb = await databaseExists(path);
      if(existsdb)
      {
        await  deleteDatabase(path);
      }*/
      int success = 0;
      if(permissionGranted == true)
    {success = await getData(mobNum);}
      else
        {success = await getDataNopermission(mobNum);}
    if(success == 1)
      {
    await getQuotes();
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "done.db");
    await openDatabase(path, version: 1);
      }
   //}
  }
 Future<int> getData(String mobNum) async {
    try {
      var response = await Dio().get(
          "https://ascoprogress.com/progress_api/studentreception.php?gmnum=" +
              mobNum);
      var data = response.data;
      int res = 1;
      int pay = 1;
      for (int j = 0; j < data.length; j++) {
        var st = new Student(
          StudentID: int.parse(data[j]['StudentID']),
          img: data[j]['img'],
          Name: data[j]['Name'],
          Gender: data[j]['Gender'],
          GradeName: data[j]['GradeName'],
          Section: data[j]['Section'],
        );
        await insertStudent(st);
        await getimg(st.StudentID.toString());
        var ad = new Addresses(
          AddID: int.parse(data[j]['address'][0]['AddID']),
          FathersMobile: data[j]['address'][0]['FathersMobile'],
          MothersMobile: data[j]['address'][0]['MothersMobile'],
          Address: data[j]['address'][0]['Address'],
          KifleKetema: data[j]['address'][0]['KifleKetema'],
          Woreda: data[j]['address'][0]['Woreda'],
          HouseNum: data[j]['address'][0]['HouseNum'],
          StudentID: int.parse(data[j]['StudentID']),
        );
        await insertAddress(ad);

        //List<Results> res = [];
        for (int i = 0; i < data[j]['result'].length; i++) {
          Results resdata = new Results(
            ResultID:int.parse(data[j]['result'][i]['ResultID']),
            AssesmentID: data[j]['result'][i]['AssesmentID'],
            SubjectName: data[j]['result'][i]['SubjectName'],
            Name: data[j]['result'][i]['Name'],
            Value: data[j]['result'][i]['Value'],
            Result: data[j]['result'][i]['Result'],
            StudentID: int.parse(data[j]['StudentID']),
          );
          //print(resdata.toString());
          // res.add(resdata);
          await insertResult(resdata);
        }
        print("I am here res");
       // print(data[j]['result'].length);
        //List<Notice> notice=[];
        for (int i = 0; i < data[j]['notice'].length; i++) {
          Notice noticedata = new Notice(
            NotificationID: res,
            Title: data[j]['notice'][i]['Title'],
            Value: data[j]['notice'][i]['Value'],
            Type: data[j]['notice'][i]['Type'],
            AssignedTo: data[j]['notice'][i]['AssignedTo'],
            StudentID: int.parse(data[j]['StudentID']),
            Seen: "NEW !!",
          );
          res++;
          //notice.add(noticedata);
          //print(noticedata.toString());
          await insertNotice(noticedata);
        }
        print("I am here not");
        //List<Commbookmonthly> commmonth=[];
        for (int i = 0; i < data[j]['combookmonthly'].length; i++) {
          var commmonthly = new Commbookmonthly(
              CommbookID: int.parse(data[j]['combookmonthly'][i]['CommbookID']),
              CommitemID: data[j]['combookmonthly'][i]['CommitemID'],
              StudentID: int.parse(data[j]['combookmonthly'][i]['StudentID']),
              Value: data[j]['combookmonthly'][i]['Value'],
              Month: data[j]['combookmonthly'][i]['Month'],
              MonthName: data[j]['combookmonthly'][i]['MonthName'],
              commitem: data[j]['combookmonthly'][i]['commitem']);
          //commmonth.add(commmonthly);
          await insertCommmonthly(commmonthly);
        }
        //List<Commbookweekly> commweek=[];
        for (int i = 0; i < data[j]['commbookweekly'].length; i++) {
          var commweekly = new Commbookweekly(
            CommbookID: int.parse(data[j]['commbookweekly'][i]['CommbookID']),
            CommitemID: data[j]['commbookweekly'][i]['CommitemID'],
            StudentID: int.parse(data[j]['commbookweekly'][i]['StudentID']),
            Value: data[j]['commbookweekly'][i]['Value'],
            WeekID: data[j]['commbookweekly'][i]['WeekID'],
            WeekName: data[j]['commbookweekly'][i]['WeekName'],
            commitem: data[j]['commbookweekly'][i]['commitem'],
          );
          // commweek.add(commweekly);
          await insertCommweekly(commweekly);
        }

        //List<Payments> pay=[];
        for (int i = 0; i < data[j]['payment'].length; i++) {
          var payment = new Payments(
            PaymentID: pay,
            AcYear: data[j]['payment'][i]['AcYear'],
            Month: data[j]['payment'][i]['Month'],
            Bank: data[j]['payment'][i]['Bank'],
            Amount: data[j]['payment'][i]['Amount'],
            Payment: data[j]['payment'][i]['Payment'],
            Stamp: data[j]['payment'][i]['Stamp'],
            StudentID: int.parse(data[j]['StudentID']),
          );
          pay++;
          //pay.add(payment);
          await insertPayment(payment);
        }
        print("I am here");
      }
      print("I am here");
      //print(await getAllQuotes(db));
    }
    catch(e){print(e);
    return 0;}
    return 1;
  }
  Future<int> getDataNopermission(String mobNum) async {
    try {
      var response = await Dio().get(
          "https://ascoprogress.com/progress_api/studentreception.php?gmnum=" +
              mobNum);
      var data = response.data;
      int res = 1;
      int pay = 1;
      for (int j = 0; j < data.length; j++) {
        var st = new Student(
          StudentID: int.parse(data[j]['StudentID']),
          img: data[j]['img'],
          Name: data[j]['Name'],
          Gender: data[j]['Gender'],
          GradeName: data[j]['GradeName'],
          Section: data[j]['Section'],
        );
        await insertStudent(st);
        var ad = new Addresses(
          AddID: int.parse(data[j]['address'][0]['AddID']),
          FathersMobile: data[j]['address'][0]['FathersMobile'],
          MothersMobile: data[j]['address'][0]['MothersMobile'],
          Address: data[j]['address'][0]['Address'],
          KifleKetema: data[j]['address'][0]['KifleKetema'],
          Woreda: data[j]['address'][0]['Woreda'],
          HouseNum: data[j]['address'][0]['HouseNum'],
          StudentID: int.parse(data[j]['StudentID']),
        );
        await insertAddress(ad);
        //List<Results> res = [];
        for (int i = 0; i < data[j]['result'].length; i++) {
          Results resdata = new Results(
            ResultID:int.parse(data[j]['result'][i]['ResultID']),
            AssesmentID: data[j]['result'][i]['AssesmentID'],
            SubjectName: data[j]['result'][i]['SubjectName'],
            Name: data[j]['result'][i]['Name'],
            Value: data[j]['result'][i]['Value'],
            Result: data[j]['result'][i]['Result'],
            StudentID: int.parse(data[j]['StudentID']),
          );
          //print(resdata.toString());
          // res.add(resdata);
          await insertResult(resdata);
        }
        // print(data[j]['result'].length);
        //List<Notice> notice=[];
        var len = await getNoticeByStudent(int.parse(data[j]['StudentID']));
        int counter = len.length;
        String seen = "Seen";
        for (int i = 0; i < data[j]['notice'].length; i++) {

            if(counter < 1)
              {
                seen = "NEW !!";
              }
            Notice noticedata = new Notice(
            NotificationID: res,
            Title: data[j]['notice'][i]['Title'],
            Value: data[j]['notice'][i]['Value'],
            Type: data[j]['notice'][i]['Type'],
            AssignedTo: data[j]['notice'][i]['AssignedTo'],
            StudentID: int.parse(data[j]['StudentID']),
            Seen: seen,
          );
          res++;
          counter--;
          //notice.add(noticedata);
          //print(noticedata.toString());
          await insertNotice(noticedata);
        }
        //List<Commbookmonthly> commmonth=[];
        for (int i = 0; i < data[j]['combookmonthly'].length; i++) {
          var commmonthly = new Commbookmonthly(
              CommbookID: int.parse(data[j]['combookmonthly'][i]['CommbookID']),
              CommitemID: data[j]['combookmonthly'][i]['CommitemID'],
              StudentID: int.parse(data[j]['combookmonthly'][i]['StudentID']),
              Value: data[j]['combookmonthly'][i]['Value'],
              Month: data[j]['combookmonthly'][i]['Month'],
              MonthName: data[j]['combookmonthly'][i]['MonthName'],
              commitem: data[j]['combookmonthly'][i]['commitem']);
          //commmonth.add(commmonthly);
          await insertCommmonthly(commmonthly);
        }
        //List<Commbookweekly> commweek=[];
        for (int i = 0; i < data[j]['commbookweekly'].length; i++) {
          var commweekly = new Commbookweekly(
            CommbookID: int.parse(data[j]['commbookweekly'][i]['CommbookID']),
            CommitemID: data[j]['commbookweekly'][i]['CommitemID'],
            StudentID: int.parse(data[j]['commbookweekly'][i]['StudentID']),
            Value: data[j]['commbookweekly'][i]['Value'],
            WeekID: data[j]['commbookweekly'][i]['WeekID'],
            WeekName: data[j]['commbookweekly'][i]['WeekName'],
            commitem: data[j]['commbookweekly'][i]['commitem'],
          );
          // commweek.add(commweekly);
          await insertCommweekly(commweekly);
        }
        //List<Payments> pay=[];
        for (int i = 0; i < data[j]['payment'].length; i++) {
          var payment = new Payments(
            PaymentID: pay,
            AcYear: data[j]['payment'][i]['AcYear'],
            Month: data[j]['payment'][i]['Month'],
            Bank: data[j]['payment'][i]['Bank'],
            Amount: data[j]['payment'][i]['Amount'],
            Payment: data[j]['payment'][i]['Payment'],
            Stamp: data[j]['payment'][i]['Stamp'],
            StudentID: int.parse(data[j]['StudentID']),
          );
          pay++;
          //pay.add(payment);
          await insertPayment(payment);
        }
      }
      //print(await getAllNotice());
      //print(await getAllQuotes(db));
    }
    catch(e){print(e);
    return 0;}
    return 1;
  }
   getQuotes() async
  {
    try {
      var response = await Dio().get(
          "https://ascoprogress.com/progress_api/quotereception.php?all=1");
      var data = response.data;
      List<Quotes> quote = [];
      for (int j = 0; j < data.length; j++) {
        var quoteitem = new Quotes(
            QuoteID: int.parse(data[j]['QuoteID']),
            Author: data[j]['Author'],
            Quote: data[j]['Quote']);
        quote.add(quoteitem);
        await insertQuote(quoteitem);
      }
      //print(quote[1].toString());
    }
    catch(e){print(e);}
  }
  Future<void> getimg(String StudentID) async
  {
    try {

      io.Directory documentDirectory = await getApplicationDocumentsDirectory();
      String inipath = "/storage/emulated/0"+documentDirectory.path;
      String path =join(inipath, "photo/"+StudentID+".png");
     // print("the path...."+path);
      //if(pemission.isGranted)
        //{
      io.File direct = new io.File(path);

      if(await direct.exists())
        {
          await direct.delete();
        }
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage("https://ascoprogress.com/progress_api/upload/"+StudentID+".png",destination: AndroidDestinationType.custom( directory: documentDirectory.path)
        ..subDirectory("photo/"+StudentID+".png"));
      if (imageId == null) {
        print("permission"+imageId.toString());
        //return ;
      }
      //print("stored"+imageId.toString());
    } on PlatformException catch (error) {
      //print(error);
    }
      // Below is a method of obtaining saved image information.
  }
  Future<void> insertStudent(Student st) async {
    var dbClient = await db;
    await dbClient!.insert(
      'student',
      st.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> insertAddress(Addresses ad) async {
    var dbClient = await db;
    await dbClient!.insert(
      'address',
      ad.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Addresses>> getAddressByStudent(int? StudentID) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT * FROM address WHERE StudentID="+StudentID.toString());
    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return Addresses(
        AddID: maps[i]['AddID'],
        FathersMobile: maps[i]['FathersMobile'],
        MothersMobile: maps[i]['MothersMobile'],
        Address: maps[i]['Address'],
        KifleKetema: maps[i]['KifleKetema'],
        Woreda:maps[i]['Woreda'],
        HouseNum:maps[i]['HouseNum'],
        StudentID:maps[i]['StudentID'],
      );
    });
  }

  Future<void> insertResult(Results res) async {
    var dbClient = await db;
    await dbClient!.insert(
      'result',
      res.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Results>> getResultByStudent(int? StudentID) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT * FROM result WHERE StudentID="+StudentID.toString()+" ORDER BY ResultID DESC");

    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return Results(
        ResultID: maps[i]['ResultID'],
        AssesmentID: maps[i]['AssesmentID'].toString(),
        SubjectName: maps[i]['SubjectName'],
        Name: maps[i]['Name'],
        Value: maps[i]['Value'],
        Result: maps[i]['Result'],
        StudentID:maps[i]['StudentID'],
      );
    });
  }
  Future<List<Results>> getResultByStudentRecent(int? StudentID) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT * FROM result WHERE StudentID="+StudentID.toString()+" ORDER BY ResultID DESC LIMIT 7");

    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return Results(
        ResultID: maps[i]['ResultID'],
        AssesmentID: maps[i]['AssesmentID'].toString(),
        SubjectName: maps[i]['SubjectName'],
        Name: maps[i]['Name'],
        Value: maps[i]['Value'],
        Result: maps[i]['Result'],
        StudentID:maps[i]['StudentID'],
      );
    });
  }
  Future<List<Results>> getResultByStudentandSubject(int? StudentID,String Subject) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT * FROM result WHERE StudentID="+StudentID.toString()+" and SubjectName ='"+ Subject +"' ORDER BY AssesmentID ASC");

    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return Results(
        ResultID: maps[i]['ResultID'],
        AssesmentID: maps[i]['AssesmentID'].toString(),
        SubjectName: maps[i]['SubjectName'],
        Name: maps[i]['Name'],
        Value: maps[i]['Value'],
        Result: maps[i]['Result'],
        StudentID:maps[i]['StudentID'],
      );
    });
  }
  sendmonthlyfeedback(String? sid,String? mid, String? val) async
  {
    try {
      var url = Uri.parse("https://ascoprogress.com/progress_api/feedbackreception.php?add=1&sid="+sid!+"&mid="+mid!+"&val="+val!);
       await http.get(url);
       print(url);
    }
    catch(e){print(e);}
  }
  sendweeklyfeedback(String? sid,String? wid,String? val) async
  {
    try {
      var url = Uri.parse("https://ascoprogress.com/progress_api/feedbackreception.php?add=2&sid="+sid!+"&wid="+wid!+"&val="+val!);
      await http.get(url);
      print(url);
    }
    catch(e){print(e);}
  }
  Future<List<Subject>> getSubjects(int? StudentID) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT  SubjectName, SUM(CAST(Value AS double)) as completed FROM result WHERE StudentID="+StudentID.toString()+" GROUP BY SubjectName");
    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return Subject(
        SubjectName: maps[i]['SubjectName'],
        Completed: maps[i]['completed'],
      );
    });
  }
  Future<void> insertNotice(Notice notice) async {
    var dbClient = await db;
    await dbClient!.insert(
      'notice',
      notice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Notice>> getNoticeByStudent(int? StudentID) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT * FROM notice WHERE StudentID="+StudentID.toString()+" ORDER BY NotificationID DESC");
    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return Notice(
        NotificationID: maps[i]['NotificationID'],
        StudentID: maps[i]['StudentID'],
        Title: maps[i]['Title'],
        Value: maps[i]['Value'],
        Type: maps[i]['Type'],
        AssignedTo:maps[i]['AssignedTo'],
        Seen:maps[i]['Seen'],
      );
    });
  }
  void UpdateSeen(int? StudentID) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("UPDATE `notice` SET Seen='Seen' WHERE StudentID="+StudentID.toString());
    // Convert the List<Map<String, dynamic> into a List<student>.
  }
  Future<void> insertCommmonthly(Commbookmonthly commmonthly) async {
    var dbClient = await db;
    await dbClient!.insert(
      'commbookmonthly',
      commmonthly.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Commbookmonthly>> getMonthlyCommByStudent(int? StudentID) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT * FROM commbookmonthly WHERE StudentID="+StudentID.toString()+" ORDER BY Month ASC, CommitemID");

    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return Commbookmonthly(
        CommbookID: maps[i]['CommbookID'],
        StudentID: maps[i]['StudentID'],
        CommitemID: maps[i]['CommitemID'],
        Value: maps[i]['Value'],
        Month: maps[i]['Month'],
        MonthName:maps[i]['MonthName'],
        commitem:maps[i]['commitem'],
      );
    });
  }
  Future<List<distnictdata>> getDistnictMonthlyCommByStudent(int? StudentID) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT DISTINCT MonthName FROM commbookmonthly WHERE StudentID="+StudentID.toString()+" ORDER BY Month DESC, CommitemID");

    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return distnictdata(
        val:  maps[i]['MonthName']
      );
    });
  }
  Future<List<Commbookmonthly>> getMonthlyCommByStudentandMonth(int? StudentID,String Month) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT * FROM commbookmonthly WHERE StudentID="+StudentID.toString()+" and MonthName='"+ Month +"' ORDER BY Month ASC, CommitemID");

    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return Commbookmonthly(
        CommbookID: maps[i]['CommbookID'],
        StudentID: maps[i]['StudentID'],
        CommitemID: maps[i]['CommitemID'],
        Value: maps[i]['Value'],
        Month: maps[i]['Month'],
        MonthName:maps[i]['MonthName'],
        commitem:maps[i]['commitem'],
      );
    });
  }
  Future<void> insertCommweekly(Commbookweekly commweekly) async {
    var dbClient = await db;
    await dbClient!.insert(
      'commbookweekly',
      commweekly.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Commbookweekly>> getWeeklyCommByStudent(int? StudentID) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT * FROM commbookweekly WHERE StudentID="+StudentID.toString()+" ORDER BY WeekID ASC, CommbookID");

    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return Commbookweekly(
        CommbookID: maps[i]['CommbookID'],
        StudentID: maps[i]['StudentID'],
        CommitemID: maps[i]['CommitemID'],
        Value: maps[i]['Value'],
        WeekID: maps[i]['WeekID'],
        WeekName:maps[i]['WeekName'],
        commitem:maps[i]['commitem'],
      );
    });
  }
  Future<List<distnictdata>> getDistnictWeeklyCommByStudent(int? StudentID) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT DISTINCT WeekName  FROM commbookweekly WHERE StudentID="+StudentID.toString()+" ORDER BY WeekID DESC");
    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return distnictdata(
          val:  maps[i]['WeekName']
      );
    });
  }
  Future<List<Commbookweekly>> getWeeklyCommByStudentandWeek(int? StudentID,String Week) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT * FROM commbookweekly WHERE StudentID="+StudentID.toString()+" and WeekName='"+ Week +"' ORDER BY WeekID ASC, CommitemID");
    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return Commbookweekly(
        CommbookID: maps[i]['CommbookID'],
        StudentID: maps[i]['StudentID'],
        CommitemID: maps[i]['CommitemID'],
        Value: maps[i]['Value'],
        WeekID: maps[i]['WeekID'],
        WeekName:maps[i]['WeekName'],
        commitem:maps[i]['commitem'],
      );
    });
  }
  Future<void> insertPayment(Payments pay) async {
    var dbClient = await db;
    await dbClient!.insert(
      'payment',
      pay.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Payments>> getPaymentByStudent(int? StudentID) async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.rawQuery("SELECT * FROM payment WHERE StudentID="+StudentID.toString()+" ORDER BY Stamp ASC");

    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i) {
      return Payments(
        PaymentID: maps[i]['PaymentID'],
        AcYear: maps[i]['AcYear'],
        Month: maps[i]['Month'],
        Bank: maps[i]['Bank'],
        Amount: maps[i]['Amount'],
        Payment: maps[i]['Payment'],
        Stamp:maps[i]['Stamp'],
        StudentID:maps[i]['StudentID'],
      );
    });
  }

  Future<void> insertQuote(Quotes quote) async {
    var dbClient = await db;
    await dbClient!.insert(
      'quote',
      quote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Student>> getAllStudents() async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.query('student');

    // Convert the List<Map<String, dynamic> into a List<student>.
    return List.generate(maps.length, (i)  {
      return Student(
        StudentID: maps[i]['StudentID'],
        img: "img",
        Name: maps[i]['Name'],
        Gender: maps[i]['Gender'],
        GradeName: maps[i]['GradeName'],
        Section:maps[i]['Section'],
      );
    });
  }
  Future<List <Quotes>> getAllQuotes() async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.query('quote');
    // Convert the List<Map<String, dynamic> into a List<student>.
    List <Quotes> quot = List.generate(maps.length, (i) {
      return Quotes(
        QuoteID: maps[i]['QuoteID'],
        Author: maps[i]['Author'],
        Quote: maps[i]['Quote'],
      );
    });
    return quot;
  }
  Future<List <Results>> getAllNotice() async {
    var dbClient = await db;
    // Query the table for all The Students.
    final List<Map<String, dynamic>> maps = await dbClient!.query('result');
    // Convert the List<Map<String, dynamic> into a List<student>.
    List <Results> quot = List.generate(maps.length, (i) {
      return Results(
        ResultID: maps[i]['ResultID'],
        AssesmentID: maps[i]['AssesmentID'].toString(),
        SubjectName: maps[i]['SubjectName'],
        Name: maps[i]['Name'],
        Value: maps[i]['Value'],
        Result: maps[i]['Result'],
        StudentID:maps[i]['StudentID'],
      );
    });
    return quot;
  }

}