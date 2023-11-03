import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/note.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    Key? key,
    required this.note,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.yMMMd().format(note.createdTime);

    return Card(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              note.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              note.description,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


