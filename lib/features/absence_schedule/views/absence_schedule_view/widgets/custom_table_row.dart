import 'package:absence_schedule/common/models/emoloyee.dart';
import 'package:flutter/material.dart';

import 'table_details_button.dart';
import 'table_item.dart';
import 'table_name_item.dart';

customTableRow({
  required int employeeIndex,
  required Employee employee,
  required TextEditingController controller,
  required Function(String name) onNameChange,
}) {
  return TableRow(
    children: [
      TableItem(data: (employeeIndex + 1).toString()),
      TableNameItem(
        name: employee.name,
        onChange: onNameChange,
        controller: controller,
      ),
      ...List.generate(
        employee.daysStates.length,
        (dayIndex) => TableDetailsButton(
          dayIndex: dayIndex,
          employeeIndex: employeeIndex,
        ),
      ),
    ],
  );
}
