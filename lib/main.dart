import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApiMain(),
    );
  }
}

class ApiMain extends StatefulWidget {
  const ApiMain({Key? key}) : super(key: key);

  @override
  _ApiMainState createState() => _ApiMainState();
}

class _ApiMainState extends State<ApiMain> {

  getUserData() async{
    var response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'users'));
    var jsonData = jsonDecode(response.body);
    List<User> users = [];
    for(var u in jsonData){
      User user = User(u["name"], u["email"], u["username"], u["phone"]);
      users.add(user);
    }
    if(users.length==100){
      print("Wrong not 100");
    }
    else{
      print("This is correct");
      print(users.length);
    }
    return users;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api Data"),
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot){
                if(snapshot.data == null)
                  {
                    return Container(
                      child: Center(
                        child: Text("Loading"),
                      ),
                    );
                  }
                else {
                  var data = (snapshot.data as List<User>).toList();
                  return ListView.builder(
                      itemCount: data.length, itemBuilder: (context, i){
                    return ListTile(
                      title: Text(data[i].name),
                      subtitle: Text(data[i].username),
                      isThreeLine: true,
                      dense: false,
                        onTap: () {
                          var snackBar = SnackBar(content: Text(data[i].username));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // Scaffold
                          //     .of(context)
                          //     .showSnackBar(SnackBar(content: Text(data.toString())));
                        },
                      trailing: Text(data[i].email),
                    );
                  });
                }
              }

          )
        ),
      )
    );
  }
}

class User{
  final String name, email, username, phone;

  User(this.name, this.email, this.username, this.phone);
}