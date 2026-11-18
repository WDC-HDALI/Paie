table 55004 "WDC Default Indemnities"
{
    CaptionML = ENG = 'Default Indemnities', FRA = 'Indemnities par défauts';
    DrillDownPageID = 55005;
    LookupPageID = 55005;

    fields
    {
        field(1; "Emplymt. Contract Code"; Code[20])
        {
            CaptionML = ENG = 'Employment Contract Code', FRA = 'Code contrat travail';
            Editable = true;
            TableRelation = "Employment Contract";

            trigger OnValidate()
            begin
                VALIDATE("Indemnity Code");
            end;
        }
        field(2; "Indemnity Code"; Code[20])
        {
            CaptionML = ENG = 'Indemnity Code', FRA = 'Code Indemnité';
            NotBlank = true;
            TableRelation = "WDC Indemnity";
            trigger OnValidate()
            begin

                IF Indemnity.GET("Indemnity Code") THEN BEGIN
                    Description := Indemnity.Description;
                    "Included in Overtime" := Indemnity."Included in Overtime";
                    Type := Indemnity.Type;
                    "Evaluation mode" := Indemnity."Evaluation mode";
                    "Default amount" := Indemnity."Default amount";
                    "Minimum value" := Indemnity."Minimum value";
                    Rate := Indemnity.Rate;
                    "Indemnity Type" := Indemnity."Indemnity type";
                    "Not incl. Nat. Old Age Insur." := Indemnity."Not incl. Nat. Old Age Insur.";
                    "Not Included in Accounting" := Indemnity."Not Included in Accounting";
                    "Not Included in Bonus" := Indemnity."Not Included in Bonus";
                    "Amount Rounding Precision" := Indemnity."Amount Rounding Precision";
                    "Rounding Direction" := Indemnity."Rounding Direction";
                    "Not Included Public Holidays" := Indemnity."Not Included Public Holidays";
                    "Included in Insurance Base" := Indemnity."Included in Insurance Base";
                    "Not included in vacation days" := Indemnity."Not included in vacation days";
                    "Conventional Indemnity" := Indemnity."Conventional Indemnity";
                    "Deduction Base Indemnity/Days" := Indemnity."Deduction Base Indemnity/Days";
                    "Deduction Base Indemnity/Hour" := Indemnity."Deduction Base Indemnity/Hour";
                    "Benefit in Kind" := Indemnity."Benefit in Kind";
                    "% Of Basic Salary" := Indemnity."% Of Basic Salary";
                    "Rate % Base Salary" := Indemnity."Rate % Base Salary";
                    "Days Number" := Indemnity."Days Number";
                    "Indemnity Account No." := Indemnity."Indemnity Account No.";
                    "Indemnity Balance Account No." := Indemnity."Indemnity Balance Account No.";
                    "Non-Deductible Work Accident" := Indemnity."Non-Deductible Work Accident";
                    "Tax-exempt (-5000 DT)" := Indemnity."Tax-exempt (-5000 DT)";
                    "Included Breastfeeding Hours" := Indemnity."Included Breastfeeding Hours";
                    "Included in Work Accident" := Indemnity."Included in Work Accident";
                    "Included in UGTT Hours" := Indemnity."Included in UGTT Hours";
                    "Includes Extra Days" := Indemnity."Includes Extra Days";
                END;
            end;
        }
        field(3; Description; Text[100])
        {
            CaptionML = ENG = 'Description', FRA = 'Description';
        }
        field(4; Type; Enum "WDC Indemnities Type")
        {
            CaptionML = ENG = 'Type', FRA = 'Type';

        }
        field(5; "Evaluation Mode"; Enum "WDC Evaluation Mode")
        {
            CaptionML = ENG = 'Evaluation mode', FRA = 'Mode d''évaluation';
        }
        field(6; "Default Amount"; Decimal)
        {
            CaptionML = ENG = 'Default Amount', FRA = 'Montant par défaut';
            DecimalPlaces = 6 : 6;
            trigger OnValidate()
            begin
                IF EmploymentContract.GET(Rec."Emplymt. Contract Code") THEN BEGIN
                    IF Regimesofwork.GET(EmploymentContract."Work Regime") THEN
                        IF "Evaluation mode".AsInteger() = 3 THEN
                            "Basis amount" := "Default amount" * Regimesofwork."Work Hours per month"
                        ELSE IF "Evaluation mode".AsInteger() = 4 THEN
                            "Basis amount" := "Default amount" * Rate

                        ELSE IF "Evaluation mode".AsInteger() = 5 THEN
                            "Basis amount" := "Default amount" * Regimesofwork."Worked Day Per Month"
                        ELSE
                            "Basis amount" := "Default amount"
                END;
            end;
        }
        field(7; "Minimum Value"; Decimal)
        {
            CaptionML = ENG = 'Minimum Value', FRA = 'Valeur minimale';
            DecimalPlaces = 3 : 3;
        }
        field(8; "Days Number"; Decimal)
        {
            CaptionML = ENG = 'Number of days', FRA = 'Nombre de jours';
        }
        field(9; "Non-Deductible Work Accident"; Boolean)
        {
            CaptionML = ENG = 'Non-Deductible work Accident', FRA = 'Non déductible accident de travail';
        }
        field(10; "Included in Overtime"; Boolean)
        {
            CaptionML = ENG = 'Included in Overtime', FRA = 'Inclus dans heures supp';
        }
        field(11; "Tax-exempt (-5000 DT)"; Boolean)
        {
            CaptionML = ENG = 'Tax-exempt (-5000 DT)', FRA = 'Exonoré d''impôt (-5000 DT)';
        }
        field(12; "Included Breastfeeding Hours"; Boolean)
        {
            CaptionML = ENG = 'Included in breastfeeding hours', FRA = 'Inclus dans les heures d''allaitement';
        }
        field(13; "Included in Work Accident"; Boolean)
        {
            CaptionML = ENG = 'Included in Work Accident', FRA = 'Inclus dans l''Accident de Travail';
        }
        field(14; "Included in UGTT Hours"; Boolean)
        {
            CaptionML = ENG = 'Included in UGTT hours', FRA = 'Inclus H.UGTT';
        }
        field(15; "Includes Extra Days"; Boolean)
        {
            CaptionML = ENG = 'Includes Extra Day', FRA = 'Inclus Jour Sup';
        }
        field(16; "Application Month"; Text[30])
        {
            FieldClass = Normal;
            CaptionML = ENG = 'Month of Application', FRA = 'Mois d''application';
        }
        field(17; "Breastfeeding Hours UGTT ATECH"; Decimal)
        {
            CaptionML = ENG = 'Breastfeeding Hours UGTTATECH', FRA = 'Allait-UGTT-ATECH';
        }
        field(18; "Not incl. Nat. Old Age Insur."; Boolean)
        {
            CaptionML = ENG = 'Not incl. Nat. Old Age Insur.', FRA = 'Non inclus dans A.V. NAT';//AV NAt = Assurance Vieillesse Nationale
        }
        field(19; "Not Included Public Holidays"; Boolean)
        {
            CaptionML = ENG = 'Not included in public holidays', FRA = 'Non inclus en jours fériés';
        }
        field(20; "Indemnity Account No."; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENG = 'Indemnity Account No.', FRA = 'N° Compte indemnité';
        }
        field(21; "Indemnity Balance Account No."; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENG = 'Indemnity Balance Account No.', FRA = 'N° Compte contre partie indemnité';
        }
        field(22; "% Of Basic Salary"; Boolean)
        {
            CaptionML = ENG = '% Of Basic Salary', FRA = '% Salaire de Base';
        }
        field(23; "Rate % Base Salary"; Decimal)
        {
            CaptionML = ENG = 'Rate % Base Salary', FRA = 'Taux % salaire de base';
        }
        field(24; "Seniority Percentage"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            CaptionML = ENG = 'Seniority Percentage', FRA = 'Pourcentage ancienneté';
        }
        field(25; "User ID"; Code[22])
        {
            Editable = false;
            TableRelation = User;
            CaptionML = ENG = 'User ID', FRA = 'Id utilisateurs';
        }
        field(26; "Last Modified Date"; Date)
        {
            CaptionML = ENG = 'Last Modified Date', FRA = 'Date de dernière modification';
            Editable = false;
        }
        field(27; Rate; Decimal)
        {
            DecimalPlaces = 0 : 5;
            CaptionML = ENG = 'Rate', FRA = 'Taux';
        }
        field(28; "Indemnity Type"; Enum "WDC Indemnity Type")
        {
            CaptionML = ENG = 'Indemnity type', FRA = 'Type Indemnité';
        }
        field(29; "Not Included in Accounting"; Boolean)
        {
            CaptionML = ENG = 'Not included in accounting', FRA = 'Non inclus dans la comptabilité';
        }
        field(30; "Not Included in Bonus"; Boolean)
        {
            CaptionML = ENG = 'Not Included in Bonus', FRA = 'Non inclus en Prime';
        }
        field(31; "Amount Rounding Precision"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            CaptionML = ENG = 'Amount Rounding Precision', FRA = 'Precision arrondi montant';
        }
        field(32; "Rounding Direction"; Enum "WDC Arround Type")
        {
            CaptionML = ENU = 'Rounding Direction', FRA = 'Sens arrondi';
        }
        field(33; "Included in Insurance Base"; Boolean)
        {
            CaptionML = ENG = 'Included in insurance base', FRA = 'Inclus dans base assurance';
        }
        field(34; "Basis Amount"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENG = 'Basis Amount', FRA = 'Montant de base';
            DecimalPlaces = 3 : 3;
        }
        field(35; "Not included in vacation days"; Boolean)
        {
            CaptionML = ENG = 'Not included in vacation days', FRA = 'Non Inclue en jours congé';
        }
        field(36; "Conventional Indemnity"; Boolean)
        {
            CaptionML = ENG = 'Conventional Indemnity', FRA = 'Indemnité conventionnelle';
        }
        field(37; "Deduction Base Indemnity/Days"; Integer)
        {
            CaptionML = ENG = 'Deduction Base for Indemnity/Days', FRA = 'Base déduction indemnité/jours';
        }
        field(39; "Deduction Base Indemnity/Hour"; Integer)
        {
            CaptionML = ENG = 'Deduction base for Indemnity/hour', FRA = 'Base déduction indemnité/heure';
        }
        field(40; "Benefit in Kind"; Boolean)
        {
            CaptionML = ENG = 'Benefit in kind', FRA = 'Avantage en nature';
        }
    }

    keys
    {
        key(Key1; "Emplymt. Contract Code", "Indemnity Code", "Not Included in Bonus")
        {
            Clustered = true;
            SumIndexFields = "Default amount", "Basis amount";
        }
        key(Key2; "Indemnity Type", "Indemnity Code", "Emplymt. Contract Code")
        {
            SumIndexFields = "Basis amount";
        }
        key(Key3; "Emplymt. Contract Code", "Evaluation mode", "Not included in vacation days", Type, "Conventional Indemnity")
        {
            SumIndexFields = "Basis amount";
        }
        key(Key4; "Indemnity Code", "Emplymt. Contract Code", "Indemnity Type")
        {
            SumIndexFields = "Basis amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Last Modified Date" := WORKDATE;
        "User ID" := USERID;
        TESTFIELD("Emplymt. Contract Code");
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

    procedure CalcLib() Name: Text[60]
    var
        L_Empl: Record Employee;
    begin
        L_Empl.RESET;
        L_Empl.SETRANGE("Emplymt. Contract Code", "Emplymt. Contract Code");

        IF L_Empl.Findlast() THEN;
        Name := L_Empl."Last Name" + ' ' + L_Empl."First Name";
    end;

    var
        Indemnity: Record "WDC Indemnity";
        SelectedInd: Record "WDC Indemnity";
        College: Record "WDC College";
        Emp: Record Employee;
        EmploymentContract: Record "Employment Contract";
        Regimesofwork: Record "WDC work Regimes";


}

