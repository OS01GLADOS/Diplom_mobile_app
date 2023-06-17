import 'package:deskFinder/utils/floors/plan/rooms_schema.dart';
import 'package:deskFinder/utils/floors/plan/stairs_schema.dart';

class PlanObjects {

  List<Room>? rooms;
  List<Stair>? stairs;

  PlanObjects({
    required this.rooms,
    required this.stairs,
  });
}