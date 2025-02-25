import 'package:e_class/pages/common widgets/module_button.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

// ignore: must_be_immutable
class ModuleList extends StatelessWidget{
  ModuleList(this.value,this.subject,{super.key});

  String value;
  var subject;

  Future<List<Widget>> showModules(subject,value) async {
      List<Widget> availableModules=[];
      var db = await mongo.Db.create("mongodb+srv://admin_kp:admin123@cluster0.hlr4lt7.mongodb.net/e-class?retryWrites=true&w=majority");
      await db.open();
      mongo.DbCollection details;
      details = db.collection("subjects");
      print(details);
      var v = await details.findOne({'_id':subject['detailsId']});
      print(v);
      db.close();
      for(var i=0;i<v!['noOfModules'];i++){
        availableModules.add(ModuleButton(i+1,subject, v['subjectName'],value));
      }
      return availableModules;
  }
  @override
  Widget build(context){
    return  Scaffold(
      body: SizedBox(
        child: Center(
            child:Container(
                  child: FutureBuilder<List<Widget>>(
                  future: showModules(subject,value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return snapshot.data![index];
                        },
                      );
                    } else {
                      return const Text('No data');
                    }
                  },
                          ),
                ),),
          ),
    );
  }
}