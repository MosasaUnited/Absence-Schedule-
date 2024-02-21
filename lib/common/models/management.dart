import 'package:absence_schedule/common/constants/keys.dart';
import 'package:absence_schedule/common/models/emoloyee.dart';
import 'package:hive/hive.dart';

part 'management.g.dart';

@HiveType(typeId: 0)
class Section {
  @HiveField(0)
  String title;
  @HiveField(1)
  late final List<Employee> employees;

  Section({
    required this.title,
    List<Employee>? employees,
  }) : employees = employees ?? List.generate(1, (_) => Employee());

  factory Section.fromJson(Map<String, dynamic> data) {
    final List<dynamic>? employeeList = data[Keys.employees];

    return Section(
      title: data[Keys.title],
      employees: employeeList != null
          ? List<Employee>.from(employeeList
              .map((employeeData) => Employee.fromJson(employeeData)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      Keys.title: title,
      Keys.employees: employees.map((employee) => employee.toJson()).toList(),
    };
  }

  changeTitle(String title) {
    this.title = title;
  }

  addNewEmployee({required int initialDays}) {
    employees.add(Employee(
      daysStates: List.generate(initialDays, (index) => null),
    ));
  }
}
