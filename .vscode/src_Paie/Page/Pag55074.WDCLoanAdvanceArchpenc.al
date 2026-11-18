page 55074 "WDC Loan Advance Arch. p en c."
{
    CaptionML = ENU = 'Archives Loans & Advances p. en c.', FRA = 'Archives Prêts et Avances p. en c.';
    DataCaptionFields = Type, "No.", Name;
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = 55012;
    SourceTableView = SORTING("No.")
                      WHERE(Type = FILTER(<> Advance),
                            Status = FILTER("In progress"));

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
                    ApplicationArea = all;
                }
                field("Type Tranche"; Rec."Type Tranche")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Inclus Paie Autre"; Rec."Inclus Paie Autre")
                {
                    ApplicationArea = all;
                }
                field("Inclus Paie13"; Rec."Inclus Paie13")
                {
                    ApplicationArea = all;
                }
                field("Not include"; Rec."Not include")
                {
                    ApplicationArea = all;
                }
                field("Advance on Holiday"; Rec."Advance on Holiday")
                {
                    Caption = 'Prêt sur congé';
                    ApplicationArea = all;
                }
                field("Double tranche"; Rec."Double tranche")
                {
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
                    Caption = 'Begining date';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("End date Loan"; Rec."End date Loan")
                {
                    ApplicationArea = all;
                }
            }
            part(Line; 55024)
            {
                Editable = true;
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
                    //Editable = false;
                    ApplicationArea = all;
                }
                field("Total to repay"; Rec."Total to repay")
                {
                    // Editable = false;
                    ApplicationArea = all;
                }
                field("Repayment slices"; Rec."Repayment slices")
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
                field(RepaidPercent; RepaidPercent)
                {
                    ExtendedDatatype = Ratio;
                    ApplicationArea = all;
                }
                field("Slice Amount"; Rec."Slice Amount")
                {
                    Editable = true;
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
                field(Solde; Solde)
                {
                    Caption = 'Solde';
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
                field("Interest %"; Rec."Interest %")
                {
                    Editable = false;
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
                Caption = 'Fonction&s';
                Visible = true;
                action(So)
                {
                    Caption = 'Solder document';
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

                action("Tableau amortissement Actuel")
                {
                    Caption = 'Tableau amortissement Actuel';
                    Image = DepreciationBooks;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        LoanAdvanceHeader: Record "WDC Loan & Advance";
                    begin
                        CLEAR(LoanAdvanceHeader);
                        LoanAdvanceHeader.RESET;
                        LoanAdvanceHeader.SETFILTER("No.", Rec."No.");
                        REPORT.RUN(55029, TRUE, FALSE, LoanAdvanceHeader);
                    end;
                }
                action(Annulation)
                {
                    Caption = 'Annulation';
                    Image = Cancel;
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        IF Rec.Status = rec.Status::"In progress" THEN
                            MgmtLoansAdvances.AnnEnregDocument(Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action(imp)
            {
                Caption = 'Contrat de prêt';
                Image = PrintVAT;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    LoanAdvanceHeader: Record "WDC Loan & Advance";
                begin
                    //CurrPage.Line.PAGE.ImprPRecette;
                    LoanAdvanceHeader.RESET;
                    LoanAdvanceHeader.SETFILTER("No.", Rec."No.");
                    REPORT.RUN(55004, TRUE, FALSE, LoanAdvanceHeader);
                end;
            }
            action("Clôturer Prêt")
            {
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Empl.GET(rec."Employee No.") THEN;

        Rec.CALCFIELDS("Repaid amount", "Repaid %");
        IF ((Rec."Repaid amount" <> 0) AND (Rec."Repaid %" <> 0)) THEN BEGIN
            "%Amont" := ROUND((Rec."Repaid amount" / Rec."Total to repay") * 10000, 1);
            RepaidPercent := ROUND((Rec."Repaid %" / 100) * 10000, 1);
        END
        ELSE BEGIN
            "%Amont" := 0;
            RepaidPercent := 0;
        END;

        FctButtonEnable := Rec.Status = Rec.Status::"In progress";
        //>>
        Rec.CALCFIELDS("Repaid %");
        CASE Rec."Repaid %" OF
            100:
                Solde := 0;
            0 .. 99:
                Solde := Rec."Total to repay" - Rec."Repaid amount";
        END;
        //<<
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
        //>>
        SetStyle();
        //<<
    end;

    var
        "%Amont": Integer;
        RepaidPercent: Integer;
        Empl: Record Employee;
        MgmtLoansAdvances: Codeunit "WDC Mgmt. Loans & Adv";
        FctButtonEnable: Boolean;
        FieldStyle: Text[50];
        Solde: Decimal;

    local procedure OnActivateForm()
    begin
        IF Empl.GET(rec."Employee No.") THEN;
        FctButtonEnable := Rec.Status = Rec.Status::"In progress";
    end;


    procedure SetStyle()
    begin
        IF Rec."Type Tranche".AsInteger() = 2 THEN
            FieldStyle := 'Unfavorable'
        ELSE
            FieldStyle := 'Standard';
    end;
}

