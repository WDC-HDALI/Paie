page 55053 "WDC Hist. Default Indemnities"
{
    CaptionML = ENU = 'Hist. Default Indemnities', FRA = 'Hist. Indemnités par Défaut';
    PageType = ListPart;
    SourceTable = "WDC Hist. Default Indemnities";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                Editable = false;
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = all;
                }
                field("Indemnity Code"; Rec."Indemnity Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Evaluation mode"; Rec."Evaluation mode")
                {
                    ApplicationArea = all;
                }
                field("Default amount"; Rec."Default amount")
                {
                    ApplicationArea = all;
                }
                field("Minimum value"; Rec."Minimum value")
                {
                    ApplicationArea = all;
                }
                field("Application Month"; Rec."Application Month")
                {
                    ApplicationArea = all;
                }
                field("Not incl. Nat. Old Age Insur."; Rec."Not incl. Nat. Old Age Insur.")
                {
                    ApplicationArea = all;
                }
                field("Not Included Public Holidays"; Rec."Not Included Public Holidays")
                {
                    ApplicationArea = all;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = all;
                }
                field("Indemnity Type"; Rec."Indemnity Type")
                {
                    ApplicationArea = all;
                }
                field("Not Included in Accounting"; Rec."Not Included in Accounting")
                {
                    ApplicationArea = all;
                }
                field("Not Included in Bonus"; Rec."Not Included in Bonus")
                {
                    ApplicationArea = all;
                }
                field("Amount Rounding Precision"; Rec."Amount Rounding Precision")
                {
                    ApplicationArea = all;
                }
                field("Rounding Direction"; Rec."Rounding Direction")
                {
                    ApplicationArea = all;
                }
                field("Included in Insurance Base"; Rec."Included in Insurance Base")
                {
                    ApplicationArea = all;
                }
                field("Basis amount"; Rec."Basis amount")
                {
                    ApplicationArea = all;
                }
                field("Not included in vacation days"; Rec."Not included in vacation days")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

