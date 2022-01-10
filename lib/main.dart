import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String input = '';
  bool isChecked = false;
  Color back = Color(0xFFBB000B);

  var shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
  );
  Color mid = Colors.white;
  AssetImage imgused = AssetImage('assets/todo.png');
  AssetImage img = AssetImage('assets/r.png');
  Createtodos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Mytodos").doc(input);
    Map<String, String> todos = {"input": input};
    documentReference.set(todos).whenComplete(() => print("$input created"));
  }

  Deletetodos(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Mytodos").doc(item);
    documentReference.delete().whenComplete(() => print("$item deleted"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mid,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 30.0,
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              image: DecorationImage(
                image: img,
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                  child: Image(
                fit: BoxFit.cover,
                image: imgused,
                height: 50.0,
              )),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            padding: EdgeInsets.only(bottom: 30.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: img,
                fit: BoxFit.cover,
              ),
              color: back,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("Mytodos")
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.hasData) {
                    if (snapshots.data!.docs.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(60, 200, 60, 170),
                        child: MaterialButton(
                          height: 40.0,
                          shape: shape,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.add,
                                color: back,
                                size: 50,
                              ),
                              Text(
                                "No tasks yet...\n\nAdd new task?",
                                style: TextStyle(color: back),
                              ),
                            ],
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: shape,
                                    title: Text(
                                      "Add todo",
                                      style: TextStyle(
                                        color: back,
                                      ),
                                    ),
                                    content: TextField(
                                      autofocus: true,
                                      onChanged: (value) {
                                        input = value;
                                      },
                                    ),
                                    actions: [
                                      MaterialButton(
                                        shape: shape,
                                        color: back,
                                        onPressed: () {
                                          Createtodos();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Add",
                                          style: TextStyle(
                                            color: mid,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          },
                        ),
                      );
                    } else {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot<Map<String, dynamic>>
                                documentSnapshot = snapshots.data!.docs[index];
                            return Dismissible(
                              onDismissed: (direction) {
                                Deletetodos(
                                    documentSnapshot.data()["input"] ?? '');
                              },
                              key: Key(documentSnapshot.data()["input"] ?? ''),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Card(
                                  shape: shape,
                                  color: mid,
                                  borderOnForeground: true,
                                  elevation: 20.0,
                                  child: ListTile(
                                      trailing: MaterialButton(
                                        shape: CircleBorder(),
                                        height: 40.0,
                                        minWidth: 40.0,
                                        child: Icon(
                                          Icons.delete,
                                          color: back,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: shape,
                                                  title: Text(
                                                    "Confirm Delete task \"${documentSnapshot.data()["input"] ?? ''}\" ?",
                                                    style: TextStyle(
                                                      color: back,
                                                    ),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        MaterialButton(
                                                          shape: shape,
                                                          color: back,
                                                          onPressed: () {
                                                            Deletetodos(
                                                                documentSnapshot
                                                                            .data()[
                                                                        "input"] ??
                                                                    '');
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                              color: mid,
                                                            ),
                                                          ),
                                                        ),
                                                        MaterialButton(
                                                          shape: shape,
                                                          color: back,
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color: mid,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                      title: Row(
                                        children: [
                                          /*Checkbox(
                                            value: isChecked,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked = value!;
                                              });
                                            },
                                          ),*/
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Text(
                                            documentSnapshot.data()["input"] ??
                                                '',
                                            style: TextStyle(color: back),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            );
                          });
                    }
                  } else {
                    return Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          )),
          SizedBox(
            height: 20.0,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: MaterialButton(
                      height: 40.0,
                      shape: shape,
                      color: back,
                      child: Text(
                        "Change theme",
                        style: TextStyle(color: mid),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  shape: shape,
                                  title: Text(
                                    'Change the theme to...',
                                    style: TextStyle(
                                      color: back,
                                    ),
                                  ),
                                  actions: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                img =
                                                    AssetImage('assets/r.png');
                                                back = Color(0xFFBB000B);
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                "Cherry Red",
                                                style: TextStyle(
                                                    color: Color(0xFFBB000B),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                img =
                                                    AssetImage('assets/g.png');
                                                back = Color(0xFF004422);
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                "Royal Green",
                                                style: TextStyle(
                                                    color: Color(0xFF004422),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                back = Color(0xFF000744);
                                                img =
                                                    AssetImage('assets/bl.png');
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                "Beast Blue",
                                                style: TextStyle(
                                                    color: Color(0xFF000744),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                img =
                                                    AssetImage('assets/b.png');
                                                back = Colors.black;
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                "Bad Black",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                img =
                                                    AssetImage('assets/p.png');
                                                back = Color(0xFF35004B);
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                "Violent Violet",
                                                style: TextStyle(
                                                    color: Color(0xFF35004B),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 20.0,
                                        )
                                      ],
                                    )
                                  ]);
                            });
                      },
                    )),
                Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: MaterialButton(
                    height: 40.0,
                    shape: shape,
                    color: back,
                    child: Text(
                      "Add new task",
                      style: TextStyle(color: mid),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: shape,
                              title: Text(
                                "Add todo",
                                style: TextStyle(
                                  color: back,
                                ),
                              ),
                              content: TextField(
                                autofocus: true,
                                onChanged: (value) {
                                  input = value;
                                },
                              ),
                              actions: [
                                MaterialButton(
                                  shape: shape,
                                  color: back,
                                  onPressed: () {
                                    Createtodos();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                      color: mid,
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                  ),
                ), //add right Widget here with padding right
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }
}
