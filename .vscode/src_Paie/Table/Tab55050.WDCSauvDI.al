table 55050 "WDC SauvDI"
{
    Caption = 'Default Indemnities';
    DrillDownPageID = "WDC Empl. Contracts List Ind";
    LookupPageID = "WDC Empl. Contracts List Ind";

    fields
    {
        field(1; "Emplymt. Contract Code"; Code[20])
        {
            CaptionML = ENU = 'Emplymt. Contract Code', FRA = 'Code Contrat Travail';
            Editable = true;
            TableRelation = "Employment Contract";

            trigger OnValidate()
            begin
                VALIDATE("Indemnity Code");
            end;
        }
        field(2; "Indemnity Code"; Code[20])
        {
            CaptionML = ENU = 'Indemnity Code', FRA = 'Code Indemnité';
            NotBlank = true;
            TableRelation = "WDC Indemnity";

            trigger OnLookup()
            begin
                CLEAR(PageIndemnity);

                EmploymentContract.GET("Emplymt. Contract Code");
                EmploymentContract.CalcFields("Employee type");
                CASE EmploymentContract."Employee type".AsInteger() OF
                    0:
                        BEGIN
                            Indemnity.SETFILTER("Evaluation mode", '0|1|2|3|4|5|6');
                            PageIndemnity.SETTABLEVIEW(Indemnity);
                            IF Indemnity.Findfirst() THEN BEGIN
                                IF PageIndemnity.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    PageIndemnity.GETRECORD(SelectedInd);
                                    VALIDATE("Indemnity Code", SelectedInd.Code);
                                END;
                            END;
                        END;
                    1:
                        BEGIN
                            Indemnity.SETFILTER("Evaluation mode", '0|1|2|3|4|5|6');
                            PageIndemnity.SETTABLEVIEW(Indemnity);
                            IF Indemnity.Findfirst() THEN BEGIN
                                IF PageIndemnity.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    PageIndemnity.GETRECORD(SelectedInd);
                                    VALIDATE("Indemnity Code", SelectedInd.Code);
                                END;
                            END;
                        END;
                END;

                //============Spécifique pour UNPA
                IF "Indemnity Code" = 'IND.TRAN' THEN BEGIN
                    Emp.SETRANGE("No.", "Emplymt. Contract Code");
                    IF Emp.Findfirst() THEN BEGIN

                        College1.SETRANGE(Code, Emp.College);
                        IF College1.Findfirst() THEN
                            VALIDATE("Default amount", College1."Transport Indemnity Amount");
                    END;
                END
                ELSE
                    IF "Indemnity Code" = 'IND.LOG' THEN BEGIN
                        Emp.SETRANGE("No.", "Emplymt. Contract Code");
                        IF Emp.Findfirst() THEN BEGIN
                            College1.SETRANGE(Code, Emp.College);
                            IF College1.Findfirst() THEN
                                VALIDATE("Default amount", College1."Housing Indemnity Amount");

                        END;
                    END
            end;

            trigger OnValidate()
            begin

                IF Indemnity.GET("Indemnity Code") THEN BEGIN
                    Description := Indemnity.Description;
                    "Included in Overtime" := Indemnity."Included in Overtime";
                    Type := Indemnity.Type;
                    "Evaluation mode" := Indemnity."Evaluation mode";
                    "Default amount" := Indemnity."Default amount";
                    "Minimum value" := Indemnity."Minimum value";
                    Taux := Indemnity.Rate;
                    "Indemnity Type" := Indemnity."Indemnity Type";
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
                    "Includes Extra Days" := Indemnity."Includes Extra Days";
                END;


                IF "% Of Basic Salary" THEN
                    IF Emp.GET("Emplymt. Contract Code") THEN BEGIN
                        IF EmploymentContract.GET("Emplymt. Contract Code") THEN BEGIN
                            IF Regimesofwork.GET(EmploymentContract."Work Regime") THEN
                                IF Emp."Employee type".AsInteger() = 0 THEN
                                    "Default amount" := Emp."Basis salary" * "Rate % Base Salary"
                                ELSE
                                    "Default amount" := (Emp."Basis salary" / Regimesofwork."Work Hours per month") * "Rate % Base Salary";
                        END;
                    END;

                IF EmploymentContract.GET("Emplymt. Contract Code") THEN BEGIN
                    IF Regimesofwork.GET(EmploymentContract."Work Regime") THEN
                        IF "Evaluation mode".AsInteger() = 3 THEN
                            "Basis amount" := "Default amount" * Regimesofwork."Work Hours per month"
                        ELSE IF "Evaluation mode".AsInteger() = 4 THEN
                            "Basis amount" := "Default amount" * Taux

                        ELSE IF "Evaluation mode".AsInteger() = 5 THEN
                            "Basis amount" := "Default amount" * Regimesofwork."Worked Day Per Month"
                        ELSE
                            "Basis amount" := "Default amount"
                END;
            end;
        }
        field(3; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
            Editable = false;
        }
        field(4; Type; Enum "WDC Indemnities Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';
        }
        field(5; "Evaluation mode"; Enum "WDC Evaluation Mode")
        {
            CaptionML = ENU = 'Evaluation mode', FRA = 'Mode d''évaluation';
            Editable = true;
        }
        field(10; "Default amount"; Decimal)
        {
            CaptionML = ENU = 'Default amount', FRA = 'Montant par défaut';
            DecimalPlaces = 6 : 6;

            trigger OnValidate()
            begin
                IF EmploymentContract.GET("Emplymt. Contract Code") THEN BEGIN
                    IF Regimesofwork.GET(EmploymentContract."Work Regime") THEN
                        IF "Evaluation mode".AsInteger() = 3 THEN
                            "Basis amount" := "Default amount" * Regimesofwork."Work Hours per month"
                        ELSE IF "Evaluation mode".AsInteger() = 4 THEN
                            "Basis amount" := "Default amount" * Taux

                        ELSE IF "Evaluation mode".AsInteger() = 5 THEN
                            "Basis amount" := "Default amount" * Regimesofwork."Worked Day Per Month"
                        ELSE
                            "Basis amount" := "Default amount"
                END;
            end;
        }
        field(50000; "Minimum value"; Decimal)
        {
            CaptionML = ENU = 'Minimum value', FRA = 'Valeur minimum';
            DecimalPlaces = 3 : 3;
        }
        field(50002; "Days Number"; Decimal)
        {
            CaptionML = ENU = 'Days Number', FRA = 'Nombre de jours';
            DecimalPlaces = 3 : 3;
        }
        field(50003; "Non-Deductible Work Accident"; Boolean)
        {
            CaptionML = ENU = 'Non-Deductible Work Accident', FRA = 'Accident de travail non déductible';
        }
        field(50004; "Included in Overtime"; Boolean)
        {
            CaptionML = ENU = 'Included in Overtime', FRA = 'Inclus dans les heures supplémentaires';
        }

        field(50009; "Includes Extra Days"; Boolean)
        {
            CaptionML = ENU = 'Includes Extra Days', FRA = 'Inclut les jours supplémentaires';
        }
        field(50010; "Application Month"; Text[30])
        {
            CaptionML = ENU = 'Application Month', FRA = 'Mois d''application';
        }
        field(50051; "Not Included Public Holidays"; Boolean)
        {
            CaptionML = ENU = 'Not Included Public Holidays', FRA = 'Non inclus dans les jours fériés';
        }
        field(50052; "Indemnity Account No."; Code[20])
        {
            CaptionML = ENU = 'Indemnity Account No.', FRA = 'N° compte indemnité';
            TableRelation = "G/L Account";

        }
        field(50053; "Indemnity Balance Account No."; Code[20])
        {
            CaptionML = ENU = 'Indemnity Balance Account No.', FRA = 'N° compte indemnité (solde)';
            TableRelation = "G/L Account";
        }
        field(50060; "% Of Basic Salary"; Boolean)
        {
            CaptionML = ENU = '% Of Basic Salary', FRA = '% du salaire de base';
        }
        field(50061; "Rate % Base Salary"; Decimal)
        {
            CaptionML = ENU = 'Rate % Base Salary', FRA = 'Taux % du salaire de base';
        }
        field(50062; "Pourcentage ancienneté"; Decimal)
        {
            CaptionML = ENU = 'Percentage of Seniority', FRA = 'Pourcentage d''ancienneté';
            DecimalPlaces = 0 : 0;
        }

        field(39001440; Taux; Decimal)
        {
            CaptionML = ENU = 'Rate', FRA = 'Taux';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF EmploymentContract.GET("Emplymt. Contract Code") THEN BEGIN
                    IF Regimesofwork.GET(EmploymentContract."Work Regime") THEN
                        IF "Evaluation mode".AsInteger() = 4 THEN
                            "Basis amount" := "Default amount" * Taux
                        ELSE
                            "Basis amount" := "Default amount"
                END;
            end;
        }
        field(39001441; "Indemnity Type"; Enum "WDC Indemnity Type")
        {
            CaptionML = ENU = 'Indemnity Type', FRA = 'Type d''indemnité';
        }
        field(39001450; "Not Included in Accounting"; Boolean)
        {
            CaptionML = ENU = 'Not Included in Accounting', FRA = 'Non inclus dans la comptabilité';
        }
        field(39001451; "Not Included in Bonus"; Boolean)
        {
            CaptionML = ENU = 'Not Included in Bonus', FRA = 'Non inclus dans les bonus';
        }
        field(39001460; "Amount Rounding Precision"; Decimal)
        {
            CaptionML = ENU = 'Amount Rounding Precision', FRA = 'Précision d''arrondi du montant';
            DecimalPlaces = 0 : 5;
        }
        field(39001461; "Rounding Direction"; Enum "WDC Arround Type")
        {
            CaptionML = ENU = 'Rounding Direction', FRA = 'Sens d''arrondi';
        }
        field(39001462; "Included in Insurance Base"; Boolean)
        {
            CaptionML = ENU = 'Included in Insurance Base', FRA = 'Inclus dans la base d''assurance';
        }
        field(39001463; "Basis amount"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Montant de base';
            DecimalPlaces = 3 : 3;
        }
        field(39001464; "Not included in vacation days"; Boolean)
        {
            CaptionML = ENU = 'Not included in vacation days', FRA = 'Non inclus dans les jours de vacances';
        }
        field(39001465; "Conventional Indemnity"; Boolean)
        {
            CaptionML = ENU = 'Conventional Indemnity', FRA = 'Indemnité conventionnelle';
        }
        field(39001466; "Deduction Base Indemnity/Days"; Integer)
        {
            CaptionML = ENU = 'Deduction Base Indemnity/Days', FRA = 'Base de déduction indemnité/Jours';
        }
        field(39001467; "Deduction Base Indemnity/Hour"; Integer)
        {
            CaptionML = ENU = 'Deduction Base Indemnity/Hour', FRA = 'Base de déduction indemnité/Heure';
        }
        field(39001468; "Benefit in Kind"; Boolean)
        {
            CaptionML = ENU = 'Benefit in Kind', FRA = 'Avantage en nature';
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


    var
        Indemnity: Record "WDC Indemnity";
        SelectedInd: Record "WDC Indemnity";
        EmploymentContract: Record 5211;
        Regimesofwork: Record "WDC work Regimes";
        College1: Record "WDC College";
        Emp: Record Employee;
        PageIndemnity: Page "WDC Indemnities List";

}

