table 55014 "WDC Loan & Advance Entry"
{
    CaptionML = ENU = 'Loan & Advance Entry', FRA = 'Ecritures Prêt & Avance';
    // DrillDownPageID = 52078224;
    //LookupPageID = 52078224;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° employé';
            Editable = false;
            TableRelation = Employee;
        }
        field(3; Name; Text[100])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';
            Editable = false;
        }
        field(4; "Employee Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe compta. employé';
            Editable = false;
            TableRelation = "WDC Employee Posting Group";
        }
        field(5; Type; Enum "WDC Loan & Advance Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';
            Editable = true;
        }
        field(6; "Document type"; Code[20])
        {
            CaptionML = ENU = 'Document type', FRA = 'Type document';
            Editable = true;
            TableRelation = "WDC Loan & Advance Type" WHERE(Type = FIELD(Type));
        }
        field(7; "Entry type"; Enum "WDC Loan Advance entry Type")
        {
            CaptionML = ENU = 'Entry type', FRA = 'Type entrée';
        }
        field(10; Amount; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Amount', FRA = 'Montant';
            Editable = true;
        }
        field(20; Status; Enum "WDC Status")
        {
            CaptionML = ENU = 'Status', FRA = 'Statut';
        }
        field(21; Month; Enum "WDC Payroll Month")
        {
            CaptionML = ENU = 'Month', FRA = 'Mois';
            Editable = false;
        }
        field(22; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';
            Editable = false;
        }
        field(23; "Payroll Date"; Date)
        {
            CaptionML = ENU = 'Payroll Date', FRA = 'Date paie';
        }
        field(25; "Payment No."; Code[20])
        {
            CaptionML = ENU = 'Payment No.', FRA = 'N° paiement';
            Editable = true;
        }
        field(30; "Global dimension 1"; Code[20])
        {
            CaptionML = ENU = 'Global dimension 1', FRA = 'Code département';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(31; "Global dimension 2"; Code[20])
        {
            CaptionML = ENU = 'Global dimension 2', FRA = 'Code dossier';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(8099197; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', FRA = 'N° séquence';
        }
        field(39001495; "Meal Advance"; Boolean)
        {
            CaptionML = ENU = 'Meal Advance', FRA = 'Avance repas';
        }
        field(39001496; "Employee Statistic Group"; Code[30])
        {
            CaptionML = ENU = 'Employee Statistic Group', FRA = 'Groupe statistique employé';
            Editable = false;
            TableRelation = Employee;
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
        }
        key(Key2; Status, Type, "Employee No.", "Global dimension 1", "Global dimension 2")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Document type", "Employee Posting Group", "Employee No.", "Global dimension 1", "Global dimension 2")
        {
            SumIndexFields = Amount;
        }
        key(Key5; "No.", "Employee No.", "Entry No.")
        {
        }
    }

}

