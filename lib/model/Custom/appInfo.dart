class AppInfo {
  AppInfo(
      {this.siteName,
      this.welcome,
      this.aboutApp,
      this.terms,
      this.mobile,
      this.email,
      this.address,
      this.whatsapp,
      this.facebook,
      this.twitter,
      this.youtube,
      this.instagram,
      this.url,
      this.theme,
      this.themeId,
      this.themes,
      this.color,
      this.logo});

  String siteName;
  String welcome;
  String aboutApp;
  String terms;
  String mobile;
  String email;
  String address;
  String whatsapp;
  String facebook;
  String twitter;
  String youtube;
  String instagram;
  String url;
  String theme;
  String themeId;
  List<Theme> themes;
  String color;
  String logo;

  factory AppInfo.fromJson(Map<String, dynamic> json) => AppInfo(
      siteName: json["site_name"] == null ? null : json["site_name"],
      welcome: json["welcome"] == null ? null : json["welcome"],
      aboutApp: json["about_app"] == null ? null : json["about_app"],
      terms: json["terms"] == null ? null : json["terms"],
      mobile: json["mobile"] == null ? null : json["mobile"],
      email: json["email"] == null ? null : json["email"],
      address: json["address"] == null ? null : json["address"],
      whatsapp: json["whatsapp"] == null ? null : json["whatsapp"],
      facebook: json["facebook"] == null ? null : json["facebook"],
      twitter: json["twitter"] == null ? null : json["twitter"],
      youtube: json["youtube"] == null ? null : json["youtube"],
      instagram: json["instagram"] == null ? null : json["instagram"],
      url: json["url"] == null ? null : json["url"],
      theme: json["theme"] == null ? null : json["theme"],
      themeId: json["theme_id"] == null ? null : json["theme_id"],
      themes: json["themes"] == null
          ? null
          : List<Theme>.from(json["themes"].map((x) => Theme.fromJson(x))),
      color: json["color"] == null ? null : json["color"],
      logo: json["logo"] == null ? null : json["logo"]);
}

class Theme {
  Theme({
    this.themeId,
    this.title,
  });

  String themeId;
  String title;

  factory Theme.fromJson(Map<String, dynamic> json) => Theme(
        themeId: json["theme_id"] == null ? null : json["theme_id"],
        title: json["title"] == null ? null : json["title"],
      );
}
