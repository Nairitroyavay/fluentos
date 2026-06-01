// ignore_for_file: prefer_initializing_formals
part of 'models.dart';

enum LanguageSupportStatus { supported, preview, comingSoon }

extension LanguageSupportStatusText on LanguageSupportStatus {
  String get label {
    switch (this) {
      case LanguageSupportStatus.supported:
        return 'Supported';
      case LanguageSupportStatus.preview:
        return 'Preview';
      case LanguageSupportStatus.comingSoon:
        return 'Coming soon';
    }
  }
}

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final LanguageSupportStatus supportStatus;
  final bool canBeBase;
  final bool canBeTarget;
  final String scriptName;
  final bool hasRomanization;
  final bool hasTransliteration;
  final List<String> commonRegions;
  final List<String> defaultAccentOptions;
  final DateTime? _createdAt;
  final DateTime? _updatedAt;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    this.supportStatus = LanguageSupportStatus.supported,
    required this.canBeBase,
    required this.canBeTarget,
    this.scriptName = 'Latin script',
    this.hasRomanization = false,
    this.hasTransliteration = false,
    this.commonRegions = const [],
    this.defaultAccentOptions = const ['Global clear'],
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _createdAt = createdAt,
       _updatedAt = updatedAt;

  bool get isPhaseOne => supportStatus == LanguageSupportStatus.supported;
  String get id => code;
  DateTime get createdAt => _createdAt ?? _fallbackDate();
  DateTime get updatedAt => _updatedAt ?? createdAt;

  factory LanguageOption.fromJson(Map<String, dynamic> json) {
    return LanguageOption(
      code: _stringValue(json['code'], _stringValue(json['id'], 'en')),
      name: _stringValue(json['name'], 'English'),
      nativeName: _stringValue(json['nativeName'], 'English'),
      flag: _stringValue(json['flag'], 'EN'),
      supportStatus: _enumValue(
        LanguageSupportStatus.values,
        json['supportStatus'],
        LanguageSupportStatus.supported,
      ),
      canBeBase: _boolValue(json['canBeBase'], true),
      canBeTarget: _boolValue(json['canBeTarget'], true),
      scriptName: _stringValue(json['scriptName'], 'Latin script'),
      hasRomanization: _boolValue(json['hasRomanization'], false),
      hasTransliteration: _boolValue(json['hasTransliteration'], false),
      commonRegions: _stringList(json['commonRegions']),
      defaultAccentOptions: _stringList(json['defaultAccentOptions']).isEmpty
          ? const ['Global clear']
          : _stringList(json['defaultAccentOptions']),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
      updatedAt: _dateValue(json['updatedAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'nativeName': nativeName,
      'flag': flag,
      'supportStatus': supportStatus.name,
      'canBeBase': canBeBase,
      'canBeTarget': canBeTarget,
      'scriptName': scriptName,
      'hasRomanization': hasRomanization,
      'hasTransliteration': hasTransliteration,
      'commonRegions': commonRegions,
      'defaultAccentOptions': defaultAccentOptions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  LanguageOption copyWith({
    String? code,
    String? name,
    String? nativeName,
    String? flag,
    LanguageSupportStatus? supportStatus,
    bool? canBeBase,
    bool? canBeTarget,
    String? scriptName,
    bool? hasRomanization,
    bool? hasTransliteration,
    List<String>? commonRegions,
    List<String>? defaultAccentOptions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LanguageOption(
      code: code ?? this.code,
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      flag: flag ?? this.flag,
      supportStatus: supportStatus ?? this.supportStatus,
      canBeBase: canBeBase ?? this.canBeBase,
      canBeTarget: canBeTarget ?? this.canBeTarget,
      scriptName: scriptName ?? this.scriptName,
      hasRomanization: hasRomanization ?? this.hasRomanization,
      hasTransliteration: hasTransliteration ?? this.hasTransliteration,
      commonRegions: commonRegions ?? this.commonRegions,
      defaultAccentOptions: defaultAccentOptions ?? this.defaultAccentOptions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class LanguageProfile {
  final String id;
  final String userId;
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final LanguageSupportStatus supportStatus;
  final String baseLanguageCode;
  final String baseLanguageName;
  final String userRegion;
  final String targetCulture;
  final String level;
  final String focus;
  final String goal;
  final int fluencyScore;
  final int confidenceScore;
  final int pronunciationScore;
  final List<String> weakSounds;
  final String scriptMode;
  final String scriptName;
  final bool hasRomanization;
  final bool hasTransliteration;
  final bool supportsTransliteration;
  final List<String> commonRegions;
  final List<String> defaultAccentOptions;
  final String accentPreference;
  final bool isActive;
  final DateTime? _createdAt;
  final DateTime? _updatedAt;

  const LanguageProfile({
    required this.id,
    this.userId = 'user_roy',
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.supportStatus,
    required this.baseLanguageCode,
    required this.baseLanguageName,
    required this.userRegion,
    required this.targetCulture,
    required this.level,
    required this.focus,
    required this.goal,
    required this.fluencyScore,
    required this.confidenceScore,
    required this.pronunciationScore,
    required this.weakSounds,
    required this.scriptMode,
    required this.scriptName,
    required this.hasRomanization,
    required this.hasTransliteration,
    required this.supportsTransliteration,
    required this.commonRegions,
    required this.defaultAccentOptions,
    required this.accentPreference,
    this.isActive = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _createdAt = createdAt,
       _updatedAt = updatedAt;

  String get languageCode => code;
  String get targetLanguageCode => code;
  String get targetLanguageName => name;
  String get emojiFlag => flag;
  bool get active => isActive;
  DateTime get createdAt => _createdAt ?? _fallbackDate();
  DateTime get updatedAt => _updatedAt ?? createdAt;

  factory LanguageProfile.fromJson(Map<String, dynamic> json) {
    final supportStatus = _enumValue(
      LanguageSupportStatus.values,
      json['supportStatus'],
      LanguageSupportStatus.supported,
    );
    final scriptName = _stringValue(
      json['scriptName'],
      _stringValue(json['scriptMode'], 'Latin script'),
    );
    final hasTransliteration = _boolValue(
      json['hasTransliteration'],
      _boolValue(json['supportsTransliteration'], false),
    );
    final goal = _stringValue(
      json['goal'],
      _stringValue(json['focus'], 'English speaking confidence'),
    );

    return LanguageProfile(
      id: _stringValue(json['id'], 'lang_en_en'),
      userId: _stringValue(json['userId'], 'user_roy'),
      code: _stringValue(
        json['languageCode'],
        _stringValue(
          json['targetLanguageCode'],
          _stringValue(json['code'], 'en'),
        ),
      ),
      name: _stringValue(json['name'], 'English'),
      nativeName: _stringValue(json['nativeName'], 'English'),
      flag: _stringValue(json['emojiFlag'], _stringValue(json['flag'], 'EN')),
      supportStatus: supportStatus,
      baseLanguageCode: _stringValue(json['baseLanguageCode'], 'en'),
      baseLanguageName: _stringValue(json['baseLanguageName'], 'English'),
      userRegion: _stringValue(json['userRegion'], 'United States'),
      targetCulture: _stringValue(json['targetCulture'], 'Global culture'),
      level: _stringValue(json['level'], 'Starter'),
      focus: _stringValue(json['focus'], goal),
      goal: goal,
      fluencyScore: _intValue(json['fluencyScore'], 160),
      confidenceScore: _intValue(json['confidenceScore'], 42),
      pronunciationScore: _intValue(json['pronunciationScore'], 58),
      weakSounds: _stringList(json['weakSounds']),
      scriptMode: _stringValue(json['scriptMode'], scriptName),
      scriptName: scriptName,
      hasRomanization: _boolValue(json['hasRomanization'], false),
      hasTransliteration: hasTransliteration,
      supportsTransliteration: hasTransliteration,
      commonRegions: _stringList(json['commonRegions']),
      defaultAccentOptions: _stringList(json['defaultAccentOptions']).isEmpty
          ? const ['Global clear']
          : _stringList(json['defaultAccentOptions']),
      accentPreference: _stringValue(json['accentPreference'], 'Global clear'),
      isActive: _boolValue(json['active'], _boolValue(json['isActive'], false)),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
      updatedAt: _dateValue(json['updatedAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'code': code,
      'languageCode': languageCode,
      'targetLanguageCode': targetLanguageCode,
      'targetLanguageName': targetLanguageName,
      'name': name,
      'nativeName': nativeName,
      'flag': flag,
      'emojiFlag': emojiFlag,
      'supportStatus': supportStatus.name,
      'baseLanguageCode': baseLanguageCode,
      'baseLanguageName': baseLanguageName,
      'userRegion': userRegion,
      'targetCulture': targetCulture,
      'level': level,
      'focus': focus,
      'goal': goal,
      'fluencyScore': fluencyScore,
      'confidenceScore': confidenceScore,
      'pronunciationScore': pronunciationScore,
      'weakSounds': weakSounds,
      'scriptMode': scriptMode,
      'scriptName': scriptName,
      'hasRomanization': hasRomanization,
      'hasTransliteration': hasTransliteration,
      'supportsTransliteration': supportsTransliteration,
      'commonRegions': commonRegions,
      'defaultAccentOptions': defaultAccentOptions,
      'accentPreference': accentPreference,
      'isActive': isActive,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  LanguageProfile copyWith({
    String? userId,
    LanguageSupportStatus? supportStatus,
    String? userRegion,
    String? targetCulture,
    String? level,
    String? focus,
    String? goal,
    int? fluencyScore,
    int? confidenceScore,
    int? pronunciationScore,
    List<String>? weakSounds,
    String? scriptMode,
    String? scriptName,
    bool? hasRomanization,
    bool? hasTransliteration,
    bool? supportsTransliteration,
    List<String>? commonRegions,
    List<String>? defaultAccentOptions,
    String? accentPreference,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LanguageProfile(
      id: id,
      userId: userId ?? this.userId,
      code: code,
      name: name,
      nativeName: nativeName,
      flag: flag,
      supportStatus: supportStatus ?? this.supportStatus,
      baseLanguageCode: baseLanguageCode,
      baseLanguageName: baseLanguageName,
      userRegion: userRegion ?? this.userRegion,
      targetCulture: targetCulture ?? this.targetCulture,
      level: level ?? this.level,
      focus: focus ?? this.focus,
      goal: goal ?? this.goal,
      fluencyScore: fluencyScore ?? this.fluencyScore,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      pronunciationScore: pronunciationScore ?? this.pronunciationScore,
      weakSounds: weakSounds ?? this.weakSounds,
      scriptMode: scriptMode ?? this.scriptMode,
      scriptName: scriptName ?? this.scriptName,
      hasRomanization: hasRomanization ?? this.hasRomanization,
      hasTransliteration: hasTransliteration ?? this.hasTransliteration,
      supportsTransliteration:
          supportsTransliteration ?? this.supportsTransliteration,
      commonRegions: commonRegions ?? this.commonRegions,
      defaultAccentOptions: defaultAccentOptions ?? this.defaultAccentOptions,
      accentPreference: accentPreference ?? this.accentPreference,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
