page 55013 "WDC Loan List"
{
    CaptionML = ENU = 'Loan List', FRA = 'Liste prêts';
    CardPageID = "WDC Loans";
    Editable = false;
    PageType = List;
    SourceTable = "WDC Loan & Advance";
    SourceTableView = WHERE(Type = FILTER(Loan));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                captionML = ENU = 'General', FRA = 'Général';

                field("No."; Rec."No.")
                {
                    StyleExpr = FieldStyle;
                    applicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    StyleExpr = FieldStyle;
                    applicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    StyleExpr = FieldStyle;
                    applicationArea = all;
                }
                field("Document type"; Rec."Document type")
                {
                    StyleExpr = FieldStyle;
                    applicationArea = all;
                }
                field("Effective date"; Rec."Effective date")
                {
                    StyleExpr = FieldStyle;
                    applicationArea = all;
                }
                field("End date Loan"; Rec."End date Loan")
                {
                    StyleExpr = FieldStyle;
                    applicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Total to repay"; Rec."Total to repay")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            group("P&osting")
            {
                CaptionML = ENU = 'P&osting', FRA = 'Validation';

                action("P&ost")
                {
                    CaptionML = ENU = 'P&ost', FRA = 'Valider';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        LoanAdvance.SETRANGE("No.", Rec."No.");
                        LoanAdvance.SETRANGE("Document type", Rec."Document type");
                        LoanAdvance.SETRANGE(Type, Rec.Type);

                        IF LoanAdvance.FINDFIRST THEN BEGIN
                            //IF MgmtLoansAdvances.TestValiditeDocument(LoanAdvance) THEN
                            REPORT.RUNMODAL(55002, TRUE, TRUE, LoanAdvance);
                        END;

                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }
    var
        HumRessSetup: Record "Human Resources Setup";
        LoanAdvance: Record "WDC Loan & Advance";
        MgmtLoansAdvances: Codeunit "WDC Mgmt. Loans & Adv";
        FieldStyle: Text[50];








}

