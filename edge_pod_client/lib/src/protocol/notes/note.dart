/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class Note
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Note._({
    this.id,
    required this.title,
    this.content,
    required this.isCompleted,
    required this.createdAt,
  });

  factory Note({
    int? id,
    required String title,
    String? content,
    required bool isCompleted,
    required DateTime createdAt,
  }) = _NoteImpl;

  factory Note.fromJson(Map<String, dynamic> jsonSerialization) {
    return Note(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String?,
      isCompleted: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isCompleted'],
      ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String? content;

  bool isCompleted;

  DateTime createdAt;

  /// Returns a shallow copy of this [Note]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Note copyWith({
    int? id,
    String? title,
    String? content,
    bool? isCompleted,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Note',
      if (id != null) 'id': id,
      'title': title,
      if (content != null) 'content': content,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Note',
      if (id != null) 'id': id,
      'title': title,
      if (content != null) 'content': content,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NoteImpl extends Note {
  _NoteImpl({
    int? id,
    required String title,
    String? content,
    required bool isCompleted,
    required DateTime createdAt,
  }) : super._(
         id: id,
         title: title,
         content: content,
         isCompleted: isCompleted,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Note]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Note copyWith({
    Object? id = _Undefined,
    String? title,
    Object? content = _Undefined,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Note(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      content: content is String? ? content : this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
