import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:changas_ya_app/core/data/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'profile_provider.dart'; 

class SaveProfileNotifier extends StateNotifier<AsyncValue<void>> {
  
  final Ref _ref;
  final ProfileRepository _repository;

  SaveProfileNotifier(this._ref) 
      : _repository = _ref.read(profileRepositoryProvider), 
        super(const AsyncValue.data(null)); 

  Future<void> saveProfile(Profile profile) async {
    state = const AsyncValue.loading(); 
    
    try {
      await _repository.updateProfile(profile);

      // hace que si o si refresque el profile
      _ref.invalidate(professionalFutureProvider(profile.uid)); 

      state = const AsyncValue.data(null); 
    } catch (e, st) {
      state = AsyncValue.error(e, st); 
    }
  }
}

final saveProfileNotifierProvider = StateNotifierProvider<SaveProfileNotifier, AsyncValue<void>>((ref) {
  return SaveProfileNotifier(ref);
});