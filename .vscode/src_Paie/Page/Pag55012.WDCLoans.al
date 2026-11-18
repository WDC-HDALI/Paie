page 55012 "WDC Loans"
{
    CaptionML = ENU = 'Loans', FRA = 'Prêts';
    PageType = Card;
    SourceTable = "WDC Loan & Advance";
    SourceTableView = WHERE(Type = FILTER(Loan));

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    trigger OnAssistEdit()
                    begin
                        // IF AssistEdit(xRec) THEN
                        //     CurrPage.UPDATE;
                    end;
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
                field("Include Other Payroll"; Rec."Include Other Payroll")
                {
                    ApplicationArea = all;
                }
                field("Global dimension 1"; Rec."Global dimension 1")
                {
                    ApplicationArea = all;
                }
                field("Global dimension 2"; Rec."Global dimension 2")
                {
                    ApplicationArea = all;
                }
            }
            group(Loan)
            {
                CaptionML = ENU = 'Loan', FRA = 'Prêt';
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Document type"; Rec."Document type")
                {
                    ApplicationArea = all;
                }
                field("Effective date"; Rec."Effective date")
                {
                    ApplicationArea = all;
                }
                field("End date Loan"; Rec."End date Loan")
                {
                    ApplicationArea = all;
                }
                field("Unlock Date"; Rec."Unlock Date")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
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
                field("Slice Amount"; Rec."Slice Amount")
                {
                    Visible = true;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = all;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field("Depreciation type"; Rec."Depreciation type")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Loan_g)
            {
                CaptionML = ENU = 'Loan', FRA = 'Prêt';
                action("Tableau d'amortissement")
                {
                    CaptionML = ENU = 'Amortization Schedule', FRA = 'Tableau d''amortissement';
                    Image = DepreciationBooks;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        CLEAR(T1);
                        T1.RESET;
                        T1.SETFILTER("No.", Rec."No.");
                        REPORT.RUN(55025, TRUE, FALSE, T1);
                    end;
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                CaptionML = ENU = 'P&osting', FRA = 'Validation';
                action("Liste Document En attente")
                {
                    CaptionML = ENU = 'Documents in Progress', FRA = 'Liste des documents en attente';
                    Image = AddWatch;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        LoanAdvance.SETRANGE(Type, 1);
                        REPORT.RUN(55023, TRUE, TRUE, LoanAdvance);
                    end;
                }
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

                        CurrPage.UPDATE(TRUE);
                    end;
                }
                // action("Post and &Print")
                // {
                //     CaptionML = ENU = 'Post and &Print', FRA = 'Valider et imprimer';
                //     Image = PostPrint;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     ShortCutKey = 'Ctrl+F7';
                //     ApplicationArea = all;
                //     trigger OnAction()
                //     begin
                //         HumRessSetup.GET();
                //         LoanAdvance.SETRANGE("No.", Rec."No.");
                //         //REPORT.RUN(39001430,FALSE,FALSE,LoanAdvance);
                //         IF LoanAdvance.FINDFIRST THEN BEGIN
                //             IF MgmtLoansAdvances.TestValiditeDocument(LoanAdvance) THEN;
                //             REPORT.RUNMODAL(55002, TRUE, TRUE, LoanAdvance);
                //             // REPORT.RUNMODAL (REPORT::Report8099010,TRUE,TRUE,LoanAdvance);
                //         END;
                //         CurrPage.UPDATE(TRUE);
                //     end;
                // }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Loan;
        Rec."Depreciation Type" := Rec."Depreciation Type"::Constant;
    end;

    var
        MgmtLoansAdvances: Codeunit "WDC Mgmt. Loans & Adv";
        HumRessSetup: Record "Human Resources Setup";
        LoanAdvance: Record "WDC Loan & Advance";
        T1: Record "WDC Loan & Advance";
}

