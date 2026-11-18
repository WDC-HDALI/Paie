page 55026 "WDC Loan & Advance List Bis"
{
    CaptionML = ENU = 'Bis Loan & Advance List', FRA = 'Liste des prêts et avances Bis';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "WDC Loan & Advance";

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
                field(Employee; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = all;
                }
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Document type"; Rec."Document type")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Interest %"; Rec."Interest %")
                {
                    ApplicationArea = all;
                }
                field("Total to repay"; Rec."Total to repay")
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

