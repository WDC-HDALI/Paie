page 55032 "WDC College"
{
    CaptionML = ENU = 'Category', FRA = 'Catégorie';
    Editable = true;
    PageType = List;
    SourceTable = "WDC College";

    layout
    {
        area(content)
        {
            repeater(General)
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
                field("Borne inférieure"; Rec."Lower Limit")
                {
                    ApplicationArea = all;
                }
                field("Borne Supérieure"; Rec."Upper Limit")
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

