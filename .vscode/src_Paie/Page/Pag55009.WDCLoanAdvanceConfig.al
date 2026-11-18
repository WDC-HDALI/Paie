page 55009 "WDC Loan & Advance Config."
{
    CaptionML = ENU = 'Loan & Advance Config.', FRA = 'Paramètres prêts et avances';
    PageType = List;
    SourceTable = "WDC Loan & Advance Type";

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
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Default Type"; Rec."Default Type")
                {
                    ApplicationArea = all;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = all;
                }
                field("Advance on Holiday"; Rec."Advance on Holiday")
                {
                    ApplicationArea = all;
                }
                field("Advance on Bonus"; Rec."Advance on Bonus")
                {
                    ApplicationArea = all;
                }
                field("Interest %"; Rec."Interest %")
                {
                    ApplicationArea = all;
                }
                field("Repayment slices"; Rec."Repayment slices")
                {
                    ApplicationArea = all;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = all;
                }
                field("Interest Account No."; Rec."Interest Account No.")
                {
                    ApplicationArea = all;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = all;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = all;
                }
                field("Accounting Posting"; Rec."Accounting Posting")
                {
                    ApplicationArea = all;
                }
                field("Depreciation type"; Rec."Depreciation type")
                {
                    ApplicationArea = all;
                }
                field("Precision Arrondi Principale"; Rec."Precision Arrondi Principale")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

