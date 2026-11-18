report 55015 "WDC Val. Leave Balance"
{
    CaptionML = ENU = 'Valorisation Leave Balance', FRA = 'Valorisation Solde de congé';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/ValorisationSoldedecongé.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE(Status = FILTER(Active));
            RequestFilterFields = "No.";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee__FullName; FullName2)
            {
            }
            column(TypeSalary; TypeSalary)
            {
            }
            column(SalaireBrut_Employee; "Basis salary")
            {
            }
            column(SoldeConge; SoldeCong)
            {
            }
            column(NbreHJ; NbreHJ)
            {
            }
            column(Valeur; Valeur)
            {
            }

            trigger OnAfterGetRecord()
            begin
                FullName2 := Employee."First Name" + ' ' + Employee."Last Name";

                IF RecGContrat.GET("Emplymt. Contract Code") THEN BEGIN
                    RecGContrat.CalcFields("Employee type");
                    IF RecGRegimeWork.GET(RecGContrat."Work Regime") THEN BEGIN
                        CASE RecGContrat."Employee type" OF
                            RecGContrat."Employee type"::"Hour based":
                                NbreHJ := RecGRegimeWork."Work Hours per month";
                            RecGContrat."Employee type"::"Month based":
                                NbreHJ := RecGRegimeWork."Worked Day Per Month";
                        END;
                    END;

                END;

                Valeur := 0;
                Employee.CALCFIELDS("Days off =", "Gross Salary");
                SoldeCong := Employee."Days off =";
                CASE "Employee type" OF
                    "Employee type"::"Hour based":
                        BEGIN
                            TypeSalary := 'Horaire';
                            Valeur := ROUND(((("Gross Salary" + "Basis salary") * NbreHJ) / 26) * "Days off =", 0.001);
                        END;
                    "Employee type"::"Month based":
                        BEGIN
                            TypeSalary := 'Mensuel';
                            Valeur := ROUND((("Basis salary") / NbreHJ) * SoldeCong, 0.001);
                        END;

                END;
            end;
        }
    }


    var
        TypeSalary: Code[20];
        RecGContrat: Record "Employment Contract";
        RecGRegimeWork: Record "WDC work Regimes";
        NbreHJ: Decimal;
        Valeur: Decimal;
        FullName2: Text;
        SoldeCong: Decimal;
}

