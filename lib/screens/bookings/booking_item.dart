import 'package:diplom_mobile_app/utils/booking/booking_schema.dart';
import 'package:flutter/material.dart';

class BookingItemWidget extends StatelessWidget {
  final Booking booking;
  final bool is_mine = true;

  const BookingItemWidget({Key? key, required this.booking}) : super(key: key);

  String format_date(DateTime date){
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }


  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title:
          Row(
            children: [
              Text('${format_date(booking.occupationStartDate)} - ${format_date(booking.occupationEndDate)}'),
              Spacer(),
              Text('${booking.status}')
            ],
          ),
      children: [
        Text('Информация о запросе'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            is_mine? Text(""): Text('Сотрудник: ${booking.employeeName}'),
            Text('Место: ${booking.workspaceNumber}'),
            Text('Кабинет: ${booking.room}'),
            Text('Этаж: ${booking.floor}'),
            Text('Адрес: ${booking.location}, ${booking.office}')
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Менеджер: ${booking.officeManagerName}'),
          ],
        ),
      ],
    );
  }
}