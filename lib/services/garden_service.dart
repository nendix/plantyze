import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantyze/models/plant.dart';
import 'package:plantyze/models/saved_plant.dart';

class GardenService extends ChangeNotifier {
  static const String _gardenKey = 'saved_plants';
  SharedPreferences? _prefs;
  List<SavedPlant> _savedPlants = [];

  List<SavedPlant> get savedPlants => List.unmodifiable(_savedPlants);
  int get plantCount => _savedPlants.length;
  bool get isEmpty => _savedPlants.isEmpty;
  bool get isNotEmpty => _savedPlants.isNotEmpty;

  /// Initialize the service and load saved plants
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedPlants();
  }

  /// Load saved plants from SharedPreferences
  Future<void> _loadSavedPlants() async {
    try {
      final String? plantsJson = _prefs?.getString(_gardenKey);
      if (plantsJson != null && plantsJson.isNotEmpty) {
        final List<dynamic> plantsList = jsonDecode(plantsJson);
        _savedPlants = plantsList
            .map((json) => SavedPlant.fromJson(json as Map<String, dynamic>))
            .toList();
        
        // Sort by saved date (newest first)
        _savedPlants.sort((a, b) => b.savedAt.compareTo(a.savedAt));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved plants: $e');
      _savedPlants = [];
    }
  }

  /// Save plants list to SharedPreferences
  Future<void> _savePlantsToStorage() async {
    try {
      final List<Map<String, dynamic>> plantsJson = 
          _savedPlants.map((plant) => plant.toJson()).toList();
      await _prefs?.setString(_gardenKey, jsonEncode(plantsJson));
    } catch (e) {
      debugPrint('Error saving plants to storage: $e');
    }
  }

  /// Add a plant to the garden
  Future<bool> savePlant(Plant plant) async {
    try {
      // Check if plant is already saved (by scientific name to avoid duplicates)
      final bool alreadyExists = _savedPlants.any(
        (savedPlant) => savedPlant.plant.scientificName == plant.scientificName,
      );

      if (alreadyExists) {
        return false; // Plant already exists
      }

      final savedPlant = SavedPlant.fromPlant(plant);
      _savedPlants.insert(0, savedPlant); // Add to beginning (newest first)
      
      await _savePlantsToStorage();
      notifyListeners();
      return true; // Successfully saved
    } catch (e) {
      debugPrint('Error saving plant: $e');
      return false;
    }
  }

  /// Remove a plant from the garden
  Future<bool> removePlant(String savedPlantId) async {
    try {
      final int index = _savedPlants.indexWhere((plant) => plant.id == savedPlantId);
      if (index != -1) {
        _savedPlants.removeAt(index);
        await _savePlantsToStorage();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error removing plant: $e');
      return false;
    }
  }

  /// Check if a plant is already saved
  bool isPlantSaved(Plant plant) {
    return _savedPlants.any(
      (savedPlant) => savedPlant.plant.scientificName == plant.scientificName,
    );
  }

  /// Clear all saved plants
  Future<void> clearGarden() async {
    try {
      _savedPlants.clear();
      await _prefs?.remove(_gardenKey);
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing garden: $e');
    }
  }

  /// Get a saved plant by ID
  SavedPlant? getSavedPlant(String id) {
    try {
      return _savedPlants.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get plants saved in a specific time range
  List<SavedPlant> getPlantsInDateRange(DateTime start, DateTime end) {
    return _savedPlants.where((plant) {
      return plant.savedAt.isAfter(start) && plant.savedAt.isBefore(end);
    }).toList();
  }
}