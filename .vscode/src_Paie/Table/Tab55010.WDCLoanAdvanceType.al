table 55010 "WDC Loan & Advance Type"
{
    CaptionML = ENU = 'Loan & Advance Type', FRA = 'Type de prêt et avance';
    DrillDownPageID = 55010;
    LookupPageID = 55010;

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(2; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(3; Type; ENUM "WDC Loan & Advance Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';
        }
        field(4; "Repayment slices"; Integer)
        {
            CaptionML = ENU = 'Repayment slices', FRA = 'Tranches remboursement';
        }
        field(11; "Interest %"; Decimal)
        {
            CaptionML = ENU = 'Interest %', FRA = 'Intérêt %';
            DecimalPlaces = 0 : 2;
        }
        field(30; "Account Type"; enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Account Type', FRA = 'Type compte';

            trigger OnValidate()
            begin
                IF (("Account Type" = Rec."Bal. Account Type")
                    AND
                    ("Account Type".AsInteger() = 1))
                 THEN
                    CASE "Account Type".AsInteger() OF
                        0:
                            BEGIN
                                Rec."Bal. Account Type" := Rec."Bal. Account Type"::"Bank Account";
                                Rec."Bal. Account No." := '';

                            END;
                        1:
                            BEGIN
                                Rec."Bal. Account Type" := rec."Bal. Account Type"::"G/L Account";
                                Rec."Bal. Account No." := '';
                                Rec."Advance on Bonus" := FALSE;
                            END;
                    END;
            end;
        }
        field(31; "Account No."; Code[20])
        {
            CaptionML = ENU = 'Account No.', FRA = 'N° compte';
            TableRelation = IF ("Account Type" = FILTER("G/L Account")) "G/L Account"
            ELSE IF ("Account Type" = FILTER("Bank Account")) "Bank Account" WHERE("Currency Code" = FILTER(''));
        }
        field(32; "Bal. Account Type"; Enum "Payment Balance Account Type")
        {
            CaptionML = ENU = 'Bal. Account Type', FRA = 'Type compte contrepartie';

            trigger OnValidate()
            var

            begin
                IF (("Account Type" = "Bal. Account Type")
                    AND
                    ("Account Type".AsInteger() = 1))
                 THEN
                    CASE "Bal. Account Type".AsInteger() OF
                        0:
                            BEGIN
                                "Account Type" := "Bal. Account Type"::"Bank Account";
                                "Account No." := '';
                            END;
                        1:
                            BEGIN
                                "Account Type" := "Bal. Account Type"::"G/L Account";
                                "Account No." := '';
                            END;
                    END;
            end;
        }
        field(33; "Bal. Account No."; Code[20])
        {
            CaptionML = ENU = 'Bal. Account No.', FRA = 'N° compte contrepartie';
            TableRelation = IF ("Bal. Account Type" = FILTER("G/L Account")) "G/L Account"
            ELSE IF ("Bal. Account Type" = FILTER("Bank Account")) "Bank Account" WHERE("Currency Code" = FILTER(''));
        }
        field(40; "Long Term Account Type"; Enum "Payment Balance Account Type")
        {
            CaptionML = ENU = 'Account Type Long Term', FRA = 'Type Compte Long Terme';
        }
        field(41; "Long Term Account No."; Code[20])
        {
            CaptionML = ENU = 'Long Term Account No.', FRA = 'N° compte Long Terme';
            TableRelation = IF ("Long Term Account Type" = FILTER("G/L Account"),
                                Type = CONST(Loan)) "G/L Account"
            ELSE IF ("Long Term Account Type" = FILTER("Bank Account"),
                                         Type = CONST(Loan)) "Bank Account" WHERE("Currency Code" = FILTER(''));
        }
        field(50; "Interest Account No."; Code[20])
        {
            CaptionML = ENU = 'Interest Account No.', FRA = 'N° compte d’intérêt';
            TableRelation = "G/L Account";
        }
        field(101; "Employee Posting Grp. filter"; Code[30])
        {
            CaptionML = ENU = 'Employee Posting Group filter', FRA = 'Filtre groupe imputation employé';
            FieldClass = FlowFilter;
            TableRelation = "WDC Employee Posting Group";
        }
        field(102; Balance; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Sum("WDC Loan & Advance Entry".Amount WHERE("Document type" = FIELD(Code),
                                                                   "Employee Posting Group" = FIELD("Employee Posting Grp. filter")));
            CaptionML = ENU = 'Balance', FRA = 'Solde';
            FieldClass = FlowField;
        }
        field(105; "Source Code"; Code[20])
        {
            CaptionML = ENU = 'Source Code', FRA = 'Code source';
            TableRelation = "Source Code";
        }
        field(110; "Advance on Bonus"; Boolean)
        {
            CaptionML = ENU = 'Advance on Bonus', FRA = 'Avance sur Prime';

            trigger OnValidate()
            var
                lText001: TextConst ENU = 'It''s a loan !!!', FRA = 'C''est un Prêt !!!!!!';
            begin
                IF Type.AsInteger() <> 0 THEN
                    ERROR(lText001);
            end;
        }
        field(5000; "Default Type"; Boolean)
        {
            CaptionML = ENU = 'Default Type', FRA = 'Type par défaut';

            trigger OnValidate()
            var
                lText001: TextConst ENU = 'You cannot assign a different default type!!!',
                                    FRA = 'Vous ne pouvez pas attribuer un autre type par défault !!!';
            begin
                T1.RESET;
                T1.SETRANGE(Type, Type);
                T1.SETRANGE("Default Type", TRUE);
                IF "Default Type" AND (T1.Findfirst()) THEN
                    ERROR(lText001);
            end;
        }
        field(50000; "Advance on Holiday"; Boolean)
        {
            CaptionML = ENU = 'Advance on Holiday', FRA = 'Avance sur congé';
        }
        field(39001450; "Depreciation type"; enum "WDC Depreciation Type")
        {
            CaptionML = ENU = 'Depreciation type', FRA = 'Type amortissement';
        }
        field(39001451; "Accounting Posting"; Enum "WDC Accounting Posting")
        {
            CaptionML = ENU = 'Accounting Posting', FRA = 'Imputation comptable';
        }
        field(39001470; "Aid Advance"; Boolean)
        {
            CaptionML = ENU = 'Aid Advance', FRA = 'Avance aide';
        }
        field(39001490; "Precision Arrondi Principale"; Decimal)
        {
            CaptionML = ENU = 'Main Rounding Precision', FRA = 'Précision Arrondi Principale';
            DecimalPlaces = 0 : 3;
        }
        field(39001495; "Meal Advance"; Boolean)
        {
            CaptionML = ENU = 'Meal Advance', FRA = 'Avance repas';
        }
        field(39001496; "Payment Type"; Text[30])
        {
            CaptionML = ENU = 'Payment Type', FRA = 'Type de paiement';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }


    var
        T1: Record 55010;
}

