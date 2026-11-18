page 55059 "WDC Human Resource RoleCenter"
{
    CaptionML = ENU = 'Human Resource RoleCenter', FRA = 'Tableau de Bord - Ressource Humaine';
    PageType = RoleCenter;
    ApplicationArea = all;

    layout
    {
        area(Rolecenter)
        {
            part("WDC Employee Activities"; "WDC Employee Activities")
            {
                ApplicationArea = all;
            }
            Group("Quick & Links")
            {

                CaptionML = ENU = 'Quick & Links', FRA = 'Raccourcis et liens';
                part("WDC Salary Treatment"; "WDC Salary Treatment")
                {
                    ApplicationArea = all;
                }
                part("WDC Wages and Employees"; "WDC Wages and Employees")
                {
                    ApplicationArea = all;
                }

            }
            part(PowerBIEmbeddedReportPart; "Power BI Embedded Report Part")
            {
                AccessByPermission = TableData "Power BI Context Settings" = I;
                ApplicationArea = Basic, Suite;
            }
            part(Control31; "Report Inbox Part")
            {
                ApplicationArea = Jobs;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Jobs;
            }
        }
    }
    actions
    {
        area(Sections)
        {
            Group("Reports")
            {
                CaptionML = ENU = 'Reports', FRA = 'Rapports';

                action("Employee Lists")
                {
                    CaptionML = ENU = 'Employee List', FRA = 'Liste employés';
                    Image = Agreement;
                    RunObject = Report 55016;
                    ApplicationArea = all;
                }
                action("Contract CDD")
                {
                    CaptionML = ENU = 'Contract CDD', FRA = 'Contrat CDD';
                    Image = Agreement;
                    RunObject = Report 55017;
                    ApplicationArea = all;
                }
                action("Work Contract CDI")
                {
                    CaptionML = ENU = 'Work Contract CDI', FRA = 'Contrat travail CDI';
                    Image = Agreement;
                    RunObject = Report 55018;
                    ApplicationArea = all;
                }
                action("Leave Entitlement by Employee")
                {
                    CaptionML = ENU = 'Leave Entitlement by Employee', FRA = 'Droit de congés par employé';
                    Image = Agreement;
                    RunObject = Report 55019;
                    ApplicationArea = all;
                }
                action("Employee - Absences by Causes")
                {
                    CaptionML = ENU = 'Employee - Absences by Causes', FRA = 'Absences employés par cause';
                    Image = Agreement;
                    RunObject = Report 5205;
                    ApplicationArea = all;
                }
                action("Complementary Scheme")
                {
                    CaptionML = ENU = 'Complementary Scheme', FRA = 'Régime complémentaire';
                    Image = "Report";
                    RunObject = Report 55021;
                    ApplicationArea = all;
                }
                action("Salary Adj. by Grid")
                {
                    CaptionML = ENU = 'Salary Adj. by Grid', FRA = 'Rappel salaire selon grille';
                    RunObject = report 55095;
                    ApplicationArea = all;
                    Image = Report2;
                }
                action("Salary Control Report")
                {
                    CaptionML = ENU = 'Salary Control Report', FRA = 'Etat contrôle salaire ';
                    RunObject = Report 55020;
                    Image = Report2;
                    ApplicationArea = all;
                }
                action("Leave Balance Valuation")
                {
                    CaptionML = ENU = 'Leave Balance Valuation', FRA = 'Valorisation solde congé';
                    RunObject = Report 55015;
                    Image = Report2;
                    ApplicationArea = all;
                }
            }
            Group(Declaration)
            {
                CaptionML = ENU = 'Declaration', FRA = 'Déclaration';
                action("CNSS Declaration")
                {
                    CaptionML = ENU = 'CNSS Declaration', FRA = 'Déclaration CNSS';
                    RunObject = Report 55022;
                    ApplicationArea = all;
                }
                action("CNSS Declaration Export")
                {
                    captionML = ENU = 'CNSS Declaration Export', FRA = 'Export déclaration CNSS';
                    RunObject = XMLport 55031;
                    ApplicationArea = all;
                }

                action("Employer Declaration")
                {
                    CaptionML = ENU = 'Employer Declaration', FRA = 'Déclaration employeur';
                    RunObject = Report 55010;
                    ApplicationArea = all;
                }
                action("Employee Tax Declaration")
                {
                    CaptionML = ENU = 'Employee Tax Declaration', FRA = 'Déclaration impôts salariés';
                    RunObject = Report 55009;
                    ApplicationArea = all;
                }
                action("CAVIS Declaration")
                {
                    CaptionML = ENU = 'CAVIS Declaration', FRA = 'Déclaration CAVIS';
                    RunObject = Report 55021;
                    ApplicationArea = all;
                }
            }

            group("Salary Histories")
            {
                CaptionML = ENU = 'Employee histories', FRA = 'Historiques salairiés';
                action("Posted Salary Histories")
                {
                    CaptionML = ENU = 'Posted Salaries', FRA = 'Salaires enregistrés';
                    RunObject = Page 55044;
                    ApplicationArea = All;

                }
                action("Posted Indemnities")
                {
                    CaptionML = ENU = 'Posted Indemnities', FRA = 'Indemnitiés enregistrées';
                    RunObject = Page "WDC Recorded Indemnities";
                    ApplicationArea = All;

                }
                action("Posted Social Controbition")
                {
                    CaptionML = ENU = 'Posted Social Controbition', FRA = 'Cotisations sociales enregistrées';
                    RunObject = Page "WDC Rec. Social Contrib.";
                    ApplicationArea = All;

                }
                action("Recorded Hours Histories")
                {
                    CaptionML = ENU = 'Posted Work Hours', FRA = 'Heures travail enregistrées';
                    RunObject = Page 55050;
                    ApplicationArea = All;

                }
                action("Absence Histories")
                {
                    CaptionML = ENU = 'Posted Absence', FRA = 'Absences enregistrés';
                    RunObject = Page 55020;
                    ApplicationArea = All;

                }
                action("Overtime Hours Histories")
                {
                    CaptionML = ENU = 'Posted Overtime Hours', FRA = 'Heure Sup. enregistrées';
                    RunObject = Page 55030;
                    ApplicationArea = All;

                }
                action("Archives Advances and Loans")
                {
                    CaptionML = ENU = 'Posted Advances and Loans', FRA = 'Avances et prêts enregistrés';
                    RunObject = Page 55081;
                    ApplicationArea = All;

                }
                action("Advances and loans tracking")
                {
                    CaptionML = ENU = 'Advances and loans tracking', FRA = 'Suivi prêts et avances';
                    RunObject = Page 55086;
                    ApplicationArea = All;

                }

            }
            // }
            // area(Sections)
            // {
            Group("Setup")
            {
                CaptionML = ENU = 'Payroll Setup', FRA = 'Paramètres paie';

                action("Paramétrage Ress. Humaines")
                {
                    CaptionML = ENU = 'HR Setup', FRA = 'Paramétrre ress. humaines';
                    RunObject = Page 5233;
                    ApplicationArea = All;
                }
                action("Irregular Indemnity")
                {
                    CaptionML = ENU = 'Irregular Indemnity', FRA = 'Indeminités irrégulières';
                    RunObject = Page 55018;
                    RunPageMode = Edit;
                    ApplicationArea = all;
                }
                action(Indemnities)
                {
                    CaptionML = ENU = 'Indemnities', FRA = 'Indemnités';
                    RunObject = Page 55000;
                    ApplicationArea = All;
                }
                action("Social Contributions")
                {
                    CaptionML = ENU = 'Social Contributions', FRA = 'Cotisation sociales';
                    RunObject = Page 55003;
                    ApplicationArea = all;
                }

                action("Employees Posting Group")
                {
                    CaptionML = ENU = 'Employees Posting Group', FRA = 'Groupe compta. salariés';
                    RunObject = Page 55049;
                    ApplicationArea = All;
                }
                action("Employee Statistical Group")
                {
                    CaptionML = ENU = 'Employee Statistical Group', FRA = 'Groupe statisitique salarié';
                    RunObject = Page 5216;
                    ApplicationArea = All;
                }
                action(Qualification)
                {
                    CaptionML = ENU = 'Qualification', FRA = 'Qualification';
                    RunObject = Page 5205;
                    ApplicationArea = All;
                }
                action("Loan & Advance Setup")
                {
                    CaptionML = ENU = 'Loan & Advance Setup', FRA = 'Paramètres. prêts et avances';
                    RunObject = Page 55009;
                    ApplicationArea = All;
                }

                action("Slices of imposition")
                {
                    CaptionML = ENU = 'Slices of imposition', FRA = 'Tranche d''imposition';
                    RunObject = Page 55008;
                    ApplicationArea = All;
                }
                action("CSS Slices of imposition")
                {
                    CaptionML = ENU = 'CSS Slices of imposition', FRA = 'Tranche d''imposition CSS';
                    RunObject = Page 55080;
                    ApplicationArea = All;
                }
                action("Work Regimes")
                {
                    CaptionML = ENU = 'Work Regimes', FRA = 'Régimes travail';
                    RunObject = Page "WDC Work Regimes List";
                    RunPageMode = View;
                    ApplicationArea = All;
                }
                action("Life Insurance Type")
                {
                    CaptionML = ENU = 'Life Insurance Type', FRA = 'Type d''assurance vie';
                    RunObject = Page 55056;
                    ApplicationArea = All;
                }
                action("Paramétrage Prime Rendement")
                {
                    CaptionML = ENU = 'Performance Bonus Setup', FRA = 'Paramétrage prime rendement';
                    RunObject = Page 55079;
                    ApplicationArea = All;
                }
                action(Relatives)
                {
                    CaptionML = ENU = 'Relatives', FRA = 'Relatives';
                    RunObject = Page 5208;
                    ApplicationArea = all;
                }
                action("Causes of Inactivity")
                {
                    CaptionML = ENU = 'Causes of Inactivity', FRA = 'Causes d''inactivité';
                    RunObject = Page 5214;
                    ApplicationArea = all;
                }
                action("Grounds for Termination")
                {
                    CaptionML = ENU = 'Grounds for Termination', FRA = 'Motifs résiliation';
                    RunObject = Page 5215;
                    ApplicationArea = all;
                }
                action("Causes of Absence")
                {
                    CaptionML = ENU = 'Causes of Absence', FRA = 'Causes absences';
                    RunObject = Page 5210;
                    ApplicationArea = all;
                }
                action(Categories)
                {
                    CaptionML = ENU = 'Categories', FRA = 'Catégories';
                    RunObject = Page 55032;
                    ApplicationArea = all;
                }
                action(Echelle)
                {
                    CaptionML = ENU = 'Scale', FRA = 'Echelle';
                    RunObject = Page 55069;
                    ApplicationArea = all;
                }
                action(Echelon)
                {
                    CaptionML = ENU = 'Echelon', FRA = 'Échelon';
                    RunObject = Page 55031;
                    ApplicationArea = all;
                }
                action("Salary Grid")
                {
                    CaptionML = ENU = 'Salary Grid', FRA = 'Grille salaires';
                    RunObject = Page 55035;
                    ApplicationArea = all;
                }
            }

        }
    }
}

