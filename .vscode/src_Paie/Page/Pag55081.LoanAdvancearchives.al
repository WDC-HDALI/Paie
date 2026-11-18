page 55081 "Loan & Advance archives"
{
    CaptionML = ENU = 'Loan & Advance archives', FRA = 'Archives prêt & avance';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = 55012;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("No."; Rec."No.")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }

                field("Document type"; Rec."Document type")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Type Tranche"; Rec."Type Tranche")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field(Avancement; CalcAvancement)
                {
                    CaptionML = ENU = 'Follow Up', FRA = 'Suivi';
                    ExtendedDatatype = Ratio;
                    applicationArea = all;
                }
                field("Effective date"; Rec."Effective date")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }

                field("End date Loan"; Rec."End date Loan")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
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
                field("Repaid amount"; Rec."Repaid amount")
                {
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
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;

                }
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Form)
            {
                CaptionML = ENU = 'Form', FRA = 'Fiche';
                Image = Card;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
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
            action("Virement avance")
            {
                CaptionML = ENU = 'Transfer Advance', FRA = 'Virement avance';
                Image = BankAccount;
                ApplicationArea = all;
                RunObject = XMLport 55032;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
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
        RecGEmploy: Record Employee;
        Compteur: Integer;
        Userparam: Record 91;


    procedure SetStyle()
    begin
        IF Rec.Type = Rec.Type::Advance THEN
            FieldStyle := 'Standard'
        ELSE
            FieldStyle := 'AttentionAccent';
        IF Rec.Status = Rec.Status::Enclosed THEN
            FieldStyle := 'Unfavorable';

    end;


    procedure CalcAvancement(): Integer
    var
        lPourCent: Decimal;
    begin
        IF Rec."Repaid amount" = 0 THEN
            lPourCent := 1
        ELSE
            lPourCent := ROUND((Rec."Repaid amount" / Rec."Total to repay" * 9999), 1);

        EXIT(lPourCent)
    end;
}

