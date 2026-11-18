table 55026 "WDC Rec. Indemnities"
{
    Caption = 'Rec. Indemnities';
    DrillDownPageID = 55047;
    LookupPageID = 55047;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
            TableRelation = "WDC Posted Salary Header"."No.";
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° employé';
            TableRelation = Employee;
        }
        field(3; "Employee Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe compta. employé';
            Editable = true;
            TableRelation = "WDC Employee Posting Group";
        }
        field(4; Indemnity; Code[20])
        {
            CaptionML = ENU = 'Indemnity', FRA = 'Indemnité';
            TableRelation = "WDC Indemnity";
        }
        field(5; Description; Text[50])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
            Editable = false;
        }
        field(6; Type; Enum "WDC Indemnities Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';
            Editable = false;
        }
        field(7; "Evaluation mode"; enum "WDC Evaluation Mode")
        {
            CaptionML = ENU = 'Evaluation mode', FRA = 'Mode d''évaluation';
        }
        field(10; "Base Amount"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Base Amount', FRA = 'Montant de base';
            DecimalPlaces = 3 : 3;

            trigger OnValidate()
            begin
                "Real Amount" := "Base Amount" * Rate / 100;
            end;
        }
        field(11; "Real Amount"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Real Amount', FRA = 'Montant réel';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(12; Rate; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Ratio', FRA = 'Taux';
            Editable = false;
        }
        field(13; "Global dimension 1"; Code[20])
        {
            CaptionML = ENU = 'Code département', FRA = 'Code département';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(14; "Global dimension 2"; Code[20])
        {
            CaptionML = ENU = 'Folder Code', FRA = 'Code Dossier';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(211; "Real Amount PR"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Real Amount PR', FRA = 'Montant réel PR';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(50000; "Minimum value"; Decimal)
        {
            CaptionML = ENU = 'Minimum value', FRA = 'Valeur minimale';
            DecimalPlaces = 3 : 3;
        }
        field(50002; "Days Number"; Decimal)
        {
            CaptionML = ENU = 'Days Number', FRA = 'Nombre de jours';
        }
        field(50003; "Non-Deductible Work Accident"; Boolean)
        {
            CaptionML = ENU = 'Non-Deductible Work Accident', FRA = 'Accident de travail non déductible';
        }
        field(50005; "Tax-exempt (-5000 DT)"; Boolean)
        {
            CaptionML = ENU = 'Tax-exempt (-5000 DT)', FRA = 'Exonéré d''impôt (-5000 DT)';
        }
        field(50006; "Included Breastfeeding Hours"; Boolean)
        {
            CaptionML = ENU = 'Included Breastfeeding Hours', FRA = 'Heures d''allaitement incluses';
        }
        field(50007; "Include A.T"; Boolean)
        {
            CaptionML = ENU = 'Include A.T', FRA = 'Include A.T';
        }
        field(50008; "Included in UGTT Hours"; Boolean)
        {
            CaptionML = ENU = 'Included in UGTT Hours', FRA = 'Heures incluses dans UGTT';
        }
        field(50009; "Includes Extra Days"; Boolean)
        {
            CaptionML = ENU = 'Includes Extra Days', FRA = 'Jours supplémentaires inclus';
        }
        field(50011; "Allait-UGTT-ATECH"; Decimal)
        {
            CaptionML = ENU = 'Allait-UGTT-ATECH', FRA = 'Allait-UGTT-ATECH';
        }
        field(50050; Numero; Integer)
        {
            CaptionML = ENU = 'Number', FRA = 'Numéro';
        }
        field(50051; Numero1; Integer)
        {
            CaptionML = ENU = 'Number 1', FRA = 'Numéro 1';
        }
        field(50052; "Indemnity Account No."; Code[20])
        {
            CaptionML = ENU = 'Indemnity Account No.', FRA = 'N° Compte d''indemnité';
            TableRelation = "G/L Account";
        }
        field(50053; "Indemnity Balance Account No."; Code[20])
        {
            CaptionML = ENU = 'Indemnity Balance Account No.', FRA = 'N° Compte contrepartie indemnité';
            TableRelation = "G/L Account";
        }
        field(50090; Month; Enum "WDC Payroll Month")
        {
            CaptionML = ENU = 'Month', FRA = 'Mois';
        }
        field(39001431; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';
        }
        field(39001441; "Indemnity Type"; enum "WDC Indemnity Type")
        {
            CaptionML = ENU = 'Indemnity Type', FRA = 'Type d''indemnité';
        }
        field(39001450; "Integrated into accounting"; Boolean)
        {
            CaptionML = ENU = 'Integrated into accounting', FRA = 'Intégré à la comptabilité';
        }
        field(39001451; "Not Included in Bonus"; Boolean)
        {
            CaptionML = ENU = 'Not Included in Bonus', FRA = 'Non inclus dans la prime';
        }
        field(39001460; "Amount Rounding Precision"; Decimal)
        {
            CaptionML = ENU = 'Amount Rounding Precision', FRA = 'Précision arrondi montant';
            DecimalPlaces = 0 : 5;
        }
        field(39001461; "Rounding Direction"; Enum "WDC Arround Type")
        {
            CaptionML = ENU = 'Rounding Direction', FRA = 'Sens arrondi';
        }
        field(39001462; "Employee Statistic Group"; Code[30])
        {
            CaptionML = ENU = 'Employee statistic Group', FRA = 'Groupe statistique employé';
            Editable = true;
            TableRelation = "Employee Statistics Group";
        }
        field(39001463; Management; Code[20])
        {
            CaptionML = ENU = 'Management', FRA = 'Direction';
        }
        field(39001464; Service; Code[20])
        {
            CaptionML = ENU = 'Service', FRA = 'Service';
        }
        field(39001465; Section; Code[20])
        {
            CaptionML = ENU = 'Section', FRA = 'Section';
        }
        field(39001466; "Not included in vacation days"; Boolean)
        {
            CaptionML = ENU = 'Not included in vacation days', FRA = 'Non inclus dans les jours congé';
        }
        field(39001467; "Benefit in Kind"; Boolean)
        {
            CaptionML = ENU = 'Benefit in Kind', FRA = 'Avantage en nature';
        }
    }

    keys
    {
        key(Key1; "No.", "Employee No.", Indemnity)
        {
            Clustered = true;
            SumIndexFields = "Real Amount";
        }
        key(Key2; "Employee Posting Group", Type, "No.", "Employee No.", "Global dimension 1", "Global dimension 2")
        {
            SumIndexFields = "Real Amount";
        }
        key(Key3; Indemnity, "Global dimension 1", "Global dimension 2")
        {
            SumIndexFields = "Real Amount";
        }
        key(Key4; Indemnity, "Employee Posting Group", "Global dimension 1", "Global dimension 2")
        {
            SumIndexFields = "Real Amount";
        }
        key(Key5; "Employee Posting Group", "Global dimension 1", "Global dimension 2", Indemnity, "Indemnity Balance Account No.")
        {
            SumIndexFields = "Real Amount";
        }
        key(Key6; "No.", "Employee No.", "Not Included in Bonus", "Indemnity Type", Type)
        {
            SumIndexFields = "Real Amount", "Real Amount PR";
        }
        key(Key7; "Employee Statistic Group", Type, "No.")
        {
            SumIndexFields = "Real Amount", "Real Amount PR";
        }
        key(Key8; "Indemnity Balance Account No.", "Indemnity Account No.")
        {
            SumIndexFields = "Real Amount", "Real Amount PR";
        }
        key(Key9; "Employee Posting Group", "Global dimension 1", "Global dimension 2", "Indemnity Account No.")
        {
            SumIndexFields = "Real Amount", "Real Amount PR";
        }
    }

}

