page 55083 "WDC Advance List"
{
    CaptionML = ENU = 'Advances list', FRA = 'Liste des avances';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = 55012;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Type = FILTER(Advance));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                captionML = ENU = 'General', FRA = 'Général';
                field(Type; Rec.Type)
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
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
                    ApplicationArea = all;
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
                    Visible = true;
                }
                field(Amount; Rec.Amount)
                {
                    Style = Strong;
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

    trigger OnOpenPage()
    begin
        // Rec.SETFILTER("Effective date", '>=%1', 010124D);
    end;

    var
        RecGLoanAdvHeader: Record "WDC Loan & Advance";
        FieldStyle: Text[50];
        RecGEmploy: Record Employee;

    procedure SetStyle()
    begin
        IF Rec.Type.AsInteger() = 0 THEN
            FieldStyle := 'Standard'
        ELSE
            FieldStyle := 'AttentionAccent';
        IF Rec.Status.AsInteger() = 1 THEN FieldStyle := 'Unfavorable';

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

