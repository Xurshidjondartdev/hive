import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_shared_pref/models/note_model.dart';
import 'package:learn_shared_pref/service/hive_service.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  void _deleteAllData() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete all data?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await HiveService.clearAll(key: LocaleKey.noteKey);
              setState(() {
                listNotes.clear();
              });
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  TextEditingController controllerNote = TextEditingController();
  TextEditingController controllerBody = TextEditingController();

  String textNote = 'title';
  String textBody = 'note';
  int id = 0;
  String textDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

  List<NoteModel> listNotes = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    List<NoteModel> loadedNotes =
        await HiveService.loadData(key: LocaleKey.noteKey);
    setState(() {
      listNotes = loadedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Note App'),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteAllData,
            ),
          ],
        ),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: listNotes.length,
            itemBuilder: (_, index) {
              return Card(
                child: ListTile(
                  title: Text(listNotes[index].title),
                  subtitle: Text(listNotes[index].text),
                  trailing: Text('${DateTime.now()}'),
                  leading: Text(listNotes[index].id.toString()),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          onSubmitted: (String value) {
                            textBody = value;
                            setState(() {});
                          },
                          textAlign: TextAlign.left,
                          showCursor: true,
                          textCapitalization: TextCapitalization.sentences,
                          controller: controllerBody,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onTap: () {},
                          decoration: const InputDecoration(
                            hintText: " Enter your Notes",
                            hintStyle: TextStyle(color: Colors.blueGrey),
                            label: Text('notes'),
                            labelStyle: TextStyle(color: Colors.blueGrey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          onSubmitted: (String value) {
                            textNote = value;
                            setState(() {});
                          },
                          textAlign: TextAlign.left,
                          showCursor: true,
                          textCapitalization: TextCapitalization.sentences,
                          controller: controllerNote,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onTap: () {},
                          decoration: const InputDecoration(
                            hintText: " Enter your Notes body",
                            hintStyle: TextStyle(color: Colors.blueGrey),
                            label: Text('notes body'),
                            labelStyle: TextStyle(color: Colors.blueGrey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ]),
                  actions: [
                    Text(DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(DateTime.now())),
                    IconButton(
                      onPressed: () {
                        listNotes.length + 1;
                        listNotes.add(NoteModel(
                          id: listNotes.length+1,
                          title: controllerNote.text.toString(),
                          text: controllerBody.text.toString(),
                          // createdTime: DateTime.now(),
                        ));
                        setState(() {});
                        HiveService.saveData(listNotes, key: LocaleKey.noteKey);
                        Navigator.pop(context);
                        controllerNote.clear();
                        controllerBody.clear();
                      },
                      icon: const Icon(Icons.done),
                    )
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}
