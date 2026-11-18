table 55000 "WDC Indemnity"
{

    CaptionML = ENG = 'Indemnity Code', FRA = 'Code Indemnité';
    DrillDownPageID = 55000;
    LookupPageID = 55000;
    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENG = 'Code', FRA = 'Code';
        }
        field(2; Description; Text[50])
        {
            CaptionML = ENG = 'Description', FRA = 'Description';
        }
        field(3; Type; Enum "WDC Indemnities Type")
        {
            CaptionML = ENG = 'Type', FRA = 'Type';

        }
        field(4; "Evaluation Mode"; Enum "WDC Evaluation Mode")
        {
            CaptionML = ENG = 'Evaluation mode', FRA = 'Mode d''évaluation';
        }
        field(5; "Default Amount"; Decimal)
        {
            CaptionML = ENG = 'Default Amount', FRA = 'Montant par défaut';
            DecimalPlaces = 0 : 3;

            trigger OnValidate()
            var
                lDefaultIndemnitys: Record "WDC Default Indemnities";
                Employee: Record Employee;
            begin
                lDefaultIndemnitys.RESET;
                lDefaultIndemnitys.SETRANGE("Indemnity Code", Code);
                IF lDefaultIndemnitys.FINDSET THEN
                    REPEAT
                        Employee.GET(lDefaultIndemnitys."Emplymt. Contract Code");
                        IF Employee.Status = Employee.Status::Active THEN
                            lDefaultIndemnitys.VALIDATE("Default Amount", "Default amount");
                        lDefaultIndemnitys.MODIFY;
                    UNTIL lDefaultIndemnitys.NEXT = 0;
            end;
        }
        field(6; "Employee Posting Grp. Filter"; Code[20])
        {
            CaptionML = ENG = 'Employee Posting Grp. Filter', FRA = 'Filtre groupe compta. salarié';
            FieldClass = FlowFilter;
            TableRelation = "WDC Employee Posting Group";
        }
        field(7; "Payment No. Filter"; Code[20])
        {
            CaptionML = ENG = 'Payment No. filter', FRA = 'Filtre N° paie';
            FieldClass = FlowFilter;
            TableRelation = "WDC Salary Header";
        }
        field(8; "Total Indemnity"; Decimal)
        {
            CaptionML = ENG = 'Code', FRA = 'Code';
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Indemnities"."Real Amount" WHERE(Indemnity = FIELD(Code),
                                                               "No." = FIELD("Payment No. Filter"),
                                                               "Employee Posting Group" = FIELD("Employee Posting Grp. filter")));
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }

        field(9; "Minimum Value"; Decimal)
        {
            CaptionML = ENG = 'Minimum Value', FRA = 'Valeur minimale';
            DecimalPlaces = 3 : 3;
        }
        field(10; "Days Number"; Decimal)
        {
            CaptionML = ENG = 'Number of days', FRA = 'Nombre de jours';
        }
        field(11; "Non-Deductible Work Accident"; Boolean)
        {
            CaptionML = ENG = 'Non-Deductible work Accident', FRA = 'Non déductible accident de travail';
        }
        field(12; "Included in Overtime"; Boolean)
        {
            CaptionML = ENG = 'Included in Overtime', FRA = 'Inclus dans heures supp';

            trigger OnValidate()
            var
                Txt001: TextConst ENG = 'Are you sure you want to modify this Indemnity for all employees',
                                  FRA = 'Etes vous sûre de vouloir modifier cette indemnité pour tout les salariés';
            begin
                IF "Included in Overtime" THEN
                    IF CONFIRM(Txt001) THEN BEGIN
                        CLEAR(DefaultIndemnities);
                        DefaultIndemnities.SETFILTER(DefaultIndemnities."Indemnity Code", '%1', Code);
                        IF DefaultIndemnities.Findfirst() THEN
                            REPEAT
                                DefaultIndemnities."Included in Overtime" := "Included in overtime";
                                DefaultIndemnities.MODIFY;
                            UNTIL DefaultIndemnities.NEXT = 0;
                    END
            end;
        }
        field(13; "Tax-exempt (-5000 DT)"; Boolean)
        {
            CaptionML = ENG = 'Tax-exempt (-5000 DT)', FRA = 'Exonoré d''impôt (-5000 DT)';
            trigger OnValidate()
            begin
                DefaultIndemnities.RESET;
                DefaultIndemnities.SETRANGE("Indemnity Code", Code);
                IF DefaultIndemnities.FINDSET THEN BEGIN
                    DefaultIndemnities.MODIFYALL("Tax-exempt (-5000 DT)", "Tax-exempt (-5000 DT)");
                END;
            end;
        }
        field(14; "Included Breastfeeding Hours"; Boolean)
        {
            CaptionML = ENG = 'Included in breastfeeding hours', FRA = 'Inclus dans les heures d''allaitement';
        }
        field(15; "Included in Work Accident"; Boolean)
        {
            CaptionML = ENG = 'Included in Work Accident', FRA = 'Inclus dans l''Accident de Travail';
        }
        field(16; "Included in UGTT Hours"; Boolean)
        {
            CaptionML = ENG = 'Included in UGTT hours', FRA = 'Inclus H.UGTT';
        }
        field(17; "Includes Extra Days"; Boolean)
        {
            CaptionML = ENG = 'Includes Extra Day', FRA = 'Inclus Jour Sup';
        }
        field(18; "Not incl. Nat. Old Age Insur."; Boolean)
        {
            CaptionML = ENG = 'Excluded from National Pension', FRA = 'Non inclus dans l''AVNAT';//AV NAt = Assurance Vieillesse Nationale
        }
        field(19; "Not Included Public Holidays"; Boolean)
        {
            CaptionML = ENG = 'Not included in public holidays', FRA = 'Non inclus en jours fériés';

            trigger OnValidate()
            begin
                IF "Not Included Public Holidays" = TRUE THEN BEGIN
                    DefIndemnities.RESET;
                    DefIndemnities.SETRANGE("Indemnity Code", Code);
                    IF DefIndemnities.FINDSET THEN BEGIN
                        MESSAGE('%1', DefIndemnities."Indemnity Code");
                        DefIndemnities.MODIFYALL("Not Included Public Holidays", "Not Included Public Holidays");
                    END;
                END;
            end;
        }
        field(20; "Indemnity Account No."; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENG = 'Indemnity Account', FRA = 'Compte indemnité';
        }
        field(21; "Indemnity Balance Account No."; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENG = 'Offset Account for Indemnity', FRA = 'Compte contre partie indemnité';
        }
        field(22; "% Of Basic Salary"; Boolean)
        {
            CaptionML = ENG = '% Of Basic Salary', FRA = '% Salaire de Base';
        }
        field(23; "Rate % Base Salary"; Decimal)
        {
            CaptionML = ENG = 'Rate % Base Salary', FRA = 'Taux % salaire de base';
        }
        field(26; Rate; Decimal)
        {
            DecimalPlaces = 0 : 5;
            CaptionML = ENG = 'Rate', FRA = 'Taux';
        }
        field(27; "Indemnity Type"; Enum "WDC Indemnity Type")
        {
            CaptionML = ENG = 'Indemnity type', FRA = 'Type Indemnité';
        }
        field(28; "Not Included in Accounting"; Boolean)
        {
            CaptionML = ENG = 'Not included in accounting', FRA = 'Non inclus dans la comptabilité';
        }
        field(29; "Not Included in Bonus"; Boolean)
        {
            CaptionML = ENG = 'Not Included in Bonus', FRA = 'Non inclus en Prime';
        }
        field(30; "Amount Rounding Precision"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            CaptionML = ENG = 'Amount Rounding Precision', FRA = 'Precision arrondi montant';
        }
        field(31; "Rounding Direction"; Enum "WDC Arround Type")
        {
            CaptionML = ENU = 'Rounding Direction', FRA = 'Sens arrondi';
        }
        field(32; "Included in Insurance Base"; Boolean)
        {
            CaptionML = ENG = 'Included in insurance base', FRA = 'Inclus dans base assurance';
        }
        field(33; "Not included in vacation days"; Boolean)
        {
            CaptionML = ENG = 'Not included in vacation days', FRA = 'Non Inclue en jours congé';
        }
        field(34; "Conventional Indemnity"; Boolean)
        {
            CaptionML = ENG = 'Conventional Indemnity', FRA = 'Indemnité conventionnelle';
        }
        field(35; "Deduction Base Indemnity/Days"; Integer)
        {
            CaptionML = ENG = 'Deduction Base for Indemnity/Days', FRA = 'Base déduction indemnité/jours';
        }
        field(36; "Deduction Base Indemnity/Hour"; Integer)
        {
            CaptionML = ENG = 'Deduction base for Indemnity/hour', FRA = 'Base déduction indemnité/heure';
        }
        field(37; "Benefit in Kind"; Boolean)
        {
            CaptionML = ENG = 'Benefit in kind', FRA = 'Avantage en nature';

            trigger OnValidate()
            begin
                IF "Benefit in Kind" THEN BEGIN
                    DefIndemnities.RESET;
                    DefIndemnities.SETRANGE("Indemnity Code", Code);
                    IF DefIndemnities.FINDSET THEN BEGIN
                        DefIndemnities.MODIFYALL("Benefit in Kind", TRUE);
                    END;
                END;

            end;
        }
        field(38; Invisible; Boolean)
        {
            CaptionML = ENG = 'Invisible', FRA = 'Invisible';
        }


        field(45; "Total Rec. Indemnity"; Decimal)
        {
            CaptionML = ENG = 'Total Rec. Indemnity', FRA = 'Total Rec. Indemnités';
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Rec. Indemnities"."Real Amount" WHERE(Indemnity = FIELD(Code),
                                                               "No." = FIELD("Payment No. Filter"),
                                                               "Employee Posting Group" = FIELD("Employee Posting Grp. filter")));
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    // trigger OnDelete() //Hamdi migration
    // var
    //     lText001: TextConst ENU = 'Unauthorized deletion', FRA = 'Suppression non autorisée';
    // begin
    //     ERROR(lText001);
    // end;

    trigger OnInsert()
    begin
        GeneralLedgerSetup.GET;
        "Amount Rounding Precision" := GeneralLedgerSetup."Amount Rounding Precision";
        "Rounding Direction" := "Rounding Direction"::"=";
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        DefaultIndemnities: Record "WDC Default Indemnities";
        DefIndemnities: Record "WDC Default Indemnities";
}

