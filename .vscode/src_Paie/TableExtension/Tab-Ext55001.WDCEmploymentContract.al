tableextension 55001 "WDC Employment Contract" extends "Employment Contract"
{
    fields
    {
        modify(Code)
        {
            trigger OnAfterValidate()
            var
                lEmployee: Record Employee;
            begin
                IF Employee.GET(Code) THEN BEGIN
                    Rec.Description := Employee."First Name" + ' ' + Employee."Last Name";
                END;
            end;
        }

        field(55000; "Employee Contract Type"; Enum "WDC Employees type Contract")
        {
            CaptionML = ENU = 'Employees type Contract', FRA = 'Type contrat employé';
            trigger OnValidate()
            begin
                IF (("Employee Contract Type" <> "Employee Contract Type"::CDD) AND
                   ("Employee Contract Type" <> "Employee Contract Type"::CDI)) THEN
                    Rec.Taxable := FALSE
                ELSE
                    Rec.Taxable := TRUE;
            end;
        }
        field(51000; "Regular payments"; Integer)
        {
            CaptionML = ENU = 'Regular payments', FRA = 'Paiements réguliers';
        }
        field(51001; "Temporary payments"; Decimal)
        {
            CaptionML = ENU = 'Temporary payments', FRA = 'Paiements temporaires';
        }
        field(51003; "Adjust indemnity amount"; Boolean)
        {
            CaptionML = ENU = 'Adjust indemnity amount', FRA = 'Ajuster le montant l''indemnité';
        }
        field(51004; "Employee Type"; Enum "WDC Employee type")
        {
            CaptionML = ENU = 'Employee type', FRA = 'Type d''employé';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Employee type" where("No." = field(Code)));
            Editable = false;

        }
        field(51005; "Work Regime"; Code[20])
        {
            CaptionML = ENU = 'Work Regime', FRA = 'Régime travail';
            TableRelation = "WDC work Regimes".Code;

            trigger OnValidate()
            begin
                CLEAR(Regimesofwork);
                IF Regimesofwork.GET("Work Regime") THEN;
                "Calendar Type" := Regimesofwork."Calendar Type";
            end;
        }
        field(51006; "Salary grid"; Code[20])
        {
            CaptionML = ENU = 'Salary grid', FRA = 'Grille salaire';
            TableRelation = "WDC Salary grid header".Code;
        }
        field(51007; Taxable; Boolean)
        {
            CaptionML = ENU = 'Taxable', FRA = 'Imposable';
        }
        field(51008; "Take in account deductions"; Boolean)
        {
            CaptionML = ENU = 'Take in account deductions', FRA = 'Prendre en compte les déductions';
        }
        field(51009; "Taxes Calculation Mode"; Enum "WDC Taxes Calcul Type")
        {
            CaptionML = ENU = 'Taxes Calculation Mode', FRA = 'Mode calcul impôts';
        }
        field(51010; "Inclusive ratio"; Decimal)
        {
            CaptionML = ENU = 'Inclusive ratio', FRA = 'Ratio inclusif';
        }
        field(51011; "Default Employment Contract"; Boolean)
        {
            CaptionML = ENU = 'Default Employment Contract', FRA = 'Contrat travail par défaut';
        }
        field(51012; "No. Series"; Code[20])
        {
        }
        field(51015; "Calendar Type"; Enum "WDC Calendar Type")
        {
            CaptionML = ENU = 'Calendar Type', FRA = 'Type calendrier';
            trigger OnValidate()
            begin
                CLEAR("Work Regime");
            end;
        }
        field(51016; "Code Calendar"; Code[20])
        {
            CaptionML = ENU = 'Code Calendar', FRA = 'Code calendrier';

        }
        field(51019; "Slice of imposition"; Code[4])
        {
            CaptionML = ENU = 'Slice of imposition', FRA = 'Tranche d''imposition';
            TableRelation = "WDC Slices of imposition".Code;
        }
        field(51021; "Has Bonus 13"; Boolean)
        {
            CaptionML = ENU = 'Has Bonus 13', FRA = 'A Prime 13éme';
        }
    }


    var
        Regimesofwork: Record "WDC work Regimes";
        Employee: Record Employee;
        TypeEmp: Boolean;
}

