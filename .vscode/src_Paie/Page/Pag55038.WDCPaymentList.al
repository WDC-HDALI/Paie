page 55038 "WDC Payment List"
{
    CaptionML = ENU = 'Payments List', FRA = 'Liste paiements';
    CardPageID = "WDC Calculation of salaries";
    Editable = false;
    PageType = List;
    SourceTable = 55022;

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = all;
                }
                field(Year; Rec.Year)
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

