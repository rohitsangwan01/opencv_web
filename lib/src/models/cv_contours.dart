class CvContours {
  int x;
  int y;
  int w;
  int h;

  CvContours({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  @override
  String toString() {
    return {"x": x, "y": y, "w": w, "h": h}.toString();
  }
}
