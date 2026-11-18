page 55075 "WDC Loan Adv. Arch. p. Closed"
{
    CaptionML = ENU = 'Loan Adv. Arch. p. Closed', FRA = 'Archives prêts et avances clôturés';
    DataCaptionFields = Type, "No.", Name;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = 55012;
    SourceTableView = SORTING("No.")
                      WHERE(Type = FILTER(<> Advance),
                            Status = FILTER(Enclosed));
    layout
    {
        area(content)
        {
            group("Général")
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Social Security No."; Empl."Social Security No.")
                {
                    CaptionML = ENU = 'Social Security No.', FRA = 'Matricule CNSS';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    Editable = false;
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
                field("Document type"; Rec."Document type")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Effective date"; Rec."Effective date")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
            }
            part(Line; "WDC Loan Advance lines")
            {
                ApplicationArea = all;
                Editable = false;
                SubPageLink = "No." = FIELD("No.");
                SubPageView = SORTING("No.", "Entry No.")
                              ORDER(Ascending);

            }
            group(Remboursement)
            {
                CaptionML = ENU = 'Repayment', FRA = 'Remboursement';
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Total to repay"; Rec."Total to repay")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Repayment slices"; Rec."Repayment slices")
                {
                    ApplicationArea = all;
                }
                field(RepaidPercent; RepaidPercent)
                {
                    ExtendedDatatype = Ratio;
                    ApplicationArea = all;
                }
                field("Slice Amount"; Rec."Slice Amount")
                {
                    ApplicationArea = all;
                }
                field("Repaiment lines"; Rec."Repaiment lines")
                {
                    ApplicationArea = all;
                }
                field("Date d'effet 2"; Rec."Effective date")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("End date Loan"; Rec."End date Loan")
                {
                    ApplicationArea = all;
                }
                field("Repaid amount"; Rec."Repaid amount")
                {
                    ApplicationArea = all;
                }
                field("Repaid %"; Rec."Repaid %")
                {
                    ApplicationArea = all;
                }
                field(Solde; Rec."Total to repay" - Rec."Repaid amount")
                {
                    CaptionML = ENU = 'Balance', FRA = 'Solde';
                    DecimalPlaces = 3 : 3;
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
                field("Not include"; Rec."Not include")
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
            action("Print Contract")
            {
                CaptionML = ENU = 'Print Contract', FRA = 'Imprimer Contrat de prêt';
                Image = PrintVAT;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    LoanAdvanceHeader: Record "WDC Loan & Advance";
                begin
                    LoanAdvanceHeader.RESET;
                    LoanAdvanceHeader.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(55004, TRUE, FALSE, LoanAdvanceHeader);
                end;
            }
            action("Actual Amortization Table")
            {
                CaptionML = ENU = 'Actual Amortization Table', FRA = 'Tableau amortissement Actuel';
                Image = DepreciationBooks;
                Visible = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    LoanAdvance: Record "WDC Loan & Advance";
                begin
                    CLEAR(LoanAdvance);
                    LoanAdvance.RESET;
                    LoanAdvance.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(55005, TRUE, FALSE, LoanAdvance);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Empl.GET(Rec."Employee No.") THEN;

        Rec.CALCFIELDS("Repaid amount", "Repaid %");
        IF ((Rec."Repaid amount" <> 0) AND (Rec."Repaid %" <> 0)) THEN BEGIN
            "%Amont" := ROUND((Rec."Repaid amount" / Rec."Total to repay") * 10000, 1);
            RepaidPercent := ROUND((Rec."Repaid %" / 100) * 10000, 1);
        END
        ELSE BEGIN
            "%Amont" := 0;
            RepaidPercent := 0;
        END;

        FctButtonEnable := Rec.Status = rec.Status::"In progress";
    end;

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
        FctButtonEnable := TRUE;
        IF Empl.GET(Rec."Employee No.") THEN;
    end;

    trigger OnOpenPage()
    begin
        OnActivateForm;
    end;

    var
        "%Amont": Integer;
        RepaidPercent: Integer;
        Empl: Record Employee;
        FctButtonEnable: Boolean;

    local procedure OnActivateForm()
    begin
        IF Empl.GET(Rec."Employee No.") THEN;
        FctButtonEnable := Rec.Status = rec.Status::"In progress";
    end;
}

