table 55007 "WDC Indemnities"
{
    CaptionML = ENG = 'Indemnities', FRA = 'Indemnities';
    DrillDownPageID = "WDC Indemnities";
    LookupPageID = "WDC Indemnities";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENG = 'No.', FRA = 'N°';
            TableRelation = "WDC Salary Header";
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENG = 'Employee No.', FRA = 'N° Employée';
            TableRelation = Employee;
        }
        field(3; "Employee Posting Group"; Code[30])
        {
            CaptionML = ENG = 'Employee Posting Group', FRA = 'Groupe compta. salarié';
            Editable = true;
            TableRelation = "WDC Employee Posting Group";
        }
        field(4; Indemnity; Code[20])
        {
            CaptionML = ENG = 'Indemnity', FRA = 'Indemnité';
            TableRelation = "WDC Indemnity";

            trigger OnValidate()
            begin
                Indemnity.RESET;
                Indemnity.GET(Rec.Indemnity);
                Description := Indemnity.Description;
                Type := Indemnity.Type;
                "Evaluation mode" := Indemnity."Evaluation mode";
                "Base Amount" := Indemnity."Default amount";
                "Minimum value" := Indemnity."Minimum value";
            end;
        }
        field(5; Description; Text[50])
        {
            CaptionML = ENG = 'Description', FRA = 'Description';
            Editable = false;
        }
        field(6; Type; Enum "WDC Indemnities Type")
        {
            CaptionML = ENG = 'Type', FRA = 'Type';

        }
        field(7; "Evaluation Mode"; Enum "WDC Evaluation Mode")
        {
            CaptionML = ENG = 'Evaluation mode', FRA = 'Mode d''évaluation';
        }
        field(8; "Base Amount"; Decimal)
        {
            AutoFormatType = 3;
            CaptionML = ENG = 'Base Amount', FRA = 'Montant de base';
            DecimalPlaces = 3 : 3;

            trigger OnValidate()
            begin
                "Real Amount" := ROUND("Base Amount" * Rate / 100, 0.001);
            end;
        }
        field(9; "Real Amount"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENG = 'Real Amount', FRA = 'Montant réel';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(10; Rate; Decimal)
        {
            CaptionML = ENG = 'Rate', FRA = 'Taux';
            DecimalPlaces = 0 : 3;
            Editable = true;
        }
        field(11; "Global Dimension 1"; Code[20])
        {
            CaptionML = ENG = 'Global Dimension 1', FRA = 'Code axe principal 1';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(12; "Global Dimension 2"; Code[20])
        {
            CaptionML = ENG = 'Global Dimension 2', FRA = 'Code axe principal 2';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(13; "Real Amount PR"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENG = 'Real Amount PR', FRA = 'Montant réel de paie';
            Editable = false;
        }
        field(14; "Minimum Value"; Decimal)
        {
            CaptionML = ENG = 'Minimum Value', FRA = 'Valeur minimale';
            DecimalPlaces = 3 : 3;
        }
        field(15; Name; Text[100])
        {
            CaptionML = ENG = 'Name', FRA = 'Nom';
        }
        field(16; "Days Number"; Decimal)
        {
            CaptionML = ENG = 'Number of days', FRA = 'Nombre de jours';
        }
        field(17; "Non-Deductible Work Accident"; Boolean)
        {
            CaptionML = ENG = 'Non-Deductible work Accident', FRA = 'Non déductible accident de travail';
        }
        field(18; "Tax-exempt (-5000 DT)"; Boolean)
        {
            CaptionML = ENG = 'Tax-exempt (-5000 DT)', FRA = 'Exonoré d''impôt (-5000 DT)';
        }
        field(19; "Included Breastfeeding Hours"; Boolean)
        {
            CaptionML = ENG = 'Included in Breastfeeding Hours', FRA = 'Inclus dans les heures d''allaitement';
        }
        field(20; "Included in Work Accident"; Boolean)
        {
            CaptionML = ENG = 'Included in Work Accident', FRA = 'Inclus dans l''Accident de Travail';
        }

        field(21; "Included in UGTT Hours"; Boolean)
        {
            CaptionML = ENG = 'Included in UGTT hours', FRA = 'Inclus H.UGTT';
        }
        field(22; "Includes Extra Days"; Boolean)
        {
            CaptionML = ENG = 'Includes Extra Day', FRA = 'Inclus Jour Sup';
        }
        field(23; "Allait-UGTT-ATECH"; Decimal)
        {
            CaptionML = ENG = 'Breastfeeding Hours UGTTATECH', FRA = 'Allait-UGTT-ATECH';
        }
        field(24; "Not incl. Nat. Old Age Insur."; Boolean)
        {
            CaptionML = ENG = 'Excluded from National Pension', FRA = 'Non inclus dans l''AVNAT';//AV NAt = Assurance Vieillesse Nationale
        }
        field(25; "Indemnity Account No."; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENG = 'Indemnity Account', FRA = 'Compte indemnité';
        }
        field(26; "Indemnity Balance Account No."; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENG = 'Offset Account for Indemnity', FRA = 'Compte contre partie indemnité';
        }
        field(27; "Conventional Indemnity"; Boolean)
        {
            CaptionML = ENG = 'Conventional Indemnity', FRA = 'Indemnité conventionnelle';
        }
        field(28; "User ID"; Code[22])
        {
            Editable = false;
            TableRelation = User;
            CaptionML = ENG = 'User ID', FRA = 'Id utilisateurs';
        }
        field(29; "Last Modified Date"; Date)
        {
            CaptionML = ENG = 'Last Modified Date', FRA = 'Date de dernière modification';
            Editable = false;
        }
        field(30; "Indemnity Type"; Enum "WDC Indemnity Type")
        {
            CaptionML = ENG = 'Indemnity type', FRA = 'Type Indemnité';
        }
        field(31; "Not Included in Accounting"; Boolean)
        {
            CaptionML = ENG = 'Not Included in Accounting', FRA = 'Non inclus dans la comptabilité';
        }
        field(32; "Not Included in Bonus"; Boolean)
        {
            CaptionML = ENG = 'Not Included in Bonus', FRA = 'Non inclus en Prime';
        }
        field(33; "Amount Rounding Precision"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            CaptionML = ENG = 'Amount Rounding Precision', FRA = 'Precision arrondi montant';
        }
        field(34; "Rounding Direction"; Enum "WDC Arround Type")
        {
            CaptionML = ENU = 'Rounding Direction', FRA = 'Sens arrondi';
        }
        field(35; "Employee Statistic Group"; Code[30])
        {
            CaptionML = ENG = 'Employee Statistic Group', FRA = 'Groupe statistic salarié';
            Editable = true;
            TableRelation = "Employee Statistics Group";
        }
        field(36; Management; Code[20])
        {
            CaptionML = ENG = 'Direction', FRA = 'Direction';
        }
        field(37; Service; Code[20])
        {
            CaptionML = ENG = 'Service', FRA = 'Service';
        }
        field(38; Section; Code[20])
        {
            CaptionML = ENG = 'Section', FRA = 'Section';
        }
        field(39; "Not included in vacation days"; Boolean)
        {
            CaptionML = ENG = 'Not included in vacation days', FRA = 'Non Inclue en jours congé';
        }
        field(40; "Deduction Base Indemnity/Days"; Integer)
        {
            CaptionML = ENG = 'Deduction Base for Indemnity/Days', FRA = 'Base déduction indemnité/jours';
        }
        field(41; "Deduction Base Indemnity/Hour"; Integer)
        {
            CaptionML = ENG = 'Deduction base for Indemnity/hour', FRA = 'Base déduction indemnité/heure';
        }
        field(42; "Benefit in Kind"; Boolean)
        {
            CaptionML = ENG = 'Benefit in kind', FRA = 'Avantage en nature';
        }

    }
    keys
    {
        key(Key1; "No.", "Employee No.", Indemnity, "Not Included in Bonus")
        {
            Clustered = true;
            SumIndexFields = "Real Amount";
        }
        key(Key2; "Employee Posting Group", Type, "No.", "Employee No.", "Global Dimension 1", "Global Dimension 2")
        {
            SumIndexFields = "Real Amount";
        }
        key(Key3; Indemnity, "Employee Statistic Group", "Employee Posting Group", "Global Dimension 1", "Global Dimension 2")
        {
            SumIndexFields = "Real Amount";
        }
        key(Key4; "No.", "Employee No.", Type)
        {
            SumIndexFields = "Real Amount", "Real Amount PR";
        }
        key(Key5; "No.", "Employee No.", Type, "Not incl. Nat. Old Age Insur.")
        {
            SumIndexFields = "Real Amount", "Real Amount PR";
        }
        key(Key6; "No.", "Employee No.", Type, "Not incl. Nat. Old Age Insur.", "Conventional Indemnity")
        {
            SumIndexFields = "Real Amount", "Real Amount PR";
        }
        key(Key7; "No.", "Employee Statistic Group", Type)
        {
            SumIndexFields = "Real Amount", "Real Amount PR";
        }
        key(Key8; Indemnity, "Employee Posting Group")
        {
            SumIndexFields = "Real Amount", "Real Amount PR";
        }
        key(Key9; "No.", "Employee No.", "Not Included in Bonus")
        {
            SumIndexFields = "Real Amount", "Base Amount";
        }
        key(Key10; "No.", "Employee No.", Indemnity, "Benefit in Kind")
        {
            SumIndexFields = "Real Amount", "Base Amount";
        }
        key(Key11; "No.", "Employee No.", Indemnity, "Benefit in Kind", "Conventional Indemnity")
        {
            SumIndexFields = "Real Amount", "Base Amount";
        }
    }

    trigger OnInsert()
    begin
        "Last Modified Date" := WORKDATE;
        "User ID" := USERID;
    end;

    trigger OnModify()
    begin
        "Last Modified Date" := WORKDATE;
        "User ID" := USERID;
    end;

    trigger OnRename()
    begin
        "Last Modified Date" := WORKDATE;
        "User ID" := USERID;
    end;

    var
        Indemnity: Record "WDC Indemnity";
}

