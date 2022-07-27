class Location {
  num? lat;
  num? lon;
  String? name;
  String? secondaryName;

  Location({this.lat, this.lon, this.name, this.secondaryName});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
    name = json['name'];
    secondaryName = json['secondaryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['name'] = this.name;
    data['secondaryName'] = this.secondaryName;
    return data;
  }
}

class SearchResluts {
  String? type;
  List<String>? query;
  List<Features>? features;
  String? attribution;
  String? message;

  SearchResluts(
      {this.type, this.query, this.features, this.attribution, this.message});

  SearchResluts.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    query = json['query'].cast<String>();
    if (json['features'] != null && json['features'] != []) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
    attribution = json['attribution'];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['query'] = query;
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
    }
    data['attribution'] = attribution;
    return data;
  }
}

class Features {
  String? id;
  String? type;
  List<String>? placeType;
  int? relevance;
  Properties? properties;
  String? text;
  String? placeName;
  String? matchingText;
  String? matchingPlaceName;
  List<double>? bbox;
  List<double>? center;
  Geometry? geometry;
  List<Context>? context;

  Features(
      {this.id,
      this.type,
      this.placeType,
      this.relevance,
      this.properties,
      this.text,
      this.placeName,
      this.matchingText,
      this.matchingPlaceName,
      this.bbox,
      this.center,
      this.geometry,
      this.context});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    placeType = json['place_type']?.cast<String>();
    relevance = json['relevance'];
    text = json['text'];
    placeName = json['place_name'];
    matchingText = json['matching_text'];
    matchingPlaceName = json['matching_place_name'];
    center = json['center']?.cast<double>();

    if (json['context'] != null) {
      context = <Context>[];
      json['context']?.forEach((v) {
        context!.add(Context.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['place_type'] = placeType;
    data['relevance'] = relevance;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    data['text'] = text;
    data['place_name'] = placeName;
    data['matching_text'] = matchingText;
    data['matching_place_name'] = matchingPlaceName;
    data['bbox'] = bbox;
    data['center'] = center;
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    if (context != null) {
      data['context'] = context!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Properties {
  String? wikidata;

  Properties({this.wikidata});

  Properties.fromJson(Map<String, dynamic> json) {
    wikidata = json['wikidata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['wikidata'] = wikidata;
    return data;
  }
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class Context {
  String? id;
  String? wikidata;
  String? text;
  String? shortCode;

  Context({this.id, this.wikidata, this.text, this.shortCode});

  Context.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wikidata = json['wikidata'];
    text = json['text'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['wikidata'] = wikidata;
    data['text'] = text;
    data['short_code'] = shortCode;
    return data;
  }
}
