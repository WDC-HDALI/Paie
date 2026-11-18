page 55080 "WDC Slices of imposition CSS"
{
    CaptionML = ENU = 'Slices of imposition', FRA = 'Tranches d''imposition';
    PageType = List;
    SourceTable = "WDC Slices of imposition_CSS";

    layout
    {
        area(content)
        {
            repeater(General)
            {
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

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;
}

