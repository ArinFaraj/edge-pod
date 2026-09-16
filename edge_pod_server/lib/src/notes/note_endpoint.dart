import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class NoteEndpoint extends Endpoint {
  Future<Note> create(Session session, String title, String? content) async {
    final note = Note(
      title: title,
      content: content,
      isCompleted: false,
      createdAt: DateTime.now().toUtc(),
    );
    return Note.db.insertRow(session, note);
  }

  Future<List<Note>> list(Session session) async {
    return Note.db.find(
      session,
      orderByList: (t) => [t.createdAt.desc()],
    );
  }

  Future<Note?> toggle(Session session, int id) async {
    final note = await Note.db.findById(session, id);
    if (note == null) {
      return null;
    }
    final updated = note.copyWith(isCompleted: !note.isCompleted);
    return Note.db.updateRow(session, updated);
  }

  Future<bool> delete(Session session, int id) async {
    final deleted = await Note.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id),
    );
    return deleted.isNotEmpty;
  }
}
