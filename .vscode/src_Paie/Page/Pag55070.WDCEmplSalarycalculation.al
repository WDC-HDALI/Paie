page 55070 "WDC Empl.Salary calculation"
{
    CaptionML = ENU = 'Employee : Salary calculation', FRA = 'Employé : Calcul du salaire';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = 55023;

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Employee Work Regime"; Rec."Employee Work Regime")
                {
                    ApplicationArea = all;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = all;
                }
                field("Worked hours"; Rec."Worked hours")
                {
                    ApplicationArea = all;
                }
                field("Basis hours"; Rec."Basis hours")
                {
                    ApplicationArea = all;
                }
            }
            group(Calcul)
            {
                CaptionML = ENU = 'Calcul', FRA = 'Calcul';
                field(NameG; Rec."Employee No." + ' - ' + Rec.Name)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Basis salary"; Rec."Basis salary")
                {
                    ApplicationArea = all;
                }
                field("Taxable indemnities"; Rec."Taxable indemnities")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Gross Salary"; Rec."Gross Salary")
                {
                    ApplicationArea = all;
                }
                field("Non Taxable Soc. Contrib."; Rec."Non Taxable Soc. Contrib.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Taxable salary"; Rec."Taxable salary")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Taxe (Month)"; Rec."Taxe (Month)")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Taxable Soc. Contrib."; Rec."Taxable Soc. Contrib.")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Non Taxable indemnities"; Rec."Non Taxable indemnities")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Net salary"; Rec."Net salary")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Fonct)
            {
                CaptionML = ENU = 'Functions', FRA = 'Fonctions';
                // action("Fiche de paie") //Migration Hamdi
                // {
                //     Caption = 'Fiche de paie';
                //     Image = SuggestPayment;

                //     trigger OnAction()
                //     begin
                //         Line.SETRANGE("No.", Rec."No.");
                //         Line.SETRANGE("Employee No.", Rec."Employee No.");

                //         REPORT.RUN(REPORT::Report81311, TRUE, TRUE, Line);
                //     end;
                // }
                action("Calculate Net Salary")
                {
                    CaptionML = ENU = 'Calculate Net Salary', FRA = 'Calculer salaire net';
                    Image = CalculateSimulation;
                    ShortCutKey = 'Ctrl+F7';
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        MngmtSalary.CalculateSalaryLine(Rec, FALSE, 0, 0, FALSE);
                        CurrPage.UPDATE(FALSE)
                    end;
                }
                action("Regularization of Net Salary")
                {
                    CaptionML = ENU = 'Regularization of Net Salary', FRA = 'Régularisation salaire net';
                    Image = CalculateSimulation;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        MngmtSalary.PaieInverseFeuilleCalcul(Rec, Rec."Basis salary", Rec."Net salary", 0, TRUE);
                    end;
                }
                action("Calcul Inverse Commission")
                {
                    CaptionML = ENU = 'Calculate Inverse Commission', FRA = 'Calcul Inverse Commission';
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        MngmtSalary2.PaieInverseFeuilleCalculCommission(Rec, Rec."Basis salary", Rec."Net salary", 0, TRUE);
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        FonctEnable := TRUE;
    end;

    trigger OnOpenPage()
    var
        EmpCont: Record "Employment Contract";
        RegWork: Record "WDC work Regimes";
    begin
        IF Rec."Employee type" = Rec."Employee type"::"Hour based" THEN
            FonctEnable := TRUE
        ELSE
            FonctEnable := TRUE;

        Empl.GET(rec."Employee No.");
        EmpCont.GET(Empl."Emplymt. Contract Code");
        RegWork.GET(EmpCont."Work Regime");

        IF Rec."Employee type" = Rec."Employee type"::"Hour based" THEN BEGIN
            Rec."Basis salary" := Empl."Basis salary" * RegWork."Work Hours per month";
            Rec."Employee type" := Rec."Employee type"::"Month based";
            Rec."Worked hours" := RegWork."Work Hours per month";
            MngmtSalary.CalculateSalaryLine(Rec, FALSE, 0, 0, FALSE);
            CurrPage.UPDATE(FALSE);
            Rec.MODIFY;
        END
    end;

    var
        MngmtSalary: Codeunit "WDC Salary Management";
        MngmtSalary2: Codeunit "WDC Salary Management 2";
        Empl: Record Employee;
        FonctEnable: Boolean;
}

