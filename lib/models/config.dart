class Config {
  String apiKey, appId, messagingSenderId, projectId, storeLink, storeType, bucketId;

  Config({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    required this.storeLink,
    required this.storeType,
    required this.bucketId,
  });

  factory Config.fromJson(Map<String, dynamic> map) {
    return Config(
      apiKey: map['apiKey'],
      appId: map['appId'],
      messagingSenderId: map['messagingSenderId'],
      projectId: map['projectId'],
      storeLink: map['storeLink'],
      storeType: map['storeType'],
      bucketId: map['bucketId'],
    );
  }
}
