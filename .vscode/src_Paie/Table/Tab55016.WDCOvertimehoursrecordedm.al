table 55016 "WDC Overtime hours recorded m"
{
    DrillDownPageID = 55030;
    LookupPageID = 55030;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° employé';
            TableRelation = Employee."No.";
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', FRA = 'N° ligne';
        }
        field(3; "Last Name"; Text[100])
        {
            CaptionML = ENU = 'Last Name', FRA = 'Nom';
        }
        field(4; "First Name"; Text[100])
        {
            CaptionML = ENU = 'First Name', FRA = 'Prénom';
        }
        field(7; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date de comptabilisation';
            NotBlank = true;
        }
        field(10; "Department Code"; Code[20])
        {
            CaptionML = ENU = 'Department Code', FRA = 'Code département';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(11; "Folder Code"; Code[20])
        {
            CaptionML = ENU = 'Folder Code', FRA = 'Code dossier';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Starting Time"; Time)
        {
            CaptionML = ENU = 'Starting Time', FRA = 'Heure de départ';
        }
        field(16; "Ending Time"; Time)
        {
            CaptionML = ENU = 'Ending Time', FRA = 'Heure de fin';
        }
        field(20; "Hours Number"; Decimal)
        {
            CaptionML = ENU = 'Hours Number', FRA = 'Nombre heures';
        }
        field(21; "Unit Tariff"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Unit Price', FRA = 'Tarif unitaire';
        }
        field(22; "Line amount"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Line amount', FRA = 'Montant ligne';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        // field(40; "Posting Date"; Date)
        // {
        //     Caption = 'Posting Date';
        // }
        field(50; "Transaction No."; Integer)
        {
            CaptionML = ENU = 'Transaction No.', FRA = 'N° transaction';
        }
        field(60; "Payment Month"; Enum "WDC Payroll Month")
        {
            CaptionML = ENU = 'Payment month', FRA = 'Mois paiement';
        }
        field(61; "Payment Year"; Integer)
        {
            CaptionML = ENU = 'Payment year', FRA = 'Année paiement';
        }
        field(70; "Day Type"; Enum "WDC Days Type")
        {
            CaptionML = ENU = 'Day Type', FRA = 'Type jour';
        }
        field(80; "Employee Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe compta. salarié';
            TableRelation = "WDC Employee Posting Group";
        }
        field(200; "System"; Boolean)
        {
            CaptionML = ENU = 'System', FRA = 'Système';
        }
        field(300; "Payment No."; Code[20])
        {
            CaptionML = ENU = 'Payment No.', FRA = 'N° paiement';
        }
        field(50000; "Overtime Rate"; Decimal)
        {
            CaptionML = ENU = 'Overtime Rate', FRA = 'Taux de majoration';
        }
        field(50012; Week; Integer)
        {
            CaptionML = ENU = 'Week', FRA = 'Semaine';
        }
        field(50020; Management; Code[20])
        {
            CaptionML = ENU = 'Management', FRA = 'Direction';
        }
        field(50021; Service; Code[20])
        {
            CaptionML = ENU = 'Service', FRA = 'Service';
        }
        field(50022; Section; Code[20])
        {
            CaptionML = ENU = 'Section', FRA = 'Section';
        }
        field(50050; Number; Integer)
        {
            CaptionML = ENU = 'Number', FRA = 'Nombre';
        }
        field(39001450; "Hour Type"; Enum "WDC Hours work Type")
        {
            CaptionML = ENU = 'Hour Type', FRA = 'Type heure';
        }
        field(39001451; "Employee Statistic Group"; Code[30])
        {
            CaptionML = ENU = 'Employee Statistic Group', FRA = 'Groupe statistique empployé';
            Editable = true;
            TableRelation = "Employee Statistics Group";
        }

        field(39001490; Fortnight; Enum "WDC Fortnight")
        {
            CaptionML = ENU = 'Fortnight', FRA = 'Quinzaine';
        }
    }

    keys
    {
        key(Key1; "Transaction No.", "Line No.", "Employee No.")
        {
            Clustered = true;
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key2; "Employee No.", "Department Code", "Folder Code", "Posting Date", "Day Type")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key3; "Employee No.", "Payment Month", "Payment Year", "Posting Date", "Payment No.")
        {
            SumIndexFields = "Line amount", "Hours Number";
        }
        key(Key4; "Overtime Rate")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key5; "Employee No.")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key6; "Employee No.", "Overtime Rate", "Payment Month", "Payment Year", Fortnight)
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key7; "Employee No.", "Payment Month", "Payment Year", "Hour Type")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key8; "Employee No.", "Posting Date", "Day Type", "Hour Type", "Department Code", "Folder Code")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key9; "Payment No.", "Employee Posting Group", "Transaction No.", "Employee No.")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key10; "Payment No.", "Employee Posting Group", "Department Code", "Folder Code", "Employee No.")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key11; "Payment Year", "Payment Month", "Payment No.")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key12; "Payment Year", "Payment Month", "Payment No.", "Department Code", "Folder Code", "Employee Posting Group")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key13; "Employee No.", "Posting Date", "Day Type", "Overtime Rate")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key14; "Employee No.", "Payment Month", "Posting Date", "Day Type")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key15; "Employee No.", "Payment Month", "Posting Date", "Day Type", "Overtime Rate")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key16; "Payment Year", "Payment Month", "Posting Date", "Employee No.")
        {
        }
        key(Key17; "Employee Statistic Group", "Payment Year", "Payment Month", "Payment No.")
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key18; "Employee No.", "Payment Month", "Payment Year", Fortnight)
        {
            SumIndexFields = "Hours Number", "Line amount";
        }
        key(Key19; "Employee No.", "Payment Month", "Payment Year", "Posting Date", "Payment No.", "Day Type")
        {
            SumIndexFields = "Line amount", "Hours Number";
        }
        key(Key20; "Employee No.", "Payment Month", "Payment Year", "Posting Date", "Payment No.", "Day Type", "Overtime Rate")
        {
            SumIndexFields = "Line amount", "Hours Number";
        }
    }

    fieldgroups
    {
    }
}

