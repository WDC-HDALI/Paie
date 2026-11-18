report 55000 "WDC Propose Salaries"
{
    CaptionML = ENU = 'Propose Salaries', FRA = 'Proposer salaires';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Salary Header"; "WDC Salary Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE("No." = FILTER(<> 'SIMULATION'));
            dataitem(Employee; Employee)
            {
                DataItemTableView = SORTING("No.")
                                    ORDER(Ascending)
                                    WHERE(Status = FILTER(Active),
                                          Blocked = FILTER(FALSE));
                RequestFilterFields = "No.", "Social Category", "Employee type";

                trigger OnAfterGetRecord()
                begin
                    RecPramRessHum.GET();
                    d.UPDATE(2, Employee."No." + ' : ' + Employee.FullName());
                    IF RecPramRessHum."Activate fortnightly regime" THEN BEGIN
                        IF RecEmployementContract.GET(Employee."No.") THEN
                            IF RecEmployementContract."Work Regime" = "Salary Header"."Fortnight Regim" THEN
                                IF "Salary Header".Month.AsInteger() < 12 THEN BEGIN
                                    ManagementSalary.CreateSalaryLine("Salary Header", Employee, 1);

                                    SalaryLine.SETRANGE("No.", "Salary Header"."No.");
                                    SalaryLine.SETRANGE("Employee No.", Employee."No.");
                                    IF SalaryLine.FINDFIRST THEN
                                        IF "Salary Header"."Disable loan calculation" = FALSE THEN
                                            MgmtLoansAdvances.CreateRepaymentLine(SalaryLine)
                                END ELSE BEGIN
                                    IF ("Salary Header".Month.AsInteger() = 13) OR ("Salary Header".Month.AsInteger() = 15) OR ("Salary Header".Month.AsInteger() = 16) THEN BEGIN
                                        ManagementSalary.CreateSalaryLine("Salary Header", Employee, 1);
                                    END
                                    ELSE BEGIN
                                        ManagementSalary.CreateSalaryLine("Salary Header", Employee, 1);
                                        SalaryLine.SETRANGE("No.", "Salary Header"."No.");
                                        SalaryLine.SETRANGE("Employee No.", Employee."No.");
                                        IF SalaryLine.FINDFIRST THEN
                                            IF "Salary Header"."Disable loan calculation" = FALSE THEN
                                                MgmtLoansAdvances.CreateRepaymentLine(SalaryLine);
                                    END;
                                END;
                    END
                    ELSE BEGIN
                        IF "Salary Header".Month.AsInteger() < 12 THEN BEGIN
                            ManagementSalary.CreateSalaryLine("Salary Header", Employee, 1);
                            SalaryLine.SETRANGE("No.", "Salary Header"."No.");
                            SalaryLine.SETRANGE("Employee No.", Employee."No.");
                            IF SalaryLine.FINDFIRST THEN
                                IF "Salary Header"."Disable loan calculation" = FALSE THEN
                                    MgmtLoansAdvances.CreateRepaymentLine(SalaryLine);
                        END ELSE IF ("Salary Header".Month.AsInteger() = 13) OR ("Salary Header".Month.AsInteger() = 16) OR ("Salary Header".Month.AsInteger() = 17) THEN
                                ManagementSalary.CreateSalaryLine("Salary Header", Employee, 1)
                        ELSE BEGIN
                            ManagementSalary2.CreateBonusLines("Salary Header", Employee);
                            SalaryLine.RESET;
                            SalaryLine.SETRANGE("No.", "Salary Header"."No.");
                            SalaryLine.SETRANGE("Employee No.", Employee."No.");
                            IF SalaryLine.FINDFIRST THEN BEGIN
                                IF "Salary Header"."Disable loan calculation" = FALSE THEN
                                    MgmtLoansAdvances.CreateRepaymentLine(SalaryLine);
                            END;
                        END;
                    END;
                    d.UPDATE(3, ROUND((i / Employee.COUNT) * 10000, 1));
                    i := i + 1;

                end;
            }

            trigger OnAfterGetRecord()
            begin
                d.UPDATE(1, "Salary Header"."No." + '' + "Salary Header".Description);
                i := 1;
            end;

            trigger OnPreDataItem()
            begin
                d.OPEN(dialogWindow
                        + '\#########################1#'
                        + '\#########################2#'
                        + '\@@@@@@@@@@@@@@@@@@@@@@@@@3@');
            end;
        }
    }



    trigger OnInitReport()
    begin
        Employee.SETRANGE(Status, 0);
    end;

    trigger OnPostReport()
    begin
        d.CLOSE;
    end;


    var
        ManagementSalary: Codeunit 55023;
        ManagementSalary2: Codeunit "WDC Salary Management 2";
        d: Dialog;
        dialogWindow: TextConst ENU = 'Creating salary calculation lines.',
                                FRA = 'Création des lignes de calcul de salaire.';
        i: Integer;
        SalaryLine: Record "WDC Salary Lines";
        RecPramRessHum: Record "Human Resources Setup";
        RecEmployementContract: Record "Employment Contract";
        MgmtLoansAdvances: Codeunit "WDC Mgmt. Loans & Adv";
}

