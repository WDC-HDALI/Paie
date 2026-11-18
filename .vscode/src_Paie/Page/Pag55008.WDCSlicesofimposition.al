page 55008 "WDC Slices of imposition"
{
    CaptionML = ENU = 'Slices of imposition', FRA = 'Tranches d''imposition';
    PageType = List;
    SourceTable = "WDC Slices of imposition";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field("Lower limit"; Rec."Lower limit")
                {
                    ApplicationArea = all;
                }
                field("Superior limit"; Rec."Superior limit")
                {
                    ApplicationArea = all;
                }
                field("Slice amount"; Rec."Slice amount")
                {
                    ApplicationArea = all;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;
}

