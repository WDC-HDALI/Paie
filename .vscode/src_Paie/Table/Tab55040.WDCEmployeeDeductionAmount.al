table 55040 "WDC Employee Deduction Amount"
{
    DrillDownPageID = 55057;
    LookupPageID = 55057;
    CaptionML = ENU = 'Employee Deduction Amount', FRA = 'Montant retenue salarié';
    fields
    {
        field(1; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
            CaptionML = ENU = 'Employee No.', FRA = 'N° employé';
        }
        field(3; "Code"; Code[20])
        {
            TableRelation = "WDC Life Insurance Type".Code;
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(4; Amount; Decimal)
        {
            DecimalPlaces = 3 : 3;
            CaptionML = ENU = 'Amount', FRA = 'Montant';

            trigger OnValidate()
            var
                lAssType: Record "WDC Life Insurance Type";
                lText001: TextConst ENU = 'Please, check the amount',
                                    FRA = 'Veuillez,vérifier le montant';
            begin
                lAssType.RESET;
                lAssType.SETRANGE(Code, Code);
                IF lAssType.Findfirst() THEN
                    IF Amount > lAssType."Maximum Amount" THEN
                        ERROR(lText001);

            end;
        }
        field(5; "First Name"; Text[100])
        {
            CalcFormula = Lookup(Employee."First Name" WHERE("No." = FIELD("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
            CaptionML = ENU = 'First Name', FRA = 'Prénom';
        }
        field(6; "Last Name"; Text[100])
        {
            CalcFormula = Lookup(Employee."Last Name" WHERE("No." = FIELD("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
            CaptionML = ENU = 'Last Name', FRA = 'Nom';
        }
    }

    keys
    {
        key(Key1; Year, "Employee No.", "Code")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.")
        {
            SumIndexFields = Amount;
        }
    }


}

