report 55001 "WDC Calculate Payment"
{
    CaptionML = ENU = 'Calculate Payment', FRA = 'Calcul paie';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Salary Header"; "WDC Salary Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            dataitem("Salary Lines"; "WDC Salary Lines")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("No.", "Employee No.")
                                    ORDER(Ascending);
                //RequestFilterFields = "Employee No.", "Employee type", Class;

                trigger OnAfterGetRecord()
                begin
                    Window.UPDATE(2, "Salary Lines"."Employee No." + ' : ' + "Salary Lines".Name + ' ( ' + "Salary Lines"."Employee Posting Group" + ' )');
                    CLEAR(ManagementSalary);
                    IF "Salary Header".Month <> "Salary Header".Month::Other THEN BEGIN
                        IF "Salary Header".Month.AsInteger() < 12 THEN
                            ManagementSalary.CalculateSalaryLine("Salary Lines", solder, 1, Nbrej, FALSE)
                        ELSE BEGIN

                            CASE "Salary Header".Month.AsInteger() OF
                                12:
                                    ManagementSalary.Calc13EmeLine("Salary Lines", solder, 1, Nbrej);
                                13:
                                    ManagementSalary.CalculateLineHoliday("Salary Lines", solder, 1, Nbrej, FALSE);
                                14:
                                    ManagementSalary2.CalculerLignePRIMEWDC("Salary Lines", solder, 1, Nbrej);
                                16:
                                    ManagementSalary2.CalculerLigneBONUSWDC("Salary Lines", solder, 1, Nbrej);
                                17:
                                    ManagementSalary2.CalculerLigneGratification("Salary Lines", solder, 1, Nbrej);
                            END;
                        END;
                    END ELSE BEGIN
                        ManagementSalary.CalculateSalaryLineSTC("Salary Lines", solder, 1, Nbrej, FALSE)
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, "Salary Header"."No." + ' : ' + "Salary Header".Description);
                i := 1;
                SalaryLines.SETRANGE("No.", "Salary Header"."No.");
                IF (("Salary Header"."Paid days" = 0) OR ("Salary Header"."Worked days" = 0)) THEN
                    ERROR(Text001);
                IF NOT SalaryLines.FINDFIRST THEN
                    ERROR(errNoLines);

                "Salary Header"."Regulation Taxe" := SetupGRH."Regulation Taxe";
                "Salary Header"."Monthes Number" := SetupGRH."Monthes Number";
                "Salary Header".MODIFY;
            end;

            trigger OnPreDataItem()
            begin

                Window.OPEN(dialogWindow
                        + '\#######################################1#'
                        + '\#######################################2#'
                        + '\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3@');
            end;
        }
    }


    trigger OnInitReport()
    begin
        SetupGRH.GET();
    end;

    trigger OnPostReport()
    begin
        "Salary Header"."Up to date" := TRUE;
        "Salary Header".MODIFY;
        Window.CLOSE;
    end;

    var
        SetupGRH: Record "Human Resources Setup";
        SalaryLines: Record "WDC Salary Header";
        ManagementSalary: Codeunit "WDC Salary Management";
        ManagementSalary2: Codeunit "WDC Salary Management 2";
        Window: Dialog;
        I: Integer;
        solder: Boolean;
        Nbrej: Decimal;
        dialogWindow: TextConst ENU = 'Calculating Salary lines',
                                FRA = 'Calcul des lignes de salaire';
        errNoLines: TextConst ENU = 'No Salary lines were found.',
                              FRA = 'Aucune ligne de salaire trouvée.';
        Text001: TextConst ENU = 'Error: Number of Days / Number of Working Days cannot be zero.',
                           FRA = 'Erreur : Nombre de Jour / Nombre de jours ouvrables ne peuvent pas être nuls.';
}

