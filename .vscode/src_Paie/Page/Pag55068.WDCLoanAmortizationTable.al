page 55068 "WDC Loan Amortization Table"
{
    PageType = List;
    SourceTable = 55049;
    CaptionML = ENU = 'Loan Amortization Table', FRA = 'Tableau d''amortissement des prêts';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Interest Calculation Base"; Rec."Interest Calculation Base")
                {
                    ApplicationArea = all;
                }
                field(Annuity; Rec.Annuity)
                {
                    ApplicationArea = all;
                }
                field("Annual Interest"; Rec."Annual Interest")
                {
                    ApplicationArea = all;
                }
                field("Principal Repaid"; Rec."Principal Repaid")
                {
                    ApplicationArea = all;
                }
                field("Remaining Principal"; Rec."Remaining Principal")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

