page 55001 "WDC Work Regime Card"
{
    CaptionML = ENU = 'Work Regime Card', FRA = 'Fiche Régime travail';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "WDC work Regimes";
    SourceTableView = SORTING(Code);

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
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Payroll Calculation Type"; Rec."Payroll Calculation Type")
                {
                    ApplicationArea = all;
                }
                field("Calendar Type"; Rec."Calendar Type")
                {
                    ApplicationArea = all;
                }
                field("Work Hours per week"; Rec."Work Hours per week")
                {
                    ApplicationArea = all;
                }
                field("Work Hours per month"; Rec."Work Hours per month")
                {
                    ApplicationArea = all;
                }
                field("Worked Day Per Month"; Rec."Worked Day Per Month")
                {
                    ApplicationArea = all;
                }
                field("Nbre Jour Payé Per Month"; Rec."Nbre Jour Payé Per Month")
                {
                    ApplicationArea = all;
                }
                field("Default Regime"; Rec."Default Regime")
                {
                    ApplicationArea = all;
                }
                field("Appliquer Régime"; Rec."Appliquer Régime")
                {
                    ApplicationArea = all;
                }
            }
            group("Supp. Hours")
            {
                Caption = 'Supp. Hours';
                field("Max. Supp. Hours per month"; Rec."Max. Supp. Hours per month")
                {
                    ApplicationArea = all;
                }
            }
            group("Days off")
            {
                Caption = 'Days off';
                field("Days off per month"; Rec."Days off per month")
                {
                    ApplicationArea = all;
                }
                field("Assignement mode"; Rec."Assignement mode")
                {
                    ApplicationArea = all;
                }
                field("Rétributions Ancienneté/An"; Rec."Rétributions Ancienneté/An")
                {
                    Editable = RétributionsAnciennetéAnEditab;
                    ApplicationArea = all;
                }
                field("Plafond Ancienneté/An"; Rec."Plafond Ancienneté/An")
                {
                    Editable = "Plafond Ancienneté/AnEditable";
                    ApplicationArea = all;
                }
                field("Limite ancienneté"; Rec."Limite ancienneté")
                {
                    Editable = "Limite anciennetéEditable";
                    ApplicationArea = all;
                }
            }
        }
    }


    trigger OnInit()
    begin
        "Limite anciennetéEditable" := TRUE;
        "Plafond Ancienneté/AnEditable" := TRUE;
        RétributionsAnciennetéAnEditab := TRUE;
    end;

    trigger OnOpenPage()
    begin
        RecGPramRessHum.GET();
        IF RecGPramRessHum."Apply Retribution for Old Days" = FALSE THEN BEGIN
            RétributionsAnciennetéAnEditab := FALSE;
            "Plafond Ancienneté/AnEditable" := FALSE;
            "Limite anciennetéEditable" := FALSE;
        END;
    end;

    var

        RecGPramRessHum: Record "Human Resources Setup";
        "RétributionsAnciennetéAnEditab": Boolean;
        "Plafond Ancienneté/AnEditable": Boolean;
        "Limite anciennetéEditable": Boolean;
}

