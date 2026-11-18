codeunit 55031 "WDC Payroll Post"
{

    var
        Temp1: Integer;
        EMP: Record Employee;

        RecGhumainressource: Record "Human Resources Setup";
        RecGIndemnity: Record "WDC Indemnity";
        RecEmpDayOFF: Record "WDC Employee's days off Entry";
        DefaultSoc: Record "WDC Default Soc. Contribution";
        RecEmp: Record Employee;

    procedure PostPayroll(var SalaryHeader: Record "WDC Salary Header")
    var
        SalaryLines: Record "WDC Salary Lines";
        Indemnities: Record "WDC Indemnities";
        SocialContribution: Record "WDC Social Contributions";
        RecSalaryHeader: Record "WDC Posted Salary Header";
        RecSalaryLine: Record "WDC Posted Salary Lines";
        RecIndemnitie: Record "WDC Rec. Indemnities";
        RecSocialContribution: Record "WDC Rec. Social Contributions";
        EmployeeDaysOffEntry: Record "WDC Employee's days off Entry";
        RecSuppHour: Record "WDC Overtime hours recorded m";
        LoanAdvanceLine: Record "WDC Loan & Advance Lines";
        LoanAdvanceHeader: Record "WDC Loan & Advance Header";
        MgmtLoansAdvances: Codeunit "WDC Mgmt. Loans & Adv";
        temp: Integer;
        ManagementAbsences: Codeunit "WDC Absences Management";
        LoanAdvanceEntry: Record "WDC Loan & Advance entry";
        nbr: Decimal;
        Wind: Dialog;
        h: Integer;
        cpt: Integer;
        Defind: Record "WDC Default Indemnities";
        LoanAdvanceHeaderTmp: Record "WDC Loan & Advance Header";
        lText001: TextConst ENU = 'Do you want to delete irregular indemnities?',
                            FRA = 'Voulez Vous Mettre supprimer Les Indemnités Non Regulières';
    begin
        RecSalaryHeader.RESET;
        Wind.OPEN('Enregistrement de Paie  :  #1############### \' +
                    'Salarié  #2################################# \' +
                    'Avancement :                                 \' +
                    ' @3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ');
        //--> Création de l'en-tête
        //>>Mise à zéro Brut Prime
        CLEAR(RecEmp);
        IF RecEmp.FINDFIRST THEN BEGIN
            REPEAT
                RecEmp."Brut prime" := 0;
                RecEmp.MODIFY;
            UNTIL RecEmp.NEXT = 0;
        END;
        //<<Mise à zéro Brut Prime
        Wind.UPDATE(1, SalaryHeader."No.");
        RecSalaryHeader.TRANSFERFIELDS(SalaryHeader);
        RecSalaryHeader."No." := SalaryHeader."No.";
        RecSalaryHeader.Description := SalaryHeader.Description;
        RecSalaryHeader.Month := SalaryHeader.Month;
        RecSalaryHeader.Year := SalaryHeader.Year;
        RecSalaryHeader."Paid days" := SalaryHeader."Paid days";
        RecSalaryHeader."Worked days" := SalaryHeader."Worked days";
        RecSalaryHeader."No. Series" := SalaryHeader."No. Series";
        RecSalaryHeader."Regulation Taxe" := SalaryHeader."Regulation Taxe";
        RecSalaryHeader."Fortnight Regim" := SalaryHeader."Fortnight Regim";
        SalaryHeader.Fortnight := SalaryHeader.Fortnight;
        RecSalaryHeader.INSERT;
        //--> Création des lignes de salaire + Attribution des droits congé + Solder droit congé
        EmployeeDaysOffEntry.RESET;
        EmployeeDaysOffEntry.SETCURRENTKEY("Entry No.");
        IF EmployeeDaysOffEntry.FINDLAST() THEN BEGIN
            temp := EmployeeDaysOffEntry."Transaction No." + 1;
            Temp1 := EmployeeDaysOffEntry."Entry No." + 1;
        END
        ELSE BEGIN
            temp := 1;
            Temp1 := 1;
        END;
        h := 0;
        RecSalaryLine.RESET;
        SalaryLines.SETRANGE("No.", SalaryHeader."No.");
        IF SalaryLines.FINDFIRST THEN
            REPEAT
                h := h + 1;
                RecSalaryLine.RESET;
                Wind.UPDATE(2, SalaryLines."Employee No." + ' ' + SalaryLines.Name);
                cpt := ROUND(h / SalaryLines.COUNT, 0.01) * 10000;
                Wind.UPDATE(3, cpt);
                RecSalaryLine.TRANSFERFIELDS(SalaryLines);
                RecSalaryLine.Quarter := Enum::"WDC Quarter".FromInteger(SalaryLines.Month.AsInteger() DIV 3);
                IF SalaryLines.Month.AsInteger() > 11 THEN
                    RecSalaryLine.Quarter := Enum::"WDC Quarter".FromInteger(DATE2DMY(SalaryHeader."Posting Date", 2) DIV 3);
                RecSalaryLine."Montant Heures" := SalaryLines."Hours Amount";
                RecSalaryLine."Amount retained cash FS" := SalaryLines."Amount retained cash FS";
                RecSalaryLine."User ID" := USERID;
                RecSalaryLine."Last Date Modified" := WORKDATE;
                RecSalaryLine.Imposable := SalaryLines.Taxable;
                RecSalaryLine."Posting Date" := SalaryHeader."Posting Date";
                RecSalaryLine."Salary RIB" := SalaryLines."Salary RIB";
                RecSalaryLine."Annual CSS Tax" := SalaryLines."Annual CSS Tax";
                RecSalaryLine."Monthly CSS Tax" := SalaryLines."Monthly CSS Tax";
                RecSalaryLine."CSS Tax" := SalaryLines."CSS Tax";
                RecSalaryLine."Total CSS Tax Recorded" := SalaryLines."Total CSS Tax Recorded";
                EMP.GET(RecSalaryLine."Employee No.");
                RecSalaryLine.VALIDATE("Employee Posting Group", EMP."Empl. Posting Group");
                EMP."Report Employee en -" := SalaryLines."Ajout  en +";
                EMP.MODIFY;
                //SPECIFIC SAMI **NE PAS INSERER ET SOLDER DROIT DE CONGE
                RecEmpDayOFF.RESET;
                RecEmpDayOFF.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year");
                RecEmpDayOFF.SETFILTER("Employee No.", SalaryLines."Employee No.");
                RecEmpDayOFF.SETFILTER("Line type", '%1|%2', RecEmpDayOFF."Line type"::"Day off Right",
                RecEmpDayOFF."Line type"::"Day off Consumption");
                RecEmpDayOFF.SETRANGE("Payment No.", '');
                IF RecEmpDayOFF.FINDFIRST THEN
                    REPEAT
                        RecEmpDayOFF."Payment No." := SalaryHeader."No.";
                        RecEmpDayOFF."Line amount" := SalaryLines."Net salary cashed";
                        RecEmpDayOFF."To Account" := TRUE;
                        RecEmpDayOFF."User ID" := USERID;
                        RecEmpDayOFF.MODIFY;
                    UNTIL RecEmpDayOFF.NEXT = 0;

                IF (SalaryLines."Days off balacement" <> 0) THEN BEGIN
                    ManagementAbsences.SoderDroitCongé(temp, SalaryLines);
                    temp := temp + 1;
                    Temp1 := Temp1 + 1;
                END;
                IF RecSalaryLine.INSERT THEN
                    SalaryLines.DELETE;
            UNTIL SalaryLines.NEXT = 0;
        EMP.SETRANGE("No.", SalaryLines."Employee No.");
        EMP."Taxable Indemnity" := SalaryLines."Gross Salary";
        EMP.MODIFY;
        LoanAdvanceHeader.RESET;
        LoanAdvanceHeader.SETCURRENTKEY(Status, "Not include", "No.");
        LoanAdvanceHeader.SETRANGE(Status, 0);
        LoanAdvanceHeader.SETRANGE("Not include", TRUE);
        LoanAdvanceHeader.MODIFYALL("Not include", FALSE);
        Wind.CLOSE;
        Wind.OPEN('Enregistrement des Indemnités :                \' +
                    'Salarié  #2################################# \' +
                    'Indemnité  #4############################### \' +
                    'Avancement :                                 \' +
                    ' @3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ');
        h := 0;
        LoanAdvanceHeaderTmp.RESET;
        LoanAdvanceHeaderTmp.SETCURRENTKEY(Status, "Not include", "No.");
        LoanAdvanceHeaderTmp.SETRANGE(Status, 0);
        LoanAdvanceHeaderTmp.SETRANGE("Not include", TRUE);
        LoanAdvanceHeaderTmp.MODIFYALL("Not include", FALSE);
        LoanAdvanceHeaderTmp.RESET;
        LoanAdvanceHeaderTmp.SETCURRENTKEY(Status, "Not include", "No.");
        LoanAdvanceHeaderTmp.SETRANGE(Status, 0);
        LoanAdvanceHeaderTmp.SETRANGE("Double tranche", TRUE);
        LoanAdvanceHeaderTmp.MODIFYALL("Double tranche", FALSE);
        CloseLoan();
        //--> Création des lignes d'indemnité  Status,Not include,No.
        Indemnities.SETRANGE("No.", SalaryHeader."No.");
        IF Indemnities.FINDFIRST THEN
            REPEAT
                RecIndemnitie.INIT;
                Wind.UPDATE(2, Indemnities."Employee No.");
                h := h + 1;
                cpt := ROUND(h / Indemnities.COUNT, 0.01) * 10000;
                Wind.UPDATE(4, Indemnities.Indemnity + ' ' + Indemnities.Description);
                Wind.UPDATE(3, cpt);

                RecIndemnitie."No." := Indemnities."No.";
                RecIndemnitie."Employee No." := Indemnities."Employee No.";
                RecIndemnitie.Indemnity := Indemnities.Indemnity;
                RecIndemnitie."Employee Posting Group" := Indemnities."Employee Posting Group";
                RecIndemnitie.Management := Indemnities.Management;
                RecIndemnitie.service := Indemnities.service;
                RecIndemnitie.section := Indemnities.section;
                RecIndemnitie."Employee Statistic Group" := Indemnities."Employee Statistic Group";
                RecIndemnitie.Description := Indemnities.Description;
                RecIndemnitie.Type := Indemnities.Type;
                RecIndemnitie."Evaluation mode" := Indemnities."Evaluation mode";
                RecIndemnitie."Base Amount" := Indemnities."Base Amount";
                RecIndemnitie."Real Amount" := Indemnities."Real Amount";
                RecIndemnitie.Rate := Indemnities.Rate;
                RecIndemnitie."Minimum value" := Indemnities."Minimum value";
                RecIndemnitie.Rate := Indemnities.Rate;
                RecIndemnitie.Year := SalaryHeader.Year;
                RecIndemnitie.Month := SalaryHeader.Month;
                RecIndemnitie."Global dimension 1" := Indemnities."Global Dimension 1";
                RecIndemnitie."Global dimension 2" := Indemnities."Global Dimension 2";
                RecIndemnitie."Indemnity Type" := Indemnities."Indemnity Type";
                RecIndemnitie."Included Breastfeeding Hours" := Indemnities."Included Breastfeeding Hours";
                RecIndemnitie."Included in UGTT Hours" := Indemnities."Included in UGTT Hours";
                RecIndemnitie."Includes Extra Days" := Indemnities."Includes Extra Days";
                RecIndemnitie."Allait-UGTT-ATECH" := Indemnities."Allait-UGTT-ATECH";
                RecIndemnitie."Amount Rounding Precision" := Indemnities."Amount Rounding Precision";
                RecIndemnitie."Rounding Direction" := Indemnities."Rounding Direction";
                RecIndemnitie."Not Included in Bonus" := Indemnities."Not Included in Bonus";
                RecIndemnitie."Not included in vacation days" := Indemnities."Not included in vacation days";
                RecIndemnitie."Real Amount PR" := Indemnities."Real Amount PR";
                RecIndemnitie."Benefit in Kind" := Indemnities."Benefit in Kind";
                RecIndemnitie."Indemnity Account No." := Indemnities."Indemnity Account No.";
                RecIndemnitie."Indemnity Balance Account No." := Indemnities."Indemnity Balance Account No.";
                RecIndemnitie."Days Number" := Indemnities."Days Number";
                RecIndemnitie."Non-Deductible Work Accident" := Indemnities."Non-Deductible Work Accident";
                IF RecIndemnitie.INSERT THEN
                    Indemnities.DELETE;

            UNTIL Indemnities.NEXT = 0;
        IF CONFIRM(lText001, TRUE, FALSE) THEN BEGIN
            Defind.RESET;
            Defind.SETCURRENTKEY("Indemnity Type", "Indemnity Code", "Emplymt. Contract Code");
            Defind.SETRANGE(Defind."Evaluation mode", 0);
            IF Defind.FINDSET THEN
                Defind.DELETEALL;
            //>>New Suppression cotisation DON SAM
            CLEAR(DefaultSoc);
            DefaultSoc.SETRANGE("Social Contribution Code", 'DSAM');
            IF DefaultSoc.FINDSET THEN
                DefaultSoc.DELETEALL;
            //<<New Suppression cotisation DON SAM
        END;
        //MBY INIT IND PANIER 
        IF RecGhumainressource.GET THEN
            IF RecGIndemnity.GET(RecGhumainressource."Default Panier") THEN BEGIN
                Defind.RESET;
                Defind.SETRANGE("Indemnity Code", RecGhumainressource."Default Panier");
                IF Defind.FINDFIRST THEN
                    REPEAT
                        Defind.Rate := 0;
                        Defind.MODIFY;
                    UNTIL Defind.NEXT = 0
            END;
        //END MBY INIT IND PANIER 
        //--> Création des lignes de cotisations sociales
        Wind.CLOSE;

        Wind.OPEN('Enregistrement des cotisations sociales :      \' +
                    'Salarié  #2################################# \' +
                    'cotisations  #4############################### \' +
                    'Avancement :                                 \' +
                    ' @3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ');
        h := 0;
        SocialContribution.SETRANGE("No.", SalaryHeader."No.");

        IF SocialContribution.FINDFIRST THEN
            REPEAT
                Wind.UPDATE(2, SocialContribution."Employee No.");
                h := h + 1;
                cpt := ROUND(h / SocialContribution.COUNT, 0.01) * 10000;
                Wind.UPDATE(4, SocialContribution."Social Contribution" + ' ' + SocialContribution.Description);
                Wind.UPDATE(3, cpt);
                RecSocialContribution.RESET;
                RecSocialContribution.INIT;
                RecSocialContribution."No." := SocialContribution."No.";
                RecSocialContribution."Employee No." := SocialContribution."Employee No.";
                RecSocialContribution.Indemnity := SocialContribution.Indemnity;
                RecSocialContribution."Basis of calculation" := SocialContribution."Basis of calculation";
                RecSocialContribution."Calculate Year" := SocialContribution."Calculate Year";
                RecSocialContribution."Social Contribution" := SocialContribution."Social Contribution";
                RecSocialContribution."Employee Posting Group" := SocialContribution."Employee Posting Group";
                RecSocialContribution."Employee Statistic Group" := SocialContribution."Employee Statistic Group";
                RecSocialContribution.Management := SocialContribution.Management;
                RecSocialContribution.service := SocialContribution.service;
                RecSocialContribution.section := SocialContribution.section;
                RecSocialContribution."Posting date" := RecSalaryHeader."Posting Date";
                RecSocialContribution.Description := SocialContribution.Description;
                RecSocialContribution."Employer's part" := SocialContribution."Employer's part";
                RecSocialContribution."Employee's part" := SocialContribution."Employee's part";
                RecSocialContribution."Base Amount" := SocialContribution."Base Amount";
                RecSocialContribution."Real Amount : Employee" := SocialContribution."Real Amount : Employee";
                RecSocialContribution."Real Amount : Employer" := SocialContribution."Real Amount : Employer";
                RecSocialContribution."Deductible of taxable basis" := SocialContribution."Deductible of taxable basis";
                RecSocialContribution."Globlal dimension 1" := SocialContribution."Global Dimension 1";
                RecSocialContribution."Global dimension 2" := SocialContribution."Global Dimension 2";
                RecSocialContribution."Maximum value - Employee" := SocialContribution."Maximum value - Employee";
                RecSocialContribution."Maximum value - Employer" := SocialContribution."Maximum value - Employer";
                RecSocialContribution."6 Smig" := SocialContribution."6 * Smig";
                RecSocialContribution.Month := SalaryHeader.Month;
                RecSocialContribution.Year := SalaryHeader.Year;
                RecSocialContribution."Calculate Year" := SalaryHeader."Calculate Year";
                RecSocialContribution."Integrated into accounting" := SocialContribution."Integrated into accounting";
                IF RecSocialContribution.INSERT THEN
                    SocialContribution.DELETE;

            UNTIL SocialContribution.NEXT = 0;

        RecSalaryLine.RESET;
        SalaryLines.SETRANGE("No.", SalaryHeader."No.");
        Indemnities.RESET;
        Indemnities.SETRANGE("No.", SalaryHeader."No.");
        SocialContribution.RESET;
        SocialContribution.SETRANGE("No.", SalaryHeader."No.");
        // Modification des lignes connexes : Absences, Heures de travail, P&A, Frais
        EmployeeDaysOffEntry.SETRANGE("Posting month", SalaryHeader.Month);
        EmployeeDaysOffEntry.SETRANGE("Posting year", SalaryHeader.Year);
        IF EmployeeDaysOffEntry.FINDFIRST THEN
            REPEAT
                EmployeeDaysOffEntry."Payment No." := SalaryHeader."No.";
                EmployeeDaysOffEntry.MODIFY;
            UNTIL EmployeeDaysOffEntry.NEXT = 0;

        RecSuppHour.SETRANGE("Payment Month", SalaryHeader.Month);
        RecSuppHour.SETRANGE("Payment Year", SalaryHeader.Year);
        IF RecSuppHour.FINDFIRST THEN
            REPEAT
                // AGA------------------------------------------------------------------------------------------
                IF (RecSuppHour."Payment No." = SalaryHeader."No.") OR (RecSuppHour."Payment No." = '') THEN BEGIN
                    RecSuppHour."Payment No." := SalaryHeader."No.";
                    RecSuppHour.MODIFY;
                END
            UNTIL RecSuppHour.NEXT = 0;
        LoanAdvanceLine.SETRANGE(Status, 0);
        LoanAdvanceLine.SETRANGE("Payment No.", SalaryHeader."No.");
        IF LoanAdvanceLine.FINDFIRST THEN
            REPEAT
                LoanAdvanceLine.Paid := TRUE;
                LoanAdvanceLine.MODIFY;

                LoanAdvanceEntry.SETRANGE("No.", LoanAdvanceLine."No.");
                LoanAdvanceEntry.ASCENDING(TRUE);
                IF LoanAdvanceEntry.FINDLAST() THEN
                    nbr := LoanAdvanceEntry."Entry No." + 1
                ELSE
                    nbr := 1;
                LoanAdvanceEntry.RESET;
                LoanAdvanceEntry."No." := LoanAdvanceLine."No.";
                LoanAdvanceEntry."Entry No." := nbr;
                LoanAdvanceEntry."Employee No." := LoanAdvanceLine."Employee No.";
                IF LoanAdvanceHeader.GET(LoanAdvanceLine."No.") THEN
                    LoanAdvanceEntry.Name := LoanAdvanceHeader.Name;
                LoanAdvanceEntry."Employee Posting Group" := LoanAdvanceLine."Employee Posting Group";
                LoanAdvanceEntry.Management := LoanAdvanceLine.Management;
                LoanAdvanceEntry.service := LoanAdvanceLine.service;
                LoanAdvanceEntry.section := LoanAdvanceLine.section;
                LoanAdvanceEntry."Global dimension 1" := LoanAdvanceLine."Global dimension 1";
                LoanAdvanceEntry."Global dimension 2" := LoanAdvanceLine."Global dimension 2";
                LoanAdvanceEntry.Month := LoanAdvanceLine.Month;
                LoanAdvanceEntry.Year := LoanAdvanceLine.Year;
                LoanAdvanceEntry."Payroll Date" := LoanAdvanceLine."Payroll Date";
                LoanAdvanceEntry."Payment No." := LoanAdvanceLine."Payment No.";
                LoanAdvanceEntry.Type := LoanAdvanceLine.Type;
                LoanAdvanceEntry."Document type" := LoanAdvanceLine."Document type";
                LoanAdvanceEntry."Entry type" := LoanAdvanceEntry."Entry type"::Repayment;
                LoanAdvanceEntry.Amount := -LoanAdvanceLine."Line Amount";
                LoanAdvanceEntry.Status := LoanAdvanceLine.Status;
                LoanAdvanceEntry.INSERT;

                IF LoanAdvanceHeader.GET(LoanAdvanceLine."No.") THEN
                    MgmtLoansAdvances.CloturerDocument(LoanAdvanceHeader);

            UNTIL LoanAdvanceLine.NEXT = 0;
        Wind.CLOSE;

    end;

    procedure CloseLoan()
    var
        RecLEbtete: Record "WDC Loan & Advance Header";
        RecLLigne: Record "WDC Loan & Advance Lines";
    begin
        RecLEbtete.RESET;
        RecLEbtete.SETFILTER(Status, '<>%1', RecLEbtete.Status::Enclosed);
        IF RecLEbtete.FINDSET THEN BEGIN

            REPEAT
                RecLEbtete.CALCFIELDS("Repaid %");
                IF RecLEbtete."Repaid %" = 100 THEN BEGIN
                    RecLLigne.RESET;
                    RecLLigne.SETRANGE("No.", RecLEbtete."No.");
                    IF RecLLigne.FINDSET THEN BEGIN
                        RecLLigne.MODIFYALL(Status, RecLLigne.Status::Enclosed);
                    END;
                    RecLEbtete.Status := RecLEbtete.Status::Enclosed;
                    RecLEbtete.MODIFY;
                END;
            UNTIL RecLEbtete.NEXT = 0;
        END;
    end;
}
