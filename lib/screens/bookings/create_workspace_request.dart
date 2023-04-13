import 'package:diplom_mobile_app/core/constants/color_constants.dart';
import 'package:diplom_mobile_app/core/widgets/button_style.dart';
import 'package:diplom_mobile_app/core/widgets/input_frame.dart';
import 'package:diplom_mobile_app/utils/booking/change_booking_time.dart';
import 'package:diplom_mobile_app/utils/booking/create_booking_request.dart';
import 'package:diplom_mobile_app/utils/floors/workspaces/workspace_schema.dart';
import 'package:flutter/material.dart';

class BookingCreateWidget extends StatefulWidget {

  final Workspace workspace;

  BookingCreateWidget(this.workspace);

  @override
  _BookingCreateState createState() => _BookingCreateState();
}

class _BookingCreateState extends State<BookingCreateWidget> {

  @override
  initState() {
    super.initState();
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
    await createOccupationRequest(
      _startDate!,
      _endDate!,
      widget.workspace.id
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      content: Text('Запрос успешно создан'),
      duration: Duration(seconds: 2),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.lightGreen,
        title: Text('Создать запрос на бронирование'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Место №${widget.workspace.number}'),
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
                child: Text('Создать'),
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