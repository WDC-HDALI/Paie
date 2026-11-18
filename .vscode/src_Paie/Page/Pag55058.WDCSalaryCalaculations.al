page 55058 "WDC Salary Calaculations"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Salary Calaculations', FRA = 'Calculs salaire';
    PageType = List;
    SourceTable = "WDC Salary Header";
    CardPageId = "WDC Calculation of Salaries";
    editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Paid days"; Rec."Paid days")
                {
                    ApplicationArea = All;
                }
                field("Worked days"; Rec."Worked days")
                {
                    ApplicationArea = All;
                }
                field("Tax Regulation"; Rec."Tax Regulation")
                {
                    ApplicationArea = All;
                }
                field("Month"; Rec."Month")
                {
                    ApplicationArea = All;
                }
                field("Year"; Rec."Year")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}
