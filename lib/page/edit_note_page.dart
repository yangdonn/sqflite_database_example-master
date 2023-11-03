import 'package:flutter/material.dart';
// import 'package:sqlite_notes/widget/note_form_widget.dart';
import '../widget/note_form_widget.dart';
import '../db/notes_database.dart';
import '../model/note.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildDeleteButton(), buildSaveButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            isImportant: isImportant,
            number: number,
            title: title,
            description: description,
            onChangedImportant: (isImportant) =>
                setState(() => this.isImportant = isImportant),
            onChangedNumber: (number) => setState(() => this.number = number),
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildDeleteButton() {
    final isUpdating = widget.note != null;

    if (isUpdating) {
      return IconButton(
        icon: Icon(Icons.delete),
        onPressed: deleteNote,
      );
    } else {
      return SizedBox.shrink(); // Hide the delete icon when creating a new note.
    }
  }

  Widget buildSaveButton() {
    return IconButton(
      icon: Icon(Icons.save),
      onPressed: addOrUpdateNote,
    );
  }

  void deleteNote() async {
    if (widget.note != null) {
      await NotesDatabase.instance.delete(widget.note!.id!);
      Navigator.of(context).pop();
    }
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;
      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
      Navigator.of(context).pop();
    }
  }
  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );
    await NotesDatabase.instance.update(note);
  }
  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: isImportant,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );
    await NotesDatabase.instance.create(note);
  }
}
