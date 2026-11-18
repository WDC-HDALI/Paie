report 55043 "WDC Sanctions List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/Listedessanctions.rdlc';
    captionML = ENU = 'Sanctions List', FRA = 'Liste sanctions';
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

            trigger OnAfterGetRecord()
            begin
                "Company Information".CALCFIELDS(Picture);
            end;
        }
        dataitem("Employee Absence"; "Employee Absence")
        {
            DataItemTableView = WHERE("Is Santion" = CONST(true));
            column(EmployeeNo_EmployeeAbsence; "Employee Absence"."Employee No.")
            {
            }
            column(Nom_EmployeeAbsence; NomPrenom)
            {
            }
            column(FromDate_EmployeeAbsence; "Employee Absence"."From Date")
            {
            }
            column(ToDate_EmployeeAbsence; "Employee Absence"."To Date")
            {
            }
            column(Quantity_EmployeeAbsence; "Employee Absence".Quantity)
            {
            }
            column(MotifDabsence_EmployeeAbsence; "Employee Absence"."Absence Reason")
            {
            }
            column(CauseofAbsenceCode_EmployeeAbsence; "Employee Absence"."Cause of Absence Code")
            {
            }
            column(Description_EmployeeAbsence; "Employee Absence".Description)
            {
            }
            column(Postingmonth_EmployeeAbsence; "Employee Absence"."Posting month")
            {
            }
            column(Postingyear_EmployeeAbsence; "Employee Absence"."Posting year")
            {
            }
            column(Ttre; Titre)
            {
            }

            trigger OnAfterGetRecord()
            var
                Employee: Record Employee;
            begin
                Employee.GET("Employee Absence"."Employee No.");
                NomPrenom := Employee."Last Name" + ' ' + Employee."First Name";
            end;
        }
    }


    var
        Titre: Label 'Liste des sanctions';
        NomPrenom: Text;
}

