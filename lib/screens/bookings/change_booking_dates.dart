import 'package:deskFinder/core/constants/color_constants.dart';
import 'package:deskFinder/core/widgets/button_style.dart';
import 'package:deskFinder/core/widgets/input_frame.dart';
import 'package:deskFinder/utils/booking/booking_schema.dart';
import 'package:deskFinder/utils/booking/change_booking_time.dart';
import 'package:flutter/material.dart';

class BookingScreenDate extends StatefulWidget {
  final Booking booking;

  BookingScreenDate({required this.booking});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreenDate> {

  @override
  initState() {
    super.initState();
    _startDate = widget.booking.occupationStartDate;
    _endDate = widget.booking.occupationEndDate;
  }

  DateTime? _startDate;
  DateTime? _endDate;

  void _showStartDatePicker() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null && selectedDate != _startDate) {
      setState(() {
        _startDate = selectedDate;
        if (_endDate == null || _endDate!.isBefore(_startDate!)) {
          _endDate = _startDate;
        }
      });
    }
  }

  void _showEndDatePicker() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null && selectedDate != _endDate) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }

  bool _validateDates() {
    if (_startDate == null || _endDate == null) {
      return false;
    }
    return _endDate!.isAfter(_startDate!);
  }

  _submitForm() async {
    if (!_validateDates()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Дата окончания бронирования не может быть раньше даты начала бронирования.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    }
    await changeBookingDate(
    _startDate!,
      _endDate!,
      widget.booking
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      content: Text('Запрос успешно изменён'),
      duration: Duration(seconds: 2),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightGreen,
        title: Text('Изменить даты бронирования'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InputFrameWidget(
              'Дата начала',
              TextButton(
                child: Text('${_startDate == null ? '' : _startDate!.toLocal().toString().split(' ')[0]}'),
                onPressed: _showStartDatePicker,
              ),
            ),
            InputFrameWidget(
              'Дата окончания',
              TextButton(
                child: Text('${_endDate == null ? '' : _endDate!.toLocal().toString().split(' ')[0]}'),
                onPressed: _showEndDatePicker,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                child: Text('Сохранить'),
                onPressed: _submitForm,
                style: default_style,
              ),
            )

          ],
        ),
      ),
    );
  }
}