tableextension 55012 "WDC Finance Cue" extends "Sales Cue"
{
    fields
    {
        field(55000; "Total Employees"; Integer)
        {
            CaptionML = ENU = 'Total Employees', FRA = 'Total employés';
            fieldClass = FlowField;
            CalcFormula = count(Employee);
        }
        field(55001; "CDI Employees"; Integer)
        {
            CaptionML = ENU = 'CDI Employees', FRA = 'Employés en CDI';
            fieldClass = FlowField;
            CalcFormula = Count(Employee where("Employee Contract Type" = const("CDI")));
        }
        field(55002; "CDD Employees"; Integer)
        {
            CaptionML = ENU = 'CDD Employees', FRA = 'Employés en CDD';
            fieldClass = FlowField;
            CalcFormula = Count(Employee where("Employee Contract Type" = const("CDD")));
        }
        field(55003; "SIVP Employees"; Integer)
        {
            CaptionML = ENU = 'SIVP Employees', FRA = 'Employés en SIVP';
            fieldClass = FlowField;
            CalcFormula = count(employee where("Employee Contract Type" = FILTER(3 | 4 | 5)));
        }
        field(55004; "Inactive Employees"; Integer)
        {
            CaptionML = ENU = 'Inactive Employees', FRA = 'Employés inactifs';
            fieldClass = FlowField;
            CalcFormula = count(employee where(Status = const(Inactive)));
        }
        field(55005; "Hours Employees"; Integer)
        {
            CaptionML = ENU = 'Hours Employees', FRA = 'Employés horaires';
            fieldClass = FlowField;
            CalcFormula = count(employee where("Employee type" = const("Hour based")));
        }
        field(55006; "Month Employees"; Integer)
        {
            CaptionML = ENU = 'Month Employees', FRA = 'Employés mensuels';
            fieldClass = FlowField;
            CalcFormula = count(employee where("Employee type" = const("Month based")));
        }


    }
}
