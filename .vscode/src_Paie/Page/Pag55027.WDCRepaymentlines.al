page 55027 "WDC Repayment lines"
{
    CaptionML = ENU = 'Repayment lines', FRA = 'Lignes de remboursement';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "WDC Loan & Advance Lines";

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

                field("Nom "; Rec.FullName)
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }

                field(Type; Rec.Type)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Principal Amount"; Rec."Principal Amount")
                {
                    ApplicationArea = all;
                }
                field("Interest Amount"; Rec."Interest Amount")
                {
                    ApplicationArea = all;
                }
                field("Document type"; Rec."Document type")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = all;
                }
                field("Line %"; Rec."Line %")
                {
                    ApplicationArea = all;
                }
                field("Payment No."; Rec."Payment No.")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(Paid; Rec.Paid)
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Print)
            {
                Image = PostPrint;
                CaptionML = ENU = 'Print', FRA = 'Imprimer';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    REPORT.RUN(52078161, TRUE, TRUE, Rec)
                end;
            }
        }
    }

}

