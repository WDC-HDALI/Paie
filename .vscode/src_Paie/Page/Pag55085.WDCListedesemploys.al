page 55085 "WDC Employee List"
{

    CaptionML = ENU = 'Employee List', FRA = 'Liste des employés';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = 5200;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Active));

    layout
    {
        area(content)
        {
            repeater("Employé")
            {
                field("No."; Rec."No.")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field(FullName; Rec.FullName)
                {
                    CaptionML = ENU = 'Full Name', FRA = 'Nom salarié';
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("CAVIS End Year"; Rec."CAVIS End Year")
                {
                    ApplicationArea = all;
                }
                field("Hors Grille"; Rec."Hors Grille")
                {
                    ApplicationArea = all;
                }
                field("Family chief"; Rec."Family chief")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("First Name"; Rec."First Name")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Default Bank Account Code"; Rec."Default Bank Account Code")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ApplicationArea = all;
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = all;
                }

                field(Address; Rec.Address)
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = all;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = all;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = all;
                }
                field("Country Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = all;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = all;
                }

                field("Employee Posting Group"; Rec."Empl. Posting Group")
                {
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Statistics Group Code"; Rec."Statistics Group Code")
                {
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = all;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = all;
                }
                field("CIN No."; Rec."CIN No.")
                {
                    ApplicationArea = all;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = all;
                }
                field("Bank Account Number"; Rec."Bank Account Number")
                {
                    ApplicationArea = all;
                }
                field(College; Rec.College)
                {
                    Caption = 'Catégorie';
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(Scale; Rec.Scale)
                {
                    ApplicationArea = all;
                }
                field(Echelon; Rec.Echelon)
                {
                    ApplicationArea = all;
                }
                field("Upgrading date Cat/Echelon"; Rec."Upgrading date Cat/Echelon")
                {
                    ApplicationArea = all;
                }
                field("Loaded childs"; Rec."Loaded childs")
                {
                    ApplicationArea = all;
                }
                field("Saved Basis salary"; Rec."Saved Basis salary")
                {
                    ApplicationArea = all;
                }
                field("Basis salary"; Rec."Basis salary")
                {
                    ApplicationArea = all;
                }
                field(SalaireBrut; SalaireBrut)
                {
                    Caption = 'Salaire brut';
                }
                field("Employee type"; Rec."Employee type")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Hire Date"; Rec."Hire Date")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Working Relationship"; Rec."Working Relationship")
                {
                    ApplicationArea = all;
                }
                field("Social Security No."; Rec."Social Security No.")
                {
                    ApplicationArea = all;
                }
                field("Days off -"; Rec."Days off -")
                {
                    ApplicationArea = all;
                }
                field("Days off +"; Rec."Days off +")
                {
                    ApplicationArea = all;
                }
                field("Days off ="; Rec."Days off =")
                {
                    ApplicationArea = all;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = all;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = all;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = all;
                }
                field(CNSS; Rec.CNSS)
                {
                    ApplicationArea = all;
                }
                field(CSS; Rec.CSS)
                {
                    ApplicationArea = all;
                }
                field(BUS; Rec.BUS)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CALCFIELDS("Gross Salary");
        SalaireBrut := Rec."Gross Salary" + Rec."Basis salary";
        SetStyle();
    end;

    trigger OnInit()
    begin
        /*Userparam.RESET;
        Userparam.GET(USERID);
        IF NOT Userparam."Droit RH" THEN
        ERROR('pas de droit sur RH');*/
        //>> DELTA 01
        //>>WDC

    end;

    var
        SalaireBrut: Decimal;
        MngtSalary: Codeunit 55023;
        FieldStyle: Text[50];



    procedure Fct_CalcNetSalary(Employee: Record Employee)
    var
        RecLSalaryLine: Record "WDC Salary Lines";
        I: Integer;
        msg: TextConst ENU = 'Net Salary calculation for %1, Employee(s) completed successfully',
                       FRA = 'Calcul du Net pour %1, Salarié(s) terminé avec succés';
    begin
        I := 0;
        Employee.RESET;
        Employee.SETFILTER(Status, '%1', Rec.Status::Active);
        IF Employee.FINDSET THEN BEGIN
            REPEAT
                I := I + 1;
                RecLSalaryLine.SETRANGE("No.", 'SIMULATION');
                RecLSalaryLine.SETRANGE("Employee No.", Employee."No.");
                IF RecLSalaryLine.FINDFIRST THEN
                    MngtSalary.DeleteLineSimu(RecLSalaryLine);
                MngtSalary.CreatePayrollSimulation(Employee);
                COMMIT;

                RecLSalaryLine.SETRANGE("No.", 'SIMULATION');
                RecLSalaryLine.SETRANGE("Employee No.", Employee."No.");
                IF RecLSalaryLine.FINDFIRST THEN BEGIN
                    Employee."Net Salary" := RecLSalaryLine."Net salary";
                    Employee.MODIFY;
                END;
            UNTIL Employee.NEXT = 0;
            MESSAGE(msg, I);
        END;
    end;


    procedure SetStyle()
    begin
        CASE Rec."Employee type".AsInteger() OF
            0:
                FieldStyle := 'AttentionAccent';
            1:
                FieldStyle := 'Favorable';
        END;
        IF Rec.Status.AsInteger() <> 0 THEN FieldStyle := 'Ambiguous';

    end;
}

