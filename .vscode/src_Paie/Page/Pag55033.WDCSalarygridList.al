page 55033 "WDC Salary Grid List"
{
    CaptionML = ENU = 'Salary Grid List', FRA = 'Liste grille salaire';
    Editable = false;
    PageType = Card;
    SourceTable = "WDC Salary grid header";

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
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

