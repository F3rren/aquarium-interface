import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fish.dart';
import '../models/coral.dart';

class InhabitantsService {
  static const String _fishKey = 'fish_list';
  static const String _coralsKey = 'corals_list';

  // Fish operations
  Future<List<Fish>> getFish() async {
    final prefs = await SharedPreferences.getInstance();
    final fishJson = prefs.getString(_fishKey);
    if (fishJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(fishJson);
    return decoded.map((json) => Fish.fromJson(json)).toList();
  }

  Future<void> saveFish(List<Fish> fish) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(fish.map((f) => f.toJson()).toList());
    await prefs.setString(_fishKey, encoded);
  }

  Future<void> addFish(Fish fish) async {
    final fishList = await getFish();
    fishList.add(fish);
    await saveFish(fishList);
  }

  Future<void> addMultipleFish(List<Fish> fish) async {
    final fishList = await getFish();
    fishList.addAll(fish);
    await saveFish(fishList);
  }

  Future<void> updateFish(Fish fish) async {
    final fishList = await getFish();
    final index = fishList.indexWhere((f) => f.id == fish.id);
    if (index != -1) {
      fishList[index] = fish;
      await saveFish(fishList);
    }
  }

  Future<void> deleteFish(String id) async {
    final fishList = await getFish();
    fishList.removeWhere((f) => f.id == id);
    await saveFish(fishList);
  }

  // Coral operations
  Future<List<Coral>> getCorals() async {
    final prefs = await SharedPreferences.getInstance();
    final coralsJson = prefs.getString(_coralsKey);
    if (coralsJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(coralsJson);
    return decoded.map((json) => Coral.fromJson(json)).toList();
  }

  Future<void> saveCorals(List<Coral> corals) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(corals.map((c) => c.toJson()).toList());
    await prefs.setString(_coralsKey, encoded);
  }

  Future<void> addCoral(Coral coral) async {
    final coralsList = await getCorals();
    coralsList.add(coral);
    await saveCorals(coralsList);
  }

  Future<void> addMultipleCorals(List<Coral> corals) async {
    final coralsList = await getCorals();
    coralsList.addAll(corals);
    await saveCorals(coralsList);
  }

  Future<void> updateCoral(Coral coral) async {
    final coralsList = await getCorals();
    final index = coralsList.indexWhere((c) => c.id == coral.id);
    if (index != -1) {
      coralsList[index] = coral;
      await saveCorals(coralsList);
    }
  }

  Future<void> deleteCoral(String id) async {
    final coralsList = await getCorals();
    coralsList.removeWhere((c) => c.id == id);
    await saveCorals(coralsList);
  }

  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final fish = await getFish();
    final corals = await getCorals();
    
    final totalFish = fish.length;
    final totalCorals = corals.length;
    final avgFishSize = fish.isEmpty ? 0.0 : fish.map((f) => f.size).reduce((a, b) => a + b) / fish.length;
    final totalBioLoad = fish.fold<double>(0, (sum, f) => sum + f.size) + (corals.length * 2.0);
    
    return {
      'totalFish': totalFish,
      'totalCorals': totalCorals,
      'avgFishSize': avgFishSize,
      'totalBioLoad': totalBioLoad,
    };
  }
}
