report 55044 "WDC Holiday Request"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/Demndedecongé.rdlc';
    captionML = ENU = 'Holiday Request', FRA = 'Demande de congé';
    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Picture; "Company Information".Picture)
            {
            }
            column(LastYear; LastYear)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Company Information".CALCFIELDS(Picture);
                LastYear := DATE2DMY(TODAY, 3) - 1;
            end;
        }
        dataitem("Employee Absence"; "Employee Absence")
        {
            RequestFilterFields = "Entry No.";
            column(ToDate_EmployeeAbsence; "Employee Absence"."To Date")
            {
            }
            column(FromDate_EmployeeAbsence; "Employee Absence"."From Date")
            {
            }
            column(EmployeeNo_EmployeeAbsence; "Employee Absence"."Employee No.")
            {
            }
            column(Quantity_EmployeeAbsence; "Employee Absence".Quantity)
            {
            }
            column(Description_EmployeeAbsence; "Employee Absence".Description)
            {
            }
            column(CauseofAbsenceCode_EmployeeAbsence; "Employee Absence"."Cause of Absence Code")
            {
            }
            column(Service; service)
            {
            }
            column(Direction; Direction)
            {
            }
            column(NomPrenom; NomPrenom)
            {
            }
            column(Fonction; Fonction)
            {
            }
            column(Interimaire; Inerimaire)
            {
            }
            column("SoldeCongé"; "Holiday Balance")
            {
            }

            trigger OnAfterGetRecord()
            var
                EmployeAbscenceEnreg: Record "WDC Employee's days off Entry";
                Employee: Record Employee;
            begin
                SoldeCong := 0;
                EmployeAbscenceEnreg.RESET;
                EmployeAbscenceEnreg.SETFILTER(EmployeAbscenceEnreg."Employee No.", "Employee Absence"."Employee No.");
                EmployeAbscenceEnreg.SETFILTER(EmployeAbscenceEnreg."To Date", '<=%1', TODAY);
                EmployeAbscenceEnreg.SETFILTER(EmployeAbscenceEnreg."Line type", '<=2');
                IF EmployeAbscenceEnreg.FINDSET THEN BEGIN
                    REPEAT
                    BEGIN
                        IF EmployeAbscenceEnreg."Line type" <> EmployeAbscenceEnreg."Line type"::"Day off Consumption" THEN
                            SoldeCong += EmployeAbscenceEnreg."Quantity (Days)"
                        ELSE
                            SoldeCong := SoldeCong - EmployeAbscenceEnreg."Quantity (Days)";
                    END;
                    UNTIL (EmployeAbscenceEnreg.NEXT = 0);
                END;
                Employee.GET(EmployeAbscenceEnreg."Employee No.");
                service := Employee.Service;
                Management := Employee.Management;
                NomPrenom := Employee."Last Name" + ' ' + Employee."First Name";
                Fonction := Employee.Title;
                IF Employee.GET("Employee Absence".Interim) THEN
                    Inerimaire := Employee."First Name" + ' ' + Employee."Last Name";

            end;
        }
    }


    var
        SoldeCong: Decimal;
        LastYear: Integer;
        Direction: Text;
        NomPrenom: Text[50];
        Fonction: Text[50];
        Inerimaire: Text[50];
}

