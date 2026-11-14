class EventModel {
  final String title;
  final String timestamp;
  final double latitude;
  final double longitude;
  final String entity;
  final String description;

  EventModel({
    required this.title,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.entity,
    required this.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final String fullText = (json['العلامة / الحدث'] ?? '') + 
                           (json['نص الحديث / الرواية والمصدر'] ?? '') + 
                           (json['الموقع الجغرافي'] ?? '');

    // إحداثيات افتراضية (وسط المنطقة العربية)
    double lat = 24.0;
    double lon = 45.0;

    // --- محرك التوزيع الجغرافي المحدث ---

    // 1. العراق (توزيع فائق التفصيل)
    if (fullText.contains('الكوفة') || fullText.contains('النجف')) {
      lat = 32.0259; lon = 44.3463;
    } else if (fullText.contains('البصرة')) {
      lat = 30.5081; lon = 47.7835;
    } else if (fullText.contains('الموصل') || fullText.contains('نينوى')) {
      lat = 36.3489; lon = 43.1577;
    } else if (fullText.contains('واسط')) {
      lat = 32.5021; lon = 45.8113;
    } else if (fullText.contains('كربلاء')) {
      lat = 32.6160; lon = 44.0249;
    } else if (fullText.contains('الأنبار') || fullText.contains('الفلوجة')) {
      lat = 33.3516; lon = 43.7842;
    } else if (fullText.contains('بغداد') || fullText.contains('العراق') || fullText.contains('الفرات')) {
      lat = 33.3152; lon = 44.3661;

    // 2. بلاد الشام (توزيع فائق التفصيل)
    } else if (fullText.contains('دمشق') || fullText.contains('الغوطة')) {
      lat = 33.5138; lon = 36.2765;
    } else if (fullText.contains('حمص')) {
      lat = 34.7324; lon = 36.7137;
    } else if (fullText.contains('حلب')) {
      lat = 36.2021; lon = 37.1343;
    } else if (fullText.contains('حماة')) {
      lat = 35.1318; lon = 36.7578;
    } else if (fullText.contains('اللاذقية') || fullText.contains('الساحل')) {
      lat = 35.5312; lon = 35.7922;
    } else if (fullText.contains('درعا') || fullText.contains('حوران')) {
      lat = 32.6151; lon = 36.1030;
    } else if (fullText.contains('الأردن') || fullText.contains('عمان')) {
      lat = 31.9454; lon = 35.9284;
    } else if (fullText.contains('بيروت') || fullText.contains('لبنان')) {
      lat = 33.8938; lon = 35.5018;
    } else if (fullText.contains('القدس') || fullText.contains('فلسطين') || fullText.contains('بيت المقدس')) {
      lat = 31.7683; lon = 35.2137;
    } else if (fullText.contains('غزة')) {
      lat = 31.5017; lon = 34.4668;

    // 3. الحجاز والجزيرة العربية
    } else if (fullText.contains('مكة')) {
      lat = 21.4225; lon = 39.8262;
    } else if (fullText.contains('المدينة') || fullText.contains('يثرب')) {
      lat = 24.4672; lon = 39.6024;
    } else if (fullText.contains('خيبر')) {
      lat = 25.6186; lon = 39.2730;
    } else if (fullText.contains('تبوك')) {
      lat = 28.3835; lon = 36.5662;
    } else if (fullText.contains('الطائف')) {
      lat = 21.2854; lon = 40.4167;
    } else if (fullText.contains('الرياض') || fullText.contains('نجد')) {
      lat = 24.7136; lon = 46.6753;
    } else if (fullText.contains('اليمن') || fullText.contains('صنعاء')) {
      lat = 15.3694; lon = 44.1910;
    } else if (fullText.contains('عدن')) {
      lat = 12.7855; lon = 45.0186;

    // 4. مصر (فقط، مع حذف المغرب العربي بناءً على طلبك)
    } else if (fullText.contains('القاهرة') || fullText.contains('مصر') || fullText.contains('الإسكندرية')) {
      lat = 30.0444; lon = 31.2357;

    // 5. تركيا وإيران
    } else if (fullText.contains('اسطنبول') || fullText.contains('تركيا') || fullText.contains('الروم')) {
      lat = 41.0082; lon = 28.9784;
    } else if (fullText.contains('طهران') || fullText.contains('إيران') || fullText.contains('خراسان')) {
      lat = 35.6892; lon = 51.3890;
    }

    // --- إزاحة طفيفة لمنع التراكم ---
    final String seedString = (json['العلامة / الحدث'] ?? '').toString();
    final int seed = seedString.hashCode;
    double offsetLat = ((seed % 100) - 50) / 1000.0; 
    double offsetLon = (((seed ~/ 100) % 100) - 50) / 1000.0;
    
    lat += offsetLat;
    lon += offsetLon;

    return EventModel(
      title: json['العلامة / الحدث'] ?? json['العلامة/الحدث'] ?? 'حدث بدون عنوان',
      timestamp: json['التوقيت الزمني الدقيق'] ?? '',
      latitude: lat,
      longitude: lon,
      entity: json['الراية / الجهة / الشخصية'] ?? json['الراية/الجهة'] ?? '',
      description: json['نص الحديث / الرواية والمصدر'] ?? json['النص الشرعي/الرواية'] ?? '',
    );
  }
}
