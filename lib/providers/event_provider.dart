import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/event_model.dart';

class EventProvider with ChangeNotifier {
  List<EventModel> _events = [];
  List<EventModel> _filteredEvents = [];
  bool _isLoading = false;
  String? _error;

  List<EventModel> get events => _events;
  List<EventModel> get filteredEvents => _filteredEvents;
  bool get isLoading => _isLoading;
  String? get error => _error;

  EventProvider() {
    loadEvents();
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // قراءة الملف الصحيح الظاهر في الصورة
      final String response = await rootBundle.loadString('assets/data/excel-to-json.json');
      final Map<String, dynamic> fullData = json.decode(response);
      
      // استخراج القائمة من داخل مفتاح "ورقة1" كما هو ظاهر في الصورة
      if (fullData.containsKey('ورقة1')) {
        final List<dynamic> dataList = fullData['ورقة1'];
        _events = dataList.map((json) => EventModel.fromJson(json)).toList();
        _filteredEvents = List.from(_events);
      } else {
        _error = "لم يتم العثور على مفتاح 'ورقة1' في ملف JSON";
      }
    } catch (e) {
      _error = "فشل تحميل البيانات: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterEvents(String query) {
    if (query.isEmpty) {
      _filteredEvents = List.from(_events);
    } else {
      _filteredEvents = _events
          .where((event) =>
              event.title.contains(query) ||
              event.entity.contains(query) ||
              event.description.contains(query))
          .toList();
    }
    notifyListeners();
  }

  void filterByEntity(String entity) {
    if (entity == "الكل" || entity.isEmpty) {
      _filteredEvents = List.from(_events);
    } else {
      _filteredEvents = _events.where((event) => event.entity == entity).toList();
    }
    notifyListeners();
  }
}
