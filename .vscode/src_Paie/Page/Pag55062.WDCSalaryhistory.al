page 55062 "WDC Salary history"
{
    PageType = CardPart;
    ApplicationArea = all;
    CaptionML = ENU = 'Salary history', FRA = 'Historiques salaires';
    layout
    {
        area(content)
        {
            cuegroup("Historiques des salaires")
            {

                actions
                {
                    action("Posted Salary Histories")
                    {
                        CaptionML = ENU = 'Posted Salary Histories', FRA = 'Historiques salaire enreg.';
                        RunObject = Page 55044;
                        ApplicationArea = All;
                        Image = TileCurrency;
                    }
                    action("Salary History")
                    {
                        CaptionML = ENU = 'Salary history', FRA = 'Historique salaires';
                        RunObject = Page 55046;
                        ApplicationArea = All;
                        Image = TileCurrency;
                    }
                    action("Recorded Hours Histories")
                    {
                        CaptionML = ENU = 'Recorded Hours Histories', FRA = 'Historiques heures enregistrées';
                        RunObject = Page 55050;
                        ApplicationArea = All;
                        Image = TileCurrency;
                    }
                    action("Historique des absences")
                    {
                        CaptionML = ENU = 'Absence Histories', FRA = 'Historique des absences';
                        RunObject = Page 55020;
                        ApplicationArea = All;
                        Image = TileCurrency;
                    }
                    action("Historique Heure Sup")
                    {
                        CaptionML = ENU = 'Overtime Hours Histories', FRA = 'Historique Heure Sup';
                        RunObject = Page 55030;
                        ApplicationArea = All;
                        Image = TileCurrency;
                    }
                    action("Archives Advances and Loans List")
                    {
                        CaptionML = ENU = 'Archives Advances and Loans List', FRA = 'Archives avances et prêts';
                        RunObject = Page 55081;
                        ApplicationArea = All;
                        Image = TileCurrency;
                    }
                    action("Suivi des prêts et avances")
                    {
                        CaptionML = ENU = 'Advances and loans tracking', FRA = 'Suivi des prêts et avances';
                        RunObject = Page 55086;
                        ApplicationArea = All;
                        Image = TileCurrency;
                    }

                }
            }
        }
    }
}

