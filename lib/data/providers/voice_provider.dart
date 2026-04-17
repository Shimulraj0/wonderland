import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/voice_model.dart';
import 'package:uuid/uuid.dart';

final voiceProvider = NotifierProvider<VoiceNotifier, List<VoiceModel>>(VoiceNotifier.new);

class VoiceNotifier extends Notifier<List<VoiceModel>> {
  @override
  List<VoiceModel> build() => _initialVoices;

  static final List<VoiceModel> _initialVoices = [
    VoiceModel(
      id: '1',
      name: 'Mom\'s Voice',
      description: 'Used in 12 stories',
      isCustom: true,
      isActive: true,
    ),
    VoiceModel(
      id: '2',
      name: 'Dad\'s Voice',
      description: 'Used in 5 stories',
      isCustom: true,
      isActive: true,
    ),
  ];

  void addVoice(String name, String description) {
    final newVoice = VoiceModel(
      id: const Uuid().v4(),
      name: name,
      description: description,
      isCustom: true,
      isActive: true,
    );
    state = [...state, newVoice];
  }
}
