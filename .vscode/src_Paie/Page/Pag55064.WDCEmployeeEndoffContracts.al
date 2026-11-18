page 55064 "WDC Employee End off Contracts"
{
    CaptionML = ENU = 'Employee End of Contract List', FRA = 'Liste salariés fin contrat';
    CardPageID = "Employee Card";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    SourceTable = 5200;
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
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ApplicationArea = all;
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = all;
                }
                field("Hire Date"; Rec."Hire Date")
                {
                    Style = Attention;
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
                field("Employee type"; Rec."Employee type")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }

                field("Employee Contract Type"; Rec."Employee Contract Type")
                {
                    ApplicationArea = all;
                }
            }
            group(Group)
            {
                Editable = true;
                label(Horaire)
                {
                    ApplicationArea = all;
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                }
                label(Mensuel)
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                label(Indisponible)
                {
                    ApplicationArea = all;
                    Style = Ambiguous;
                    StyleExpr = TRUE;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                Image = Employee;
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    ApplicationArea = all;
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Employee),
                                  "No." = FIELD("No.");
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        ApplicationArea = all;
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(5200),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        Caption = 'Dimensions-&Multiple';
                        ApplicationArea = all;
                        Image = DimensionSets;

                        trigger OnAction()
                        var
                            Employee: Record Employee;
                            DefaultDimMultiple: Page 542;
                        begin
                            CurrPage.SETSELECTIONFILTER(Employee);
                            DefaultDimMultiple.SetMultiEmployee(Employee);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    ApplicationArea = all;
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No." = FIELD("No.");
                }
                action("&Alternative Addresses")
                {
                    Caption = '&Alternative Addresses';
                    ApplicationArea = all;
                    Image = Addresses;
                    RunObject = Page 5204;
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("&Relatives")
                {
                    Caption = '&Relatives';
                    ApplicationArea = all;
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Mi&sc. Article Information")
                {
                    Caption = 'Mi&sc. Article Information';
                    ApplicationArea = all;
                    Image = Filed;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Co&nfidential Information")
                {
                    Caption = 'Co&nfidential Information';
                    ApplicationArea = all;
                    Image = Lock;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Q&ualifications")
                {
                    Caption = 'Q&ualifications';
                    ApplicationArea = all;
                    Image = Certificate;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("A&bsences")
                {
                    Caption = 'A&bsences';
                    ApplicationArea = all;
                    Image = Absence;
                    RunObject = Page 5211;
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Absences by Ca&tegories")
                {
                    Caption = 'Absences by Ca&tegories';
                    ApplicationArea = all;
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = FIELD("No."),
                                  "Employee No. Filter" = FIELD("No.");
                }
                action("Misc. Articles &Overview")
                {
                    Caption = 'Misc. Articles &Overview';
                    ApplicationArea = all;
                    Image = FiledOverview;
                    RunObject = Page "Misc. Articles Overview";
                }
                action("Con&fidential Info. Overview")
                {
                    Caption = 'Con&fidential Info. Overview';
                    ApplicationArea = all;
                    Image = ConfidentialOverview;
                    RunObject = Page 5229;
                }

                action("Changer Statut==> Indisponible")
                {
                    ApplicationArea = all;
                    Image = AdjustVATExemption;

                    trigger OnAction()
                    var
                        RecLEmploy: Record Employee;
                        conf: TextConst ENU = 'Are you sure you want to unvalidate the selected lines?',
                                       FRA = 'Êtes-vous sûr de vouloir dévalider les lignes sélectionnées?';
                        Wind: Dialog;
                    begin
                        CurrPage.SETSELECTIONFILTER(RecLEmploy);
                        Wind.OPEN('Changement status salariés : \' +
                                  ' Salariée  #1########################### \');

                        IF RecLEmploy.FINDSET THEN
                            IF CONFIRM(conf) THEN
                                REPEAT
                                    Wind.UPDATE(1, RecLEmploy."No." + ' ' + RecLEmploy.FullName);
                                    RecLEmploy.Status := RecLEmploy.Status::Inactive;
                                    RecLEmploy.MODIFY;
                                UNTIL RecLEmploy.NEXT = 0;
                        Wind.CLOSE;
                    end;
                }
                action("Changer Statut==> Disponible")
                {
                    ApplicationArea = all;
                    Image = AdjustVATExemption;

                    trigger OnAction()
                    var
                        RecLEmploy: Record Employee;
                        conf: TextConst ENU = 'Do you want to unvalidate the selected lines?',
                                       FRA = 'Êtes-vous sûr de vouloir dévalider les lignes sélectionnées?';
                        Wind: Dialog;
                    begin
                        CurrPage.SETSELECTIONFILTER(RecLEmploy);
                        Wind.OPEN('Changement status salariés : \' +
                                  ' Salariée  #1########################### \');

                        IF RecLEmploy.FINDSET THEN
                            IF CONFIRM(conf) THEN
                                REPEAT
                                    Wind.UPDATE(1, RecLEmploy."No." + ' ' + RecLEmploy.FullName);
                                    RecLEmploy.Status := RecLEmploy.Status::Inactive;
                                    RecLEmploy.MODIFY;
                                UNTIL RecLEmploy.NEXT = 0;
                        Wind.CLOSE;
                    end;
                }

                action("Salaires enreg.")
                {
                    Caption = 'Salaires enreg.';
                    ApplicationArea = all;
                    Image = WageLines;
                    RunObject = Page 55045;
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Lancer simulation salariés (tous)")
                {
                    ApplicationArea = all;
                    Image = NewSum;

                    trigger OnAction()
                    var
                        SalaryLine: Record "WDC Salary Lines";
                        Employee: Record Employee;
                        dialogWindow: TextConst ENU = 'Salary simulation ',
                                              FRA = 'Simulation de salaire ';
                        d: Dialog;
                        i: Integer;
                        RecLEmploy: Record Employee;
                    begin
                        d.OPEN(dialogWindow
                                + '\#########################1#'
                                + '\@@@@@@@@@@@@@@@@@@@@@@@@@2@');
                        CurrPage.SETSELECTIONFILTER(RecLEmploy);
                        Rec.SETFILTER(Status, '%1', Rec.Status::Active);
                        IF RecLEmploy.FINDSET THEN BEGIN
                            REPEAT
                                i += 1;
                                d.UPDATE(1, Rec."No." + ' : ' + Rec.FullName());
                                d.UPDATE(2, ROUND((i / Rec.COUNT) * 10000, 1));
                                SalaryLine.SETRANGE("No.", 'SIMULATION');
                                SalaryLine.SETRANGE("Employee No.", RecLEmploy."No.");
                                IF SalaryLine.FindFirst() THEN
                                    MngtSalary.DeleteLineSimu(SalaryLine);
                                MngtSalary.CreatePayrollSimulation(RecLEmploy);
                                COMMIT;
                            UNTIL RecLEmploy.NEXT = 0;
                        END;
                    end;
                }
                action("Calculer Montant Prim Except.")
                {
                    ApplicationArea = all;
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    var
                        SalaryLine: Record "WDC Salary Lines";
                        Employee: Record Employee;
                        d: Dialog;
                        i: Integer;
                        Managementofsalary: Codeunit "WDC Salary Management 2";
                        HumResPara: Record "Human Resources Setup";
                    begin
                        HumResPara.GET;
                        HumResPara.TESTFIELD("Exceptional Bonus");
                        HumResPara.TESTFIELD("Exceptional Bonus Amount");
                        SalaryLine.SETRANGE("No.", 'SIMULATION');
                        IF SalaryLine.FINDSET THEN
                            REPEAT
                                Managementofsalary.PaieInverseFeuilleCalcul13e(SalaryLine, SalaryLine."Basis salary", SalaryLine."Net salary", 1);
                            UNTIL SalaryLine.NEXT = 0;
                    end;
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


    trigger OnOpenPage()
    begin
        Rec.SETRANGE(Status, Rec.Status::Active);
        Rec.SETFILTER("Employee Contract Type", '=%1|%2|%3|%4', Rec."Employee Contract Type"::CDD, Rec."Employee Contract Type"::"SIVP I First Year", Rec."Employee Contract Type"::"SIVP I Second Year", Rec."Employee Contract Type"::"SIVP II");
        Rec.SETFILTER("Termination Date", '<>%1', 0D);
        Rec.SETFILTER("Termination Date", '<=%1', CALCDATE('<-15D>', WORKDATE));
    end;

    var
        SalaireBrut: Decimal;
        Userparam: Record 91;
        MngtSalary: Codeunit 55023;
        FieldStyle: Text[50];


    procedure Fct_CalcNetSalary(Employee: Record Employee)
    var
        RecLSalaryLine: Record "WDC Salary Lines";
        I: Integer;
        msg: TextConst ENU = 'Net salary calculation for %1, Employee(s) completed successfully',
                       FRA = 'Calcul du Net pour %1, Salarié(s) terminé avec succés';
    begin
        //>>
        I := 0;
        Employee.RESET;
        Employee.SETFILTER(Status, '%1', Rec.Status::Active);
        IF Employee.FINDSET THEN BEGIN
            REPEAT
                I := I + 1;
                RecLSalaryLine.SETRANGE("No.", 'SIMULATION');
                RecLSalaryLine.SETRANGE("Employee No.", Employee."No.");
                IF RecLSalaryLine.FIND('-') THEN
                    MngtSalary.DeleteLineSimu(RecLSalaryLine);
                MngtSalary.CreatePayrollSimulation(Employee);
                COMMIT;

                RecLSalaryLine.SETRANGE("No.", 'SIMULATION');
                RecLSalaryLine.SETRANGE("Employee No.", Employee."No.");
                IF RecLSalaryLine.FIND('-') THEN BEGIN
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
        IF Rec.Status <> rec.Status::Active THEN
            FieldStyle := 'Ambiguous';

    end;
}

