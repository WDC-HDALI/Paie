page 55072 "WDC Loan Adv. arch. In Prog."
{
    CaptionML = ENU = 'Loans & Advances In Progress', FRA = 'Prêts & Avances en cours';
    DataCaptionFields = Type, "No.", Name;
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "WDC Loan & Advance Header";
    SourceTableView = SORTING("No.")
                      WHERE(Type = FILTER(Advance),
                            Status = FILTER("In progress"));

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
                field("Type Tranche"; Rec."Type Tranche")
                {
                    ApplicationArea = all;
                }
                field("Inclus Paie Autre"; Rec."Inclus Paie Autre")
                {
                    ApplicationArea = all;
                }
                field("Advance on Holiday"; Rec."Advance on Holiday")
                {
                    CaptionML = ENU = 'Advance on Holiday', FRA = 'Prêt sur congé';
                    ApplicationArea = all;
                }
                field("Avance Sur Prime"; Rec."Avance Sur Prime")
                {
                    CaptionML = ENU = 'Advance on Bonus', FRA = 'Avance sur prime';
                    ApplicationArea = all;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Depreciation type"; Rec."Depreciation type")
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
                Editable = true;
                SubPageLink = "No." = field("No.");
                SubPageView = SORTING("No.", "Entry No.")
                              ORDER(Ascending);
                ApplicationArea = all;
            }
            group(Remboursement)
            {
                CaptionML = ENU = 'Repayment', FRA = 'Remboursement';
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Total to re   pay"; Rec."Total to repay")
                {
                    ApplicationArea = all;
                }
                field("Repayment sli   ces"; Rec."Repayment slices")
                {
                    ApplicationArea = all;
                }
                field("%Repaid"; ROUND((Rec."Repaid amount" / Rec."Total to repay") * 100, 0.01))
                {
                    CaptionML = ENU = 'Repaid %', FRA = '% remboursé';
                    ExtendedDatatype = Ratio;
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Montant tran   che"; Rec."Slice Amount")
                {
                    ApplicationArea = all;
                }
                field("Repaiment lines"; Rec."Repaiment lines")
                {
                    ApplicationArea = all;
                }
                field("Date d'effe   t 2"; Rec."Effective date")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Date fin P   rêt"; Rec."End date Loan")
                {
                    ApplicationArea = all;
                }
                field("Repaid amo   unt"; Rec."Repaid amount")
                {
                    ApplicationArea = all;
                }
                field("Repaid %"; Rec."Repaid %")
                {
                    CaptionML = ENU = 'Repaid %', FRA = '% remboursé';
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
        area(navigation)
        {
            group(FctButton)
            {
                CaptionML = ENU = 'Functions', FRA = 'Fonctions';
                action("Settle Document")
                {
                    CaptionML = ENU = 'Settle Document', FRA = 'Solder document';
                    Image = Balance;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        LoanAdvanceHeader: Record "WDC Loan & Advance";
                    begin
                        LoanAdvanceHeader.RESET;
                        LoanAdvanceHeader.SETFILTER("No.", Rec."No.");
                        REPORT.RUN(55028, TRUE, FALSE, LoanAdvanceHeader);
                    end;
                }



                action(Canceling)
                {
                    CaptionML = ENU = 'Cancel Advance', FRA = 'Annuler l''avance';
                    Image = Cancel;
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        IF Rec.Status = Rec.Status::"In progress" THEN
                            MgmtLoansAdvances.AnnEnregDocument(Rec);
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
                    CurrPage.Line.PAGE.ImprPRecette;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Empl.Get(Rec."Employee No.") THEN;

        Rec.CALCFIELDS("Repaid amount", "Repaid %");
        IF ((Rec."Repaid amount" <> 0) AND (Rec."Repaid %" <> 0)) THEN BEGIN
            "%Amont" := ROUND((Rec."Repaid amount" / Rec."Total to repay") * 10000, 1);
            RepaidPercent := ROUND((Rec."Repaid %" / 100) * 10000, 1);
        END
        ELSE BEGIN
            "%Amont" := 0;
            RepaidPercent := 0;
        END;
    end;

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
        FctButtonEnable := TRUE;
        IF Empl.Get(Rec."Employee No.") THEN;
    end;

    trigger OnOpenPage()
    begin
        //OnActivateForm; //Hamdi Migration
    end;

    var
        "%Amont": Integer;
        RepaidPercent: Integer;
        Empl: Record Employee;
        MgmtLoansAdvances: Codeunit 55025;
        FctButtonEnable: Boolean;

}

