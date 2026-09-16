import 'package:edge_pod_client/edge_pod_client.dart';
import 'package:flutter/material.dart';

import '../client.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final items = await client.note.list();
      if (mounted) {
        setState(() {
          _notes = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addNote(String title, String? content) async {
    try {
      await client.note.create(title, content);
      await _fetchNotes();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add note: $e')),
        );
      }
    }
  }

  Future<void> _toggleNote(int id) async {
    try {
      await client.note.toggle(id);
      await _fetchNotes();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update note: $e')),
        );
      }
    }
  }

  Future<void> _deleteNote(int id) async {
    try {
      await client.note.delete(id);
      await _fetchNotes();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete note: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NoteInputSection(onAdd: _addNote),
        const Divider(height: 1),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text('Error: $_error'))
              : _notes.isEmpty
              ? const NoteEmptyState()
              : NoteList(
                  notes: _notes,
                  onToggle: _toggleNote,
                  onDelete: _deleteNote,
                ),
        ),
      ],
    );
  }
}

class NoteInputSection extends StatefulWidget {
  final Future<void> Function(String title, String? content) onAdd;

  const NoteInputSection({super.key, required this.onAdd});

  @override
  State<NoteInputSection> createState() => _NoteInputSectionState();
}

class _NoteInputSectionState extends State<NoteInputSection> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final content = _contentController.text.trim();
    setState(() {
      _isSubmitting = true;
    });

    await widget.onAdd(title, content.isEmpty ? null : content);

    if (mounted) {
      _titleController.clear();
      _contentController.clear();
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Content (optional)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _isSubmitting ? null : _submit,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
            label: const Text('Add Note'),
          ),
        ],
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final ValueChanged<int> onToggle;
  final ValueChanged<int> onDelete;

  const NoteList({
    super.key,
    required this.notes,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notes.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteTile(
          note: note,
          onToggle: onToggle,
          onDelete: onDelete,
        );
      },
    );
  }
}

class NoteTile extends StatelessWidget {
  final Note note;
  final ValueChanged<int> onToggle;
  final ValueChanged<int> onDelete;

  const NoteTile({
    super.key,
    required this.note,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final noteId = note.id;

    return ListTile(
      leading: Checkbox(
        value: note.isCompleted,
        onChanged: noteId == null ? null : (_) => onToggle(noteId),
      ),
      title: Text(
        note.title,
        style: TextStyle(
          decoration: note.isCompleted ? TextDecoration.lineThrough : null,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: note.content != null && note.content!.isNotEmpty
          ? Text(
              note.content!,
              style: TextStyle(
                decoration: note.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            )
          : null,
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: noteId == null ? null : () => onDelete(noteId),
      ),
    );
  }
}

class NoteEmptyState extends StatelessWidget {
  const NoteEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No notes yet. Add one above.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
