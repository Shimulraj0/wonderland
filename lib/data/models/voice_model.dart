class VoiceModel {
  final String id;
  final String name;
  final String description;
  final bool isCustom;
  final bool isActive;

  VoiceModel({
    required this.id,
    required this.name,
    required this.description,
    this.isCustom = false,
    this.isActive = true,
  });
}
