import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Note endpoint', (sessionBuilder, endpoints) {
    test('when creating a note then it is returned with title', () async {
      final note = await endpoints.note.create(
        sessionBuilder,
        'Buy milk',
        '2 percent',
      );
      expect(note.title, 'Buy milk');
      expect(note.content, '2 percent');
      expect(note.isCompleted, isFalse);
    });

    test(
      'when listing notes after creation then it contains the note',
      () async {
        await endpoints.note.create(
          sessionBuilder,
          'Test Note',
          null,
        );
        final notes = await endpoints.note.list(sessionBuilder);
        expect(notes.any((n) => n.title == 'Test Note'), isTrue);
      },
    );
  });
}
