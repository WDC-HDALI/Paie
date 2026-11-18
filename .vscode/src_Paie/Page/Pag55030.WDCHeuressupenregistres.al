page 55030 "WDC Recorded Overtime Hours"
{
    CaptionML = ENU = 'Recorded Overtime Hours', FRA = 'Heures sup. enregistrées';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = 55016;
    SourceTableView = SORTING("Transaction No.", "Line No.", "Employee No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                Editable = false;
                field("Payment No."; Rec."Payment No.")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(FullName; Rec."First Name" + ' ' + Rec."Last Name")
                {
                    Caption = 'Nom salarié';
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Hour Type"; Rec."Hour Type")
                {
                    ApplicationArea = all;
                }
                field("Day Type"; Rec."Day Type")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Payment Month"; Rec."Payment Month")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Payment Year"; Rec."Payment Year")
                {
                    ApplicationArea = all;
                }
                field("Overtime Rate"; Rec."Overtime Rate")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Hours Number"; Rec."Hours Number")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Prix HN"; PrixHN)
                {
                    ApplicationArea = all;
                }
                field("Line amount"; Rec."Line amount")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
            }
            group(Group)
            {
                field("N° Salarié 2"; Rec."Employee No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(GFullName; Rec."First Name" + ' ' + Rec."Last Name")
                {
                    Caption = 'Nom salarié';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Mois de paiement 2"; Rec."Payment Month")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Année de paiement 2"; Rec."Payment Year")
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
            group("Fonction&s")
            {
                Caption = 'Fonction&s';
                action("Dévalider")
                {
                    Caption = 'Dévalider';
                    Image = UnApply;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        conf: Textconst ENU = 'Do you want to unvalidate the selected lines?',
                                        FRA = 'Voulez-vous dévalider les lignes sélectionnées ?';
                        HeuresSup: Record 55015;
                        Nligne: Integer;
                    begin
                        HeuresSup.RESET;
                        HeuresSup.SETCURRENTKEY("Line No.");
                        IF HeuresSup.FINDLAST THEN
                            Nligne := HeuresSup."Line No." + 10000
                        ELSE
                            Nligne := 10000;

                        CurrPage.SETSELECTIONFILTER(Saved);
                        //Saved.SETFILTER("Payment No.",'=''''');
                        Wind.OPEN('De validation de Heures Supplémentaire : \' +
                                  ' Salariée  #1########################### \' +
                                  ' N° Ligne              #2############### \' +
                                  ' Date Heure Supplémentaire  #3########## ');
                        IF Saved.FINDFIRST THEN
                            IF CONFIRM(conf) THEN
                                REPEAT
                                    Wind.UPDATE(1, Saved."Employee No." + ' ' + Saved."Last Name");
                                    Wind.UPDATE(2, Nligne);
                                    Wind.UPDATE(3, Saved."Posting Date");
                                    Hcode.DevaliderHeuresSup(Saved, Nligne);
                                    Nligne := Nligne + 10000;
                                UNTIL Saved.NEXT = 0;
                        Wind.CLOSE;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStyle();
        IF RecGEmploy.GET(Rec."Employee No.") THEN BEGIN
            BasicSalary := RecGEmploy."Basis salary";
            IF RecGEmploy."Employee type" = RecGEmploy."Employee type"::"Month based" THEN PrixHN := BasicSalary / 208;
            IF RecGEmploy."Employee type" = RecGEmploy."Employee type"::"Hour based" THEN PrixHN := BasicSalary;
        END;
    end;

    var
        Saved: Record "WDC Overtime hours recorded m";
        Hcode: Codeunit "WDC Management of Work Hours";
        Wind: Dialog;
        PrixHN: Decimal;
        RecGEmploy: Record Employee;
        BasicSalary: Decimal;
        FieldStyle: Text[50];


    procedure SetStyle()
    begin
        CASE Rec."Overtime Rate" OF
            1.25:
                FieldStyle := 'StandardAccent';
            1.5:
                FieldStyle := 'Favorable';
            2:
                FieldStyle := 'Attention';
        END;
    end;
}

