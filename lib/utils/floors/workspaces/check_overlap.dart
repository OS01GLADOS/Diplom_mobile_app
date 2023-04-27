import 'dart:math';
import 'package:diplom_mobile_app/core/constants/workspace_size.dart';
import 'package:diplom_mobile_app/utils/floors/workspaces/workspace_schema.dart';

bool checkOverlap(int id, double x, double y, List<Workspace> workspaces, [int rotate_degree = 0]) {
  for (final w in workspaces) {
    if (w.id == id) {
      continue; // пропускаем переданный workspace
    }
    // Проверяем пересечение текущего workspace с w.
    final wWidth = w.rotateDegree == 90 || w.rotateDegree == 270 ? WORKSPACE_HEIGHT! : WORKSPACE_WIDTH!;
    final wHeight = w.rotateDegree == 90 || w.rotateDegree == 270 ? WORKSPACE_WIDTH! : WORKSPACE_HEIGHT!;
    final wX = w.coordinates[0][0];
    final wY = w.coordinates[0][1];
    final cosAngle = cos(w.rotateDegree * pi / 180); // явно указываем dart:math
    final sinAngle = sin(w.rotateDegree * pi / 180);
    final rotatedX = wX + (cosAngle * (x - wX) + sinAngle * (y - wY));
    final rotatedY = wY + (cosAngle * (y - wY) - sinAngle * (x - wX));
    if (rotatedX < wX + wWidth &&
        rotatedX + WORKSPACE_WIDTH! > wX &&
        rotatedY < wY + wHeight &&
        rotatedY + WORKSPACE_HEIGHT! > wY) {
      // Если координаты пересекаются, возвращаем true.
      return true;
    }
  }
  // Если не найдено пересечений, возвращаем false.
  return false;
}