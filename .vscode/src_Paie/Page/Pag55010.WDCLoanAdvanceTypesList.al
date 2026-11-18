page 55010 "WDC Loan & Advance Types List"
{
    CaptionML = ENU = 'Loan & Advance List', FRA = 'Prêts et Avances';
    Editable = false;
    PageType = Card;
    SourceTable = "WDC Loan & Advance Type";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = all;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                }
                field("Repayment slices"; Rec."Repayment slices")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

