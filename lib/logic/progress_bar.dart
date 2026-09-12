double progressBarValue(double current, double total) {
  if (total == 0) return 0.0;
  return current / total;
}