page 55082 "WDC Inactive Employee List"
{
    CaptionML = ENU = 'Inactive Employee List', FRA = 'Liste employés inactifs';
    CardPageID = "Employee Card";
    Editable = false;
    PageType = List;
    ShowFilter = true;
    SourceTable = 5200;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Inactive));

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
                field("Country/Region Code"; Rec."Country/Region Code")
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
                field(RIB; Rec."Bank Account Number")
                {
                    ApplicationArea = all;
                }
                field(College; Rec.College)
                {
                    CaptionML = ENU = 'Category', FRA = 'Catégorie';
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
                    CaptionML = ENU = 'Gross Salary', FRA = 'Salaire brut';
                    ApplicationArea = all;
                }
                field("Employee type"; Rec."Employee type")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
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
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                label(Indisponible)
                {
                    Style = Ambiguous;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
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
                    CaptionML = ENU = 'Co&mments', FRA = 'Commentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(Employee),
                                  "No." = FIELD("No.");
                    ApplicationArea = all;
                }
                group(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions', FRA = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        CaptionML = ENU = 'Dimensions-Single', FRA = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(5200),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ApplicationArea = all;
                    }
                    action("Dimensions-&Multiple")
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'Dimensions-&Multiple', FRA = 'Dimensions-&Multiple';
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
                    ApplicationArea = all;
                    CaptionML = ENU = '&Picture', FRA = '&Image';
                    Image = Picture;
                    RunObject = Page 5202;
                    RunPageLink = "No." = FIELD("No.");
                }
                action("&Alternative Addresses")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = '&Alternative Addresses', FRA = '&Adresses alternatives';
                    Image = Addresses;
                    RunObject = Page 5204;
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("&Relatives")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = '&Relatives', FRA = '&Proches';
                    Image = Relatives;
                    RunObject = Page 5209;
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Mi&sc. Article Information")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Mi&sc. Article Information', FRA = 'Informations diverses sur l''article';
                    Image = Filed;
                    RunObject = Page 5219;
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Co&nfidential Information")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Co&nfidential Information', FRA = 'Informations confidentielles';
                    Image = Lock;
                    RunObject = Page 5221;
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Q&ualifications")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Q&ualifications', FRA = 'Qualifications';
                    Image = Certificate;
                    RunObject = Page 5206;
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("A&bsences")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'A&bsences', FRA = 'Absences';
                    Image = Absence;
                    RunObject = Page 5211;
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Absences by Ca&tegories")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Absences by Ca&tegories', FRA = 'Absences par catégories';
                    Image = AbsenceCategory;
                    RunObject = Page 5226;
                    RunPageLink = "No." = FIELD("No."),
                                  "Employee No. Filter" = FIELD("No.");
                }
                action("Misc. Articles &Overview")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Misc. Articles &Overview', FRA = 'Aperçu articles divers';
                    Image = FiledOverview;
                    RunObject = Page 5228;
                }
                action("Con&fidential Info. Overview")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Con&fidential Info. Overview', FRA = 'Aperçu informations confidentielles';
                    Image = ConfidentialOverview;
                    RunObject = Page 5229;
                }

                action("Change Status==> Unavailable")
                {
                    ApplicationArea = all;
                    Image = AdjustVATExemption;
                    CaptionML = ENU = 'Change Status==> Unavailable', FRA = 'Changer Statut==> Indisponible';
                    trigger OnAction()
                    var
                        RecLEmploy: Record Employee;
                        conf: TextConst ENU = 'Are you sure you want to unvalidate the selected lines?',
                                        FRA = 'Êtes-vous sûr de vouloir invalider les lignes sélectionnées ?';
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
                action("Change Status==> Available")
                {
                    ApplicationArea = all;
                    Image = AdjustVATExemption;
                    CaptionML = ENU = 'Change Status==> Available', FRA = 'Changer Statut==> Disponible';
                    trigger OnAction()
                    var
                        RecLEmploy: Record Employee;
                        conf: TextConst ENU = 'Are you sure you want to unvalidate the selected lines?', FRA = 'Êtes-vous sûr de vouloir invalider les lignes sélectionnées ?';
                        Wind: Dialog;
                    begin
                        CurrPage.SETSELECTIONFILTER(RecLEmploy);
                        Wind.OPEN('Changement status salariés : \' +
                                  ' Salariée  #1########################### \');

                        IF RecLEmploy.FINDSET THEN
                            IF CONFIRM(conf) THEN
                                REPEAT
                                    Wind.UPDATE(1, RecLEmploy."No." + ' ' + RecLEmploy.FullName);
                                    RecLEmploy.Status := RecLEmploy.Status::Active;
                                    RecLEmploy.MODIFY;
                                UNTIL RecLEmploy.NEXT = 0;
                        Wind.CLOSE;
                    end;
                }
                action("Recorded Salaries")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Recorded Salaries', FRA = 'Salaires enregistrés';
                    Image = WageLines;
                    RunObject = Page 55045;
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Launch simulation for all employees")
                {
                    ApplicationArea = all;
                    Image = NewSum;
                    CaptionML = ENU = 'Launch simulation for all employees',
                                FRA = 'Lancer simulation pour tous les salariés';
                    trigger OnAction()
                    var
                        SalaryLine: Record "WDC Salary Lines";
                        Employee: Record Employee;
                        dialogWindow: TextConst ENU = 'Salary simulation', FRA = 'Simulation de salaire';
                        Wind: Dialog;
                        i: Integer;
                        RecLEmploy: Record Employee;
                    begin
                        Wind.OPEN(dialogWindow
                                + '\#########################1#'
                                + '\@@@@@@@@@@@@@@@@@@@@@@@@@2@');
                        CurrPage.SETSELECTIONFILTER(RecLEmploy);
                        Rec.SETFILTER(Status, '%1', Rec.Status::Active);
                        IF RecLEmploy.FINDSET THEN BEGIN
                            REPEAT
                                i += 1;
                                Wind.UPDATE(1, RecLEmploy."No." + ' : ' + RecLEmploy.FullName());
                                Wind.UPDATE(2, ROUND((i / RecLEmploy.COUNT) * 10000, 1));
                                SalaryLine.SETRANGE("No.", 'SIMULATION');
                                SalaryLine.SETRANGE("Employee No.", RecLEmploy."No.");
                                IF SalaryLine.FIND('-') THEN
                                    MngtSalary.DeleteLineSimu(SalaryLine);
                                MngtSalary.CreatePayrollSimulation(RecLEmploy);
                                COMMIT;
                            UNTIL RecLEmploy.NEXT = 0;
                        END;
                    end;
                }
                action("Calculate Exceptional Bonus Amount")
                {
                    ApplicationArea = all;
                    Image = SelectItemSubstitution;
                    CaptionML = ENU = 'Calculate Exceptional Bonus Amount', FRA = 'Calculer montant prime except.';
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
                action("Qualification update")
                {
                    CaptionML = ENU = 'Qualification update', FRA = 'Mise à jour qualification';
                    Image = UpdateDescription;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        managementSalary2.MajQualif;
                    end;
                }
            }
            group("Indemnities update")
            {
                CaptionML = ENU = 'Indemnities update', FRA = 'Mise à jour indemnités';
                Image = Dimensions;
                action(Save)
                {
                    CaptionML = ENU = 'Save', FRA = 'Sauvegarde';
                    Image = Dimensions;
                    trigger OnAction()
                    begin
                        CLEAR(SauvDI);
                        SauvDI.DELETEALL;
                        CLEAR(DefaultIndem);
                        IF DefaultIndem.FINDFIRST THEN
                            REPEAT
                                SauvDI.TRANSFERFIELDS(DefaultIndem);
                                SauvDI.INSERT;
                            UNTIL DefaultIndem.NEXT = 0;
                        MESSAGE(Text001);
                    end;
                }
                action("2-suppression des indemnités courantes")
                {
                    CaptionML = ENU = 'Delete Current indemnities', FRA = 'Suppression indemnités courantes';
                    Image = Delete;

                    trigger OnAction()
                    var
                        Employee: Record Employee;
                        DefaultDimMultiple: Page 542;
                    begin
                        CLEAR(DefaultIndem);
                        DefaultIndem.DELETEALL;
                    end;
                }
                action("3-Transfert vers la table des indemnités")
                {
                    CaptionML = ENU = 'Restore', FRA = 'Restauration';
                    Image = Restore;

                    trigger OnAction()
                    begin
                        CLEAR(SauvDI);
                        IF SauvDI.FINDFIRST THEN
                            REPEAT
                                DefaultIndem.TRANSFERFIELDS(SauvDI);
                                DefaultIndem.INSERT;
                            UNTIL SauvDI.NEXT = 0;
                        MESSAGE(Text001);
                    end;
                }
            }
            group("Sauvegarde salaire de base")
            {
                Caption = 'Sauvegarde salaire de base';
                Image = Dimensions;
                action("1-Sauvegarde salaire de base")
                {
                    CaptionML = ENU = 'Save Base Salary', FRA = 'Sauvegarde salaire de base';
                    Image = Dimensions;

                    trigger OnAction()
                    var

                    begin
                        CLEAR(Gemp);
                        IF Gemp.FINDFIRST THEN
                            REPEAT
                                Gemp."Saved Basis salary" := Gemp."Basis salary";
                                Gemp.MODIFY;
                            UNTIL Gemp.NEXT = 0;
                        CLEAR(Gemp);
                        IF Gemp.FINDFIRST THEN
                            REPEAT
                                Gemp."Basis salary" := 0;
                                Gemp.MODIFY;
                            UNTIL Gemp.NEXT = 0;

                        MESSAGE(Text001);
                    end;
                }
                action("2-Restauration salaire de base")
                {
                    CaptionML = ENU = 'Restore Base Salary', FRA = 'Restauration salaire de base';
                    Image = Restore;

                    trigger OnAction()
                    var
                        Employee: Record Employee;
                        DefaultDimMultiple: Page 542;
                    begin
                        CLEAR(Gemp);
                        IF Gemp.FINDFIRST THEN
                            REPEAT
                                Gemp."Basis salary" := Gemp."Saved Basis salary";
                                Gemp.MODIFY;
                            UNTIL Gemp.NEXT = 0;
                        MESSAGE(Text001);
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


    var
        SalaireBrut: Decimal;
        MngtSalary: Codeunit "WDC Salary Management";
        FieldStyle: Text[50];
        managementSalary2: Codeunit "WDC Salary Management 2";
        DefaultIndem: Record "WDC Default Indemnities";
        SauvDI: Record "WDC SauvDI";
        Gemp: Record Employee;
        Text001: TextConst ENU = 'Operation complete',
                           FRA = 'Opération terminée';

    procedure Fct_CalcNetSalary(Employee: Record Employee)
    var
        RecLSalaryLine: Record "WDC Salary Lines";
        I: Integer;
        msg: TextConst ENU = 'Net calculation for %1 completed successfully', FRA = 'Calcul du Net pour %1, Salarié(s) terminé avec succès';
    begin
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
        IF Rec.Status <> Rec.Status::Active THEN
            FieldStyle := 'Ambiguous';

    end;
}

