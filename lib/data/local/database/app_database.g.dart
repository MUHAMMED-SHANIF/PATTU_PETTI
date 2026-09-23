// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalProfilesTable extends LocalProfiles
    with TableInfo<$LocalProfilesTable, LocalProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _isLoggedInMeta = const VerificationMeta(
    'isLoggedIn',
  );
  @override
  late final GeneratedColumn<bool> isLoggedIn = GeneratedColumn<bool>(
    'is_logged_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_logged_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    displayName,
    email,
    avatarPath,
    role,
    isLoggedIn,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('is_logged_in')) {
      context.handle(
        _isLoggedInMeta,
        isLoggedIn.isAcceptableOrUnknown(
          data['is_logged_in']!,
          _isLoggedInMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      isLoggedIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_logged_in'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalProfilesTable createAlias(String alias) {
    return $LocalProfilesTable(attachedDatabase, alias);
  }
}

class LocalProfile extends DataClass implements Insertable<LocalProfile> {
  final String id;
  final String username;
  final String? displayName;
  final String? email;
  final String? avatarPath;
  final String role;
  final bool isLoggedIn;
  final DateTime updatedAt;
  const LocalProfile({
    required this.id,
    required this.username,
    this.displayName,
    this.email,
    this.avatarPath,
    required this.role,
    required this.isLoggedIn,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['role'] = Variable<String>(role);
    map['is_logged_in'] = Variable<bool>(isLoggedIn);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalProfilesCompanion(
      id: Value(id),
      username: Value(username),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      role: Value(role),
      isLoggedIn: Value(isLoggedIn),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProfile(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      email: serializer.fromJson<String?>(json['email']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      role: serializer.fromJson<String>(json['role']),
      isLoggedIn: serializer.fromJson<bool>(json['isLoggedIn']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'displayName': serializer.toJson<String?>(displayName),
      'email': serializer.toJson<String?>(email),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'role': serializer.toJson<String>(role),
      'isLoggedIn': serializer.toJson<bool>(isLoggedIn),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalProfile copyWith({
    String? id,
    String? username,
    Value<String?> displayName = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> avatarPath = const Value.absent(),
    String? role,
    bool? isLoggedIn,
    DateTime? updatedAt,
  }) => LocalProfile(
    id: id ?? this.id,
    username: username ?? this.username,
    displayName: displayName.present ? displayName.value : this.displayName,
    email: email.present ? email.value : this.email,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    role: role ?? this.role,
    isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalProfile copyWithCompanion(LocalProfilesCompanion data) {
    return LocalProfile(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      email: data.email.present ? data.email.value : this.email,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      role: data.role.present ? data.role.value : this.role,
      isLoggedIn: data.isLoggedIn.present
          ? data.isLoggedIn.value
          : this.isLoggedIn,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfile(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('role: $role, ')
          ..write('isLoggedIn: $isLoggedIn, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    displayName,
    email,
    avatarPath,
    role,
    isLoggedIn,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProfile &&
          other.id == this.id &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.email == this.email &&
          other.avatarPath == this.avatarPath &&
          other.role == this.role &&
          other.isLoggedIn == this.isLoggedIn &&
          other.updatedAt == this.updatedAt);
}

class LocalProfilesCompanion extends UpdateCompanion<LocalProfile> {
  final Value<String> id;
  final Value<String> username;
  final Value<String?> displayName;
  final Value<String?> email;
  final Value<String?> avatarPath;
  final Value<String> role;
  final Value<bool> isLoggedIn;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalProfilesCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.role = const Value.absent(),
    this.isLoggedIn = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProfilesCompanion.insert({
    required String id,
    required String username,
    this.displayName = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.role = const Value.absent(),
    this.isLoggedIn = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       username = Value(username);
  static Insertable<LocalProfile> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? email,
    Expression<String>? avatarPath,
    Expression<String>? role,
    Expression<bool>? isLoggedIn,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (email != null) 'email': email,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (role != null) 'role': role,
      if (isLoggedIn != null) 'is_logged_in': isLoggedIn,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? username,
    Value<String?>? displayName,
    Value<String?>? email,
    Value<String?>? avatarPath,
    Value<String>? role,
    Value<bool>? isLoggedIn,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalProfilesCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
      role: role ?? this.role,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isLoggedIn.present) {
      map['is_logged_in'] = Variable<bool>(isLoggedIn.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfilesCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('role: $role, ')
          ..write('isLoggedIn: $isLoggedIn, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FolderSourcesTable extends FolderSources
    with TableInfo<$FolderSourcesTable, FolderSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FolderSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folderPathMeta = const VerificationMeta(
    'folderPath',
  );
  @override
  late final GeneratedColumn<String> folderPath = GeneratedColumn<String>(
    'folder_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastScannedAtMeta = const VerificationMeta(
    'lastScannedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastScannedAt =
      GeneratedColumn<DateTime>(
        'last_scanned_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    folderPath,
    displayName,
    lastScannedAt,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folder_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<FolderSource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('folder_path')) {
      context.handle(
        _folderPathMeta,
        folderPath.isAcceptableOrUnknown(data['folder_path']!, _folderPathMeta),
      );
    } else if (isInserting) {
      context.missing(_folderPathMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('last_scanned_at')) {
      context.handle(
        _lastScannedAtMeta,
        lastScannedAt.isAcceptableOrUnknown(
          data['last_scanned_at']!,
          _lastScannedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, folderPath},
  ];
  @override
  FolderSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FolderSource(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      folderPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_path'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      lastScannedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_scanned_at'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FolderSourcesTable createAlias(String alias) {
    return $FolderSourcesTable(attachedDatabase, alias);
  }
}

class FolderSource extends DataClass implements Insertable<FolderSource> {
  final int id;
  final String userId;
  final String folderPath;
  final String? displayName;
  final DateTime? lastScannedAt;
  final bool isActive;
  final DateTime createdAt;
  const FolderSource({
    required this.id,
    required this.userId,
    required this.folderPath,
    this.displayName,
    this.lastScannedAt,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['folder_path'] = Variable<String>(folderPath);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || lastScannedAt != null) {
      map['last_scanned_at'] = Variable<DateTime>(lastScannedAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FolderSourcesCompanion toCompanion(bool nullToAbsent) {
    return FolderSourcesCompanion(
      id: Value(id),
      userId: Value(userId),
      folderPath: Value(folderPath),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      lastScannedAt: lastScannedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastScannedAt),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory FolderSource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FolderSource(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      folderPath: serializer.fromJson<String>(json['folderPath']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      lastScannedAt: serializer.fromJson<DateTime?>(json['lastScannedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'folderPath': serializer.toJson<String>(folderPath),
      'displayName': serializer.toJson<String?>(displayName),
      'lastScannedAt': serializer.toJson<DateTime?>(lastScannedAt),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FolderSource copyWith({
    int? id,
    String? userId,
    String? folderPath,
    Value<String?> displayName = const Value.absent(),
    Value<DateTime?> lastScannedAt = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
  }) => FolderSource(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    folderPath: folderPath ?? this.folderPath,
    displayName: displayName.present ? displayName.value : this.displayName,
    lastScannedAt: lastScannedAt.present
        ? lastScannedAt.value
        : this.lastScannedAt,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  FolderSource copyWithCompanion(FolderSourcesCompanion data) {
    return FolderSource(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      folderPath: data.folderPath.present
          ? data.folderPath.value
          : this.folderPath,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      lastScannedAt: data.lastScannedAt.present
          ? data.lastScannedAt.value
          : this.lastScannedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FolderSource(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('folderPath: $folderPath, ')
          ..write('displayName: $displayName, ')
          ..write('lastScannedAt: $lastScannedAt, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    folderPath,
    displayName,
    lastScannedAt,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FolderSource &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.folderPath == this.folderPath &&
          other.displayName == this.displayName &&
          other.lastScannedAt == this.lastScannedAt &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class FolderSourcesCompanion extends UpdateCompanion<FolderSource> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> folderPath;
  final Value<String?> displayName;
  final Value<DateTime?> lastScannedAt;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const FolderSourcesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.folderPath = const Value.absent(),
    this.displayName = const Value.absent(),
    this.lastScannedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FolderSourcesCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String folderPath,
    this.displayName = const Value.absent(),
    this.lastScannedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       folderPath = Value(folderPath);
  static Insertable<FolderSource> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? folderPath,
    Expression<String>? displayName,
    Expression<DateTime>? lastScannedAt,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (folderPath != null) 'folder_path': folderPath,
      if (displayName != null) 'display_name': displayName,
      if (lastScannedAt != null) 'last_scanned_at': lastScannedAt,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FolderSourcesCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String>? folderPath,
    Value<String?>? displayName,
    Value<DateTime?>? lastScannedAt,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return FolderSourcesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      folderPath: folderPath ?? this.folderPath,
      displayName: displayName ?? this.displayName,
      lastScannedAt: lastScannedAt ?? this.lastScannedAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (folderPath.present) {
      map['folder_path'] = Variable<String>(folderPath.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (lastScannedAt.present) {
      map['last_scanned_at'] = Variable<DateTime>(lastScannedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FolderSourcesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('folderPath: $folderPath, ')
          ..write('displayName: $displayName, ')
          ..write('lastScannedAt: $lastScannedAt, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AudioItemsTable extends AudioItems
    with TableInfo<$AudioItemsTable, AudioItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudioItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumMeta = const VerificationMeta('album');
  @override
  late final GeneratedColumn<String> album = GeneratedColumn<String>(
    'album',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumArtistMeta = const VerificationMeta(
    'albumArtist',
  );
  @override
  late final GeneratedColumn<String> albumArtist = GeneratedColumn<String>(
    'album_artist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackNumberMeta = const VerificationMeta(
    'trackNumber',
  );
  @override
  late final GeneratedColumn<int> trackNumber = GeneratedColumn<int>(
    'track_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _composerMeta = const VerificationMeta(
    'composer',
  );
  @override
  late final GeneratedColumn<String> composer = GeneratedColumn<String>(
    'composer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artworkPathMeta = const VerificationMeta(
    'artworkPath',
  );
  @override
  late final GeneratedColumn<String> artworkPath = GeneratedColumn<String>(
    'artwork_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLikedMeta = const VerificationMeta(
    'isLiked',
  );
  @override
  late final GeneratedColumn<bool> isLiked = GeneratedColumn<bool>(
    'is_liked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_liked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _starNumberMeta = const VerificationMeta(
    'starNumber',
  );
  @override
  late final GeneratedColumn<int> starNumber = GeneratedColumn<int>(
    'star_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _playCountMeta = const VerificationMeta(
    'playCount',
  );
  @override
  late final GeneratedColumn<int> playCount = GeneratedColumn<int>(
    'play_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta(
    'lastPlayedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayedAt = GeneratedColumn<DateTime>(
    'last_played_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resumePositionMsMeta = const VerificationMeta(
    'resumePositionMs',
  );
  @override
  late final GeneratedColumn<int> resumePositionMs = GeneratedColumn<int>(
    'resume_position_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    itemType,
    title,
    artist,
    album,
    albumArtist,
    genre,
    year,
    trackNumber,
    composer,
    durationMs,
    artworkPath,
    isLiked,
    starNumber,
    playCount,
    lastPlayedAt,
    resumePositionMs,
    isAvailable,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<AudioItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(
        _artistMeta,
        artist.isAcceptableOrUnknown(data['artist']!, _artistMeta),
      );
    }
    if (data.containsKey('album')) {
      context.handle(
        _albumMeta,
        album.isAcceptableOrUnknown(data['album']!, _albumMeta),
      );
    }
    if (data.containsKey('album_artist')) {
      context.handle(
        _albumArtistMeta,
        albumArtist.isAcceptableOrUnknown(
          data['album_artist']!,
          _albumArtistMeta,
        ),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('track_number')) {
      context.handle(
        _trackNumberMeta,
        trackNumber.isAcceptableOrUnknown(
          data['track_number']!,
          _trackNumberMeta,
        ),
      );
    }
    if (data.containsKey('composer')) {
      context.handle(
        _composerMeta,
        composer.isAcceptableOrUnknown(data['composer']!, _composerMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('artwork_path')) {
      context.handle(
        _artworkPathMeta,
        artworkPath.isAcceptableOrUnknown(
          data['artwork_path']!,
          _artworkPathMeta,
        ),
      );
    }
    if (data.containsKey('is_liked')) {
      context.handle(
        _isLikedMeta,
        isLiked.isAcceptableOrUnknown(data['is_liked']!, _isLikedMeta),
      );
    }
    if (data.containsKey('star_number')) {
      context.handle(
        _starNumberMeta,
        starNumber.isAcceptableOrUnknown(data['star_number']!, _starNumberMeta),
      );
    }
    if (data.containsKey('play_count')) {
      context.handle(
        _playCountMeta,
        playCount.isAcceptableOrUnknown(data['play_count']!, _playCountMeta),
      );
    }
    if (data.containsKey('last_played_at')) {
      context.handle(
        _lastPlayedAtMeta,
        lastPlayedAt.isAcceptableOrUnknown(
          data['last_played_at']!,
          _lastPlayedAtMeta,
        ),
      );
    }
    if (data.containsKey('resume_position_ms')) {
      context.handle(
        _resumePositionMsMeta,
        resumePositionMs.isAcceptableOrUnknown(
          data['resume_position_ms']!,
          _resumePositionMsMeta,
        ),
      );
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AudioItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      artist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist'],
      ),
      album: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album'],
      ),
      albumArtist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_artist'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      trackNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_number'],
      ),
      composer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}composer'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      artworkPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artwork_path'],
      ),
      isLiked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_liked'],
      )!,
      starNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}star_number'],
      ),
      playCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}play_count'],
      )!,
      lastPlayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played_at'],
      ),
      resumePositionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resume_position_ms'],
      )!,
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AudioItemsTable createAlias(String alias) {
    return $AudioItemsTable(attachedDatabase, alias);
  }
}

class AudioItem extends DataClass implements Insertable<AudioItem> {
  final String id;
  final String userId;
  final String itemType;
  final String title;
  final String? artist;
  final String? album;
  final String? albumArtist;
  final String? genre;
  final int? year;
  final int? trackNumber;
  final String? composer;
  final int? durationMs;
  final String? artworkPath;
  final bool isLiked;
  final int? starNumber;
  final int playCount;
  final DateTime? lastPlayedAt;
  final int resumePositionMs;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AudioItem({
    required this.id,
    required this.userId,
    required this.itemType,
    required this.title,
    this.artist,
    this.album,
    this.albumArtist,
    this.genre,
    this.year,
    this.trackNumber,
    this.composer,
    this.durationMs,
    this.artworkPath,
    required this.isLiked,
    this.starNumber,
    required this.playCount,
    this.lastPlayedAt,
    required this.resumePositionMs,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['item_type'] = Variable<String>(itemType);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<String>(artist);
    }
    if (!nullToAbsent || album != null) {
      map['album'] = Variable<String>(album);
    }
    if (!nullToAbsent || albumArtist != null) {
      map['album_artist'] = Variable<String>(albumArtist);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || trackNumber != null) {
      map['track_number'] = Variable<int>(trackNumber);
    }
    if (!nullToAbsent || composer != null) {
      map['composer'] = Variable<String>(composer);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || artworkPath != null) {
      map['artwork_path'] = Variable<String>(artworkPath);
    }
    map['is_liked'] = Variable<bool>(isLiked);
    if (!nullToAbsent || starNumber != null) {
      map['star_number'] = Variable<int>(starNumber);
    }
    map['play_count'] = Variable<int>(playCount);
    if (!nullToAbsent || lastPlayedAt != null) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt);
    }
    map['resume_position_ms'] = Variable<int>(resumePositionMs);
    map['is_available'] = Variable<bool>(isAvailable);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AudioItemsCompanion toCompanion(bool nullToAbsent) {
    return AudioItemsCompanion(
      id: Value(id),
      userId: Value(userId),
      itemType: Value(itemType),
      title: Value(title),
      artist: artist == null && nullToAbsent
          ? const Value.absent()
          : Value(artist),
      album: album == null && nullToAbsent
          ? const Value.absent()
          : Value(album),
      albumArtist: albumArtist == null && nullToAbsent
          ? const Value.absent()
          : Value(albumArtist),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      trackNumber: trackNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(trackNumber),
      composer: composer == null && nullToAbsent
          ? const Value.absent()
          : Value(composer),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      artworkPath: artworkPath == null && nullToAbsent
          ? const Value.absent()
          : Value(artworkPath),
      isLiked: Value(isLiked),
      starNumber: starNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(starNumber),
      playCount: Value(playCount),
      lastPlayedAt: lastPlayedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayedAt),
      resumePositionMs: Value(resumePositionMs),
      isAvailable: Value(isAvailable),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AudioItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioItem(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      itemType: serializer.fromJson<String>(json['itemType']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String?>(json['artist']),
      album: serializer.fromJson<String?>(json['album']),
      albumArtist: serializer.fromJson<String?>(json['albumArtist']),
      genre: serializer.fromJson<String?>(json['genre']),
      year: serializer.fromJson<int?>(json['year']),
      trackNumber: serializer.fromJson<int?>(json['trackNumber']),
      composer: serializer.fromJson<String?>(json['composer']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      artworkPath: serializer.fromJson<String?>(json['artworkPath']),
      isLiked: serializer.fromJson<bool>(json['isLiked']),
      starNumber: serializer.fromJson<int?>(json['starNumber']),
      playCount: serializer.fromJson<int>(json['playCount']),
      lastPlayedAt: serializer.fromJson<DateTime?>(json['lastPlayedAt']),
      resumePositionMs: serializer.fromJson<int>(json['resumePositionMs']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'itemType': serializer.toJson<String>(itemType),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String?>(artist),
      'album': serializer.toJson<String?>(album),
      'albumArtist': serializer.toJson<String?>(albumArtist),
      'genre': serializer.toJson<String?>(genre),
      'year': serializer.toJson<int?>(year),
      'trackNumber': serializer.toJson<int?>(trackNumber),
      'composer': serializer.toJson<String?>(composer),
      'durationMs': serializer.toJson<int?>(durationMs),
      'artworkPath': serializer.toJson<String?>(artworkPath),
      'isLiked': serializer.toJson<bool>(isLiked),
      'starNumber': serializer.toJson<int?>(starNumber),
      'playCount': serializer.toJson<int>(playCount),
      'lastPlayedAt': serializer.toJson<DateTime?>(lastPlayedAt),
      'resumePositionMs': serializer.toJson<int>(resumePositionMs),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AudioItem copyWith({
    String? id,
    String? userId,
    String? itemType,
    String? title,
    Value<String?> artist = const Value.absent(),
    Value<String?> album = const Value.absent(),
    Value<String?> albumArtist = const Value.absent(),
    Value<String?> genre = const Value.absent(),
    Value<int?> year = const Value.absent(),
    Value<int?> trackNumber = const Value.absent(),
    Value<String?> composer = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<String?> artworkPath = const Value.absent(),
    bool? isLiked,
    Value<int?> starNumber = const Value.absent(),
    int? playCount,
    Value<DateTime?> lastPlayedAt = const Value.absent(),
    int? resumePositionMs,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AudioItem(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    itemType: itemType ?? this.itemType,
    title: title ?? this.title,
    artist: artist.present ? artist.value : this.artist,
    album: album.present ? album.value : this.album,
    albumArtist: albumArtist.present ? albumArtist.value : this.albumArtist,
    genre: genre.present ? genre.value : this.genre,
    year: year.present ? year.value : this.year,
    trackNumber: trackNumber.present ? trackNumber.value : this.trackNumber,
    composer: composer.present ? composer.value : this.composer,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    artworkPath: artworkPath.present ? artworkPath.value : this.artworkPath,
    isLiked: isLiked ?? this.isLiked,
    starNumber: starNumber.present ? starNumber.value : this.starNumber,
    playCount: playCount ?? this.playCount,
    lastPlayedAt: lastPlayedAt.present ? lastPlayedAt.value : this.lastPlayedAt,
    resumePositionMs: resumePositionMs ?? this.resumePositionMs,
    isAvailable: isAvailable ?? this.isAvailable,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AudioItem copyWithCompanion(AudioItemsCompanion data) {
    return AudioItem(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      album: data.album.present ? data.album.value : this.album,
      albumArtist: data.albumArtist.present
          ? data.albumArtist.value
          : this.albumArtist,
      genre: data.genre.present ? data.genre.value : this.genre,
      year: data.year.present ? data.year.value : this.year,
      trackNumber: data.trackNumber.present
          ? data.trackNumber.value
          : this.trackNumber,
      composer: data.composer.present ? data.composer.value : this.composer,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      artworkPath: data.artworkPath.present
          ? data.artworkPath.value
          : this.artworkPath,
      isLiked: data.isLiked.present ? data.isLiked.value : this.isLiked,
      starNumber: data.starNumber.present
          ? data.starNumber.value
          : this.starNumber,
      playCount: data.playCount.present ? data.playCount.value : this.playCount,
      lastPlayedAt: data.lastPlayedAt.present
          ? data.lastPlayedAt.value
          : this.lastPlayedAt,
      resumePositionMs: data.resumePositionMs.present
          ? data.resumePositionMs.value
          : this.resumePositionMs,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudioItem(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('itemType: $itemType, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('album: $album, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('genre: $genre, ')
          ..write('year: $year, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('composer: $composer, ')
          ..write('durationMs: $durationMs, ')
          ..write('artworkPath: $artworkPath, ')
          ..write('isLiked: $isLiked, ')
          ..write('starNumber: $starNumber, ')
          ..write('playCount: $playCount, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('resumePositionMs: $resumePositionMs, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    itemType,
    title,
    artist,
    album,
    albumArtist,
    genre,
    year,
    trackNumber,
    composer,
    durationMs,
    artworkPath,
    isLiked,
    starNumber,
    playCount,
    lastPlayedAt,
    resumePositionMs,
    isAvailable,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioItem &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.itemType == this.itemType &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.album == this.album &&
          other.albumArtist == this.albumArtist &&
          other.genre == this.genre &&
          other.year == this.year &&
          other.trackNumber == this.trackNumber &&
          other.composer == this.composer &&
          other.durationMs == this.durationMs &&
          other.artworkPath == this.artworkPath &&
          other.isLiked == this.isLiked &&
          other.starNumber == this.starNumber &&
          other.playCount == this.playCount &&
          other.lastPlayedAt == this.lastPlayedAt &&
          other.resumePositionMs == this.resumePositionMs &&
          other.isAvailable == this.isAvailable &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AudioItemsCompanion extends UpdateCompanion<AudioItem> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> itemType;
  final Value<String> title;
  final Value<String?> artist;
  final Value<String?> album;
  final Value<String?> albumArtist;
  final Value<String?> genre;
  final Value<int?> year;
  final Value<int?> trackNumber;
  final Value<String?> composer;
  final Value<int?> durationMs;
  final Value<String?> artworkPath;
  final Value<bool> isLiked;
  final Value<int?> starNumber;
  final Value<int> playCount;
  final Value<DateTime?> lastPlayedAt;
  final Value<int> resumePositionMs;
  final Value<bool> isAvailable;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AudioItemsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.itemType = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.album = const Value.absent(),
    this.albumArtist = const Value.absent(),
    this.genre = const Value.absent(),
    this.year = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.composer = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.artworkPath = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.starNumber = const Value.absent(),
    this.playCount = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.resumePositionMs = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AudioItemsCompanion.insert({
    required String id,
    required String userId,
    required String itemType,
    required String title,
    this.artist = const Value.absent(),
    this.album = const Value.absent(),
    this.albumArtist = const Value.absent(),
    this.genre = const Value.absent(),
    this.year = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.composer = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.artworkPath = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.starNumber = const Value.absent(),
    this.playCount = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.resumePositionMs = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       itemType = Value(itemType),
       title = Value(title);
  static Insertable<AudioItem> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? itemType,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? album,
    Expression<String>? albumArtist,
    Expression<String>? genre,
    Expression<int>? year,
    Expression<int>? trackNumber,
    Expression<String>? composer,
    Expression<int>? durationMs,
    Expression<String>? artworkPath,
    Expression<bool>? isLiked,
    Expression<int>? starNumber,
    Expression<int>? playCount,
    Expression<DateTime>? lastPlayedAt,
    Expression<int>? resumePositionMs,
    Expression<bool>? isAvailable,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (itemType != null) 'item_type': itemType,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (album != null) 'album': album,
      if (albumArtist != null) 'album_artist': albumArtist,
      if (genre != null) 'genre': genre,
      if (year != null) 'year': year,
      if (trackNumber != null) 'track_number': trackNumber,
      if (composer != null) 'composer': composer,
      if (durationMs != null) 'duration_ms': durationMs,
      if (artworkPath != null) 'artwork_path': artworkPath,
      if (isLiked != null) 'is_liked': isLiked,
      if (starNumber != null) 'star_number': starNumber,
      if (playCount != null) 'play_count': playCount,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
      if (resumePositionMs != null) 'resume_position_ms': resumePositionMs,
      if (isAvailable != null) 'is_available': isAvailable,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AudioItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? itemType,
    Value<String>? title,
    Value<String?>? artist,
    Value<String?>? album,
    Value<String?>? albumArtist,
    Value<String?>? genre,
    Value<int?>? year,
    Value<int?>? trackNumber,
    Value<String?>? composer,
    Value<int?>? durationMs,
    Value<String?>? artworkPath,
    Value<bool>? isLiked,
    Value<int?>? starNumber,
    Value<int>? playCount,
    Value<DateTime?>? lastPlayedAt,
    Value<int>? resumePositionMs,
    Value<bool>? isAvailable,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AudioItemsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemType: itemType ?? this.itemType,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      albumArtist: albumArtist ?? this.albumArtist,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      trackNumber: trackNumber ?? this.trackNumber,
      composer: composer ?? this.composer,
      durationMs: durationMs ?? this.durationMs,
      artworkPath: artworkPath ?? this.artworkPath,
      isLiked: isLiked ?? this.isLiked,
      starNumber: starNumber ?? this.starNumber,
      playCount: playCount ?? this.playCount,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      resumePositionMs: resumePositionMs ?? this.resumePositionMs,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (album.present) {
      map['album'] = Variable<String>(album.value);
    }
    if (albumArtist.present) {
      map['album_artist'] = Variable<String>(albumArtist.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (trackNumber.present) {
      map['track_number'] = Variable<int>(trackNumber.value);
    }
    if (composer.present) {
      map['composer'] = Variable<String>(composer.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (artworkPath.present) {
      map['artwork_path'] = Variable<String>(artworkPath.value);
    }
    if (isLiked.present) {
      map['is_liked'] = Variable<bool>(isLiked.value);
    }
    if (starNumber.present) {
      map['star_number'] = Variable<int>(starNumber.value);
    }
    if (playCount.present) {
      map['play_count'] = Variable<int>(playCount.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt.value);
    }
    if (resumePositionMs.present) {
      map['resume_position_ms'] = Variable<int>(resumePositionMs.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudioItemsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('itemType: $itemType, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('album: $album, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('genre: $genre, ')
          ..write('year: $year, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('composer: $composer, ')
          ..write('durationMs: $durationMs, ')
          ..write('artworkPath: $artworkPath, ')
          ..write('isLiked: $isLiked, ')
          ..write('starNumber: $starNumber, ')
          ..write('playCount: $playCount, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('resumePositionMs: $resumePositionMs, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AudioFilesTable extends AudioFiles
    with TableInfo<$AudioFilesTable, AudioFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudioFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioItemIdMeta = const VerificationMeta(
    'audioItemId',
  );
  @override
  late final GeneratedColumn<String> audioItemId = GeneratedColumn<String>(
    'audio_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES audio_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bitRateMeta = const VerificationMeta(
    'bitRate',
  );
  @override
  late final GeneratedColumn<int> bitRate = GeneratedColumn<int>(
    'bit_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sampleRateMeta = const VerificationMeta(
    'sampleRate',
  );
  @override
  late final GeneratedColumn<int> sampleRate = GeneratedColumn<int>(
    'sample_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _channelsMeta = const VerificationMeta(
    'channels',
  );
  @override
  late final GeneratedColumn<int> channels = GeneratedColumn<int>(
    'channels',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastVerifiedAtMeta = const VerificationMeta(
    'lastVerifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastVerifiedAt =
      GeneratedColumn<DateTime>(
        'last_verified_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    audioItemId,
    filePath,
    fileHash,
    fileSizeBytes,
    mimeType,
    bitRate,
    sampleRate,
    channels,
    isAvailable,
    lastVerifiedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<AudioFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('audio_item_id')) {
      context.handle(
        _audioItemIdMeta,
        audioItemId.isAcceptableOrUnknown(
          data['audio_item_id']!,
          _audioItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_audioItemIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('bit_rate')) {
      context.handle(
        _bitRateMeta,
        bitRate.isAcceptableOrUnknown(data['bit_rate']!, _bitRateMeta),
      );
    }
    if (data.containsKey('sample_rate')) {
      context.handle(
        _sampleRateMeta,
        sampleRate.isAcceptableOrUnknown(data['sample_rate']!, _sampleRateMeta),
      );
    }
    if (data.containsKey('channels')) {
      context.handle(
        _channelsMeta,
        channels.isAcceptableOrUnknown(data['channels']!, _channelsMeta),
      );
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    }
    if (data.containsKey('last_verified_at')) {
      context.handle(
        _lastVerifiedAtMeta,
        lastVerifiedAt.isAcceptableOrUnknown(
          data['last_verified_at']!,
          _lastVerifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AudioFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      audioItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_item_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      ),
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      ),
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      bitRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bit_rate'],
      ),
      sampleRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sample_rate'],
      ),
      channels: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}channels'],
      ),
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      )!,
      lastVerifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_verified_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AudioFilesTable createAlias(String alias) {
    return $AudioFilesTable(attachedDatabase, alias);
  }
}

class AudioFile extends DataClass implements Insertable<AudioFile> {
  final String id;
  final String audioItemId;
  final String filePath;
  final String? fileHash;
  final int? fileSizeBytes;
  final String? mimeType;
  final int? bitRate;
  final int? sampleRate;
  final int? channels;
  final bool isAvailable;
  final DateTime? lastVerifiedAt;
  final DateTime createdAt;
  const AudioFile({
    required this.id,
    required this.audioItemId,
    required this.filePath,
    this.fileHash,
    this.fileSizeBytes,
    this.mimeType,
    this.bitRate,
    this.sampleRate,
    this.channels,
    required this.isAvailable,
    this.lastVerifiedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['audio_item_id'] = Variable<String>(audioItemId);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || fileHash != null) {
      map['file_hash'] = Variable<String>(fileHash);
    }
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || bitRate != null) {
      map['bit_rate'] = Variable<int>(bitRate);
    }
    if (!nullToAbsent || sampleRate != null) {
      map['sample_rate'] = Variable<int>(sampleRate);
    }
    if (!nullToAbsent || channels != null) {
      map['channels'] = Variable<int>(channels);
    }
    map['is_available'] = Variable<bool>(isAvailable);
    if (!nullToAbsent || lastVerifiedAt != null) {
      map['last_verified_at'] = Variable<DateTime>(lastVerifiedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AudioFilesCompanion toCompanion(bool nullToAbsent) {
    return AudioFilesCompanion(
      id: Value(id),
      audioItemId: Value(audioItemId),
      filePath: Value(filePath),
      fileHash: fileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(fileHash),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSizeBytes),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      bitRate: bitRate == null && nullToAbsent
          ? const Value.absent()
          : Value(bitRate),
      sampleRate: sampleRate == null && nullToAbsent
          ? const Value.absent()
          : Value(sampleRate),
      channels: channels == null && nullToAbsent
          ? const Value.absent()
          : Value(channels),
      isAvailable: Value(isAvailable),
      lastVerifiedAt: lastVerifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVerifiedAt),
      createdAt: Value(createdAt),
    );
  }

  factory AudioFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioFile(
      id: serializer.fromJson<String>(json['id']),
      audioItemId: serializer.fromJson<String>(json['audioItemId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileHash: serializer.fromJson<String?>(json['fileHash']),
      fileSizeBytes: serializer.fromJson<int?>(json['fileSizeBytes']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      bitRate: serializer.fromJson<int?>(json['bitRate']),
      sampleRate: serializer.fromJson<int?>(json['sampleRate']),
      channels: serializer.fromJson<int?>(json['channels']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      lastVerifiedAt: serializer.fromJson<DateTime?>(json['lastVerifiedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'audioItemId': serializer.toJson<String>(audioItemId),
      'filePath': serializer.toJson<String>(filePath),
      'fileHash': serializer.toJson<String?>(fileHash),
      'fileSizeBytes': serializer.toJson<int?>(fileSizeBytes),
      'mimeType': serializer.toJson<String?>(mimeType),
      'bitRate': serializer.toJson<int?>(bitRate),
      'sampleRate': serializer.toJson<int?>(sampleRate),
      'channels': serializer.toJson<int?>(channels),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'lastVerifiedAt': serializer.toJson<DateTime?>(lastVerifiedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AudioFile copyWith({
    String? id,
    String? audioItemId,
    String? filePath,
    Value<String?> fileHash = const Value.absent(),
    Value<int?> fileSizeBytes = const Value.absent(),
    Value<String?> mimeType = const Value.absent(),
    Value<int?> bitRate = const Value.absent(),
    Value<int?> sampleRate = const Value.absent(),
    Value<int?> channels = const Value.absent(),
    bool? isAvailable,
    Value<DateTime?> lastVerifiedAt = const Value.absent(),
    DateTime? createdAt,
  }) => AudioFile(
    id: id ?? this.id,
    audioItemId: audioItemId ?? this.audioItemId,
    filePath: filePath ?? this.filePath,
    fileHash: fileHash.present ? fileHash.value : this.fileHash,
    fileSizeBytes: fileSizeBytes.present
        ? fileSizeBytes.value
        : this.fileSizeBytes,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    bitRate: bitRate.present ? bitRate.value : this.bitRate,
    sampleRate: sampleRate.present ? sampleRate.value : this.sampleRate,
    channels: channels.present ? channels.value : this.channels,
    isAvailable: isAvailable ?? this.isAvailable,
    lastVerifiedAt: lastVerifiedAt.present
        ? lastVerifiedAt.value
        : this.lastVerifiedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  AudioFile copyWithCompanion(AudioFilesCompanion data) {
    return AudioFile(
      id: data.id.present ? data.id.value : this.id,
      audioItemId: data.audioItemId.present
          ? data.audioItemId.value
          : this.audioItemId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      bitRate: data.bitRate.present ? data.bitRate.value : this.bitRate,
      sampleRate: data.sampleRate.present
          ? data.sampleRate.value
          : this.sampleRate,
      channels: data.channels.present ? data.channels.value : this.channels,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      lastVerifiedAt: data.lastVerifiedAt.present
          ? data.lastVerifiedAt.value
          : this.lastVerifiedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudioFile(')
          ..write('id: $id, ')
          ..write('audioItemId: $audioItemId, ')
          ..write('filePath: $filePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('mimeType: $mimeType, ')
          ..write('bitRate: $bitRate, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('channels: $channels, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('lastVerifiedAt: $lastVerifiedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    audioItemId,
    filePath,
    fileHash,
    fileSizeBytes,
    mimeType,
    bitRate,
    sampleRate,
    channels,
    isAvailable,
    lastVerifiedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioFile &&
          other.id == this.id &&
          other.audioItemId == this.audioItemId &&
          other.filePath == this.filePath &&
          other.fileHash == this.fileHash &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.mimeType == this.mimeType &&
          other.bitRate == this.bitRate &&
          other.sampleRate == this.sampleRate &&
          other.channels == this.channels &&
          other.isAvailable == this.isAvailable &&
          other.lastVerifiedAt == this.lastVerifiedAt &&
          other.createdAt == this.createdAt);
}

class AudioFilesCompanion extends UpdateCompanion<AudioFile> {
  final Value<String> id;
  final Value<String> audioItemId;
  final Value<String> filePath;
  final Value<String?> fileHash;
  final Value<int?> fileSizeBytes;
  final Value<String?> mimeType;
  final Value<int?> bitRate;
  final Value<int?> sampleRate;
  final Value<int?> channels;
  final Value<bool> isAvailable;
  final Value<DateTime?> lastVerifiedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AudioFilesCompanion({
    this.id = const Value.absent(),
    this.audioItemId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.bitRate = const Value.absent(),
    this.sampleRate = const Value.absent(),
    this.channels = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.lastVerifiedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AudioFilesCompanion.insert({
    required String id,
    required String audioItemId,
    required String filePath,
    this.fileHash = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.bitRate = const Value.absent(),
    this.sampleRate = const Value.absent(),
    this.channels = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.lastVerifiedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       audioItemId = Value(audioItemId),
       filePath = Value(filePath);
  static Insertable<AudioFile> custom({
    Expression<String>? id,
    Expression<String>? audioItemId,
    Expression<String>? filePath,
    Expression<String>? fileHash,
    Expression<int>? fileSizeBytes,
    Expression<String>? mimeType,
    Expression<int>? bitRate,
    Expression<int>? sampleRate,
    Expression<int>? channels,
    Expression<bool>? isAvailable,
    Expression<DateTime>? lastVerifiedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (audioItemId != null) 'audio_item_id': audioItemId,
      if (filePath != null) 'file_path': filePath,
      if (fileHash != null) 'file_hash': fileHash,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (mimeType != null) 'mime_type': mimeType,
      if (bitRate != null) 'bit_rate': bitRate,
      if (sampleRate != null) 'sample_rate': sampleRate,
      if (channels != null) 'channels': channels,
      if (isAvailable != null) 'is_available': isAvailable,
      if (lastVerifiedAt != null) 'last_verified_at': lastVerifiedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AudioFilesCompanion copyWith({
    Value<String>? id,
    Value<String>? audioItemId,
    Value<String>? filePath,
    Value<String?>? fileHash,
    Value<int?>? fileSizeBytes,
    Value<String?>? mimeType,
    Value<int?>? bitRate,
    Value<int?>? sampleRate,
    Value<int?>? channels,
    Value<bool>? isAvailable,
    Value<DateTime?>? lastVerifiedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AudioFilesCompanion(
      id: id ?? this.id,
      audioItemId: audioItemId ?? this.audioItemId,
      filePath: filePath ?? this.filePath,
      fileHash: fileHash ?? this.fileHash,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      mimeType: mimeType ?? this.mimeType,
      bitRate: bitRate ?? this.bitRate,
      sampleRate: sampleRate ?? this.sampleRate,
      channels: channels ?? this.channels,
      isAvailable: isAvailable ?? this.isAvailable,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (audioItemId.present) {
      map['audio_item_id'] = Variable<String>(audioItemId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (bitRate.present) {
      map['bit_rate'] = Variable<int>(bitRate.value);
    }
    if (sampleRate.present) {
      map['sample_rate'] = Variable<int>(sampleRate.value);
    }
    if (channels.present) {
      map['channels'] = Variable<int>(channels.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (lastVerifiedAt.present) {
      map['last_verified_at'] = Variable<DateTime>(lastVerifiedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudioFilesCompanion(')
          ..write('id: $id, ')
          ..write('audioItemId: $audioItemId, ')
          ..write('filePath: $filePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('mimeType: $mimeType, ')
          ..write('bitRate: $bitRate, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('channels: $channels, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('lastVerifiedAt: $lastVerifiedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClipRecordsTable extends ClipRecords
    with TableInfo<$ClipRecordsTable, ClipRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClipRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioItemIdMeta = const VerificationMeta(
    'audioItemId',
  );
  @override
  late final GeneratedColumn<String> audioItemId = GeneratedColumn<String>(
    'audio_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES audio_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sourceAudioItemIdMeta = const VerificationMeta(
    'sourceAudioItemId',
  );
  @override
  late final GeneratedColumn<String> sourceAudioItemId =
      GeneratedColumn<String>(
        'source_audio_item_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES audio_items (id) ON DELETE RESTRICT',
        ),
      );
  static const VerificationMeta _parentClipIdMeta = const VerificationMeta(
    'parentClipId',
  );
  @override
  late final GeneratedColumn<String> parentClipId = GeneratedColumn<String>(
    'parent_clip_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startMsMeta = const VerificationMeta(
    'startMs',
  );
  @override
  late final GeneratedColumn<int> startMs = GeneratedColumn<int>(
    'start_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMsMeta = const VerificationMeta('endMs');
  @override
  late final GeneratedColumn<int> endMs = GeneratedColumn<int>(
    'end_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPhysicalMeta = const VerificationMeta(
    'isPhysical',
  );
  @override
  late final GeneratedColumn<bool> isPhysical = GeneratedColumn<bool>(
    'is_physical',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_physical" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    audioItemId,
    sourceAudioItemId,
    parentClipId,
    startMs,
    endMs,
    isPhysical,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clip_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClipRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('audio_item_id')) {
      context.handle(
        _audioItemIdMeta,
        audioItemId.isAcceptableOrUnknown(
          data['audio_item_id']!,
          _audioItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_audioItemIdMeta);
    }
    if (data.containsKey('source_audio_item_id')) {
      context.handle(
        _sourceAudioItemIdMeta,
        sourceAudioItemId.isAcceptableOrUnknown(
          data['source_audio_item_id']!,
          _sourceAudioItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceAudioItemIdMeta);
    }
    if (data.containsKey('parent_clip_id')) {
      context.handle(
        _parentClipIdMeta,
        parentClipId.isAcceptableOrUnknown(
          data['parent_clip_id']!,
          _parentClipIdMeta,
        ),
      );
    }
    if (data.containsKey('start_ms')) {
      context.handle(
        _startMsMeta,
        startMs.isAcceptableOrUnknown(data['start_ms']!, _startMsMeta),
      );
    } else if (isInserting) {
      context.missing(_startMsMeta);
    }
    if (data.containsKey('end_ms')) {
      context.handle(
        _endMsMeta,
        endMs.isAcceptableOrUnknown(data['end_ms']!, _endMsMeta),
      );
    } else if (isInserting) {
      context.missing(_endMsMeta);
    }
    if (data.containsKey('is_physical')) {
      context.handle(
        _isPhysicalMeta,
        isPhysical.isAcceptableOrUnknown(data['is_physical']!, _isPhysicalMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClipRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClipRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      audioItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_item_id'],
      )!,
      sourceAudioItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_audio_item_id'],
      )!,
      parentClipId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_clip_id'],
      ),
      startMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_ms'],
      )!,
      endMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_ms'],
      )!,
      isPhysical: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_physical'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ClipRecordsTable createAlias(String alias) {
    return $ClipRecordsTable(attachedDatabase, alias);
  }
}

class ClipRecord extends DataClass implements Insertable<ClipRecord> {
  final String id;
  final String audioItemId;
  final String sourceAudioItemId;
  final String? parentClipId;
  final int startMs;
  final int endMs;
  final bool isPhysical;
  final DateTime createdAt;
  const ClipRecord({
    required this.id,
    required this.audioItemId,
    required this.sourceAudioItemId,
    this.parentClipId,
    required this.startMs,
    required this.endMs,
    required this.isPhysical,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['audio_item_id'] = Variable<String>(audioItemId);
    map['source_audio_item_id'] = Variable<String>(sourceAudioItemId);
    if (!nullToAbsent || parentClipId != null) {
      map['parent_clip_id'] = Variable<String>(parentClipId);
    }
    map['start_ms'] = Variable<int>(startMs);
    map['end_ms'] = Variable<int>(endMs);
    map['is_physical'] = Variable<bool>(isPhysical);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ClipRecordsCompanion toCompanion(bool nullToAbsent) {
    return ClipRecordsCompanion(
      id: Value(id),
      audioItemId: Value(audioItemId),
      sourceAudioItemId: Value(sourceAudioItemId),
      parentClipId: parentClipId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentClipId),
      startMs: Value(startMs),
      endMs: Value(endMs),
      isPhysical: Value(isPhysical),
      createdAt: Value(createdAt),
    );
  }

  factory ClipRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClipRecord(
      id: serializer.fromJson<String>(json['id']),
      audioItemId: serializer.fromJson<String>(json['audioItemId']),
      sourceAudioItemId: serializer.fromJson<String>(json['sourceAudioItemId']),
      parentClipId: serializer.fromJson<String?>(json['parentClipId']),
      startMs: serializer.fromJson<int>(json['startMs']),
      endMs: serializer.fromJson<int>(json['endMs']),
      isPhysical: serializer.fromJson<bool>(json['isPhysical']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'audioItemId': serializer.toJson<String>(audioItemId),
      'sourceAudioItemId': serializer.toJson<String>(sourceAudioItemId),
      'parentClipId': serializer.toJson<String?>(parentClipId),
      'startMs': serializer.toJson<int>(startMs),
      'endMs': serializer.toJson<int>(endMs),
      'isPhysical': serializer.toJson<bool>(isPhysical),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ClipRecord copyWith({
    String? id,
    String? audioItemId,
    String? sourceAudioItemId,
    Value<String?> parentClipId = const Value.absent(),
    int? startMs,
    int? endMs,
    bool? isPhysical,
    DateTime? createdAt,
  }) => ClipRecord(
    id: id ?? this.id,
    audioItemId: audioItemId ?? this.audioItemId,
    sourceAudioItemId: sourceAudioItemId ?? this.sourceAudioItemId,
    parentClipId: parentClipId.present ? parentClipId.value : this.parentClipId,
    startMs: startMs ?? this.startMs,
    endMs: endMs ?? this.endMs,
    isPhysical: isPhysical ?? this.isPhysical,
    createdAt: createdAt ?? this.createdAt,
  );
  ClipRecord copyWithCompanion(ClipRecordsCompanion data) {
    return ClipRecord(
      id: data.id.present ? data.id.value : this.id,
      audioItemId: data.audioItemId.present
          ? data.audioItemId.value
          : this.audioItemId,
      sourceAudioItemId: data.sourceAudioItemId.present
          ? data.sourceAudioItemId.value
          : this.sourceAudioItemId,
      parentClipId: data.parentClipId.present
          ? data.parentClipId.value
          : this.parentClipId,
      startMs: data.startMs.present ? data.startMs.value : this.startMs,
      endMs: data.endMs.present ? data.endMs.value : this.endMs,
      isPhysical: data.isPhysical.present
          ? data.isPhysical.value
          : this.isPhysical,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClipRecord(')
          ..write('id: $id, ')
          ..write('audioItemId: $audioItemId, ')
          ..write('sourceAudioItemId: $sourceAudioItemId, ')
          ..write('parentClipId: $parentClipId, ')
          ..write('startMs: $startMs, ')
          ..write('endMs: $endMs, ')
          ..write('isPhysical: $isPhysical, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    audioItemId,
    sourceAudioItemId,
    parentClipId,
    startMs,
    endMs,
    isPhysical,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClipRecord &&
          other.id == this.id &&
          other.audioItemId == this.audioItemId &&
          other.sourceAudioItemId == this.sourceAudioItemId &&
          other.parentClipId == this.parentClipId &&
          other.startMs == this.startMs &&
          other.endMs == this.endMs &&
          other.isPhysical == this.isPhysical &&
          other.createdAt == this.createdAt);
}

class ClipRecordsCompanion extends UpdateCompanion<ClipRecord> {
  final Value<String> id;
  final Value<String> audioItemId;
  final Value<String> sourceAudioItemId;
  final Value<String?> parentClipId;
  final Value<int> startMs;
  final Value<int> endMs;
  final Value<bool> isPhysical;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ClipRecordsCompanion({
    this.id = const Value.absent(),
    this.audioItemId = const Value.absent(),
    this.sourceAudioItemId = const Value.absent(),
    this.parentClipId = const Value.absent(),
    this.startMs = const Value.absent(),
    this.endMs = const Value.absent(),
    this.isPhysical = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClipRecordsCompanion.insert({
    required String id,
    required String audioItemId,
    required String sourceAudioItemId,
    this.parentClipId = const Value.absent(),
    required int startMs,
    required int endMs,
    this.isPhysical = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       audioItemId = Value(audioItemId),
       sourceAudioItemId = Value(sourceAudioItemId),
       startMs = Value(startMs),
       endMs = Value(endMs);
  static Insertable<ClipRecord> custom({
    Expression<String>? id,
    Expression<String>? audioItemId,
    Expression<String>? sourceAudioItemId,
    Expression<String>? parentClipId,
    Expression<int>? startMs,
    Expression<int>? endMs,
    Expression<bool>? isPhysical,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (audioItemId != null) 'audio_item_id': audioItemId,
      if (sourceAudioItemId != null) 'source_audio_item_id': sourceAudioItemId,
      if (parentClipId != null) 'parent_clip_id': parentClipId,
      if (startMs != null) 'start_ms': startMs,
      if (endMs != null) 'end_ms': endMs,
      if (isPhysical != null) 'is_physical': isPhysical,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClipRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? audioItemId,
    Value<String>? sourceAudioItemId,
    Value<String?>? parentClipId,
    Value<int>? startMs,
    Value<int>? endMs,
    Value<bool>? isPhysical,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ClipRecordsCompanion(
      id: id ?? this.id,
      audioItemId: audioItemId ?? this.audioItemId,
      sourceAudioItemId: sourceAudioItemId ?? this.sourceAudioItemId,
      parentClipId: parentClipId ?? this.parentClipId,
      startMs: startMs ?? this.startMs,
      endMs: endMs ?? this.endMs,
      isPhysical: isPhysical ?? this.isPhysical,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (audioItemId.present) {
      map['audio_item_id'] = Variable<String>(audioItemId.value);
    }
    if (sourceAudioItemId.present) {
      map['source_audio_item_id'] = Variable<String>(sourceAudioItemId.value);
    }
    if (parentClipId.present) {
      map['parent_clip_id'] = Variable<String>(parentClipId.value);
    }
    if (startMs.present) {
      map['start_ms'] = Variable<int>(startMs.value);
    }
    if (endMs.present) {
      map['end_ms'] = Variable<int>(endMs.value);
    }
    if (isPhysical.present) {
      map['is_physical'] = Variable<bool>(isPhysical.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClipRecordsCompanion(')
          ..write('id: $id, ')
          ..write('audioItemId: $audioItemId, ')
          ..write('sourceAudioItemId: $sourceAudioItemId, ')
          ..write('parentClipId: $parentClipId, ')
          ..write('startMs: $startMs, ')
          ..write('endMs: $endMs, ')
          ..write('isPhysical: $isPhysical, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MergedTracksTable extends MergedTracks
    with TableInfo<$MergedTracksTable, MergedTrack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MergedTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPhysicalMeta = const VerificationMeta(
    'isPhysical',
  );
  @override
  late final GeneratedColumn<bool> isPhysical = GeneratedColumn<bool>(
    'is_physical',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_physical" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, isPhysical, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merged_tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<MergedTrack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('is_physical')) {
      context.handle(
        _isPhysicalMeta,
        isPhysical.isAcceptableOrUnknown(data['is_physical']!, _isPhysicalMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MergedTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MergedTrack(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      isPhysical: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_physical'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MergedTracksTable createAlias(String alias) {
    return $MergedTracksTable(attachedDatabase, alias);
  }
}

class MergedTrack extends DataClass implements Insertable<MergedTrack> {
  final String id;
  final bool isPhysical;
  final DateTime createdAt;
  const MergedTrack({
    required this.id,
    required this.isPhysical,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['is_physical'] = Variable<bool>(isPhysical);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MergedTracksCompanion toCompanion(bool nullToAbsent) {
    return MergedTracksCompanion(
      id: Value(id),
      isPhysical: Value(isPhysical),
      createdAt: Value(createdAt),
    );
  }

  factory MergedTrack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MergedTrack(
      id: serializer.fromJson<String>(json['id']),
      isPhysical: serializer.fromJson<bool>(json['isPhysical']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'isPhysical': serializer.toJson<bool>(isPhysical),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MergedTrack copyWith({String? id, bool? isPhysical, DateTime? createdAt}) =>
      MergedTrack(
        id: id ?? this.id,
        isPhysical: isPhysical ?? this.isPhysical,
        createdAt: createdAt ?? this.createdAt,
      );
  MergedTrack copyWithCompanion(MergedTracksCompanion data) {
    return MergedTrack(
      id: data.id.present ? data.id.value : this.id,
      isPhysical: data.isPhysical.present
          ? data.isPhysical.value
          : this.isPhysical,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MergedTrack(')
          ..write('id: $id, ')
          ..write('isPhysical: $isPhysical, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, isPhysical, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MergedTrack &&
          other.id == this.id &&
          other.isPhysical == this.isPhysical &&
          other.createdAt == this.createdAt);
}

class MergedTracksCompanion extends UpdateCompanion<MergedTrack> {
  final Value<String> id;
  final Value<bool> isPhysical;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MergedTracksCompanion({
    this.id = const Value.absent(),
    this.isPhysical = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MergedTracksCompanion.insert({
    required String id,
    this.isPhysical = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<MergedTrack> custom({
    Expression<String>? id,
    Expression<bool>? isPhysical,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isPhysical != null) 'is_physical': isPhysical,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MergedTracksCompanion copyWith({
    Value<String>? id,
    Value<bool>? isPhysical,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MergedTracksCompanion(
      id: id ?? this.id,
      isPhysical: isPhysical ?? this.isPhysical,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (isPhysical.present) {
      map['is_physical'] = Variable<bool>(isPhysical.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MergedTracksCompanion(')
          ..write('id: $id, ')
          ..write('isPhysical: $isPhysical, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MergeItemsTable extends MergeItems
    with TableInfo<$MergeItemsTable, MergeItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MergeItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mergedTrackIdMeta = const VerificationMeta(
    'mergedTrackId',
  );
  @override
  late final GeneratedColumn<String> mergedTrackId = GeneratedColumn<String>(
    'merged_track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES merged_tracks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _audioItemIdMeta = const VerificationMeta(
    'audioItemId',
  );
  @override
  late final GeneratedColumn<String> audioItemId = GeneratedColumn<String>(
    'audio_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES audio_items (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fadeInMsMeta = const VerificationMeta(
    'fadeInMs',
  );
  @override
  late final GeneratedColumn<int> fadeInMs = GeneratedColumn<int>(
    'fade_in_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(500),
  );
  static const VerificationMeta _fadeOutMsMeta = const VerificationMeta(
    'fadeOutMs',
  );
  @override
  late final GeneratedColumn<int> fadeOutMs = GeneratedColumn<int>(
    'fade_out_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(500),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mergedTrackId,
    audioItemId,
    position,
    fadeInMs,
    fadeOutMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merge_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<MergeItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('merged_track_id')) {
      context.handle(
        _mergedTrackIdMeta,
        mergedTrackId.isAcceptableOrUnknown(
          data['merged_track_id']!,
          _mergedTrackIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mergedTrackIdMeta);
    }
    if (data.containsKey('audio_item_id')) {
      context.handle(
        _audioItemIdMeta,
        audioItemId.isAcceptableOrUnknown(
          data['audio_item_id']!,
          _audioItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_audioItemIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('fade_in_ms')) {
      context.handle(
        _fadeInMsMeta,
        fadeInMs.isAcceptableOrUnknown(data['fade_in_ms']!, _fadeInMsMeta),
      );
    }
    if (data.containsKey('fade_out_ms')) {
      context.handle(
        _fadeOutMsMeta,
        fadeOutMs.isAcceptableOrUnknown(data['fade_out_ms']!, _fadeOutMsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MergeItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MergeItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mergedTrackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merged_track_id'],
      )!,
      audioItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_item_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      fadeInMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fade_in_ms'],
      )!,
      fadeOutMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fade_out_ms'],
      )!,
    );
  }

  @override
  $MergeItemsTable createAlias(String alias) {
    return $MergeItemsTable(attachedDatabase, alias);
  }
}

class MergeItem extends DataClass implements Insertable<MergeItem> {
  final String id;
  final String mergedTrackId;
  final String audioItemId;
  final int position;
  final int fadeInMs;
  final int fadeOutMs;
  const MergeItem({
    required this.id,
    required this.mergedTrackId,
    required this.audioItemId,
    required this.position,
    required this.fadeInMs,
    required this.fadeOutMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['merged_track_id'] = Variable<String>(mergedTrackId);
    map['audio_item_id'] = Variable<String>(audioItemId);
    map['position'] = Variable<int>(position);
    map['fade_in_ms'] = Variable<int>(fadeInMs);
    map['fade_out_ms'] = Variable<int>(fadeOutMs);
    return map;
  }

  MergeItemsCompanion toCompanion(bool nullToAbsent) {
    return MergeItemsCompanion(
      id: Value(id),
      mergedTrackId: Value(mergedTrackId),
      audioItemId: Value(audioItemId),
      position: Value(position),
      fadeInMs: Value(fadeInMs),
      fadeOutMs: Value(fadeOutMs),
    );
  }

  factory MergeItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MergeItem(
      id: serializer.fromJson<String>(json['id']),
      mergedTrackId: serializer.fromJson<String>(json['mergedTrackId']),
      audioItemId: serializer.fromJson<String>(json['audioItemId']),
      position: serializer.fromJson<int>(json['position']),
      fadeInMs: serializer.fromJson<int>(json['fadeInMs']),
      fadeOutMs: serializer.fromJson<int>(json['fadeOutMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mergedTrackId': serializer.toJson<String>(mergedTrackId),
      'audioItemId': serializer.toJson<String>(audioItemId),
      'position': serializer.toJson<int>(position),
      'fadeInMs': serializer.toJson<int>(fadeInMs),
      'fadeOutMs': serializer.toJson<int>(fadeOutMs),
    };
  }

  MergeItem copyWith({
    String? id,
    String? mergedTrackId,
    String? audioItemId,
    int? position,
    int? fadeInMs,
    int? fadeOutMs,
  }) => MergeItem(
    id: id ?? this.id,
    mergedTrackId: mergedTrackId ?? this.mergedTrackId,
    audioItemId: audioItemId ?? this.audioItemId,
    position: position ?? this.position,
    fadeInMs: fadeInMs ?? this.fadeInMs,
    fadeOutMs: fadeOutMs ?? this.fadeOutMs,
  );
  MergeItem copyWithCompanion(MergeItemsCompanion data) {
    return MergeItem(
      id: data.id.present ? data.id.value : this.id,
      mergedTrackId: data.mergedTrackId.present
          ? data.mergedTrackId.value
          : this.mergedTrackId,
      audioItemId: data.audioItemId.present
          ? data.audioItemId.value
          : this.audioItemId,
      position: data.position.present ? data.position.value : this.position,
      fadeInMs: data.fadeInMs.present ? data.fadeInMs.value : this.fadeInMs,
      fadeOutMs: data.fadeOutMs.present ? data.fadeOutMs.value : this.fadeOutMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MergeItem(')
          ..write('id: $id, ')
          ..write('mergedTrackId: $mergedTrackId, ')
          ..write('audioItemId: $audioItemId, ')
          ..write('position: $position, ')
          ..write('fadeInMs: $fadeInMs, ')
          ..write('fadeOutMs: $fadeOutMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mergedTrackId,
    audioItemId,
    position,
    fadeInMs,
    fadeOutMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MergeItem &&
          other.id == this.id &&
          other.mergedTrackId == this.mergedTrackId &&
          other.audioItemId == this.audioItemId &&
          other.position == this.position &&
          other.fadeInMs == this.fadeInMs &&
          other.fadeOutMs == this.fadeOutMs);
}

class MergeItemsCompanion extends UpdateCompanion<MergeItem> {
  final Value<String> id;
  final Value<String> mergedTrackId;
  final Value<String> audioItemId;
  final Value<int> position;
  final Value<int> fadeInMs;
  final Value<int> fadeOutMs;
  final Value<int> rowid;
  const MergeItemsCompanion({
    this.id = const Value.absent(),
    this.mergedTrackId = const Value.absent(),
    this.audioItemId = const Value.absent(),
    this.position = const Value.absent(),
    this.fadeInMs = const Value.absent(),
    this.fadeOutMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MergeItemsCompanion.insert({
    required String id,
    required String mergedTrackId,
    required String audioItemId,
    required int position,
    this.fadeInMs = const Value.absent(),
    this.fadeOutMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mergedTrackId = Value(mergedTrackId),
       audioItemId = Value(audioItemId),
       position = Value(position);
  static Insertable<MergeItem> custom({
    Expression<String>? id,
    Expression<String>? mergedTrackId,
    Expression<String>? audioItemId,
    Expression<int>? position,
    Expression<int>? fadeInMs,
    Expression<int>? fadeOutMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mergedTrackId != null) 'merged_track_id': mergedTrackId,
      if (audioItemId != null) 'audio_item_id': audioItemId,
      if (position != null) 'position': position,
      if (fadeInMs != null) 'fade_in_ms': fadeInMs,
      if (fadeOutMs != null) 'fade_out_ms': fadeOutMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MergeItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? mergedTrackId,
    Value<String>? audioItemId,
    Value<int>? position,
    Value<int>? fadeInMs,
    Value<int>? fadeOutMs,
    Value<int>? rowid,
  }) {
    return MergeItemsCompanion(
      id: id ?? this.id,
      mergedTrackId: mergedTrackId ?? this.mergedTrackId,
      audioItemId: audioItemId ?? this.audioItemId,
      position: position ?? this.position,
      fadeInMs: fadeInMs ?? this.fadeInMs,
      fadeOutMs: fadeOutMs ?? this.fadeOutMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mergedTrackId.present) {
      map['merged_track_id'] = Variable<String>(mergedTrackId.value);
    }
    if (audioItemId.present) {
      map['audio_item_id'] = Variable<String>(audioItemId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (fadeInMs.present) {
      map['fade_in_ms'] = Variable<int>(fadeInMs.value);
    }
    if (fadeOutMs.present) {
      map['fade_out_ms'] = Variable<int>(fadeOutMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MergeItemsCompanion(')
          ..write('id: $id, ')
          ..write('mergedTrackId: $mergedTrackId, ')
          ..write('audioItemId: $audioItemId, ')
          ..write('position: $position, ')
          ..write('fadeInMs: $fadeInMs, ')
          ..write('fadeOutMs: $fadeOutMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, Playlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artworkPathMeta = const VerificationMeta(
    'artworkPath',
  );
  @override
  late final GeneratedColumn<String> artworkPath = GeneratedColumn<String>(
    'artwork_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSmartMeta = const VerificationMeta(
    'isSmart',
  );
  @override
  late final GeneratedColumn<bool> isSmart = GeneratedColumn<bool>(
    'is_smart',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_smart" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _smartCriteriaMeta = const VerificationMeta(
    'smartCriteria',
  );
  @override
  late final GeneratedColumn<String> smartCriteria = GeneratedColumn<String>(
    'smart_criteria',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    description,
    artworkPath,
    isSmart,
    smartCriteria,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Playlist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('artwork_path')) {
      context.handle(
        _artworkPathMeta,
        artworkPath.isAcceptableOrUnknown(
          data['artwork_path']!,
          _artworkPathMeta,
        ),
      );
    }
    if (data.containsKey('is_smart')) {
      context.handle(
        _isSmartMeta,
        isSmart.isAcceptableOrUnknown(data['is_smart']!, _isSmartMeta),
      );
    }
    if (data.containsKey('smart_criteria')) {
      context.handle(
        _smartCriteriaMeta,
        smartCriteria.isAcceptableOrUnknown(
          data['smart_criteria']!,
          _smartCriteriaMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Playlist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      artworkPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artwork_path'],
      ),
      isSmart: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_smart'],
      )!,
      smartCriteria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}smart_criteria'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class Playlist extends DataClass implements Insertable<Playlist> {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String? artworkPath;
  final bool isSmart;
  final String? smartCriteria;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Playlist({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.artworkPath,
    required this.isSmart,
    this.smartCriteria,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || artworkPath != null) {
      map['artwork_path'] = Variable<String>(artworkPath);
    }
    map['is_smart'] = Variable<bool>(isSmart);
    if (!nullToAbsent || smartCriteria != null) {
      map['smart_criteria'] = Variable<String>(smartCriteria);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      artworkPath: artworkPath == null && nullToAbsent
          ? const Value.absent()
          : Value(artworkPath),
      isSmart: Value(isSmart),
      smartCriteria: smartCriteria == null && nullToAbsent
          ? const Value.absent()
          : Value(smartCriteria),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Playlist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Playlist(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      artworkPath: serializer.fromJson<String?>(json['artworkPath']),
      isSmart: serializer.fromJson<bool>(json['isSmart']),
      smartCriteria: serializer.fromJson<String?>(json['smartCriteria']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'artworkPath': serializer.toJson<String?>(artworkPath),
      'isSmart': serializer.toJson<bool>(isSmart),
      'smartCriteria': serializer.toJson<String?>(smartCriteria),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Playlist copyWith({
    String? id,
    String? userId,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> artworkPath = const Value.absent(),
    bool? isSmart,
    Value<String?> smartCriteria = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Playlist(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    artworkPath: artworkPath.present ? artworkPath.value : this.artworkPath,
    isSmart: isSmart ?? this.isSmart,
    smartCriteria: smartCriteria.present
        ? smartCriteria.value
        : this.smartCriteria,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Playlist copyWithCompanion(PlaylistsCompanion data) {
    return Playlist(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      artworkPath: data.artworkPath.present
          ? data.artworkPath.value
          : this.artworkPath,
      isSmart: data.isSmart.present ? data.isSmart.value : this.isSmart,
      smartCriteria: data.smartCriteria.present
          ? data.smartCriteria.value
          : this.smartCriteria,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Playlist(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('artworkPath: $artworkPath, ')
          ..write('isSmart: $isSmart, ')
          ..write('smartCriteria: $smartCriteria, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    description,
    artworkPath,
    isSmart,
    smartCriteria,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Playlist &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.description == this.description &&
          other.artworkPath == this.artworkPath &&
          other.isSmart == this.isSmart &&
          other.smartCriteria == this.smartCriteria &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlaylistsCompanion extends UpdateCompanion<Playlist> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> artworkPath;
  final Value<bool> isSmart;
  final Value<String?> smartCriteria;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.artworkPath = const Value.absent(),
    this.isSmart = const Value.absent(),
    this.smartCriteria = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    this.description = const Value.absent(),
    this.artworkPath = const Value.absent(),
    this.isSmart = const Value.absent(),
    this.smartCriteria = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name);
  static Insertable<Playlist> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? artworkPath,
    Expression<bool>? isSmart,
    Expression<String>? smartCriteria,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (artworkPath != null) 'artwork_path': artworkPath,
      if (isSmart != null) 'is_smart': isSmart,
      if (smartCriteria != null) 'smart_criteria': smartCriteria,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? artworkPath,
    Value<bool>? isSmart,
    Value<String?>? smartCriteria,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlaylistsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      artworkPath: artworkPath ?? this.artworkPath,
      isSmart: isSmart ?? this.isSmart,
      smartCriteria: smartCriteria ?? this.smartCriteria,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (artworkPath.present) {
      map['artwork_path'] = Variable<String>(artworkPath.value);
    }
    if (isSmart.present) {
      map['is_smart'] = Variable<bool>(isSmart.value);
    }
    if (smartCriteria.present) {
      map['smart_criteria'] = Variable<String>(smartCriteria.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('artworkPath: $artworkPath, ')
          ..write('isSmart: $isSmart, ')
          ..write('smartCriteria: $smartCriteria, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistItemsTable extends PlaylistItems
    with TableInfo<$PlaylistItemsTable, PlaylistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<String> playlistId = GeneratedColumn<String>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES playlists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _audioItemIdMeta = const VerificationMeta(
    'audioItemId',
  );
  @override
  late final GeneratedColumn<String> audioItemId = GeneratedColumn<String>(
    'audio_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES audio_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    playlistId,
    audioItemId,
    position,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaylistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('audio_item_id')) {
      context.handle(
        _audioItemIdMeta,
        audioItemId.isAcceptableOrUnknown(
          data['audio_item_id']!,
          _audioItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_audioItemIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}playlist_id'],
      )!,
      audioItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_item_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $PlaylistItemsTable createAlias(String alias) {
    return $PlaylistItemsTable(attachedDatabase, alias);
  }
}

class PlaylistItem extends DataClass implements Insertable<PlaylistItem> {
  final String id;
  final String playlistId;
  final String audioItemId;
  final int position;
  final DateTime addedAt;
  const PlaylistItem({
    required this.id,
    required this.playlistId,
    required this.audioItemId,
    required this.position,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['playlist_id'] = Variable<String>(playlistId);
    map['audio_item_id'] = Variable<String>(audioItemId);
    map['position'] = Variable<int>(position);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  PlaylistItemsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistItemsCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      audioItemId: Value(audioItemId),
      position: Value(position),
      addedAt: Value(addedAt),
    );
  }

  factory PlaylistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistItem(
      id: serializer.fromJson<String>(json['id']),
      playlistId: serializer.fromJson<String>(json['playlistId']),
      audioItemId: serializer.fromJson<String>(json['audioItemId']),
      position: serializer.fromJson<int>(json['position']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'playlistId': serializer.toJson<String>(playlistId),
      'audioItemId': serializer.toJson<String>(audioItemId),
      'position': serializer.toJson<int>(position),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  PlaylistItem copyWith({
    String? id,
    String? playlistId,
    String? audioItemId,
    int? position,
    DateTime? addedAt,
  }) => PlaylistItem(
    id: id ?? this.id,
    playlistId: playlistId ?? this.playlistId,
    audioItemId: audioItemId ?? this.audioItemId,
    position: position ?? this.position,
    addedAt: addedAt ?? this.addedAt,
  );
  PlaylistItem copyWithCompanion(PlaylistItemsCompanion data) {
    return PlaylistItem(
      id: data.id.present ? data.id.value : this.id,
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      audioItemId: data.audioItemId.present
          ? data.audioItemId.value
          : this.audioItemId,
      position: data.position.present ? data.position.value : this.position,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistItem(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('audioItemId: $audioItemId, ')
          ..write('position: $position, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, playlistId, audioItemId, position, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistItem &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.audioItemId == this.audioItemId &&
          other.position == this.position &&
          other.addedAt == this.addedAt);
}

class PlaylistItemsCompanion extends UpdateCompanion<PlaylistItem> {
  final Value<String> id;
  final Value<String> playlistId;
  final Value<String> audioItemId;
  final Value<int> position;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const PlaylistItemsCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.audioItemId = const Value.absent(),
    this.position = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistItemsCompanion.insert({
    required String id,
    required String playlistId,
    required String audioItemId,
    required int position,
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       playlistId = Value(playlistId),
       audioItemId = Value(audioItemId),
       position = Value(position);
  static Insertable<PlaylistItem> custom({
    Expression<String>? id,
    Expression<String>? playlistId,
    Expression<String>? audioItemId,
    Expression<int>? position,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (audioItemId != null) 'audio_item_id': audioItemId,
      if (position != null) 'position': position,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? playlistId,
    Value<String>? audioItemId,
    Value<int>? position,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return PlaylistItemsCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      audioItemId: audioItemId ?? this.audioItemId,
      position: position ?? this.position,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<String>(playlistId.value);
    }
    if (audioItemId.present) {
      map['audio_item_id'] = Variable<String>(audioItemId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistItemsCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('audioItemId: $audioItemId, ')
          ..write('position: $position, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayHistoryTable extends PlayHistory
    with TableInfo<$PlayHistoryTable, PlayHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioItemIdMeta = const VerificationMeta(
    'audioItemId',
  );
  @override
  late final GeneratedColumn<String> audioItemId = GeneratedColumn<String>(
    'audio_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES audio_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _playedAtMeta = const VerificationMeta(
    'playedAt',
  );
  @override
  late final GeneratedColumn<DateTime> playedAt = GeneratedColumn<DateTime>(
    'played_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _durationPlayedMsMeta = const VerificationMeta(
    'durationPlayedMs',
  );
  @override
  late final GeneratedColumn<int> durationPlayedMs = GeneratedColumn<int>(
    'duration_played_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    audioItemId,
    playedAt,
    durationPlayedMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'play_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('audio_item_id')) {
      context.handle(
        _audioItemIdMeta,
        audioItemId.isAcceptableOrUnknown(
          data['audio_item_id']!,
          _audioItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_audioItemIdMeta);
    }
    if (data.containsKey('played_at')) {
      context.handle(
        _playedAtMeta,
        playedAt.isAcceptableOrUnknown(data['played_at']!, _playedAtMeta),
      );
    }
    if (data.containsKey('duration_played_ms')) {
      context.handle(
        _durationPlayedMsMeta,
        durationPlayedMs.isAcceptableOrUnknown(
          data['duration_played_ms']!,
          _durationPlayedMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      audioItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_item_id'],
      )!,
      playedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}played_at'],
      )!,
      durationPlayedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_played_ms'],
      ),
    );
  }

  @override
  $PlayHistoryTable createAlias(String alias) {
    return $PlayHistoryTable(attachedDatabase, alias);
  }
}

class PlayHistoryData extends DataClass implements Insertable<PlayHistoryData> {
  final String id;
  final String userId;
  final String audioItemId;
  final DateTime playedAt;
  final int? durationPlayedMs;
  const PlayHistoryData({
    required this.id,
    required this.userId,
    required this.audioItemId,
    required this.playedAt,
    this.durationPlayedMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['audio_item_id'] = Variable<String>(audioItemId);
    map['played_at'] = Variable<DateTime>(playedAt);
    if (!nullToAbsent || durationPlayedMs != null) {
      map['duration_played_ms'] = Variable<int>(durationPlayedMs);
    }
    return map;
  }

  PlayHistoryCompanion toCompanion(bool nullToAbsent) {
    return PlayHistoryCompanion(
      id: Value(id),
      userId: Value(userId),
      audioItemId: Value(audioItemId),
      playedAt: Value(playedAt),
      durationPlayedMs: durationPlayedMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationPlayedMs),
    );
  }

  factory PlayHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayHistoryData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      audioItemId: serializer.fromJson<String>(json['audioItemId']),
      playedAt: serializer.fromJson<DateTime>(json['playedAt']),
      durationPlayedMs: serializer.fromJson<int?>(json['durationPlayedMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'audioItemId': serializer.toJson<String>(audioItemId),
      'playedAt': serializer.toJson<DateTime>(playedAt),
      'durationPlayedMs': serializer.toJson<int?>(durationPlayedMs),
    };
  }

  PlayHistoryData copyWith({
    String? id,
    String? userId,
    String? audioItemId,
    DateTime? playedAt,
    Value<int?> durationPlayedMs = const Value.absent(),
  }) => PlayHistoryData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    audioItemId: audioItemId ?? this.audioItemId,
    playedAt: playedAt ?? this.playedAt,
    durationPlayedMs: durationPlayedMs.present
        ? durationPlayedMs.value
        : this.durationPlayedMs,
  );
  PlayHistoryData copyWithCompanion(PlayHistoryCompanion data) {
    return PlayHistoryData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      audioItemId: data.audioItemId.present
          ? data.audioItemId.value
          : this.audioItemId,
      playedAt: data.playedAt.present ? data.playedAt.value : this.playedAt,
      durationPlayedMs: data.durationPlayedMs.present
          ? data.durationPlayedMs.value
          : this.durationPlayedMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayHistoryData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('audioItemId: $audioItemId, ')
          ..write('playedAt: $playedAt, ')
          ..write('durationPlayedMs: $durationPlayedMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, audioItemId, playedAt, durationPlayedMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayHistoryData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.audioItemId == this.audioItemId &&
          other.playedAt == this.playedAt &&
          other.durationPlayedMs == this.durationPlayedMs);
}

class PlayHistoryCompanion extends UpdateCompanion<PlayHistoryData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> audioItemId;
  final Value<DateTime> playedAt;
  final Value<int?> durationPlayedMs;
  final Value<int> rowid;
  const PlayHistoryCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.audioItemId = const Value.absent(),
    this.playedAt = const Value.absent(),
    this.durationPlayedMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayHistoryCompanion.insert({
    required String id,
    required String userId,
    required String audioItemId,
    this.playedAt = const Value.absent(),
    this.durationPlayedMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       audioItemId = Value(audioItemId);
  static Insertable<PlayHistoryData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? audioItemId,
    Expression<DateTime>? playedAt,
    Expression<int>? durationPlayedMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (audioItemId != null) 'audio_item_id': audioItemId,
      if (playedAt != null) 'played_at': playedAt,
      if (durationPlayedMs != null) 'duration_played_ms': durationPlayedMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayHistoryCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? audioItemId,
    Value<DateTime>? playedAt,
    Value<int?>? durationPlayedMs,
    Value<int>? rowid,
  }) {
    return PlayHistoryCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      audioItemId: audioItemId ?? this.audioItemId,
      playedAt: playedAt ?? this.playedAt,
      durationPlayedMs: durationPlayedMs ?? this.durationPlayedMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (audioItemId.present) {
      map['audio_item_id'] = Variable<String>(audioItemId.value);
    }
    if (playedAt.present) {
      map['played_at'] = Variable<DateTime>(playedAt.value);
    }
    if (durationPlayedMs.present) {
      map['duration_played_ms'] = Variable<int>(durationPlayedMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayHistoryCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('audioItemId: $audioItemId, ')
          ..write('playedAt: $playedAt, ')
          ..write('durationPlayedMs: $durationPlayedMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QueueSnapshotTable extends QueueSnapshot
    with TableInfo<$QueueSnapshotTable, QueueSnapshotData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QueueSnapshotTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdsMeta = const VerificationMeta(
    'itemIds',
  );
  @override
  late final GeneratedColumn<String> itemIds = GeneratedColumn<String>(
    'item_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentIndexMeta = const VerificationMeta(
    'currentIndex',
  );
  @override
  late final GeneratedColumn<int> currentIndex = GeneratedColumn<int>(
    'current_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentPositionMsMeta = const VerificationMeta(
    'currentPositionMs',
  );
  @override
  late final GeneratedColumn<int> currentPositionMs = GeneratedColumn<int>(
    'current_position_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _shuffleEnabledMeta = const VerificationMeta(
    'shuffleEnabled',
  );
  @override
  late final GeneratedColumn<bool> shuffleEnabled = GeneratedColumn<bool>(
    'shuffle_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("shuffle_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _repeatModeMeta = const VerificationMeta(
    'repeatMode',
  );
  @override
  late final GeneratedColumn<String> repeatMode = GeneratedColumn<String>(
    'repeat_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('off'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    itemIds,
    currentIndex,
    currentPositionMs,
    shuffleEnabled,
    repeatMode,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'queue_snapshot';
  @override
  VerificationContext validateIntegrity(
    Insertable<QueueSnapshotData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('item_ids')) {
      context.handle(
        _itemIdsMeta,
        itemIds.isAcceptableOrUnknown(data['item_ids']!, _itemIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdsMeta);
    }
    if (data.containsKey('current_index')) {
      context.handle(
        _currentIndexMeta,
        currentIndex.isAcceptableOrUnknown(
          data['current_index']!,
          _currentIndexMeta,
        ),
      );
    }
    if (data.containsKey('current_position_ms')) {
      context.handle(
        _currentPositionMsMeta,
        currentPositionMs.isAcceptableOrUnknown(
          data['current_position_ms']!,
          _currentPositionMsMeta,
        ),
      );
    }
    if (data.containsKey('shuffle_enabled')) {
      context.handle(
        _shuffleEnabledMeta,
        shuffleEnabled.isAcceptableOrUnknown(
          data['shuffle_enabled']!,
          _shuffleEnabledMeta,
        ),
      );
    }
    if (data.containsKey('repeat_mode')) {
      context.handle(
        _repeatModeMeta,
        repeatMode.isAcceptableOrUnknown(data['repeat_mode']!, _repeatModeMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  QueueSnapshotData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QueueSnapshotData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      itemIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_ids'],
      )!,
      currentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_index'],
      )!,
      currentPositionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_position_ms'],
      )!,
      shuffleEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}shuffle_enabled'],
      )!,
      repeatMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_mode'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $QueueSnapshotTable createAlias(String alias) {
    return $QueueSnapshotTable(attachedDatabase, alias);
  }
}

class QueueSnapshotData extends DataClass
    implements Insertable<QueueSnapshotData> {
  final String userId;
  final String itemIds;
  final int currentIndex;
  final int currentPositionMs;
  final bool shuffleEnabled;
  final String repeatMode;
  final DateTime updatedAt;
  const QueueSnapshotData({
    required this.userId,
    required this.itemIds,
    required this.currentIndex,
    required this.currentPositionMs,
    required this.shuffleEnabled,
    required this.repeatMode,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['item_ids'] = Variable<String>(itemIds);
    map['current_index'] = Variable<int>(currentIndex);
    map['current_position_ms'] = Variable<int>(currentPositionMs);
    map['shuffle_enabled'] = Variable<bool>(shuffleEnabled);
    map['repeat_mode'] = Variable<String>(repeatMode);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  QueueSnapshotCompanion toCompanion(bool nullToAbsent) {
    return QueueSnapshotCompanion(
      userId: Value(userId),
      itemIds: Value(itemIds),
      currentIndex: Value(currentIndex),
      currentPositionMs: Value(currentPositionMs),
      shuffleEnabled: Value(shuffleEnabled),
      repeatMode: Value(repeatMode),
      updatedAt: Value(updatedAt),
    );
  }

  factory QueueSnapshotData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QueueSnapshotData(
      userId: serializer.fromJson<String>(json['userId']),
      itemIds: serializer.fromJson<String>(json['itemIds']),
      currentIndex: serializer.fromJson<int>(json['currentIndex']),
      currentPositionMs: serializer.fromJson<int>(json['currentPositionMs']),
      shuffleEnabled: serializer.fromJson<bool>(json['shuffleEnabled']),
      repeatMode: serializer.fromJson<String>(json['repeatMode']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'itemIds': serializer.toJson<String>(itemIds),
      'currentIndex': serializer.toJson<int>(currentIndex),
      'currentPositionMs': serializer.toJson<int>(currentPositionMs),
      'shuffleEnabled': serializer.toJson<bool>(shuffleEnabled),
      'repeatMode': serializer.toJson<String>(repeatMode),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  QueueSnapshotData copyWith({
    String? userId,
    String? itemIds,
    int? currentIndex,
    int? currentPositionMs,
    bool? shuffleEnabled,
    String? repeatMode,
    DateTime? updatedAt,
  }) => QueueSnapshotData(
    userId: userId ?? this.userId,
    itemIds: itemIds ?? this.itemIds,
    currentIndex: currentIndex ?? this.currentIndex,
    currentPositionMs: currentPositionMs ?? this.currentPositionMs,
    shuffleEnabled: shuffleEnabled ?? this.shuffleEnabled,
    repeatMode: repeatMode ?? this.repeatMode,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  QueueSnapshotData copyWithCompanion(QueueSnapshotCompanion data) {
    return QueueSnapshotData(
      userId: data.userId.present ? data.userId.value : this.userId,
      itemIds: data.itemIds.present ? data.itemIds.value : this.itemIds,
      currentIndex: data.currentIndex.present
          ? data.currentIndex.value
          : this.currentIndex,
      currentPositionMs: data.currentPositionMs.present
          ? data.currentPositionMs.value
          : this.currentPositionMs,
      shuffleEnabled: data.shuffleEnabled.present
          ? data.shuffleEnabled.value
          : this.shuffleEnabled,
      repeatMode: data.repeatMode.present
          ? data.repeatMode.value
          : this.repeatMode,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QueueSnapshotData(')
          ..write('userId: $userId, ')
          ..write('itemIds: $itemIds, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('currentPositionMs: $currentPositionMs, ')
          ..write('shuffleEnabled: $shuffleEnabled, ')
          ..write('repeatMode: $repeatMode, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    itemIds,
    currentIndex,
    currentPositionMs,
    shuffleEnabled,
    repeatMode,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QueueSnapshotData &&
          other.userId == this.userId &&
          other.itemIds == this.itemIds &&
          other.currentIndex == this.currentIndex &&
          other.currentPositionMs == this.currentPositionMs &&
          other.shuffleEnabled == this.shuffleEnabled &&
          other.repeatMode == this.repeatMode &&
          other.updatedAt == this.updatedAt);
}

class QueueSnapshotCompanion extends UpdateCompanion<QueueSnapshotData> {
  final Value<String> userId;
  final Value<String> itemIds;
  final Value<int> currentIndex;
  final Value<int> currentPositionMs;
  final Value<bool> shuffleEnabled;
  final Value<String> repeatMode;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const QueueSnapshotCompanion({
    this.userId = const Value.absent(),
    this.itemIds = const Value.absent(),
    this.currentIndex = const Value.absent(),
    this.currentPositionMs = const Value.absent(),
    this.shuffleEnabled = const Value.absent(),
    this.repeatMode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QueueSnapshotCompanion.insert({
    required String userId,
    required String itemIds,
    this.currentIndex = const Value.absent(),
    this.currentPositionMs = const Value.absent(),
    this.shuffleEnabled = const Value.absent(),
    this.repeatMode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       itemIds = Value(itemIds);
  static Insertable<QueueSnapshotData> custom({
    Expression<String>? userId,
    Expression<String>? itemIds,
    Expression<int>? currentIndex,
    Expression<int>? currentPositionMs,
    Expression<bool>? shuffleEnabled,
    Expression<String>? repeatMode,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (itemIds != null) 'item_ids': itemIds,
      if (currentIndex != null) 'current_index': currentIndex,
      if (currentPositionMs != null) 'current_position_ms': currentPositionMs,
      if (shuffleEnabled != null) 'shuffle_enabled': shuffleEnabled,
      if (repeatMode != null) 'repeat_mode': repeatMode,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QueueSnapshotCompanion copyWith({
    Value<String>? userId,
    Value<String>? itemIds,
    Value<int>? currentIndex,
    Value<int>? currentPositionMs,
    Value<bool>? shuffleEnabled,
    Value<String>? repeatMode,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return QueueSnapshotCompanion(
      userId: userId ?? this.userId,
      itemIds: itemIds ?? this.itemIds,
      currentIndex: currentIndex ?? this.currentIndex,
      currentPositionMs: currentPositionMs ?? this.currentPositionMs,
      shuffleEnabled: shuffleEnabled ?? this.shuffleEnabled,
      repeatMode: repeatMode ?? this.repeatMode,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (itemIds.present) {
      map['item_ids'] = Variable<String>(itemIds.value);
    }
    if (currentIndex.present) {
      map['current_index'] = Variable<int>(currentIndex.value);
    }
    if (currentPositionMs.present) {
      map['current_position_ms'] = Variable<int>(currentPositionMs.value);
    }
    if (shuffleEnabled.present) {
      map['shuffle_enabled'] = Variable<bool>(shuffleEnabled.value);
    }
    if (repeatMode.present) {
      map['repeat_mode'] = Variable<String>(repeatMode.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QueueSnapshotCompanion(')
          ..write('userId: $userId, ')
          ..write('itemIds: $itemIds, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('currentPositionMs: $currentPositionMs, ')
          ..write('shuffleEnabled: $shuffleEnabled, ')
          ..write('repeatMode: $repeatMode, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalNotificationsTable extends LocalNotifications
    with TableInfo<$LocalNotificationsTable, LocalNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    body,
    type,
    isRead,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalNotification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalNotification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalNotificationsTable createAlias(String alias) {
    return $LocalNotificationsTable(attachedDatabase, alias);
  }
}

class LocalNotification extends DataClass
    implements Insertable<LocalNotification> {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  const LocalNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['type'] = Variable<String>(type);
    map['is_read'] = Variable<bool>(isRead);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalNotificationsCompanion toCompanion(bool nullToAbsent) {
    return LocalNotificationsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      body: Value(body),
      type: Value(type),
      isRead: Value(isRead),
      createdAt: Value(createdAt),
    );
  }

  factory LocalNotification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalNotification(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      type: serializer.fromJson<String>(json['type']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'type': serializer.toJson<String>(type),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalNotification copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    DateTime? createdAt,
  }) => LocalNotification(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    body: body ?? this.body,
    type: type ?? this.type,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalNotification copyWithCompanion(LocalNotificationsCompanion data) {
    return LocalNotification(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      type: data.type.present ? data.type.value : this.type,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalNotification(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, title, body, type, isRead, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalNotification &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.body == this.body &&
          other.type == this.type &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt);
}

class LocalNotificationsCompanion extends UpdateCompanion<LocalNotification> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String> body;
  final Value<String> type;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalNotificationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.type = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalNotificationsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    required String body,
    required String type,
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       title = Value(title),
       body = Value(body),
       type = Value(type);
  static Insertable<LocalNotification> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? type,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (type != null) 'type': type,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalNotificationsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? title,
    Value<String>? body,
    Value<String>? type,
    Value<bool>? isRead,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalNotificationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalFeatureFlagsTable extends LocalFeatureFlags
    with TableInfo<$LocalFeatureFlagsTable, LocalFeatureFlag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalFeatureFlagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _featureKeyMeta = const VerificationMeta(
    'featureKey',
  );
  @override
  late final GeneratedColumn<String> featureKey = GeneratedColumn<String>(
    'feature_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [featureKey, enabled, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_feature_flags';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalFeatureFlag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('feature_key')) {
      context.handle(
        _featureKeyMeta,
        featureKey.isAcceptableOrUnknown(data['feature_key']!, _featureKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_featureKeyMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {featureKey};
  @override
  LocalFeatureFlag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalFeatureFlag(
      featureKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_key'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalFeatureFlagsTable createAlias(String alias) {
    return $LocalFeatureFlagsTable(attachedDatabase, alias);
  }
}

class LocalFeatureFlag extends DataClass
    implements Insertable<LocalFeatureFlag> {
  final String featureKey;
  final bool enabled;
  final DateTime updatedAt;
  const LocalFeatureFlag({
    required this.featureKey,
    required this.enabled,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['feature_key'] = Variable<String>(featureKey);
    map['enabled'] = Variable<bool>(enabled);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalFeatureFlagsCompanion toCompanion(bool nullToAbsent) {
    return LocalFeatureFlagsCompanion(
      featureKey: Value(featureKey),
      enabled: Value(enabled),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalFeatureFlag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalFeatureFlag(
      featureKey: serializer.fromJson<String>(json['featureKey']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'featureKey': serializer.toJson<String>(featureKey),
      'enabled': serializer.toJson<bool>(enabled),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalFeatureFlag copyWith({
    String? featureKey,
    bool? enabled,
    DateTime? updatedAt,
  }) => LocalFeatureFlag(
    featureKey: featureKey ?? this.featureKey,
    enabled: enabled ?? this.enabled,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalFeatureFlag copyWithCompanion(LocalFeatureFlagsCompanion data) {
    return LocalFeatureFlag(
      featureKey: data.featureKey.present
          ? data.featureKey.value
          : this.featureKey,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalFeatureFlag(')
          ..write('featureKey: $featureKey, ')
          ..write('enabled: $enabled, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(featureKey, enabled, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalFeatureFlag &&
          other.featureKey == this.featureKey &&
          other.enabled == this.enabled &&
          other.updatedAt == this.updatedAt);
}

class LocalFeatureFlagsCompanion extends UpdateCompanion<LocalFeatureFlag> {
  final Value<String> featureKey;
  final Value<bool> enabled;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalFeatureFlagsCompanion({
    this.featureKey = const Value.absent(),
    this.enabled = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalFeatureFlagsCompanion.insert({
    required String featureKey,
    this.enabled = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : featureKey = Value(featureKey);
  static Insertable<LocalFeatureFlag> custom({
    Expression<String>? featureKey,
    Expression<bool>? enabled,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (featureKey != null) 'feature_key': featureKey,
      if (enabled != null) 'enabled': enabled,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalFeatureFlagsCompanion copyWith({
    Value<String>? featureKey,
    Value<bool>? enabled,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalFeatureFlagsCompanion(
      featureKey: featureKey ?? this.featureKey,
      enabled: enabled ?? this.enabled,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (featureKey.present) {
      map['feature_key'] = Variable<String>(featureKey.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalFeatureFlagsCompanion(')
          ..write('featureKey: $featureKey, ')
          ..write('enabled: $enabled, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalFeatureOverridesTable extends LocalFeatureOverrides
    with TableInfo<$LocalFeatureOverridesTable, LocalFeatureOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalFeatureOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureKeyMeta = const VerificationMeta(
    'featureKey',
  );
  @override
  late final GeneratedColumn<String> featureKey = GeneratedColumn<String>(
    'feature_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    featureKey,
    enabled,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_feature_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalFeatureOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('feature_key')) {
      context.handle(
        _featureKeyMeta,
        featureKey.isAcceptableOrUnknown(data['feature_key']!, _featureKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_featureKeyMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, featureKey};
  @override
  LocalFeatureOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalFeatureOverride(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      featureKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_key'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalFeatureOverridesTable createAlias(String alias) {
    return $LocalFeatureOverridesTable(attachedDatabase, alias);
  }
}

class LocalFeatureOverride extends DataClass
    implements Insertable<LocalFeatureOverride> {
  final String userId;
  final String featureKey;
  final bool enabled;
  final DateTime updatedAt;
  const LocalFeatureOverride({
    required this.userId,
    required this.featureKey,
    required this.enabled,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['feature_key'] = Variable<String>(featureKey);
    map['enabled'] = Variable<bool>(enabled);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalFeatureOverridesCompanion toCompanion(bool nullToAbsent) {
    return LocalFeatureOverridesCompanion(
      userId: Value(userId),
      featureKey: Value(featureKey),
      enabled: Value(enabled),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalFeatureOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalFeatureOverride(
      userId: serializer.fromJson<String>(json['userId']),
      featureKey: serializer.fromJson<String>(json['featureKey']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'featureKey': serializer.toJson<String>(featureKey),
      'enabled': serializer.toJson<bool>(enabled),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalFeatureOverride copyWith({
    String? userId,
    String? featureKey,
    bool? enabled,
    DateTime? updatedAt,
  }) => LocalFeatureOverride(
    userId: userId ?? this.userId,
    featureKey: featureKey ?? this.featureKey,
    enabled: enabled ?? this.enabled,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalFeatureOverride copyWithCompanion(LocalFeatureOverridesCompanion data) {
    return LocalFeatureOverride(
      userId: data.userId.present ? data.userId.value : this.userId,
      featureKey: data.featureKey.present
          ? data.featureKey.value
          : this.featureKey,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalFeatureOverride(')
          ..write('userId: $userId, ')
          ..write('featureKey: $featureKey, ')
          ..write('enabled: $enabled, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, featureKey, enabled, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalFeatureOverride &&
          other.userId == this.userId &&
          other.featureKey == this.featureKey &&
          other.enabled == this.enabled &&
          other.updatedAt == this.updatedAt);
}

class LocalFeatureOverridesCompanion
    extends UpdateCompanion<LocalFeatureOverride> {
  final Value<String> userId;
  final Value<String> featureKey;
  final Value<bool> enabled;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalFeatureOverridesCompanion({
    this.userId = const Value.absent(),
    this.featureKey = const Value.absent(),
    this.enabled = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalFeatureOverridesCompanion.insert({
    required String userId,
    required String featureKey,
    required bool enabled,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       featureKey = Value(featureKey),
       enabled = Value(enabled);
  static Insertable<LocalFeatureOverride> custom({
    Expression<String>? userId,
    Expression<String>? featureKey,
    Expression<bool>? enabled,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (featureKey != null) 'feature_key': featureKey,
      if (enabled != null) 'enabled': enabled,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalFeatureOverridesCompanion copyWith({
    Value<String>? userId,
    Value<String>? featureKey,
    Value<bool>? enabled,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalFeatureOverridesCompanion(
      userId: userId ?? this.userId,
      featureKey: featureKey ?? this.featureKey,
      enabled: enabled ?? this.enabled,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (featureKey.present) {
      map['feature_key'] = Variable<String>(featureKey.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalFeatureOverridesCompanion(')
          ..write('userId: $userId, ')
          ..write('featureKey: $featureKey, ')
          ..write('enabled: $enabled, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalProfilesTable localProfiles = $LocalProfilesTable(this);
  late final $FolderSourcesTable folderSources = $FolderSourcesTable(this);
  late final $AudioItemsTable audioItems = $AudioItemsTable(this);
  late final $AudioFilesTable audioFiles = $AudioFilesTable(this);
  late final $ClipRecordsTable clipRecords = $ClipRecordsTable(this);
  late final $MergedTracksTable mergedTracks = $MergedTracksTable(this);
  late final $MergeItemsTable mergeItems = $MergeItemsTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $PlaylistItemsTable playlistItems = $PlaylistItemsTable(this);
  late final $PlayHistoryTable playHistory = $PlayHistoryTable(this);
  late final $QueueSnapshotTable queueSnapshot = $QueueSnapshotTable(this);
  late final $LocalNotificationsTable localNotifications =
      $LocalNotificationsTable(this);
  late final $LocalFeatureFlagsTable localFeatureFlags =
      $LocalFeatureFlagsTable(this);
  late final $LocalFeatureOverridesTable localFeatureOverrides =
      $LocalFeatureOverridesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localProfiles,
    folderSources,
    audioItems,
    audioFiles,
    clipRecords,
    mergedTracks,
    mergeItems,
    playlists,
    playlistItems,
    playHistory,
    queueSnapshot,
    localNotifications,
    localFeatureFlags,
    localFeatureOverrides,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audio_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('audio_files', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audio_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('clip_records', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'merged_tracks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('merge_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'playlists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('playlist_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audio_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('playlist_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audio_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('play_history', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LocalProfilesTableCreateCompanionBuilder =
    LocalProfilesCompanion Function({
      required String id,
      required String username,
      Value<String?> displayName,
      Value<String?> email,
      Value<String?> avatarPath,
      Value<String> role,
      Value<bool> isLoggedIn,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalProfilesTableUpdateCompanionBuilder =
    LocalProfilesCompanion Function({
      Value<String> id,
      Value<String> username,
      Value<String?> displayName,
      Value<String?> email,
      Value<String?> avatarPath,
      Value<String> role,
      Value<bool> isLoggedIn,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLoggedIn => $composableBuilder(
    column: $table.isLoggedIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLoggedIn => $composableBuilder(
    column: $table.isLoggedIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get isLoggedIn => $composableBuilder(
    column: $table.isLoggedIn,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalProfilesTable,
          LocalProfile,
          $$LocalProfilesTableFilterComposer,
          $$LocalProfilesTableOrderingComposer,
          $$LocalProfilesTableAnnotationComposer,
          $$LocalProfilesTableCreateCompanionBuilder,
          $$LocalProfilesTableUpdateCompanionBuilder,
          (
            LocalProfile,
            BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfile>,
          ),
          LocalProfile,
          PrefetchHooks Function()
        > {
  $$LocalProfilesTableTableManager(_$AppDatabase db, $LocalProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> isLoggedIn = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProfilesCompanion(
                id: id,
                username: username,
                displayName: displayName,
                email: email,
                avatarPath: avatarPath,
                role: role,
                isLoggedIn: isLoggedIn,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String username,
                Value<String?> displayName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> isLoggedIn = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProfilesCompanion.insert(
                id: id,
                username: username,
                displayName: displayName,
                email: email,
                avatarPath: avatarPath,
                role: role,
                isLoggedIn: isLoggedIn,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalProfilesTable,
      LocalProfile,
      $$LocalProfilesTableFilterComposer,
      $$LocalProfilesTableOrderingComposer,
      $$LocalProfilesTableAnnotationComposer,
      $$LocalProfilesTableCreateCompanionBuilder,
      $$LocalProfilesTableUpdateCompanionBuilder,
      (
        LocalProfile,
        BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfile>,
      ),
      LocalProfile,
      PrefetchHooks Function()
    >;
typedef $$FolderSourcesTableCreateCompanionBuilder =
    FolderSourcesCompanion Function({
      Value<int> id,
      required String userId,
      required String folderPath,
      Value<String?> displayName,
      Value<DateTime?> lastScannedAt,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$FolderSourcesTableUpdateCompanionBuilder =
    FolderSourcesCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String> folderPath,
      Value<String?> displayName,
      Value<DateTime?> lastScannedAt,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

class $$FolderSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $FolderSourcesTable> {
  $$FolderSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folderPath => $composableBuilder(
    column: $table.folderPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastScannedAt => $composableBuilder(
    column: $table.lastScannedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FolderSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $FolderSourcesTable> {
  $$FolderSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folderPath => $composableBuilder(
    column: $table.folderPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastScannedAt => $composableBuilder(
    column: $table.lastScannedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FolderSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FolderSourcesTable> {
  $$FolderSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get folderPath => $composableBuilder(
    column: $table.folderPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastScannedAt => $composableBuilder(
    column: $table.lastScannedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FolderSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FolderSourcesTable,
          FolderSource,
          $$FolderSourcesTableFilterComposer,
          $$FolderSourcesTableOrderingComposer,
          $$FolderSourcesTableAnnotationComposer,
          $$FolderSourcesTableCreateCompanionBuilder,
          $$FolderSourcesTableUpdateCompanionBuilder,
          (
            FolderSource,
            BaseReferences<_$AppDatabase, $FolderSourcesTable, FolderSource>,
          ),
          FolderSource,
          PrefetchHooks Function()
        > {
  $$FolderSourcesTableTableManager(_$AppDatabase db, $FolderSourcesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FolderSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FolderSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FolderSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> folderPath = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<DateTime?> lastScannedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FolderSourcesCompanion(
                id: id,
                userId: userId,
                folderPath: folderPath,
                displayName: displayName,
                lastScannedAt: lastScannedAt,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required String folderPath,
                Value<String?> displayName = const Value.absent(),
                Value<DateTime?> lastScannedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FolderSourcesCompanion.insert(
                id: id,
                userId: userId,
                folderPath: folderPath,
                displayName: displayName,
                lastScannedAt: lastScannedAt,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FolderSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FolderSourcesTable,
      FolderSource,
      $$FolderSourcesTableFilterComposer,
      $$FolderSourcesTableOrderingComposer,
      $$FolderSourcesTableAnnotationComposer,
      $$FolderSourcesTableCreateCompanionBuilder,
      $$FolderSourcesTableUpdateCompanionBuilder,
      (
        FolderSource,
        BaseReferences<_$AppDatabase, $FolderSourcesTable, FolderSource>,
      ),
      FolderSource,
      PrefetchHooks Function()
    >;
typedef $$AudioItemsTableCreateCompanionBuilder =
    AudioItemsCompanion Function({
      required String id,
      required String userId,
      required String itemType,
      required String title,
      Value<String?> artist,
      Value<String?> album,
      Value<String?> albumArtist,
      Value<String?> genre,
      Value<int?> year,
      Value<int?> trackNumber,
      Value<String?> composer,
      Value<int?> durationMs,
      Value<String?> artworkPath,
      Value<bool> isLiked,
      Value<int?> starNumber,
      Value<int> playCount,
      Value<DateTime?> lastPlayedAt,
      Value<int> resumePositionMs,
      Value<bool> isAvailable,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AudioItemsTableUpdateCompanionBuilder =
    AudioItemsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> itemType,
      Value<String> title,
      Value<String?> artist,
      Value<String?> album,
      Value<String?> albumArtist,
      Value<String?> genre,
      Value<int?> year,
      Value<int?> trackNumber,
      Value<String?> composer,
      Value<int?> durationMs,
      Value<String?> artworkPath,
      Value<bool> isLiked,
      Value<int?> starNumber,
      Value<int> playCount,
      Value<DateTime?> lastPlayedAt,
      Value<int> resumePositionMs,
      Value<bool> isAvailable,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$AudioItemsTableReferences
    extends BaseReferences<_$AppDatabase, $AudioItemsTable, AudioItem> {
  $$AudioItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AudioFilesTable, List<AudioFile>>
  _audioFilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.audioFiles,
    aliasName: $_aliasNameGenerator(
      db.audioItems.id,
      db.audioFiles.audioItemId,
    ),
  );

  $$AudioFilesTableProcessedTableManager get audioFilesRefs {
    final manager = $$AudioFilesTableTableManager(
      $_db,
      $_db.audioFiles,
    ).filter((f) => f.audioItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_audioFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MergeItemsTable, List<MergeItem>>
  _mergeItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mergeItems,
    aliasName: $_aliasNameGenerator(
      db.audioItems.id,
      db.mergeItems.audioItemId,
    ),
  );

  $$MergeItemsTableProcessedTableManager get mergeItemsRefs {
    final manager = $$MergeItemsTableTableManager(
      $_db,
      $_db.mergeItems,
    ).filter((f) => f.audioItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mergeItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlaylistItemsTable, List<PlaylistItem>>
  _playlistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playlistItems,
    aliasName: $_aliasNameGenerator(
      db.audioItems.id,
      db.playlistItems.audioItemId,
    ),
  );

  $$PlaylistItemsTableProcessedTableManager get playlistItemsRefs {
    final manager = $$PlaylistItemsTableTableManager(
      $_db,
      $_db.playlistItems,
    ).filter((f) => f.audioItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_playlistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlayHistoryTable, List<PlayHistoryData>>
  _playHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playHistory,
    aliasName: $_aliasNameGenerator(
      db.audioItems.id,
      db.playHistory.audioItemId,
    ),
  );

  $$PlayHistoryTableProcessedTableManager get playHistoryRefs {
    final manager = $$PlayHistoryTableTableManager(
      $_db,
      $_db.playHistory,
    ).filter((f) => f.audioItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_playHistoryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AudioItemsTableFilterComposer
    extends Composer<_$AppDatabase, $AudioItemsTable> {
  $$AudioItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get album => $composableBuilder(
    column: $table.album,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get composer => $composableBuilder(
    column: $table.composer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get starNumber => $composableBuilder(
    column: $table.starNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playCount => $composableBuilder(
    column: $table.playCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get resumePositionMs => $composableBuilder(
    column: $table.resumePositionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> audioFilesRefs(
    Expression<bool> Function($$AudioFilesTableFilterComposer f) f,
  ) {
    final $$AudioFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.audioFiles,
      getReferencedColumn: (t) => t.audioItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioFilesTableFilterComposer(
            $db: $db,
            $table: $db.audioFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mergeItemsRefs(
    Expression<bool> Function($$MergeItemsTableFilterComposer f) f,
  ) {
    final $$MergeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mergeItems,
      getReferencedColumn: (t) => t.audioItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MergeItemsTableFilterComposer(
            $db: $db,
            $table: $db.mergeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playlistItemsRefs(
    Expression<bool> Function($$PlaylistItemsTableFilterComposer f) f,
  ) {
    final $$PlaylistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistItems,
      getReferencedColumn: (t) => t.audioItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistItemsTableFilterComposer(
            $db: $db,
            $table: $db.playlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playHistoryRefs(
    Expression<bool> Function($$PlayHistoryTableFilterComposer f) f,
  ) {
    final $$PlayHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playHistory,
      getReferencedColumn: (t) => t.audioItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayHistoryTableFilterComposer(
            $db: $db,
            $table: $db.playHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AudioItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $AudioItemsTable> {
  $$AudioItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get album => $composableBuilder(
    column: $table.album,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get composer => $composableBuilder(
    column: $table.composer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get starNumber => $composableBuilder(
    column: $table.starNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playCount => $composableBuilder(
    column: $table.playCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get resumePositionMs => $composableBuilder(
    column: $table.resumePositionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AudioItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudioItemsTable> {
  $$AudioItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get album =>
      $composableBuilder(column: $table.album, builder: (column) => column);

  GeneratedColumn<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => column,
  );

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get composer =>
      $composableBuilder(column: $table.composer, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLiked =>
      $composableBuilder(column: $table.isLiked, builder: (column) => column);

  GeneratedColumn<int> get starNumber => $composableBuilder(
    column: $table.starNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get playCount =>
      $composableBuilder(column: $table.playCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get resumePositionMs => $composableBuilder(
    column: $table.resumePositionMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> audioFilesRefs<T extends Object>(
    Expression<T> Function($$AudioFilesTableAnnotationComposer a) f,
  ) {
    final $$AudioFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.audioFiles,
      getReferencedColumn: (t) => t.audioItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.audioFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mergeItemsRefs<T extends Object>(
    Expression<T> Function($$MergeItemsTableAnnotationComposer a) f,
  ) {
    final $$MergeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mergeItems,
      getReferencedColumn: (t) => t.audioItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MergeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.mergeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> playlistItemsRefs<T extends Object>(
    Expression<T> Function($$PlaylistItemsTableAnnotationComposer a) f,
  ) {
    final $$PlaylistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistItems,
      getReferencedColumn: (t) => t.audioItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.playlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> playHistoryRefs<T extends Object>(
    Expression<T> Function($$PlayHistoryTableAnnotationComposer a) f,
  ) {
    final $$PlayHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playHistory,
      getReferencedColumn: (t) => t.audioItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.playHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AudioItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AudioItemsTable,
          AudioItem,
          $$AudioItemsTableFilterComposer,
          $$AudioItemsTableOrderingComposer,
          $$AudioItemsTableAnnotationComposer,
          $$AudioItemsTableCreateCompanionBuilder,
          $$AudioItemsTableUpdateCompanionBuilder,
          (AudioItem, $$AudioItemsTableReferences),
          AudioItem,
          PrefetchHooks Function({
            bool audioFilesRefs,
            bool mergeItemsRefs,
            bool playlistItemsRefs,
            bool playHistoryRefs,
          })
        > {
  $$AudioItemsTableTableManager(_$AppDatabase db, $AudioItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudioItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudioItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudioItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> artist = const Value.absent(),
                Value<String?> album = const Value.absent(),
                Value<String?> albumArtist = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<int?> trackNumber = const Value.absent(),
                Value<String?> composer = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> artworkPath = const Value.absent(),
                Value<bool> isLiked = const Value.absent(),
                Value<int?> starNumber = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> resumePositionMs = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudioItemsCompanion(
                id: id,
                userId: userId,
                itemType: itemType,
                title: title,
                artist: artist,
                album: album,
                albumArtist: albumArtist,
                genre: genre,
                year: year,
                trackNumber: trackNumber,
                composer: composer,
                durationMs: durationMs,
                artworkPath: artworkPath,
                isLiked: isLiked,
                starNumber: starNumber,
                playCount: playCount,
                lastPlayedAt: lastPlayedAt,
                resumePositionMs: resumePositionMs,
                isAvailable: isAvailable,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String itemType,
                required String title,
                Value<String?> artist = const Value.absent(),
                Value<String?> album = const Value.absent(),
                Value<String?> albumArtist = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<int?> trackNumber = const Value.absent(),
                Value<String?> composer = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> artworkPath = const Value.absent(),
                Value<bool> isLiked = const Value.absent(),
                Value<int?> starNumber = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> resumePositionMs = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudioItemsCompanion.insert(
                id: id,
                userId: userId,
                itemType: itemType,
                title: title,
                artist: artist,
                album: album,
                albumArtist: albumArtist,
                genre: genre,
                year: year,
                trackNumber: trackNumber,
                composer: composer,
                durationMs: durationMs,
                artworkPath: artworkPath,
                isLiked: isLiked,
                starNumber: starNumber,
                playCount: playCount,
                lastPlayedAt: lastPlayedAt,
                resumePositionMs: resumePositionMs,
                isAvailable: isAvailable,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AudioItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                audioFilesRefs = false,
                mergeItemsRefs = false,
                playlistItemsRefs = false,
                playHistoryRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (audioFilesRefs) db.audioFiles,
                    if (mergeItemsRefs) db.mergeItems,
                    if (playlistItemsRefs) db.playlistItems,
                    if (playHistoryRefs) db.playHistory,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (audioFilesRefs)
                        await $_getPrefetchedData<
                          AudioItem,
                          $AudioItemsTable,
                          AudioFile
                        >(
                          currentTable: table,
                          referencedTable: $$AudioItemsTableReferences
                              ._audioFilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AudioItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).audioFilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.audioItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mergeItemsRefs)
                        await $_getPrefetchedData<
                          AudioItem,
                          $AudioItemsTable,
                          MergeItem
                        >(
                          currentTable: table,
                          referencedTable: $$AudioItemsTableReferences
                              ._mergeItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AudioItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).mergeItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.audioItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (playlistItemsRefs)
                        await $_getPrefetchedData<
                          AudioItem,
                          $AudioItemsTable,
                          PlaylistItem
                        >(
                          currentTable: table,
                          referencedTable: $$AudioItemsTableReferences
                              ._playlistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AudioItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).playlistItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.audioItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (playHistoryRefs)
                        await $_getPrefetchedData<
                          AudioItem,
                          $AudioItemsTable,
                          PlayHistoryData
                        >(
                          currentTable: table,
                          referencedTable: $$AudioItemsTableReferences
                              ._playHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AudioItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).playHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.audioItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AudioItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AudioItemsTable,
      AudioItem,
      $$AudioItemsTableFilterComposer,
      $$AudioItemsTableOrderingComposer,
      $$AudioItemsTableAnnotationComposer,
      $$AudioItemsTableCreateCompanionBuilder,
      $$AudioItemsTableUpdateCompanionBuilder,
      (AudioItem, $$AudioItemsTableReferences),
      AudioItem,
      PrefetchHooks Function({
        bool audioFilesRefs,
        bool mergeItemsRefs,
        bool playlistItemsRefs,
        bool playHistoryRefs,
      })
    >;
typedef $$AudioFilesTableCreateCompanionBuilder =
    AudioFilesCompanion Function({
      required String id,
      required String audioItemId,
      required String filePath,
      Value<String?> fileHash,
      Value<int?> fileSizeBytes,
      Value<String?> mimeType,
      Value<int?> bitRate,
      Value<int?> sampleRate,
      Value<int?> channels,
      Value<bool> isAvailable,
      Value<DateTime?> lastVerifiedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$AudioFilesTableUpdateCompanionBuilder =
    AudioFilesCompanion Function({
      Value<String> id,
      Value<String> audioItemId,
      Value<String> filePath,
      Value<String?> fileHash,
      Value<int?> fileSizeBytes,
      Value<String?> mimeType,
      Value<int?> bitRate,
      Value<int?> sampleRate,
      Value<int?> channels,
      Value<bool> isAvailable,
      Value<DateTime?> lastVerifiedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$AudioFilesTableReferences
    extends BaseReferences<_$AppDatabase, $AudioFilesTable, AudioFile> {
  $$AudioFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AudioItemsTable _audioItemIdTable(_$AppDatabase db) =>
      db.audioItems.createAlias(
        $_aliasNameGenerator(db.audioFiles.audioItemId, db.audioItems.id),
      );

  $$AudioItemsTableProcessedTableManager get audioItemId {
    final $_column = $_itemColumn<String>('audio_item_id')!;

    final manager = $$AudioItemsTableTableManager(
      $_db,
      $_db.audioItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AudioFilesTableFilterComposer
    extends Composer<_$AppDatabase, $AudioFilesTable> {
  $$AudioFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bitRate => $composableBuilder(
    column: $table.bitRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get channels => $composableBuilder(
    column: $table.channels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AudioItemsTableFilterComposer get audioItemId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableFilterComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $AudioFilesTable> {
  $$AudioFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bitRate => $composableBuilder(
    column: $table.bitRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get channels => $composableBuilder(
    column: $table.channels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AudioItemsTableOrderingComposer get audioItemId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableOrderingComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudioFilesTable> {
  $$AudioFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get bitRate =>
      $composableBuilder(column: $table.bitRate, builder: (column) => column);

  GeneratedColumn<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get channels =>
      $composableBuilder(column: $table.channels, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AudioItemsTableAnnotationComposer get audioItemId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AudioFilesTable,
          AudioFile,
          $$AudioFilesTableFilterComposer,
          $$AudioFilesTableOrderingComposer,
          $$AudioFilesTableAnnotationComposer,
          $$AudioFilesTableCreateCompanionBuilder,
          $$AudioFilesTableUpdateCompanionBuilder,
          (AudioFile, $$AudioFilesTableReferences),
          AudioFile,
          PrefetchHooks Function({bool audioItemId})
        > {
  $$AudioFilesTableTableManager(_$AppDatabase db, $AudioFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudioFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudioFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudioFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> audioItemId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<int?> bitRate = const Value.absent(),
                Value<int?> sampleRate = const Value.absent(),
                Value<int?> channels = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<DateTime?> lastVerifiedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudioFilesCompanion(
                id: id,
                audioItemId: audioItemId,
                filePath: filePath,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                mimeType: mimeType,
                bitRate: bitRate,
                sampleRate: sampleRate,
                channels: channels,
                isAvailable: isAvailable,
                lastVerifiedAt: lastVerifiedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String audioItemId,
                required String filePath,
                Value<String?> fileHash = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<int?> bitRate = const Value.absent(),
                Value<int?> sampleRate = const Value.absent(),
                Value<int?> channels = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<DateTime?> lastVerifiedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudioFilesCompanion.insert(
                id: id,
                audioItemId: audioItemId,
                filePath: filePath,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                mimeType: mimeType,
                bitRate: bitRate,
                sampleRate: sampleRate,
                channels: channels,
                isAvailable: isAvailable,
                lastVerifiedAt: lastVerifiedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AudioFilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({audioItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (audioItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.audioItemId,
                                referencedTable: $$AudioFilesTableReferences
                                    ._audioItemIdTable(db),
                                referencedColumn: $$AudioFilesTableReferences
                                    ._audioItemIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AudioFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AudioFilesTable,
      AudioFile,
      $$AudioFilesTableFilterComposer,
      $$AudioFilesTableOrderingComposer,
      $$AudioFilesTableAnnotationComposer,
      $$AudioFilesTableCreateCompanionBuilder,
      $$AudioFilesTableUpdateCompanionBuilder,
      (AudioFile, $$AudioFilesTableReferences),
      AudioFile,
      PrefetchHooks Function({bool audioItemId})
    >;
typedef $$ClipRecordsTableCreateCompanionBuilder =
    ClipRecordsCompanion Function({
      required String id,
      required String audioItemId,
      required String sourceAudioItemId,
      Value<String?> parentClipId,
      required int startMs,
      required int endMs,
      Value<bool> isPhysical,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ClipRecordsTableUpdateCompanionBuilder =
    ClipRecordsCompanion Function({
      Value<String> id,
      Value<String> audioItemId,
      Value<String> sourceAudioItemId,
      Value<String?> parentClipId,
      Value<int> startMs,
      Value<int> endMs,
      Value<bool> isPhysical,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ClipRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $ClipRecordsTable, ClipRecord> {
  $$ClipRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AudioItemsTable _audioItemIdTable(_$AppDatabase db) =>
      db.audioItems.createAlias(
        $_aliasNameGenerator(db.clipRecords.audioItemId, db.audioItems.id),
      );

  $$AudioItemsTableProcessedTableManager get audioItemId {
    final $_column = $_itemColumn<String>('audio_item_id')!;

    final manager = $$AudioItemsTableTableManager(
      $_db,
      $_db.audioItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AudioItemsTable _sourceAudioItemIdTable(_$AppDatabase db) =>
      db.audioItems.createAlias(
        $_aliasNameGenerator(
          db.clipRecords.sourceAudioItemId,
          db.audioItems.id,
        ),
      );

  $$AudioItemsTableProcessedTableManager get sourceAudioItemId {
    final $_column = $_itemColumn<String>('source_audio_item_id')!;

    final manager = $$AudioItemsTableTableManager(
      $_db,
      $_db.audioItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceAudioItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClipRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ClipRecordsTable> {
  $$ClipRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentClipId => $composableBuilder(
    column: $table.parentClipId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMs => $composableBuilder(
    column: $table.startMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMs => $composableBuilder(
    column: $table.endMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPhysical => $composableBuilder(
    column: $table.isPhysical,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AudioItemsTableFilterComposer get audioItemId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableFilterComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudioItemsTableFilterComposer get sourceAudioItemId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAudioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableFilterComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClipRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClipRecordsTable> {
  $$ClipRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentClipId => $composableBuilder(
    column: $table.parentClipId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMs => $composableBuilder(
    column: $table.startMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMs => $composableBuilder(
    column: $table.endMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPhysical => $composableBuilder(
    column: $table.isPhysical,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AudioItemsTableOrderingComposer get audioItemId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableOrderingComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudioItemsTableOrderingComposer get sourceAudioItemId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAudioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableOrderingComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClipRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClipRecordsTable> {
  $$ClipRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get parentClipId => $composableBuilder(
    column: $table.parentClipId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMs =>
      $composableBuilder(column: $table.startMs, builder: (column) => column);

  GeneratedColumn<int> get endMs =>
      $composableBuilder(column: $table.endMs, builder: (column) => column);

  GeneratedColumn<bool> get isPhysical => $composableBuilder(
    column: $table.isPhysical,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AudioItemsTableAnnotationComposer get audioItemId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudioItemsTableAnnotationComposer get sourceAudioItemId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAudioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClipRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClipRecordsTable,
          ClipRecord,
          $$ClipRecordsTableFilterComposer,
          $$ClipRecordsTableOrderingComposer,
          $$ClipRecordsTableAnnotationComposer,
          $$ClipRecordsTableCreateCompanionBuilder,
          $$ClipRecordsTableUpdateCompanionBuilder,
          (ClipRecord, $$ClipRecordsTableReferences),
          ClipRecord,
          PrefetchHooks Function({bool audioItemId, bool sourceAudioItemId})
        > {
  $$ClipRecordsTableTableManager(_$AppDatabase db, $ClipRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClipRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClipRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClipRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> audioItemId = const Value.absent(),
                Value<String> sourceAudioItemId = const Value.absent(),
                Value<String?> parentClipId = const Value.absent(),
                Value<int> startMs = const Value.absent(),
                Value<int> endMs = const Value.absent(),
                Value<bool> isPhysical = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClipRecordsCompanion(
                id: id,
                audioItemId: audioItemId,
                sourceAudioItemId: sourceAudioItemId,
                parentClipId: parentClipId,
                startMs: startMs,
                endMs: endMs,
                isPhysical: isPhysical,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String audioItemId,
                required String sourceAudioItemId,
                Value<String?> parentClipId = const Value.absent(),
                required int startMs,
                required int endMs,
                Value<bool> isPhysical = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClipRecordsCompanion.insert(
                id: id,
                audioItemId: audioItemId,
                sourceAudioItemId: sourceAudioItemId,
                parentClipId: parentClipId,
                startMs: startMs,
                endMs: endMs,
                isPhysical: isPhysical,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClipRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({audioItemId = false, sourceAudioItemId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (audioItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.audioItemId,
                                    referencedTable:
                                        $$ClipRecordsTableReferences
                                            ._audioItemIdTable(db),
                                    referencedColumn:
                                        $$ClipRecordsTableReferences
                                            ._audioItemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sourceAudioItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceAudioItemId,
                                    referencedTable:
                                        $$ClipRecordsTableReferences
                                            ._sourceAudioItemIdTable(db),
                                    referencedColumn:
                                        $$ClipRecordsTableReferences
                                            ._sourceAudioItemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ClipRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClipRecordsTable,
      ClipRecord,
      $$ClipRecordsTableFilterComposer,
      $$ClipRecordsTableOrderingComposer,
      $$ClipRecordsTableAnnotationComposer,
      $$ClipRecordsTableCreateCompanionBuilder,
      $$ClipRecordsTableUpdateCompanionBuilder,
      (ClipRecord, $$ClipRecordsTableReferences),
      ClipRecord,
      PrefetchHooks Function({bool audioItemId, bool sourceAudioItemId})
    >;
typedef $$MergedTracksTableCreateCompanionBuilder =
    MergedTracksCompanion Function({
      required String id,
      Value<bool> isPhysical,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$MergedTracksTableUpdateCompanionBuilder =
    MergedTracksCompanion Function({
      Value<String> id,
      Value<bool> isPhysical,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$MergedTracksTableReferences
    extends BaseReferences<_$AppDatabase, $MergedTracksTable, MergedTrack> {
  $$MergedTracksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MergeItemsTable, List<MergeItem>>
  _mergeItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mergeItems,
    aliasName: $_aliasNameGenerator(
      db.mergedTracks.id,
      db.mergeItems.mergedTrackId,
    ),
  );

  $$MergeItemsTableProcessedTableManager get mergeItemsRefs {
    final manager = $$MergeItemsTableTableManager(
      $_db,
      $_db.mergeItems,
    ).filter((f) => f.mergedTrackId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mergeItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MergedTracksTableFilterComposer
    extends Composer<_$AppDatabase, $MergedTracksTable> {
  $$MergedTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPhysical => $composableBuilder(
    column: $table.isPhysical,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mergeItemsRefs(
    Expression<bool> Function($$MergeItemsTableFilterComposer f) f,
  ) {
    final $$MergeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mergeItems,
      getReferencedColumn: (t) => t.mergedTrackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MergeItemsTableFilterComposer(
            $db: $db,
            $table: $db.mergeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MergedTracksTableOrderingComposer
    extends Composer<_$AppDatabase, $MergedTracksTable> {
  $$MergedTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPhysical => $composableBuilder(
    column: $table.isPhysical,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MergedTracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $MergedTracksTable> {
  $$MergedTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isPhysical => $composableBuilder(
    column: $table.isPhysical,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> mergeItemsRefs<T extends Object>(
    Expression<T> Function($$MergeItemsTableAnnotationComposer a) f,
  ) {
    final $$MergeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mergeItems,
      getReferencedColumn: (t) => t.mergedTrackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MergeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.mergeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MergedTracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MergedTracksTable,
          MergedTrack,
          $$MergedTracksTableFilterComposer,
          $$MergedTracksTableOrderingComposer,
          $$MergedTracksTableAnnotationComposer,
          $$MergedTracksTableCreateCompanionBuilder,
          $$MergedTracksTableUpdateCompanionBuilder,
          (MergedTrack, $$MergedTracksTableReferences),
          MergedTrack,
          PrefetchHooks Function({bool mergeItemsRefs})
        > {
  $$MergedTracksTableTableManager(_$AppDatabase db, $MergedTracksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MergedTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MergedTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MergedTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<bool> isPhysical = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MergedTracksCompanion(
                id: id,
                isPhysical: isPhysical,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<bool> isPhysical = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MergedTracksCompanion.insert(
                id: id,
                isPhysical: isPhysical,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MergedTracksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mergeItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mergeItemsRefs) db.mergeItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mergeItemsRefs)
                    await $_getPrefetchedData<
                      MergedTrack,
                      $MergedTracksTable,
                      MergeItem
                    >(
                      currentTable: table,
                      referencedTable: $$MergedTracksTableReferences
                          ._mergeItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MergedTracksTableReferences(
                            db,
                            table,
                            p0,
                          ).mergeItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.mergedTrackId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MergedTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MergedTracksTable,
      MergedTrack,
      $$MergedTracksTableFilterComposer,
      $$MergedTracksTableOrderingComposer,
      $$MergedTracksTableAnnotationComposer,
      $$MergedTracksTableCreateCompanionBuilder,
      $$MergedTracksTableUpdateCompanionBuilder,
      (MergedTrack, $$MergedTracksTableReferences),
      MergedTrack,
      PrefetchHooks Function({bool mergeItemsRefs})
    >;
typedef $$MergeItemsTableCreateCompanionBuilder =
    MergeItemsCompanion Function({
      required String id,
      required String mergedTrackId,
      required String audioItemId,
      required int position,
      Value<int> fadeInMs,
      Value<int> fadeOutMs,
      Value<int> rowid,
    });
typedef $$MergeItemsTableUpdateCompanionBuilder =
    MergeItemsCompanion Function({
      Value<String> id,
      Value<String> mergedTrackId,
      Value<String> audioItemId,
      Value<int> position,
      Value<int> fadeInMs,
      Value<int> fadeOutMs,
      Value<int> rowid,
    });

final class $$MergeItemsTableReferences
    extends BaseReferences<_$AppDatabase, $MergeItemsTable, MergeItem> {
  $$MergeItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MergedTracksTable _mergedTrackIdTable(_$AppDatabase db) =>
      db.mergedTracks.createAlias(
        $_aliasNameGenerator(db.mergeItems.mergedTrackId, db.mergedTracks.id),
      );

  $$MergedTracksTableProcessedTableManager get mergedTrackId {
    final $_column = $_itemColumn<String>('merged_track_id')!;

    final manager = $$MergedTracksTableTableManager(
      $_db,
      $_db.mergedTracks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mergedTrackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AudioItemsTable _audioItemIdTable(_$AppDatabase db) =>
      db.audioItems.createAlias(
        $_aliasNameGenerator(db.mergeItems.audioItemId, db.audioItems.id),
      );

  $$AudioItemsTableProcessedTableManager get audioItemId {
    final $_column = $_itemColumn<String>('audio_item_id')!;

    final manager = $$AudioItemsTableTableManager(
      $_db,
      $_db.audioItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MergeItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MergeItemsTable> {
  $$MergeItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fadeInMs => $composableBuilder(
    column: $table.fadeInMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fadeOutMs => $composableBuilder(
    column: $table.fadeOutMs,
    builder: (column) => ColumnFilters(column),
  );

  $$MergedTracksTableFilterComposer get mergedTrackId {
    final $$MergedTracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mergedTrackId,
      referencedTable: $db.mergedTracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MergedTracksTableFilterComposer(
            $db: $db,
            $table: $db.mergedTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudioItemsTableFilterComposer get audioItemId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableFilterComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MergeItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MergeItemsTable> {
  $$MergeItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fadeInMs => $composableBuilder(
    column: $table.fadeInMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fadeOutMs => $composableBuilder(
    column: $table.fadeOutMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$MergedTracksTableOrderingComposer get mergedTrackId {
    final $$MergedTracksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mergedTrackId,
      referencedTable: $db.mergedTracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MergedTracksTableOrderingComposer(
            $db: $db,
            $table: $db.mergedTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudioItemsTableOrderingComposer get audioItemId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableOrderingComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MergeItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MergeItemsTable> {
  $$MergeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get fadeInMs =>
      $composableBuilder(column: $table.fadeInMs, builder: (column) => column);

  GeneratedColumn<int> get fadeOutMs =>
      $composableBuilder(column: $table.fadeOutMs, builder: (column) => column);

  $$MergedTracksTableAnnotationComposer get mergedTrackId {
    final $$MergedTracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mergedTrackId,
      referencedTable: $db.mergedTracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MergedTracksTableAnnotationComposer(
            $db: $db,
            $table: $db.mergedTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudioItemsTableAnnotationComposer get audioItemId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MergeItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MergeItemsTable,
          MergeItem,
          $$MergeItemsTableFilterComposer,
          $$MergeItemsTableOrderingComposer,
          $$MergeItemsTableAnnotationComposer,
          $$MergeItemsTableCreateCompanionBuilder,
          $$MergeItemsTableUpdateCompanionBuilder,
          (MergeItem, $$MergeItemsTableReferences),
          MergeItem,
          PrefetchHooks Function({bool mergedTrackId, bool audioItemId})
        > {
  $$MergeItemsTableTableManager(_$AppDatabase db, $MergeItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MergeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MergeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MergeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mergedTrackId = const Value.absent(),
                Value<String> audioItemId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> fadeInMs = const Value.absent(),
                Value<int> fadeOutMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MergeItemsCompanion(
                id: id,
                mergedTrackId: mergedTrackId,
                audioItemId: audioItemId,
                position: position,
                fadeInMs: fadeInMs,
                fadeOutMs: fadeOutMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mergedTrackId,
                required String audioItemId,
                required int position,
                Value<int> fadeInMs = const Value.absent(),
                Value<int> fadeOutMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MergeItemsCompanion.insert(
                id: id,
                mergedTrackId: mergedTrackId,
                audioItemId: audioItemId,
                position: position,
                fadeInMs: fadeInMs,
                fadeOutMs: fadeOutMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MergeItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({mergedTrackId = false, audioItemId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (mergedTrackId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.mergedTrackId,
                                    referencedTable: $$MergeItemsTableReferences
                                        ._mergedTrackIdTable(db),
                                    referencedColumn:
                                        $$MergeItemsTableReferences
                                            ._mergedTrackIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (audioItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.audioItemId,
                                    referencedTable: $$MergeItemsTableReferences
                                        ._audioItemIdTable(db),
                                    referencedColumn:
                                        $$MergeItemsTableReferences
                                            ._audioItemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$MergeItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MergeItemsTable,
      MergeItem,
      $$MergeItemsTableFilterComposer,
      $$MergeItemsTableOrderingComposer,
      $$MergeItemsTableAnnotationComposer,
      $$MergeItemsTableCreateCompanionBuilder,
      $$MergeItemsTableUpdateCompanionBuilder,
      (MergeItem, $$MergeItemsTableReferences),
      MergeItem,
      PrefetchHooks Function({bool mergedTrackId, bool audioItemId})
    >;
typedef $$PlaylistsTableCreateCompanionBuilder =
    PlaylistsCompanion Function({
      required String id,
      required String userId,
      required String name,
      Value<String?> description,
      Value<String?> artworkPath,
      Value<bool> isSmart,
      Value<String?> smartCriteria,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PlaylistsTableUpdateCompanionBuilder =
    PlaylistsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<String?> description,
      Value<String?> artworkPath,
      Value<bool> isSmart,
      Value<String?> smartCriteria,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PlaylistsTableReferences
    extends BaseReferences<_$AppDatabase, $PlaylistsTable, Playlist> {
  $$PlaylistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlaylistItemsTable, List<PlaylistItem>>
  _playlistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playlistItems,
    aliasName: $_aliasNameGenerator(
      db.playlists.id,
      db.playlistItems.playlistId,
    ),
  );

  $$PlaylistItemsTableProcessedTableManager get playlistItemsRefs {
    final manager = $$PlaylistItemsTableTableManager(
      $_db,
      $_db.playlistItems,
    ).filter((f) => f.playlistId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_playlistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlaylistsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSmart => $composableBuilder(
    column: $table.isSmart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smartCriteria => $composableBuilder(
    column: $table.smartCriteria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playlistItemsRefs(
    Expression<bool> Function($$PlaylistItemsTableFilterComposer f) f,
  ) {
    final $$PlaylistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistItems,
      getReferencedColumn: (t) => t.playlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistItemsTableFilterComposer(
            $db: $db,
            $table: $db.playlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaylistsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSmart => $composableBuilder(
    column: $table.isSmart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smartCriteria => $composableBuilder(
    column: $table.smartCriteria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaylistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSmart =>
      $composableBuilder(column: $table.isSmart, builder: (column) => column);

  GeneratedColumn<String> get smartCriteria => $composableBuilder(
    column: $table.smartCriteria,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> playlistItemsRefs<T extends Object>(
    Expression<T> Function($$PlaylistItemsTableAnnotationComposer a) f,
  ) {
    final $$PlaylistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistItems,
      getReferencedColumn: (t) => t.playlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.playlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaylistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistsTable,
          Playlist,
          $$PlaylistsTableFilterComposer,
          $$PlaylistsTableOrderingComposer,
          $$PlaylistsTableAnnotationComposer,
          $$PlaylistsTableCreateCompanionBuilder,
          $$PlaylistsTableUpdateCompanionBuilder,
          (Playlist, $$PlaylistsTableReferences),
          Playlist,
          PrefetchHooks Function({bool playlistItemsRefs})
        > {
  $$PlaylistsTableTableManager(_$AppDatabase db, $PlaylistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> artworkPath = const Value.absent(),
                Value<bool> isSmart = const Value.absent(),
                Value<String?> smartCriteria = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistsCompanion(
                id: id,
                userId: userId,
                name: name,
                description: description,
                artworkPath: artworkPath,
                isSmart: isSmart,
                smartCriteria: smartCriteria,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> artworkPath = const Value.absent(),
                Value<bool> isSmart = const Value.absent(),
                Value<String?> smartCriteria = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                description: description,
                artworkPath: artworkPath,
                isSmart: isSmart,
                smartCriteria: smartCriteria,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaylistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playlistItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playlistItemsRefs) db.playlistItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistItemsRefs)
                    await $_getPrefetchedData<
                      Playlist,
                      $PlaylistsTable,
                      PlaylistItem
                    >(
                      currentTable: table,
                      referencedTable: $$PlaylistsTableReferences
                          ._playlistItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlaylistsTableReferences(
                            db,
                            table,
                            p0,
                          ).playlistItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.playlistId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistsTable,
      Playlist,
      $$PlaylistsTableFilterComposer,
      $$PlaylistsTableOrderingComposer,
      $$PlaylistsTableAnnotationComposer,
      $$PlaylistsTableCreateCompanionBuilder,
      $$PlaylistsTableUpdateCompanionBuilder,
      (Playlist, $$PlaylistsTableReferences),
      Playlist,
      PrefetchHooks Function({bool playlistItemsRefs})
    >;
typedef $$PlaylistItemsTableCreateCompanionBuilder =
    PlaylistItemsCompanion Function({
      required String id,
      required String playlistId,
      required String audioItemId,
      required int position,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });
typedef $$PlaylistItemsTableUpdateCompanionBuilder =
    PlaylistItemsCompanion Function({
      Value<String> id,
      Value<String> playlistId,
      Value<String> audioItemId,
      Value<int> position,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

final class $$PlaylistItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PlaylistItemsTable, PlaylistItem> {
  $$PlaylistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlaylistsTable _playlistIdTable(_$AppDatabase db) =>
      db.playlists.createAlias(
        $_aliasNameGenerator(db.playlistItems.playlistId, db.playlists.id),
      );

  $$PlaylistsTableProcessedTableManager get playlistId {
    final $_column = $_itemColumn<String>('playlist_id')!;

    final manager = $$PlaylistsTableTableManager(
      $_db,
      $_db.playlists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AudioItemsTable _audioItemIdTable(_$AppDatabase db) =>
      db.audioItems.createAlias(
        $_aliasNameGenerator(db.playlistItems.audioItemId, db.audioItems.id),
      );

  $$AudioItemsTableProcessedTableManager get audioItemId {
    final $_column = $_itemColumn<String>('audio_item_id')!;

    final manager = $$AudioItemsTableTableManager(
      $_db,
      $_db.audioItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlaylistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistItemsTable> {
  $$PlaylistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlaylistsTableFilterComposer get playlistId {
    final $$PlaylistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableFilterComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudioItemsTableFilterComposer get audioItemId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableFilterComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistItemsTable> {
  $$PlaylistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlaylistsTableOrderingComposer get playlistId {
    final $$PlaylistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableOrderingComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudioItemsTableOrderingComposer get audioItemId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableOrderingComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistItemsTable> {
  $$PlaylistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$PlaylistsTableAnnotationComposer get playlistId {
    final $$PlaylistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableAnnotationComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudioItemsTableAnnotationComposer get audioItemId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistItemsTable,
          PlaylistItem,
          $$PlaylistItemsTableFilterComposer,
          $$PlaylistItemsTableOrderingComposer,
          $$PlaylistItemsTableAnnotationComposer,
          $$PlaylistItemsTableCreateCompanionBuilder,
          $$PlaylistItemsTableUpdateCompanionBuilder,
          (PlaylistItem, $$PlaylistItemsTableReferences),
          PlaylistItem,
          PrefetchHooks Function({bool playlistId, bool audioItemId})
        > {
  $$PlaylistItemsTableTableManager(_$AppDatabase db, $PlaylistItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> playlistId = const Value.absent(),
                Value<String> audioItemId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistItemsCompanion(
                id: id,
                playlistId: playlistId,
                audioItemId: audioItemId,
                position: position,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String playlistId,
                required String audioItemId,
                required int position,
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistItemsCompanion.insert(
                id: id,
                playlistId: playlistId,
                audioItemId: audioItemId,
                position: position,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaylistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playlistId = false, audioItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (playlistId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playlistId,
                                referencedTable: $$PlaylistItemsTableReferences
                                    ._playlistIdTable(db),
                                referencedColumn: $$PlaylistItemsTableReferences
                                    ._playlistIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (audioItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.audioItemId,
                                referencedTable: $$PlaylistItemsTableReferences
                                    ._audioItemIdTable(db),
                                referencedColumn: $$PlaylistItemsTableReferences
                                    ._audioItemIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistItemsTable,
      PlaylistItem,
      $$PlaylistItemsTableFilterComposer,
      $$PlaylistItemsTableOrderingComposer,
      $$PlaylistItemsTableAnnotationComposer,
      $$PlaylistItemsTableCreateCompanionBuilder,
      $$PlaylistItemsTableUpdateCompanionBuilder,
      (PlaylistItem, $$PlaylistItemsTableReferences),
      PlaylistItem,
      PrefetchHooks Function({bool playlistId, bool audioItemId})
    >;
typedef $$PlayHistoryTableCreateCompanionBuilder =
    PlayHistoryCompanion Function({
      required String id,
      required String userId,
      required String audioItemId,
      Value<DateTime> playedAt,
      Value<int?> durationPlayedMs,
      Value<int> rowid,
    });
typedef $$PlayHistoryTableUpdateCompanionBuilder =
    PlayHistoryCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> audioItemId,
      Value<DateTime> playedAt,
      Value<int?> durationPlayedMs,
      Value<int> rowid,
    });

final class $$PlayHistoryTableReferences
    extends BaseReferences<_$AppDatabase, $PlayHistoryTable, PlayHistoryData> {
  $$PlayHistoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AudioItemsTable _audioItemIdTable(_$AppDatabase db) =>
      db.audioItems.createAlias(
        $_aliasNameGenerator(db.playHistory.audioItemId, db.audioItems.id),
      );

  $$AudioItemsTableProcessedTableManager get audioItemId {
    final $_column = $_itemColumn<String>('audio_item_id')!;

    final manager = $$AudioItemsTableTableManager(
      $_db,
      $_db.audioItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlayHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PlayHistoryTable> {
  $$PlayHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationPlayedMs => $composableBuilder(
    column: $table.durationPlayedMs,
    builder: (column) => ColumnFilters(column),
  );

  $$AudioItemsTableFilterComposer get audioItemId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableFilterComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayHistoryTable> {
  $$PlayHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationPlayedMs => $composableBuilder(
    column: $table.durationPlayedMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$AudioItemsTableOrderingComposer get audioItemId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableOrderingComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayHistoryTable> {
  $$PlayHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get playedAt =>
      $composableBuilder(column: $table.playedAt, builder: (column) => column);

  GeneratedColumn<int> get durationPlayedMs => $composableBuilder(
    column: $table.durationPlayedMs,
    builder: (column) => column,
  );

  $$AudioItemsTableAnnotationComposer get audioItemId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioItemId,
      referencedTable: $db.audioItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.audioItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayHistoryTable,
          PlayHistoryData,
          $$PlayHistoryTableFilterComposer,
          $$PlayHistoryTableOrderingComposer,
          $$PlayHistoryTableAnnotationComposer,
          $$PlayHistoryTableCreateCompanionBuilder,
          $$PlayHistoryTableUpdateCompanionBuilder,
          (PlayHistoryData, $$PlayHistoryTableReferences),
          PlayHistoryData,
          PrefetchHooks Function({bool audioItemId})
        > {
  $$PlayHistoryTableTableManager(_$AppDatabase db, $PlayHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> audioItemId = const Value.absent(),
                Value<DateTime> playedAt = const Value.absent(),
                Value<int?> durationPlayedMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayHistoryCompanion(
                id: id,
                userId: userId,
                audioItemId: audioItemId,
                playedAt: playedAt,
                durationPlayedMs: durationPlayedMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String audioItemId,
                Value<DateTime> playedAt = const Value.absent(),
                Value<int?> durationPlayedMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayHistoryCompanion.insert(
                id: id,
                userId: userId,
                audioItemId: audioItemId,
                playedAt: playedAt,
                durationPlayedMs: durationPlayedMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({audioItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (audioItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.audioItemId,
                                referencedTable: $$PlayHistoryTableReferences
                                    ._audioItemIdTable(db),
                                referencedColumn: $$PlayHistoryTableReferences
                                    ._audioItemIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlayHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayHistoryTable,
      PlayHistoryData,
      $$PlayHistoryTableFilterComposer,
      $$PlayHistoryTableOrderingComposer,
      $$PlayHistoryTableAnnotationComposer,
      $$PlayHistoryTableCreateCompanionBuilder,
      $$PlayHistoryTableUpdateCompanionBuilder,
      (PlayHistoryData, $$PlayHistoryTableReferences),
      PlayHistoryData,
      PrefetchHooks Function({bool audioItemId})
    >;
typedef $$QueueSnapshotTableCreateCompanionBuilder =
    QueueSnapshotCompanion Function({
      required String userId,
      required String itemIds,
      Value<int> currentIndex,
      Value<int> currentPositionMs,
      Value<bool> shuffleEnabled,
      Value<String> repeatMode,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$QueueSnapshotTableUpdateCompanionBuilder =
    QueueSnapshotCompanion Function({
      Value<String> userId,
      Value<String> itemIds,
      Value<int> currentIndex,
      Value<int> currentPositionMs,
      Value<bool> shuffleEnabled,
      Value<String> repeatMode,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$QueueSnapshotTableFilterComposer
    extends Composer<_$AppDatabase, $QueueSnapshotTable> {
  $$QueueSnapshotTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemIds => $composableBuilder(
    column: $table.itemIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPositionMs => $composableBuilder(
    column: $table.currentPositionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get shuffleEnabled => $composableBuilder(
    column: $table.shuffleEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatMode => $composableBuilder(
    column: $table.repeatMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QueueSnapshotTableOrderingComposer
    extends Composer<_$AppDatabase, $QueueSnapshotTable> {
  $$QueueSnapshotTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemIds => $composableBuilder(
    column: $table.itemIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPositionMs => $composableBuilder(
    column: $table.currentPositionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get shuffleEnabled => $composableBuilder(
    column: $table.shuffleEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatMode => $composableBuilder(
    column: $table.repeatMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QueueSnapshotTableAnnotationComposer
    extends Composer<_$AppDatabase, $QueueSnapshotTable> {
  $$QueueSnapshotTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get itemIds =>
      $composableBuilder(column: $table.itemIds, builder: (column) => column);

  GeneratedColumn<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentPositionMs => $composableBuilder(
    column: $table.currentPositionMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get shuffleEnabled => $composableBuilder(
    column: $table.shuffleEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatMode => $composableBuilder(
    column: $table.repeatMode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$QueueSnapshotTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QueueSnapshotTable,
          QueueSnapshotData,
          $$QueueSnapshotTableFilterComposer,
          $$QueueSnapshotTableOrderingComposer,
          $$QueueSnapshotTableAnnotationComposer,
          $$QueueSnapshotTableCreateCompanionBuilder,
          $$QueueSnapshotTableUpdateCompanionBuilder,
          (
            QueueSnapshotData,
            BaseReferences<
              _$AppDatabase,
              $QueueSnapshotTable,
              QueueSnapshotData
            >,
          ),
          QueueSnapshotData,
          PrefetchHooks Function()
        > {
  $$QueueSnapshotTableTableManager(_$AppDatabase db, $QueueSnapshotTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QueueSnapshotTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QueueSnapshotTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QueueSnapshotTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> itemIds = const Value.absent(),
                Value<int> currentIndex = const Value.absent(),
                Value<int> currentPositionMs = const Value.absent(),
                Value<bool> shuffleEnabled = const Value.absent(),
                Value<String> repeatMode = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QueueSnapshotCompanion(
                userId: userId,
                itemIds: itemIds,
                currentIndex: currentIndex,
                currentPositionMs: currentPositionMs,
                shuffleEnabled: shuffleEnabled,
                repeatMode: repeatMode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String itemIds,
                Value<int> currentIndex = const Value.absent(),
                Value<int> currentPositionMs = const Value.absent(),
                Value<bool> shuffleEnabled = const Value.absent(),
                Value<String> repeatMode = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QueueSnapshotCompanion.insert(
                userId: userId,
                itemIds: itemIds,
                currentIndex: currentIndex,
                currentPositionMs: currentPositionMs,
                shuffleEnabled: shuffleEnabled,
                repeatMode: repeatMode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QueueSnapshotTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QueueSnapshotTable,
      QueueSnapshotData,
      $$QueueSnapshotTableFilterComposer,
      $$QueueSnapshotTableOrderingComposer,
      $$QueueSnapshotTableAnnotationComposer,
      $$QueueSnapshotTableCreateCompanionBuilder,
      $$QueueSnapshotTableUpdateCompanionBuilder,
      (
        QueueSnapshotData,
        BaseReferences<_$AppDatabase, $QueueSnapshotTable, QueueSnapshotData>,
      ),
      QueueSnapshotData,
      PrefetchHooks Function()
    >;
typedef $$LocalNotificationsTableCreateCompanionBuilder =
    LocalNotificationsCompanion Function({
      required String id,
      required String userId,
      required String title,
      required String body,
      required String type,
      Value<bool> isRead,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$LocalNotificationsTableUpdateCompanionBuilder =
    LocalNotificationsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> title,
      Value<String> body,
      Value<String> type,
      Value<bool> isRead,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalNotificationsTable> {
  $$LocalNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalNotificationsTable> {
  $$LocalNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalNotificationsTable> {
  $$LocalNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalNotificationsTable,
          LocalNotification,
          $$LocalNotificationsTableFilterComposer,
          $$LocalNotificationsTableOrderingComposer,
          $$LocalNotificationsTableAnnotationComposer,
          $$LocalNotificationsTableCreateCompanionBuilder,
          $$LocalNotificationsTableUpdateCompanionBuilder,
          (
            LocalNotification,
            BaseReferences<
              _$AppDatabase,
              $LocalNotificationsTable,
              LocalNotification
            >,
          ),
          LocalNotification,
          PrefetchHooks Function()
        > {
  $$LocalNotificationsTableTableManager(
    _$AppDatabase db,
    $LocalNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalNotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalNotificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalNotificationsCompanion(
                id: id,
                userId: userId,
                title: title,
                body: body,
                type: type,
                isRead: isRead,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String title,
                required String body,
                required String type,
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalNotificationsCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                body: body,
                type: type,
                isRead: isRead,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalNotificationsTable,
      LocalNotification,
      $$LocalNotificationsTableFilterComposer,
      $$LocalNotificationsTableOrderingComposer,
      $$LocalNotificationsTableAnnotationComposer,
      $$LocalNotificationsTableCreateCompanionBuilder,
      $$LocalNotificationsTableUpdateCompanionBuilder,
      (
        LocalNotification,
        BaseReferences<
          _$AppDatabase,
          $LocalNotificationsTable,
          LocalNotification
        >,
      ),
      LocalNotification,
      PrefetchHooks Function()
    >;
typedef $$LocalFeatureFlagsTableCreateCompanionBuilder =
    LocalFeatureFlagsCompanion Function({
      required String featureKey,
      Value<bool> enabled,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalFeatureFlagsTableUpdateCompanionBuilder =
    LocalFeatureFlagsCompanion Function({
      Value<String> featureKey,
      Value<bool> enabled,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalFeatureFlagsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalFeatureFlagsTable> {
  $$LocalFeatureFlagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalFeatureFlagsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalFeatureFlagsTable> {
  $$LocalFeatureFlagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalFeatureFlagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalFeatureFlagsTable> {
  $$LocalFeatureFlagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalFeatureFlagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalFeatureFlagsTable,
          LocalFeatureFlag,
          $$LocalFeatureFlagsTableFilterComposer,
          $$LocalFeatureFlagsTableOrderingComposer,
          $$LocalFeatureFlagsTableAnnotationComposer,
          $$LocalFeatureFlagsTableCreateCompanionBuilder,
          $$LocalFeatureFlagsTableUpdateCompanionBuilder,
          (
            LocalFeatureFlag,
            BaseReferences<
              _$AppDatabase,
              $LocalFeatureFlagsTable,
              LocalFeatureFlag
            >,
          ),
          LocalFeatureFlag,
          PrefetchHooks Function()
        > {
  $$LocalFeatureFlagsTableTableManager(
    _$AppDatabase db,
    $LocalFeatureFlagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalFeatureFlagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalFeatureFlagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalFeatureFlagsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> featureKey = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFeatureFlagsCompanion(
                featureKey: featureKey,
                enabled: enabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String featureKey,
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFeatureFlagsCompanion.insert(
                featureKey: featureKey,
                enabled: enabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalFeatureFlagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalFeatureFlagsTable,
      LocalFeatureFlag,
      $$LocalFeatureFlagsTableFilterComposer,
      $$LocalFeatureFlagsTableOrderingComposer,
      $$LocalFeatureFlagsTableAnnotationComposer,
      $$LocalFeatureFlagsTableCreateCompanionBuilder,
      $$LocalFeatureFlagsTableUpdateCompanionBuilder,
      (
        LocalFeatureFlag,
        BaseReferences<
          _$AppDatabase,
          $LocalFeatureFlagsTable,
          LocalFeatureFlag
        >,
      ),
      LocalFeatureFlag,
      PrefetchHooks Function()
    >;
typedef $$LocalFeatureOverridesTableCreateCompanionBuilder =
    LocalFeatureOverridesCompanion Function({
      required String userId,
      required String featureKey,
      required bool enabled,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalFeatureOverridesTableUpdateCompanionBuilder =
    LocalFeatureOverridesCompanion Function({
      Value<String> userId,
      Value<String> featureKey,
      Value<bool> enabled,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalFeatureOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalFeatureOverridesTable> {
  $$LocalFeatureOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalFeatureOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalFeatureOverridesTable> {
  $$LocalFeatureOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalFeatureOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalFeatureOverridesTable> {
  $$LocalFeatureOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalFeatureOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalFeatureOverridesTable,
          LocalFeatureOverride,
          $$LocalFeatureOverridesTableFilterComposer,
          $$LocalFeatureOverridesTableOrderingComposer,
          $$LocalFeatureOverridesTableAnnotationComposer,
          $$LocalFeatureOverridesTableCreateCompanionBuilder,
          $$LocalFeatureOverridesTableUpdateCompanionBuilder,
          (
            LocalFeatureOverride,
            BaseReferences<
              _$AppDatabase,
              $LocalFeatureOverridesTable,
              LocalFeatureOverride
            >,
          ),
          LocalFeatureOverride,
          PrefetchHooks Function()
        > {
  $$LocalFeatureOverridesTableTableManager(
    _$AppDatabase db,
    $LocalFeatureOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalFeatureOverridesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalFeatureOverridesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalFeatureOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> featureKey = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFeatureOverridesCompanion(
                userId: userId,
                featureKey: featureKey,
                enabled: enabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String featureKey,
                required bool enabled,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFeatureOverridesCompanion.insert(
                userId: userId,
                featureKey: featureKey,
                enabled: enabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalFeatureOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalFeatureOverridesTable,
      LocalFeatureOverride,
      $$LocalFeatureOverridesTableFilterComposer,
      $$LocalFeatureOverridesTableOrderingComposer,
      $$LocalFeatureOverridesTableAnnotationComposer,
      $$LocalFeatureOverridesTableCreateCompanionBuilder,
      $$LocalFeatureOverridesTableUpdateCompanionBuilder,
      (
        LocalFeatureOverride,
        BaseReferences<
          _$AppDatabase,
          $LocalFeatureOverridesTable,
          LocalFeatureOverride
        >,
      ),
      LocalFeatureOverride,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalProfilesTableTableManager get localProfiles =>
      $$LocalProfilesTableTableManager(_db, _db.localProfiles);
  $$FolderSourcesTableTableManager get folderSources =>
      $$FolderSourcesTableTableManager(_db, _db.folderSources);
  $$AudioItemsTableTableManager get audioItems =>
      $$AudioItemsTableTableManager(_db, _db.audioItems);
  $$AudioFilesTableTableManager get audioFiles =>
      $$AudioFilesTableTableManager(_db, _db.audioFiles);
  $$ClipRecordsTableTableManager get clipRecords =>
      $$ClipRecordsTableTableManager(_db, _db.clipRecords);
  $$MergedTracksTableTableManager get mergedTracks =>
      $$MergedTracksTableTableManager(_db, _db.mergedTracks);
  $$MergeItemsTableTableManager get mergeItems =>
      $$MergeItemsTableTableManager(_db, _db.mergeItems);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db, _db.playlists);
  $$PlaylistItemsTableTableManager get playlistItems =>
      $$PlaylistItemsTableTableManager(_db, _db.playlistItems);
  $$PlayHistoryTableTableManager get playHistory =>
      $$PlayHistoryTableTableManager(_db, _db.playHistory);
  $$QueueSnapshotTableTableManager get queueSnapshot =>
      $$QueueSnapshotTableTableManager(_db, _db.queueSnapshot);
  $$LocalNotificationsTableTableManager get localNotifications =>
      $$LocalNotificationsTableTableManager(_db, _db.localNotifications);
  $$LocalFeatureFlagsTableTableManager get localFeatureFlags =>
      $$LocalFeatureFlagsTableTableManager(_db, _db.localFeatureFlags);
  $$LocalFeatureOverridesTableTableManager get localFeatureOverrides =>
      $$LocalFeatureOverridesTableTableManager(_db, _db.localFeatureOverrides);
}
