import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:deskFinder/utils/booking/booking_schema.dart';
import 'package:flutter/material.dart';

class BookingItemWidget extends StatelessWidget {
  final Booking booking;
  bool is_mine = true;

  BookingItemWidget({Key? key, required this.booking, required this.is_mine}) : super(key: key);

  String format_date(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  Map<String, Color> statusColors = {
    'In progress': ColorConstants.requestInProgress,
    'Approved': ColorConstants.requestApproved,
    'Rejected': ColorConstants.requestRejected,
    'Delayed': ColorConstants.requestDelayed,
    'Canceled': ColorConstants.requestCanceled,
  };

  Map<String, String> statusesRus = {
  'In progress': 'На рассмотрении',
  'Approved': "Одобрен",
  'Rejected': "Отклонён",
  'Delayed': "Отменён",
  'Canceled': "Истёк срок"
  };

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Text(
            '${format_date(booking.occupationStartDate)} - ${format_date(booking.occupationEndDate)}',
            style: TextStyle(
              color: statusColors[booking.status],
            ),
          ),
          Spacer(),
          Text(
            statusesRus[booking.status]!,
            style: TextStyle(
              color: statusColors[booking.status],
            ),
          )
        ],
      ),
      children: [
        Text('Информация о запросе'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            is_mine ? Text("") : Text('Сотрудник: ${booking.employeeName}'),
            Text('Место: ${booking.workspaceNumber}'),
            Text('Кабинет: ${booking.room}'),
            Text('Этаж: ${booking.floor}'),
            Text('Адрес: ${booking.location}, ${booking.office}')
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(booking.officeManagerName != null)
            Text('Менеджер: ${booking.officeManagerName}'),
          ],
        ),
      ],
    );
  }
}
