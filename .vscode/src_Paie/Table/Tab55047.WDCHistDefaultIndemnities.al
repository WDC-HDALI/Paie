table 55047 "WDC Hist. Default Indemnities"
{
    Caption = 'Default Indemnities';
    DrillDownPageID = 55053;
    LookupPageID = 55053;

    fields
    {
        field(1; "Emplymt. Contract Code"; Code[20])
        {
            CaptionML = ENU = 'Employment Contract Code', FRA = 'Code Contrat Travail';
            Editable = true;
            TableRelation = "WDC Hist. contrat de travail";

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
                            Indemnity.SETFILTER("Evaluation mode", '0|1|2|3|4|5|6');  //0|3|5|6
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
                            Indemnity.SETFILTER("Evaluation mode", '0|1|2|3|4|5|6');  //0|1|2|3|5|6
                            PageIndemnity.SETTABLEVIEW(Indemnity);
                            IF Indemnity.Findfirst() THEN BEGIN
                                IF PageIndemnity.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    PageIndemnity.GETRECORD(SelectedInd);
                                    VALIDATE("Indemnity Code", SelectedInd.Code);
                                END;
                            END;
                        END;
                END;

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
                    Type := Indemnity.Type;
                    "Evaluation mode" := Indemnity."Evaluation Mode";
                    "Default amount" := Indemnity."Default amount";
                    "Minimum value" := Indemnity."Minimum value";
                    Rate := Indemnity.Rate;
                    "Indemnity Type" := Indemnity."Indemnity Type";
                    "Not Included in Accounting" := Indemnity."Not Included in Accounting";
                    "Not Included in Bonus" := Indemnity."Not Included in Bonus";
                    "Amount Rounding Precision" := Indemnity."Amount Rounding Precision";
                    "Rounding Direction" := Indemnity."Rounding Direction";
                    "Not Included Public Holidays" := Indemnity."Not Included Public Holidays";
                    "Included in Insurance Base" := Indemnity."Included in Insurance Base";
                    "Not included in vacation days" := Indemnity."Not included in vacation days";

                END;


                IF EmploymentContract.GET("Emplymt. Contract Code") THEN BEGIN
                    IF Regimesofwork.GET(EmploymentContract."Work Regime") THEN
                        IF "Evaluation mode" = "Evaluation mode"::"On Worked Hour" THEN
                            "Basis amount" := "Default amount" * Regimesofwork."Work Hours per month"
                        ELSE IF "Evaluation mode" = "Evaluation mode"::"On Flight Hours" THEN
                            "Basis amount" := "Default amount" * Rate
                        ELSE
                            "Basis amount" := "Default amount"
                END;

            end;
        }
        field(3; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(4; Type; Enum "WDC Indemnities Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';
        }
        field(5; "Evaluation mode"; Enum "WDC Evaluation Mode")
        {
            CaptionML = ENU = 'Evaluation mode', FRA = 'Mode évaluation';
            Editable = true;
        }
        field(10; "Default amount"; Decimal)
        {
            CaptionML = ENU = 'Default amount', FRA = 'Montant par défaut';
            DecimalPlaces = 3 : 3;

            trigger OnValidate()
            begin
                IF EmploymentContract.GET("Emplymt. Contract Code") THEN BEGIN
                    IF Regimesofwork.GET(EmploymentContract."Work Regime") THEN
                        IF "Evaluation mode" = "Evaluation mode"::"On Worked Hour" THEN
                            "Basis amount" := "Default amount" * Regimesofwork."Work Hours per month"
                        ELSE
                            "Basis amount" := "Default amount"
                END;
            end;
        }
        field(50000; "Minimum value"; Decimal)
        {
            CaptionML = ENU = 'Minimum value', FRA = 'Valeur minimale';
            DecimalPlaces = 3 : 3;
        }
        field(50010; "Application Month"; Text[30])
        {
            CaptionML = ENU = 'Application Month', FRA = 'Mois d''application';
            FieldClass = Normal;
        }
        field(50050; "Not incl. Nat. Old Age Insur."; Boolean)
        {
            CaptionML = ENU = 'Not incl. Nat. Old Age Insur.', FRA = 'Non Inclis en AV NAt';
        }
        field(50051; "Not Included Public Holidays"; Boolean)
        {
            CaptionML = ENU = 'Not Included Public Holidays', FRA = 'Non inclus jours fériés';
        }
        field(39001440; Rate; Decimal)
        {
            CaptionML = ENU = 'Rate', FRA = 'Taux';
            DecimalPlaces = 0 : 5;
        }
        field(39001441; "Indemnity Type"; Enum "WDC Indemnity Type")
        {
            CaptionML = ENU = 'Indemnity Type', FRA = 'Type d''indemnité';
        }
        field(39001450; "Not Included in Accounting"; Boolean)
        {
            CaptionML = ENU = 'Not Included in Accounting', FRA = 'Non inclus dans comptabilité';
        }
        field(39001451; "Not Included in Bonus"; Boolean)
        {
            CaptionML = ENU = 'Not Included in Bonus', FRA = 'Non inclus dans bonus';
        }
        field(39001460; "Amount Rounding Precision"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            CaptionML = ENU = 'Amount Rounding Precision', FRA = 'Précision d''arrondi montant';
        }
        field(39001461; "Rounding Direction"; Enum "WDC Arround Type")
        {
            CaptionML = ENU = 'Rounding Direction', FRA = 'Sens d''arrondi';
        }
        field(39001462; "Included in Insurance Base"; Boolean)
        {
            CaptionML = ENU = 'Included in Insurance Base', FRA = 'Inclus dans base d''assurance';
        }
        field(39001463; "Basis amount"; Decimal)
        {
            CaptionML = ENU = 'Basis amount', FRA = 'Montant de base';
        }
        field(39001464; "Not included in vacation days"; Boolean)
        {
            CaptionML = ENU = 'Not included in vacation days', FRA = 'Non inclus dans jours congé';
        }
        field(39001537; "Archived contract code"; Code[20])
        {
            TableRelation = "WDC Hist. contrat de travail";
            CaptionML = ENU = 'Archived contract code', FRA = 'Code contrat archivé';
        }
    }

    keys
    {
        key(Key1; "Emplymt. Contract Code", "Indemnity Code", "Archived contract code")
        {
            Clustered = true;
            SumIndexFields = "Default amount", "Basis amount";
        }
        key(Key2; "Indemnity Type", "Indemnity Code", "Emplymt. Contract Code")
        {
            SumIndexFields = "Basis amount";
        }
        key(Key3; "Emplymt. Contract Code", "Evaluation mode", "Not included in vacation days")
        {
            SumIndexFields = "Basis amount";
        }
        key(Key4; "Archived contract code", "Emplymt. Contract Code")
        {
        }
    }



    var
        Indemnity: Record "WDC Indemnity";
        SelectedInd: Record "WDC Indemnity";
        EmploymentContract: Record 5211;
        Regimesofwork: Record "WDC work Regimes";
        "College1": Record "WDC College";
        Emp: Record Employee;
        PageIndemnity: Page "WDC Indemnities List";
}

