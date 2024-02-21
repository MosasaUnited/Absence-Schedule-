import 'package:absence_schedule/features/absence_schedule/cubit/absence_cubit/absence_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/absence_cubit/absence_cubit.dart';
import 'custom_table.dart';
import 'custom_table_row.dart';
import 'table_header_row.dart';

class AbsenceScheduleBody extends StatelessWidget {
  const AbsenceScheduleBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AbsenceCubit, AbsenceState>(
      builder: (context, state) {
        final absenceCubit = AbsenceCubit.of(context);
        return CustomTable(
          children: [
            tableHeaderRow(
                absenceCubit.section.employees.first.daysStates.length),
            ...absenceCubit.section.employees.asMap().entries.map(
                  (entry) => customTableRow(
                    employeeIndex: entry.key,
                    employee: entry.value,
                    controller: absenceCubit.controllers[entry.key],
                    onNameChange: (name) => absenceCubit.changeEmployeeName(
                      name: name,
                      employeeIndex: entry.key,
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}
