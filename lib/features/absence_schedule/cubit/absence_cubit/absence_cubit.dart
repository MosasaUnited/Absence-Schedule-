import 'package:absence_schedule/common/models/management.dart';
import 'package:absence_schedule/features/absence_schedule/data/sections_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'absence_state.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  AbsenceCubit() : super(AbsenceInitial());

  static AbsenceCubit of(BuildContext context) => BlocProvider.of(context);
  late Section section;
  late final List<TextEditingController> controllers = [];
  late int sectionIndex;

  initial() {
    emit(AbsenceInitial());
  }

  selectSection({required int sectionIndex}) {
    emit(AbsenceLoadingState());
    // save current section index and section
    this.sectionIndex = sectionIndex;
    section = SectionsBox.getSection(index: sectionIndex);

    // clear old controllers and add new controllers
    controllers.clear();
    controllers.addAll(
      List.generate(
        section.employees.length,
        (index) => TextEditingController(
          text: section.employees[index].name,
        ),
      ),
    );
    emit(AbsenceSuccessState());
  }

  changeEmployeeName({
    required String name,
    required int employeeIndex,
  }) {
    emit(AbsenceLoadingState());
    section.employees[employeeIndex].changeName(name);
    controllers[employeeIndex].text = name;
    _fixedDays();
    _fixedEmployee();
    SectionsBox.editSection(
      index: sectionIndex,
      section: section,
    );
    emit(AbsenceSuccessState());
  }

  changeDayState({
    required int employeeIndex,
    required int dayIndex,
  }) {
    emit(AbsenceLoadingState());
    section.employees[employeeIndex].nextDayState(dayIndex);
    _fixedDays();
    _fixedEmployee();
    SectionsBox.editSection(
      index: sectionIndex,
      section: section,
    );
    emit(AbsenceSuccessState());
  }

  _fixedDays() {
    for (int day = 0; day < section.employees.first.daysStates.length; day++) {
      bool isEmpty = true;
      for (var employee in section.employees) {
        if (employee.daysStates[day] != null) {
          isEmpty = false;
          break;
        }
      }
      if (isEmpty) {
        if (day != section.employees.first.daysStates.length - 1) {
          for (int i = 0; i < section.employees.length; i++) {
            section.employees[i].daysStates.removeAt(day);
          }
        }
      } else {
        if (day == section.employees.first.daysStates.length - 1) {
          for (int i = 0; i < section.employees.length; i++) {
            section.employees[i].addNewDay();
          }
        }
      }
    }
  }

  _fixedEmployee() {
    for (int i = 0; i < section.employees.length; i++) {
      bool isEmpty = section.employees[i].name.isEmpty;
      for (var day in section.employees[i].daysStates) {
        if (day != null) {
          isEmpty = false;
          break;
        }
      }
      if (isEmpty) {
        if (i != section.employees.length - 1) {
          section.employees.removeAt(i);
          controllers.removeAt(i);
        }
      } else {
        if (i == section.employees.length - 1) {
          section.addNewEmployee(
              initialDays: section.employees.first.daysStates.length);
          controllers.add(TextEditingController());
        }
      }
    }
  }
}
