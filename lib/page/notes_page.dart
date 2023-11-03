import 'package:flutter/material.dart';
import '../db/notes_database.dart';
import '../model/note.dart';
import '../page/edit_note_page.dart';
import '../widget/note_card_widget.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}
class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshNotes();
  }
  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }
  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notes',
            style: TextStyle(fontSize: 24),
          ),
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text(
                      'No Notes',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );
            refreshNotes();
          },
        ),
      );

  Widget buildNotes() => ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddEditNotePage(note: note),
              ),
            );
            refreshNotes();
          },
          child: NoteCardWidget(note: note),
        );
      },
  );
}
