page 55024 "WDC Loan Advance lines"
{
    CaptionML = ENU = 'Loan Advance lines', FRA = 'Lignes de prêt et avance';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = "WDC Loan & Advance Lines";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Type Tranche"; Rec."Type Tranche")
                {
                    ApplicationArea = all;
                }
                field("Payment No."; Rec."Payment No.")
                {
                    ApplicationArea = all;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Line Amount"; Rec."Line Amount")
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
                field("Line %"; Rec."Line %")
                {
                    ApplicationArea = all;
                }
                field(Paid; Rec.Paid)
                {
                    ApplicationArea = all;
                }
            }
        }
    }



    var
        LoanAdvanceLines: Record "WDC Loan & Advance Lines";


    procedure ImprPRecette()
    begin
        LoanAdvanceLines.RESET;
        LoanAdvanceLines.SETFILTER("No.", Rec."No.");
        LoanAdvanceLines.SETRANGE("Entry No.", Rec."Entry No.");
        REPORT.RUNMODAL(55027, TRUE, FALSE, LoanAdvanceLines);
    end;
}

