page 55015 "WDC Advances List"
{
    CaptionML = ENU = 'Advances List', FRA = 'Liste avances';
    PageType = List;
    CardPageId = "WDC Advance";
    SourceTable = "WDC Loan & Advance";
    SourceTableView = WHERE(Type = FILTER(advance));
    editable = false;
    layout
    {
        area(content)
        {
            group(Advances)
            {
                CaptionML = ENU = 'Advances', FRA = 'Avances';
                field("Total Advances"; TotalAvance)
                {
                    captionML = ENU = 'Total Advances', FRA = 'Total des avances';
                    ApplicationArea = all;
                }
            }
            repeater(Group)
            {
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
                field("Global dimension 1"; Rec."Global dimension 1")
                {
                    ApplicationArea = all;
                }
                field("Global dimension 2"; Rec."Global dimension 2")
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
                field("Posting Date"; Rec."Posting Date")
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
                field("Repayment slices"; Rec."Repayment slices")
                {
                    ApplicationArea = all;
                }
                field("Slice Amount"; Rec."Slice Amount")
                {
                    ApplicationArea = all;
                }
                field("Total to repay"; Rec."Total to repay")
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
                field("External Document No."; Rec."External Document No.")
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
                action("Accord Advance Loan")
                {
                    CaptionML = ENU = 'Accord Advance / Loan', FRA = 'Accord Avance / Prêt';
                    Ellipsis = true;
                    Image = TestReport;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        HumRessSetup.GET;
                        LoanAdvance.SETRANGE("No.", Rec."No.");
                        REPORT.RUN(55024, TRUE, TRUE, LoanAdvance);
                    end;
                }
                action("Print List")
                {
                    CaptionML = ENU = 'Print List', FRA = 'Impression liste';
                    Image = PrintVAT;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        LoanAdvance.SETRANGE(Type, LoanAdvance.Type::Advance);
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
                        LoanAdvance2.RESET;
                        LoanAdvance2.SETFILTER("Document type", '<>%1', '');
                        LoanAdvance2.SETFILTER(Amount, '=%1', 0);
                        IF LoanAdvance2.FINDFIRST THEN
                            REPEAT
                                LoanAdvance2.DELETE;
                            UNTIL LoanAdvance2.NEXT = 0;
                        LoanAdvance2.RESET;
                        LoanAdvance2.SETFILTER("Document type", '<>%1', '');
                        LoanAdvance2.SETFILTER(Amount, '>%1', 0);
                        IF LoanAdvance2.FINDFIRST THEN
                            REPEAT
                                REPORT.RUNMODAL(55002, FALSE, TRUE, LoanAdvance2);
                            UNTIL LoanAdvance2.NEXT = 0;

                        CurrPage.UPDATE;
                    end;
                }
                // action("Post and &Print") //Hamdi Migration
                // {
                //     Caption = 'Post and &Print';
                //     Image = PostPrint;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     ShortCutKey = 'Ctrl+F7';

                //     trigger OnAction()
                //     begin
                //         HumRessSetup.GET();
                //         LoanAdvance.SETRANGE("No.", Rec."No.");
                //         LoanAdvance.SETRANGE("Document type", Rec."Document type");
                //         LoanAdvance.SETRANGE(Type, Rec.Type);

                //         REPORT.RUN(55002, FALSE, FALSE, LoanAdvance);


                //         IF LoanAdvance.FINDFIRST THEN BEGIN
                //             IF MgmtLoansAdvances.TestValiditeDocument(LoanAdvance) THEN
                //                 REPORT.RUNMODAL(REPORT::Report81302, TRUE, TRUE, LoanAdvance);
                //         END;

                //         CurrPage.UPDATE;
                //     end;
                // }
                action("Import Advance")
                {
                    CaptionML = ENU = 'Import Advance', FRA = 'Import Avance';
                    Image = ImportExcel;
                    RunObject = XMLport 55047;
                    ApplicationArea = all;
                }
                action("Update Total Advances")
                {
                    CaptionML = ENU = 'Update Total Advances', FRA = 'Mise à jour total avances';
                    Image = UpdateXML;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        TotalAvance := 0;
                        CLEAR(Loan);
                        IF Loan.FINDFIRST THEN
                            REPEAT
                                TotalAvance += Loan.Amount;
                            UNTIL Loan.NEXT = 0;
                        CurrPage.UPDATE(TRUE);
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        Dateffet := 0D;
    end;

    var
        HumRessSetup: Record "Human Resources Setup";
        LoanAdvance: Record "WDC Loan & Advance";
        LoanAdvance2: Record "WDC Loan & Advance";
        Dateffet: Date;
        TotalAvance: Decimal;
        Loan: Record "WDC Loan & Advance";


}

