report 55016 "WDC Employees List"
{
    CaptionML = ENU = 'Employees List', FRA = 'Liste des Employés';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/ListedesEmployés.rdlc';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Name; "Company Information".Name)
            {
            }
            column(AdresseCompany; "Company Information".Address)
            {
            }
            column(Picture; "Company Information".Picture)
            {
            }
        }
        dataitem(Employee; Employee)
        {
            column(Matricule; Employee."No.")
            {
            }
            column(Nom; Name)
            {
            }
            column(Job; Employee.Title)
            {
            }
            column(Adresse; Employee.Address)
            {
            }
            column(DateNaissance; Employee."Birth Date")
            {
            }
            column(CNSS; Employee."Social Security No.")
            {
            }
            column(DateDembauche; Employee."Employment Date")
            {
            }
            column(Status; Employee.Status)
            {
            }
            column(MaritalStatus; Employee."Family Situation A")
            {
            }
            column(CIN; Employee."CIN No.")
            {
            }
            column(ModedePaiment; Employee."Payment Method Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Name := Employee."First Name" + ' ' + Employee."Last Name";
            end;
        }
    }


    var
        Name: Text;
}

