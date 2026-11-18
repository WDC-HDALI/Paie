table 55021 "WDC Employee's days off Entry"
{
    CaptionML = ENG = 'Employee''s days off Entry', FRA = 'Entrée des jours de congé pour l''employé';
    DrillDownPageID = 55020;
    LookupPageID = 55020;

    fields
    {
        field(1; "Transaction No."; Integer)
        {
            CaptionML = ENG = 'Transaction No.', FRA = 'N° Transaction';
        }
        field(2; "Entry No."; Integer)
        {
            CaptionML = ENG = 'Entry No.', FRA = 'N° Séquence';

        }
        field(3; "Employee No."; Code[20])
        {
            CaptionML = ENG = 'Employee No.', FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(4; "From Date"; Date)
        {
            CaptionML = ENG = 'From Date', FRA = 'Date de début';
        }
        field(5; "To Date"; Date)
        {
            Editable = true;
            CaptionML = ENG = 'To Date', FRA = 'Date de fin';
        }
        field(6; "Cause of Absence Code"; Code[20])
        {
            CaptionML = ENG = 'Cause of Absence Code', FRA = 'Code motif absence';
            TableRelation = "Cause of Absence";
        }
        field(7; Description; Text[60])
        {
            CaptionML = ENG = 'Description', FRA = 'Description';
        }
        field(8; Quantity; Decimal)
        {
            CaptionML = ENG = 'Quantity', FRA = 'Quantité';
            DecimalPlaces = 0 : 5;
        }
        field(9; Unit; Enum "WDC Work Unit")
        {
            CaptionML = ENG = 'Unit', FRA = 'Unité';
        }
        field(10; "Impute on days off"; Boolean)
        {
            CaptionML = ENG = 'Impute on days off', FRA = 'Imputer sur jours de repo';
        }
        field(11; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST("Confidential Information"),
                                                                     "Table Line No." = FIELD("Entry No."),
                                                                     "No." = FIELD("Employee No.")));
            CaptionML = ENG = 'Comment', FRA = 'Commentaire';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Posting Month"; Enum "WDC Payroll Month")
        {
            CaptionML = ENG = 'Posting Month', FRA = 'Mois d''imputation';
        }
        field(13; "Posting year"; Integer)
        {
            CaptionML = ENG = 'Posting year', FRA = 'Annéé d''imputation';
        }
        field(14; "Line type"; Enum "WDC Absence Type")
        {
            CaptionML = ENG = 'Line type', FRA = 'Type de ligne';
        }
        field(15; "Quantity (Days)"; Decimal)
        {
            CaptionML = ENG = 'Quantity (Days)', FRA = 'Quantité(jours)';
        }
        field(16; "Quantity (Hours)"; Decimal)
        {
            CaptionML = ENG = 'Quantity (Hours)', FRA = 'Quantité (Heures)';
            DecimalPlaces = 0 : 2;
        }
        field(17; "Payment No."; Code[20])
        {
            CaptionML = ENG = 'Payment No.', FRA = 'N° paie';
        }
        field(18; "Employee Posting Group"; Code[20])
        {
            TableRelation = "WDC Employee Posting Group";
            CaptionML = ENG = 'Employee Posting Group', FRA = 'Groupe compta. salarié';

        }
        field(19; "Global dimension 1"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENG = 'Global dimension 1', FRA = 'Axe analytique 1';
        }
        field(20; "Global dimension 2"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENG = 'Global dimension 2', FRA = 'Axe analytique 2';
        }
        field(21; "Starting Time"; Time)
        {
            CaptionML = ENG = 'Starting Time', FRA = 'Heure Début';
        }
        field(22; "Ending Time"; Time)
        {
            CaptionML = ENG = 'Ending Time', FRA = 'Heure fin';
        }
        field(23; "To Account"; Boolean)
        {
            CaptionML = ENG = 'To Account', FRA = 'à Comptabiliser';
        }
        field(24; Management; Code[20])
        {
            TableRelation = "WDC Management";
            CaptionML = ENG = 'Direction', FRA = 'Direction';
        }
        field(25; Service; Code[20])
        {
            CaptionML = ENG = 'Service', FRA = 'Service';
        }
        field(26; Section; Code[20])
        {
            CaptionML = ENG = 'Section', FRA = 'Section';

        }
        field(27; Week; Integer)
        {
            CaptionML = ENG = 'Week', FRA = 'Semaine';
        }
        field(28; "Is Sanction"; Boolean)
        {
            CaptionML = ENG = 'Is Sanction"', FRA = 'Sanction';
        }
        field(29; "Temporary Worker"; Code[20])
        {
            CaptionML = ENG = 'Temporary Worker"', FRA = 'Intérimaire';
            TableRelation = Employee;
        }
        field(30; "User ID"; Code[22])
        {
            Editable = false;
            TableRelation = User;
            CaptionML = ENG = 'User ID', FRA = 'ID utilisateur';
        }
        field(31; "Last Modified Date"; Date)
        {
            CaptionML = ENG = 'Last Modified Date', FRA = 'Date de dernière modification';
            Editable = false;
        }
        field(32; "Absence Reason"; Enum "WDC Absence Reason")
        {
            CaptionML = ENG = 'Absence Reason', FRA = 'Motif D''absence';
        }
        field(33; Correction; Boolean)
        {
            CaptionML = ENG = 'Correction', FRA = 'Correction';
        }
        field(34; "Line amount"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENG = 'Line Amount', FRA = 'Montant Ligne';
        }
        field(35; "Authorization Entry No."; Integer)
        {
            CaptionML = ENG = 'Authorization Entry No.', FRA = 'Entry No. Autorisation';
        }
        field(36; "Validity Date"; Date)
        {
            CaptionML = ENG = 'Validity Date', FRA = 'Date Validité';
        }
        field(37; "Recovery Entry No."; Integer)
        {
            CaptionML = ENG = '"Recovery Entry No."', FRA = 'N° récuperation';
        }
        field(38; "Number of Recovery Hours"; Decimal)
        {
            CalcFormula = Sum("WDC Employee's days off Entry"."Quantity (Hours)" WHERE("Line type" = FILTER("Recovery Right" | "Recovery Consumption"),
                                                                                    "Employee No." = FIELD("Employee No."),
                                                                                    "Authorization Entry No." = field("Authorization Entry No.")));
            FieldClass = FlowField;
            CaptionML = ENG = 'Number of Recovery Hours', FRA = 'Nbre Heures recup';

        }
        field(39; Name; Text[100])
        {
            Editable = false;
            CaptionML = ENG = 'Name', FRA = 'Nom';
        }
        field(40; "First Name"; Text[100])
        {
            Editable = false;
            CaptionML = ENG = 'First Name', FRA = 'Prénom';
        }
        field(41; "Site Seq. No."; Integer)
        {
            CaptionML = ENG = 'Site Seq. No.', FRA = 'N° seq Chantier';
        }
        field(42; "Transferred Days"; Boolean)
        {
            CaptionML = ENG = 'Transferred Days', FRA = 'Jours trans';
        }
        field(43; "Employee Statistic Group"; Code[20])
        {
            TableRelation = "Employee Statistics Group";
            CaptionML = ENG = 'Employee Statistic Group', FRA = 'Groupe statistique des employés';
        }
        field(44; Fortnight; Enum "WDC Fortnight")
        {
            CaptionML = ENU = 'Fortnight', FRA = 'Quainzaine';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting year", "Posting month", "From Date", "Line type", "Entry No.")
        {
        }
        key(Key3; "Transaction No.", "Entry No.", "Employee No.")
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key4; "Cause of Absence Code", "To Date")
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key5; "Line type", "Employee No.", "To Date")
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key6; "Employee No.", "Posting month", "Posting year", "Line type", "Payment No.", "From Date", "To Date")
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Quantity (Hours)";
        }
        key(Key7; "Employee Posting Group", "Employee No.", "Global dimension 1", "Global dimension 2", "Line type", "Posting month", "Posting year", "Payment No.")
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key8; "Line type", "Employee No.", "Posting month", "Posting year", "Payment No.")
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Line amount", "Quantity (Hours)";
        }
        key(Key9; "Line type", "Employee No.", "From Date", "To Date", "Starting Time")
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key10; "Line type", "Employee No.", "From Date", "To Date", "Starting Time", "Ending Time")
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key11; "Posting year", "Line type", "Cause of Absence Code", "Employee No.")
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key12; "Employee No.", "Posting year", "Posting month", "Line type", "Impute on days off")
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key13; "Authorization Entry No.", "Entry No.")
        {
        }
        key(Key14; "Employee No.", "From Date", Management, "Cause of Absence Code", "Entry No.")
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key15; "Employee No.", "Line type", "From Date")
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Quantity (Hours)";
        }
        key(Key16; "Line type", "Employee No.", "Validity Date", "Entry No.")
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Quantity (Hours)";
        }
        key(Key17; "Line type", "Employee No.", "Authorization Entry No.")
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Quantity (Hours)";
        }
        key(Key18; "Employee No.", "Posting year", "Posting month", "Cause of Absence Code", "Absence Reason")
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Quantity (Hours)";
        }
        key(Key19; "Employee No.", "Line type", "Validity Date")
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Quantity (Hours)";
        }
        key(Key20; "Employee No.", "Posting year", "Transaction No.", "Line type")
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Quantity (Hours)";
        }
        key(Key21; "Employee No.", "Posting month", "Posting year", Quantity)
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Quantity (Hours)";
        }
        key(Key22; "Cause of Absence Code", "Transaction No.", "Entry No.", "Employee No.", "From Date", "To Date")
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Quantity (Hours)";
        }
        key(Key23; "Employee No.", "From Date", "Line type")
        {
        }
        key(Key24; "Employee No.", "From Date", "Absence Reason")
        {
        }
        key(Key25; "Employee No.", "Posting year", "Posting month", "Absence Reason")
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Quantity (Hours)";
        }
        key(Key26; "Site Seq. No.", "Entry No.")
        {
        }
        key(Key27; "Employee No.", "Posting year", "Posting month", "Absence Reason", Week, Fortnight)
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key28; "Employee No.", "Posting year", "Cause of Absence Code", "Posting month")
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key29; "Employee Statistic Group", "Line type", "Posting year", "Posting month")
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
        key(Key30; "Line type", "Employee No.", "Posting month", "Posting year", Fortnight)
        {
            SumIndexFields = Quantity, "Quantity (Days)", "Line amount", "Quantity (Hours)";
        }
        key(Key31; "Employee No.", "Posting month", "Posting year", "Absence Reason")
        {
            SumIndexFields = "Line amount";
        }
        key(Key32; "Line type", "Employee No.", "Posting month", "Posting year", Fortnight, "Absence Reason", Unit)
        {
            SumIndexFields = "Line amount", Quantity, "Quantity (Days)", "Quantity (Hours)";
        }
        key(Key33; "Employee No.", "Posting year", "Posting month", "Line type", Week)
        {
            SumIndexFields = Quantity, "Quantity (Days)";
        }
    }

}

