page 55073 "WDC Arch. Closed Loans & Adv."
{
    CaptionML = ENU = 'Archives Closed Loans & Advances', FRA = 'Archives Prêts et Avances clôturés';
    //DataCaptionExpression = FORMAT(Type) + ' ' + "No." + '-->' + Name;
    DataCaptionFields = Type, "No.", Name;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = 55012;
    SourceTableView = SORTING("No.")
                      WHERE(Type = FILTER(Advance),
                            Status = FILTER(Enclosed));

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Employee; Rec."Employee No.")
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
                    ApplicationArea = all;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Effective date"; Rec."Effective date")
                {
                    Editable = false;
                    ApplicationArea = all;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
            }
            part("WDC Loan Advance lines"; 55024)
            {
                Editable = false;
                ApplicationArea = all;
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
                field("Total to re  pay"; Rec."Total to repay")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Repayment sli  ces"; Rec."Repayment slices")
                {
                    CaptionML = ENU = 'Repayment Slices', FRA = 'Tranches remboursement';
                    ApplicationArea = all;
                }
                field("%Rep  aid"; Rec."Repaid %")
                {
                    ExtendedDatatype = Ratio;
                    ApplicationArea = all;
                }
                field("Montant tran  che"; Rec."Slice Amount")
                {
                    ApplicationArea = all;
                }
                field("Repaiment li  nes"; Rec."Repaiment lines")
                {
                    ApplicationArea = all;
                }
                field("Date d'effe  t 2"; Rec."Effective date")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Date fin P  rêt"; Rec."End date Loan")
                {
                    ApplicationArea = all;
                }
                field("Repaid amo  unt"; Rec."Repaid amount")
                {
                    ApplicationArea = all;
                }
                field("Repai  d %"; Rec."Repaid %")
                {
                    ApplicationArea = all;
                }
                field(Balance; Rec."Total to repay" - rec."Repaid amount")
                {
                    Caption = 'Solde';
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Principal Amo  unt"; Rec."Principal Amount")
                {
                    ApplicationArea = all;
                }
                field("Interest Amo  unt"; Rec."Interest Amount")
                {
                    ApplicationArea = all;
                }
                field("Not incl  ude"; Rec."Not include")
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
            group(FctButton)
            {
                CaptionML = ENU = 'Functions', FRA = 'Fonctions';
                action(So)
                {
                    CaptionML = ENU = 'Settle Document', FRA = 'Solder document';
                    Image = Balance;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        MgmtLoansAdvances: Codeunit "WDC Mgmt. Loans & Adv";
                        LoanAdvanceHeader: Record "WDC Loan & Advance";
                    begin
                        LoanAdvanceHeader.RESET;
                        LoanAdvanceHeader.SETFILTER("No.", Rec."No.");
                        REPORT.RUN(50062, TRUE, FALSE, LoanAdvanceHeader);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Print Receipt Voucher")
            {
                CaptionML = ENU = 'Print Receipt Voucher', FRA = 'Imprimer pièce recette';
                Image = PrintVAT;
                Promoted = false;
                ApplicationArea = all;
                trigger OnAction()
                var
                begin
                    CurrPage."WDC Loan Advance lines".PAGE.ImprPRecette;
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
            "%Repaid" := ROUND((Rec."Repaid %" / 100) * 10000, 1);
        END
        ELSE BEGIN
            "%Amont" := 0;
            "%Repaid" := 0;
        END;

        FctButtonEnable := Rec.Status = Rec.Status::"In progress";
    end;

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
        FctButtonEnable := TRUE;
        IF Empl.GET(rec."Employee No.") THEN;
    end;

    trigger OnOpenPage()
    begin
        OnActivateForm;
    end;

    var
        "%Amont": Integer;
        "%Repaid": Integer;
        Empl: Record Employee;
        MgmtLoansAdvances: Codeunit "WDC Mgmt. Loans & Adv";
        FctButtonEnable: Boolean;

    local procedure OnActivateForm()
    begin
        IF Empl.GET(rec."Employee No.") THEN;
        FctButtonEnable := Rec.Status = Rec.Status::"In progress";
    end;
}

