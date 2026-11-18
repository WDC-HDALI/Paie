page 55060 "WDC Payroll Setup"
{
    PageType = CardPart;
    CaptionML = ENU = 'Payroll Setup', FRA = 'Paramétres Paie';
    ApplicationArea = All;
    sourceTable = "Company Information";
    layout
    {
        area(content)
        {
            cuegroup(Setup)
            {
                ShowCaption = false;
                actions
                {
                    action("Paramétrage Ress. Humaines")
                    {
                        CaptionML = ENU = 'HR Setup', FRA = 'Paramétrre ress. humaines';
                        RunObject = Page 5233;
                        ApplicationArea = All;
                    }
                    action("Paramétre Société")
                    {
                        CaptionML = ENU = 'Company Setup', FRA = 'Paramétre société';
                        RunObject = Page 1;
                        ApplicationArea = All;
                    }
                    action(Calendrier)
                    {
                        CaptionML = ENU = 'Calendar', FRA = 'Calendrier';
                        RunObject = Page 7600;
                        ApplicationArea = All;
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
                    action("Misc. Items")
                    {
                        CaptionML = ENU = 'Misc. Items', FRA = 'Misc. articles';
                        RunObject = Page 5218;
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
                    action("No. Series")
                    {
                        CaptionML = ENU = 'No. Series', FRA = 'N° souches';
                        RunObject = Page 456;
                        ApplicationArea = all;
                    }
                }
            }
        }
    }


}

