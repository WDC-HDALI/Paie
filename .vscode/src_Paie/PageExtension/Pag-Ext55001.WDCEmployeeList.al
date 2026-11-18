pageextension 55001 "WDC Employee List" extends "Employee List"
{
    layout
    {
        modify("No.")
        {
            StyleExpr = fieldStyle;
        }
        modify(FullName)
        {
            Visible = true;
            StyleExpr = fieldStyle;
        }
        modify("Job Title")
        {
            StyleExpr = fieldStyle;
        }
        modify("Last Name")
        {
            Visible = false;
        }
        modify("First Name")
        {
            Visible = false;
        }

        addafter(FullName)
        {

            field(Status; Rec.Status)
            {
                ApplicationArea = all;
                StyleExpr = fieldStyle;
            }
            field("Employee type"; Rec."Employee type")
            {
                ApplicationArea = all;
                StyleExpr = fieldStyle;
            }

        }
        addafter("First Name")
        {
            field("Default Bank Account Code"; Rec."Default Bank Account Code")
            {
                ApplicationArea = all;
                StyleExpr = fieldStyle;
            }
            field("Qualification Code"; Rec."Qualification Code")
            {
                ApplicationArea = all;
                StyleExpr = fieldStyle;
            }
        }
        addafter("Job Title")
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = all;
                StyleExpr = fieldStyle;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
                StyleExpr = fieldStyle;
            }
        }
        addafter("Post Code")
        {
            field(City; Rec.City)
            {
                ApplicationArea = all;
                StyleExpr = fieldStyle;
            }
        }
        addafter("Mobile Phone No.")
        {
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
                ApplicationArea = all;
            }
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = all;
            }
            field("Employee Posting Group"; Rec."Empl. Posting Group")
            {
                Style = StandardAccent;
                StyleExpr = TRUE;
                applicationArea = all;
            }
        }
        addafter("Statistics Group Code")
        {
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
                Caption = 'Catégorie';
                Style = Attention;
                StyleExpr = TRUE;
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
            field("Gross Salary"; Rec."Basis salary" + Rec."Gross Salary")
            {
                CaptionML = ENU = 'Gross Salary', FRA = 'Salaire brut';
                ApplicationArea = all;
            }

            field("Hire Date"; Rec."Hire Date")
            {
                Style = Attention;
                StyleExpr = TRUE;
            }
            field("Employment Date"; Rec."Employment Date")
            {
                // Style = Strong;
                // StyleExpr = TRUE;
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
        }
        addafter(Comment)
        {
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
            field("Workplace Accident"; Rec."Workplace Accident")
            {
                ApplicationArea = all;
            }
            field(VOIT; Rec.VOIT)
            {
                ApplicationArea = all;
            }
            field("Insurance Group"; Rec."Insurance Group")
            {
                ApplicationArea = all;
            }
        }
        // group(control)
        // {
        //     Editable = true;
        //     label(Horaire)
        //     {
        //         Style = AttentionAccent;
        //         StyleExpr = TRUE;
        //     }
        //     label(Mensuel)
        //     {
        //         Style = Favorable;
        //         StyleExpr = TRUE;
        //     }
        //     label(Indisponible)
        //     {
        //         Style = Ambiguous;
        //         StyleExpr = TRUE;
        //     }
        // }
        //}

    }

    actions
    {
        addafter("A&bsences")
        {
            action("Change Status to Unavailable")
            {
                captionML = ENU = 'Change Status to Unavailable', FRA = 'Changer Statut à Indisponible';
                Image = AdjustVATExemption;
                ApplicationArea = all;
                trigger OnAction()
                var
                    RecLEmploy: Record Employee;
                    conf: TextConst ENU = 'Do you want to unvalidate the selected lines?',
                                    FRA = 'Voulez-vous dévalider les lignes sélectionnées ?';
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
            action("Change Status to Available")
            {
                Image = AdjustVATExemption;
                ApplicationArea = all;
                trigger OnAction()
                var
                    RecLEmploy: Record Employee;
                    conf: TextConst ENU = 'Do you want to unvalidate the selected lines?',
                                    FRA = 'Voulez-vous dévalider les lignes sélectionnées ?';
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

            action("Posted salaries")
            {
                CaptionML = ENU = 'Posted salaries', FRA = 'Salaires enregistrés';
                Image = WageLines;
                RunObject = Page 55045;
                RunPageLink = "Employee No." = FIELD("No.");
            }
            action("Lancer simulation salariés (tous)")
            {
                Image = NewSum;
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalaryLine: Record "WDC Salary Lines";
                    Employee: Record Employee;
                    dialogWindow: TextConst ENU = 'Salary simulation ',
                                            FRA = 'Simulation de salaire';
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
                            IF SalaryLine.FIND('-') THEN
                                MngtSalary.DeleteLineSimu(SalaryLine);
                            MngtSalary.CreatePayrollSimulation(RecLEmploy);
                            COMMIT;
                        UNTIL RecLEmploy.NEXT = 0;
                    END;
                end;
            }
            action("Calculate Except. Bonus Amount")
            {
                captionML = ENU = 'Calculate Except. Bonus Amount', FRA = 'Calculer Montant Prime Except.';
                Image = SelectItemSubstitution;
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalaryLine: Record "WDC Salary Lines";
                    Employee: Record Employee;
                    d: Dialog;
                    i: Integer;
                    HumResPara: Record "Human Resources Setup";
                begin
                    HumResPara.GET;
                    HumResPara.TESTFIELD("Exceptional Bonus");
                    HumResPara.TESTFIELD("Exceptional Bonus Amount");
                    SalaryLine.SETRANGE("No.", 'SIMULATION');
                    IF SalaryLine.FINDSET THEN
                        REPEAT
                            MngtSalary2.PaieInverseFeuilleCalcul13e(SalaryLine, SalaryLine."Basis salary", SalaryLine."Net salary", 1);
                        UNTIL SalaryLine.NEXT = 0;
                end;
            }
            action("Update Qualification")
            {
                captionML = ENU = 'Update Qualification', FRA = 'Mise à jour qualification';
                Image = Job;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    MngtSalary2.MajQualif;
                end;
            }

            group("Update Indemnities")
            {
                CaptionML = ENU = 'Update Indemnities', FRA = 'Mise à jour indemnités';
                Image = Dimensions;
                action("Transfer to Backup Table")
                {
                    CaptionML = ENU = 'Transfer to Backup Table', FRA = 'Sauvegarde';
                    Image = Dimensions;
                    ApplicationArea = all;
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
                action("Delete Current Indemnities")
                {
                    CaptionML = ENU = 'Delete Current Indemnities', FRA = 'Suppression';
                    Image = Delete;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        Employee: Record Employee;
                        DefaultDimMultiple: Page 542;
                    begin
                        CLEAR(DefaultIndem);
                        DefaultIndem.DELETEALL;
                    end;
                }
                action("Restore Indemnities")
                {
                    CaptionML = ENU = 'Restore Indemnities', FRA = 'Restauration';
                    Image = Restore;
                    ApplicationArea = all;
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
            group("Save Base Salary")
            {
                CaptionML = ENU = 'Save Base Salary', FRA = 'Sauvegarde salaire de base';
                Image = Dimensions;
                action("1-Sauvegarde salaire de base")
                {
                    CaptionML = ENU = 'Save Base Salary', FRA = 'Sauvegarde salaire de base';
                    Image = Dimensions;
                    ApplicationArea = all;
                    trigger OnAction()
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
                action("Restore Base Salary")
                {
                    CaptionML = ENU = 'Restore Base Salary', FRA = 'Restauration salaire de base';
                    Image = Restore;
                    ApplicationArea = all;
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
        MngtSalary2: Codeunit "WDC Salary Management 2";
        FieldStyle: Text[50];
        DefaultIndem: Record "WDC Default Indemnities";
        SauvDI: Record "WDC SauvDI";
        Gemp: Record Employee;
        Text001: TextConst ENU = 'Operation complete',
                           FRA = 'Opération terminée';

    procedure SetStyle()
    begin
        CASE Rec."Employee type".AsInteger() OF
            0:
                FieldStyle := 'Strong';
            1:
                FieldStyle := 'Favorable';
        END;
        IF Rec.Status <> rec.Status::Active THEN FieldStyle := 'Ambiguous';

    end;
}

