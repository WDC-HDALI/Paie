page 55084 "WDC Salary Treatment"
{
    PageType = CardPart;
    ApplicationArea = all;
    CaptionML = ENU = 'Salary Treatment', FRA = 'Traitement des salaires';

    layout
    {
        area(content)
        {
            cuegroup(Processing)
            {
                showCaption = False;
                captionML = ENU = 'Processing', FRA = 'Traitements';
                actions
                {
                    action("Work Time-Sheet")
                    {
                        CaptionML = ENU = 'Work Time-Sheet', FRA = 'Saisie jours travaillés';
                        RunObject = Page 55063;
                        ApplicationArea = all;
                        Image = TileNew;
                    }
                    action("Overtime Inputs")
                    {
                        CaptionML = ENU = 'Overtime Inputs', FRA = 'Saisie heures suppl.';
                        RunObject = Page 55029;
                        ApplicationArea = all;
                        Image = TileNew;
                    }
                    action("Absences Inputs")
                    {
                        CaptionML = ENU = 'Absences Inputs', FRA = 'Saisie absences';
                        RunObject = Page 5212;
                        ApplicationArea = all;
                        Image = TileNew;
                    }
                    action("Advances Inputs")
                    {
                        CaptionML = ENU = 'Advances Inputs', FRA = 'Saisie avances';
                        RunObject = Page 55015;
                        ApplicationArea = all;
                        Image = TileNew;
                    }
                    action("Loan Inputs")
                    {
                        CaptionML = ENU = 'Loan Inputs', FRA = 'Saisie prêts';
                        RunObject = Page 55013;
                        ApplicationArea = all;
                        Image = TileNew;
                    }
                    action("Employee Note")
                    {
                        CaptionML = ENU = 'Employee Note', FRA = 'Notes salariées';
                        RunObject = Page 55067;
                        ApplicationArea = all;
                        Image = TileInfo;
                    }
                    action("Indemnities Affectation")
                    {
                        CaptionML = ENU = 'Indemnities Affectation', FRA = 'Affectater indemnités';
                        RunObject = Page 55000;
                        ApplicationArea = all;
                        Image = TileCloud;
                    }
                    action("Calculate Salaries")
                    {
                        CaptionML = ENU = 'Calculate Salaries', FRA = 'Calcul salaires';
                        RunObject = Page 55058;
                        Image = TileCurrency;

                    }
                    action("Validate Payroll in Accounting")
                    {
                        CaptionML = ENU = 'Validate Payroll in Accounting', FRA = 'Valider paie en comptabilité';
                        RunObject = Report 55046;
                        ApplicationArea = all;
                        Image = TileCamera;
                    }

                }
            }

        }

    }
    actions
    {
        area(Processing)
        {
            action("WDC Salary Treatment")
            {
                CaptionML = ENU = 'WDC Salary Treatment', FRA = 'Traitement des salaires WDC';
                RunObject = Page 55084;
                ApplicationArea = all;
                //Image = TileNew;
            }
        }
    }
}

