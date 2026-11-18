page 55005 "WDC Empl. Contracts List Ind"
{
    CaptionML = ENU = 'Indemnities List', FRA = 'Liste indemnités';
    PageType = ListPart;
    SourceTable = "WDC Default Indemnities";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                captionML = ENU = 'General', FRA = 'Général';
                field("Indemnity Code"; Rec."Indemnity Code")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Tax-exempt (-5000 DT)"; Rec."Tax-exempt (-5000 DT)")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Included in Overtime"; Rec."Included in Overtime")
                {
                    ApplicationArea = all;
                }
                field("Default amount"; Rec."Default amount")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Basis amount"; Rec."Basis amount")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Indemnity Account No."; Rec."Indemnity Account No.")
                {
                    ApplicationArea = all;
                }
                field("Indemnity Balance Account No."; Rec."Indemnity Balance Account No.")
                {
                    ApplicationArea = all;
                }
                field("Not included in vacation days"; Rec."Not included in vacation days")
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
                field("Evaluation mode"; Rec."Evaluation mode")
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field("Indemnity Type"; Rec."Indemnity Type")
                {
                    ApplicationArea = all;
                }
                field("Days Number"; Rec."Days Number")
                {
                    ApplicationArea = all;
                }
                field("Amount Rounding Precision"; Rec."Amount Rounding Precision")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Included Breastfeeding Hours"; Rec."Included Breastfeeding Hours")
                {
                    ApplicationArea = all;
                }
                field("Included in UGTT Hours"; Rec."Included in UGTT Hours")
                {
                    ApplicationArea = all;
                }
                field("Includes Extra Days"; Rec."Includes Extra Days")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

