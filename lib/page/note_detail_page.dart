import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/notes_database.dart';
import '../model/note.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: isLoading
      ? const Center(child: CircularProgressIndicator())
      : Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            Text(
              note.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat.yMMMd().format(note.createdTime),
              style: const TextStyle(color: Colors.black38),
            ),
            const SizedBox(height: 8),
            Text(
              note.description,
              style:
                const TextStyle(color: Colors.black87, fontSize: 18),
            )
          ],
        ),
      ),
  );
}
