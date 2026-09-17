// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfileTableTable extends ProfileTable
    with TableInfo<$ProfileTableTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    requiredDuringInsert: false,
    defaultValue: const Constant('Trader'),
  );
  static const VerificationMeta _avatarIdMeta = const VerificationMeta(
    'avatarId',
  );
  @override
  late final GeneratedColumn<String> avatarId = GeneratedColumn<String>(
    'avatar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('avatar_01'),
  );
  static const VerificationMeta _experienceLevelMeta = const VerificationMeta(
    'experienceLevel',
  );
  @override
  late final GeneratedColumn<String> experienceLevel = GeneratedColumn<String>(
    'experience_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('beginner'),
  );
  static const VerificationMeta _dailyGoalMinutesMeta = const VerificationMeta(
    'dailyGoalMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyGoalMinutes = GeneratedColumn<int>(
    'daily_goal_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _totalXpMeta = const VerificationMeta(
    'totalXp',
  );
  @override
  late final GeneratedColumn<int> totalXp = GeneratedColumn<int>(
    'total_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _heartsMeta = const VerificationMeta('hearts');
  @override
  late final GeneratedColumn<int> hearts = GeneratedColumn<int>(
    'hearts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _heartsUpdatedAtMeta = const VerificationMeta(
    'heartsUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> heartsUpdatedAt =
      GeneratedColumn<DateTime>(
        'hearts_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    avatarId,
    experienceLevel,
    dailyGoalMinutes,
    totalXp,
    hearts,
    heartsUpdatedAt,
    onboardingComplete,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('avatar_id')) {
      context.handle(
        _avatarIdMeta,
        avatarId.isAcceptableOrUnknown(data['avatar_id']!, _avatarIdMeta),
      );
    }
    if (data.containsKey('experience_level')) {
      context.handle(
        _experienceLevelMeta,
        experienceLevel.isAcceptableOrUnknown(
          data['experience_level']!,
          _experienceLevelMeta,
        ),
      );
    }
    if (data.containsKey('daily_goal_minutes')) {
      context.handle(
        _dailyGoalMinutesMeta,
        dailyGoalMinutes.isAcceptableOrUnknown(
          data['daily_goal_minutes']!,
          _dailyGoalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('total_xp')) {
      context.handle(
        _totalXpMeta,
        totalXp.isAcceptableOrUnknown(data['total_xp']!, _totalXpMeta),
      );
    }
    if (data.containsKey('hearts')) {
      context.handle(
        _heartsMeta,
        hearts.isAcceptableOrUnknown(data['hearts']!, _heartsMeta),
      );
    }
    if (data.containsKey('hearts_updated_at')) {
      context.handle(
        _heartsUpdatedAtMeta,
        heartsUpdatedAt.isAcceptableOrUnknown(
          data['hearts_updated_at']!,
          _heartsUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
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
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      avatarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_id'],
      )!,
      experienceLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}experience_level'],
      )!,
      dailyGoalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal_minutes'],
      )!,
      totalXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_xp'],
      )!,
      hearts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hearts'],
      )!,
      heartsUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}hearts_updated_at'],
      ),
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $ProfileTableTable createAlias(String alias) {
    return $ProfileTableTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final int id;
  final String username;
  final String avatarId;
  final String experienceLevel;
  final int dailyGoalMinutes;
  final int totalXp;
  final int hearts;
  final DateTime? heartsUpdatedAt;
  final bool onboardingComplete;
  final DateTime? createdAt;
  const ProfileRow({
    required this.id,
    required this.username,
    required this.avatarId,
    required this.experienceLevel,
    required this.dailyGoalMinutes,
    required this.totalXp,
    required this.hearts,
    this.heartsUpdatedAt,
    required this.onboardingComplete,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['avatar_id'] = Variable<String>(avatarId);
    map['experience_level'] = Variable<String>(experienceLevel);
    map['daily_goal_minutes'] = Variable<int>(dailyGoalMinutes);
    map['total_xp'] = Variable<int>(totalXp);
    map['hearts'] = Variable<int>(hearts);
    if (!nullToAbsent || heartsUpdatedAt != null) {
      map['hearts_updated_at'] = Variable<DateTime>(heartsUpdatedAt);
    }
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  ProfileTableCompanion toCompanion(bool nullToAbsent) {
    return ProfileTableCompanion(
      id: Value(id),
      username: Value(username),
      avatarId: Value(avatarId),
      experienceLevel: Value(experienceLevel),
      dailyGoalMinutes: Value(dailyGoalMinutes),
      totalXp: Value(totalXp),
      hearts: Value(hearts),
      heartsUpdatedAt: heartsUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(heartsUpdatedAt),
      onboardingComplete: Value(onboardingComplete),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      avatarId: serializer.fromJson<String>(json['avatarId']),
      experienceLevel: serializer.fromJson<String>(json['experienceLevel']),
      dailyGoalMinutes: serializer.fromJson<int>(json['dailyGoalMinutes']),
      totalXp: serializer.fromJson<int>(json['totalXp']),
      hearts: serializer.fromJson<int>(json['hearts']),
      heartsUpdatedAt: serializer.fromJson<DateTime?>(json['heartsUpdatedAt']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'avatarId': serializer.toJson<String>(avatarId),
      'experienceLevel': serializer.toJson<String>(experienceLevel),
      'dailyGoalMinutes': serializer.toJson<int>(dailyGoalMinutes),
      'totalXp': serializer.toJson<int>(totalXp),
      'hearts': serializer.toJson<int>(hearts),
      'heartsUpdatedAt': serializer.toJson<DateTime?>(heartsUpdatedAt),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  ProfileRow copyWith({
    int? id,
    String? username,
    String? avatarId,
    String? experienceLevel,
    int? dailyGoalMinutes,
    int? totalXp,
    int? hearts,
    Value<DateTime?> heartsUpdatedAt = const Value.absent(),
    bool? onboardingComplete,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => ProfileRow(
    id: id ?? this.id,
    username: username ?? this.username,
    avatarId: avatarId ?? this.avatarId,
    experienceLevel: experienceLevel ?? this.experienceLevel,
    dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
    totalXp: totalXp ?? this.totalXp,
    hearts: hearts ?? this.hearts,
    heartsUpdatedAt: heartsUpdatedAt.present
        ? heartsUpdatedAt.value
        : this.heartsUpdatedAt,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  ProfileRow copyWithCompanion(ProfileTableCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      avatarId: data.avatarId.present ? data.avatarId.value : this.avatarId,
      experienceLevel: data.experienceLevel.present
          ? data.experienceLevel.value
          : this.experienceLevel,
      dailyGoalMinutes: data.dailyGoalMinutes.present
          ? data.dailyGoalMinutes.value
          : this.dailyGoalMinutes,
      totalXp: data.totalXp.present ? data.totalXp.value : this.totalXp,
      hearts: data.hearts.present ? data.hearts.value : this.hearts,
      heartsUpdatedAt: data.heartsUpdatedAt.present
          ? data.heartsUpdatedAt.value
          : this.heartsUpdatedAt,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('avatarId: $avatarId, ')
          ..write('experienceLevel: $experienceLevel, ')
          ..write('dailyGoalMinutes: $dailyGoalMinutes, ')
          ..write('totalXp: $totalXp, ')
          ..write('hearts: $hearts, ')
          ..write('heartsUpdatedAt: $heartsUpdatedAt, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    avatarId,
    experienceLevel,
    dailyGoalMinutes,
    totalXp,
    hearts,
    heartsUpdatedAt,
    onboardingComplete,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.username == this.username &&
          other.avatarId == this.avatarId &&
          other.experienceLevel == this.experienceLevel &&
          other.dailyGoalMinutes == this.dailyGoalMinutes &&
          other.totalXp == this.totalXp &&
          other.hearts == this.hearts &&
          other.heartsUpdatedAt == this.heartsUpdatedAt &&
          other.onboardingComplete == this.onboardingComplete &&
          other.createdAt == this.createdAt);
}

class ProfileTableCompanion extends UpdateCompanion<ProfileRow> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> avatarId;
  final Value<String> experienceLevel;
  final Value<int> dailyGoalMinutes;
  final Value<int> totalXp;
  final Value<int> hearts;
  final Value<DateTime?> heartsUpdatedAt;
  final Value<bool> onboardingComplete;
  final Value<DateTime?> createdAt;
  const ProfileTableCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.avatarId = const Value.absent(),
    this.experienceLevel = const Value.absent(),
    this.dailyGoalMinutes = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.hearts = const Value.absent(),
    this.heartsUpdatedAt = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfileTableCompanion.insert({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.avatarId = const Value.absent(),
    this.experienceLevel = const Value.absent(),
    this.dailyGoalMinutes = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.hearts = const Value.absent(),
    this.heartsUpdatedAt = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<ProfileRow> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? avatarId,
    Expression<String>? experienceLevel,
    Expression<int>? dailyGoalMinutes,
    Expression<int>? totalXp,
    Expression<int>? hearts,
    Expression<DateTime>? heartsUpdatedAt,
    Expression<bool>? onboardingComplete,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (avatarId != null) 'avatar_id': avatarId,
      if (experienceLevel != null) 'experience_level': experienceLevel,
      if (dailyGoalMinutes != null) 'daily_goal_minutes': dailyGoalMinutes,
      if (totalXp != null) 'total_xp': totalXp,
      if (hearts != null) 'hearts': hearts,
      if (heartsUpdatedAt != null) 'hearts_updated_at': heartsUpdatedAt,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfileTableCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? avatarId,
    Value<String>? experienceLevel,
    Value<int>? dailyGoalMinutes,
    Value<int>? totalXp,
    Value<int>? hearts,
    Value<DateTime?>? heartsUpdatedAt,
    Value<bool>? onboardingComplete,
    Value<DateTime?>? createdAt,
  }) {
    return ProfileTableCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarId: avatarId ?? this.avatarId,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      totalXp: totalXp ?? this.totalXp,
      hearts: hearts ?? this.hearts,
      heartsUpdatedAt: heartsUpdatedAt ?? this.heartsUpdatedAt,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (avatarId.present) {
      map['avatar_id'] = Variable<String>(avatarId.value);
    }
    if (experienceLevel.present) {
      map['experience_level'] = Variable<String>(experienceLevel.value);
    }
    if (dailyGoalMinutes.present) {
      map['daily_goal_minutes'] = Variable<int>(dailyGoalMinutes.value);
    }
    if (totalXp.present) {
      map['total_xp'] = Variable<int>(totalXp.value);
    }
    if (hearts.present) {
      map['hearts'] = Variable<int>(hearts.value);
    }
    if (heartsUpdatedAt.present) {
      map['hearts_updated_at'] = Variable<DateTime>(heartsUpdatedAt.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileTableCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('avatarId: $avatarId, ')
          ..write('experienceLevel: $experienceLevel, ')
          ..write('dailyGoalMinutes: $dailyGoalMinutes, ')
          ..write('totalXp: $totalXp, ')
          ..write('hearts: $hearts, ')
          ..write('heartsUpdatedAt: $heartsUpdatedAt, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('dark'),
  );
  static const VerificationMeta _soundEnabledMeta = const VerificationMeta(
    'soundEnabled',
  );
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
    'sound_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hapticsEnabledMeta = const VerificationMeta(
    'hapticsEnabled',
  );
  @override
  late final GeneratedColumn<bool> hapticsEnabled = GeneratedColumn<bool>(
    'haptics_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("haptics_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dailyGoalMinutesMeta = const VerificationMeta(
    'dailyGoalMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyGoalMinutes = GeneratedColumn<int>(
    'daily_goal_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _reduceMotionMeta = const VerificationMeta(
    'reduceMotion',
  );
  @override
  late final GeneratedColumn<bool> reduceMotion = GeneratedColumn<bool>(
    'reduce_motion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reduce_motion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _showVolumeMeta = const VerificationMeta(
    'showVolume',
  );
  @override
  late final GeneratedColumn<bool> showVolume = GeneratedColumn<bool>(
    'show_volume',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_volume" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _defaultRiskPercentMeta =
      const VerificationMeta('defaultRiskPercent');
  @override
  late final GeneratedColumn<double> defaultRiskPercent =
      GeneratedColumn<double>(
        'default_risk_percent',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1.0),
      );
  static const VerificationMeta _simulatorStartingBalanceMeta =
      const VerificationMeta('simulatorStartingBalance');
  @override
  late final GeneratedColumn<double> simulatorStartingBalance =
      GeneratedColumn<double>(
        'simulator_starting_balance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(10000.0),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    theme,
    soundEnabled,
    hapticsEnabled,
    dailyGoalMinutes,
    reduceMotion,
    showVolume,
    defaultRiskPercent,
    simulatorStartingBalance,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
        _soundEnabledMeta,
        soundEnabled.isAcceptableOrUnknown(
          data['sound_enabled']!,
          _soundEnabledMeta,
        ),
      );
    }
    if (data.containsKey('haptics_enabled')) {
      context.handle(
        _hapticsEnabledMeta,
        hapticsEnabled.isAcceptableOrUnknown(
          data['haptics_enabled']!,
          _hapticsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('daily_goal_minutes')) {
      context.handle(
        _dailyGoalMinutesMeta,
        dailyGoalMinutes.isAcceptableOrUnknown(
          data['daily_goal_minutes']!,
          _dailyGoalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('reduce_motion')) {
      context.handle(
        _reduceMotionMeta,
        reduceMotion.isAcceptableOrUnknown(
          data['reduce_motion']!,
          _reduceMotionMeta,
        ),
      );
    }
    if (data.containsKey('show_volume')) {
      context.handle(
        _showVolumeMeta,
        showVolume.isAcceptableOrUnknown(data['show_volume']!, _showVolumeMeta),
      );
    }
    if (data.containsKey('default_risk_percent')) {
      context.handle(
        _defaultRiskPercentMeta,
        defaultRiskPercent.isAcceptableOrUnknown(
          data['default_risk_percent']!,
          _defaultRiskPercentMeta,
        ),
      );
    }
    if (data.containsKey('simulator_starting_balance')) {
      context.handle(
        _simulatorStartingBalanceMeta,
        simulatorStartingBalance.isAcceptableOrUnknown(
          data['simulator_starting_balance']!,
          _simulatorStartingBalanceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      )!,
      soundEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_enabled'],
      )!,
      hapticsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptics_enabled'],
      )!,
      dailyGoalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal_minutes'],
      )!,
      reduceMotion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reduce_motion'],
      )!,
      showVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_volume'],
      )!,
      defaultRiskPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_risk_percent'],
      )!,
      simulatorStartingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}simulator_starting_balance'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final String theme;
  final bool soundEnabled;
  final bool hapticsEnabled;
  final int dailyGoalMinutes;
  final bool reduceMotion;
  final bool showVolume;
  final double defaultRiskPercent;
  final double simulatorStartingBalance;
  const SettingsRow({
    required this.id,
    required this.theme,
    required this.soundEnabled,
    required this.hapticsEnabled,
    required this.dailyGoalMinutes,
    required this.reduceMotion,
    required this.showVolume,
    required this.defaultRiskPercent,
    required this.simulatorStartingBalance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme'] = Variable<String>(theme);
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['haptics_enabled'] = Variable<bool>(hapticsEnabled);
    map['daily_goal_minutes'] = Variable<int>(dailyGoalMinutes);
    map['reduce_motion'] = Variable<bool>(reduceMotion);
    map['show_volume'] = Variable<bool>(showVolume);
    map['default_risk_percent'] = Variable<double>(defaultRiskPercent);
    map['simulator_starting_balance'] = Variable<double>(
      simulatorStartingBalance,
    );
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      id: Value(id),
      theme: Value(theme),
      soundEnabled: Value(soundEnabled),
      hapticsEnabled: Value(hapticsEnabled),
      dailyGoalMinutes: Value(dailyGoalMinutes),
      reduceMotion: Value(reduceMotion),
      showVolume: Value(showVolume),
      defaultRiskPercent: Value(defaultRiskPercent),
      simulatorStartingBalance: Value(simulatorStartingBalance),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      theme: serializer.fromJson<String>(json['theme']),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      hapticsEnabled: serializer.fromJson<bool>(json['hapticsEnabled']),
      dailyGoalMinutes: serializer.fromJson<int>(json['dailyGoalMinutes']),
      reduceMotion: serializer.fromJson<bool>(json['reduceMotion']),
      showVolume: serializer.fromJson<bool>(json['showVolume']),
      defaultRiskPercent: serializer.fromJson<double>(
        json['defaultRiskPercent'],
      ),
      simulatorStartingBalance: serializer.fromJson<double>(
        json['simulatorStartingBalance'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'theme': serializer.toJson<String>(theme),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'hapticsEnabled': serializer.toJson<bool>(hapticsEnabled),
      'dailyGoalMinutes': serializer.toJson<int>(dailyGoalMinutes),
      'reduceMotion': serializer.toJson<bool>(reduceMotion),
      'showVolume': serializer.toJson<bool>(showVolume),
      'defaultRiskPercent': serializer.toJson<double>(defaultRiskPercent),
      'simulatorStartingBalance': serializer.toJson<double>(
        simulatorStartingBalance,
      ),
    };
  }

  SettingsRow copyWith({
    int? id,
    String? theme,
    bool? soundEnabled,
    bool? hapticsEnabled,
    int? dailyGoalMinutes,
    bool? reduceMotion,
    bool? showVolume,
    double? defaultRiskPercent,
    double? simulatorStartingBalance,
  }) => SettingsRow(
    id: id ?? this.id,
    theme: theme ?? this.theme,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    showVolume: showVolume ?? this.showVolume,
    defaultRiskPercent: defaultRiskPercent ?? this.defaultRiskPercent,
    simulatorStartingBalance:
        simulatorStartingBalance ?? this.simulatorStartingBalance,
  );
  SettingsRow copyWithCompanion(SettingsTableCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      theme: data.theme.present ? data.theme.value : this.theme,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      hapticsEnabled: data.hapticsEnabled.present
          ? data.hapticsEnabled.value
          : this.hapticsEnabled,
      dailyGoalMinutes: data.dailyGoalMinutes.present
          ? data.dailyGoalMinutes.value
          : this.dailyGoalMinutes,
      reduceMotion: data.reduceMotion.present
          ? data.reduceMotion.value
          : this.reduceMotion,
      showVolume: data.showVolume.present
          ? data.showVolume.value
          : this.showVolume,
      defaultRiskPercent: data.defaultRiskPercent.present
          ? data.defaultRiskPercent.value
          : this.defaultRiskPercent,
      simulatorStartingBalance: data.simulatorStartingBalance.present
          ? data.simulatorStartingBalance.value
          : this.simulatorStartingBalance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('dailyGoalMinutes: $dailyGoalMinutes, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('showVolume: $showVolume, ')
          ..write('defaultRiskPercent: $defaultRiskPercent, ')
          ..write('simulatorStartingBalance: $simulatorStartingBalance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    theme,
    soundEnabled,
    hapticsEnabled,
    dailyGoalMinutes,
    reduceMotion,
    showVolume,
    defaultRiskPercent,
    simulatorStartingBalance,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.theme == this.theme &&
          other.soundEnabled == this.soundEnabled &&
          other.hapticsEnabled == this.hapticsEnabled &&
          other.dailyGoalMinutes == this.dailyGoalMinutes &&
          other.reduceMotion == this.reduceMotion &&
          other.showVolume == this.showVolume &&
          other.defaultRiskPercent == this.defaultRiskPercent &&
          other.simulatorStartingBalance == this.simulatorStartingBalance);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<String> theme;
  final Value<bool> soundEnabled;
  final Value<bool> hapticsEnabled;
  final Value<int> dailyGoalMinutes;
  final Value<bool> reduceMotion;
  final Value<bool> showVolume;
  final Value<double> defaultRiskPercent;
  final Value<double> simulatorStartingBalance;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.dailyGoalMinutes = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.showVolume = const Value.absent(),
    this.defaultRiskPercent = const Value.absent(),
    this.simulatorStartingBalance = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.dailyGoalMinutes = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.showVolume = const Value.absent(),
    this.defaultRiskPercent = const Value.absent(),
    this.simulatorStartingBalance = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<String>? theme,
    Expression<bool>? soundEnabled,
    Expression<bool>? hapticsEnabled,
    Expression<int>? dailyGoalMinutes,
    Expression<bool>? reduceMotion,
    Expression<bool>? showVolume,
    Expression<double>? defaultRiskPercent,
    Expression<double>? simulatorStartingBalance,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (theme != null) 'theme': theme,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (hapticsEnabled != null) 'haptics_enabled': hapticsEnabled,
      if (dailyGoalMinutes != null) 'daily_goal_minutes': dailyGoalMinutes,
      if (reduceMotion != null) 'reduce_motion': reduceMotion,
      if (showVolume != null) 'show_volume': showVolume,
      if (defaultRiskPercent != null)
        'default_risk_percent': defaultRiskPercent,
      if (simulatorStartingBalance != null)
        'simulator_starting_balance': simulatorStartingBalance,
    });
  }

  SettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? theme,
    Value<bool>? soundEnabled,
    Value<bool>? hapticsEnabled,
    Value<int>? dailyGoalMinutes,
    Value<bool>? reduceMotion,
    Value<bool>? showVolume,
    Value<double>? defaultRiskPercent,
    Value<double>? simulatorStartingBalance,
  }) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      showVolume: showVolume ?? this.showVolume,
      defaultRiskPercent: defaultRiskPercent ?? this.defaultRiskPercent,
      simulatorStartingBalance:
          simulatorStartingBalance ?? this.simulatorStartingBalance,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (hapticsEnabled.present) {
      map['haptics_enabled'] = Variable<bool>(hapticsEnabled.value);
    }
    if (dailyGoalMinutes.present) {
      map['daily_goal_minutes'] = Variable<int>(dailyGoalMinutes.value);
    }
    if (reduceMotion.present) {
      map['reduce_motion'] = Variable<bool>(reduceMotion.value);
    }
    if (showVolume.present) {
      map['show_volume'] = Variable<bool>(showVolume.value);
    }
    if (defaultRiskPercent.present) {
      map['default_risk_percent'] = Variable<double>(defaultRiskPercent.value);
    }
    if (simulatorStartingBalance.present) {
      map['simulator_starting_balance'] = Variable<double>(
        simulatorStartingBalance.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('dailyGoalMinutes: $dailyGoalMinutes, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('showVolume: $showVolume, ')
          ..write('defaultRiskPercent: $defaultRiskPercent, ')
          ..write('simulatorStartingBalance: $simulatorStartingBalance')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressTableTable extends LessonProgressTable
    with TableInfo<$LessonProgressTableTable, LessonProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completionsMeta = const VerificationMeta(
    'completions',
  );
  @override
  late final GeneratedColumn<int> completions = GeneratedColumn<int>(
    'completions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestAccuracyMeta = const VerificationMeta(
    'bestAccuracy',
  );
  @override
  late final GeneratedColumn<double> bestAccuracy = GeneratedColumn<double>(
    'best_accuracy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastAccuracyMeta = const VerificationMeta(
    'lastAccuracy',
  );
  @override
  late final GeneratedColumn<double> lastAccuracy = GeneratedColumn<double>(
    'last_accuracy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _perfectMeta = const VerificationMeta(
    'perfect',
  );
  @override
  late final GeneratedColumn<bool> perfect = GeneratedColumn<bool>(
    'perfect',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("perfect" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastCompletedAtMeta = const VerificationMeta(
    'lastCompletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastCompletedAt =
      GeneratedColumn<DateTime>(
        'last_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    lessonId,
    completions,
    bestAccuracy,
    lastAccuracy,
    perfect,
    lastCompletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('completions')) {
      context.handle(
        _completionsMeta,
        completions.isAcceptableOrUnknown(
          data['completions']!,
          _completionsMeta,
        ),
      );
    }
    if (data.containsKey('best_accuracy')) {
      context.handle(
        _bestAccuracyMeta,
        bestAccuracy.isAcceptableOrUnknown(
          data['best_accuracy']!,
          _bestAccuracyMeta,
        ),
      );
    }
    if (data.containsKey('last_accuracy')) {
      context.handle(
        _lastAccuracyMeta,
        lastAccuracy.isAcceptableOrUnknown(
          data['last_accuracy']!,
          _lastAccuracyMeta,
        ),
      );
    }
    if (data.containsKey('perfect')) {
      context.handle(
        _perfectMeta,
        perfect.isAcceptableOrUnknown(data['perfect']!, _perfectMeta),
      );
    }
    if (data.containsKey('last_completed_at')) {
      context.handle(
        _lastCompletedAtMeta,
        lastCompletedAt.isAcceptableOrUnknown(
          data['last_completed_at']!,
          _lastCompletedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId};
  @override
  LessonProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressRow(
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      completions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completions'],
      )!,
      bestAccuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}best_accuracy'],
      )!,
      lastAccuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_accuracy'],
      )!,
      perfect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}perfect'],
      )!,
      lastCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_completed_at'],
      ),
    );
  }

  @override
  $LessonProgressTableTable createAlias(String alias) {
    return $LessonProgressTableTable(attachedDatabase, alias);
  }
}

class LessonProgressRow extends DataClass
    implements Insertable<LessonProgressRow> {
  final String lessonId;
  final int completions;
  final double bestAccuracy;
  final double lastAccuracy;
  final bool perfect;
  final DateTime? lastCompletedAt;
  const LessonProgressRow({
    required this.lessonId,
    required this.completions,
    required this.bestAccuracy,
    required this.lastAccuracy,
    required this.perfect,
    this.lastCompletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    map['completions'] = Variable<int>(completions);
    map['best_accuracy'] = Variable<double>(bestAccuracy);
    map['last_accuracy'] = Variable<double>(lastAccuracy);
    map['perfect'] = Variable<bool>(perfect);
    if (!nullToAbsent || lastCompletedAt != null) {
      map['last_completed_at'] = Variable<DateTime>(lastCompletedAt);
    }
    return map;
  }

  LessonProgressTableCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressTableCompanion(
      lessonId: Value(lessonId),
      completions: Value(completions),
      bestAccuracy: Value(bestAccuracy),
      lastAccuracy: Value(lastAccuracy),
      perfect: Value(perfect),
      lastCompletedAt: lastCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedAt),
    );
  }

  factory LessonProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressRow(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      completions: serializer.fromJson<int>(json['completions']),
      bestAccuracy: serializer.fromJson<double>(json['bestAccuracy']),
      lastAccuracy: serializer.fromJson<double>(json['lastAccuracy']),
      perfect: serializer.fromJson<bool>(json['perfect']),
      lastCompletedAt: serializer.fromJson<DateTime?>(json['lastCompletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'completions': serializer.toJson<int>(completions),
      'bestAccuracy': serializer.toJson<double>(bestAccuracy),
      'lastAccuracy': serializer.toJson<double>(lastAccuracy),
      'perfect': serializer.toJson<bool>(perfect),
      'lastCompletedAt': serializer.toJson<DateTime?>(lastCompletedAt),
    };
  }

  LessonProgressRow copyWith({
    String? lessonId,
    int? completions,
    double? bestAccuracy,
    double? lastAccuracy,
    bool? perfect,
    Value<DateTime?> lastCompletedAt = const Value.absent(),
  }) => LessonProgressRow(
    lessonId: lessonId ?? this.lessonId,
    completions: completions ?? this.completions,
    bestAccuracy: bestAccuracy ?? this.bestAccuracy,
    lastAccuracy: lastAccuracy ?? this.lastAccuracy,
    perfect: perfect ?? this.perfect,
    lastCompletedAt: lastCompletedAt.present
        ? lastCompletedAt.value
        : this.lastCompletedAt,
  );
  LessonProgressRow copyWithCompanion(LessonProgressTableCompanion data) {
    return LessonProgressRow(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      completions: data.completions.present
          ? data.completions.value
          : this.completions,
      bestAccuracy: data.bestAccuracy.present
          ? data.bestAccuracy.value
          : this.bestAccuracy,
      lastAccuracy: data.lastAccuracy.present
          ? data.lastAccuracy.value
          : this.lastAccuracy,
      perfect: data.perfect.present ? data.perfect.value : this.perfect,
      lastCompletedAt: data.lastCompletedAt.present
          ? data.lastCompletedAt.value
          : this.lastCompletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressRow(')
          ..write('lessonId: $lessonId, ')
          ..write('completions: $completions, ')
          ..write('bestAccuracy: $bestAccuracy, ')
          ..write('lastAccuracy: $lastAccuracy, ')
          ..write('perfect: $perfect, ')
          ..write('lastCompletedAt: $lastCompletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    lessonId,
    completions,
    bestAccuracy,
    lastAccuracy,
    perfect,
    lastCompletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressRow &&
          other.lessonId == this.lessonId &&
          other.completions == this.completions &&
          other.bestAccuracy == this.bestAccuracy &&
          other.lastAccuracy == this.lastAccuracy &&
          other.perfect == this.perfect &&
          other.lastCompletedAt == this.lastCompletedAt);
}

class LessonProgressTableCompanion extends UpdateCompanion<LessonProgressRow> {
  final Value<String> lessonId;
  final Value<int> completions;
  final Value<double> bestAccuracy;
  final Value<double> lastAccuracy;
  final Value<bool> perfect;
  final Value<DateTime?> lastCompletedAt;
  final Value<int> rowid;
  const LessonProgressTableCompanion({
    this.lessonId = const Value.absent(),
    this.completions = const Value.absent(),
    this.bestAccuracy = const Value.absent(),
    this.lastAccuracy = const Value.absent(),
    this.perfect = const Value.absent(),
    this.lastCompletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonProgressTableCompanion.insert({
    required String lessonId,
    this.completions = const Value.absent(),
    this.bestAccuracy = const Value.absent(),
    this.lastAccuracy = const Value.absent(),
    this.perfect = const Value.absent(),
    this.lastCompletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : lessonId = Value(lessonId);
  static Insertable<LessonProgressRow> custom({
    Expression<String>? lessonId,
    Expression<int>? completions,
    Expression<double>? bestAccuracy,
    Expression<double>? lastAccuracy,
    Expression<bool>? perfect,
    Expression<DateTime>? lastCompletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (completions != null) 'completions': completions,
      if (bestAccuracy != null) 'best_accuracy': bestAccuracy,
      if (lastAccuracy != null) 'last_accuracy': lastAccuracy,
      if (perfect != null) 'perfect': perfect,
      if (lastCompletedAt != null) 'last_completed_at': lastCompletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonProgressTableCompanion copyWith({
    Value<String>? lessonId,
    Value<int>? completions,
    Value<double>? bestAccuracy,
    Value<double>? lastAccuracy,
    Value<bool>? perfect,
    Value<DateTime?>? lastCompletedAt,
    Value<int>? rowid,
  }) {
    return LessonProgressTableCompanion(
      lessonId: lessonId ?? this.lessonId,
      completions: completions ?? this.completions,
      bestAccuracy: bestAccuracy ?? this.bestAccuracy,
      lastAccuracy: lastAccuracy ?? this.lastAccuracy,
      perfect: perfect ?? this.perfect,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (completions.present) {
      map['completions'] = Variable<int>(completions.value);
    }
    if (bestAccuracy.present) {
      map['best_accuracy'] = Variable<double>(bestAccuracy.value);
    }
    if (lastAccuracy.present) {
      map['last_accuracy'] = Variable<double>(lastAccuracy.value);
    }
    if (perfect.present) {
      map['perfect'] = Variable<bool>(perfect.value);
    }
    if (lastCompletedAt.present) {
      map['last_completed_at'] = Variable<DateTime>(lastCompletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressTableCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('completions: $completions, ')
          ..write('bestAccuracy: $bestAccuracy, ')
          ..write('lastAccuracy: $lastAccuracy, ')
          ..write('perfect: $perfect, ')
          ..write('lastCompletedAt: $lastCompletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SkillMasteryTableTable extends SkillMasteryTable
    with TableInfo<$SkillMasteryTableTable, SkillMasteryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkillMasteryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _skillIdMeta = const VerificationMeta(
    'skillId',
  );
  @override
  late final GeneratedColumn<String> skillId = GeneratedColumn<String>(
    'skill_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastPracticedMeta = const VerificationMeta(
    'lastPracticed',
  );
  @override
  late final GeneratedColumn<DateTime> lastPracticed =
      GeneratedColumn<DateTime>(
        'last_practiced',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    skillId,
    score,
    attempts,
    correct,
    lastPracticed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'skill_mastery_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SkillMasteryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('skill_id')) {
      context.handle(
        _skillIdMeta,
        skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta),
      );
    } else if (isInserting) {
      context.missing(_skillIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    }
    if (data.containsKey('last_practiced')) {
      context.handle(
        _lastPracticedMeta,
        lastPracticed.isAcceptableOrUnknown(
          data['last_practiced']!,
          _lastPracticedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {skillId};
  @override
  SkillMasteryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkillMasteryRow(
      skillId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skill_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct'],
      )!,
      lastPracticed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_practiced'],
      ),
    );
  }

  @override
  $SkillMasteryTableTable createAlias(String alias) {
    return $SkillMasteryTableTable(attachedDatabase, alias);
  }
}

class SkillMasteryRow extends DataClass implements Insertable<SkillMasteryRow> {
  final String skillId;
  final double score;
  final int attempts;
  final int correct;
  final DateTime? lastPracticed;
  const SkillMasteryRow({
    required this.skillId,
    required this.score,
    required this.attempts,
    required this.correct,
    this.lastPracticed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['skill_id'] = Variable<String>(skillId);
    map['score'] = Variable<double>(score);
    map['attempts'] = Variable<int>(attempts);
    map['correct'] = Variable<int>(correct);
    if (!nullToAbsent || lastPracticed != null) {
      map['last_practiced'] = Variable<DateTime>(lastPracticed);
    }
    return map;
  }

  SkillMasteryTableCompanion toCompanion(bool nullToAbsent) {
    return SkillMasteryTableCompanion(
      skillId: Value(skillId),
      score: Value(score),
      attempts: Value(attempts),
      correct: Value(correct),
      lastPracticed: lastPracticed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPracticed),
    );
  }

  factory SkillMasteryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkillMasteryRow(
      skillId: serializer.fromJson<String>(json['skillId']),
      score: serializer.fromJson<double>(json['score']),
      attempts: serializer.fromJson<int>(json['attempts']),
      correct: serializer.fromJson<int>(json['correct']),
      lastPracticed: serializer.fromJson<DateTime?>(json['lastPracticed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'skillId': serializer.toJson<String>(skillId),
      'score': serializer.toJson<double>(score),
      'attempts': serializer.toJson<int>(attempts),
      'correct': serializer.toJson<int>(correct),
      'lastPracticed': serializer.toJson<DateTime?>(lastPracticed),
    };
  }

  SkillMasteryRow copyWith({
    String? skillId,
    double? score,
    int? attempts,
    int? correct,
    Value<DateTime?> lastPracticed = const Value.absent(),
  }) => SkillMasteryRow(
    skillId: skillId ?? this.skillId,
    score: score ?? this.score,
    attempts: attempts ?? this.attempts,
    correct: correct ?? this.correct,
    lastPracticed: lastPracticed.present
        ? lastPracticed.value
        : this.lastPracticed,
  );
  SkillMasteryRow copyWithCompanion(SkillMasteryTableCompanion data) {
    return SkillMasteryRow(
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      score: data.score.present ? data.score.value : this.score,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      correct: data.correct.present ? data.correct.value : this.correct,
      lastPracticed: data.lastPracticed.present
          ? data.lastPracticed.value
          : this.lastPracticed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SkillMasteryRow(')
          ..write('skillId: $skillId, ')
          ..write('score: $score, ')
          ..write('attempts: $attempts, ')
          ..write('correct: $correct, ')
          ..write('lastPracticed: $lastPracticed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(skillId, score, attempts, correct, lastPracticed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkillMasteryRow &&
          other.skillId == this.skillId &&
          other.score == this.score &&
          other.attempts == this.attempts &&
          other.correct == this.correct &&
          other.lastPracticed == this.lastPracticed);
}

class SkillMasteryTableCompanion extends UpdateCompanion<SkillMasteryRow> {
  final Value<String> skillId;
  final Value<double> score;
  final Value<int> attempts;
  final Value<int> correct;
  final Value<DateTime?> lastPracticed;
  final Value<int> rowid;
  const SkillMasteryTableCompanion({
    this.skillId = const Value.absent(),
    this.score = const Value.absent(),
    this.attempts = const Value.absent(),
    this.correct = const Value.absent(),
    this.lastPracticed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SkillMasteryTableCompanion.insert({
    required String skillId,
    this.score = const Value.absent(),
    this.attempts = const Value.absent(),
    this.correct = const Value.absent(),
    this.lastPracticed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : skillId = Value(skillId);
  static Insertable<SkillMasteryRow> custom({
    Expression<String>? skillId,
    Expression<double>? score,
    Expression<int>? attempts,
    Expression<int>? correct,
    Expression<DateTime>? lastPracticed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (skillId != null) 'skill_id': skillId,
      if (score != null) 'score': score,
      if (attempts != null) 'attempts': attempts,
      if (correct != null) 'correct': correct,
      if (lastPracticed != null) 'last_practiced': lastPracticed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SkillMasteryTableCompanion copyWith({
    Value<String>? skillId,
    Value<double>? score,
    Value<int>? attempts,
    Value<int>? correct,
    Value<DateTime?>? lastPracticed,
    Value<int>? rowid,
  }) {
    return SkillMasteryTableCompanion(
      skillId: skillId ?? this.skillId,
      score: score ?? this.score,
      attempts: attempts ?? this.attempts,
      correct: correct ?? this.correct,
      lastPracticed: lastPracticed ?? this.lastPracticed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (skillId.present) {
      map['skill_id'] = Variable<String>(skillId.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (lastPracticed.present) {
      map['last_practiced'] = Variable<DateTime>(lastPracticed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkillMasteryTableCompanion(')
          ..write('skillId: $skillId, ')
          ..write('score: $score, ')
          ..write('attempts: $attempts, ')
          ..write('correct: $correct, ')
          ..write('lastPracticed: $lastPracticed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewItemTableTable extends ReviewItemTable
    with TableInfo<$ReviewItemTableTable, ReviewItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _conceptTagMeta = const VerificationMeta(
    'conceptTag',
  );
  @override
  late final GeneratedColumn<String> conceptTag = GeneratedColumn<String>(
    'concept_tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skillIdMeta = const VerificationMeta(
    'skillId',
  );
  @override
  late final GeneratedColumn<String> skillId = GeneratedColumn<String>(
    'skill_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _easeMeta = const VerificationMeta('ease');
  @override
  late final GeneratedColumn<double> ease = GeneratedColumn<double>(
    'ease',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.3),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReviewedMeta = const VerificationMeta(
    'lastReviewed',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewed = GeneratedColumn<DateTime>(
    'last_reviewed',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastDifficultyMeta = const VerificationMeta(
    'lastDifficulty',
  );
  @override
  late final GeneratedColumn<String> lastDifficulty = GeneratedColumn<String>(
    'last_difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('beginner'),
  );
  static const VerificationMeta _totalAttemptsMeta = const VerificationMeta(
    'totalAttempts',
  );
  @override
  late final GeneratedColumn<int> totalAttempts = GeneratedColumn<int>(
    'total_attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalCorrectMeta = const VerificationMeta(
    'totalCorrect',
  );
  @override
  late final GeneratedColumn<int> totalCorrect = GeneratedColumn<int>(
    'total_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    conceptTag,
    skillId,
    dueAt,
    intervalDays,
    ease,
    repetitions,
    lapses,
    lastReviewed,
    lastDifficulty,
    totalAttempts,
    totalCorrect,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_item_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('concept_tag')) {
      context.handle(
        _conceptTagMeta,
        conceptTag.isAcceptableOrUnknown(data['concept_tag']!, _conceptTagMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptTagMeta);
    }
    if (data.containsKey('skill_id')) {
      context.handle(
        _skillIdMeta,
        skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta),
      );
    } else if (isInserting) {
      context.missing(_skillIdMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('ease')) {
      context.handle(
        _easeMeta,
        ease.isAcceptableOrUnknown(data['ease']!, _easeMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('last_reviewed')) {
      context.handle(
        _lastReviewedMeta,
        lastReviewed.isAcceptableOrUnknown(
          data['last_reviewed']!,
          _lastReviewedMeta,
        ),
      );
    }
    if (data.containsKey('last_difficulty')) {
      context.handle(
        _lastDifficultyMeta,
        lastDifficulty.isAcceptableOrUnknown(
          data['last_difficulty']!,
          _lastDifficultyMeta,
        ),
      );
    }
    if (data.containsKey('total_attempts')) {
      context.handle(
        _totalAttemptsMeta,
        totalAttempts.isAcceptableOrUnknown(
          data['total_attempts']!,
          _totalAttemptsMeta,
        ),
      );
    }
    if (data.containsKey('total_correct')) {
      context.handle(
        _totalCorrectMeta,
        totalCorrect.isAcceptableOrUnknown(
          data['total_correct']!,
          _totalCorrectMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {conceptTag};
  @override
  ReviewItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewItemRow(
      conceptTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concept_tag'],
      )!,
      skillId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skill_id'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      )!,
      ease: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      lastReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed'],
      ),
      lastDifficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_difficulty'],
      )!,
      totalAttempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_attempts'],
      )!,
      totalCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_correct'],
      )!,
    );
  }

  @override
  $ReviewItemTableTable createAlias(String alias) {
    return $ReviewItemTableTable(attachedDatabase, alias);
  }
}

class ReviewItemRow extends DataClass implements Insertable<ReviewItemRow> {
  final String conceptTag;
  final String skillId;
  final DateTime dueAt;
  final int intervalDays;
  final double ease;
  final int repetitions;
  final int lapses;
  final DateTime? lastReviewed;
  final String lastDifficulty;
  final int totalAttempts;
  final int totalCorrect;
  const ReviewItemRow({
    required this.conceptTag,
    required this.skillId,
    required this.dueAt,
    required this.intervalDays,
    required this.ease,
    required this.repetitions,
    required this.lapses,
    this.lastReviewed,
    required this.lastDifficulty,
    required this.totalAttempts,
    required this.totalCorrect,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['concept_tag'] = Variable<String>(conceptTag);
    map['skill_id'] = Variable<String>(skillId);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['interval_days'] = Variable<int>(intervalDays);
    map['ease'] = Variable<double>(ease);
    map['repetitions'] = Variable<int>(repetitions);
    map['lapses'] = Variable<int>(lapses);
    if (!nullToAbsent || lastReviewed != null) {
      map['last_reviewed'] = Variable<DateTime>(lastReviewed);
    }
    map['last_difficulty'] = Variable<String>(lastDifficulty);
    map['total_attempts'] = Variable<int>(totalAttempts);
    map['total_correct'] = Variable<int>(totalCorrect);
    return map;
  }

  ReviewItemTableCompanion toCompanion(bool nullToAbsent) {
    return ReviewItemTableCompanion(
      conceptTag: Value(conceptTag),
      skillId: Value(skillId),
      dueAt: Value(dueAt),
      intervalDays: Value(intervalDays),
      ease: Value(ease),
      repetitions: Value(repetitions),
      lapses: Value(lapses),
      lastReviewed: lastReviewed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewed),
      lastDifficulty: Value(lastDifficulty),
      totalAttempts: Value(totalAttempts),
      totalCorrect: Value(totalCorrect),
    );
  }

  factory ReviewItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewItemRow(
      conceptTag: serializer.fromJson<String>(json['conceptTag']),
      skillId: serializer.fromJson<String>(json['skillId']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      ease: serializer.fromJson<double>(json['ease']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      lapses: serializer.fromJson<int>(json['lapses']),
      lastReviewed: serializer.fromJson<DateTime?>(json['lastReviewed']),
      lastDifficulty: serializer.fromJson<String>(json['lastDifficulty']),
      totalAttempts: serializer.fromJson<int>(json['totalAttempts']),
      totalCorrect: serializer.fromJson<int>(json['totalCorrect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conceptTag': serializer.toJson<String>(conceptTag),
      'skillId': serializer.toJson<String>(skillId),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'ease': serializer.toJson<double>(ease),
      'repetitions': serializer.toJson<int>(repetitions),
      'lapses': serializer.toJson<int>(lapses),
      'lastReviewed': serializer.toJson<DateTime?>(lastReviewed),
      'lastDifficulty': serializer.toJson<String>(lastDifficulty),
      'totalAttempts': serializer.toJson<int>(totalAttempts),
      'totalCorrect': serializer.toJson<int>(totalCorrect),
    };
  }

  ReviewItemRow copyWith({
    String? conceptTag,
    String? skillId,
    DateTime? dueAt,
    int? intervalDays,
    double? ease,
    int? repetitions,
    int? lapses,
    Value<DateTime?> lastReviewed = const Value.absent(),
    String? lastDifficulty,
    int? totalAttempts,
    int? totalCorrect,
  }) => ReviewItemRow(
    conceptTag: conceptTag ?? this.conceptTag,
    skillId: skillId ?? this.skillId,
    dueAt: dueAt ?? this.dueAt,
    intervalDays: intervalDays ?? this.intervalDays,
    ease: ease ?? this.ease,
    repetitions: repetitions ?? this.repetitions,
    lapses: lapses ?? this.lapses,
    lastReviewed: lastReviewed.present ? lastReviewed.value : this.lastReviewed,
    lastDifficulty: lastDifficulty ?? this.lastDifficulty,
    totalAttempts: totalAttempts ?? this.totalAttempts,
    totalCorrect: totalCorrect ?? this.totalCorrect,
  );
  ReviewItemRow copyWithCompanion(ReviewItemTableCompanion data) {
    return ReviewItemRow(
      conceptTag: data.conceptTag.present
          ? data.conceptTag.value
          : this.conceptTag,
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      ease: data.ease.present ? data.ease.value : this.ease,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      lastReviewed: data.lastReviewed.present
          ? data.lastReviewed.value
          : this.lastReviewed,
      lastDifficulty: data.lastDifficulty.present
          ? data.lastDifficulty.value
          : this.lastDifficulty,
      totalAttempts: data.totalAttempts.present
          ? data.totalAttempts.value
          : this.totalAttempts,
      totalCorrect: data.totalCorrect.present
          ? data.totalCorrect.value
          : this.totalCorrect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewItemRow(')
          ..write('conceptTag: $conceptTag, ')
          ..write('skillId: $skillId, ')
          ..write('dueAt: $dueAt, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('ease: $ease, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('lastDifficulty: $lastDifficulty, ')
          ..write('totalAttempts: $totalAttempts, ')
          ..write('totalCorrect: $totalCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    conceptTag,
    skillId,
    dueAt,
    intervalDays,
    ease,
    repetitions,
    lapses,
    lastReviewed,
    lastDifficulty,
    totalAttempts,
    totalCorrect,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewItemRow &&
          other.conceptTag == this.conceptTag &&
          other.skillId == this.skillId &&
          other.dueAt == this.dueAt &&
          other.intervalDays == this.intervalDays &&
          other.ease == this.ease &&
          other.repetitions == this.repetitions &&
          other.lapses == this.lapses &&
          other.lastReviewed == this.lastReviewed &&
          other.lastDifficulty == this.lastDifficulty &&
          other.totalAttempts == this.totalAttempts &&
          other.totalCorrect == this.totalCorrect);
}

class ReviewItemTableCompanion extends UpdateCompanion<ReviewItemRow> {
  final Value<String> conceptTag;
  final Value<String> skillId;
  final Value<DateTime> dueAt;
  final Value<int> intervalDays;
  final Value<double> ease;
  final Value<int> repetitions;
  final Value<int> lapses;
  final Value<DateTime?> lastReviewed;
  final Value<String> lastDifficulty;
  final Value<int> totalAttempts;
  final Value<int> totalCorrect;
  final Value<int> rowid;
  const ReviewItemTableCompanion({
    this.conceptTag = const Value.absent(),
    this.skillId = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.ease = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.lastDifficulty = const Value.absent(),
    this.totalAttempts = const Value.absent(),
    this.totalCorrect = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewItemTableCompanion.insert({
    required String conceptTag,
    required String skillId,
    required DateTime dueAt,
    this.intervalDays = const Value.absent(),
    this.ease = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.lastDifficulty = const Value.absent(),
    this.totalAttempts = const Value.absent(),
    this.totalCorrect = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : conceptTag = Value(conceptTag),
       skillId = Value(skillId),
       dueAt = Value(dueAt);
  static Insertable<ReviewItemRow> custom({
    Expression<String>? conceptTag,
    Expression<String>? skillId,
    Expression<DateTime>? dueAt,
    Expression<int>? intervalDays,
    Expression<double>? ease,
    Expression<int>? repetitions,
    Expression<int>? lapses,
    Expression<DateTime>? lastReviewed,
    Expression<String>? lastDifficulty,
    Expression<int>? totalAttempts,
    Expression<int>? totalCorrect,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conceptTag != null) 'concept_tag': conceptTag,
      if (skillId != null) 'skill_id': skillId,
      if (dueAt != null) 'due_at': dueAt,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (ease != null) 'ease': ease,
      if (repetitions != null) 'repetitions': repetitions,
      if (lapses != null) 'lapses': lapses,
      if (lastReviewed != null) 'last_reviewed': lastReviewed,
      if (lastDifficulty != null) 'last_difficulty': lastDifficulty,
      if (totalAttempts != null) 'total_attempts': totalAttempts,
      if (totalCorrect != null) 'total_correct': totalCorrect,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewItemTableCompanion copyWith({
    Value<String>? conceptTag,
    Value<String>? skillId,
    Value<DateTime>? dueAt,
    Value<int>? intervalDays,
    Value<double>? ease,
    Value<int>? repetitions,
    Value<int>? lapses,
    Value<DateTime?>? lastReviewed,
    Value<String>? lastDifficulty,
    Value<int>? totalAttempts,
    Value<int>? totalCorrect,
    Value<int>? rowid,
  }) {
    return ReviewItemTableCompanion(
      conceptTag: conceptTag ?? this.conceptTag,
      skillId: skillId ?? this.skillId,
      dueAt: dueAt ?? this.dueAt,
      intervalDays: intervalDays ?? this.intervalDays,
      ease: ease ?? this.ease,
      repetitions: repetitions ?? this.repetitions,
      lapses: lapses ?? this.lapses,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      lastDifficulty: lastDifficulty ?? this.lastDifficulty,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conceptTag.present) {
      map['concept_tag'] = Variable<String>(conceptTag.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<String>(skillId.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (ease.present) {
      map['ease'] = Variable<double>(ease.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (lastReviewed.present) {
      map['last_reviewed'] = Variable<DateTime>(lastReviewed.value);
    }
    if (lastDifficulty.present) {
      map['last_difficulty'] = Variable<String>(lastDifficulty.value);
    }
    if (totalAttempts.present) {
      map['total_attempts'] = Variable<int>(totalAttempts.value);
    }
    if (totalCorrect.present) {
      map['total_correct'] = Variable<int>(totalCorrect.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewItemTableCompanion(')
          ..write('conceptTag: $conceptTag, ')
          ..write('skillId: $skillId, ')
          ..write('dueAt: $dueAt, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('ease: $ease, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('lastDifficulty: $lastDifficulty, ')
          ..write('totalAttempts: $totalAttempts, ')
          ..write('totalCorrect: $totalCorrect, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StreakTableTable extends StreakTable
    with TableInfo<$StreakTableTable, StreakRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreakTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _currentMeta = const VerificationMeta(
    'current',
  );
  @override
  late final GeneratedColumn<int> current = GeneratedColumn<int>(
    'current',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestMeta = const VerificationMeta(
    'longest',
  );
  @override
  late final GeneratedColumn<int> longest = GeneratedColumn<int>(
    'longest',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastActiveDayMeta = const VerificationMeta(
    'lastActiveDay',
  );
  @override
  late final GeneratedColumn<DateTime> lastActiveDay =
      GeneratedColumn<DateTime>(
        'last_active_day',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _totalActiveDaysMeta = const VerificationMeta(
    'totalActiveDays',
  );
  @override
  late final GeneratedColumn<int> totalActiveDays = GeneratedColumn<int>(
    'total_active_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    current,
    longest,
    lastActiveDay,
    totalActiveDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streak_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreakRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current')) {
      context.handle(
        _currentMeta,
        current.isAcceptableOrUnknown(data['current']!, _currentMeta),
      );
    }
    if (data.containsKey('longest')) {
      context.handle(
        _longestMeta,
        longest.isAcceptableOrUnknown(data['longest']!, _longestMeta),
      );
    }
    if (data.containsKey('last_active_day')) {
      context.handle(
        _lastActiveDayMeta,
        lastActiveDay.isAcceptableOrUnknown(
          data['last_active_day']!,
          _lastActiveDayMeta,
        ),
      );
    }
    if (data.containsKey('total_active_days')) {
      context.handle(
        _totalActiveDaysMeta,
        totalActiveDays.isAcceptableOrUnknown(
          data['total_active_days']!,
          _totalActiveDaysMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StreakRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreakRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      current: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current'],
      )!,
      longest: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest'],
      )!,
      lastActiveDay: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_active_day'],
      ),
      totalActiveDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_active_days'],
      )!,
    );
  }

  @override
  $StreakTableTable createAlias(String alias) {
    return $StreakTableTable(attachedDatabase, alias);
  }
}

class StreakRow extends DataClass implements Insertable<StreakRow> {
  final int id;
  final int current;
  final int longest;
  final DateTime? lastActiveDay;
  final int totalActiveDays;
  const StreakRow({
    required this.id,
    required this.current,
    required this.longest,
    this.lastActiveDay,
    required this.totalActiveDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current'] = Variable<int>(current);
    map['longest'] = Variable<int>(longest);
    if (!nullToAbsent || lastActiveDay != null) {
      map['last_active_day'] = Variable<DateTime>(lastActiveDay);
    }
    map['total_active_days'] = Variable<int>(totalActiveDays);
    return map;
  }

  StreakTableCompanion toCompanion(bool nullToAbsent) {
    return StreakTableCompanion(
      id: Value(id),
      current: Value(current),
      longest: Value(longest),
      lastActiveDay: lastActiveDay == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActiveDay),
      totalActiveDays: Value(totalActiveDays),
    );
  }

  factory StreakRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreakRow(
      id: serializer.fromJson<int>(json['id']),
      current: serializer.fromJson<int>(json['current']),
      longest: serializer.fromJson<int>(json['longest']),
      lastActiveDay: serializer.fromJson<DateTime?>(json['lastActiveDay']),
      totalActiveDays: serializer.fromJson<int>(json['totalActiveDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'current': serializer.toJson<int>(current),
      'longest': serializer.toJson<int>(longest),
      'lastActiveDay': serializer.toJson<DateTime?>(lastActiveDay),
      'totalActiveDays': serializer.toJson<int>(totalActiveDays),
    };
  }

  StreakRow copyWith({
    int? id,
    int? current,
    int? longest,
    Value<DateTime?> lastActiveDay = const Value.absent(),
    int? totalActiveDays,
  }) => StreakRow(
    id: id ?? this.id,
    current: current ?? this.current,
    longest: longest ?? this.longest,
    lastActiveDay: lastActiveDay.present
        ? lastActiveDay.value
        : this.lastActiveDay,
    totalActiveDays: totalActiveDays ?? this.totalActiveDays,
  );
  StreakRow copyWithCompanion(StreakTableCompanion data) {
    return StreakRow(
      id: data.id.present ? data.id.value : this.id,
      current: data.current.present ? data.current.value : this.current,
      longest: data.longest.present ? data.longest.value : this.longest,
      lastActiveDay: data.lastActiveDay.present
          ? data.lastActiveDay.value
          : this.lastActiveDay,
      totalActiveDays: data.totalActiveDays.present
          ? data.totalActiveDays.value
          : this.totalActiveDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreakRow(')
          ..write('id: $id, ')
          ..write('current: $current, ')
          ..write('longest: $longest, ')
          ..write('lastActiveDay: $lastActiveDay, ')
          ..write('totalActiveDays: $totalActiveDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, current, longest, lastActiveDay, totalActiveDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreakRow &&
          other.id == this.id &&
          other.current == this.current &&
          other.longest == this.longest &&
          other.lastActiveDay == this.lastActiveDay &&
          other.totalActiveDays == this.totalActiveDays);
}

class StreakTableCompanion extends UpdateCompanion<StreakRow> {
  final Value<int> id;
  final Value<int> current;
  final Value<int> longest;
  final Value<DateTime?> lastActiveDay;
  final Value<int> totalActiveDays;
  const StreakTableCompanion({
    this.id = const Value.absent(),
    this.current = const Value.absent(),
    this.longest = const Value.absent(),
    this.lastActiveDay = const Value.absent(),
    this.totalActiveDays = const Value.absent(),
  });
  StreakTableCompanion.insert({
    this.id = const Value.absent(),
    this.current = const Value.absent(),
    this.longest = const Value.absent(),
    this.lastActiveDay = const Value.absent(),
    this.totalActiveDays = const Value.absent(),
  });
  static Insertable<StreakRow> custom({
    Expression<int>? id,
    Expression<int>? current,
    Expression<int>? longest,
    Expression<DateTime>? lastActiveDay,
    Expression<int>? totalActiveDays,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (current != null) 'current': current,
      if (longest != null) 'longest': longest,
      if (lastActiveDay != null) 'last_active_day': lastActiveDay,
      if (totalActiveDays != null) 'total_active_days': totalActiveDays,
    });
  }

  StreakTableCompanion copyWith({
    Value<int>? id,
    Value<int>? current,
    Value<int>? longest,
    Value<DateTime?>? lastActiveDay,
    Value<int>? totalActiveDays,
  }) {
    return StreakTableCompanion(
      id: id ?? this.id,
      current: current ?? this.current,
      longest: longest ?? this.longest,
      lastActiveDay: lastActiveDay ?? this.lastActiveDay,
      totalActiveDays: totalActiveDays ?? this.totalActiveDays,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (current.present) {
      map['current'] = Variable<int>(current.value);
    }
    if (longest.present) {
      map['longest'] = Variable<int>(longest.value);
    }
    if (lastActiveDay.present) {
      map['last_active_day'] = Variable<DateTime>(lastActiveDay.value);
    }
    if (totalActiveDays.present) {
      map['total_active_days'] = Variable<int>(totalActiveDays.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreakTableCompanion(')
          ..write('id: $id, ')
          ..write('current: $current, ')
          ..write('longest: $longest, ')
          ..write('lastActiveDay: $lastActiveDay, ')
          ..write('totalActiveDays: $totalActiveDays')
          ..write(')'))
        .toString();
  }
}

class $UnlockedAchievementTableTable extends UnlockedAchievementTable
    with TableInfo<$UnlockedAchievementTableTable, UnlockedAchievementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnlockedAchievementTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _achievementIdMeta = const VerificationMeta(
    'achievementId',
  );
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
    'achievement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [achievementId, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unlocked_achievement_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnlockedAchievementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('achievement_id')) {
      context.handle(
        _achievementIdMeta,
        achievementId.isAcceptableOrUnknown(
          data['achievement_id']!,
          _achievementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {achievementId};
  @override
  UnlockedAchievementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnlockedAchievementRow(
      achievementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_id'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      )!,
    );
  }

  @override
  $UnlockedAchievementTableTable createAlias(String alias) {
    return $UnlockedAchievementTableTable(attachedDatabase, alias);
  }
}

class UnlockedAchievementRow extends DataClass
    implements Insertable<UnlockedAchievementRow> {
  final String achievementId;
  final DateTime unlockedAt;
  const UnlockedAchievementRow({
    required this.achievementId,
    required this.unlockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['achievement_id'] = Variable<String>(achievementId);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  UnlockedAchievementTableCompanion toCompanion(bool nullToAbsent) {
    return UnlockedAchievementTableCompanion(
      achievementId: Value(achievementId),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory UnlockedAchievementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnlockedAchievementRow(
      achievementId: serializer.fromJson<String>(json['achievementId']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'achievementId': serializer.toJson<String>(achievementId),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  UnlockedAchievementRow copyWith({
    String? achievementId,
    DateTime? unlockedAt,
  }) => UnlockedAchievementRow(
    achievementId: achievementId ?? this.achievementId,
    unlockedAt: unlockedAt ?? this.unlockedAt,
  );
  UnlockedAchievementRow copyWithCompanion(
    UnlockedAchievementTableCompanion data,
  ) {
    return UnlockedAchievementRow(
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedAchievementRow(')
          ..write('achievementId: $achievementId, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(achievementId, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnlockedAchievementRow &&
          other.achievementId == this.achievementId &&
          other.unlockedAt == this.unlockedAt);
}

class UnlockedAchievementTableCompanion
    extends UpdateCompanion<UnlockedAchievementRow> {
  final Value<String> achievementId;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const UnlockedAchievementTableCompanion({
    this.achievementId = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnlockedAchievementTableCompanion.insert({
    required String achievementId,
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  }) : achievementId = Value(achievementId),
       unlockedAt = Value(unlockedAt);
  static Insertable<UnlockedAchievementRow> custom({
    Expression<String>? achievementId,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (achievementId != null) 'achievement_id': achievementId,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnlockedAchievementTableCompanion copyWith({
    Value<String>? achievementId,
    Value<DateTime>? unlockedAt,
    Value<int>? rowid,
  }) {
    return UnlockedAchievementTableCompanion(
      achievementId: achievementId ?? this.achievementId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedAchievementTableCompanion(')
          ..write('achievementId: $achievementId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntryTableTable extends JournalEntryTable
    with TableInfo<$JournalEntryTableTable, JournalEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scenarioIdMeta = const VerificationMeta(
    'scenarioId',
  );
  @override
  late final GeneratedColumn<String> scenarioId = GeneratedColumn<String>(
    'scenario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetSymbolMeta = const VerificationMeta(
    'assetSymbol',
  );
  @override
  late final GeneratedColumn<String> assetSymbol = GeneratedColumn<String>(
    'asset_symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeframeNameMeta = const VerificationMeta(
    'timeframeName',
  );
  @override
  late final GeneratedColumn<String> timeframeName = GeneratedColumn<String>(
    'timeframe_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryMeta = const VerificationMeta('entry');
  @override
  late final GeneratedColumn<double> entry = GeneratedColumn<double>(
    'entry',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stopLossMeta = const VerificationMeta(
    'stopLoss',
  );
  @override
  late final GeneratedColumn<double> stopLoss = GeneratedColumn<double>(
    'stop_loss',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takeProfitMeta = const VerificationMeta(
    'takeProfit',
  );
  @override
  late final GeneratedColumn<double> takeProfit = GeneratedColumn<double>(
    'take_profit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _riskPercentMeta = const VerificationMeta(
    'riskPercent',
  );
  @override
  late final GeneratedColumn<double> riskPercent = GeneratedColumn<double>(
    'risk_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionSizeMeta = const VerificationMeta(
    'positionSize',
  );
  @override
  late final GeneratedColumn<double> positionSize = GeneratedColumn<double>(
    'position_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardToRiskMeta = const VerificationMeta(
    'rewardToRisk',
  );
  @override
  late final GeneratedColumn<double> rewardToRisk = GeneratedColumn<double>(
    'reward_to_risk',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rMultipleMeta = const VerificationMeta(
    'rMultiple',
  );
  @override
  late final GeneratedColumn<double> rMultiple = GeneratedColumn<double>(
    'r_multiple',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profitLossMeta = const VerificationMeta(
    'profitLoss',
  );
  @override
  late final GeneratedColumn<double> profitLoss = GeneratedColumn<double>(
    'profit_loss',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processScoreMeta = const VerificationMeta(
    'processScore',
  );
  @override
  late final GeneratedColumn<double> processScore = GeneratedColumn<double>(
    'process_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mistakeTagsMeta = const VerificationMeta(
    'mistakeTags',
  );
  @override
  late final GeneratedColumn<String> mistakeTags = GeneratedColumn<String>(
    'mistake_tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _featuresMeta = const VerificationMeta(
    'features',
  );
  @override
  late final GeneratedColumn<String> features = GeneratedColumn<String>(
    'features',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _favouriteMeta = const VerificationMeta(
    'favourite',
  );
  @override
  late final GeneratedColumn<bool> favourite = GeneratedColumn<bool>(
    'favourite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favourite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ambiguousCloseMeta = const VerificationMeta(
    'ambiguousClose',
  );
  @override
  late final GeneratedColumn<bool> ambiguousClose = GeneratedColumn<bool>(
    'ambiguous_close',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ambiguous_close" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scenarioId,
    completedAt,
    assetSymbol,
    timeframeName,
    direction,
    entry,
    stopLoss,
    takeProfit,
    riskPercent,
    positionSize,
    rewardToRisk,
    outcome,
    rMultiple,
    profitLoss,
    processScore,
    difficulty,
    mistakeTags,
    features,
    note,
    favourite,
    ambiguousClose,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entry_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('scenario_id')) {
      context.handle(
        _scenarioIdMeta,
        scenarioId.isAcceptableOrUnknown(data['scenario_id']!, _scenarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scenarioIdMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('asset_symbol')) {
      context.handle(
        _assetSymbolMeta,
        assetSymbol.isAcceptableOrUnknown(
          data['asset_symbol']!,
          _assetSymbolMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assetSymbolMeta);
    }
    if (data.containsKey('timeframe_name')) {
      context.handle(
        _timeframeNameMeta,
        timeframeName.isAcceptableOrUnknown(
          data['timeframe_name']!,
          _timeframeNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeframeNameMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('entry')) {
      context.handle(
        _entryMeta,
        entry.isAcceptableOrUnknown(data['entry']!, _entryMeta),
      );
    } else if (isInserting) {
      context.missing(_entryMeta);
    }
    if (data.containsKey('stop_loss')) {
      context.handle(
        _stopLossMeta,
        stopLoss.isAcceptableOrUnknown(data['stop_loss']!, _stopLossMeta),
      );
    } else if (isInserting) {
      context.missing(_stopLossMeta);
    }
    if (data.containsKey('take_profit')) {
      context.handle(
        _takeProfitMeta,
        takeProfit.isAcceptableOrUnknown(data['take_profit']!, _takeProfitMeta),
      );
    } else if (isInserting) {
      context.missing(_takeProfitMeta);
    }
    if (data.containsKey('risk_percent')) {
      context.handle(
        _riskPercentMeta,
        riskPercent.isAcceptableOrUnknown(
          data['risk_percent']!,
          _riskPercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_riskPercentMeta);
    }
    if (data.containsKey('position_size')) {
      context.handle(
        _positionSizeMeta,
        positionSize.isAcceptableOrUnknown(
          data['position_size']!,
          _positionSizeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_positionSizeMeta);
    }
    if (data.containsKey('reward_to_risk')) {
      context.handle(
        _rewardToRiskMeta,
        rewardToRisk.isAcceptableOrUnknown(
          data['reward_to_risk']!,
          _rewardToRiskMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rewardToRiskMeta);
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    } else if (isInserting) {
      context.missing(_outcomeMeta);
    }
    if (data.containsKey('r_multiple')) {
      context.handle(
        _rMultipleMeta,
        rMultiple.isAcceptableOrUnknown(data['r_multiple']!, _rMultipleMeta),
      );
    } else if (isInserting) {
      context.missing(_rMultipleMeta);
    }
    if (data.containsKey('profit_loss')) {
      context.handle(
        _profitLossMeta,
        profitLoss.isAcceptableOrUnknown(data['profit_loss']!, _profitLossMeta),
      );
    } else if (isInserting) {
      context.missing(_profitLossMeta);
    }
    if (data.containsKey('process_score')) {
      context.handle(
        _processScoreMeta,
        processScore.isAcceptableOrUnknown(
          data['process_score']!,
          _processScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processScoreMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('mistake_tags')) {
      context.handle(
        _mistakeTagsMeta,
        mistakeTags.isAcceptableOrUnknown(
          data['mistake_tags']!,
          _mistakeTagsMeta,
        ),
      );
    }
    if (data.containsKey('features')) {
      context.handle(
        _featuresMeta,
        features.isAcceptableOrUnknown(data['features']!, _featuresMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('favourite')) {
      context.handle(
        _favouriteMeta,
        favourite.isAcceptableOrUnknown(data['favourite']!, _favouriteMeta),
      );
    }
    if (data.containsKey('ambiguous_close')) {
      context.handle(
        _ambiguousCloseMeta,
        ambiguousClose.isAcceptableOrUnknown(
          data['ambiguous_close']!,
          _ambiguousCloseMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      scenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scenario_id'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      assetSymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_symbol'],
      )!,
      timeframeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timeframe_name'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      entry: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}entry'],
      )!,
      stopLoss: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stop_loss'],
      )!,
      takeProfit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}take_profit'],
      )!,
      riskPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}risk_percent'],
      )!,
      positionSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}position_size'],
      )!,
      rewardToRisk: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reward_to_risk'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      rMultiple: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}r_multiple'],
      )!,
      profitLoss: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}profit_loss'],
      )!,
      processScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}process_score'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      mistakeTags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mistake_tags'],
      )!,
      features: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}features'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      favourite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favourite'],
      )!,
      ambiguousClose: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ambiguous_close'],
      )!,
    );
  }

  @override
  $JournalEntryTableTable createAlias(String alias) {
    return $JournalEntryTableTable(attachedDatabase, alias);
  }
}

class JournalEntryRow extends DataClass implements Insertable<JournalEntryRow> {
  final String id;
  final String scenarioId;
  final DateTime completedAt;
  final String assetSymbol;
  final String timeframeName;
  final String direction;
  final double entry;
  final double stopLoss;
  final double takeProfit;
  final double riskPercent;
  final double positionSize;
  final double rewardToRisk;
  final String outcome;
  final double rMultiple;
  final double profitLoss;
  final double processScore;
  final String difficulty;

  /// Comma-separated mistake tag names.
  final String mistakeTags;

  /// Comma-separated scenario feature names.
  final String features;
  final String note;
  final bool favourite;
  final bool ambiguousClose;
  const JournalEntryRow({
    required this.id,
    required this.scenarioId,
    required this.completedAt,
    required this.assetSymbol,
    required this.timeframeName,
    required this.direction,
    required this.entry,
    required this.stopLoss,
    required this.takeProfit,
    required this.riskPercent,
    required this.positionSize,
    required this.rewardToRisk,
    required this.outcome,
    required this.rMultiple,
    required this.profitLoss,
    required this.processScore,
    required this.difficulty,
    required this.mistakeTags,
    required this.features,
    required this.note,
    required this.favourite,
    required this.ambiguousClose,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['scenario_id'] = Variable<String>(scenarioId);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['asset_symbol'] = Variable<String>(assetSymbol);
    map['timeframe_name'] = Variable<String>(timeframeName);
    map['direction'] = Variable<String>(direction);
    map['entry'] = Variable<double>(entry);
    map['stop_loss'] = Variable<double>(stopLoss);
    map['take_profit'] = Variable<double>(takeProfit);
    map['risk_percent'] = Variable<double>(riskPercent);
    map['position_size'] = Variable<double>(positionSize);
    map['reward_to_risk'] = Variable<double>(rewardToRisk);
    map['outcome'] = Variable<String>(outcome);
    map['r_multiple'] = Variable<double>(rMultiple);
    map['profit_loss'] = Variable<double>(profitLoss);
    map['process_score'] = Variable<double>(processScore);
    map['difficulty'] = Variable<String>(difficulty);
    map['mistake_tags'] = Variable<String>(mistakeTags);
    map['features'] = Variable<String>(features);
    map['note'] = Variable<String>(note);
    map['favourite'] = Variable<bool>(favourite);
    map['ambiguous_close'] = Variable<bool>(ambiguousClose);
    return map;
  }

  JournalEntryTableCompanion toCompanion(bool nullToAbsent) {
    return JournalEntryTableCompanion(
      id: Value(id),
      scenarioId: Value(scenarioId),
      completedAt: Value(completedAt),
      assetSymbol: Value(assetSymbol),
      timeframeName: Value(timeframeName),
      direction: Value(direction),
      entry: Value(entry),
      stopLoss: Value(stopLoss),
      takeProfit: Value(takeProfit),
      riskPercent: Value(riskPercent),
      positionSize: Value(positionSize),
      rewardToRisk: Value(rewardToRisk),
      outcome: Value(outcome),
      rMultiple: Value(rMultiple),
      profitLoss: Value(profitLoss),
      processScore: Value(processScore),
      difficulty: Value(difficulty),
      mistakeTags: Value(mistakeTags),
      features: Value(features),
      note: Value(note),
      favourite: Value(favourite),
      ambiguousClose: Value(ambiguousClose),
    );
  }

  factory JournalEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryRow(
      id: serializer.fromJson<String>(json['id']),
      scenarioId: serializer.fromJson<String>(json['scenarioId']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      assetSymbol: serializer.fromJson<String>(json['assetSymbol']),
      timeframeName: serializer.fromJson<String>(json['timeframeName']),
      direction: serializer.fromJson<String>(json['direction']),
      entry: serializer.fromJson<double>(json['entry']),
      stopLoss: serializer.fromJson<double>(json['stopLoss']),
      takeProfit: serializer.fromJson<double>(json['takeProfit']),
      riskPercent: serializer.fromJson<double>(json['riskPercent']),
      positionSize: serializer.fromJson<double>(json['positionSize']),
      rewardToRisk: serializer.fromJson<double>(json['rewardToRisk']),
      outcome: serializer.fromJson<String>(json['outcome']),
      rMultiple: serializer.fromJson<double>(json['rMultiple']),
      profitLoss: serializer.fromJson<double>(json['profitLoss']),
      processScore: serializer.fromJson<double>(json['processScore']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      mistakeTags: serializer.fromJson<String>(json['mistakeTags']),
      features: serializer.fromJson<String>(json['features']),
      note: serializer.fromJson<String>(json['note']),
      favourite: serializer.fromJson<bool>(json['favourite']),
      ambiguousClose: serializer.fromJson<bool>(json['ambiguousClose']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scenarioId': serializer.toJson<String>(scenarioId),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'assetSymbol': serializer.toJson<String>(assetSymbol),
      'timeframeName': serializer.toJson<String>(timeframeName),
      'direction': serializer.toJson<String>(direction),
      'entry': serializer.toJson<double>(entry),
      'stopLoss': serializer.toJson<double>(stopLoss),
      'takeProfit': serializer.toJson<double>(takeProfit),
      'riskPercent': serializer.toJson<double>(riskPercent),
      'positionSize': serializer.toJson<double>(positionSize),
      'rewardToRisk': serializer.toJson<double>(rewardToRisk),
      'outcome': serializer.toJson<String>(outcome),
      'rMultiple': serializer.toJson<double>(rMultiple),
      'profitLoss': serializer.toJson<double>(profitLoss),
      'processScore': serializer.toJson<double>(processScore),
      'difficulty': serializer.toJson<String>(difficulty),
      'mistakeTags': serializer.toJson<String>(mistakeTags),
      'features': serializer.toJson<String>(features),
      'note': serializer.toJson<String>(note),
      'favourite': serializer.toJson<bool>(favourite),
      'ambiguousClose': serializer.toJson<bool>(ambiguousClose),
    };
  }

  JournalEntryRow copyWith({
    String? id,
    String? scenarioId,
    DateTime? completedAt,
    String? assetSymbol,
    String? timeframeName,
    String? direction,
    double? entry,
    double? stopLoss,
    double? takeProfit,
    double? riskPercent,
    double? positionSize,
    double? rewardToRisk,
    String? outcome,
    double? rMultiple,
    double? profitLoss,
    double? processScore,
    String? difficulty,
    String? mistakeTags,
    String? features,
    String? note,
    bool? favourite,
    bool? ambiguousClose,
  }) => JournalEntryRow(
    id: id ?? this.id,
    scenarioId: scenarioId ?? this.scenarioId,
    completedAt: completedAt ?? this.completedAt,
    assetSymbol: assetSymbol ?? this.assetSymbol,
    timeframeName: timeframeName ?? this.timeframeName,
    direction: direction ?? this.direction,
    entry: entry ?? this.entry,
    stopLoss: stopLoss ?? this.stopLoss,
    takeProfit: takeProfit ?? this.takeProfit,
    riskPercent: riskPercent ?? this.riskPercent,
    positionSize: positionSize ?? this.positionSize,
    rewardToRisk: rewardToRisk ?? this.rewardToRisk,
    outcome: outcome ?? this.outcome,
    rMultiple: rMultiple ?? this.rMultiple,
    profitLoss: profitLoss ?? this.profitLoss,
    processScore: processScore ?? this.processScore,
    difficulty: difficulty ?? this.difficulty,
    mistakeTags: mistakeTags ?? this.mistakeTags,
    features: features ?? this.features,
    note: note ?? this.note,
    favourite: favourite ?? this.favourite,
    ambiguousClose: ambiguousClose ?? this.ambiguousClose,
  );
  JournalEntryRow copyWithCompanion(JournalEntryTableCompanion data) {
    return JournalEntryRow(
      id: data.id.present ? data.id.value : this.id,
      scenarioId: data.scenarioId.present
          ? data.scenarioId.value
          : this.scenarioId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      assetSymbol: data.assetSymbol.present
          ? data.assetSymbol.value
          : this.assetSymbol,
      timeframeName: data.timeframeName.present
          ? data.timeframeName.value
          : this.timeframeName,
      direction: data.direction.present ? data.direction.value : this.direction,
      entry: data.entry.present ? data.entry.value : this.entry,
      stopLoss: data.stopLoss.present ? data.stopLoss.value : this.stopLoss,
      takeProfit: data.takeProfit.present
          ? data.takeProfit.value
          : this.takeProfit,
      riskPercent: data.riskPercent.present
          ? data.riskPercent.value
          : this.riskPercent,
      positionSize: data.positionSize.present
          ? data.positionSize.value
          : this.positionSize,
      rewardToRisk: data.rewardToRisk.present
          ? data.rewardToRisk.value
          : this.rewardToRisk,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      rMultiple: data.rMultiple.present ? data.rMultiple.value : this.rMultiple,
      profitLoss: data.profitLoss.present
          ? data.profitLoss.value
          : this.profitLoss,
      processScore: data.processScore.present
          ? data.processScore.value
          : this.processScore,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      mistakeTags: data.mistakeTags.present
          ? data.mistakeTags.value
          : this.mistakeTags,
      features: data.features.present ? data.features.value : this.features,
      note: data.note.present ? data.note.value : this.note,
      favourite: data.favourite.present ? data.favourite.value : this.favourite,
      ambiguousClose: data.ambiguousClose.present
          ? data.ambiguousClose.value
          : this.ambiguousClose,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryRow(')
          ..write('id: $id, ')
          ..write('scenarioId: $scenarioId, ')
          ..write('completedAt: $completedAt, ')
          ..write('assetSymbol: $assetSymbol, ')
          ..write('timeframeName: $timeframeName, ')
          ..write('direction: $direction, ')
          ..write('entry: $entry, ')
          ..write('stopLoss: $stopLoss, ')
          ..write('takeProfit: $takeProfit, ')
          ..write('riskPercent: $riskPercent, ')
          ..write('positionSize: $positionSize, ')
          ..write('rewardToRisk: $rewardToRisk, ')
          ..write('outcome: $outcome, ')
          ..write('rMultiple: $rMultiple, ')
          ..write('profitLoss: $profitLoss, ')
          ..write('processScore: $processScore, ')
          ..write('difficulty: $difficulty, ')
          ..write('mistakeTags: $mistakeTags, ')
          ..write('features: $features, ')
          ..write('note: $note, ')
          ..write('favourite: $favourite, ')
          ..write('ambiguousClose: $ambiguousClose')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    scenarioId,
    completedAt,
    assetSymbol,
    timeframeName,
    direction,
    entry,
    stopLoss,
    takeProfit,
    riskPercent,
    positionSize,
    rewardToRisk,
    outcome,
    rMultiple,
    profitLoss,
    processScore,
    difficulty,
    mistakeTags,
    features,
    note,
    favourite,
    ambiguousClose,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryRow &&
          other.id == this.id &&
          other.scenarioId == this.scenarioId &&
          other.completedAt == this.completedAt &&
          other.assetSymbol == this.assetSymbol &&
          other.timeframeName == this.timeframeName &&
          other.direction == this.direction &&
          other.entry == this.entry &&
          other.stopLoss == this.stopLoss &&
          other.takeProfit == this.takeProfit &&
          other.riskPercent == this.riskPercent &&
          other.positionSize == this.positionSize &&
          other.rewardToRisk == this.rewardToRisk &&
          other.outcome == this.outcome &&
          other.rMultiple == this.rMultiple &&
          other.profitLoss == this.profitLoss &&
          other.processScore == this.processScore &&
          other.difficulty == this.difficulty &&
          other.mistakeTags == this.mistakeTags &&
          other.features == this.features &&
          other.note == this.note &&
          other.favourite == this.favourite &&
          other.ambiguousClose == this.ambiguousClose);
}

class JournalEntryTableCompanion extends UpdateCompanion<JournalEntryRow> {
  final Value<String> id;
  final Value<String> scenarioId;
  final Value<DateTime> completedAt;
  final Value<String> assetSymbol;
  final Value<String> timeframeName;
  final Value<String> direction;
  final Value<double> entry;
  final Value<double> stopLoss;
  final Value<double> takeProfit;
  final Value<double> riskPercent;
  final Value<double> positionSize;
  final Value<double> rewardToRisk;
  final Value<String> outcome;
  final Value<double> rMultiple;
  final Value<double> profitLoss;
  final Value<double> processScore;
  final Value<String> difficulty;
  final Value<String> mistakeTags;
  final Value<String> features;
  final Value<String> note;
  final Value<bool> favourite;
  final Value<bool> ambiguousClose;
  final Value<int> rowid;
  const JournalEntryTableCompanion({
    this.id = const Value.absent(),
    this.scenarioId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.assetSymbol = const Value.absent(),
    this.timeframeName = const Value.absent(),
    this.direction = const Value.absent(),
    this.entry = const Value.absent(),
    this.stopLoss = const Value.absent(),
    this.takeProfit = const Value.absent(),
    this.riskPercent = const Value.absent(),
    this.positionSize = const Value.absent(),
    this.rewardToRisk = const Value.absent(),
    this.outcome = const Value.absent(),
    this.rMultiple = const Value.absent(),
    this.profitLoss = const Value.absent(),
    this.processScore = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.mistakeTags = const Value.absent(),
    this.features = const Value.absent(),
    this.note = const Value.absent(),
    this.favourite = const Value.absent(),
    this.ambiguousClose = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntryTableCompanion.insert({
    required String id,
    required String scenarioId,
    required DateTime completedAt,
    required String assetSymbol,
    required String timeframeName,
    required String direction,
    required double entry,
    required double stopLoss,
    required double takeProfit,
    required double riskPercent,
    required double positionSize,
    required double rewardToRisk,
    required String outcome,
    required double rMultiple,
    required double profitLoss,
    required double processScore,
    required String difficulty,
    this.mistakeTags = const Value.absent(),
    this.features = const Value.absent(),
    this.note = const Value.absent(),
    this.favourite = const Value.absent(),
    this.ambiguousClose = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scenarioId = Value(scenarioId),
       completedAt = Value(completedAt),
       assetSymbol = Value(assetSymbol),
       timeframeName = Value(timeframeName),
       direction = Value(direction),
       entry = Value(entry),
       stopLoss = Value(stopLoss),
       takeProfit = Value(takeProfit),
       riskPercent = Value(riskPercent),
       positionSize = Value(positionSize),
       rewardToRisk = Value(rewardToRisk),
       outcome = Value(outcome),
       rMultiple = Value(rMultiple),
       profitLoss = Value(profitLoss),
       processScore = Value(processScore),
       difficulty = Value(difficulty);
  static Insertable<JournalEntryRow> custom({
    Expression<String>? id,
    Expression<String>? scenarioId,
    Expression<DateTime>? completedAt,
    Expression<String>? assetSymbol,
    Expression<String>? timeframeName,
    Expression<String>? direction,
    Expression<double>? entry,
    Expression<double>? stopLoss,
    Expression<double>? takeProfit,
    Expression<double>? riskPercent,
    Expression<double>? positionSize,
    Expression<double>? rewardToRisk,
    Expression<String>? outcome,
    Expression<double>? rMultiple,
    Expression<double>? profitLoss,
    Expression<double>? processScore,
    Expression<String>? difficulty,
    Expression<String>? mistakeTags,
    Expression<String>? features,
    Expression<String>? note,
    Expression<bool>? favourite,
    Expression<bool>? ambiguousClose,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scenarioId != null) 'scenario_id': scenarioId,
      if (completedAt != null) 'completed_at': completedAt,
      if (assetSymbol != null) 'asset_symbol': assetSymbol,
      if (timeframeName != null) 'timeframe_name': timeframeName,
      if (direction != null) 'direction': direction,
      if (entry != null) 'entry': entry,
      if (stopLoss != null) 'stop_loss': stopLoss,
      if (takeProfit != null) 'take_profit': takeProfit,
      if (riskPercent != null) 'risk_percent': riskPercent,
      if (positionSize != null) 'position_size': positionSize,
      if (rewardToRisk != null) 'reward_to_risk': rewardToRisk,
      if (outcome != null) 'outcome': outcome,
      if (rMultiple != null) 'r_multiple': rMultiple,
      if (profitLoss != null) 'profit_loss': profitLoss,
      if (processScore != null) 'process_score': processScore,
      if (difficulty != null) 'difficulty': difficulty,
      if (mistakeTags != null) 'mistake_tags': mistakeTags,
      if (features != null) 'features': features,
      if (note != null) 'note': note,
      if (favourite != null) 'favourite': favourite,
      if (ambiguousClose != null) 'ambiguous_close': ambiguousClose,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntryTableCompanion copyWith({
    Value<String>? id,
    Value<String>? scenarioId,
    Value<DateTime>? completedAt,
    Value<String>? assetSymbol,
    Value<String>? timeframeName,
    Value<String>? direction,
    Value<double>? entry,
    Value<double>? stopLoss,
    Value<double>? takeProfit,
    Value<double>? riskPercent,
    Value<double>? positionSize,
    Value<double>? rewardToRisk,
    Value<String>? outcome,
    Value<double>? rMultiple,
    Value<double>? profitLoss,
    Value<double>? processScore,
    Value<String>? difficulty,
    Value<String>? mistakeTags,
    Value<String>? features,
    Value<String>? note,
    Value<bool>? favourite,
    Value<bool>? ambiguousClose,
    Value<int>? rowid,
  }) {
    return JournalEntryTableCompanion(
      id: id ?? this.id,
      scenarioId: scenarioId ?? this.scenarioId,
      completedAt: completedAt ?? this.completedAt,
      assetSymbol: assetSymbol ?? this.assetSymbol,
      timeframeName: timeframeName ?? this.timeframeName,
      direction: direction ?? this.direction,
      entry: entry ?? this.entry,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      riskPercent: riskPercent ?? this.riskPercent,
      positionSize: positionSize ?? this.positionSize,
      rewardToRisk: rewardToRisk ?? this.rewardToRisk,
      outcome: outcome ?? this.outcome,
      rMultiple: rMultiple ?? this.rMultiple,
      profitLoss: profitLoss ?? this.profitLoss,
      processScore: processScore ?? this.processScore,
      difficulty: difficulty ?? this.difficulty,
      mistakeTags: mistakeTags ?? this.mistakeTags,
      features: features ?? this.features,
      note: note ?? this.note,
      favourite: favourite ?? this.favourite,
      ambiguousClose: ambiguousClose ?? this.ambiguousClose,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scenarioId.present) {
      map['scenario_id'] = Variable<String>(scenarioId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (assetSymbol.present) {
      map['asset_symbol'] = Variable<String>(assetSymbol.value);
    }
    if (timeframeName.present) {
      map['timeframe_name'] = Variable<String>(timeframeName.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (entry.present) {
      map['entry'] = Variable<double>(entry.value);
    }
    if (stopLoss.present) {
      map['stop_loss'] = Variable<double>(stopLoss.value);
    }
    if (takeProfit.present) {
      map['take_profit'] = Variable<double>(takeProfit.value);
    }
    if (riskPercent.present) {
      map['risk_percent'] = Variable<double>(riskPercent.value);
    }
    if (positionSize.present) {
      map['position_size'] = Variable<double>(positionSize.value);
    }
    if (rewardToRisk.present) {
      map['reward_to_risk'] = Variable<double>(rewardToRisk.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (rMultiple.present) {
      map['r_multiple'] = Variable<double>(rMultiple.value);
    }
    if (profitLoss.present) {
      map['profit_loss'] = Variable<double>(profitLoss.value);
    }
    if (processScore.present) {
      map['process_score'] = Variable<double>(processScore.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (mistakeTags.present) {
      map['mistake_tags'] = Variable<String>(mistakeTags.value);
    }
    if (features.present) {
      map['features'] = Variable<String>(features.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (favourite.present) {
      map['favourite'] = Variable<bool>(favourite.value);
    }
    if (ambiguousClose.present) {
      map['ambiguous_close'] = Variable<bool>(ambiguousClose.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryTableCompanion(')
          ..write('id: $id, ')
          ..write('scenarioId: $scenarioId, ')
          ..write('completedAt: $completedAt, ')
          ..write('assetSymbol: $assetSymbol, ')
          ..write('timeframeName: $timeframeName, ')
          ..write('direction: $direction, ')
          ..write('entry: $entry, ')
          ..write('stopLoss: $stopLoss, ')
          ..write('takeProfit: $takeProfit, ')
          ..write('riskPercent: $riskPercent, ')
          ..write('positionSize: $positionSize, ')
          ..write('rewardToRisk: $rewardToRisk, ')
          ..write('outcome: $outcome, ')
          ..write('rMultiple: $rMultiple, ')
          ..write('profitLoss: $profitLoss, ')
          ..write('processScore: $processScore, ')
          ..write('difficulty: $difficulty, ')
          ..write('mistakeTags: $mistakeTags, ')
          ..write('features: $features, ')
          ..write('note: $note, ')
          ..write('favourite: $favourite, ')
          ..write('ambiguousClose: $ambiguousClose, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SimulatorAccountTableTable extends SimulatorAccountTable
    with TableInfo<$SimulatorAccountTableTable, SimulatorAccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SimulatorAccountTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _startingBalanceMeta = const VerificationMeta(
    'startingBalance',
  );
  @override
  late final GeneratedColumn<double> startingBalance = GeneratedColumn<double>(
    'starting_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(10000.0),
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(10000.0),
  );
  static const VerificationMeta _peakBalanceMeta = const VerificationMeta(
    'peakBalance',
  );
  @override
  late final GeneratedColumn<double> peakBalance = GeneratedColumn<double>(
    'peak_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(10000.0),
  );
  static const VerificationMeta _tradeCountMeta = const VerificationMeta(
    'tradeCount',
  );
  @override
  late final GeneratedColumn<int> tradeCount = GeneratedColumn<int>(
    'trade_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _resetAtMeta = const VerificationMeta(
    'resetAt',
  );
  @override
  late final GeneratedColumn<DateTime> resetAt = GeneratedColumn<DateTime>(
    'reset_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startingBalance,
    balance,
    peakBalance,
    tradeCount,
    resetAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'simulator_account_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SimulatorAccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('starting_balance')) {
      context.handle(
        _startingBalanceMeta,
        startingBalance.isAcceptableOrUnknown(
          data['starting_balance']!,
          _startingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    }
    if (data.containsKey('peak_balance')) {
      context.handle(
        _peakBalanceMeta,
        peakBalance.isAcceptableOrUnknown(
          data['peak_balance']!,
          _peakBalanceMeta,
        ),
      );
    }
    if (data.containsKey('trade_count')) {
      context.handle(
        _tradeCountMeta,
        tradeCount.isAcceptableOrUnknown(data['trade_count']!, _tradeCountMeta),
      );
    }
    if (data.containsKey('reset_at')) {
      context.handle(
        _resetAtMeta,
        resetAt.isAcceptableOrUnknown(data['reset_at']!, _resetAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SimulatorAccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SimulatorAccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}starting_balance'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
      peakBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peak_balance'],
      )!,
      tradeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trade_count'],
      )!,
      resetAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reset_at'],
      ),
    );
  }

  @override
  $SimulatorAccountTableTable createAlias(String alias) {
    return $SimulatorAccountTableTable(attachedDatabase, alias);
  }
}

class SimulatorAccountRow extends DataClass
    implements Insertable<SimulatorAccountRow> {
  final int id;
  final double startingBalance;
  final double balance;
  final double peakBalance;
  final int tradeCount;
  final DateTime? resetAt;
  const SimulatorAccountRow({
    required this.id,
    required this.startingBalance,
    required this.balance,
    required this.peakBalance,
    required this.tradeCount,
    this.resetAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['starting_balance'] = Variable<double>(startingBalance);
    map['balance'] = Variable<double>(balance);
    map['peak_balance'] = Variable<double>(peakBalance);
    map['trade_count'] = Variable<int>(tradeCount);
    if (!nullToAbsent || resetAt != null) {
      map['reset_at'] = Variable<DateTime>(resetAt);
    }
    return map;
  }

  SimulatorAccountTableCompanion toCompanion(bool nullToAbsent) {
    return SimulatorAccountTableCompanion(
      id: Value(id),
      startingBalance: Value(startingBalance),
      balance: Value(balance),
      peakBalance: Value(peakBalance),
      tradeCount: Value(tradeCount),
      resetAt: resetAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resetAt),
    );
  }

  factory SimulatorAccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SimulatorAccountRow(
      id: serializer.fromJson<int>(json['id']),
      startingBalance: serializer.fromJson<double>(json['startingBalance']),
      balance: serializer.fromJson<double>(json['balance']),
      peakBalance: serializer.fromJson<double>(json['peakBalance']),
      tradeCount: serializer.fromJson<int>(json['tradeCount']),
      resetAt: serializer.fromJson<DateTime?>(json['resetAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startingBalance': serializer.toJson<double>(startingBalance),
      'balance': serializer.toJson<double>(balance),
      'peakBalance': serializer.toJson<double>(peakBalance),
      'tradeCount': serializer.toJson<int>(tradeCount),
      'resetAt': serializer.toJson<DateTime?>(resetAt),
    };
  }

  SimulatorAccountRow copyWith({
    int? id,
    double? startingBalance,
    double? balance,
    double? peakBalance,
    int? tradeCount,
    Value<DateTime?> resetAt = const Value.absent(),
  }) => SimulatorAccountRow(
    id: id ?? this.id,
    startingBalance: startingBalance ?? this.startingBalance,
    balance: balance ?? this.balance,
    peakBalance: peakBalance ?? this.peakBalance,
    tradeCount: tradeCount ?? this.tradeCount,
    resetAt: resetAt.present ? resetAt.value : this.resetAt,
  );
  SimulatorAccountRow copyWithCompanion(SimulatorAccountTableCompanion data) {
    return SimulatorAccountRow(
      id: data.id.present ? data.id.value : this.id,
      startingBalance: data.startingBalance.present
          ? data.startingBalance.value
          : this.startingBalance,
      balance: data.balance.present ? data.balance.value : this.balance,
      peakBalance: data.peakBalance.present
          ? data.peakBalance.value
          : this.peakBalance,
      tradeCount: data.tradeCount.present
          ? data.tradeCount.value
          : this.tradeCount,
      resetAt: data.resetAt.present ? data.resetAt.value : this.resetAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SimulatorAccountRow(')
          ..write('id: $id, ')
          ..write('startingBalance: $startingBalance, ')
          ..write('balance: $balance, ')
          ..write('peakBalance: $peakBalance, ')
          ..write('tradeCount: $tradeCount, ')
          ..write('resetAt: $resetAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startingBalance,
    balance,
    peakBalance,
    tradeCount,
    resetAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SimulatorAccountRow &&
          other.id == this.id &&
          other.startingBalance == this.startingBalance &&
          other.balance == this.balance &&
          other.peakBalance == this.peakBalance &&
          other.tradeCount == this.tradeCount &&
          other.resetAt == this.resetAt);
}

class SimulatorAccountTableCompanion
    extends UpdateCompanion<SimulatorAccountRow> {
  final Value<int> id;
  final Value<double> startingBalance;
  final Value<double> balance;
  final Value<double> peakBalance;
  final Value<int> tradeCount;
  final Value<DateTime?> resetAt;
  const SimulatorAccountTableCompanion({
    this.id = const Value.absent(),
    this.startingBalance = const Value.absent(),
    this.balance = const Value.absent(),
    this.peakBalance = const Value.absent(),
    this.tradeCount = const Value.absent(),
    this.resetAt = const Value.absent(),
  });
  SimulatorAccountTableCompanion.insert({
    this.id = const Value.absent(),
    this.startingBalance = const Value.absent(),
    this.balance = const Value.absent(),
    this.peakBalance = const Value.absent(),
    this.tradeCount = const Value.absent(),
    this.resetAt = const Value.absent(),
  });
  static Insertable<SimulatorAccountRow> custom({
    Expression<int>? id,
    Expression<double>? startingBalance,
    Expression<double>? balance,
    Expression<double>? peakBalance,
    Expression<int>? tradeCount,
    Expression<DateTime>? resetAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startingBalance != null) 'starting_balance': startingBalance,
      if (balance != null) 'balance': balance,
      if (peakBalance != null) 'peak_balance': peakBalance,
      if (tradeCount != null) 'trade_count': tradeCount,
      if (resetAt != null) 'reset_at': resetAt,
    });
  }

  SimulatorAccountTableCompanion copyWith({
    Value<int>? id,
    Value<double>? startingBalance,
    Value<double>? balance,
    Value<double>? peakBalance,
    Value<int>? tradeCount,
    Value<DateTime?>? resetAt,
  }) {
    return SimulatorAccountTableCompanion(
      id: id ?? this.id,
      startingBalance: startingBalance ?? this.startingBalance,
      balance: balance ?? this.balance,
      peakBalance: peakBalance ?? this.peakBalance,
      tradeCount: tradeCount ?? this.tradeCount,
      resetAt: resetAt ?? this.resetAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startingBalance.present) {
      map['starting_balance'] = Variable<double>(startingBalance.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (peakBalance.present) {
      map['peak_balance'] = Variable<double>(peakBalance.value);
    }
    if (tradeCount.present) {
      map['trade_count'] = Variable<int>(tradeCount.value);
    }
    if (resetAt.present) {
      map['reset_at'] = Variable<DateTime>(resetAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SimulatorAccountTableCompanion(')
          ..write('id: $id, ')
          ..write('startingBalance: $startingBalance, ')
          ..write('balance: $balance, ')
          ..write('peakBalance: $peakBalance, ')
          ..write('tradeCount: $tradeCount, ')
          ..write('resetAt: $resetAt')
          ..write(')'))
        .toString();
  }
}

class $EquityPointTableTable extends EquityPointTable
    with TableInfo<$EquityPointTableTable, EquityPointRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquityPointTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rMultipleMeta = const VerificationMeta(
    'rMultiple',
  );
  @override
  late final GeneratedColumn<double> rMultiple = GeneratedColumn<double>(
    'r_multiple',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _journalEntryIdMeta = const VerificationMeta(
    'journalEntryId',
  );
  @override
  late final GeneratedColumn<String> journalEntryId = GeneratedColumn<String>(
    'journal_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    at,
    balance,
    rMultiple,
    journalEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equity_point_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquityPointRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('r_multiple')) {
      context.handle(
        _rMultipleMeta,
        rMultiple.isAcceptableOrUnknown(data['r_multiple']!, _rMultipleMeta),
      );
    }
    if (data.containsKey('journal_entry_id')) {
      context.handle(
        _journalEntryIdMeta,
        journalEntryId.isAcceptableOrUnknown(
          data['journal_entry_id']!,
          _journalEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquityPointRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquityPointRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
      rMultiple: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}r_multiple'],
      )!,
      journalEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal_entry_id'],
      ),
    );
  }

  @override
  $EquityPointTableTable createAlias(String alias) {
    return $EquityPointTableTable(attachedDatabase, alias);
  }
}

class EquityPointRow extends DataClass implements Insertable<EquityPointRow> {
  final int id;
  final DateTime at;
  final double balance;
  final double rMultiple;
  final String? journalEntryId;
  const EquityPointRow({
    required this.id,
    required this.at,
    required this.balance,
    required this.rMultiple,
    this.journalEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['balance'] = Variable<double>(balance);
    map['r_multiple'] = Variable<double>(rMultiple);
    if (!nullToAbsent || journalEntryId != null) {
      map['journal_entry_id'] = Variable<String>(journalEntryId);
    }
    return map;
  }

  EquityPointTableCompanion toCompanion(bool nullToAbsent) {
    return EquityPointTableCompanion(
      id: Value(id),
      at: Value(at),
      balance: Value(balance),
      rMultiple: Value(rMultiple),
      journalEntryId: journalEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(journalEntryId),
    );
  }

  factory EquityPointRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquityPointRow(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      balance: serializer.fromJson<double>(json['balance']),
      rMultiple: serializer.fromJson<double>(json['rMultiple']),
      journalEntryId: serializer.fromJson<String?>(json['journalEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'balance': serializer.toJson<double>(balance),
      'rMultiple': serializer.toJson<double>(rMultiple),
      'journalEntryId': serializer.toJson<String?>(journalEntryId),
    };
  }

  EquityPointRow copyWith({
    int? id,
    DateTime? at,
    double? balance,
    double? rMultiple,
    Value<String?> journalEntryId = const Value.absent(),
  }) => EquityPointRow(
    id: id ?? this.id,
    at: at ?? this.at,
    balance: balance ?? this.balance,
    rMultiple: rMultiple ?? this.rMultiple,
    journalEntryId: journalEntryId.present
        ? journalEntryId.value
        : this.journalEntryId,
  );
  EquityPointRow copyWithCompanion(EquityPointTableCompanion data) {
    return EquityPointRow(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      balance: data.balance.present ? data.balance.value : this.balance,
      rMultiple: data.rMultiple.present ? data.rMultiple.value : this.rMultiple,
      journalEntryId: data.journalEntryId.present
          ? data.journalEntryId.value
          : this.journalEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquityPointRow(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('balance: $balance, ')
          ..write('rMultiple: $rMultiple, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, balance, rMultiple, journalEntryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquityPointRow &&
          other.id == this.id &&
          other.at == this.at &&
          other.balance == this.balance &&
          other.rMultiple == this.rMultiple &&
          other.journalEntryId == this.journalEntryId);
}

class EquityPointTableCompanion extends UpdateCompanion<EquityPointRow> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<double> balance;
  final Value<double> rMultiple;
  final Value<String?> journalEntryId;
  const EquityPointTableCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.balance = const Value.absent(),
    this.rMultiple = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  });
  EquityPointTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    required double balance,
    this.rMultiple = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  }) : at = Value(at),
       balance = Value(balance);
  static Insertable<EquityPointRow> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<double>? balance,
    Expression<double>? rMultiple,
    Expression<String>? journalEntryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (balance != null) 'balance': balance,
      if (rMultiple != null) 'r_multiple': rMultiple,
      if (journalEntryId != null) 'journal_entry_id': journalEntryId,
    });
  }

  EquityPointTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<double>? balance,
    Value<double>? rMultiple,
    Value<String?>? journalEntryId,
  }) {
    return EquityPointTableCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      balance: balance ?? this.balance,
      rMultiple: rMultiple ?? this.rMultiple,
      journalEntryId: journalEntryId ?? this.journalEntryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (rMultiple.present) {
      map['r_multiple'] = Variable<double>(rMultiple.value);
    }
    if (journalEntryId.present) {
      map['journal_entry_id'] = Variable<String>(journalEntryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquityPointTableCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('balance: $balance, ')
          ..write('rMultiple: $rMultiple, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }
}

class $XpEventTableTable extends XpEventTable
    with TableInfo<$XpEventTableTable, XpEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $XpEventTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, at, amount, source, reference];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'xp_event_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<XpEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  XpEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return XpEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
    );
  }

  @override
  $XpEventTableTable createAlias(String alias) {
    return $XpEventTableTable(attachedDatabase, alias);
  }
}

class XpEventRow extends DataClass implements Insertable<XpEventRow> {
  final int id;
  final DateTime at;
  final int amount;
  final String source;
  final String? reference;
  const XpEventRow({
    required this.id,
    required this.at,
    required this.amount,
    required this.source,
    this.reference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['amount'] = Variable<int>(amount);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    return map;
  }

  XpEventTableCompanion toCompanion(bool nullToAbsent) {
    return XpEventTableCompanion(
      id: Value(id),
      at: Value(at),
      amount: Value(amount),
      source: Value(source),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
    );
  }

  factory XpEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return XpEventRow(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      amount: serializer.fromJson<int>(json['amount']),
      source: serializer.fromJson<String>(json['source']),
      reference: serializer.fromJson<String?>(json['reference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'amount': serializer.toJson<int>(amount),
      'source': serializer.toJson<String>(source),
      'reference': serializer.toJson<String?>(reference),
    };
  }

  XpEventRow copyWith({
    int? id,
    DateTime? at,
    int? amount,
    String? source,
    Value<String?> reference = const Value.absent(),
  }) => XpEventRow(
    id: id ?? this.id,
    at: at ?? this.at,
    amount: amount ?? this.amount,
    source: source ?? this.source,
    reference: reference.present ? reference.value : this.reference,
  );
  XpEventRow copyWithCompanion(XpEventTableCompanion data) {
    return XpEventRow(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      amount: data.amount.present ? data.amount.value : this.amount,
      source: data.source.present ? data.source.value : this.source,
      reference: data.reference.present ? data.reference.value : this.reference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('XpEventRow(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('amount: $amount, ')
          ..write('source: $source, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, amount, source, reference);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XpEventRow &&
          other.id == this.id &&
          other.at == this.at &&
          other.amount == this.amount &&
          other.source == this.source &&
          other.reference == this.reference);
}

class XpEventTableCompanion extends UpdateCompanion<XpEventRow> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<int> amount;
  final Value<String> source;
  final Value<String?> reference;
  const XpEventTableCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.amount = const Value.absent(),
    this.source = const Value.absent(),
    this.reference = const Value.absent(),
  });
  XpEventTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    required int amount,
    required String source,
    this.reference = const Value.absent(),
  }) : at = Value(at),
       amount = Value(amount),
       source = Value(source);
  static Insertable<XpEventRow> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<int>? amount,
    Expression<String>? source,
    Expression<String>? reference,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (amount != null) 'amount': amount,
      if (source != null) 'source': source,
      if (reference != null) 'reference': reference,
    });
  }

  XpEventTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<int>? amount,
    Value<String>? source,
    Value<String?>? reference,
  }) {
    return XpEventTableCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      reference: reference ?? this.reference,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('XpEventTableCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('amount: $amount, ')
          ..write('source: $source, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }
}

class $ActivityAttemptTableTable extends ActivityAttemptTable
    with TableInfo<$ActivityAttemptTableTable, ActivityAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityAttemptTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityKindMeta = const VerificationMeta(
    'activityKind',
  );
  @override
  late final GeneratedColumn<String> activityKind = GeneratedColumn<String>(
    'activity_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skillIdMeta = const VerificationMeta(
    'skillId',
  );
  @override
  late final GeneratedColumn<String> skillId = GeneratedColumn<String>(
    'skill_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conceptTagMeta = const VerificationMeta(
    'conceptTag',
  );
  @override
  late final GeneratedColumn<String> conceptTag = GeneratedColumn<String>(
    'concept_tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _contextMeta = const VerificationMeta(
    'context',
  );
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
    'context',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('lesson'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    at,
    lessonId,
    activityId,
    activityKind,
    skillId,
    conceptTag,
    difficulty,
    correct,
    context,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_attempt_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityAttemptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('activity_kind')) {
      context.handle(
        _activityKindMeta,
        activityKind.isAcceptableOrUnknown(
          data['activity_kind']!,
          _activityKindMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityKindMeta);
    }
    if (data.containsKey('skill_id')) {
      context.handle(
        _skillIdMeta,
        skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta),
      );
    } else if (isInserting) {
      context.missing(_skillIdMeta);
    }
    if (data.containsKey('concept_tag')) {
      context.handle(
        _conceptTagMeta,
        conceptTag.isAcceptableOrUnknown(data['concept_tag']!, _conceptTagMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptTagMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('context')) {
      context.handle(
        _contextMeta,
        this.context.isAcceptableOrUnknown(data['context']!, _contextMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityAttemptRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      activityKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_kind'],
      )!,
      skillId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skill_id'],
      )!,
      conceptTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concept_tag'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      )!,
      context: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context'],
      )!,
    );
  }

  @override
  $ActivityAttemptTableTable createAlias(String alias) {
    return $ActivityAttemptTableTable(attachedDatabase, alias);
  }
}

class ActivityAttemptRow extends DataClass
    implements Insertable<ActivityAttemptRow> {
  final int id;
  final DateTime at;
  final String lessonId;
  final String activityId;
  final String activityKind;
  final String skillId;
  final String conceptTag;
  final String difficulty;
  final bool correct;
  final String context;
  const ActivityAttemptRow({
    required this.id,
    required this.at,
    required this.lessonId,
    required this.activityId,
    required this.activityKind,
    required this.skillId,
    required this.conceptTag,
    required this.difficulty,
    required this.correct,
    required this.context,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['lesson_id'] = Variable<String>(lessonId);
    map['activity_id'] = Variable<String>(activityId);
    map['activity_kind'] = Variable<String>(activityKind);
    map['skill_id'] = Variable<String>(skillId);
    map['concept_tag'] = Variable<String>(conceptTag);
    map['difficulty'] = Variable<String>(difficulty);
    map['correct'] = Variable<bool>(correct);
    map['context'] = Variable<String>(context);
    return map;
  }

  ActivityAttemptTableCompanion toCompanion(bool nullToAbsent) {
    return ActivityAttemptTableCompanion(
      id: Value(id),
      at: Value(at),
      lessonId: Value(lessonId),
      activityId: Value(activityId),
      activityKind: Value(activityKind),
      skillId: Value(skillId),
      conceptTag: Value(conceptTag),
      difficulty: Value(difficulty),
      correct: Value(correct),
      context: Value(context),
    );
  }

  factory ActivityAttemptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityAttemptRow(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      activityId: serializer.fromJson<String>(json['activityId']),
      activityKind: serializer.fromJson<String>(json['activityKind']),
      skillId: serializer.fromJson<String>(json['skillId']),
      conceptTag: serializer.fromJson<String>(json['conceptTag']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      correct: serializer.fromJson<bool>(json['correct']),
      context: serializer.fromJson<String>(json['context']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'lessonId': serializer.toJson<String>(lessonId),
      'activityId': serializer.toJson<String>(activityId),
      'activityKind': serializer.toJson<String>(activityKind),
      'skillId': serializer.toJson<String>(skillId),
      'conceptTag': serializer.toJson<String>(conceptTag),
      'difficulty': serializer.toJson<String>(difficulty),
      'correct': serializer.toJson<bool>(correct),
      'context': serializer.toJson<String>(context),
    };
  }

  ActivityAttemptRow copyWith({
    int? id,
    DateTime? at,
    String? lessonId,
    String? activityId,
    String? activityKind,
    String? skillId,
    String? conceptTag,
    String? difficulty,
    bool? correct,
    String? context,
  }) => ActivityAttemptRow(
    id: id ?? this.id,
    at: at ?? this.at,
    lessonId: lessonId ?? this.lessonId,
    activityId: activityId ?? this.activityId,
    activityKind: activityKind ?? this.activityKind,
    skillId: skillId ?? this.skillId,
    conceptTag: conceptTag ?? this.conceptTag,
    difficulty: difficulty ?? this.difficulty,
    correct: correct ?? this.correct,
    context: context ?? this.context,
  );
  ActivityAttemptRow copyWithCompanion(ActivityAttemptTableCompanion data) {
    return ActivityAttemptRow(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      activityKind: data.activityKind.present
          ? data.activityKind.value
          : this.activityKind,
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      conceptTag: data.conceptTag.present
          ? data.conceptTag.value
          : this.conceptTag,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      correct: data.correct.present ? data.correct.value : this.correct,
      context: data.context.present ? data.context.value : this.context,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityAttemptRow(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('lessonId: $lessonId, ')
          ..write('activityId: $activityId, ')
          ..write('activityKind: $activityKind, ')
          ..write('skillId: $skillId, ')
          ..write('conceptTag: $conceptTag, ')
          ..write('difficulty: $difficulty, ')
          ..write('correct: $correct, ')
          ..write('context: $context')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    at,
    lessonId,
    activityId,
    activityKind,
    skillId,
    conceptTag,
    difficulty,
    correct,
    context,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityAttemptRow &&
          other.id == this.id &&
          other.at == this.at &&
          other.lessonId == this.lessonId &&
          other.activityId == this.activityId &&
          other.activityKind == this.activityKind &&
          other.skillId == this.skillId &&
          other.conceptTag == this.conceptTag &&
          other.difficulty == this.difficulty &&
          other.correct == this.correct &&
          other.context == this.context);
}

class ActivityAttemptTableCompanion
    extends UpdateCompanion<ActivityAttemptRow> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<String> lessonId;
  final Value<String> activityId;
  final Value<String> activityKind;
  final Value<String> skillId;
  final Value<String> conceptTag;
  final Value<String> difficulty;
  final Value<bool> correct;
  final Value<String> context;
  const ActivityAttemptTableCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.activityKind = const Value.absent(),
    this.skillId = const Value.absent(),
    this.conceptTag = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.correct = const Value.absent(),
    this.context = const Value.absent(),
  });
  ActivityAttemptTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    required String lessonId,
    required String activityId,
    required String activityKind,
    required String skillId,
    required String conceptTag,
    required String difficulty,
    required bool correct,
    this.context = const Value.absent(),
  }) : at = Value(at),
       lessonId = Value(lessonId),
       activityId = Value(activityId),
       activityKind = Value(activityKind),
       skillId = Value(skillId),
       conceptTag = Value(conceptTag),
       difficulty = Value(difficulty),
       correct = Value(correct);
  static Insertable<ActivityAttemptRow> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<String>? lessonId,
    Expression<String>? activityId,
    Expression<String>? activityKind,
    Expression<String>? skillId,
    Expression<String>? conceptTag,
    Expression<String>? difficulty,
    Expression<bool>? correct,
    Expression<String>? context,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (lessonId != null) 'lesson_id': lessonId,
      if (activityId != null) 'activity_id': activityId,
      if (activityKind != null) 'activity_kind': activityKind,
      if (skillId != null) 'skill_id': skillId,
      if (conceptTag != null) 'concept_tag': conceptTag,
      if (difficulty != null) 'difficulty': difficulty,
      if (correct != null) 'correct': correct,
      if (context != null) 'context': context,
    });
  }

  ActivityAttemptTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<String>? lessonId,
    Value<String>? activityId,
    Value<String>? activityKind,
    Value<String>? skillId,
    Value<String>? conceptTag,
    Value<String>? difficulty,
    Value<bool>? correct,
    Value<String>? context,
  }) {
    return ActivityAttemptTableCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      lessonId: lessonId ?? this.lessonId,
      activityId: activityId ?? this.activityId,
      activityKind: activityKind ?? this.activityKind,
      skillId: skillId ?? this.skillId,
      conceptTag: conceptTag ?? this.conceptTag,
      difficulty: difficulty ?? this.difficulty,
      correct: correct ?? this.correct,
      context: context ?? this.context,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (activityKind.present) {
      map['activity_kind'] = Variable<String>(activityKind.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<String>(skillId.value);
    }
    if (conceptTag.present) {
      map['concept_tag'] = Variable<String>(conceptTag.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityAttemptTableCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('lessonId: $lessonId, ')
          ..write('activityId: $activityId, ')
          ..write('activityKind: $activityKind, ')
          ..write('skillId: $skillId, ')
          ..write('conceptTag: $conceptTag, ')
          ..write('difficulty: $difficulty, ')
          ..write('correct: $correct, ')
          ..write('context: $context')
          ..write(')'))
        .toString();
  }
}

class $DailyChallengeTableTable extends DailyChallengeTable
    with TableInfo<$DailyChallengeTableTable, DailyChallengeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyChallengeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seedMeta = const VerificationMeta('seed');
  @override
  late final GeneratedColumn<int> seed = GeneratedColumn<int>(
    'seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedTaskCountMeta =
      const VerificationMeta('completedTaskCount');
  @override
  late final GeneratedColumn<int> completedTaskCount = GeneratedColumn<int>(
    'completed_task_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    dayKey,
    seed,
    completedTaskCount,
    completed,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_challenge_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyChallengeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('seed')) {
      context.handle(
        _seedMeta,
        seed.isAcceptableOrUnknown(data['seed']!, _seedMeta),
      );
    } else if (isInserting) {
      context.missing(_seedMeta);
    }
    if (data.containsKey('completed_task_count')) {
      context.handle(
        _completedTaskCountMeta,
        completedTaskCount.isAcceptableOrUnknown(
          data['completed_task_count']!,
          _completedTaskCountMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dayKey};
  @override
  DailyChallengeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyChallengeRow(
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      seed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seed'],
      )!,
      completedTaskCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_task_count'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $DailyChallengeTableTable createAlias(String alias) {
    return $DailyChallengeTableTable(attachedDatabase, alias);
  }
}

class DailyChallengeRow extends DataClass
    implements Insertable<DailyChallengeRow> {
  final String dayKey;
  final int seed;
  final int completedTaskCount;
  final bool completed;
  final DateTime? completedAt;
  const DailyChallengeRow({
    required this.dayKey,
    required this.seed,
    required this.completedTaskCount,
    required this.completed,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day_key'] = Variable<String>(dayKey);
    map['seed'] = Variable<int>(seed);
    map['completed_task_count'] = Variable<int>(completedTaskCount);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  DailyChallengeTableCompanion toCompanion(bool nullToAbsent) {
    return DailyChallengeTableCompanion(
      dayKey: Value(dayKey),
      seed: Value(seed),
      completedTaskCount: Value(completedTaskCount),
      completed: Value(completed),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory DailyChallengeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyChallengeRow(
      dayKey: serializer.fromJson<String>(json['dayKey']),
      seed: serializer.fromJson<int>(json['seed']),
      completedTaskCount: serializer.fromJson<int>(json['completedTaskCount']),
      completed: serializer.fromJson<bool>(json['completed']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dayKey': serializer.toJson<String>(dayKey),
      'seed': serializer.toJson<int>(seed),
      'completedTaskCount': serializer.toJson<int>(completedTaskCount),
      'completed': serializer.toJson<bool>(completed),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  DailyChallengeRow copyWith({
    String? dayKey,
    int? seed,
    int? completedTaskCount,
    bool? completed,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => DailyChallengeRow(
    dayKey: dayKey ?? this.dayKey,
    seed: seed ?? this.seed,
    completedTaskCount: completedTaskCount ?? this.completedTaskCount,
    completed: completed ?? this.completed,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  DailyChallengeRow copyWithCompanion(DailyChallengeTableCompanion data) {
    return DailyChallengeRow(
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      seed: data.seed.present ? data.seed.value : this.seed,
      completedTaskCount: data.completedTaskCount.present
          ? data.completedTaskCount.value
          : this.completedTaskCount,
      completed: data.completed.present ? data.completed.value : this.completed,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyChallengeRow(')
          ..write('dayKey: $dayKey, ')
          ..write('seed: $seed, ')
          ..write('completedTaskCount: $completedTaskCount, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(dayKey, seed, completedTaskCount, completed, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyChallengeRow &&
          other.dayKey == this.dayKey &&
          other.seed == this.seed &&
          other.completedTaskCount == this.completedTaskCount &&
          other.completed == this.completed &&
          other.completedAt == this.completedAt);
}

class DailyChallengeTableCompanion extends UpdateCompanion<DailyChallengeRow> {
  final Value<String> dayKey;
  final Value<int> seed;
  final Value<int> completedTaskCount;
  final Value<bool> completed;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const DailyChallengeTableCompanion({
    this.dayKey = const Value.absent(),
    this.seed = const Value.absent(),
    this.completedTaskCount = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyChallengeTableCompanion.insert({
    required String dayKey,
    required int seed,
    this.completedTaskCount = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dayKey = Value(dayKey),
       seed = Value(seed);
  static Insertable<DailyChallengeRow> custom({
    Expression<String>? dayKey,
    Expression<int>? seed,
    Expression<int>? completedTaskCount,
    Expression<bool>? completed,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dayKey != null) 'day_key': dayKey,
      if (seed != null) 'seed': seed,
      if (completedTaskCount != null)
        'completed_task_count': completedTaskCount,
      if (completed != null) 'completed': completed,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyChallengeTableCompanion copyWith({
    Value<String>? dayKey,
    Value<int>? seed,
    Value<int>? completedTaskCount,
    Value<bool>? completed,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return DailyChallengeTableCompanion(
      dayKey: dayKey ?? this.dayKey,
      seed: seed ?? this.seed,
      completedTaskCount: completedTaskCount ?? this.completedTaskCount,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (seed.present) {
      map['seed'] = Variable<int>(seed.value);
    }
    if (completedTaskCount.present) {
      map['completed_task_count'] = Variable<int>(completedTaskCount.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyChallengeTableCompanion(')
          ..write('dayKey: $dayKey, ')
          ..write('seed: $seed, ')
          ..write('completedTaskCount: $completedTaskCount, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeeklyChallengeTableTable extends WeeklyChallengeTable
    with TableInfo<$WeeklyChallengeTableTable, WeeklyChallengeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyChallengeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _weekKeyMeta = const VerificationMeta(
    'weekKey',
  );
  @override
  late final GeneratedColumn<String> weekKey = GeneratedColumn<String>(
    'week_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metricMeta = const VerificationMeta('metric');
  @override
  late final GeneratedColumn<String> metric = GeneratedColumn<String>(
    'metric',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    weekKey,
    metric,
    target,
    progress,
    completed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_challenge_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyChallengeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('week_key')) {
      context.handle(
        _weekKeyMeta,
        weekKey.isAcceptableOrUnknown(data['week_key']!, _weekKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_weekKeyMeta);
    }
    if (data.containsKey('metric')) {
      context.handle(
        _metricMeta,
        metric.isAcceptableOrUnknown(data['metric']!, _metricMeta),
      );
    } else if (isInserting) {
      context.missing(_metricMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {weekKey};
  @override
  WeeklyChallengeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyChallengeRow(
      weekKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}week_key'],
      )!,
      metric: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $WeeklyChallengeTableTable createAlias(String alias) {
    return $WeeklyChallengeTableTable(attachedDatabase, alias);
  }
}

class WeeklyChallengeRow extends DataClass
    implements Insertable<WeeklyChallengeRow> {
  final String weekKey;
  final String metric;
  final int target;
  final int progress;
  final bool completed;
  const WeeklyChallengeRow({
    required this.weekKey,
    required this.metric,
    required this.target,
    required this.progress,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['week_key'] = Variable<String>(weekKey);
    map['metric'] = Variable<String>(metric);
    map['target'] = Variable<int>(target);
    map['progress'] = Variable<int>(progress);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  WeeklyChallengeTableCompanion toCompanion(bool nullToAbsent) {
    return WeeklyChallengeTableCompanion(
      weekKey: Value(weekKey),
      metric: Value(metric),
      target: Value(target),
      progress: Value(progress),
      completed: Value(completed),
    );
  }

  factory WeeklyChallengeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyChallengeRow(
      weekKey: serializer.fromJson<String>(json['weekKey']),
      metric: serializer.fromJson<String>(json['metric']),
      target: serializer.fromJson<int>(json['target']),
      progress: serializer.fromJson<int>(json['progress']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'weekKey': serializer.toJson<String>(weekKey),
      'metric': serializer.toJson<String>(metric),
      'target': serializer.toJson<int>(target),
      'progress': serializer.toJson<int>(progress),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  WeeklyChallengeRow copyWith({
    String? weekKey,
    String? metric,
    int? target,
    int? progress,
    bool? completed,
  }) => WeeklyChallengeRow(
    weekKey: weekKey ?? this.weekKey,
    metric: metric ?? this.metric,
    target: target ?? this.target,
    progress: progress ?? this.progress,
    completed: completed ?? this.completed,
  );
  WeeklyChallengeRow copyWithCompanion(WeeklyChallengeTableCompanion data) {
    return WeeklyChallengeRow(
      weekKey: data.weekKey.present ? data.weekKey.value : this.weekKey,
      metric: data.metric.present ? data.metric.value : this.metric,
      target: data.target.present ? data.target.value : this.target,
      progress: data.progress.present ? data.progress.value : this.progress,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyChallengeRow(')
          ..write('weekKey: $weekKey, ')
          ..write('metric: $metric, ')
          ..write('target: $target, ')
          ..write('progress: $progress, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(weekKey, metric, target, progress, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyChallengeRow &&
          other.weekKey == this.weekKey &&
          other.metric == this.metric &&
          other.target == this.target &&
          other.progress == this.progress &&
          other.completed == this.completed);
}

class WeeklyChallengeTableCompanion
    extends UpdateCompanion<WeeklyChallengeRow> {
  final Value<String> weekKey;
  final Value<String> metric;
  final Value<int> target;
  final Value<int> progress;
  final Value<bool> completed;
  final Value<int> rowid;
  const WeeklyChallengeTableCompanion({
    this.weekKey = const Value.absent(),
    this.metric = const Value.absent(),
    this.target = const Value.absent(),
    this.progress = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyChallengeTableCompanion.insert({
    required String weekKey,
    required String metric,
    required int target,
    this.progress = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : weekKey = Value(weekKey),
       metric = Value(metric),
       target = Value(target);
  static Insertable<WeeklyChallengeRow> custom({
    Expression<String>? weekKey,
    Expression<String>? metric,
    Expression<int>? target,
    Expression<int>? progress,
    Expression<bool>? completed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (weekKey != null) 'week_key': weekKey,
      if (metric != null) 'metric': metric,
      if (target != null) 'target': target,
      if (progress != null) 'progress': progress,
      if (completed != null) 'completed': completed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyChallengeTableCompanion copyWith({
    Value<String>? weekKey,
    Value<String>? metric,
    Value<int>? target,
    Value<int>? progress,
    Value<bool>? completed,
    Value<int>? rowid,
  }) {
    return WeeklyChallengeTableCompanion(
      weekKey: weekKey ?? this.weekKey,
      metric: metric ?? this.metric,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      completed: completed ?? this.completed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (weekKey.present) {
      map['week_key'] = Variable<String>(weekKey.value);
    }
    if (metric.present) {
      map['metric'] = Variable<String>(metric.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyChallengeTableCompanion(')
          ..write('weekKey: $weekKey, ')
          ..write('metric: $metric, ')
          ..write('target: $target, ')
          ..write('progress: $progress, ')
          ..write('completed: $completed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeagueStateTableTable extends LeagueStateTable
    with TableInfo<$LeagueStateTableTable, LeagueStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeagueStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
    'tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bronze'),
  );
  static const VerificationMeta _weekKeyMeta = const VerificationMeta(
    'weekKey',
  );
  @override
  late final GeneratedColumn<String> weekKey = GeneratedColumn<String>(
    'week_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _weeklyXpMeta = const VerificationMeta(
    'weeklyXp',
  );
  @override
  late final GeneratedColumn<int> weeklyXp = GeneratedColumn<int>(
    'weekly_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, tier, weekKey, weeklyXp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'league_state_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeagueStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tier')) {
      context.handle(
        _tierMeta,
        tier.isAcceptableOrUnknown(data['tier']!, _tierMeta),
      );
    }
    if (data.containsKey('week_key')) {
      context.handle(
        _weekKeyMeta,
        weekKey.isAcceptableOrUnknown(data['week_key']!, _weekKeyMeta),
      );
    }
    if (data.containsKey('weekly_xp')) {
      context.handle(
        _weeklyXpMeta,
        weeklyXp.isAcceptableOrUnknown(data['weekly_xp']!, _weeklyXpMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeagueStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeagueStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tier'],
      )!,
      weekKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}week_key'],
      )!,
      weeklyXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_xp'],
      )!,
    );
  }

  @override
  $LeagueStateTableTable createAlias(String alias) {
    return $LeagueStateTableTable(attachedDatabase, alias);
  }
}

class LeagueStateRow extends DataClass implements Insertable<LeagueStateRow> {
  final int id;
  final String tier;
  final String weekKey;
  final int weeklyXp;
  const LeagueStateRow({
    required this.id,
    required this.tier,
    required this.weekKey,
    required this.weeklyXp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tier'] = Variable<String>(tier);
    map['week_key'] = Variable<String>(weekKey);
    map['weekly_xp'] = Variable<int>(weeklyXp);
    return map;
  }

  LeagueStateTableCompanion toCompanion(bool nullToAbsent) {
    return LeagueStateTableCompanion(
      id: Value(id),
      tier: Value(tier),
      weekKey: Value(weekKey),
      weeklyXp: Value(weeklyXp),
    );
  }

  factory LeagueStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeagueStateRow(
      id: serializer.fromJson<int>(json['id']),
      tier: serializer.fromJson<String>(json['tier']),
      weekKey: serializer.fromJson<String>(json['weekKey']),
      weeklyXp: serializer.fromJson<int>(json['weeklyXp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tier': serializer.toJson<String>(tier),
      'weekKey': serializer.toJson<String>(weekKey),
      'weeklyXp': serializer.toJson<int>(weeklyXp),
    };
  }

  LeagueStateRow copyWith({
    int? id,
    String? tier,
    String? weekKey,
    int? weeklyXp,
  }) => LeagueStateRow(
    id: id ?? this.id,
    tier: tier ?? this.tier,
    weekKey: weekKey ?? this.weekKey,
    weeklyXp: weeklyXp ?? this.weeklyXp,
  );
  LeagueStateRow copyWithCompanion(LeagueStateTableCompanion data) {
    return LeagueStateRow(
      id: data.id.present ? data.id.value : this.id,
      tier: data.tier.present ? data.tier.value : this.tier,
      weekKey: data.weekKey.present ? data.weekKey.value : this.weekKey,
      weeklyXp: data.weeklyXp.present ? data.weeklyXp.value : this.weeklyXp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeagueStateRow(')
          ..write('id: $id, ')
          ..write('tier: $tier, ')
          ..write('weekKey: $weekKey, ')
          ..write('weeklyXp: $weeklyXp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tier, weekKey, weeklyXp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeagueStateRow &&
          other.id == this.id &&
          other.tier == this.tier &&
          other.weekKey == this.weekKey &&
          other.weeklyXp == this.weeklyXp);
}

class LeagueStateTableCompanion extends UpdateCompanion<LeagueStateRow> {
  final Value<int> id;
  final Value<String> tier;
  final Value<String> weekKey;
  final Value<int> weeklyXp;
  const LeagueStateTableCompanion({
    this.id = const Value.absent(),
    this.tier = const Value.absent(),
    this.weekKey = const Value.absent(),
    this.weeklyXp = const Value.absent(),
  });
  LeagueStateTableCompanion.insert({
    this.id = const Value.absent(),
    this.tier = const Value.absent(),
    this.weekKey = const Value.absent(),
    this.weeklyXp = const Value.absent(),
  });
  static Insertable<LeagueStateRow> custom({
    Expression<int>? id,
    Expression<String>? tier,
    Expression<String>? weekKey,
    Expression<int>? weeklyXp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tier != null) 'tier': tier,
      if (weekKey != null) 'week_key': weekKey,
      if (weeklyXp != null) 'weekly_xp': weeklyXp,
    });
  }

  LeagueStateTableCompanion copyWith({
    Value<int>? id,
    Value<String>? tier,
    Value<String>? weekKey,
    Value<int>? weeklyXp,
  }) {
    return LeagueStateTableCompanion(
      id: id ?? this.id,
      tier: tier ?? this.tier,
      weekKey: weekKey ?? this.weekKey,
      weeklyXp: weeklyXp ?? this.weeklyXp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (weekKey.present) {
      map['week_key'] = Variable<String>(weekKey.value);
    }
    if (weeklyXp.present) {
      map['weekly_xp'] = Variable<int>(weeklyXp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeagueStateTableCompanion(')
          ..write('id: $id, ')
          ..write('tier: $tier, ')
          ..write('weekKey: $weekKey, ')
          ..write('weeklyXp: $weeklyXp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfileTableTable profileTable = $ProfileTableTable(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $LessonProgressTableTable lessonProgressTable =
      $LessonProgressTableTable(this);
  late final $SkillMasteryTableTable skillMasteryTable =
      $SkillMasteryTableTable(this);
  late final $ReviewItemTableTable reviewItemTable = $ReviewItemTableTable(
    this,
  );
  late final $StreakTableTable streakTable = $StreakTableTable(this);
  late final $UnlockedAchievementTableTable unlockedAchievementTable =
      $UnlockedAchievementTableTable(this);
  late final $JournalEntryTableTable journalEntryTable =
      $JournalEntryTableTable(this);
  late final $SimulatorAccountTableTable simulatorAccountTable =
      $SimulatorAccountTableTable(this);
  late final $EquityPointTableTable equityPointTable = $EquityPointTableTable(
    this,
  );
  late final $XpEventTableTable xpEventTable = $XpEventTableTable(this);
  late final $ActivityAttemptTableTable activityAttemptTable =
      $ActivityAttemptTableTable(this);
  late final $DailyChallengeTableTable dailyChallengeTable =
      $DailyChallengeTableTable(this);
  late final $WeeklyChallengeTableTable weeklyChallengeTable =
      $WeeklyChallengeTableTable(this);
  late final $LeagueStateTableTable leagueStateTable = $LeagueStateTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profileTable,
    settingsTable,
    lessonProgressTable,
    skillMasteryTable,
    reviewItemTable,
    streakTable,
    unlockedAchievementTable,
    journalEntryTable,
    simulatorAccountTable,
    equityPointTable,
    xpEventTable,
    activityAttemptTable,
    dailyChallengeTable,
    weeklyChallengeTable,
    leagueStateTable,
  ];
}

typedef $$ProfileTableTableCreateCompanionBuilder =
    ProfileTableCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> avatarId,
      Value<String> experienceLevel,
      Value<int> dailyGoalMinutes,
      Value<int> totalXp,
      Value<int> hearts,
      Value<DateTime?> heartsUpdatedAt,
      Value<bool> onboardingComplete,
      Value<DateTime?> createdAt,
    });
typedef $$ProfileTableTableUpdateCompanionBuilder =
    ProfileTableCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> avatarId,
      Value<String> experienceLevel,
      Value<int> dailyGoalMinutes,
      Value<int> totalXp,
      Value<int> hearts,
      Value<DateTime?> heartsUpdatedAt,
      Value<bool> onboardingComplete,
      Value<DateTime?> createdAt,
    });

class $$ProfileTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileTableTable> {
  $$ProfileTableTableFilterComposer({
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

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get experienceLevel => $composableBuilder(
    column: $table.experienceLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hearts => $composableBuilder(
    column: $table.hearts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get heartsUpdatedAt => $composableBuilder(
    column: $table.heartsUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfileTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileTableTable> {
  $$ProfileTableTableOrderingComposer({
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

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get experienceLevel => $composableBuilder(
    column: $table.experienceLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hearts => $composableBuilder(
    column: $table.hearts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get heartsUpdatedAt => $composableBuilder(
    column: $table.heartsUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfileTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileTableTable> {
  $$ProfileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get avatarId =>
      $composableBuilder(column: $table.avatarId, builder: (column) => column);

  GeneratedColumn<String> get experienceLevel => $composableBuilder(
    column: $table.experienceLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalXp =>
      $composableBuilder(column: $table.totalXp, builder: (column) => column);

  GeneratedColumn<int> get hearts =>
      $composableBuilder(column: $table.hearts, builder: (column) => column);

  GeneratedColumn<DateTime> get heartsUpdatedAt => $composableBuilder(
    column: $table.heartsUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfileTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileTableTable,
          ProfileRow,
          $$ProfileTableTableFilterComposer,
          $$ProfileTableTableOrderingComposer,
          $$ProfileTableTableAnnotationComposer,
          $$ProfileTableTableCreateCompanionBuilder,
          $$ProfileTableTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfileTableTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfileTableTableTableManager(_$AppDatabase db, $ProfileTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> avatarId = const Value.absent(),
                Value<String> experienceLevel = const Value.absent(),
                Value<int> dailyGoalMinutes = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
                Value<int> hearts = const Value.absent(),
                Value<DateTime?> heartsUpdatedAt = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => ProfileTableCompanion(
                id: id,
                username: username,
                avatarId: avatarId,
                experienceLevel: experienceLevel,
                dailyGoalMinutes: dailyGoalMinutes,
                totalXp: totalXp,
                hearts: hearts,
                heartsUpdatedAt: heartsUpdatedAt,
                onboardingComplete: onboardingComplete,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> avatarId = const Value.absent(),
                Value<String> experienceLevel = const Value.absent(),
                Value<int> dailyGoalMinutes = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
                Value<int> hearts = const Value.absent(),
                Value<DateTime?> heartsUpdatedAt = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => ProfileTableCompanion.insert(
                id: id,
                username: username,
                avatarId: avatarId,
                experienceLevel: experienceLevel,
                dailyGoalMinutes: dailyGoalMinutes,
                totalXp: totalXp,
                hearts: hearts,
                heartsUpdatedAt: heartsUpdatedAt,
                onboardingComplete: onboardingComplete,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfileTableTable, ProfileRow>(table),
                  BaseReferences<_$AppDatabase, $ProfileTableTable, ProfileRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfileTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileTableTable,
      ProfileRow,
      $$ProfileTableTableFilterComposer,
      $$ProfileTableTableOrderingComposer,
      $$ProfileTableTableAnnotationComposer,
      $$ProfileTableTableCreateCompanionBuilder,
      $$ProfileTableTableUpdateCompanionBuilder,
      (
        ProfileRow,
        BaseReferences<_$AppDatabase, $ProfileTableTable, ProfileRow>,
      ),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<String> theme,
      Value<bool> soundEnabled,
      Value<bool> hapticsEnabled,
      Value<int> dailyGoalMinutes,
      Value<bool> reduceMotion,
      Value<bool> showVolume,
      Value<double> defaultRiskPercent,
      Value<double> simulatorStartingBalance,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<String> theme,
      Value<bool> soundEnabled,
      Value<bool> hapticsEnabled,
      Value<int> dailyGoalMinutes,
      Value<bool> reduceMotion,
      Value<bool> showVolume,
      Value<double> defaultRiskPercent,
      Value<double> simulatorStartingBalance,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
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

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showVolume => $composableBuilder(
    column: $table.showVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultRiskPercent => $composableBuilder(
    column: $table.defaultRiskPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get simulatorStartingBalance => $composableBuilder(
    column: $table.simulatorStartingBalance,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showVolume => $composableBuilder(
    column: $table.showVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultRiskPercent => $composableBuilder(
    column: $table.defaultRiskPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get simulatorStartingBalance => $composableBuilder(
    column: $table.simulatorStartingBalance,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showVolume => $composableBuilder(
    column: $table.showVolume,
    builder: (column) => column,
  );

  GeneratedColumn<double> get defaultRiskPercent => $composableBuilder(
    column: $table.defaultRiskPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get simulatorStartingBalance => $composableBuilder(
    column: $table.simulatorStartingBalance,
    builder: (column) => column,
  );
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingsRow,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
                Value<int> dailyGoalMinutes = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<bool> showVolume = const Value.absent(),
                Value<double> defaultRiskPercent = const Value.absent(),
                Value<double> simulatorStartingBalance = const Value.absent(),
              }) => SettingsTableCompanion(
                id: id,
                theme: theme,
                soundEnabled: soundEnabled,
                hapticsEnabled: hapticsEnabled,
                dailyGoalMinutes: dailyGoalMinutes,
                reduceMotion: reduceMotion,
                showVolume: showVolume,
                defaultRiskPercent: defaultRiskPercent,
                simulatorStartingBalance: simulatorStartingBalance,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
                Value<int> dailyGoalMinutes = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<bool> showVolume = const Value.absent(),
                Value<double> defaultRiskPercent = const Value.absent(),
                Value<double> simulatorStartingBalance = const Value.absent(),
              }) => SettingsTableCompanion.insert(
                id: id,
                theme: theme,
                soundEnabled: soundEnabled,
                hapticsEnabled: hapticsEnabled,
                dailyGoalMinutes: dailyGoalMinutes,
                reduceMotion: reduceMotion,
                showVolume: showVolume,
                defaultRiskPercent: defaultRiskPercent,
                simulatorStartingBalance: simulatorStartingBalance,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTableTable, SettingsRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SettingsTableTable,
                    SettingsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingsRow,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (
        SettingsRow,
        BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsRow>,
      ),
      SettingsRow,
      PrefetchHooks Function()
    >;
typedef $$LessonProgressTableTableCreateCompanionBuilder =
    LessonProgressTableCompanion Function({
      required String lessonId,
      Value<int> completions,
      Value<double> bestAccuracy,
      Value<double> lastAccuracy,
      Value<bool> perfect,
      Value<DateTime?> lastCompletedAt,
      Value<int> rowid,
    });
typedef $$LessonProgressTableTableUpdateCompanionBuilder =
    LessonProgressTableCompanion Function({
      Value<String> lessonId,
      Value<int> completions,
      Value<double> bestAccuracy,
      Value<double> lastAccuracy,
      Value<bool> perfect,
      Value<DateTime?> lastCompletedAt,
      Value<int> rowid,
    });

class $$LessonProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $LessonProgressTableTable> {
  $$LessonProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completions => $composableBuilder(
    column: $table.completions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bestAccuracy => $composableBuilder(
    column: $table.bestAccuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastAccuracy => $composableBuilder(
    column: $table.lastAccuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get perfect => $composableBuilder(
    column: $table.perfect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCompletedAt => $composableBuilder(
    column: $table.lastCompletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LessonProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonProgressTableTable> {
  $$LessonProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completions => $composableBuilder(
    column: $table.completions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bestAccuracy => $composableBuilder(
    column: $table.bestAccuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastAccuracy => $composableBuilder(
    column: $table.lastAccuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get perfect => $composableBuilder(
    column: $table.perfect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCompletedAt => $composableBuilder(
    column: $table.lastCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonProgressTableTable> {
  $$LessonProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<int> get completions => $composableBuilder(
    column: $table.completions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bestAccuracy => $composableBuilder(
    column: $table.bestAccuracy,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastAccuracy => $composableBuilder(
    column: $table.lastAccuracy,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get perfect =>
      $composableBuilder(column: $table.perfect, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCompletedAt => $composableBuilder(
    column: $table.lastCompletedAt,
    builder: (column) => column,
  );
}

class $$LessonProgressTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonProgressTableTable,
          LessonProgressRow,
          $$LessonProgressTableTableFilterComposer,
          $$LessonProgressTableTableOrderingComposer,
          $$LessonProgressTableTableAnnotationComposer,
          $$LessonProgressTableTableCreateCompanionBuilder,
          $$LessonProgressTableTableUpdateCompanionBuilder,
          (
            LessonProgressRow,
            BaseReferences<
              _$AppDatabase,
              $LessonProgressTableTable,
              LessonProgressRow
            >,
          ),
          LessonProgressRow,
          PrefetchHooks Function()
        > {
  $$LessonProgressTableTableTableManager(
    _$AppDatabase db,
    $LessonProgressTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonProgressTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LessonProgressTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> lessonId = const Value.absent(),
                Value<int> completions = const Value.absent(),
                Value<double> bestAccuracy = const Value.absent(),
                Value<double> lastAccuracy = const Value.absent(),
                Value<bool> perfect = const Value.absent(),
                Value<DateTime?> lastCompletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonProgressTableCompanion(
                lessonId: lessonId,
                completions: completions,
                bestAccuracy: bestAccuracy,
                lastAccuracy: lastAccuracy,
                perfect: perfect,
                lastCompletedAt: lastCompletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String lessonId,
                Value<int> completions = const Value.absent(),
                Value<double> bestAccuracy = const Value.absent(),
                Value<double> lastAccuracy = const Value.absent(),
                Value<bool> perfect = const Value.absent(),
                Value<DateTime?> lastCompletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonProgressTableCompanion.insert(
                lessonId: lessonId,
                completions: completions,
                bestAccuracy: bestAccuracy,
                lastAccuracy: lastAccuracy,
                perfect: perfect,
                lastCompletedAt: lastCompletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LessonProgressTableTable, LessonProgressRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $LessonProgressTableTable,
                    LessonProgressRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LessonProgressTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonProgressTableTable,
      LessonProgressRow,
      $$LessonProgressTableTableFilterComposer,
      $$LessonProgressTableTableOrderingComposer,
      $$LessonProgressTableTableAnnotationComposer,
      $$LessonProgressTableTableCreateCompanionBuilder,
      $$LessonProgressTableTableUpdateCompanionBuilder,
      (
        LessonProgressRow,
        BaseReferences<
          _$AppDatabase,
          $LessonProgressTableTable,
          LessonProgressRow
        >,
      ),
      LessonProgressRow,
      PrefetchHooks Function()
    >;
typedef $$SkillMasteryTableTableCreateCompanionBuilder =
    SkillMasteryTableCompanion Function({
      required String skillId,
      Value<double> score,
      Value<int> attempts,
      Value<int> correct,
      Value<DateTime?> lastPracticed,
      Value<int> rowid,
    });
typedef $$SkillMasteryTableTableUpdateCompanionBuilder =
    SkillMasteryTableCompanion Function({
      Value<String> skillId,
      Value<double> score,
      Value<int> attempts,
      Value<int> correct,
      Value<DateTime?> lastPracticed,
      Value<int> rowid,
    });

class $$SkillMasteryTableTableFilterComposer
    extends Composer<_$AppDatabase, $SkillMasteryTableTable> {
  $$SkillMasteryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get skillId => $composableBuilder(
    column: $table.skillId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPracticed => $composableBuilder(
    column: $table.lastPracticed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SkillMasteryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SkillMasteryTableTable> {
  $$SkillMasteryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get skillId => $composableBuilder(
    column: $table.skillId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPracticed => $composableBuilder(
    column: $table.lastPracticed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SkillMasteryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SkillMasteryTableTable> {
  $$SkillMasteryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get skillId =>
      $composableBuilder(column: $table.skillId, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPracticed => $composableBuilder(
    column: $table.lastPracticed,
    builder: (column) => column,
  );
}

class $$SkillMasteryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SkillMasteryTableTable,
          SkillMasteryRow,
          $$SkillMasteryTableTableFilterComposer,
          $$SkillMasteryTableTableOrderingComposer,
          $$SkillMasteryTableTableAnnotationComposer,
          $$SkillMasteryTableTableCreateCompanionBuilder,
          $$SkillMasteryTableTableUpdateCompanionBuilder,
          (
            SkillMasteryRow,
            BaseReferences<
              _$AppDatabase,
              $SkillMasteryTableTable,
              SkillMasteryRow
            >,
          ),
          SkillMasteryRow,
          PrefetchHooks Function()
        > {
  $$SkillMasteryTableTableTableManager(
    _$AppDatabase db,
    $SkillMasteryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkillMasteryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkillMasteryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkillMasteryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> skillId = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<DateTime?> lastPracticed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SkillMasteryTableCompanion(
                skillId: skillId,
                score: score,
                attempts: attempts,
                correct: correct,
                lastPracticed: lastPracticed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String skillId,
                Value<double> score = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<DateTime?> lastPracticed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SkillMasteryTableCompanion.insert(
                skillId: skillId,
                score: score,
                attempts: attempts,
                correct: correct,
                lastPracticed: lastPracticed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SkillMasteryTableTable, SkillMasteryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SkillMasteryTableTable,
                    SkillMasteryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SkillMasteryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SkillMasteryTableTable,
      SkillMasteryRow,
      $$SkillMasteryTableTableFilterComposer,
      $$SkillMasteryTableTableOrderingComposer,
      $$SkillMasteryTableTableAnnotationComposer,
      $$SkillMasteryTableTableCreateCompanionBuilder,
      $$SkillMasteryTableTableUpdateCompanionBuilder,
      (
        SkillMasteryRow,
        BaseReferences<_$AppDatabase, $SkillMasteryTableTable, SkillMasteryRow>,
      ),
      SkillMasteryRow,
      PrefetchHooks Function()
    >;
typedef $$ReviewItemTableTableCreateCompanionBuilder =
    ReviewItemTableCompanion Function({
      required String conceptTag,
      required String skillId,
      required DateTime dueAt,
      Value<int> intervalDays,
      Value<double> ease,
      Value<int> repetitions,
      Value<int> lapses,
      Value<DateTime?> lastReviewed,
      Value<String> lastDifficulty,
      Value<int> totalAttempts,
      Value<int> totalCorrect,
      Value<int> rowid,
    });
typedef $$ReviewItemTableTableUpdateCompanionBuilder =
    ReviewItemTableCompanion Function({
      Value<String> conceptTag,
      Value<String> skillId,
      Value<DateTime> dueAt,
      Value<int> intervalDays,
      Value<double> ease,
      Value<int> repetitions,
      Value<int> lapses,
      Value<DateTime?> lastReviewed,
      Value<String> lastDifficulty,
      Value<int> totalAttempts,
      Value<int> totalCorrect,
      Value<int> rowid,
    });

class $$ReviewItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewItemTableTable> {
  $$ReviewItemTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get conceptTag => $composableBuilder(
    column: $table.conceptTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skillId => $composableBuilder(
    column: $table.skillId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastDifficulty => $composableBuilder(
    column: $table.lastDifficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAttempts => $composableBuilder(
    column: $table.totalAttempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewItemTableTable> {
  $$ReviewItemTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get conceptTag => $composableBuilder(
    column: $table.conceptTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skillId => $composableBuilder(
    column: $table.skillId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastDifficulty => $composableBuilder(
    column: $table.lastDifficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAttempts => $composableBuilder(
    column: $table.totalAttempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewItemTableTable> {
  $$ReviewItemTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get conceptTag => $composableBuilder(
    column: $table.conceptTag,
    builder: (column) => column,
  );

  GeneratedColumn<String> get skillId =>
      $composableBuilder(column: $table.skillId, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ease =>
      $composableBuilder(column: $table.ease, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewed => $composableBuilder(
    column: $table.lastReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastDifficulty => $composableBuilder(
    column: $table.lastDifficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAttempts => $composableBuilder(
    column: $table.totalAttempts,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => column,
  );
}

class $$ReviewItemTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewItemTableTable,
          ReviewItemRow,
          $$ReviewItemTableTableFilterComposer,
          $$ReviewItemTableTableOrderingComposer,
          $$ReviewItemTableTableAnnotationComposer,
          $$ReviewItemTableTableCreateCompanionBuilder,
          $$ReviewItemTableTableUpdateCompanionBuilder,
          (
            ReviewItemRow,
            BaseReferences<_$AppDatabase, $ReviewItemTableTable, ReviewItemRow>,
          ),
          ReviewItemRow,
          PrefetchHooks Function()
        > {
  $$ReviewItemTableTableTableManager(
    _$AppDatabase db,
    $ReviewItemTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewItemTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewItemTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewItemTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> conceptTag = const Value.absent(),
                Value<String> skillId = const Value.absent(),
                Value<DateTime> dueAt = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<double> ease = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<DateTime?> lastReviewed = const Value.absent(),
                Value<String> lastDifficulty = const Value.absent(),
                Value<int> totalAttempts = const Value.absent(),
                Value<int> totalCorrect = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewItemTableCompanion(
                conceptTag: conceptTag,
                skillId: skillId,
                dueAt: dueAt,
                intervalDays: intervalDays,
                ease: ease,
                repetitions: repetitions,
                lapses: lapses,
                lastReviewed: lastReviewed,
                lastDifficulty: lastDifficulty,
                totalAttempts: totalAttempts,
                totalCorrect: totalCorrect,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String conceptTag,
                required String skillId,
                required DateTime dueAt,
                Value<int> intervalDays = const Value.absent(),
                Value<double> ease = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<DateTime?> lastReviewed = const Value.absent(),
                Value<String> lastDifficulty = const Value.absent(),
                Value<int> totalAttempts = const Value.absent(),
                Value<int> totalCorrect = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewItemTableCompanion.insert(
                conceptTag: conceptTag,
                skillId: skillId,
                dueAt: dueAt,
                intervalDays: intervalDays,
                ease: ease,
                repetitions: repetitions,
                lapses: lapses,
                lastReviewed: lastReviewed,
                lastDifficulty: lastDifficulty,
                totalAttempts: totalAttempts,
                totalCorrect: totalCorrect,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewItemTableTable, ReviewItemRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ReviewItemTableTable,
                    ReviewItemRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewItemTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewItemTableTable,
      ReviewItemRow,
      $$ReviewItemTableTableFilterComposer,
      $$ReviewItemTableTableOrderingComposer,
      $$ReviewItemTableTableAnnotationComposer,
      $$ReviewItemTableTableCreateCompanionBuilder,
      $$ReviewItemTableTableUpdateCompanionBuilder,
      (
        ReviewItemRow,
        BaseReferences<_$AppDatabase, $ReviewItemTableTable, ReviewItemRow>,
      ),
      ReviewItemRow,
      PrefetchHooks Function()
    >;
typedef $$StreakTableTableCreateCompanionBuilder =
    StreakTableCompanion Function({
      Value<int> id,
      Value<int> current,
      Value<int> longest,
      Value<DateTime?> lastActiveDay,
      Value<int> totalActiveDays,
    });
typedef $$StreakTableTableUpdateCompanionBuilder =
    StreakTableCompanion Function({
      Value<int> id,
      Value<int> current,
      Value<int> longest,
      Value<DateTime?> lastActiveDay,
      Value<int> totalActiveDays,
    });

class $$StreakTableTableFilterComposer
    extends Composer<_$AppDatabase, $StreakTableTable> {
  $$StreakTableTableFilterComposer({
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

  ColumnFilters<int> get current => $composableBuilder(
    column: $table.current,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longest => $composableBuilder(
    column: $table.longest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastActiveDay => $composableBuilder(
    column: $table.lastActiveDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalActiveDays => $composableBuilder(
    column: $table.totalActiveDays,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreakTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StreakTableTable> {
  $$StreakTableTableOrderingComposer({
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

  ColumnOrderings<int> get current => $composableBuilder(
    column: $table.current,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longest => $composableBuilder(
    column: $table.longest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastActiveDay => $composableBuilder(
    column: $table.lastActiveDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalActiveDays => $composableBuilder(
    column: $table.totalActiveDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreakTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreakTableTable> {
  $$StreakTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get current =>
      $composableBuilder(column: $table.current, builder: (column) => column);

  GeneratedColumn<int> get longest =>
      $composableBuilder(column: $table.longest, builder: (column) => column);

  GeneratedColumn<DateTime> get lastActiveDay => $composableBuilder(
    column: $table.lastActiveDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalActiveDays => $composableBuilder(
    column: $table.totalActiveDays,
    builder: (column) => column,
  );
}

class $$StreakTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreakTableTable,
          StreakRow,
          $$StreakTableTableFilterComposer,
          $$StreakTableTableOrderingComposer,
          $$StreakTableTableAnnotationComposer,
          $$StreakTableTableCreateCompanionBuilder,
          $$StreakTableTableUpdateCompanionBuilder,
          (
            StreakRow,
            BaseReferences<_$AppDatabase, $StreakTableTable, StreakRow>,
          ),
          StreakRow,
          PrefetchHooks Function()
        > {
  $$StreakTableTableTableManager(_$AppDatabase db, $StreakTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreakTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreakTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreakTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> current = const Value.absent(),
                Value<int> longest = const Value.absent(),
                Value<DateTime?> lastActiveDay = const Value.absent(),
                Value<int> totalActiveDays = const Value.absent(),
              }) => StreakTableCompanion(
                id: id,
                current: current,
                longest: longest,
                lastActiveDay: lastActiveDay,
                totalActiveDays: totalActiveDays,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> current = const Value.absent(),
                Value<int> longest = const Value.absent(),
                Value<DateTime?> lastActiveDay = const Value.absent(),
                Value<int> totalActiveDays = const Value.absent(),
              }) => StreakTableCompanion.insert(
                id: id,
                current: current,
                longest: longest,
                lastActiveDay: lastActiveDay,
                totalActiveDays: totalActiveDays,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StreakTableTable, StreakRow>(table),
                  BaseReferences<_$AppDatabase, $StreakTableTable, StreakRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreakTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreakTableTable,
      StreakRow,
      $$StreakTableTableFilterComposer,
      $$StreakTableTableOrderingComposer,
      $$StreakTableTableAnnotationComposer,
      $$StreakTableTableCreateCompanionBuilder,
      $$StreakTableTableUpdateCompanionBuilder,
      (StreakRow, BaseReferences<_$AppDatabase, $StreakTableTable, StreakRow>),
      StreakRow,
      PrefetchHooks Function()
    >;
typedef $$UnlockedAchievementTableTableCreateCompanionBuilder =
    UnlockedAchievementTableCompanion Function({
      required String achievementId,
      required DateTime unlockedAt,
      Value<int> rowid,
    });
typedef $$UnlockedAchievementTableTableUpdateCompanionBuilder =
    UnlockedAchievementTableCompanion Function({
      Value<String> achievementId,
      Value<DateTime> unlockedAt,
      Value<int> rowid,
    });

class $$UnlockedAchievementTableTableFilterComposer
    extends Composer<_$AppDatabase, $UnlockedAchievementTableTable> {
  $$UnlockedAchievementTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnlockedAchievementTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UnlockedAchievementTableTable> {
  $$UnlockedAchievementTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnlockedAchievementTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnlockedAchievementTableTable> {
  $$UnlockedAchievementTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );
}

class $$UnlockedAchievementTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnlockedAchievementTableTable,
          UnlockedAchievementRow,
          $$UnlockedAchievementTableTableFilterComposer,
          $$UnlockedAchievementTableTableOrderingComposer,
          $$UnlockedAchievementTableTableAnnotationComposer,
          $$UnlockedAchievementTableTableCreateCompanionBuilder,
          $$UnlockedAchievementTableTableUpdateCompanionBuilder,
          (
            UnlockedAchievementRow,
            BaseReferences<
              _$AppDatabase,
              $UnlockedAchievementTableTable,
              UnlockedAchievementRow
            >,
          ),
          UnlockedAchievementRow,
          PrefetchHooks Function()
        > {
  $$UnlockedAchievementTableTableTableManager(
    _$AppDatabase db,
    $UnlockedAchievementTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnlockedAchievementTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$UnlockedAchievementTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UnlockedAchievementTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> achievementId = const Value.absent(),
                Value<DateTime> unlockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnlockedAchievementTableCompanion(
                achievementId: achievementId,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String achievementId,
                required DateTime unlockedAt,
                Value<int> rowid = const Value.absent(),
              }) => UnlockedAchievementTableCompanion.insert(
                achievementId: achievementId,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $UnlockedAchievementTableTable,
                    UnlockedAchievementRow
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UnlockedAchievementTableTable,
                    UnlockedAchievementRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnlockedAchievementTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnlockedAchievementTableTable,
      UnlockedAchievementRow,
      $$UnlockedAchievementTableTableFilterComposer,
      $$UnlockedAchievementTableTableOrderingComposer,
      $$UnlockedAchievementTableTableAnnotationComposer,
      $$UnlockedAchievementTableTableCreateCompanionBuilder,
      $$UnlockedAchievementTableTableUpdateCompanionBuilder,
      (
        UnlockedAchievementRow,
        BaseReferences<
          _$AppDatabase,
          $UnlockedAchievementTableTable,
          UnlockedAchievementRow
        >,
      ),
      UnlockedAchievementRow,
      PrefetchHooks Function()
    >;
typedef $$JournalEntryTableTableCreateCompanionBuilder =
    JournalEntryTableCompanion Function({
      required String id,
      required String scenarioId,
      required DateTime completedAt,
      required String assetSymbol,
      required String timeframeName,
      required String direction,
      required double entry,
      required double stopLoss,
      required double takeProfit,
      required double riskPercent,
      required double positionSize,
      required double rewardToRisk,
      required String outcome,
      required double rMultiple,
      required double profitLoss,
      required double processScore,
      required String difficulty,
      Value<String> mistakeTags,
      Value<String> features,
      Value<String> note,
      Value<bool> favourite,
      Value<bool> ambiguousClose,
      Value<int> rowid,
    });
typedef $$JournalEntryTableTableUpdateCompanionBuilder =
    JournalEntryTableCompanion Function({
      Value<String> id,
      Value<String> scenarioId,
      Value<DateTime> completedAt,
      Value<String> assetSymbol,
      Value<String> timeframeName,
      Value<String> direction,
      Value<double> entry,
      Value<double> stopLoss,
      Value<double> takeProfit,
      Value<double> riskPercent,
      Value<double> positionSize,
      Value<double> rewardToRisk,
      Value<String> outcome,
      Value<double> rMultiple,
      Value<double> profitLoss,
      Value<double> processScore,
      Value<String> difficulty,
      Value<String> mistakeTags,
      Value<String> features,
      Value<String> note,
      Value<bool> favourite,
      Value<bool> ambiguousClose,
      Value<int> rowid,
    });

class $$JournalEntryTableTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntryTableTable> {
  $$JournalEntryTableTableFilterComposer({
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

  ColumnFilters<String> get scenarioId => $composableBuilder(
    column: $table.scenarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetSymbol => $composableBuilder(
    column: $table.assetSymbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeframeName => $composableBuilder(
    column: $table.timeframeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get entry => $composableBuilder(
    column: $table.entry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stopLoss => $composableBuilder(
    column: $table.stopLoss,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get takeProfit => $composableBuilder(
    column: $table.takeProfit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get riskPercent => $composableBuilder(
    column: $table.riskPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get positionSize => $composableBuilder(
    column: $table.positionSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rewardToRisk => $composableBuilder(
    column: $table.rewardToRisk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rMultiple => $composableBuilder(
    column: $table.rMultiple,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get profitLoss => $composableBuilder(
    column: $table.profitLoss,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get processScore => $composableBuilder(
    column: $table.processScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mistakeTags => $composableBuilder(
    column: $table.mistakeTags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get features => $composableBuilder(
    column: $table.features,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favourite => $composableBuilder(
    column: $table.favourite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ambiguousClose => $composableBuilder(
    column: $table.ambiguousClose,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalEntryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntryTableTable> {
  $$JournalEntryTableTableOrderingComposer({
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

  ColumnOrderings<String> get scenarioId => $composableBuilder(
    column: $table.scenarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetSymbol => $composableBuilder(
    column: $table.assetSymbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeframeName => $composableBuilder(
    column: $table.timeframeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get entry => $composableBuilder(
    column: $table.entry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stopLoss => $composableBuilder(
    column: $table.stopLoss,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get takeProfit => $composableBuilder(
    column: $table.takeProfit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get riskPercent => $composableBuilder(
    column: $table.riskPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get positionSize => $composableBuilder(
    column: $table.positionSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rewardToRisk => $composableBuilder(
    column: $table.rewardToRisk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rMultiple => $composableBuilder(
    column: $table.rMultiple,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get profitLoss => $composableBuilder(
    column: $table.profitLoss,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get processScore => $composableBuilder(
    column: $table.processScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mistakeTags => $composableBuilder(
    column: $table.mistakeTags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get features => $composableBuilder(
    column: $table.features,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favourite => $composableBuilder(
    column: $table.favourite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ambiguousClose => $composableBuilder(
    column: $table.ambiguousClose,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalEntryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntryTableTable> {
  $$JournalEntryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scenarioId => $composableBuilder(
    column: $table.scenarioId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetSymbol => $composableBuilder(
    column: $table.assetSymbol,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeframeName => $composableBuilder(
    column: $table.timeframeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<double> get entry =>
      $composableBuilder(column: $table.entry, builder: (column) => column);

  GeneratedColumn<double> get stopLoss =>
      $composableBuilder(column: $table.stopLoss, builder: (column) => column);

  GeneratedColumn<double> get takeProfit => $composableBuilder(
    column: $table.takeProfit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get riskPercent => $composableBuilder(
    column: $table.riskPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get positionSize => $composableBuilder(
    column: $table.positionSize,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rewardToRisk => $composableBuilder(
    column: $table.rewardToRisk,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<double> get rMultiple =>
      $composableBuilder(column: $table.rMultiple, builder: (column) => column);

  GeneratedColumn<double> get profitLoss => $composableBuilder(
    column: $table.profitLoss,
    builder: (column) => column,
  );

  GeneratedColumn<double> get processScore => $composableBuilder(
    column: $table.processScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mistakeTags => $composableBuilder(
    column: $table.mistakeTags,
    builder: (column) => column,
  );

  GeneratedColumn<String> get features =>
      $composableBuilder(column: $table.features, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get favourite =>
      $composableBuilder(column: $table.favourite, builder: (column) => column);

  GeneratedColumn<bool> get ambiguousClose => $composableBuilder(
    column: $table.ambiguousClose,
    builder: (column) => column,
  );
}

class $$JournalEntryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntryTableTable,
          JournalEntryRow,
          $$JournalEntryTableTableFilterComposer,
          $$JournalEntryTableTableOrderingComposer,
          $$JournalEntryTableTableAnnotationComposer,
          $$JournalEntryTableTableCreateCompanionBuilder,
          $$JournalEntryTableTableUpdateCompanionBuilder,
          (
            JournalEntryRow,
            BaseReferences<
              _$AppDatabase,
              $JournalEntryTableTable,
              JournalEntryRow
            >,
          ),
          JournalEntryRow,
          PrefetchHooks Function()
        > {
  $$JournalEntryTableTableTableManager(
    _$AppDatabase db,
    $JournalEntryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> scenarioId = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<String> assetSymbol = const Value.absent(),
                Value<String> timeframeName = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<double> entry = const Value.absent(),
                Value<double> stopLoss = const Value.absent(),
                Value<double> takeProfit = const Value.absent(),
                Value<double> riskPercent = const Value.absent(),
                Value<double> positionSize = const Value.absent(),
                Value<double> rewardToRisk = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<double> rMultiple = const Value.absent(),
                Value<double> profitLoss = const Value.absent(),
                Value<double> processScore = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<String> mistakeTags = const Value.absent(),
                Value<String> features = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> favourite = const Value.absent(),
                Value<bool> ambiguousClose = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntryTableCompanion(
                id: id,
                scenarioId: scenarioId,
                completedAt: completedAt,
                assetSymbol: assetSymbol,
                timeframeName: timeframeName,
                direction: direction,
                entry: entry,
                stopLoss: stopLoss,
                takeProfit: takeProfit,
                riskPercent: riskPercent,
                positionSize: positionSize,
                rewardToRisk: rewardToRisk,
                outcome: outcome,
                rMultiple: rMultiple,
                profitLoss: profitLoss,
                processScore: processScore,
                difficulty: difficulty,
                mistakeTags: mistakeTags,
                features: features,
                note: note,
                favourite: favourite,
                ambiguousClose: ambiguousClose,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String scenarioId,
                required DateTime completedAt,
                required String assetSymbol,
                required String timeframeName,
                required String direction,
                required double entry,
                required double stopLoss,
                required double takeProfit,
                required double riskPercent,
                required double positionSize,
                required double rewardToRisk,
                required String outcome,
                required double rMultiple,
                required double profitLoss,
                required double processScore,
                required String difficulty,
                Value<String> mistakeTags = const Value.absent(),
                Value<String> features = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> favourite = const Value.absent(),
                Value<bool> ambiguousClose = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntryTableCompanion.insert(
                id: id,
                scenarioId: scenarioId,
                completedAt: completedAt,
                assetSymbol: assetSymbol,
                timeframeName: timeframeName,
                direction: direction,
                entry: entry,
                stopLoss: stopLoss,
                takeProfit: takeProfit,
                riskPercent: riskPercent,
                positionSize: positionSize,
                rewardToRisk: rewardToRisk,
                outcome: outcome,
                rMultiple: rMultiple,
                profitLoss: profitLoss,
                processScore: processScore,
                difficulty: difficulty,
                mistakeTags: mistakeTags,
                features: features,
                note: note,
                favourite: favourite,
                ambiguousClose: ambiguousClose,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$JournalEntryTableTable, JournalEntryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $JournalEntryTableTable,
                    JournalEntryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalEntryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntryTableTable,
      JournalEntryRow,
      $$JournalEntryTableTableFilterComposer,
      $$JournalEntryTableTableOrderingComposer,
      $$JournalEntryTableTableAnnotationComposer,
      $$JournalEntryTableTableCreateCompanionBuilder,
      $$JournalEntryTableTableUpdateCompanionBuilder,
      (
        JournalEntryRow,
        BaseReferences<_$AppDatabase, $JournalEntryTableTable, JournalEntryRow>,
      ),
      JournalEntryRow,
      PrefetchHooks Function()
    >;
typedef $$SimulatorAccountTableTableCreateCompanionBuilder =
    SimulatorAccountTableCompanion Function({
      Value<int> id,
      Value<double> startingBalance,
      Value<double> balance,
      Value<double> peakBalance,
      Value<int> tradeCount,
      Value<DateTime?> resetAt,
    });
typedef $$SimulatorAccountTableTableUpdateCompanionBuilder =
    SimulatorAccountTableCompanion Function({
      Value<int> id,
      Value<double> startingBalance,
      Value<double> balance,
      Value<double> peakBalance,
      Value<int> tradeCount,
      Value<DateTime?> resetAt,
    });

class $$SimulatorAccountTableTableFilterComposer
    extends Composer<_$AppDatabase, $SimulatorAccountTableTable> {
  $$SimulatorAccountTableTableFilterComposer({
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

  ColumnFilters<double> get startingBalance => $composableBuilder(
    column: $table.startingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get peakBalance => $composableBuilder(
    column: $table.peakBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tradeCount => $composableBuilder(
    column: $table.tradeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resetAt => $composableBuilder(
    column: $table.resetAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SimulatorAccountTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SimulatorAccountTableTable> {
  $$SimulatorAccountTableTableOrderingComposer({
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

  ColumnOrderings<double> get startingBalance => $composableBuilder(
    column: $table.startingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get peakBalance => $composableBuilder(
    column: $table.peakBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tradeCount => $composableBuilder(
    column: $table.tradeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resetAt => $composableBuilder(
    column: $table.resetAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SimulatorAccountTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SimulatorAccountTableTable> {
  $$SimulatorAccountTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get startingBalance => $composableBuilder(
    column: $table.startingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<double> get peakBalance => $composableBuilder(
    column: $table.peakBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tradeCount => $composableBuilder(
    column: $table.tradeCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get resetAt =>
      $composableBuilder(column: $table.resetAt, builder: (column) => column);
}

class $$SimulatorAccountTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SimulatorAccountTableTable,
          SimulatorAccountRow,
          $$SimulatorAccountTableTableFilterComposer,
          $$SimulatorAccountTableTableOrderingComposer,
          $$SimulatorAccountTableTableAnnotationComposer,
          $$SimulatorAccountTableTableCreateCompanionBuilder,
          $$SimulatorAccountTableTableUpdateCompanionBuilder,
          (
            SimulatorAccountRow,
            BaseReferences<
              _$AppDatabase,
              $SimulatorAccountTableTable,
              SimulatorAccountRow
            >,
          ),
          SimulatorAccountRow,
          PrefetchHooks Function()
        > {
  $$SimulatorAccountTableTableTableManager(
    _$AppDatabase db,
    $SimulatorAccountTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SimulatorAccountTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SimulatorAccountTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SimulatorAccountTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> startingBalance = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<double> peakBalance = const Value.absent(),
                Value<int> tradeCount = const Value.absent(),
                Value<DateTime?> resetAt = const Value.absent(),
              }) => SimulatorAccountTableCompanion(
                id: id,
                startingBalance: startingBalance,
                balance: balance,
                peakBalance: peakBalance,
                tradeCount: tradeCount,
                resetAt: resetAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> startingBalance = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<double> peakBalance = const Value.absent(),
                Value<int> tradeCount = const Value.absent(),
                Value<DateTime?> resetAt = const Value.absent(),
              }) => SimulatorAccountTableCompanion.insert(
                id: id,
                startingBalance: startingBalance,
                balance: balance,
                peakBalance: peakBalance,
                tradeCount: tradeCount,
                resetAt: resetAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SimulatorAccountTableTable, SimulatorAccountRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $SimulatorAccountTableTable,
                    SimulatorAccountRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SimulatorAccountTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SimulatorAccountTableTable,
      SimulatorAccountRow,
      $$SimulatorAccountTableTableFilterComposer,
      $$SimulatorAccountTableTableOrderingComposer,
      $$SimulatorAccountTableTableAnnotationComposer,
      $$SimulatorAccountTableTableCreateCompanionBuilder,
      $$SimulatorAccountTableTableUpdateCompanionBuilder,
      (
        SimulatorAccountRow,
        BaseReferences<
          _$AppDatabase,
          $SimulatorAccountTableTable,
          SimulatorAccountRow
        >,
      ),
      SimulatorAccountRow,
      PrefetchHooks Function()
    >;
typedef $$EquityPointTableTableCreateCompanionBuilder =
    EquityPointTableCompanion Function({
      Value<int> id,
      required DateTime at,
      required double balance,
      Value<double> rMultiple,
      Value<String?> journalEntryId,
    });
typedef $$EquityPointTableTableUpdateCompanionBuilder =
    EquityPointTableCompanion Function({
      Value<int> id,
      Value<DateTime> at,
      Value<double> balance,
      Value<double> rMultiple,
      Value<String?> journalEntryId,
    });

class $$EquityPointTableTableFilterComposer
    extends Composer<_$AppDatabase, $EquityPointTableTable> {
  $$EquityPointTableTableFilterComposer({
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

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rMultiple => $composableBuilder(
    column: $table.rMultiple,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EquityPointTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EquityPointTableTable> {
  $$EquityPointTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rMultiple => $composableBuilder(
    column: $table.rMultiple,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquityPointTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquityPointTableTable> {
  $$EquityPointTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<double> get rMultiple =>
      $composableBuilder(column: $table.rMultiple, builder: (column) => column);

  GeneratedColumn<String> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => column,
  );
}

class $$EquityPointTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquityPointTableTable,
          EquityPointRow,
          $$EquityPointTableTableFilterComposer,
          $$EquityPointTableTableOrderingComposer,
          $$EquityPointTableTableAnnotationComposer,
          $$EquityPointTableTableCreateCompanionBuilder,
          $$EquityPointTableTableUpdateCompanionBuilder,
          (
            EquityPointRow,
            BaseReferences<
              _$AppDatabase,
              $EquityPointTableTable,
              EquityPointRow
            >,
          ),
          EquityPointRow,
          PrefetchHooks Function()
        > {
  $$EquityPointTableTableTableManager(
    _$AppDatabase db,
    $EquityPointTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquityPointTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquityPointTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquityPointTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<double> rMultiple = const Value.absent(),
                Value<String?> journalEntryId = const Value.absent(),
              }) => EquityPointTableCompanion(
                id: id,
                at: at,
                balance: balance,
                rMultiple: rMultiple,
                journalEntryId: journalEntryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                required double balance,
                Value<double> rMultiple = const Value.absent(),
                Value<String?> journalEntryId = const Value.absent(),
              }) => EquityPointTableCompanion.insert(
                id: id,
                at: at,
                balance: balance,
                rMultiple: rMultiple,
                journalEntryId: journalEntryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EquityPointTableTable, EquityPointRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EquityPointTableTable,
                    EquityPointRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EquityPointTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquityPointTableTable,
      EquityPointRow,
      $$EquityPointTableTableFilterComposer,
      $$EquityPointTableTableOrderingComposer,
      $$EquityPointTableTableAnnotationComposer,
      $$EquityPointTableTableCreateCompanionBuilder,
      $$EquityPointTableTableUpdateCompanionBuilder,
      (
        EquityPointRow,
        BaseReferences<_$AppDatabase, $EquityPointTableTable, EquityPointRow>,
      ),
      EquityPointRow,
      PrefetchHooks Function()
    >;
typedef $$XpEventTableTableCreateCompanionBuilder =
    XpEventTableCompanion Function({
      Value<int> id,
      required DateTime at,
      required int amount,
      required String source,
      Value<String?> reference,
    });
typedef $$XpEventTableTableUpdateCompanionBuilder =
    XpEventTableCompanion Function({
      Value<int> id,
      Value<DateTime> at,
      Value<int> amount,
      Value<String> source,
      Value<String?> reference,
    });

class $$XpEventTableTableFilterComposer
    extends Composer<_$AppDatabase, $XpEventTableTable> {
  $$XpEventTableTableFilterComposer({
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

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );
}

class $$XpEventTableTableOrderingComposer
    extends Composer<_$AppDatabase, $XpEventTableTable> {
  $$XpEventTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$XpEventTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $XpEventTableTable> {
  $$XpEventTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);
}

class $$XpEventTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $XpEventTableTable,
          XpEventRow,
          $$XpEventTableTableFilterComposer,
          $$XpEventTableTableOrderingComposer,
          $$XpEventTableTableAnnotationComposer,
          $$XpEventTableTableCreateCompanionBuilder,
          $$XpEventTableTableUpdateCompanionBuilder,
          (
            XpEventRow,
            BaseReferences<_$AppDatabase, $XpEventTableTable, XpEventRow>,
          ),
          XpEventRow,
          PrefetchHooks Function()
        > {
  $$XpEventTableTableTableManager(_$AppDatabase db, $XpEventTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$XpEventTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$XpEventTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$XpEventTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> reference = const Value.absent(),
              }) => XpEventTableCompanion(
                id: id,
                at: at,
                amount: amount,
                source: source,
                reference: reference,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                required int amount,
                required String source,
                Value<String?> reference = const Value.absent(),
              }) => XpEventTableCompanion.insert(
                id: id,
                at: at,
                amount: amount,
                source: source,
                reference: reference,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$XpEventTableTable, XpEventRow>(table),
                  BaseReferences<_$AppDatabase, $XpEventTableTable, XpEventRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$XpEventTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $XpEventTableTable,
      XpEventRow,
      $$XpEventTableTableFilterComposer,
      $$XpEventTableTableOrderingComposer,
      $$XpEventTableTableAnnotationComposer,
      $$XpEventTableTableCreateCompanionBuilder,
      $$XpEventTableTableUpdateCompanionBuilder,
      (
        XpEventRow,
        BaseReferences<_$AppDatabase, $XpEventTableTable, XpEventRow>,
      ),
      XpEventRow,
      PrefetchHooks Function()
    >;
typedef $$ActivityAttemptTableTableCreateCompanionBuilder =
    ActivityAttemptTableCompanion Function({
      Value<int> id,
      required DateTime at,
      required String lessonId,
      required String activityId,
      required String activityKind,
      required String skillId,
      required String conceptTag,
      required String difficulty,
      required bool correct,
      Value<String> context,
    });
typedef $$ActivityAttemptTableTableUpdateCompanionBuilder =
    ActivityAttemptTableCompanion Function({
      Value<int> id,
      Value<DateTime> at,
      Value<String> lessonId,
      Value<String> activityId,
      Value<String> activityKind,
      Value<String> skillId,
      Value<String> conceptTag,
      Value<String> difficulty,
      Value<bool> correct,
      Value<String> context,
    });

class $$ActivityAttemptTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityAttemptTableTable> {
  $$ActivityAttemptTableTableFilterComposer({
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

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityKind => $composableBuilder(
    column: $table.activityKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skillId => $composableBuilder(
    column: $table.skillId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conceptTag => $composableBuilder(
    column: $table.conceptTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityAttemptTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityAttemptTableTable> {
  $$ActivityAttemptTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityKind => $composableBuilder(
    column: $table.activityKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skillId => $composableBuilder(
    column: $table.skillId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conceptTag => $composableBuilder(
    column: $table.conceptTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityAttemptTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityAttemptTableTable> {
  $$ActivityAttemptTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activityKind => $composableBuilder(
    column: $table.activityKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get skillId =>
      $composableBuilder(column: $table.skillId, builder: (column) => column);

  GeneratedColumn<String> get conceptTag => $composableBuilder(
    column: $table.conceptTag,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);
}

class $$ActivityAttemptTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityAttemptTableTable,
          ActivityAttemptRow,
          $$ActivityAttemptTableTableFilterComposer,
          $$ActivityAttemptTableTableOrderingComposer,
          $$ActivityAttemptTableTableAnnotationComposer,
          $$ActivityAttemptTableTableCreateCompanionBuilder,
          $$ActivityAttemptTableTableUpdateCompanionBuilder,
          (
            ActivityAttemptRow,
            BaseReferences<
              _$AppDatabase,
              $ActivityAttemptTableTable,
              ActivityAttemptRow
            >,
          ),
          ActivityAttemptRow,
          PrefetchHooks Function()
        > {
  $$ActivityAttemptTableTableTableManager(
    _$AppDatabase db,
    $ActivityAttemptTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityAttemptTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityAttemptTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityAttemptTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<String> activityKind = const Value.absent(),
                Value<String> skillId = const Value.absent(),
                Value<String> conceptTag = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<bool> correct = const Value.absent(),
                Value<String> context = const Value.absent(),
              }) => ActivityAttemptTableCompanion(
                id: id,
                at: at,
                lessonId: lessonId,
                activityId: activityId,
                activityKind: activityKind,
                skillId: skillId,
                conceptTag: conceptTag,
                difficulty: difficulty,
                correct: correct,
                context: context,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                required String lessonId,
                required String activityId,
                required String activityKind,
                required String skillId,
                required String conceptTag,
                required String difficulty,
                required bool correct,
                Value<String> context = const Value.absent(),
              }) => ActivityAttemptTableCompanion.insert(
                id: id,
                at: at,
                lessonId: lessonId,
                activityId: activityId,
                activityKind: activityKind,
                skillId: skillId,
                conceptTag: conceptTag,
                difficulty: difficulty,
                correct: correct,
                context: context,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityAttemptTableTable, ActivityAttemptRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ActivityAttemptTableTable,
                    ActivityAttemptRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityAttemptTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityAttemptTableTable,
      ActivityAttemptRow,
      $$ActivityAttemptTableTableFilterComposer,
      $$ActivityAttemptTableTableOrderingComposer,
      $$ActivityAttemptTableTableAnnotationComposer,
      $$ActivityAttemptTableTableCreateCompanionBuilder,
      $$ActivityAttemptTableTableUpdateCompanionBuilder,
      (
        ActivityAttemptRow,
        BaseReferences<
          _$AppDatabase,
          $ActivityAttemptTableTable,
          ActivityAttemptRow
        >,
      ),
      ActivityAttemptRow,
      PrefetchHooks Function()
    >;
typedef $$DailyChallengeTableTableCreateCompanionBuilder =
    DailyChallengeTableCompanion Function({
      required String dayKey,
      required int seed,
      Value<int> completedTaskCount,
      Value<bool> completed,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$DailyChallengeTableTableUpdateCompanionBuilder =
    DailyChallengeTableCompanion Function({
      Value<String> dayKey,
      Value<int> seed,
      Value<int> completedTaskCount,
      Value<bool> completed,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

class $$DailyChallengeTableTableFilterComposer
    extends Composer<_$AppDatabase, $DailyChallengeTableTable> {
  $$DailyChallengeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedTaskCount => $composableBuilder(
    column: $table.completedTaskCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyChallengeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyChallengeTableTable> {
  $$DailyChallengeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedTaskCount => $composableBuilder(
    column: $table.completedTaskCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyChallengeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyChallengeTableTable> {
  $$DailyChallengeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<int> get seed =>
      $composableBuilder(column: $table.seed, builder: (column) => column);

  GeneratedColumn<int> get completedTaskCount => $composableBuilder(
    column: $table.completedTaskCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$DailyChallengeTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyChallengeTableTable,
          DailyChallengeRow,
          $$DailyChallengeTableTableFilterComposer,
          $$DailyChallengeTableTableOrderingComposer,
          $$DailyChallengeTableTableAnnotationComposer,
          $$DailyChallengeTableTableCreateCompanionBuilder,
          $$DailyChallengeTableTableUpdateCompanionBuilder,
          (
            DailyChallengeRow,
            BaseReferences<
              _$AppDatabase,
              $DailyChallengeTableTable,
              DailyChallengeRow
            >,
          ),
          DailyChallengeRow,
          PrefetchHooks Function()
        > {
  $$DailyChallengeTableTableTableManager(
    _$AppDatabase db,
    $DailyChallengeTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyChallengeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyChallengeTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyChallengeTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> dayKey = const Value.absent(),
                Value<int> seed = const Value.absent(),
                Value<int> completedTaskCount = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyChallengeTableCompanion(
                dayKey: dayKey,
                seed: seed,
                completedTaskCount: completedTaskCount,
                completed: completed,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dayKey,
                required int seed,
                Value<int> completedTaskCount = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyChallengeTableCompanion.insert(
                dayKey: dayKey,
                seed: seed,
                completedTaskCount: completedTaskCount,
                completed: completed,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyChallengeTableTable, DailyChallengeRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyChallengeTableTable,
                    DailyChallengeRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyChallengeTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyChallengeTableTable,
      DailyChallengeRow,
      $$DailyChallengeTableTableFilterComposer,
      $$DailyChallengeTableTableOrderingComposer,
      $$DailyChallengeTableTableAnnotationComposer,
      $$DailyChallengeTableTableCreateCompanionBuilder,
      $$DailyChallengeTableTableUpdateCompanionBuilder,
      (
        DailyChallengeRow,
        BaseReferences<
          _$AppDatabase,
          $DailyChallengeTableTable,
          DailyChallengeRow
        >,
      ),
      DailyChallengeRow,
      PrefetchHooks Function()
    >;
typedef $$WeeklyChallengeTableTableCreateCompanionBuilder =
    WeeklyChallengeTableCompanion Function({
      required String weekKey,
      required String metric,
      required int target,
      Value<int> progress,
      Value<bool> completed,
      Value<int> rowid,
    });
typedef $$WeeklyChallengeTableTableUpdateCompanionBuilder =
    WeeklyChallengeTableCompanion Function({
      Value<String> weekKey,
      Value<String> metric,
      Value<int> target,
      Value<int> progress,
      Value<bool> completed,
      Value<int> rowid,
    });

class $$WeeklyChallengeTableTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyChallengeTableTable> {
  $$WeeklyChallengeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get weekKey => $composableBuilder(
    column: $table.weekKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyChallengeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyChallengeTableTable> {
  $$WeeklyChallengeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get weekKey => $composableBuilder(
    column: $table.weekKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyChallengeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyChallengeTableTable> {
  $$WeeklyChallengeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get weekKey =>
      $composableBuilder(column: $table.weekKey, builder: (column) => column);

  GeneratedColumn<String> get metric =>
      $composableBuilder(column: $table.metric, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);
}

class $$WeeklyChallengeTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyChallengeTableTable,
          WeeklyChallengeRow,
          $$WeeklyChallengeTableTableFilterComposer,
          $$WeeklyChallengeTableTableOrderingComposer,
          $$WeeklyChallengeTableTableAnnotationComposer,
          $$WeeklyChallengeTableTableCreateCompanionBuilder,
          $$WeeklyChallengeTableTableUpdateCompanionBuilder,
          (
            WeeklyChallengeRow,
            BaseReferences<
              _$AppDatabase,
              $WeeklyChallengeTableTable,
              WeeklyChallengeRow
            >,
          ),
          WeeklyChallengeRow,
          PrefetchHooks Function()
        > {
  $$WeeklyChallengeTableTableTableManager(
    _$AppDatabase db,
    $WeeklyChallengeTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyChallengeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyChallengeTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeeklyChallengeTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> weekKey = const Value.absent(),
                Value<String> metric = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyChallengeTableCompanion(
                weekKey: weekKey,
                metric: metric,
                target: target,
                progress: progress,
                completed: completed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String weekKey,
                required String metric,
                required int target,
                Value<int> progress = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyChallengeTableCompanion.insert(
                weekKey: weekKey,
                metric: metric,
                target: target,
                progress: progress,
                completed: completed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeeklyChallengeTableTable, WeeklyChallengeRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $WeeklyChallengeTableTable,
                    WeeklyChallengeRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyChallengeTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyChallengeTableTable,
      WeeklyChallengeRow,
      $$WeeklyChallengeTableTableFilterComposer,
      $$WeeklyChallengeTableTableOrderingComposer,
      $$WeeklyChallengeTableTableAnnotationComposer,
      $$WeeklyChallengeTableTableCreateCompanionBuilder,
      $$WeeklyChallengeTableTableUpdateCompanionBuilder,
      (
        WeeklyChallengeRow,
        BaseReferences<
          _$AppDatabase,
          $WeeklyChallengeTableTable,
          WeeklyChallengeRow
        >,
      ),
      WeeklyChallengeRow,
      PrefetchHooks Function()
    >;
typedef $$LeagueStateTableTableCreateCompanionBuilder =
    LeagueStateTableCompanion Function({
      Value<int> id,
      Value<String> tier,
      Value<String> weekKey,
      Value<int> weeklyXp,
    });
typedef $$LeagueStateTableTableUpdateCompanionBuilder =
    LeagueStateTableCompanion Function({
      Value<int> id,
      Value<String> tier,
      Value<String> weekKey,
      Value<int> weeklyXp,
    });

class $$LeagueStateTableTableFilterComposer
    extends Composer<_$AppDatabase, $LeagueStateTableTable> {
  $$LeagueStateTableTableFilterComposer({
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

  ColumnFilters<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekKey => $composableBuilder(
    column: $table.weekKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyXp => $composableBuilder(
    column: $table.weeklyXp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeagueStateTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LeagueStateTableTable> {
  $$LeagueStateTableTableOrderingComposer({
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

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekKey => $composableBuilder(
    column: $table.weekKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyXp => $composableBuilder(
    column: $table.weeklyXp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeagueStateTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeagueStateTableTable> {
  $$LeagueStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<String> get weekKey =>
      $composableBuilder(column: $table.weekKey, builder: (column) => column);

  GeneratedColumn<int> get weeklyXp =>
      $composableBuilder(column: $table.weeklyXp, builder: (column) => column);
}

class $$LeagueStateTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeagueStateTableTable,
          LeagueStateRow,
          $$LeagueStateTableTableFilterComposer,
          $$LeagueStateTableTableOrderingComposer,
          $$LeagueStateTableTableAnnotationComposer,
          $$LeagueStateTableTableCreateCompanionBuilder,
          $$LeagueStateTableTableUpdateCompanionBuilder,
          (
            LeagueStateRow,
            BaseReferences<
              _$AppDatabase,
              $LeagueStateTableTable,
              LeagueStateRow
            >,
          ),
          LeagueStateRow,
          PrefetchHooks Function()
        > {
  $$LeagueStateTableTableTableManager(
    _$AppDatabase db,
    $LeagueStateTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeagueStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeagueStateTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeagueStateTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<String> weekKey = const Value.absent(),
                Value<int> weeklyXp = const Value.absent(),
              }) => LeagueStateTableCompanion(
                id: id,
                tier: tier,
                weekKey: weekKey,
                weeklyXp: weeklyXp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<String> weekKey = const Value.absent(),
                Value<int> weeklyXp = const Value.absent(),
              }) => LeagueStateTableCompanion.insert(
                id: id,
                tier: tier,
                weekKey: weekKey,
                weeklyXp: weeklyXp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LeagueStateTableTable, LeagueStateRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LeagueStateTableTable,
                    LeagueStateRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeagueStateTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeagueStateTableTable,
      LeagueStateRow,
      $$LeagueStateTableTableFilterComposer,
      $$LeagueStateTableTableOrderingComposer,
      $$LeagueStateTableTableAnnotationComposer,
      $$LeagueStateTableTableCreateCompanionBuilder,
      $$LeagueStateTableTableUpdateCompanionBuilder,
      (
        LeagueStateRow,
        BaseReferences<_$AppDatabase, $LeagueStateTableTable, LeagueStateRow>,
      ),
      LeagueStateRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfileTableTableTableManager get profileTable =>
      $$ProfileTableTableTableManager(_db, _db.profileTable);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$LessonProgressTableTableTableManager get lessonProgressTable =>
      $$LessonProgressTableTableTableManager(_db, _db.lessonProgressTable);
  $$SkillMasteryTableTableTableManager get skillMasteryTable =>
      $$SkillMasteryTableTableTableManager(_db, _db.skillMasteryTable);
  $$ReviewItemTableTableTableManager get reviewItemTable =>
      $$ReviewItemTableTableTableManager(_db, _db.reviewItemTable);
  $$StreakTableTableTableManager get streakTable =>
      $$StreakTableTableTableManager(_db, _db.streakTable);
  $$UnlockedAchievementTableTableTableManager get unlockedAchievementTable =>
      $$UnlockedAchievementTableTableTableManager(
        _db,
        _db.unlockedAchievementTable,
      );
  $$JournalEntryTableTableTableManager get journalEntryTable =>
      $$JournalEntryTableTableTableManager(_db, _db.journalEntryTable);
  $$SimulatorAccountTableTableTableManager get simulatorAccountTable =>
      $$SimulatorAccountTableTableTableManager(_db, _db.simulatorAccountTable);
  $$EquityPointTableTableTableManager get equityPointTable =>
      $$EquityPointTableTableTableManager(_db, _db.equityPointTable);
  $$XpEventTableTableTableManager get xpEventTable =>
      $$XpEventTableTableTableManager(_db, _db.xpEventTable);
  $$ActivityAttemptTableTableTableManager get activityAttemptTable =>
      $$ActivityAttemptTableTableTableManager(_db, _db.activityAttemptTable);
  $$DailyChallengeTableTableTableManager get dailyChallengeTable =>
      $$DailyChallengeTableTableTableManager(_db, _db.dailyChallengeTable);
  $$WeeklyChallengeTableTableTableManager get weeklyChallengeTable =>
      $$WeeklyChallengeTableTableTableManager(_db, _db.weeklyChallengeTable);
  $$LeagueStateTableTableTableManager get leagueStateTable =>
      $$LeagueStateTableTableTableManager(_db, _db.leagueStateTable);
}
