page 55029 "WDC Heures Suppléméntaires"
{
    CaptionML = ENU = 'Overtime Hours', FRA = 'Heures Supplémentaires';
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "WDC Monthly Overtime Hours";
    SourceTableView = SORTING("Employee No.", "Line No.", "Department Code", "Folder Code")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            group(Dates)
            {
                CaptionML = ENU = 'Dates', FRA = 'Dates';
                field("Date Insertion"; Date2)
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Date', FRA = 'Date';
                }
            }
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Employee No."; Rec."Employee No.")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field(Name; Rec."First Name" + ' ' + rec."Last Name")
                {
                    CaptionML = ENU = 'Name', FRA = 'Nom Salarié';
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    StyleExpr = FieldStyle;
                }
                field("Day Type"; Rec."Day Type")
                {
                    ApplicationArea = all;
                    StyleExpr = FieldStyle;
                }
                field("Unit Tariff"; Rec."Unit Tariff")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 3 : 3;
                    StyleExpr = FieldStyle;
                }
                field("Overtime Rate"; Rec."Overtime Rate")
                {

                    ApplicationArea = all;
                    StyleExpr = FieldStyle;
                }
                field("Hours Number"; Rec."Hours Number")
                {
                    ApplicationArea = all;
                    StyleExpr = FieldStyle;
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    ApplicationArea = all;
                    StyleExpr = FieldStyle;
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    ApplicationArea = all;
                }
                field("Line amount"; Rec."Line amount")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 3 : 3;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Payment Month"; Rec."Payment Month")
                {
                    ApplicationArea = all;
                }
                field("Payment Year"; Rec."Payment Year")
                {
                    ApplicationArea = all;
                }
            }
            group(Group)
            {
                field(GName; Rec."First Name" + ' ' + rec."Last Name")
                {
                    CaptionML = ENU = 'Name', FRA = 'Nom Salarié';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Montant ligne 2"; Rec."Line amount")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Heures sup."; Employee.Overtime)
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Overtime Hours', FRA = 'Heures Supplémentaires';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Fonction&s")
            {
                Caption = 'Fonction&s';

                action(Post)
                {
                    CaptionML = ENU = 'Post', FRA = 'Valider';
                    Image = Post;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F9';
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        GRH: Codeunit "WDC Management of Work Hours";
                        HeuresSup: Record "WDC Monthly Overtime Hours";
                        HeuresSupTmp: Record "WDC Monthly Overtime Hours";
                        lText001: TextConst ENU = 'Do you want to post',
                                            FRA = 'Voulez-vous valider?';
                    begin
                        if Not Confirm(lText001) then
                            exit;
                        HeuresSup.RESET;
                        HeuresSup.COPYFILTERS(Rec);
                        GRH.RUN(HeuresSup);
                    end;
                }
                action("Import Overtime Hours")
                {
                    CaptionML = ENU = 'Import Overtime Hours', FRA = 'Importer Heures Supplémentaires';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    RunObject = XMLport 55037;
                    ApplicationArea = all;
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStyle();
        IF Employee.GET(Rec."Employee No.") THEN
            Employee.CALCFIELDS(Employee.Overtime);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.VALIDATE("Posting Date", WorkDate());
        Rec."Hour Type" := Enum::"WDC Hours work Type".FromInteger(Typej);
    end;

    var
        Employee: Record Employee;
        Typej: Option "Heure Sup.",Roulement;
        FieldStyle: Text[50];
        Date2: Date;


    procedure SetStyle()
    begin
        //>>
        CASE Rec."Overtime Rate" OF
            1.25:
                FieldStyle := 'StandardAccent';
            1.5:
                FieldStyle := 'Favorable';
            2:
                FieldStyle := 'Attention';
        END;
        //<<
    end;
}

