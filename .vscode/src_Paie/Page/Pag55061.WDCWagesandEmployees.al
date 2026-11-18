page 55061 "WDC Wages and Employees"
{
    PageType = CardPart;
    ApplicationArea = all;
    CaptionML = ENU = 'Wages and employees', FRA = 'Salaires et salariés';

    layout
    {
        area(content)
        {
            cuegroup("Wages and employees")
            {
                showCaption = false;
                CaptionML = ENU = 'Wages and employees', FRA = 'Salaires et salariés';
                actions
                {
                    action("Employee List")
                    {
                        CaptionML = ENU = 'Employee List', FRA = 'Liste employés';
                        ApplicationArea = all;
                        RunObject = Page 5201;
                        image = TilePeople;
                    }
                    action("Employee Contracts")
                    {
                        CaptionML = ENU = 'Employee Contracts', FRA = 'Contrats employés';

                        ApplicationArea = all;
                        RunObject = Page 5217;
                        image = TileReport;
                    }
                    // action("Posted Indemnities")
                    // {
                    //     CaptionML = ENU = 'Posted Indemnities', FRA = 'Indemnités enreg.';
                    //     RunObject = Page "WDC Recorded Indemnities";
                    //     image = TileInfo;
                    //     ApplicationArea = all;
                    // }

                    // action("Social Contributions")
                    // {
                    //     CaptionML = ENU = 'Posted Social Contributions', FRA = 'Cotisation sociales enreg.';
                    //     RunObject = Page 55006;
                    //     image = TileVideo;
                    //     ApplicationArea = all;
                    // }
                    action("Sanctions List")
                    {
                        CaptionML = ENU = 'Sanctions List', FRA = 'Liste sanctions';
                        RunObject = Page 55077;
                        image = TileHelp;
                        ApplicationArea = all;
                    }

                    action("Employees at End of Contract")
                    {
                        CaptionML = ENU = 'Employees at End of Contract', FRA = 'Employés en fin de contrat';
                        RunObject = Page 55064;
                        image = TileVideo;
                        ApplicationArea = all;
                    }
                    action("Inactive Employee List")
                    {
                        CaptionML = ENU = 'Inactive Employee List', FRA = 'Liste employés inactifs';
                        RunObject = Page 55082;
                        ApplicationArea = all;
                        image = TileInfo;
                    }
                }
            }

            // cuegroup(Processing)
            // {
            //     captionML = ENU = 'Processing', FRA = 'Traitements';
            //     actions
            //     {
            //         action("CNSS Declaration Export")
            //         {
            //             captionML = ENU = 'CNSS Declaration Export', FRA = 'Export Déclaration CNSS';
            //             RunObject = XMLport 55031;
            //             ApplicationArea = all;
            //         }
            //         action("CNSS Declaration")
            //         {
            //             CaptionML = ENU = 'CNSS Declaration', FRA = 'Déclaration CNSS';
            //             RunObject = Report 55022;
            //             ApplicationArea = all;
            //         }
            //         // action("Export CNSS") //Hamdi Migration : N'est pas fonctionnel au KBE
            //         // {
            //         //     Caption = 'Export CNSS';
            //         //     RunObject = XMLport 55000;
            //         // }
            //         // action("Export CAVIS")
            //         // {
            //         //     Caption = 'Export CAVIS';
            //         //     RunObject = XMLport 55006;
            //         // }
            //         action("Employer Declaration")
            //         {
            //             CaptionML = ENU = 'Employer Declaration', FRA = 'Déclaration employeur';
            //             RunObject = Report 55010;
            //             ApplicationArea = all;
            //         }
            //         action("Employee Tax Declaration")
            //         {
            //             CaptionML = ENU = 'Employee Tax Declaration', FRA = 'Déclaration impôts salariés';
            //             RunObject = Report 55009;
            //             ApplicationArea = all;
            //         }
            //         action("CAVIS Declaration")
            //         {
            //             CaptionML = ENU = 'CAVIS Declaration', FRA = 'Déclaration CAVIS';
            //             RunObject = Report 55021;
            //             ApplicationArea = all;
            //         }
            //         action("Employee Note")
            //         {
            //             CaptionML = ENU = 'Employee Note', FRA = 'Notes salariées';
            //             RunObject = Page 55067;
            //             ApplicationArea = all;
            //         }
            //         action("Calculate Salaries")
            //         {
            //             CaptionML = ENU = 'Calculate Salaries', FRA = 'Calcul salaires';
            //             RunObject = Page 55058;
            //             ApplicationArea = all;
            //         }
            //         action("Validate Payroll in Accounting")
            //         {
            //             CaptionML = ENU = 'Validate Payroll in Accounting', FRA = 'Valider paie en comptabilité';
            //             RunObject = Report 55046;
            //             ApplicationArea = all;
            //         }
            //         // action("Intégrer paie à KBE-TN") //Hamdi Migration
            //         // {
            //         //     Caption = '2-Intégrer à KBE-TN';

            //         //     trigger OnAction()
            //         //     begin
            //         //         ProcessPayroll.DELBeforeInsert;
            //         //         ProcessPayroll.InsertSQL;
            //         //     end;
            //         // }
            //     }
            // }
            // cuegroup(Etats)
            // {
            //     actions
            //     {
            // action("Report Employee List")
            // {
            //     CaptionML = ENU = 'Employee List', FRA = 'Liste employés';
            //     ApplicationArea = all;
            //     RunObject = Report 55016;
            //     Image = TileReport;
            // }
            // action("Salary Adj. by Grid")
            // {
            //     CaptionML = ENU = 'Salary Adj. by Grid', FRA = 'Rappel salaire selon grille';
            //     RunObject = report 55095;
            //     ApplicationArea = all;
            //     Image = TileReport;
            // }
            // action("Contract CDD")
            // {
            //     CaptionML = ENU = 'Contract CDD', FRA = 'Contrat CDD';
            //     ApplicationArea = all;
            //     RunObject = Report 55017;
            //     Image = TileReport;
            // }
            // action("CDI Employment Contract")
            // {
            //     CaptionML = ENU = 'CDI Employment Contract', FRA = 'Contrat travail CDI';
            //     ApplicationArea = all;
            //     RunObject = Report 55018;
            //     Image = TileReport;
            // }

            // action("Leave Entitlement by Employee")
            // {
            //     CaptionML = ENU = 'Leave Entitlement by Employee', FRA = 'Droit de congés par salarié';

            //     ApplicationArea = all;
            //     RunObject = Report 55019;
            //     Image = TileReport;
            // }
            // action("Employee - Absences by Causes")
            // {
            //     CaptionML = ENU = 'Employee - Absences by Causes', FRA = 'Absences par Cause';
            //     Image = TileReport;
            //     ApplicationArea = all;
            //     RunObject = Report 5205;
            // }
            // action("Salary Control Report")
            // {
            //     CaptionML = ENU = 'Salary Control Report', FRA = 'Etat contrôle salaire ';
            //     RunObject = Report 55020;
            //     Image = TileReport;
            //     ApplicationArea = all;
            // }
            // action("Leave Balance Valuation")
            // {
            //     CaptionML = ENU = 'Leave Balance Valuation', FRA = 'Valorisation solde congé';
            //     RunObject = Report 55015;
            //     Image = TileReport;
            //     ApplicationArea = all;
            // }

        }
    }
}
// }
//  }





//var

//ProcessPayroll: Codeunit 55029;
//}

