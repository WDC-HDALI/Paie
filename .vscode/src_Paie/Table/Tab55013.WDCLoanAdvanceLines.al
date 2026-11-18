table 55013 "WDC Loan & Advance Lines"
{
    CaptionML = ENU = 'Loan & Advance Lines', FRA = 'Lignes Prêt & Avance';
    DrillDownPageID = 55027;
    LookupPageID = 55027;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
            TableRelation = "WDC Loan & Advance Header"."No.";
        }
        field(2; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', FRA = 'N° ligne';
        }
        field(3; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° employé';
            TableRelation = Employee;
        }
        field(5; "Employee Posting Group"; Code[30])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe compta. employé';
            Editable = false;
            TableRelation = "WDC Employee Posting Group";
        }
        field(6; Type; Enum "WDC Loan & Advance Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';
        }
        field(7; "Document type"; Code[20])
        {
            CaptionML = ENU = 'Document type', FRA = 'Type document';
            TableRelation = "WDC Loan & Advance Type" WHERE(Type = FIELD(Type));
        }
        field(10; "Line Amount"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Line Amount', FRA = 'Montant ligne';

            trigger OnValidate()
            begin
                IF LoanAdvanceHeader.GET("No.") THEN BEGIN
                    "Line %" := ("Line Amount" / LoanAdvanceHeader."Total to repay") * 100
                END
            end;
        }
        field(11; "Line %"; Decimal)
        {
            CaptionML = ENU = 'Line %', FRA = '% ligne';

            trigger OnValidate()
            begin
                IF LoanAdvanceHeader.GET("No.") THEN BEGIN
                    "Line Amount" := ("Line %" * LoanAdvanceHeader."Total to repay") / 100
                END
            end;
        }
        field(20; Status; Enum "WDC Status")
        {
            CaptionML = ENU = 'Status', FRA = 'Statut';
            Editable = true;
        }
        field(21; Month; Enum "WDC Payroll Month")
        {
            CaptionML = ENU = 'Month', FRA = 'Mois';
        }
        field(22; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';
            Editable = true;
        }
        field(23; "Payroll Date"; Date)
        {
            CaptionML = ENU = 'Payroll Date', FRA = 'Date paie';
        }
        field(30; "Payment No."; Code[20])
        {
            CaptionML = ENU = 'Payment No.', FRA = 'N° paiement';
            Editable = true;
            TableRelation = IF (Paid = FILTER(false)) "WDC Salary Header"
            ELSE IF (Paid = FILTER(true)) "WDC Posted Salary Header";
        }
        field(31; Paid; Boolean)
        {
            CaptionML = ENU = 'Paid', FRA = 'Payé';
            Editable = false;
        }
        field(32; "Global dimension 1"; Code[20])
        {
            CaptionML = ENU = 'Global dimension 1', FRA = 'Code département';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(33; "Global dimension 2"; Code[20])
        {
            CaptionML = ENU = 'Global dimension 2', FRA = 'Code dossier';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50; "Principal Amount"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Principal Amount', FRA = 'Montant principal';
        }
        field(51; "Interest Amount"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Interest Amount', FRA = 'Montant d''intérêt';
        }
        field(50002; "Type Tranche"; Enum "WDC Slice Type")
        {
            CaptionML = ENU = 'Tranche Type', FRA = 'Type de tranche';
        }
        field(50050; Number; Integer)
        {
            CaptionML = ENU = 'Number', FRA = 'Numéro';
        }

        field(39001405; "Account Type"; Enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Account Type', FRA = 'Type de compte';
        }
        field(39001406; "Account No."; Code[20])
        {
            CaptionML = ENU = 'Account No.', FRA = 'N° compte';
        }
        field(39001407; "External Document No."; Code[20])
        {
            CaptionML = ENU = 'External Document No.', FRA = 'N° document externe';
        }

        field(39001408; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
        }
        field(39001495; "Meal Advance"; Boolean)
        {
            CaptionML = ENU = 'Meal Advance', FRA = 'Avance repas';
        }
        field(39001496; "Employee Statistic Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Statistic Group', FRA = 'Groupe statistique employé';
            Editable = false;
            TableRelation = "Employee Statistics Group";
        }
        field(39001497; Management; Code[20])
        {
            CaptionML = ENU = 'Management', FRA = 'Direction';
        }
        field(39001498; Service; Code[20])
        {
            CaptionML = ENU = 'Service', FRA = 'Service';
        }
        field(39001499; Section; Code[20])
        {
            CaptionML = ENU = 'Section', FRA = 'Section';
        }
    }

    keys
    {
        key(Key1; "No.", "Entry No.")
        {
            Clustered = true;
            SumIndexFields = "Line Amount", "Line %";
        }
        key(Key2; "Document type", "Employee Posting Group", "Payment No.", Status, Type, "Employee No.", "Global dimension 1", "Global dimension 2", "Employee Statistic Group")
        {
            SumIndexFields = "Line Amount", "Line %";
        }
        key(Key3; "Payment No.", Status, Type, "Employee No.")
        {
            SumIndexFields = "Line Amount", "Line %";
        }
        key(Key4; "No.", Status, Type, "Employee No.")
        {
            SumIndexFields = "Line Amount", "Line %", "Principal Amount", "Interest Amount";
        }
        key(Key5; "Payment No.", Paid, "Employee No.")
        {
            SumIndexFields = "Line Amount", "Line %", "Principal Amount", "Interest Amount";
        }
        key(Key6; "No.", Status, Type, "Employee No.", Paid)
        {
            SumIndexFields = "Line Amount", "Line %", "Principal Amount", "Interest Amount";
        }
        key(Key7; "Document type", "Global dimension 1", "Global dimension 2", "Employee No.")
        {
            SumIndexFields = "Line Amount", "Line %", "Principal Amount", "Interest Amount";
        }
        key(Key8; "No.", "Employee No.", Paid)
        {
            SumIndexFields = "Line Amount", "Line %", "Principal Amount", "Interest Amount";
        }
        key(Key9; "No.", "Document type", Paid)
        {
            SumIndexFields = "Line Amount", "Line %", "Principal Amount", "Interest Amount";
        }
        key(Key10; "No.", "Employee No.", Status, Type, Paid, "Entry No.")
        {
            SumIndexFields = "Line Amount", "Line %", "Principal Amount", "Interest Amount";
        }
        key(Key11; Type, "Payment No.", "Employee No.", "Employee Posting Group", Month, Year, "Global dimension 1", "Global dimension 2", "Document type", "Employee Statistic Group")
        {
            SumIndexFields = "Line Amount", "Line %", "Principal Amount", "Interest Amount";
        }
        key(Key12; "Employee No.", Type, "Posting Date")
        {
        }
    }


    trigger OnInsert()
    var
    begin
        IF LoanAdvanceHeader.GET("No.") THEN BEGIN
            LoanAdvanceHeader.CALCFIELDS("Repaid amount", "Repaid %");
        END
    end;

    trigger OnModify()
    begin

        IF LoanAdvanceHeader.GET("No.") THEN BEGIN
            LoanAdvanceHeader.CALCFIELDS("Repaid amount", "Repaid %");
        END
    end;


    var
        LoanAdvanceHeader: Record "WDC Loan & Advance Header";
        RecGEmploy: Record Employee;


    procedure FullName(): Text[100]
    begin
        RecGEmploy.RESET;
        IF RecGEmploy.GET("Employee No.") THEN
            IF RecGEmploy."Middle Name" = '' THEN
                EXIT(RecGEmploy."First Name" + ' ' + RecGEmploy."Last Name")
            ELSE
                EXIT(RecGEmploy."First Name" + ' ' + RecGEmploy."Middle Name" + ' ' + RecGEmploy."Last Name");
    end;
}

