page 55025 "WDC Loan & Advance Hdr"
{
    CaptionML = ENU = 'Loan & Advance List', FRA = 'Liste des prêts et avances';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "WDC Loan & Advance Header";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Effective date"; Rec."Effective date")
                {
                    ApplicationArea = all;
                }
                field("Type Tranche"; Rec."Type Tranche")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field(Employee; Rec."Employee No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field("Double tranche"; Rec."Double tranche")
                {
                    ApplicationArea = all;
                }
                field("Repayment slices"; Rec."Repayment slices")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Nombre Tranches"; Rec."Nombre Tranches")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Repaiment lines"; Rec."Repaiment lines")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = all;
                }
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Employee Statistic Group"; Rec."Employee Statistic Group")
                {
                    ApplicationArea = all;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Document type"; Rec."Document type")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Interest %"; Rec."Interest %")
                {
                    ApplicationArea = all;
                }
                field("Total to repay"; Rec."Total to repay")
                {
                    ApplicationArea = all;
                }
                field("Repaid amount"; Rec."Repaid amount")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(Solde; Rec."Total to repay" - Rec."Repaid amount")
                {
                    CaptionML = ENU = 'Solde', FRA = 'Solde';
                    DecimalPlaces = 3 : 3;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Repaid %"; Rec."Repaid %")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
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
            action(Card)
            {
                CaptionML = ENU = 'Card', FRA = 'Fiche';
                Image = Card;
                Promoted = false;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    RecGLoanAdvHeader.GET(Rec."No.");
                    CASE Rec.Type OF
                        Rec.Type::Advance:
                            BEGIN
                                CASE Rec.Status OF
                                    Rec.Status::"In progress":
                                        PAGE.RUN(55072, RecGLoanAdvHeader);
                                    Rec.Status::Enclosed:
                                        PAGE.RUN(55073, RecGLoanAdvHeader);
                                END;
                            END;
                        Rec.Type::Loan:
                            BEGIN
                                CASE Rec.Status OF
                                    Rec.Status::"In progress":
                                        PAGE.RUN(55074, RecGLoanAdvHeader);
                                    Rec.Status::Enclosed:
                                        PAGE.RUN(55075, RecGLoanAdvHeader);
                                END;

                            END;


                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStyle();
    end;

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;

    var
        RecGLoanAdvHeader: Record "WDC Loan & Advance Header";
        FieldStyle: Text[50];


    procedure SetStyle()
    begin
        IF Rec."Type Tranche".AsInteger() = 2 THEN
            FieldStyle := 'Unfavorable'
        ELSE
            FieldStyle := 'Standard';
    end;
}

