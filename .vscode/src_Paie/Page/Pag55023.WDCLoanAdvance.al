page 55023 "WDC Loan Advance"
{
    CaptionML = ENU = 'Loans & Advances', FRA = 'Prêts et avances';
    //DataCaptionExpression = FORMAT(Type) + ' ' + "No." + '-->' + Name;
    DataCaptionFields = Type, "No.", Name;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = 55012;

    layout
    {
        area(content)
        {
            group("General")
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
            part(Line; 55024)
            {
                ApplicationArea = all;
                Editable = true;
                SubPageLink = "No." = FIELD("No.");
                SubPageView = SORTING("No.", "Entry No.")
                              ORDER(Ascending);
            }
            group(Remboursement)
            {
                CaptionML = ENU = 'Repayment', FRA = 'Remboursement';
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Total to re pay"; Rec."Total to repay")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Repayment sli ces"; Rec."Repayment slices")
                {
                    ApplicationArea = all;
                }
                field("%Rep aid"; "%Repaid")
                {
                    ApplicationArea = all;
                    ExtendedDatatype = Ratio;
                }
                field("Montant tran che"; Rec."Slice Amount")
                {
                    ApplicationArea = all;
                }
                field("Repaiment li nes"; Rec."Repaiment lines")
                {
                    ApplicationArea = all;
                }
                field("Date d'effe t 2"; Rec."Effective date")
                {
                    ApplicationArea = all;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Date fin P rêt"; Rec."End date Loan")
                {
                    ApplicationArea = all;
                }
                field("Repaid amo unt"; Rec."Repaid amount")
                {
                    ApplicationArea = all;
                }
                field("Repai d %"; Rec."Repaid %")
                {
                    ApplicationArea = all;
                }
                field(Balance; Rec."Total to repay" - Rec."Repaid amount")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Balance', FRA = 'Solde';
                    DecimalPlaces = 3 : 3;
                }
                field("Principal Amo unt"; Rec."Principal Amount")
                {
                    ApplicationArea = all;
                }
                field("Interest Amo unt"; Rec."Interest Amount")
                {
                    ApplicationArea = all;
                }
                field("Not incl ude"; Rec."Not include")
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
                action("Imprimer Pièce de recette ")
                {
                    Image = Bank;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        CurrPage.Line.PAGE.ImprPRecette;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Empl.GET(Rec."Employee No.") THEN;

        Rec.CALCFIELDS(Rec."Repaid amount", Rec."Repaid %");
        IF ((Rec."Repaid amount" <> 0) AND (Rec."Repaid %" <> 0)) THEN BEGIN
            "%Amont" := ROUND((Rec."Repaid amount" / Rec."Total to repay") * 10000, 1);
            "%Repaid" := ROUND((Rec."Repaid %" / 100) * 10000, 1);
        END
        ELSE BEGIN
            "%Amont" := 0;
            "%Repaid" := 0;
        END;

        FctButtonEnable := Rec.Status = rec.Status::Enclosed;
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
        "%Repaid": Integer;
        Empl: Record Employee;
        FctButtonEnable: Boolean;

    local procedure OnActivateForm()
    begin
        IF Empl.GET(Rec."Employee No.") THEN;
        FctButtonEnable := Rec.Status = rec.Status::Enclosed;
    end;
}

