page 55065 "WDC Employment Contract"
{
    CaptionML = ENU = 'Employment Contract', FRA = 'Contrat travail';
    PageType = Card;
    SourceTable = 5211;

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                    trigger OnAssistEdit()
                    begin
                        //IF AssistEdit(xRec) THEN
                        CurrPage.UPDATE;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Regular payments"; Rec."Regular payments")
                {
                    Editable = true;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Temporary payments"; Rec."Temporary payments")
                {
                    ApplicationArea = all;
                }
                field("Employee type"; Rec."Employee type")
                {
                    ApplicationArea = all;
                }
                field("Work Regimes"; Rec."Work Regime")
                {
                    ApplicationArea = all;
                }
                field("Employee Contract Type"; Rec."Employee Contract Type")
                {
                    ApplicationArea = all;
                }
                field("Salary grid"; Rec."Salary grid")
                {
                    ApplicationArea = all;
                }
                field("Slice of imposition"; Rec."Slice of imposition")
                {
                    TableRelation = "WDC Slices of imposition".Code;
                    ApplicationArea = all;
                }
                field("Inclusive ratio"; Rec."Inclusive ratio")
                {
                    ApplicationArea = all;
                }
                field(Taxable; Rec.Taxable)
                {
                    ApplicationArea = all;
                }
                field("Taxes Calculation Mode"; Rec."Taxes Calculation Mode")
                {

                    trigger OnValidate()
                    begin
                        CalculationmodeofthetaxesOnAft;
                    end;
                }
            }
            group(Indemnities)
            {
                CaptionML = ENU = 'Indemnities', FRA = 'Indemnités';
                part("WDC Empl. Contracts List Ind"; "WDC Empl. Contracts List Ind")
                {
                    SubPageLink = "Emplymt. Contract Code" = FIELD(Code);
                    ApplicationArea = all;
                }
            }
            group("Soc. Contribution")
            {
                CaptionML = ENU = 'Soc. Contribution', FRA = 'Cotisations Sociale';
                part("WDC Empl. Contracts List Cot"; "WDC Empl. Contracts List Cot")
                {
                    SubPageLink = "Emplymt. Contract Code" = FIELD(Code);
                    ApplicationArea = all;
                }
            }
        }
    }



    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Employee type");
        IF Rec."Taxes Calculation Mode".AsInteger() = 0 THEN
            "Inclusive ratioEditable" := FALSE
        ELSE
            "Inclusive ratioEditable" := TRUE;
    end;

    trigger OnInit()
    begin
        "Inclusive ratioEditable" := TRUE;
    end;

    var
        "Inclusive ratioEditable": Boolean;

    local procedure CalculationmodeofthetaxesOnAft()
    begin
        IF Rec."Taxes Calculation Mode".AsInteger() = 0 THEN
            "Inclusive ratioEditable" := FALSE
        ELSE
            "Inclusive ratioEditable" := TRUE;
    end;
}

