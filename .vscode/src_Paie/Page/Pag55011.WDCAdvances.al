page 55011 "WDC Advance"
{
    CaptionML = ENU = 'Advance', FRA = 'Avance';
    PageType = Card;
    SourceTable = "WDC Loan & Advance";
    SourceTableView = WHERE(Type = FILTER(Advance));

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
                    Editable = false;

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
            }
            group(Advance)
            {
                CaptionML = ENU = 'Advance', FRA = 'Avance';
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
                field("Total Month Advance"; Rec."Total Month Advance")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Type Tranche"; Rec."Type Tranche")
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
                action("Advance/Loan Agreement")
                {
                    CaptionML = ENU = 'Advance/Loan Agreement', FRA = 'Accord Avance / Prêt';
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
                        LoanAdvance.SETRANGE(Type, 0);
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
                        CurrPage.UPDATE;
                    end;
                }
                // action("Post and &Print") //Hamdi Migration
                // {
                //     CaptionML = ENU = 'Post and &Print', FRA = 'Valider et imprimer';
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
                //         // IF LoanAdvance.FINDFIRST THEN BEGIN
                //         //     IF MgmtLoansAdvances.TestValiditeDocument(LoanAdvance) THEN
                //         //         REPORT.RUNMODAL(REPORT::Report81302, TRUE, TRUE, LoanAdvance);
                //         // END;

                //         CurrPage.UPDATE;
                //     end;
                // }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Initialisate;
    end;

    trigger OnInit()
    begin
        "Montant H TravailVisible" := TRUE;
        "Heure TravailéVisible" := TRUE;
        "jour AbsenceVisible" := TRUE;
        "Salaire de BaseVisible" := TRUE;
        datet := WORKDATE;
        datet := DMY2DATE(1, DATE2DMY(datet, 2), DATE2DMY(datet, 3));
        Rec.SETFILTER("Date Filter", '%1..%2', datet, CALCDATE('<+CM>', datet));//WDC
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    Var
        lLoanAdvanceType: Record 55010;
    begin
        Rec.Type := Rec.Type::Advance;
        Rec."Effective date" := WorkDate();
        lLoanAdvanceType.Reset();
        lloanAdvanceType.SetRange(type, Rec.Type::Advance);
        if lLoanAdvanceType.FindFirst() then
            Rec.Validate("Document type", lLoanAdvanceType.code);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Initialisate;
    end;

    var
        HumRessSetup: Record "Human Resources Setup";
        MgmtLoansAdvances: Codeunit "WDC Mgmt. Loans & Adv";
        LoanAdvance: Record "WDC Loan & Advance";
        datet: Date;
        "Salaire de BaseVisible": Boolean;
        "jour AbsenceVisible": Boolean;
        "Heure TravailéVisible": Boolean;
        "Montant H TravailVisible": Boolean;


    local procedure Initialisate()
    begin
        xRec := Rec;
        CASE Rec."Employee type".AsInteger() OF
            0:
                BEGIN
                    "Salaire de BaseVisible" := FALSE;
                    "jour AbsenceVisible" := FALSE;
                    "Heure TravailéVisible" := TRUE;
                    "Montant H TravailVisible" := TRUE;
                END;
            1:
                BEGIN
                    "Salaire de BaseVisible" := TRUE;
                    "jour AbsenceVisible" := TRUE;
                    "Heure TravailéVisible" := FALSE;
                    "Montant H TravailVisible" := FALSE;

                END;
        END;
        datet := 0D;
        IF FORMAT(Rec."Posting Date") <> '' THEN
            datet := Rec."Posting Date"
        ELSE
            datet := WORKDATE;
        datet := DMY2DATE(1, DATE2DMY(datet, 2), DATE2DMY(datet, 3));
        Rec.SETFILTER("Date Filter", '%1..%2', datet, CALCDATE('<+CM>', datet));//WDC


    end;
}

