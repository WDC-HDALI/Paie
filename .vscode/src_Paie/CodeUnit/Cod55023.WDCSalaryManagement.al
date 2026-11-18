codeunit 55023 "WDC Salary Management"
{
    // //>>
    // WDC04 29/01/2024 AttribuerDroitCongé blogué les congés sont attribués en début d'année
    // WDC03 22/11/2023 Ass.Shemsi.bus.Tél non pris en compte pour les primes
    // WDC02 04/05/2023 AJOUT Colonee Ass.Shemsi.bus.Tél.Car
    // WDC01 04/05/2023 Ajout colonne Retraite +
    // STA25    Hatem  (21-12-16):Calcul du Cavis Code commenté le SMIG n'est pas correct pour l'historique Salary Line Enrg (à Mêttre en place JANVIER 2017) Le SMIG été fixé à 450
    // //>>
    trigger OnRun()
    begin
    end;

    var
        TaxesMgmt: Codeunit "WDC Taxes Management";
        MgmtSalary2: Codeunit "WDC Salary Management 2";
        AbsenceMgmt: Codeunit "WDC Absences Management";
        SH: Record "WDC Salary Header";
        found: Boolean;
        ParamCpta: Record "General Ledger Setup";
        Ins: Boolean;
        RecGSalayEnr: Record "WDC Posted Salary Lines";
        FraisEnreg: Decimal;
        Carr: Record "WDC Career Record";
        ImposEnreg: Decimal;
        Bnk: Record "WDC Employee Bank Account";
        NbrPaie: Integer;
        DateJ: Date;
        Tchange: Record 330;
        EMP: Record Employee;
        EmployeeAbsence2: Record "WDC Employee's days off Entry";
        SalaryHeaders: Record "WDC Salary Header";
        Regimesofwork: Record 55003;
        TotAbs: Decimal;
        TotHeuresEnreg: Decimal;
        Heuresoccaenregm: Record "WDC Occasional Hours Recorded";
        DiffHours: Decimal;
        AbsenceEnreg1: Record "WDC Employee's days off Entry";
        AbsenceEnreg: Record "WDC Employee's days off Entry";
        GNbJour: Decimal;
        GNbHeure: Decimal;
        GRecNote: Record "WDC Notes";
        TotJoursEnreg: Decimal;
        DecNBHeureEncouragement: Decimal;
        DecMntHoraire: Decimal;
        DecVar: Decimal;
        DEDUCIMPOT: Decimal;
        MntAssVie: Decimal;
        RecAssVie: Record "WDC Employee Deduction Amount";
        "RecGRec. Salary Lines": Record "WDC Posted Salary Lines";
        DecGTotSalaireBrut: Decimal;
        IndConvent: Decimal;
        ParamGrH: Record "Human Resources Setup";
        MontCapitalReinvesti: Decimal;
        BaremeCalculImpot: Decimal;
        BaremeCalculImpotApCNSS: Decimal;
        BaremeCalculImpotApFraisProf: Decimal;
        NbrJourPaye: Decimal;
        SocialContriubtion: Record "WDC Social Contributions";
        Gemployee: Record Employee;
        IndemJS: Record "WDC Default Indemnities";
        JourS: Decimal;
        SalaryLineEnreg: Record "WDC Salary Lines";
        NombreMois: Integer;
        RecSalaryLine: Record "WDC Posted Salary Lines";
        FacteurMois: Integer;
        Tresource: Record 156 temporary;
        MoisPaye: Integer;
        Text001: TextConst ENU = 'Employee salary %1 must not be negative',
                            FRA = 'Salaire de l''employé %1 ne doit pas être négatif';

    procedure CreateSalaryLine(SalaryHeader: Record "WDC Salary Header"; Employee: Record Employee; Sim: Option Simulation,Real) OK: Boolean
    var
        SalaryLine: Record "WDC Salary Lines";
        EmploymentContract: Record "Employment Contract";
        err1: TextConst ENU = 'Regime of work is empty on Employment contract : %1',
                        FRA = 'Code de régime de travail est vide sur le Contrat de travail : %1';
        err2: TextConst ENU = 'Employment contract is empty for the employee : %1',
                        FRA = 'Contrat de travail est vide pour l''employé : %1';
        confMess: TextConst ENU = 'Do you want to Replace the existing line ?',
                            FRA = 'Voulez vous remplacer  la ligne existante ?';
        err3: TextConst ENU = 'Tax bracket code empty on Employment contract : %1',
                        FRA = 'Code tranche d''imposition vide sur Contrat de travail : %1';
        lText001: TextConst ENU = 'Do you want to include the employee loan?',
                            FRA = 'Voulez-vous inclure le prêt du salarié';
        lText002: TextConst ENU = 'for the month',
                            FRA = ' pour le mois de ';
        DefaultSocContribution: Record "WDC Default Soc. Contribution";
        SocialContributions: Record "WDC Social Contributions";
        SocialContribution: Record "WDC Social Contribution";
        DefaultIndemnities: Record "WDC Default Indemnities";
        Indemnities: Record "WDC Indemnities";
        nbr: Decimal;
        ParamRessHum: Record "Human Resources Setup";
        dateD: Date;
        SB: Decimal;
        DateF: Date;
        NBJ: Decimal;
        DefaultIndemnitiesTmp: Record "WDC Default Indemnities";
        MntInd: Decimal;
        regimeofwork: Record "WDC work Regimes";
        RecHeureSupplEnreg: Record "WDC Overtime hours recorded m";
        LoanAD: Record "WDC Loan & Advance Header";
        RecLHeureOccEnreg: Record "WDC Occasional Hours Recorded";
        MonthOFPostingDate: Integer;
    begin
        SalaryLine.RESET;
        Employee.MAJDeductions;
        ParamCpta.GET;
        ParamRessHum.GET();
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN;
        IF regimeofwork.GET(EmploymentContract."Work Regime") THEN;
        SalaryLine.SETRANGE("No.", SalaryHeader."No.");
        SalaryLine.SETRANGE("Employee No.", Employee."No.");
        IF SalaryLine.FINDFIRST THEN BEGIN
            IF CONFIRM(confMess + '\%1\', FALSE, Employee."No." + ' : ' + Employee.FullName())
              THEN
                MgmtSalary2.DeleteLine(SalaryLine)
            ELSE
                EXIT(FALSE);
        END;

        SalaryLine.INIT;
        IndConvent := 0;
        ParamRessHum.GET();
        SalaryLine."No." := SalaryHeader."No.";
        SalaryLine."Employee No." := Employee."No.";
        SalaryLine.Name := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
        SalaryLine."Employee Posting Group" := Employee."Empl. Posting Group";
        SalaryLine."Statistics Group Code" := Employee."Statistics Group Code";
        SalaryLine."Global Dimension 1" := Employee."Global Dimension 1 Code";
        SalaryLine."Global Dimension 2" := Employee."Global Dimension 2 Code";
        IF SalaryLine.Month.AsInteger() < 12 THEN
            SalaryLine."Retirement plus" := Employee."Retirement plus"//WDC
        ELSE
            SalaryLine."Retirement plus" := 0;//WDC
        SalaryLine."Quarterly Note" := Employee."Quarterly Note";//WDC
        SalaryLine."Posting Date" := SalaryHeader."Posting Date";
        SalaryLine.Class := Employee.Class;
        IF Employee."Emplymt. Contract Code" <> '' THEN BEGIN
            EmploymentContract.GET(Employee."Emplymt. Contract Code");
            SalaryLine."Emplymt. Contract Code" := Employee."Emplymt. Contract Code";
            IF EmploymentContract."Work Regime" <> '' THEN
                SalaryLine."Employee Work Regime" := EmploymentContract."Work Regime"
            ELSE
                ERROR(err1, EmploymentContract.Code + ' - ' + EmploymentContract.Description);
            IF EmploymentContract.Taxable THEN
                IF EmploymentContract."Slice of imposition" = '' THEN
                    ERROR(err3, EmploymentContract.Code + ' - ' + EmploymentContract.Description);
        END ELSE
            ERROR(err2, Employee."No." + ' - ' + Employee."First Name" + ' ' + Employee."Last Name");
        CLEAR(Bnk);
        Bnk.RESET;
        IF Employee."Default Bank Account Code" <> '' THEN
            Bnk.GET(Employee."No.", Employee."Default Bank Account Code");
        SalaryLine."Account No." := Bnk."Bank Account No.";

        SalaryLine.Description := SalaryHeader.Description;
        SalaryLine.Month := SalaryHeader.Month;
        SalaryLine.Year := SalaryHeader.Year;
        CASE DATE2DMY(SalaryHeader."Posting Date", 2) OF
            1, 2, 3:
                SalaryLine.Trimestre := SalaryLine.Trimestre::"1St";
            4, 5, 6:
                SalaryLine.Trimestre := SalaryLine.Trimestre::"2nd";
            7, 8, 9:
                SalaryLine.Trimestre := SalaryLine.Trimestre::"3rd";
            10, 11, 12:
                SalaryLine.Trimestre := SalaryLine.Trimestre::"4th";
        END;
        SalaryLine."Bank Account Code" := Employee."Default Bank Account Code";
        SalaryLine."Employee type" := Employee."Employee type";
        SalaryLine."Company Bank Account No." := Employee."Company Bank Account No.";
        SalaryLine."Adjustment of absences" := 0;
        SalaryLine."Assiduity (Paid days)" := 0;
        SalaryLine."Assiduity (Worked days)" := 0;
        SalaryLine.Note := 0;
        SalaryLine.Purcent := 0;
        SalaryLine.Charge := Employee.Charge;
        SalaryLine.Management := Employee.Management;
        SalaryLine.Service := Employee.Service;
        SalaryLine.Section := Employee.Section;
        SalaryLine."Amount Days Off balacement" := 0;
        SalaryLine.Holiday := 0;
        SalaryLine."Assiduity (days off balacement" := 0;
        SalaryLine."Worked Months" := EmploymentContract."Regular payments";
        SalaryLine."Statistics Group Code" := Employee."Statistics Group Code";
        SalaryLine."Employee Contract Type" := Employee."Employee Contract Type";
        SalaryLine."CNSS No." := Employee."Social Security No.";
        SalaryLine."CIN No." := Employee."CIN No.";
        SalaryLine."Payment Method Code" := Employee."Payment Method Code";
        SalaryLine."Salary grid code" := EmploymentContract."Salary grid";
        //SalaryLine.Category := Employee.College; //Hamdi Migration : à vérifier l'affectation
        SalaryLine.Echelon := Employee.Echelon;
        SalaryLine."Salary grid base" := Employee."Basis salary";
        SalaryLine.Fortnight := SalaryHeader.Fortnight;
        SalaryLine.Taxable := EmploymentContract.Taxable;
        //<< DEV CAISSE FOND SOCIAL
        IF Employee."Social Fund" THEN
            SalaryLine."Amount retained cash FS" := ParamRessHum."Amount retained cash FS";

        //>>DEV CAISSE FOND SOCIAL

        IF SalaryHeader.Month.AsInteger() < 12 THEN BEGIN
            LoanAD.RESET;
            LoanAD.SETFILTER("Employee No.", SalaryLine."Employee No.");
            LoanAD.SETRANGE(Type, LoanAD.Type::Loan);
            LoanAD.SETRANGE(Status, LoanAD.Status::"In progress");
            LoanAD.SETRANGE("Not include", TRUE);
            LoanAD.SETRANGE("Avance Sur Prime", FALSE);
            LoanAD.SETRANGE("Meal Advance", FALSE);
            IF LoanAD.FINDFIRST THEN
                IF CONFIRM(lText001
                   + ' ' + FORMAT(SalaryLine."Employee No.") + ' '
                   + SalaryLine.Name + lText002 + FORMAT(SalaryLine.Month), TRUE, FALSE) THEN BEGIN
                    LoanAD."Not include" := FALSE;
                    LoanAD.MODIFY;
                END;
        END;
        RecLHeureOccEnreg.RESET;
        RecLHeureOccEnreg.SETRANGE("Employee No.", SalaryLine."Employee No.");
        RecLHeureOccEnreg.SETRANGE("Payment Year", SalaryLine.Year);
        RecLHeureOccEnreg.SETRANGE("Payment Month", SalaryLine.Month);
        IF RecLHeureOccEnreg.FINDSET THEN BEGIN
            RecLHeureOccEnreg.CALCSUMS(RecLHeureOccEnreg."Pulic Holiday Days");
            SalaryLine."Public Holidays" := RecLHeureOccEnreg."Pulic Holiday Days";
            SalaryLine."Public Holiday Amount" := RecLHeureOccEnreg."Pulic Holiday Amount";
        END;
        RecHeureSupplEnreg.RESET;
        RecHeureSupplEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
        RecHeureSupplEnreg.SETFILTER("Employee No.", '%1', SalaryLine."Employee No.");
        RecHeureSupplEnreg.SETFILTER("Payment Month", '%1', SalaryLine.Month);
        RecHeureSupplEnreg.SETFILTER("Payment Year", '%1', SalaryLine.Year);
        IF ParamRessHum."Activate fortnightly regime" THEN
            IF regimeofwork."Payroll Calculation Type" = regimeofwork."Payroll Calculation Type"::Fortnight THEN
                RecHeureSupplEnreg.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
        RecHeureSupplEnreg.CALCSUMS(RecHeureSupplEnreg."Hours Number");
        SalaryLine."Overtime Hours" := RecHeureSupplEnreg."Hours Number";
        SalaryLine."Report en -" := Employee."Report Employee en -";
        SalaryLine."Salary RIB" := Employee."Bank Account Number";
        Carr.RESET;
        Carr.SETCURRENTKEY("Employee No.", "Decision Date");
        SB := 0;
        NBJ := 0;

        MntInd := 0;
        IF SalaryLine."Posting Date" = 0D THEN
            SalaryLine."Posting Date" := WORKDATE;
        IF Employee."Currency Code" <> '' THEN BEGIN
            DefaultIndemnitiesTmp.RESET;
            DefaultIndemnitiesTmp.SETFILTER("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
            DefaultIndemnitiesTmp.SETRANGE("Evaluation mode", 1, 2);
            DefaultIndemnitiesTmp.SETRANGE("Indemnity Type", DefaultIndemnitiesTmp."Indemnity Type"::Regular);
            IF DefaultIndemnitiesTmp.FINDFIRST THEN
                REPEAT
                    MntInd := MntInd + DefaultIndemnitiesTmp."Default amount";
                UNTIL DefaultIndemnitiesTmp.NEXT = 0;
        END;

        TotAbs := 0;
        TotHeuresEnreg := 0;
        DiffHours := 0;
        Regimesofwork.RESET;
        Regimesofwork.FINDFIRST;
        IF (Employee.Status = Employee.Status::Active) AND
           (Employee."Employee type" = Employee."Employee type"::"Month based") THEN BEGIN
            EmployeeAbsence2.RESET;
            EmployeeAbsence2.SETFILTER("Posting month", '%1', SalaryHeader.Month);
            EmployeeAbsence2.SETFILTER("Posting year", '%1', SalaryHeader.Year);
            EmployeeAbsence2.SETFILTER("Employee No.", Employee."No.");
            EmployeeAbsence2.SETFILTER("Line type", '%1', EmployeeAbsence2."Line type"::"Not Paid");
            IF EmployeeAbsence2.FINDFIRST THEN
                REPEAT
                    TotAbs := TotAbs + EmployeeAbsence2.Quantity;
                UNTIL EmployeeAbsence2.NEXT = 0;
            Heuresoccaenregm.RESET;
            Heuresoccaenregm.SETFILTER("Employee No.", Employee."No.");
            Heuresoccaenregm.SETFILTER("Payment Month", '%1', SalaryHeader.Month);
            Heuresoccaenregm.SETFILTER("Payment Year", '%1', SalaryHeader.Year);
            IF ParamRessHum."Activate fortnightly regime" THEN
                IF regimeofwork."Payroll Calculation Type" = regimeofwork."Payroll Calculation Type"::Fortnight THEN
                    Heuresoccaenregm.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
            Heuresoccaenregm.SETFILTER(Heuresoccaenregm."Payment No.", '%1', '');
            IF Heuresoccaenregm.FINDFIRST THEN
                REPEAT
                    TotHeuresEnreg := TotHeuresEnreg + Heuresoccaenregm."Hours Number";
                UNTIL Heuresoccaenregm.NEXT = 0;
            IF ((TotHeuresEnreg > 0) AND (TotHeuresEnreg < Regimesofwork."Work Hours per month")) THEN BEGIN
                DiffHours := Regimesofwork."Work Hours per month" -
                              TotHeuresEnreg;

                AbsenceEnreg.RESET;
                AbsenceEnreg.SETFILTER("Posting month", '%1', SalaryHeader.Month);
                AbsenceEnreg.SETFILTER("Posting year", '%1', SalaryHeader.Year);
                AbsenceEnreg.SETFILTER("Employee No.", Employee."No.");
                AbsenceEnreg.SETFILTER("Line type", '%1', AbsenceEnreg."Line type"::"Not Paid");
                AbsenceEnreg.SETRANGE(Week, 0);
                IF AbsenceEnreg.FINDFIRST THEN BEGIN
                    AbsenceEnreg.Quantity := DiffHours;
                    AbsenceEnreg."Quantity (Hours)" := -DiffHours;
                    AbsenceEnreg."Quantity (Days)" := -DiffHours /
                                                  (Regimesofwork."Work Hours per month" / Regimesofwork."Worked Day Per Month");
                    AbsenceEnreg.VALIDATE(Quantity, DiffHours);
                    AbsenceEnreg.MODIFY;
                END
                ELSE BEGIN
                    AbsenceEnreg1.RESET;
                    AbsenceEnreg1.FINDLAST();
                    AbsenceEnreg1."Entry No." := AbsenceEnreg1."Entry No." + 1;
                    AbsenceEnreg1."Transaction No." := AbsenceEnreg1."Transaction No." + 1;
                    AbsenceEnreg1."Employee No." := Employee."No.";
                    AbsenceEnreg1."Employee Posting Group" := Employee."Empl. Posting Group";
                    AbsenceEnreg1."Employee Statistic Group" := Employee."Statistics Group Code";
                    AbsenceEnreg1.Management := Employee.Management;
                    AbsenceEnreg1.service := Employee.Service;
                    AbsenceEnreg1.section := Employee.Section;
                    AbsenceEnreg1.VALIDATE("Employee No.", Employee."No.");
                    AbsenceEnreg1."Cause of Absence Code" := 'ABS';
                    AbsenceEnreg1.VALIDATE("Cause of Absence Code", 'ABS');
                    AbsenceEnreg1."Posting month" := SalaryHeader.Month;
                    AbsenceEnreg1."Posting year" := SalaryHeader.Year;
                    AbsenceEnreg1."Line type" := AbsenceEnreg1."Line type"::"Not Paid";
                    AbsenceEnreg1.Unit := AbsenceEnreg1.Unit::"Work hour";
                    AbsenceEnreg1.Week := 0;
                    AbsenceEnreg1.Quantity := DiffHours;
                    AbsenceEnreg1."Quantity (Hours)" := -DiffHours;
                    AbsenceEnreg1."Quantity (Days)" := -DiffHours /
                                                  (Regimesofwork."Work Hours per month" / Regimesofwork."Worked Day Per Month");
                    AbsenceEnreg1.VALIDATE(Quantity, DiffHours);
                    AbsenceEnreg1.INSERT;
                END;
            END;
        END;
        IF SalaryLine."Employee No." <> '' THEN BEGIN
            IF Sim = 1 THEN BEGIN
                Carr.ASCENDING(TRUE);
                Carr.SETCURRENTKEY("Employee No.", "Posting Date");
                Carr.SETFILTER("Employee No.", SalaryLine."Employee No.");
                IF ParamRessHum."Payroll Calculation Date" <> 0 THEN BEGIN
                    IF DATE2DMY(SalaryHeader."Posting Date", 2) = 1 THEN
                        IF ParamRessHum."Payroll Calculation Date" = 30 THEN
                            dateD := DMY2DATE(1, 12, SalaryHeader.Year - 1) ELSE
                            dateD := DMY2DATE(ParamRessHum."Payroll Calculation Date" + 1, 12, SalaryHeader.Year - 1)
                    ELSE
                        IF ParamRessHum."Payroll Calculation Date" <> 30 THEN
                            dateD := DMY2DATE(ParamRessHum."Payroll Calculation Date" + 1, DATE2DMY(SalaryHeader."Posting Date", 2) - 1, SalaryHeader.Year)
                        ELSE
                            dateD := DMY2DATE(1, DATE2DMY(SalaryHeader."Posting Date", 2) - 1, SalaryHeader.Year);
                    MonthOFPostingDate := DATE2DMY(SalaryHeader."Posting Date", 2);
                    IF (SalaryHeader.Month.AsInteger() <> 1) AND (MonthOFPostingDate <> 2) THEN
                        DateF := DMY2DATE(ParamRessHum."Payroll Calculation Date", DATE2DMY(SalaryHeader."Posting Date", 2), SalaryHeader.Year)
                    ELSE
                        DateF := DMY2DATE(28, DATE2DMY(SalaryHeader."Posting Date", 2), SalaryHeader.Year);
                END ELSE BEGIN
                    dateD := DMY2DATE(1, DATE2DMY(SalaryHeader."Posting Date", 2), SalaryHeader.Year);
                    DateF := CALCDATE('<+CM>', dateD);
                END;

                Carr.SETRANGE("Posting Date", dateD, DateF);
                Carr.SETFILTER("Base Salary", '<>0');
                NBJ := (DateF - dateD) + 1;
                IF Carr.COUNT <> 0 THEN BEGIN
                    Carr.SETRANGE("Posting Date", dateD, DateF);
                    IF Carr.FINDFIRST THEN BEGIN  // RAMZI
                        Carr.SETRANGE("Posting Date", 0D, DateF);
                        REPEAT
                            IF Carr."Posting Date" > dateD THEN BEGIN
                                BEGIN
                                    IF Carr."Base Salary" <> 0 THEN
                                        SB := ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code",

                                              Carr."Base Salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code")) -
                                              MntInd, ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        SB := ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code",
                                              Carr."Base Salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code"))
                                              , ParamCpta."Amount Rounding Precision");
                                END;
                            END
                            ELSE BEGIN
                                IF Carr."Currency Code" = '' THEN
                                    SB := Carr."Base Salary"
                                ELSE BEGIN
                                    IF Carr."Gross Salary" <> 0 THEN
                                        SB := ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code",
                                              Carr."Gross Salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code")) -
                                              MntInd, ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        SB := ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code",
                                              Carr."Base Salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code"))
                                              , ParamCpta."Amount Rounding Precision");
                                END;
                            END;
                            DateF := CALCDATE('<-1J>', Carr."Posting Date");
                        UNTIL (Carr.NEXT = 0) OR (DateF <= dateD);
                    END;
                END;
            END;
            IF SB <> 0 THEN
                SalaryLine."Basis salary" := SB
            ELSE BEGIN
                IF Employee."Currency Code" = '' THEN
                    SalaryLine."Basis salary" := Employee."Basis salary"
                ELSE BEGIN
                    IF Employee."Taxable Indemnity" <> 0 THEN
                        SalaryLine."Basis salary" :=
                           ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code",
                              Employee."Taxable Indemnity", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"),
                              Employee."Currency Code")
                  ) -
                              MntInd, ParamCpta."Amount Rounding Precision")
                    ELSE
                        SalaryLine."Basis salary" :=
                             ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code",
                              Employee."Basis salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code")
                  )
                              , ParamCpta."Amount Rounding Precision");
                END;
            END;
        END;
        IF (Sim = 0) THEN
            SalaryLine."Basis salary" := Employee."Basis salary";

        EmploymentContract.RESET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        nbr := 12;
        CASE ParamRessHum."Monthes Number".AsInteger() OF
            0:
                nbr := EmploymentContract."Regular payments";
            1:
                nbr := EmploymentContract."Temporary payments";
            2:
                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
        END;
        IF TRUE THEN BEGIN
            IF (Employee."Family chief") AND NOT (Employee.Abattement) THEN
                SalaryLine."Deduction Family chief" := ROUND(ParamRessHum."Deduction for Familly Chief" / nbr,
                                                      ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLine."Deduction Family chief" := 0;
            CheckChieldOnCharge(SalaryHeader."Posting Date");
            IF nbr <> 0 THEN BEGIN
                Employee.CALCFIELDS("Deduction Loaded child");
                SalaryLine."Deduction Loaded child" := ROUND(Employee."Deduction Loaded child" / nbr,
                                                            ParamCpta."Amount Rounding Precision");
            END;
        END
        ELSE BEGIN
            SalaryLine."Deduction Family chief" := 0;
            SalaryLine."Deduction Loaded child" := 0;
        END;
        SalaryLine."Deduction Prof. expenses" := 0;
        //>>AGA + FONCTIONS DE CALCUL HEURES SUPP PRIME AVANCE PRET
        CalculerFieldsPaie(SalaryLine, Sim);
        IF SalaryLine.INSERT THEN BEGIN
            // Liste des indemnités du salarié en cour
            DefaultIndemnities.SETRANGE("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
            IF (SalaryLine.Month.AsInteger() > 12) THEN
                DefaultIndemnities.SETRANGE("Indemnity Type", 0);
            IF DefaultIndemnities.FINDFIRST THEN
                REPEAT
                    found := FALSE;
                    SH.SETFILTER(Month, DefaultIndemnities."Application Month");
                    IF SH.FINDFIRST THEN
                        REPEAT
                            IF SH."No." = SH."No." THEN
                                found := TRUE;
                        UNTIL SH.NEXT = 0;
                    IF SalaryLine.Month.AsInteger() = 16 THEN
                        found := TRUE;
                    IF found THEN BEGIN
                        Indemnities.INIT;
                        Indemnities."No." := SalaryLine."No.";
                        Indemnities."Employee No." := SalaryLine."Employee No.";
                        Indemnities.Indemnity := DefaultIndemnities."Indemnity Code";
                        Indemnities."Employee Posting Group" := SalaryLine."Employee Posting Group";
                        Indemnities."Global Dimension 1" := SalaryLine."Global Dimension 1";
                        Indemnities."Global Dimension 2" := SalaryLine."Global Dimension 2";
                        Indemnities."Employee Statistic Group" := SalaryLine."Statistics Group Code";
                        Indemnities.Management := SalaryLine.Management;
                        Indemnities.service := SalaryLine.Service;
                        Indemnities.section := SalaryLine.Section;
                        Indemnities.Description := DefaultIndemnities.Description;
                        Indemnities.Type := DefaultIndemnities.Type;
                        Indemnities."Evaluation mode" := DefaultIndemnities."Evaluation mode";
                        Indemnities."Indemnity Type" := DefaultIndemnities."Indemnity Type";
                        Indemnities."Not Included in Bonus" := DefaultIndemnities."Not Included in Bonus";
                        Indemnities."Amount Rounding Precision" := DefaultIndemnities."Amount Rounding Precision";
                        Indemnities."Rounding Direction" := DefaultIndemnities."Rounding Direction";
                        Indemnities."Deduction Base Indemnity/Days" := DefaultIndemnities."Deduction Base Indemnity/Days";
                        Indemnities."Deduction Base Indemnity/Hour" := DefaultIndemnities."Deduction Base Indemnity/Hour";
                        Indemnities."Benefit in Kind" := DefaultIndemnities."Benefit in Kind";
                        Indemnities."Indemnity Account No." := DefaultIndemnities."Indemnity Account No.";
                        Indemnities."Indemnity Balance Account No." := DefaultIndemnities."Indemnity Balance Account No.";
                        Indemnities."Days Number" := DefaultIndemnities."Days Number";
                        Indemnities."Non-Deductible Work Accident" := DefaultIndemnities."Non-Deductible Work Accident";
                        Indemnities."Conventional Indemnity" := DefaultIndemnities."Conventional Indemnity";
                        // MC : Minimum ganati -------------------------------------------------------------------------------------
                        Indemnities."Minimum value" := DefaultIndemnities."Minimum value";
                        Indemnities.Name := Employee.FullName();
                        Indemnities."Included Breastfeeding Hours" := DefaultIndemnities."Included Breastfeeding Hours";
                        Indemnities."Included in UGTT Hours" := DefaultIndemnities."Included in UGTT Hours";
                        Indemnities."Includes Extra Days" := DefaultIndemnities."Includes Extra Days";
                        Indemnities."User ID" := USERID;
                        Indemnities.Rate := DefaultIndemnities.Rate;
                        IF (SalaryLine.Month.AsInteger() > 12) AND (DefaultIndemnities."Not Included in Bonus" = TRUE) THEN
                            Indemnities.Rate := 0;
                        IF EmploymentContract."Adjust indemnity amount" THEN BEGIN
                            CASE DefaultIndemnities."Evaluation mode".AsInteger() OF
                                0, 4, 9:
                                    Indemnities."Base Amount" := DefaultIndemnities."Default amount";
                                1:
                                    Indemnities."Base Amount" := DefaultIndemnities."Default amount"
                                                                 * SalaryHeader."Paid days"
                                                                 / ParamRessHum."Paid days";
                                2:
                                    Indemnities."Base Amount" := (DefaultIndemnities."Default amount"
                                                                 * SalaryHeader."Worked days"
                                                                 / ParamRessHum."Worked days");
                                7:
                                    Indemnities."Base Amount" := (SalaryLine."Basis salary");
                                3, 8:
                                    Indemnities."Base Amount" := (DefaultIndemnities."Default amount");
                            END;
                        END
                        ELSE
                            Indemnities."Base Amount" := (DefaultIndemnities."Default amount");
                        Indemnities."Real Amount" := 0;
                        Indemnities."Not incl. Nat. Old Age Insur." := DefaultIndemnities."Not incl. Nat. Old Age Insur.";
                        Ins := TRUE;
                        IF Indemnities."Indemnity Type" = Indemnities."Indemnity Type"::"Not Regular" THEN BEGIN
                            Ins := FALSE;
                            IF ParamRessHum."Activate Alert Other Payroll" THEN BEGIN
                                IF CONFIRM(STRSUBSTNO('Indemnité %1 Pour L''Employer %2 Montant de Base est de %3 n''est Pas une Indemnité Régulière',
                                 Indemnities.Description, Indemnities."Employee No." + ' ' + Indemnities.Name, Indemnities."Base Amount"), FALSE, TRUE) THEN
                                    Ins := TRUE;
                            END ELSE BEGIN
                                Ins := TRUE;
                            END;
                        END;
                        IF Ins THEN
                            IF Indemnities.INSERT THEN BEGIN
                                // Cotisations à appliquer à des Indmennités particulières
                                DefaultSocContribution.RESET;
                                DefaultSocContribution.SETRANGE("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
                                DefaultSocContribution.SETRANGE("Indemnity Code", DefaultIndemnities."Indemnity Code");
                                ParamRessHum.GET;
                                IF SalaryLine.Month = SalaryLine.Month::Prime THEN
                                    DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
                                IF NOT ParamRessHum."Activate Bonus Type" THEN BEGIN
                                    IF SalaryLine.Month = SalaryLine.Month::Prime THEN
                                        DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
                                END ELSE BEGIN
                                    SocialContributions.RESET;
                                    SocialContributions.SETRANGE("No.", SalaryLine."No.");
                                    SocialContributions.SETRANGE("Employee No.", SalaryLine."Employee No.");
                                    IF SocialContributions.FINDSET THEN
                                        SocialContributions.DELETEALL();
                                    IF ((SalaryLine.Month.AsInteger() > 12)) THEN //OR (PrimeType.Fonction<>2) THEN  WDC0911
                                        DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
                                END;
                                IF DefaultSocContribution.FINDFIRST THEN
                                    REPEAT
                                        SocialContributions.INIT;
                                        SocialContributions."No." := SalaryLine."No.";
                                        SocialContributions."Calculate Year" := SalaryLine."Calculate Year";
                                        SocialContributions."Employee No." := SalaryLine."Employee No.";
                                        SocialContributions.Indemnity := DefaultIndemnities."Indemnity Code";
                                        SocialContributions."Social Contribution" := DefaultSocContribution."Social Contribution Code";
                                        SocialContributions."Basis of calculation" := DefaultSocContribution."Basis of calculation";
                                        SocialContributions."Employee Posting Group" := SalaryLine."Employee Posting Group";
                                        SocialContributions."Employee Statistic Group" := SalaryLine."Statistics Group Code";
                                        SocialContributions."Global Dimension 1" := SalaryLine."Global Dimension 1";
                                        SocialContributions."Global Dimension 2" := SalaryLine."Global Dimension 2";
                                        SocialContributions.Management := SalaryLine.Management;
                                        SocialContributions.service := SalaryLine.Service;
                                        SocialContributions.section := SalaryLine.Section;
                                        IF SocialContribution.GET(DefaultSocContribution."Social Contribution Code") THEN
                                            SocialContributions.Description := SocialContribution.Description;
                                        SocialContributions."Employer's part" := DefaultSocContribution."Employer's part";
                                        SocialContributions."Employee's part" := DefaultSocContribution."Employee's part";
                                        SocialContributions."Base Amount" := 0;
                                        SocialContributions."Real Amount : Employee" := 0;
                                        SocialContributions."Real Amount : Employer" := 0;
                                        SocialContributions."Deductible of taxable basis" := DefaultSocContribution."Deductible of taxable basis";
                                        SocialContributions."Maximum value - Employee" := DefaultSocContribution."Maximum value - Employee";
                                        SocialContributions."Maximum value - Employer" := DefaultSocContribution."Maximum value - Employer";

                                        SocialContributions."Evaluation Mode" := DefaultSocContribution."Evaluation Mode";
                                        SocialContributions."Salary Package" := DefaultSocContribution."Salary Package";
                                        SocialContributions."Employer contribution" := DefaultSocContribution."Employer contribution";

                                        SocialContributions.INSERT;
                                    UNTIL DefaultSocContribution.NEXT = 0;
                            END;
                    END;
                UNTIL DefaultIndemnities.NEXT = 0;

            // Cotisations à appliquer à toutes les indemnités
            DefaultSocContribution.SETRANGE("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
            DefaultSocContribution.SETRANGE("Indemnity Code", '');
            ParamRessHum.GET;
            IF NOT ParamRessHum."Activate Bonus Type" THEN BEGIN
                IF SalaryLine.Month = SalaryLine.Month::Prime THEN
                    DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
            END ELSE BEGIN
                IF ((SalaryLine.Month.AsInteger() > 12)) THEN //OR (PrimeType.Fonction<>2) THEN  WDC0901
                    DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
            END;
            IF DefaultSocContribution.FINDFIRST THEN
                REPEAT
                    //WDC01
                    SocialContributions.INIT;
                    SocialContributions."No." := SalaryLine."No.";
                    SocialContributions."Employee No." := SalaryLine."Employee No.";
                    SocialContributions."Calculate Year" := SalaryLine."Calculate Year";
                    SocialContributions.Indemnity := '';
                    SocialContributions."Social Contribution" := DefaultSocContribution."Social Contribution Code";
                    SocialContributions."Employee Posting Group" := SalaryLine."Employee Posting Group";
                    SocialContributions."Employee Statistic Group" := SalaryLine."Statistics Group Code";
                    SocialContributions."Global Dimension 1" := SalaryLine."Global Dimension 1";
                    SocialContributions."Global Dimension 2" := SalaryLine."Global Dimension 2";
                    SocialContributions.Management := SalaryLine.Management;
                    SocialContributions.service := SalaryLine.Service;
                    SocialContributions.section := SalaryLine.Section;
                    IF SocialContribution.GET(DefaultSocContribution."Social Contribution Code") THEN
                        SocialContributions.Description := SocialContribution.Description;
                    SocialContributions."Basis of calculation" := DefaultSocContribution."Basis of calculation";
                    SocialContributions."Employer's part" := DefaultSocContribution."Employer's part";
                    SocialContributions."Employee's part" := DefaultSocContribution."Employee's part";
                    SocialContributions."Base Amount" := 0;
                    SocialContributions."Real Amount : Employee" := 0;
                    SocialContributions."Real Amount : Employer" := 0;
                    SocialContributions."Deductible of taxable basis" := DefaultSocContribution."Deductible of taxable basis";
                    SocialContributions."Maximum value - Employee" := DefaultSocContribution."Maximum value - Employee";
                    SocialContributions."Maximum value - Employer" := DefaultSocContribution."Maximum value - Employer";
                    SocialContributions."Evaluation Mode" := DefaultSocContribution."Evaluation Mode";
                    SocialContributions."Salary Package" := DefaultSocContribution."Salary Package";
                    SocialContributions."Employer contribution" := DefaultSocContribution."Employer contribution";
                    IF SocialContributions.INSERT THEN;
                UNTIL DefaultSocContribution.NEXT = 0;
            OK := TRUE;
        END ELSE
            OK := FALSE;
    end;


    procedure CreateIndemnityLine(var SalaryLine: Record "WDC Salary Lines"; Employee: Record Employee) OK: Boolean
    var
        Indemnities: Record "WDC Indemnities";
        EmploymentContract: Record "Employment Contract";
        DefaultIndemnities: Record "WDC Default Indemnities";
        DefaultSocContribution: Record "WDC Default Soc. Contribution";
        ins: Boolean;
        ParamRessHum: Record "Human Resources Setup";
    begin
        ParamCpta.GET;
        IF Employee."Emplymt. Contract Code" <> '' THEN BEGIN
            DefaultIndemnities.RESET;
            IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN;
            DefaultIndemnities.SETRANGE("Emplymt. Contract Code", EmploymentContract.Code);
            IF (SalaryLine.Month.AsInteger() <> 15) AND (SalaryLine.Month.AsInteger() > 12) THEN
                DefaultIndemnities.SETRANGE("Not Included in Bonus", FALSE);
            IF DefaultIndemnities.FINDSET THEN
                REPEAT
                    Indemnities.RESET;
                    Indemnities.INIT;
                    Indemnities."No." := SalaryLine."No.";
                    Indemnities."Employee No." := SalaryLine."Employee No.";
                    Indemnities.Indemnity := DefaultIndemnities."Indemnity Code";
                    Indemnities."Employee Posting Group" := SalaryLine."Employee Posting Group";
                    Indemnities."Employee Statistic Group" := SalaryLine."Statistics Group Code";
                    Indemnities."Global Dimension 1" := SalaryLine."Global Dimension 1";
                    Indemnities."Global Dimension 2" := SalaryLine."Global Dimension 2";
                    Indemnities.Management := SalaryLine.Management;
                    Indemnities.service := SalaryLine.Service;
                    Indemnities.section := SalaryLine.Section;
                    Indemnities.Description := DefaultIndemnities.Description;
                    Indemnities.Type := DefaultIndemnities.Type;
                    Indemnities."Evaluation mode" := DefaultIndemnities."Evaluation mode";
                    Indemnities."Not Included in Bonus" := DefaultIndemnities."Not Included in Bonus";
                    Indemnities."Amount Rounding Precision" := DefaultIndemnities."Amount Rounding Precision";
                    Indemnities."Rounding Direction" := DefaultIndemnities."Rounding Direction";
                    Indemnities."Not included in vacation days" := DefaultIndemnities."Not included in vacation days";
                    Indemnities."Days Number" := DefaultIndemnities."Days Number";
                    Indemnities."Days Number" := DefaultIndemnities."Days Number";
                    Indemnities."Included Breastfeeding Hours" := DefaultIndemnities."Included Breastfeeding Hours";
                    Indemnities."Included in UGTT Hours" := DefaultIndemnities."Included in UGTT Hours";
                    Indemnities."Includes Extra Days" := DefaultIndemnities."Includes Extra Days";
                    IF ((SalaryLine.Month.AsInteger() > 12)) AND (DefaultIndemnities."Not Included in Bonus" = TRUE) THEN
                        Indemnities.Rate := 0;
                    IF Indemnities."Evaluation mode".AsInteger() = 7 THEN
                        Indemnities."Base Amount" := (SalaryLine."Basis salary")
                    ELSE
                        Indemnities."Base Amount" := ROUND(DefaultIndemnities."Default amount", ParamCpta."Amount Rounding Precision");
                    Indemnities."Minimum value" := DefaultIndemnities."Minimum value";
                    Indemnities."Real Amount" := 0;
                    Indemnities."Indemnity Type" := DefaultIndemnities."Indemnity Type";
                    Indemnities."User ID" := USERID;
                    ins := TRUE;
                    IF Indemnities."Indemnity Type".AsInteger() = 1 THEN BEGIN
                        ins := FALSE;
                        ParamRessHum.GET();
                        IF ParamRessHum."Activate Alert Other Payroll" THEN BEGIN
                            IF CONFIRM(STRSUBSTNO('Indemnité %1 Pour L''Employer %2 Montant de Base est de %3 n''est Pas une Indemnité Régulière',
                             Indemnities.Description, Indemnities."Employee No." + ' ' + Indemnities.Name, Indemnities."Base Amount"), FALSE, TRUE) THEN
                                ins := TRUE;
                        END ELSE BEGIN
                            ins := TRUE;
                        END;
                    END;
                    IF ins THEN
                        IF Indemnities.INSERT THEN;
                UNTIL DefaultIndemnities.NEXT = 0;
            OK := TRUE;
        END
        ELSE
            OK := FALSE;
    end;

    procedure CalculateSalaryLine(var SalaryLine: Record "WDC Salary Lines"; "SolderDroitCongé": Boolean; Sim: Option Simulation,Real,Prime; nbjsolder: Decimal; Pinverse: Boolean): Decimal
    var
        SalaryHeader: Record "WDC Salary Header";
        Ind: Record "WDC Indemnities";
        ParamRessHum: Record "Human Resources Setup";
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        Employee: Record Employee;
        SliceImposition: Record "WDC Slices of imposition";
        TableauAmortissementPret: Record "WDC Tablau amortissement prêt";
        MontantPretAmmortissement: Decimal;
        ChefFamille: Decimal;
        nbr: Decimal;
        bonus: Decimal;
        SalLineEng: Record "WDC Salary Lines";
        LigneTravail: Record "WDC Occasional Hours Recorded";
        NbrPaieEmployee: Decimal;
        TotImposable: Decimal;
        LigneTravailEnreg: Record "WDC Overtime hours recorded m";
        "Mgmt.ofLoansandAdvances": Codeunit "WDC Mgmt. Loans & Adv";
        droitconge: Record "WDC Employee's days off Entry";
        SalLineEngTmp: Record "WDC Salary Lines";
        MntInd: Decimal;
        DefaultIndemnitiesTmp: Record "WDC Default Indemnities";
        SoldeReport: Decimal;
        EMP1: Record Employee;
        LigneAbsence: Record "WDC Employee's days off Entry";
        AbsEmp: Decimal;
        "RecLJourFérier": Record "WDC Employee's days off Entry";
        RecLDefaultindemnities: Record "WDC Default Indemnities";
        RecLIndemnities: Record "WDC Indemnities";
        HeureJourTravail: Record "WDC Occasional Hours Recorded";
        AbsEmp1: Decimal;
        Indem: Record "WDC Indemnities";
        RecEmployeeAbsence: Record "WDC Employee's days off Entry";
        Cumconge: Decimal;
        Lemp: Record Employee;

    begin
        SalaryHeader.GET(SalaryLine."No.");
        ParamRessHum.GET();
        IF NOT SolderDroitCongé THEN
            nbjsolder := 0;
        ParamCpta.GET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        CLEAR(EmploymentContract);
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        RegimeWork.RESET;
        RegimeWork.GET(EmploymentContract."Work Regime");
        MgmtSalary2.initLigne(SalaryLine, Sim);
        GNbJour := SalaryHeader."Worked days"; //RegimeWork."Worked Day Per Month" WDC2308
        GNbHeure := RegimeWork."Work Hours per month";
        IndConvent := 0;
        //-->calcul de la bonification
        bonus := 1;
        IF (SalaryLine.Month.AsInteger() > 11) AND (SalaryLine.Purcent > 0) THEN BEGIN
            bonus := SalaryLine.Purcent;
            IF ParamRessHum."Type de Note" = 0 THEN
                bonus := bonus / 100;
            //-->Prise en compte de nbre de mois travaillés
            IF SalaryLine."Worked Months" > 0 THEN
                bonus := bonus * (SalaryLine."Worked Months" / 12)
            ELSE
                bonus := 0;
        END;
        //--> Soder droit congé
        IF Sim = 1 THEN
            AbsenceMgmt.CalcAbsence(SalaryLine);
        ParamRessHum.TESTFIELD("Minimum Wage Guarantee");
        IF SalaryLine.Month.AsInteger() < 12 THEN BEGIN
            IF (DATE2DMY(Employee."Employment Date", 3) = SalaryLine.Year) AND ((DATE2DMY(Employee."Employment Date", 2) - 1) = SalaryLine.Month.AsInteger())
            THEN BEGIN

                SalaryLine."6 * SMIG" := ROUND(ParamRessHum."Minimum Wage Guarantee" * 6 *
                      (CALCDATE('<+CM>', Employee."Employment Date") - Employee."Employment Date" + 1), ParamCpta."Amount Rounding Precision");
                IF DATE2DMY(Employee."Employment Date", 2) = (SalaryHeader.Month.AsInteger() + 1) THEN
                    GNbJour := SalaryHeader."Posting Date" - Employee."Employment Date";
                IF GNbJour > SalaryHeader."Worked days" THEN //WDC2308 RegimeWork."Worked Day Per Month"
                    GNbJour := RegimeWork."Worked Day Per Month";
            END ELSE BEGIN
                SalaryLine."6 * SMIG" := ROUND(ParamRessHum."Minimum Wage Guarantee" * 6, ParamCpta."Amount Rounding Precision");
            END;
        END;
        IF SolderDroitCongé THEN BEGIN
            IF ((SalaryLine."Days off remaining" + SalaryLine."Monthly Leave Entitlement") >= nbjsolder) AND (nbjsolder <> 0) THEN
                SalaryLine."Days off balacement" := nbjsolder
            ELSE
                SalaryLine."Days off balacement" := (SalaryLine."Days off remaining" + SalaryLine."Monthly Leave Entitlement");
            droitconge.RESET;

            droitconge.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year");
            droitconge.SETRANGE("Line type", 1);
            droitconge.SETRANGE("Employee No.", SalaryLine."Employee No.");
            droitconge.SETRANGE("Posting month", SalaryLine.Month);
            droitconge.SETRANGE("Posting year", SalaryLine.Year);

            droitconge.CALCSUMS("Quantity (Days)", "Line amount", "Quantity (Hours)");
            SalaryLine."Amount Days Off balacement" := ROUND(Employee."Basis salary" * SalaryLine."Days off balacement" /
                                                     SalaryHeader."Paid days", ParamCpta."Amount Rounding Precision");
            SalaryLine."Assiduity (days off balacement" := ROUND(SalaryLine."Days off balacement" / SalaryHeader."Paid days", 0.0001) * 100;
            SalaryLine."Hours off Balacement" := droitconge."Quantity (Hours)";
        END ELSE
            SalaryLine."Days off balacement" := 0;
        // calcul jour férié
        ParamRessHum.GET();
        IF ParamRessHum."Calculate Absence Amount" = FALSE THEN BEGIN
            RecLJourFérier.RESET;
            RecLJourFérier.SETRANGE("Employee No.", SalaryLine."Employee No.");
            RecLJourFérier.SETRANGE("Posting month", SalaryLine.Month);
            RecLJourFérier.SETRANGE("Posting year", SalaryLine.Year);
            RecLJourFérier.SETRANGE("Line type", RecLJourFérier."Line type"::"Paid Public Holiday");
            IF ParamRessHum."Activate fortnightly regime" THEN
                IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                    RecLJourFérier.SETRANGE(Fortnight, SalaryHeader.Fortnight);
        END;
        IF SalaryLine."Public Holiday Worked Days" <> 0 THEN BEGIN

            RecLJourFérier.RESET;
            RecLJourFérier.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year", Fortnight, "Absence Reason");
            RecLJourFérier.SETRANGE("Employee No.", SalaryLine."Employee No.");
            RecLJourFérier.SETRANGE("Posting month", SalaryLine.Month);
            RecLJourFérier.SETRANGE("Posting year", SalaryLine.Year);
            RecLJourFérier.SETRANGE("Line type", 11);
            IF ParamRessHum."Activate fortnightly regime" THEN
                IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                    RecLJourFérier.SETRANGE(Fortnight, SalaryHeader.Fortnight);
            RecLJourFérier.CALCSUMS(RecLJourFérier."Line amount");
            SalaryLine."Public Holiday Worked Amount" := RecLJourFérier."Line amount";
            RecLJourFérier.RESET;
            RecLJourFérier.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year", Fortnight, "Absence Reason");
            RecLJourFérier.SETRANGE("Employee No.", SalaryLine."Employee No.");
            RecLJourFérier.SETRANGE("Posting month", SalaryLine.Month);
            RecLJourFérier.SETRANGE("Posting year", SalaryLine.Year);
            RecLJourFérier.SETRANGE("Line type", 10);
            IF ParamRessHum."Activate fortnightly regime" THEN
                IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                    RecLJourFérier.SETRANGE(Fortnight, SalaryHeader.Fortnight);
            RecLJourFérier.CALCSUMS(RecLJourFérier."Line amount");
            SalaryLine."Public Holiday Amount" := RecLJourFérier."Line amount";
        END;
        // --> Calcul des 2 param. d'assiduité
        MntInd := 0;
        IF Employee."Currency Code" <> '' THEN BEGIN
            DefaultIndemnitiesTmp.RESET;
            DefaultIndemnitiesTmp.SETFILTER("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
            DefaultIndemnitiesTmp.SETRANGE("Evaluation mode", 1, 2);
            DefaultIndemnitiesTmp.SETRANGE("Indemnity Type", 0);
            IF DefaultIndemnitiesTmp.FINDFIRST THEN
                REPEAT
                    MntInd := MntInd + DefaultIndemnitiesTmp."Default amount";
                UNTIL DefaultIndemnitiesTmp.NEXT = 0;
        END;
        nbr := 12;
        EmploymentContract.RESET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        CASE ParamRessHum."Monthes Number".AsInteger() OF
            0:
                nbr := EmploymentContract."Regular payments";
            1:
                nbr := EmploymentContract."Temporary payments";
            2:
                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
        END;
        IF RegimeWork.GET(SalaryLine."Employee Work Regime") THEN;
        IF ((Sim = 1) OR ((SalaryLine."Basis salary" = 0) AND (Sim = 0))) AND NOT ((Pinverse = TRUE) AND (SalaryLine."Basis salary" = 0)) THEN BEGIN
            IF SalaryLine."Posting Date" = 0D THEN
                SalaryLine."Posting Date" := WORKDATE;
            IF Employee."Currency Code" = '' THEN
                SalaryLine."Basis salary" := Employee."Basis salary"
            ELSE BEGIN
                IF Employee."Taxable Indemnity" <> 0 THEN
                    SalaryLine."Basis salary" :=
                       ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code",
                          Employee."Taxable Indemnity", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"),
                          Employee."Currency Code")
              ) -
                          MntInd, ParamCpta."Amount Rounding Precision")
                ELSE
                    SalaryLine."Basis salary" :=
                         ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code",
                          Employee."Basis salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code")
              )
                          , ParamCpta."Amount Rounding Precision");
            END;
        END;
        //Salaire de base
        CASE SalaryLine."Employee type".AsInteger() OF
            0:
                BEGIN
                    LigneAbsence.RESET;
                    LigneAbsence.SETCURRENTKEY("Employee No.", "Posting year", "Posting month", "Absence Reason", Week, Fortnight);
                    //>>4   Correctif calcul absence
                    LigneAbsence.SETFILTER("Line type", '%1|%2', LigneAbsence."Line type"::"Not Paid",
                     LigneAbsence."Line type"::"1/2 Paid");
                    //<<  Correctif calcul absence
                    LigneAbsence.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneAbsence.SETRANGE("Posting month", SalaryLine.Month);
                    LigneAbsence.SETRANGE("Posting year", SalaryLine.Year);
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                            LigneAbsence.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                    LigneAbsence.CALCSUMS(Quantity);
                    AbsEmp := LigneAbsence.Quantity;

                    SalaryLine."Assiduity (Paid days)" := (SalaryHeader."Paid days"
                                                             - SalaryLine.Absences
                                                             + ABS(SalaryLine."Public Holidays")
                                                             - SalaryLine."Adjustment of absences")
                                                             / SalaryHeader."Paid days"
                                                             * 100;

                    SalaryLine."Assiduity (Worked days)" := (SalaryHeader."Worked days"
                                                             - ABS(LigneAbsence.Quantity)
                                                             - ABS(SalaryLine."Days off")
                                                             + ABS(SalaryLine."Public Holidays")
                                                             - ABS(SalaryLine."Adjustment of absences"))
                                                             / SalaryHeader."Worked days"
                                                             * 100;



                    //CALCUL HEURES NORMALES
                    Heuresoccaenregm.RESET;
                    Heuresoccaenregm.SETFILTER("Employee No.", Employee."No.");
                    Heuresoccaenregm.SETFILTER("Payment Month", '%1', SalaryHeader.Month);
                    Heuresoccaenregm.SETFILTER("Payment Year", '%1', SalaryHeader.Year);
                    Heuresoccaenregm.SETFILTER(Heuresoccaenregm."Payment No.", '%1', '');
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                            Heuresoccaenregm.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                    IF Heuresoccaenregm.FINDFIRST THEN
                        REPEAT
                            TotHeuresEnreg := TotHeuresEnreg + Heuresoccaenregm."Hours Number";
                        UNTIL Heuresoccaenregm.NEXT = 0;
                    //END CALCUL HEURES NORMALE 25/12/2008
                    IF Sim = 0 THEN
                        TotHeuresEnreg := GNbHeure;

                    SalaryLine."Worked hours" := TotHeuresEnreg;
                    IF (Pinverse = TRUE) THEN
                        SalaryLine."Basis salary" := Employee."Basis salary";
                    IF GNbHeure > TotHeuresEnreg THEN
                        SalaryLine.Absences := GNbHeure - TotHeuresEnreg;

                    SalaryLine."Real basis salary" := ROUND(SalaryLine."Worked hours" * Employee."Basis salary",
                                                      ParamCpta."Amount Rounding Precision");
                    IF (Pinverse = FALSE) THEN
                        SalaryLine."Real basis salary" := ROUND(SalaryLine."Worked hours" * SalaryLine."Basis salary",
                                                        ParamCpta."Amount Rounding Precision");
                    SalaryLine."Assiduity (Paid days)" := (SalaryLine."Worked hours" / RegimeWork."Work Hours per month") * 100;
                    IF SalaryLine."Assiduity (Paid days)" > 100 THEN
                        SalaryLine."Assiduity (Paid days)" := 100;
                END;
            1:
                BEGIN
                    SalaryLine."Basis hours" := LigneTravail."Hours Number";
                    LigneAbsence.RESET;
                    LigneAbsence.SETCURRENTKEY("Employee No.", "Posting year", "Posting month", "Absence Reason", Week, Fortnight);
                    LigneAbsence.SETFILTER("Line type", '%1|%2', LigneAbsence."Line type"::"Not Paid",
                     LigneAbsence."Line type"::"1/2 Paid");
                    //<<  Correctif calcul absence
                    LigneAbsence.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneAbsence.SETRANGE("Posting month", SalaryLine.Month);
                    LigneAbsence.SETRANGE("Posting year", SalaryLine.Year);
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                            LigneAbsence.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);

                    LigneAbsence.CALCSUMS(Quantity);
                    AbsEmp := LigneAbsence.Quantity;
                    //CALCUL JOUR NORMALES 
                    //>> ----NE PAS SAISIR LE NOMBRE DE JOOUR TRAVAILLE
                    Lemp.GET(SalaryLine."Employee No.");
                    IF Lemp."Employee type".AsInteger() = 1 THEN BEGIN
                        CLEAR(RecEmployeeAbsence);
                        CLEAR(Cumconge);
                        RecEmployeeAbsence.SETFILTER("Employee No.", '%1', SalaryLine."Employee No.");
                        RecEmployeeAbsence.SETFILTER("Posting month", '%1', SalaryLine.Month);
                        RecEmployeeAbsence.SETFILTER("Posting year", '%1', SalaryLine.Year);
                        RecEmployeeAbsence.SETFILTER("Line type", '%1', RecEmployeeAbsence."Line type"::"Day off Consumption");
                        IF RecEmployeeAbsence.FINDSET THEN
                            REPEAT
                                Cumconge += RecEmployeeAbsence.Quantity
                            UNTIL RecEmployeeAbsence.NEXT = 0;
                    END ELSE
                        Cumconge := 0;
                    //>>Congès Jours supplémentaires
                    JourS := 0;
                    IndemJS.RESET;
                    IndemJS.SETRANGE("Emplymt. Contract Code", SalaryLine."Employee No.");
                    IndemJS.SetRange("Indemnity Code", ParamRessHum."Indem Overtime Days");
                    IF IndemJS.FINDSET THEN
                        JourS := IndemJS."Days Number"
                    ELSE
                        JourS := 0;
                    //<<Conges jours supplémentaires
                    NbrJourPaye := 0;
                    TotJoursEnreg := GNbJour - AbsEmp - AbsEmp1 - SalaryLine."Public Holidays" - Cumconge;
                    //>>           -Cas des soldes congés Mensuel
                    IF SalaryLine.Month.AsInteger() = 16 THEN BEGIN
                        LigneTravail.RESET;
                        LigneTravail.SETRANGE("Employee No.", SalaryLine."Employee No.");
                        LigneTravail.SETRANGE("Payment Month", SalaryLine.Month);
                        LigneTravail.SETRANGE("Payment Year", SalaryLine.Year);
                        LigneTravail.SETFILTER("Payment No.", '%1', '');
                        IF LigneTravail.FINDSET THEN BEGIN
                            LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                            TotJoursEnreg := LigneTravail."Days Number";
                        END;
                    END;
                    //<<           -Cas des soldes congés Mensuel
                    //<< ----NE PAS SAISIR LE NOMBRE DE JOUR TRAVAILLE
                    //>>          -Calcul Impot Rammené au nombre de jour--------------------------------------------------------
                    IF SalaryLine."Employee type".AsInteger() = 1 THEN BEGIN
                        NbrJourPaye := TotJoursEnreg + SalaryLine."Public Holidays" + Cumconge;        //WDC2308 SalaryLine."Jour CongéAPEM"
                    END;
                    //<<          -Calcul Impot Rammené au nombre de jour--------------------------------------------------------

                    Heuresoccaenregm.RESET;
                    Heuresoccaenregm.SETFILTER("Employee No.", Employee."No.");
                    Heuresoccaenregm.SETFILTER("Payment Month", '%1', SalaryHeader.Month);
                    Heuresoccaenregm.SETFILTER("Payment Year", '%1', SalaryHeader.Year);
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                            Heuresoccaenregm.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                    IF Heuresoccaenregm.FINDFIRST THEN
                        REPEAT
                            TotJoursEnreg := TotJoursEnreg;
                        UNTIL Heuresoccaenregm.NEXT = 0;
                    IF GNbJour >= TotJoursEnreg THEN
                        AbsEmp := GNbJour - TotJoursEnreg
                    ELSE BEGIN
                        AbsEmp := 0;
                    END;
                    IF Sim = 0 THEN
                        TotJoursEnreg := GNbJour - AbsEmp;
                    IF Lemp."Employee type".AsInteger() = 1 THEN BEGIN
                        AbsEmp := 0;
                        CLEAR(RecEmployeeAbsence);
                        RecEmployeeAbsence.SETFILTER("Employee No.", '%1', SalaryLine."Employee No.");
                        RecEmployeeAbsence.SETFILTER("Posting month", '%1', SalaryLine.Month);
                        RecEmployeeAbsence.SETFILTER("Posting year", '%1', SalaryLine.Year);
                        RecEmployeeAbsence.SETFILTER("Line type", '%1', RecEmployeeAbsence."Line type"::"Not Paid");
                        IF RecEmployeeAbsence.FINDSET THEN
                            REPEAT
                                AbsEmp += RecEmployeeAbsence.Quantity
                            UNTIL RecEmployeeAbsence.NEXT = 0
                    END
                    ELSE
                        AbsEmp := 0;

                    SalaryLine.Absences := AbsEmp;
                    IF Pinverse THEN
                        SalaryLine."Paied days" := RegimeWork."Worked Day Per Month"
                    ELSE
                        SalaryLine."Paied days" := TotJoursEnreg;//-SalaryLine."Public Holidays";
                    GNbJour := SalaryHeader."Worked days";
                    SalaryLine."Assiduity (Paid days)" := (SalaryHeader."Paid days"
                                                              - AbsEmp
                                                              - ABS(SalaryLine."Public Holidays")
                                                              - Cumconge
                                                              - SalaryLine."Adjustment of absences")
                                                              / SalaryHeader."Paid days"
                                                              * 100;
                    SalaryLine."Assiduity (Worked days)" := (SalaryHeader."Worked days"
                                                             - ABS(LigneAbsence.Quantity)
                                                             - ABS(SalaryLine."Days off")
                                                             //>>
                                                             + ABS(SalaryLine."Public Holidays")
                                                             + Cumconge
                                                             //<<
                                                             - ABS(SalaryLine."Adjustment of absences"))
                                                             / SalaryHeader."Worked days"
                                                             * 100;
                    IF (Pinverse = TRUE) THEN
                        SalaryLine."Basis salary" := Employee."Basis salary";
                    // AGA >> assiduité jour payé

                    IF (Pinverse = FALSE) THEN
                        SalaryLine."Real basis salary" := ROUND((TotJoursEnreg) * SalaryLine."Basis salary" / RegimeWork."Worked Day Per Month"
                                                         , ParamCpta."Amount Rounding Precision");



                    //>> calcul des heures travaillées pour les salariers de type  mensuel horaire
                    Heuresoccaenregm.RESET;
                    Heuresoccaenregm.SETFILTER("Employee No.", Employee."No.");
                    Heuresoccaenregm.SETFILTER("Payment Month", '%1', SalaryHeader.Month);
                    Heuresoccaenregm.SETFILTER("Payment Year", '%1', SalaryHeader.Year);
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                            Heuresoccaenregm.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                    IF Heuresoccaenregm.FINDFIRST THEN
                        REPEAT
                            SalaryLine."Hours Amount" := Heuresoccaenregm."Line amount";
                        UNTIL Heuresoccaenregm.NEXT = 0;
                END;
        END;
        //FIN CALCUL SALAIRE DE BASE
        // Calcul Indemnité
        IF Pinverse AND (SalaryLine.Month = SalaryLine.Month::Prime) THEN
            SalaryLine."Amount Days Off balacement" := 0;
        IF ParamRessHum."Leave Balance Calc. Type".AsInteger() = 1 THEN
            SalaryLine."Assiduity (Paid days)" := SalaryLine."Assiduity (Paid days)" + SalaryLine."Assiduity (days off balacement";
        // Calcul Indemnité
        TaxesMgmt.CalcTaxableIndemnity(SalaryLine, GNBJour, GNBHeure, TotJoursEnreg);
        // calcul droit de congé du mois
        HeureJourTravail.RESET;
        HeureJourTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
        HeureJourTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
        HeureJourTravail.SETFILTER("Payment Month", '%1', SalaryLine.Month);
        HeureJourTravail.SETFILTER("Payment Year", '%1', SalaryLine.Year);
        IF ParamRessHum."Activate fortnightly regime" THEN
            IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN BEGIN
                HeureJourTravail.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
            END;
        //>>          -Calcul Impot Rammené au nombre de jour-------------------------------------------------------------
        HeureJourTravail.CALCSUMS("Hours Number", "Line amount", "Days Number", "Pulic Holiday Days");
        //<<          -Calcul Impot Rammené au nombre de jour-------------------------------------------------------------


        //>>         -Calcul Impot Rammené au nombre de jour-------------------------------------------------------------
        IF SalaryLine."Employee type".AsInteger() = 0 THEN BEGIN
            NbrJourPaye := HeureJourTravail."Days Number" + HeureJourTravail."Pulic Holiday Days";//+ROUND(HeureJourTravail."Jour CongéAPEM"/7,0.1,'>');
        END;
        //<<          -Calcul Impot Rammené au nombre de jour-------------------------------------------------------------


        IF Employee."Employee type".AsInteger() = 0 THEN
            SalaryLine."Monthly Leave Entitlement" := ROUND(RegimeWork."Days off per month" * HeureJourTravail."Hours Number" /
                                                      RegimeWork."Work Hours per month", ParamCpta."Amount Rounding Precision")
        ELSE
            SalaryLine."Monthly Leave Entitlement" := ROUND(RegimeWork."Days off per month" * SalaryLine."Assiduity (Paid days)" / 100,
                                                            ParamCpta."Amount Rounding Precision");
        IF SalaryLine."Monthly Leave Entitlement" > RegimeWork."Days off per month" THEN
            SalaryLine."Monthly Leave Entitlement" := RegimeWork."Days off per month";

        //--> Calcul du salaire Brut du mois
        //  SalaryLine.CALCFIELDS("Public Holiday Worked Amount");
        "CalcInd&HsupNav"(SalaryLine, Sim);
        SalaryLine.CALCFIELDS("Sick leave amount", "Work accident amount");

        SalaryLine."6 * SMIG" := ROUND(ParamRessHum."Minimum wage guarantee" * 6, ParamCpta."Amount Rounding Precision");
        IF (SalaryLine.Month = SalaryLine.Month::Prime) THEN
            SalaryLine."Assiduity (Paid days)" := 100;
        CASE SalaryLine."Employee type".AsInteger() OF
            1:
                BEGIN
                    SalaryLine."Gross Salary (Without AV)" := ROUND((bonus * SalaryLine."Real basis salary")
                                                          + SalaryLine."Taxable Indem. PR (Not Gross)"
                                                          + SalaryLine."Taxable indemnities"
                                                          + SalaryLine."Supp. hours"
                                                          + SalaryLine."Public Holiday Amount"
                                                        + SalaryLine."Public Holiday Worked Amount"
                                                        + SalaryLine."Sick leave amount"
                                                        + SalaryLine."Work accident amount"

                                                          , ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary (Without AV) PR" := ROUND((SalaryLine."Basis salary" - SalaryLine."Amount Days Off balacement"
                                                                  ) + SalaryLine."Taxable indemnities PR"
                                                                  , ParamCpta."Amount Rounding Precision") +
                                                                  SalaryLine."Taxable indem. PR (Not Gross)";
                    SalaryLine."Gross Salary" := SalaryLine."Gross Salary (Without AV)";
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary PR" := SalaryLine."Gross Salary (Without AV) PR";
                END;
            0:
                BEGIN
                    SalaryLine."Gross Salary (Without AV)" := ROUND((bonus * SalaryLine."Real basis salary")
                                                        + SalaryLine."Taxable Indem. PR (Not Gross)"
                                                        + SalaryLine."Taxable indemnities"
                                                        + SalaryLine."Supp. hours"
                                                        + SalaryLine."Public Holiday Worked Amount"
                                                        + SalaryLine."Sick leave amount"
                                                        + SalaryLine."Work accident amount"
                                                        , ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary (Without AV) PR" := ROUND((SalaryLine."Basis salary" - SalaryLine."Amount Days Off balacement"
         )
                                                        + SalaryLine."Taxable indemnities PR" + SalaryLine."Taxable indem. PR (Not Gross)"
                                                        , ParamCpta."Amount Rounding Precision");
                    SalaryLine."Gross Salary" := SalaryLine."Gross Salary (Without AV)";
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary (Without AV) PR" := SalaryLine."Gross Salary (Without AV) PR";
                END;
        END;

        CalculIndemnityAvNat(SalaryLine);
        CASE SalaryLine."Employee type".AsInteger() OF
            1:
                BEGIN
                    LigneTravail.RESET;
                    LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight, "Payment No.");
                    LigneTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravail.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravail.SETRANGE("Payment Year", SalaryLine.Year);
                    LigneTravail.SETFILTER("Payment No.", '%1|%2', SalaryLine."No.", '');
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN BEGIN
                            LigneTravail.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                        END;
                    LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                    LigneTravail.MODIFYALL("Payment No.", SalaryLine."No.");
                    SalaryLine."Basis hours" := LigneTravail."Hours Number";
                    LigneTravailEnreg.RESET;
                    LigneTravailEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
                    LigneTravailEnreg.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravailEnreg.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravailEnreg.SETRANGE("Payment Year", SalaryLine.Year);
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN BEGIN
                            LigneTravailEnreg.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                        END;

                    LigneTravailEnreg.CALCSUMS("Hours Number", "Line amount");
                    LigneAbsence.RESET;
                    //WDC0805

                    SalaryLine."Gross Salary" := ROUND(
                                                           (SalaryLine."Real basis salary" * bonus)
                                                           + SalaryLine."Taxable indemnities"
                                                           + SalaryLine."Supp. hours"
                                                           + SalaryLine."Public Holiday Worked Amount"
                                                             + SalaryLine."Public Holiday Amount"
                                                           + SalaryLine."Sick leave amount"
                                                           + SalaryLine."Work accident amount",
                                                           //>> Régime mensuel horaires
                                                           //WDC0805 +SalaryLine."Montant Heures",
                                                           ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary PR" := ROUND((bonus * SalaryLine."Real basis salary") + SalaryLine.
                                                               "Taxable indemnities PR", ParamCpta."Amount Rounding Precision");
                END;
            0:
                BEGIN
                    LigneTravail.RESET;
                    LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
                    LigneTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravail.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravail.SETRANGE("Payment Year", SalaryLine.Year);

                    //AGA ---------------------------------------------------------------------------------------
                    LigneTravail.SETFILTER("Payment No.", '%1|%2', SalaryLine."No.", '');
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN BEGIN
                            LigneTravail.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                        END;
                    LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                    LigneTravail.MODIFYALL("Payment No.", SalaryLine."No.");
                    SalaryLine."Basis hours" := LigneTravail."Hours Number";
                    LigneTravailEnreg.RESET;
                    LigneTravailEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
                    LigneTravailEnreg.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravailEnreg.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravailEnreg.SETRANGE("Payment Year", SalaryLine.Year);
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN BEGIN
                            LigneTravailEnreg.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                        END;
                    LigneTravailEnreg.CALCSUMS("Hours Number", "Line amount");
                    LigneAbsence.RESET;
                    SalaryLine."Gross Salary" := ROUND(
                                                            (SalaryLine."Real basis salary" * bonus)
                                                           + SalaryLine."Taxable indemnities"
                                                           + SalaryLine."Supp. hours"
                                                           + SalaryLine."Public Holiday Worked Amount"
                                                             + SalaryLine."Public Holiday Amount"
                                                           + SalaryLine."Sick leave amount"
                                                           + SalaryLine."Work accident amount",
                                                           ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary PR" := ROUND((SalaryLine."Real basis salary" * bonus)
                                                               + SalaryLine."Taxable indemnities PR"
                                                               , ParamCpta."Amount Rounding Precision");
                END;
        END;
        // --> Calc Cotisation Social
        IF ParamRessHum."Leave Balance Calc. Type".AsInteger() = 0 THEN
            SalaryLine."Basis salary" := SalaryLine."Basis salary" - SalaryLine."Amount Days Off balacement";
        MgmtSalary2.CalcCotisationSocial1(SalaryLine);
        //--> Calcul du salaire imposable
        MgmtSalary2.CalcAllTaxe(SalaryLine);
        //A AJOUTER CONTROLE NON IMPOSABLE
        IF EmploymentContract.Taxable = FALSE THEN
            SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib." +  //WDC01
                                     SalaryLine."Taxable indemnities(Not Gross)"
                                     - SalaryLine."Non Taxable indemnities" + (SalaryLine."Non Taxable indemnities" * 9.68 / 100)
                                     - SalaryLine."Retirement plus"//WDC01
                                                 , ParamCpta."Amount Rounding Precision");
        IF EmploymentContract.Taxable THEN BEGIN
            Gemployee.GET(SalaryLine."Employee No."); //WDC01

            SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib." +
                                               SalaryLine."Taxable indemnities(Not Gross)"
                                               - SalaryLine."Non Taxable indemnities" + (SalaryLine."Non Taxable indemnities" * 9.68 / 100)
                                              - SalaryLine."Retirement plus"
                                                           , ParamCpta."Amount Rounding Precision");   //WDC01
        END;
        IF Sim < 2 THEN
            IF EmploymentContract.Taxable THEN
                SalaryLine."Taxable salary PR" := ROUND(SalaryLine."Gross Salary PR" - SalaryLine."Non Taxable Soc. Contrib. PR" +
                                                       SalaryLine."Taxable indem. PR (Not Gross)"
                                                     - SalaryLine."Non Taxable indemnities"
                                                      , ParamCpta."Amount Rounding Precision");



        // Calc Cotisation Social
        MgmtSalary2.CalcCotisationSocial2(SalaryLine);
        //--> Calcul de l'imposable réel
        IF EmploymentContract.Taxable THEN BEGIN
            IF NOT Employee."Family chief" THEN BEGIN
                SalaryLine."Deduction Family chief" := 0;
                SalaryLine."Deduction Loaded child" := 0;
            END;
            SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Pourcent professional expenses"
                                                           * SalaryLine."Taxable salary");
            //******(1)********************Recherche sur les paie enregistr² *********************************
            ImposEnreg := 0;
            NbrPaie := 0;
            FraisEnreg := 0;
            RecGSalayEnr.RESET;
            RecGSalayEnr.SETCURRENTKEY(Year, Month, "Employee No.", "No.");
            RecGSalayEnr.SETRANGE("Employee No.", SalaryLine."Employee No.");
            RecGSalayEnr.SETRANGE(Year, SalaryLine.Year);
            IF RecGSalayEnr.FINDSET THEN
                REPEAT
                    IF RecGSalayEnr.Month.AsInteger() < nbr THEN BEGIN
                        ImposEnreg := ImposEnreg + RecGSalayEnr."Taxable salary";      //Somme imposable Enregistr²
                        FraisEnreg := FraisEnreg + RecGSalayEnr."Deduction Prof. expenses";
                    END;     //Somme Frais prof Enregistr²
                    IF RecGSalayEnr.Month.AsInteger() < nbr THEN
                        NbrPaie := NbrPaie + 1;
                UNTIL RecGSalayEnr.NEXT = 0;
            //******(2)********************Si Frais prof enregistr² >= 2000 alors frais prof = zero *********************************
            //@@@@@@@@@@@@@@@@@@   Condition 1
            IF FraisEnreg >= ParamRessHum."Professional Expenses Charges" THEN BEGIN
                SalaryLine."Deduction Prof. expenses" := 0;
            END ELSE BEGIN
                //@@@@@@@@@@@@@@@@@@   Condition 2
                //******(3)********************Si Frais prof annuel <=2000 < alors **********************************************************
                IF ROUND(ParamRessHum."Pourcent professional expenses" * (SalaryLine."Taxable salary" * (nbr - NbrPaie) + ImposEnreg)) <=
        ParamRessHum."Professional Expenses Charges" THEN BEGIN
                    IF ROUND(ParamRessHum."Pourcent professional expenses" * SalaryLine."Taxable salary") >= ROUND(ParamRessHum.
                                                                                        "Professional Expenses Charges" / nbr) THEN
                        SalaryLine."Deduction Prof. expenses" := ROUND((ParamRessHum."Professional Expenses Charges" / nbr) * (NbrPaie + 1) - FraisEnreg)
                    ELSE
                        SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Pourcent professional expenses"
                                                                        * SalaryLine."Taxable salary");
                    //@@@@@@@@@@@@@@@@@@   Condition 3
                    //******(3)********************Si Frais prof annuel <=2000 et avec l'imposable en cour sera >=2000 *********************************
                    //*************************
                END ELSE BEGIN
                    IF nbr - NbrPaie > 0 THEN   //0512
                        SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Professional Expenses Charges" - FraisEnreg) / (nbr - NbrPaie)
                    ELSE
                        SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Professional Expenses Charges" - FraisEnreg) / 1
                END;
            END;
            IF SalaryLine."Deduction Prof. expenses" > ParamRessHum."Professional Expenses Charges" / nbr THEN
                SalaryLine."Deduction Prof. expenses" := ParamRessHum."Professional Expenses Charges" / nbr;
            IF SalaryLine."Deduction Prof. expenses" + FraisEnreg > ParamRessHum."Professional Expenses Charges" THEN
                SalaryLine."Deduction Prof. expenses" := ParamRessHum."Professional Expenses Charges" - FraisEnreg;
            EMP.GET(SalaryLine."Employee No.");
            EMP.CALCFIELDS("Deduction Loaded child");
            IF EMP."Family chief" THEN BEGIN
                SalaryLine."Deduction Family chief" := ROUND(ParamRessHum."Deduction for Familly Chief" / nbr, ParamCpta."Amount Rounding Precision");
                SalaryLine."Deduction Loaded child" := ROUND(EMP."Deduction Loaded child" / nbr, ParamCpta."Amount Rounding Precision");
            END;
            IF SalaryLine.Month.AsInteger() < nbr THEN BEGIN
                SalaryLine."Real taxable" := ROUND(SalaryLine."Taxable salary"
                                                               - SalaryLine."Deduction Family chief"
                                                               - SalaryLine."Deduction Loaded child"
                                                               - SalaryLine."Deduction Prof. expenses", ParamCpta."Amount Rounding Precision");
            END
            ELSE
                SalaryLine."Real taxable" := ROUND(SalaryLine."Taxable salary"
                                                               - SalaryLine."Deduction Prof. expenses", ParamCpta."Amount Rounding Precision");
            IF (SalaryLine.Month.AsInteger() < nbr) OR (Sim = 2) THEN
                SalaryLine."Real taxable PR" := ROUND(SalaryLine."Taxable salary PR"
                                                               - SalaryLine."Deduction Family chief"
                                                               - SalaryLine."Deduction Loaded child"
                                                               - ROUND(SalaryLine."Taxable salary PR" * ParamRessHum."Pourcent professional expenses" / 100
                                                               , ParamCpta."Amount Rounding Precision"), ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLine."Real taxable PR" := ROUND(SalaryLine."Taxable salary PR"
                                                               - ROUND(SalaryLine."Taxable salary PR" * ParamRessHum."Pourcent professional expenses" / 100
                                                               , ParamCpta."Amount Rounding Precision"), ParamCpta."Amount Rounding Precision");



            //--> Calcul de l'imposable réel par an
            SalLineEng.RESET;
            SalLineEng.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Taxable);
            SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEng.Setrange(Year, SalaryLine.Year);
            SalLineEng.Setrange(Taxable, TRUE);
            SalLineEng.CALCSUMS("Real taxable", "Taxe (Month)", "Taxable salary", "Public Holidays", "Paied days", "CSS Tax");  //WDCREGUL REMPLACEMENT "Monthly CSS Tax"
            SalaryLine."Total CSS Tax Recorded" := SalLineEng."CSS Tax"; //WDCREGUL REMPLACEMENT "Monthly CSS Tax"
            SalaryLine."Total taxable rec." := SalLineEng."Real taxable";
            SalaryLine."Total taxes rec." := SalLineEng."Taxe (Month)";
            //>-Calcul Impot Rammené au nombre de jour--------------------------------------------------
            SalaryLine."Cumulative Taxable Salary" := SalLineEng."Taxable salary";
            SalaryLine."Recorded Pay Days" := SalLineEng."Paied days" + SalLineEng."Public Holidays";
            HeureJourTravail.RESET;
            HeureJourTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
            HeureJourTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
            HeureJourTravail.SETFILTER("Payment Month", '<>%1', SalaryLine.Month);
            HeureJourTravail.SETFILTER("Payment Year", '%1', SalaryLine.Year);
            IF ParamRessHum."Activate fortnightly regime" THEN
                IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN BEGIN
                    HeureJourTravail.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                END;
            HeureJourTravail.CALCSUMS("Hours Number", "Line amount", "Days Number", "Pulic Holiday Days");
            IF SalaryLine."Employee type".AsInteger() = 0 THEN BEGIN
                SalaryLine."Recorded Pay Days" := HeureJourTravail."Days Number" + SalLineEng."Public Holidays";//+ROUND(SalLineEng."Jour CongéAPEM"/7,0.1,'>');
                                                                                                                // message('%1',ROUND(SalLineEng."Jour CongéAPEM"/7,0.1,'>'));
            END;
            SalaryLine."Days Period Number" := NbrJourPaye + SalaryLine."Recorded Pay Days";
            //<<          -Calcul Impot Rammené au nombre de jour-----------------------------------------------------------
            SalaryLine."Rec. payments" := 0;
            SalLineEngTmp.RESET;
            SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Taxable);
            SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEngTmp.Setrange(Year, SalaryLine.Year);
            SalLineEngTmp.Setrange(Taxable, TRUE);
            SalLineEngTmp.SETFILTER(Month, '<%1', SalLineEngTmp.month::"13th Salary");
            SalLineEngTmp.CALCSUMS("Real taxable", "Taxe (Month)", "Taxable salary");

            //***************************************************  ************************************
            //>>6  --Regul d'impôt
            //***************************************************  ************************************
            IF SalaryHeader."Tax Regulation" THEN BEGIN
                //--> Calcul de l'imposable réel par an
                SalLineEng.RESET;
                SalLineEng.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Taxable);
                SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
                SalLineEng.Setrange(Year, SalaryLine.Year);
                SalLineEng.CALCSUMS("Real taxable", "Taxe (Month)");
                SalaryLine."Total taxable rec." := SalLineEng."Real taxable";
                SalaryLine."Total taxes rec." := SalLineEng."Taxe (Month)";
                SalaryLine."Rec. payments" := 0;
                SalLineEngTmp.RESET;
                SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Taxable);
                SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
                SalLineEngTmp.Setrange(Year, SalaryLine.Year);
                SalLineEngTmp.SETFILTER(Month, '<%1', SalLineEngTmp.month::"13th Salary");
                SalLineEngTmp.CALCSUMS("Real taxable", "Taxe (Month)");
                SalaryLine."Rec. payments" := SalLineEngTmp.COUNT;
            END;
            //***************************************************  ************************************
            //<<  --Regul d'impôt
            //***************************************************  ************************************
            SalLineEngTmp.RESET;
            SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Taxable);
            SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEngTmp.Setrange(Year, SalaryLine.Year);
            SalLineEngTmp.SETFILTER(Month, '<%1', SalLineEngTmp.month::"13th Salary");
            IF SalLineEngTmp.FINDSET THEN
                SalaryLine."Rec. payments" := SalLineEngTmp.COUNT;
            DEDUCIMPOT := 0;
            IF SalLineEngTmp.FINDFIRST THEN
                REPEAT
                    DEDUCIMPOT := DEDUCIMPOT + SalLineEngTmp."Deduction Family chief" +
                                  SalLineEngTmp."Deduction Loaded child" + SalLineEngTmp."Deduction Prof. expenses"
                UNTIL SalLineEngTmp.NEXT = 0;
            //--> Calcul de l'Imposable Réel
            EmploymentContract.RESET;
            Employee.GET(SalaryLine."Employee No.");
            EmploymentContract.GET(Employee."Emplymt. Contract Code");
            MntAssVie := 0;
            RecAssVie.RESET;
            RecAssVie.SETRANGE(Year, SalaryLine.Year);
            RecAssVie.SETRANGE("Employee No.", SalaryLine."Employee No.");
            IF RecAssVie.FINDFIRST THEN
                REPEAT
                    MntAssVie := MntAssVie + RecAssVie.Amount;
                UNTIL RecAssVie.NEXT = 0;

            MontCapitalReinvesti := 0;
            CASE Sim OF
                0:
                    BEGIN
                        CASE ParamRessHum."Monthes Number".AsInteger() OF
                            0:
                                nbr := EmploymentContract."Regular payments";
                            1:
                                nbr := EmploymentContract."Temporary payments";
                            2:
                                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
                        END;
                        SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" * nbr,
                                                                               ParamCpta."Amount Rounding Precision");
                    END;
                1, 2:
                    BEGIN
                        nbr := 12;
                        EmploymentContract.RESET;
                        Employee.GET(SalaryLine."Employee No.");
                        EmploymentContract.GET(Employee."Emplymt. Contract Code");
                        CASE ParamRessHum."Monthes Number".AsInteger() OF
                            0:
                                nbr := EmploymentContract."Regular payments";
                            1:
                                nbr := EmploymentContract."Temporary payments";
                            2:
                                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
                        END;
                        CASE ParamRessHum."Regulation Taxe".AsInteger() OF
                            0:
                                BEGIN
                                    IF SalaryLine.Month.AsInteger() < 12 THEN BEGIN
                                        IF (Employee."Working Relationship".AsInteger() = 2) OR (Employee."Working Relationship".AsInteger() = 3) THEN BEGIN
                                            IF nbr - SalaryLine."Rec. payments" - 1 > 0 THEN
                                                SalaryLine."Real taxable (Year)" := ROUND((SalaryLine."Real taxable" +
                                                                                   (SalaryLine."Real taxable" * (nbr - SalaryLine."Rec. payments" - 1)))
                                                                                   + SalaryLine."Total taxable rec."
                                                                                   , ParamCpta."Amount Rounding Precision")
                                            ELSE
                                                SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" +
                                                                                   +SalaryLine."Total taxable rec."
                                                                                   , ParamCpta."Amount Rounding Precision")
                                        END ELSE
                                            SalaryLine."Real taxable (Year)" := ROUND(((SalaryLine."Real taxable" * (nbr)))
                                                                               , ParamCpta."Amount Rounding Precision");
                                    END
                                    ELSE
                                        SalaryLine."Real taxable (Year)" := ROUND((SalaryLine."Real taxable" +
                                                         ((SalaryLine."Real taxable PR")//- SalaryLine."Deduction Family chief"
                                                          * (nbr - SalaryLine."Rec. payments")))
                                                         + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                                    IF SalaryLine.Month.AsInteger() < 12 THEN
                                        SalaryLine."Real Taxable PR (Year)" := ROUND((SalaryLine."Real taxable PR" +
                                                                            (SalaryLine."Real taxable PR" * (nbr - SalaryLine."Rec. payments" - 1)))
                                                                            + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        SalaryLine."Real Taxable PR (Year)" := ROUND((
                                                                            ((SalaryLine."Real taxable PR")//-SalaryLine."Deduction Family chief"
                                                                             * (nbr - SalaryLine."Rec. payments")))
                                                                            + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                                END;
                            1:
                                BEGIN

                                    //>>
                                    //@@@@@@@@@@@@@@@@@@ Spécifique STA
                                    SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" * nbr,
                                                                                       ParamCpta."Amount Rounding Precision");
                                END;

                            // AGA IMPOT STTAIQUE
                            2:
                                BEGIN

                                    SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" * nbr,
                                                                                   ParamCpta."Amount Rounding Precision");

                                    SalaryLine."Real Taxable PR (Year)" := ROUND(SalaryLine."Real taxable PR" * nbr,
                                                                                   ParamCpta."Amount Rounding Precision")
                                END;

                        //>>          -Calcul Impot Rammené au nombre de jour-------------------------------------------------------
                        //<<5          -Calcul Impot Rammené au nombre de jour-------------------------------------------------------
                        END;
                    END;
            END;

            //*****************************************END 10/03/2009
            // Calcul Impôt Annuel
            //>>
            //
            TableauAmortissementPret.RESET;
            TableauAmortissementPret.SETRANGE("Employee No.", SalaryLine."Employee No.");
            TableauAmortissementPret.SETRANGE(Year, SalaryLine.Year);
            TableauAmortissementPret.CALCSUMS("Annual Interest");
            IF TableauAmortissementPret.FINDSET THEN
                MontantPretAmmortissement := TableauAmortissementPret."Annual Interest";
            SalaryLine."Real taxable (Year)" := SalaryLine."Real taxable (Year)" - MntAssVie - MontCapitalReinvesti - MontantPretAmmortissement;

            //>>------------------------------------------------------------------------------------LOI IMPÔT 2014 -------------------------------
            //>  -Loi calcul impot 2014
            ParamGrH.GET();
            TaxesMgmt.CalcAnnualTaxes(SalaryLine);
            //>>
            CalcAnnualTaxesCSS(SalaryLine);
            //<<
            //END;
            //***************************************************  ************************************
            //>>  --Regul d'impôt
            //***************************************************  ************************************
            IF SalaryHeader."Tax Regulation" THEN BEGIN
                SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                //***************************************************  ************************************
            END;
            //***************************************************  ************************************
            //<<   --Regul d'impôt
            //***************************************************  ************************************
            //<<  -Loi calcul impot 2014
            //<<------------------------------------------------------------------------------------LOI IMPÔT 2014 -------------------------------

            IF (SalaryLine.Month.AsInteger() > 12) AND (Sim <> 2) THEN BEGIN
                SalaryLine."Deduction Family chief" := 0;
                SalaryLine."Deduction Loaded child" := 0;
            END;
            CalcImpotMensuel(SalaryLine, nbr); //WDCREGUL
                                               // Calcul Impôt mensuel
            IF Sim = 0 THEN BEGIN
                SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" / nbr), ParamCpta."Amount Rounding Precision");
                SalaryLine."Monthly CSS Tax" := ROUND((SalaryLine."Annual CSS Tax" / nbr), ParamCpta."Amount Rounding Precision");
            END;
        END;
        //>>WDCREGUL Régul Impôt
        IF SalaryHeader."Tax Regulation" THEN BEGIN
            SalaryLineEnreg.RESET;
            SalaryLineEnreg.SETCURRENTKEY(Year, "Employee No.", "No.");
            SalaryLineEnreg.SETRANGE(Year, SalaryLine.Year);
            SalaryLineEnreg.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalaryLineEnreg.CALCSUMS("Taxable salary", "Real taxable", "Taxe (Month)", "CSS Tax");  //WDCREGUL REMPLACEMENT "Monthly CSS Tax"
            SalaryLine."Total CSS Tax Recorded" := SalaryLineEnreg."CSS Tax"; //WDCREGUL REMPLACEMENT "Monthly CSS Tax"
            SalaryLine."Total taxable rec." := SalaryLineEnreg."Real taxable";
            SalaryLine."Total taxes rec." := SalaryLineEnreg."Taxe (Month)";
            SalaryLine."Rec. payments" := SalaryLineEnreg.COUNT;
            SalaryLine."Imposable Annuel Regul" := SalaryLineEnreg."Taxable salary" + SalaryLine."Taxable salary";
            IF SalaryLine."Rec. payments" < FacteurMois - 1 THEN
                SalaryLine."Imposable Annuel Regul" := (SalaryLine."Imposable Annuel Regul" / (SalaryLine."Rec. payments" + 1)) * FacteurMois;
            IF (SalaryLine."Imposable Annuel Regul" * ParamRessHum."Pourcent professional expenses") < ParamRessHum."Professional Expenses Charges" THEN BEGIN
                SalaryLine."Real taxable (Year)" := SalaryLine."Imposable Annuel Regul" -
                (SalaryLine."Imposable Annuel Regul" * ParamRessHum."Pourcent professional expenses");
            END ELSE BEGIN
                SalaryLine."Real taxable (Year)" := SalaryLine."Imposable Annuel Regul" - ParamRessHum."Professional Expenses Charges";
            END;
            Employee.CALCFIELDS("Deduction Loaded child");
            IF Employee."Family chief" THEN
                SalaryLine."Real taxable (Year)" := SalaryLine."Real taxable (Year)" - ParamRessHum."Deduction for Familly Chief" -
                -Employee."Deduction Loaded child";
        END;
        //>>WDCREGUL Régul impot
        IF EmploymentContract."Inclusive ratio" <> 0 THEN
            SalaryLine."Taxe (Month)" := (SalaryLine."Gross Salary" * EmploymentContract."Inclusive ratio") / 100;
        IF EmploymentContract."Inclusive ratio" <> 0 THEN
            SalaryLine."Monthly CSS Tax" := (SalaryLine."Gross Salary" * (EmploymentContract."Inclusive ratio" + 1)) / 100;
        //>>WDCREGUL
        IF SalaryHeader."Tax Regulation" THEN BEGIN
            CalcAnnualTaxesregul(SalaryLine);
            CLEAR(NombreMois);
            CLEAR(RecSalaryLine);
            RecSalaryLine.SETRANGE("Employee No.", SalaryLine."Employee No.");
            RecSalaryLine.SETRANGE(Year, SalaryLine.Year);
            IF RecSalaryLine.FINDSET THEN
                REPEAT
                    NombreMois += 1;
                UNTIL RecSalaryLine.NEXT = 0;
            NombreMois := NombreMois + 1;
            IF NombreMois >= 14 THEN
                FacteurMois := nbr ELSE
                FacteurMois := NombreMois;
            IF SalaryLine."Rec. payments" < FacteurMois - 1 THEN BEGIN
                SalaryLine."Taxe (Month)" := (SalaryLine."Taxe (Year)" / FacteurMois) * (SalaryLine."Rec. payments" + 1) - SalaryLine."Total taxes rec.";
                SalaryLine."Monthly CSS Tax" := (SalaryLine."Annual CSS Tax" / FacteurMois) * (SalaryLine."Rec. payments" + 1) - SalaryLine."Total CSS Tax Recorded";
            END ELSE BEGIN
                SalaryLine."Taxe (Month)" := SalaryLine."Taxe (Year)" - SalaryLine."Total taxes rec.";
                SalaryLine."Monthly CSS Tax" := SalaryLine."Annual CSS Tax" - SalaryLine."Total CSS Tax Recorded";
                SalaryLine."CSS Tax" := SalaryLine."Annual CSS Tax" - SalaryLine."Total CSS Tax Recorded";
            END;
            IF SalaryLine."Taxe (Month)" < 0 THEN
                SalaryLine."Taxe (Month)" := 0; //WDC
            IF SalaryLine."Monthly CSS Tax" < 0 THEN
                SalaryLine."Monthly CSS Tax" := 0;
        END;
        //<<WDCREGUL
        CLEAR(SocialContriubtion);
        SocialContriubtion.SETRANGE("No.", SalaryLine."No.");
        SocialContriubtion.SETRANGE("Employee No.", SalaryLine."Employee No.");
        SocialContriubtion.SETRANGE("Basis of calculation", 3);
        IF SocialContriubtion.FINDSET THEN
            REPEAT
                IF SocialContriubtion."Social Contribution" = 'ASS' THEN
                    SalaryLine.Assurance := SocialContriubtion."Employee's part";
                IF SocialContriubtion."Social Contribution" = 'BUS' THEN
                    SalaryLine.Bus := SocialContriubtion."Employee's part";
                IF SocialContriubtion."Social Contribution" = 'SHEMS' THEN
                    SalaryLine.Shems := SocialContriubtion."Employee's part";
                IF SocialContriubtion."Social Contribution" = 'TEL' THEN
                    SalaryLine.Phone := SocialContriubtion."Employee's part";
                IF SocialContriubtion."Social Contribution" = 'VOIT' THEN
                    SalaryLine.Car := SocialContriubtion."Employee's part";
                IF SocialContriubtion."Social Contribution" = 'DSAM' THEN
                    SalaryLine.DSAM := SocialContriubtion."Employee's part";
            UNTIL SocialContriubtion.NEXT = 0;
        //<<WDC02

        Gemployee.GET(SalaryLine."Employee No.");//WDC01
        SalaryLine."Net salary" := ROUND(SalaryLine."Gross Salary"
                                 - SalaryLine."Non Taxable Soc. Contrib."
                                 + SalaryLine."Taxable Indem. PR (Not Gross)"
                                 + SalaryLine."Non Taxable indemnities"
                                 + SalaryLine."Mission expenses"
                                 - ROUND(SalaryLine."CSS Tax")
                                 - IndConvent
                                 - SalaryLine."Taxable Soc. Contrib."
                                 - ROUND(SalaryLine."Taxe (Month)")
                                 //<<
                                 //<<WDC02
                                 - SalaryLine.Assurance
                                 - SalaryLine.Bus
                                 - SalaryLine.Phone
                                 - SalaryLine.Shems
                                 - SalaryLine."Retirement plus"  //WDC02
                                 - SalaryLine.Car
                                 - SalaryLine.DSAM
                                  //>>WDC02
                                  , ParamCpta."Amount Rounding Precision");

        //<<

        //CALCUL INDEMNITE AVENTAGE EN NATURE
        Ind.RESET;
        Ind.SETCURRENTKEY("No.", "Employee No.", Indemnity, "Benefit in Kind");
        Ind.SETRANGE("No.", SalaryLine."No.");
        Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
        Ind.SETRANGE("Benefit in Kind", TRUE);
        Ind.CALCSUMS("Real Amount");
        SalaryLine."Non Taxable indemnities" := ROUND(Ind."Real Amount", ParamCpta."Amount Rounding Precision");
        IF Sim = 1 THEN
            IF SalaryHeader."Disable loan calculation" = FALSE THEN
                "Mgmt.ofLoansandAdvances".CreateRepaymentLine(SalaryLine);


        //>>
        SalaryLine.CALCFIELDS("Indem. Not Tax. Not Contrib.");
        //<<

        //>>
        //----ARRONDI-------------------------------------ANCIEN--------------------

        SalaryLine."Net salary cashed" := SalaryLine."Net salary"
                                                       - SalaryLine.Loans
                                                       - SalaryLine.Advances
                                                       + Ind."Real Amount"
                                                       - SalaryLine."Amount retained cash FS" +
                                                       SalaryLine."Indem. Not Tax. Not Contrib.";


        //<<

        IF SalaryLine."Net salary cashed" < 0 THEN
            MESSAGE(Text001, SalaryLine."Employee No.");

        //======================= END ARRONDISSEMENT

        IF (SalaryLine."Taxable salary" = 0) AND (SalaryLine."Net salary" <= 0) AND (Sim = 1) THEN
            MgmtSalary2.DeleteLine(SalaryLine)
        ELSE
            SalaryLine.MODIFY;
        EXIT(SalaryLine."Net salary");
    end;


    procedure CalculateLineHoliday(var SalaryLine: Record "WDC Salary Lines"; "SolderDroitCongé": Boolean; Sim: Option Simulation,Real,Prime; nbjsolder: Decimal; Pinverse: Boolean): Decimal
    var
        SalaryHeader: Record "WDC Salary Header";
        Ind: Record "WDC Indemnities";
        ParamRessHum: Record "Human Resources Setup";
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        Employee: Record Employee;
        SliceImposition: Record "WDC Slices of imposition";
        temp: Decimal;
        tmp: Decimal;
        tmp1: Decimal;
        Cot: Record "WDC Default Soc. Contribution";
        TableauAmortissementPret: Record "WDC Tablau amortissement prêt";
        ChefFamille: Decimal;
        nbr: Decimal;
        TotImposable: Decimal;
        NbreHJ: Decimal;
        SoldeCong: Decimal;
        bonus: Decimal;
        EmployeAbscence: Record "WDC Employee's days off Entry";
        SalLineEng: Record "WDC Salary Lines";
        EntEng: Record "WDC Salary Header";
        LigneTravail: Record "WDC Overcharge of hour cost";
        NbrPaieEmployee: Decimal;
        MontantPretAmmortissement: Decimal;
        LigneTravailEnreg: Record "WDC Overtime hours recorded m";
        WorkedD: Decimal;
        "Mgmt.ofLoansandAdvances": Codeunit "WDC Mgmt. Loans & Adv";
        droitconge: Record "WDC Employee's days off Entry";
        SalLineEngTmp: Record "WDC Salary Lines";
        MntInd: Decimal;
        DefaultIndemnitiesTmp: Record "WDC Default Indemnities";
        SoldeReport: Decimal;
        SoldeReport1: Decimal;
        EMP1: Record Employee;
        LigneAbsence: Record "WDC Employee's days off Entry";
        AbsEmp: Decimal;
        GNbJourConge: Decimal;
        GNbHeurConge: Decimal;
    begin
        SalaryHeader.GET(SalaryLine."No.");
        ParamRessHum.GET();
        EmploymentContract.RESET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        EmploymentContract.CalcFields("Employee type");
        IF RegimeWork.GET(EmploymentContract."Work Regime") THEN BEGIN
            CASE EmploymentContract."Employee type" OF
                EmploymentContract."Employee type"::"Hour based":
                    NbreHJ := RegimeWork."Work Hours per month";
                EmploymentContract."Employee type"::"Month based":
                    NbreHJ := RegimeWork."Worked Day Per Month";
            END;
        END;

        SoldeCong := 0;
        EmployeAbscence.RESET;
        EmployeAbscence.SETFILTER(EmployeAbscence."Employee No.", Employee."No.");
        EmployeAbscence.SETFILTER(EmployeAbscence."To Date", '<=%1', SalaryHeaders."Posting Date");
        EmployeAbscence.SETFILTER(EmployeAbscence."Line type", '<=2');
        IF EmployeAbscence.FINDSET THEN BEGIN
            REPEAT
            BEGIN
                IF EmployeAbscence."Line type".AsInteger() <> 2 THEN
                    SoldeCong += EmployeAbscence."Quantity (Days)"
                ELSE
                    SoldeCong := SoldeCong - EmployeAbscence."Quantity (Days)";
            END;
            UNTIL (EmployeAbscence.NEXT = 0);
        END;


        Employee.CALCFIELDS("Days off =", "Gross Salary");
        CASE Employee."Employee type" OF
            Employee."Employee type"::"Hour based":
                BEGIN
                    SalaryLine."Gross Salary" := ROUND((((Employee."Gross Salary" + Employee."Basis salary") * NbreHJ) / 20) * Employee."Days off =", 0.001);
                END;
            Employee."Employee type"::"Month based":
                BEGIN
                    SalaryLine."Gross Salary" := ROUND(((Employee."Gross Salary" + Employee."Basis salary") / NbreHJ) * SoldeCong, 0.001);
                END;
        END;

        // --> Calc Cotisation Social
        MgmtSalary2.CalcCotisationSocial1(SalaryLine);
        //--> Calcul du salaire imposable
        MgmtSalary2.CalcAllTaxe(SalaryLine);
        //A AJOUTER CONTROLE NON IMPOSABLE
        Gemployee.GET(SalaryLine."Employee No.");//WDC01
        IF EmploymentContract.Taxable THEN
            SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib." +
                                               SalaryLine."Taxable indemnities(Not Gross)"
                                                          - SalaryLine."Retirement plus", ParamCpta."Amount Rounding Precision");     //WDC01

        IF Sim < 2 THEN
            IF EmploymentContract.Taxable THEN
                SalaryLine."Taxable salary PR" := ROUND(SalaryLine."Gross Salary PR" - SalaryLine."Non Taxable Soc. Contrib. PR" +
                                                   SalaryLine."Taxable indem. PR (Not Gross)"
                                                             , ParamCpta."Amount Rounding Precision");
        // Calc Cotisation Social
        MgmtSalary2.CalcCotisationSocial2(SalaryLine);
        //--> Calcul de l'imposable réel
        IF EmploymentContract.Taxable THEN BEGIN
            IF NOT Employee."Family chief" THEN BEGIN
                SalaryLine."Deduction Family chief" := 0;
                SalaryLine."Deduction Loaded child" := 0;
            END;
            SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Pourcent professional expenses"
                                                       * SalaryLine."Taxable salary");
            //>>
            //******(1)********************Recherche sur les paie enregistr² *********************************
            nbr := 12;
            ImposEnreg := 0;
            NbrPaie := 0;
            FraisEnreg := 0;
            RecGSalayEnr.RESET;
            RecGSalayEnr.SETCURRENTKEY(Year, Month, "Employee No.", "No.");
            RecGSalayEnr.SETRANGE("Employee No.", SalaryLine."Employee No.");
            RecGSalayEnr.SETRANGE(Year, SalaryLine.Year);
            IF RecGSalayEnr.FINDSET THEN
                REPEAT
                    IF RecGSalayEnr.Month.AsInteger() < nbr THEN
                        ImposEnreg := ImposEnreg + RecGSalayEnr."Taxable salary";      //Somme imposable Enregistr²
                    FraisEnreg := FraisEnreg + RecGSalayEnr."Deduction Prof. expenses"; //Somme Frais prof Enregistr²
                    IF RecGSalayEnr.Month.AsInteger() < nbr THEN
                        NbrPaie := NbrPaie + 1;
                UNTIL RecGSalayEnr.NEXT = 0;
            //******(2)********************Si Frais prof enregistr² >= 2000 alors frais prof = zero *********************************
            //@@@@@@@@@@@@@@@@@@   Condition 1
            IF FraisEnreg >= ParamRessHum."Professional Expenses Charges" THEN BEGIN
                SalaryLine."Deduction Prof. expenses" := 0;
            END ELSE BEGIN
                //@@@@@@@@@@@@@@@@@@   Condition 2
                //******(3)********************Si Frais prof annuel <=2000 < alors **********************************************************
                IF ROUND(ParamRessHum."Pourcent professional expenses" * (SalaryLine."Taxable salary" * (nbr - NbrPaie) + ImposEnreg)) <=
        ParamRessHum."Professional Expenses Charges" THEN BEGIN
                    IF ROUND(ParamRessHum."Pourcent professional expenses" * SalaryLine."Taxable salary") >= ROUND(ParamRessHum.
                                                                                        "Professional Expenses Charges" / nbr) THEN
                        SalaryLine."Deduction Prof. expenses" := ROUND((ParamRessHum."Professional Expenses Charges" / nbr) * (NbrPaie + 1) - FraisEnreg)
                    ELSE
                        SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Pourcent professional expenses"
                                                                        * SalaryLine."Taxable salary");
                    //@@@@@@@@@@@@@@@@@@   Condition 3
                    //******(3)********************Si Frais prof annuel <=2000 et avec l'imposable en cour sera >=2000 *********************************
                    //*************************
                END ELSE BEGIN
                    SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Professional Expenses Charges" - FraisEnreg) / (nbr - NbrPaie);
                END;
            END;
            //<<
            IF SalaryLine.Month.AsInteger() < 12 THEN
                SalaryLine."Real taxable" := ROUND(SalaryLine."Taxable salary"
                                                         - SalaryLine."Deduction Family chief"
                                                         - SalaryLine."Deduction Loaded child"
                                                         - SalaryLine."Deduction Prof. expenses", ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLine."Real taxable" := ROUND(SalaryLine."Taxable salary"
                                                         - SalaryLine."Deduction Prof. expenses", ParamCpta."Amount Rounding Precision");
            IF (SalaryLine.Month.AsInteger() < 12) OR (Sim = 2) THEN
                SalaryLine."Real taxable PR" := ROUND(SalaryLine."Taxable salary PR"
                                                         - SalaryLine."Deduction Family chief"
                                                         - SalaryLine."Deduction Loaded child"
                                                         - ROUND(SalaryLine."Taxable salary PR" * ParamRessHum."Pourcent professional expenses" / 100
                                                         , ParamCpta."Amount Rounding Precision"), ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLine."Real taxable PR" := ROUND(SalaryLine."Taxable salary PR"
                                                         - ROUND(SalaryLine."Taxable salary PR" * ParamRessHum."Pourcent professional expenses" / 100
                                                         , ParamCpta."Amount Rounding Precision"), ParamCpta."Amount Rounding Precision");
        END;

        //IMPOSABLE CONGE************************************
        SalaryLine."Annual taxable vacation salary" := 0;
        SalaryLine."Vacation Tax. bracket Rate" := 0;
        CASE SalaryLine."Employee type".AsInteger() OF
            0:
                BEGIN
                    IF GNbHeurConge > 0 THEN
                        SalaryLine."Annual taxable vacation salary" := ROUND(
                        (SalaryLine."Taxable salary" / GNbHeurConge) * GNbHeure * 13, ParamCpta."Amount Rounding Precision")
                END;
            1:
                BEGIN
                    IF GNbJourConge > 0 THEN
                        SalaryLine."Annual taxable vacation salary" := ROUND(
                        (SalaryLine."Taxable salary" / GNbJourConge) * GNbJour * 13, ParamCpta."Amount Rounding Precision")
                END;
        END;
        IF SalaryLine."Deduction Family chief" > 0 THEN
            SalaryLine."Annual taxable vacation salary" := SalaryLine."Annual taxable vacation salary" - (SalaryLine."Deduction Family chief" * 12);
        IF SalaryLine."Deduction Loaded child" > 0 THEN
            SalaryLine."Annual taxable vacation salary" := SalaryLine."Annual taxable vacation salary" - (SalaryLine."Deduction Loaded child" * 12);
        SalaryLine."Annual taxable vacation salary" := SalaryLine."Annual taxable vacation salary" * 0.9;
        IF EmploymentContract.Taxable THEN
            IF EmploymentContract."Taxes Calculation Mode".AsInteger() = 0 THEN BEGIN
                SliceImposition.RESET;
                SliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                IF SliceImposition.FINDFIRST THEN
                    REPEAT
                        IF ((SalaryLine."Annual taxable vacation salary" > SliceImposition."Lower limit")
                          AND (SalaryLine."Annual taxable vacation salary" < SliceImposition."Superior limit")) THEN
                            SalaryLine."Vacation Tax. bracket Rate" := SliceImposition.Rate;
                    UNTIL SliceImposition.NEXT = 0;
            END;
        //FIN IMPOSABLE CONGE***************************************************
        //--> Calcul de l'imposable réel par an
        SalLineEng.RESET;
        SalLineEng.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Taxable);
        SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
        SalLineEng.Setrange(Year, SalaryLine.Year);
        SalLineEng.Setrange(Taxable, TRUE);
        SalLineEng.CALCSUMS("Real taxable", "Taxe (Month)", "Taxable salary");
        SalaryLine."Total taxable rec." := SalLineEng."Real taxable";
        SalaryLine."Total taxes rec." := SalLineEng."Taxe (Month)";
        SalaryLine."Rec. payments" := 0;
        SalLineEngTmp.RESET;
        SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Taxable);
        SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
        SalLineEngTmp.Setrange(Year, SalaryLine.Year);
        SalLineEngTmp.Setrange(Taxable, TRUE);
        SalLineEngTmp.SETFILTER(Month, '<%1', SalLineEngTmp.month::"13th Salary");

        //***************************************************  ************************************
        //>>  --Regul d'impôt
        //***************************************************  ************************************
        IF SalaryHeader."Tax Regulation" THEN BEGIN
            //--> Calcul de l'imposable réel par an
            SalLineEng.RESET;
            SalLineEng.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Taxable);
            SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEng.Setrange(Year, SalaryLine.Year);

            SalLineEng.CALCSUMS("Real taxable", "Taxe (Month)");
            SalaryLine."Total taxable rec." := SalLineEng."Real taxable";
            SalaryLine."Total taxes rec." := SalLineEng."Taxe (Month)";
            SalaryLine."Rec. payments" := 0;

            SalLineEngTmp.RESET;
            SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Taxable);
            SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEngTmp.Setrange(Year, SalaryLine.Year);

            SalLineEngTmp.SETFILTER(Month, '<%1', SalLineEngTmp.month::"13th Salary");
            SalLineEngTmp.CALCSUMS("Real taxable", "Taxe (Month)");
            SalaryLine."Rec. payments" := SalLineEngTmp.COUNT;
        END;
        //***************************************************  ************************************
        //<<  --Regul d'impôt
        //***************************************************  ************************************
        //--> Calcul de l'Imposable Réel
        // Calcul Impôt Annuel
        SalaryLine."Annual taxable vacation salary" := SalaryLine."Real taxable" * nbr;
        //>>------------------------------------------------------------------------------------LOI IMPÔT 2014 -------------------------------
        //>>  -Loi calcul impot 2014
        ParamGrH.GET();
        IF ParamGrH."Active IRPP Ceiling" THEN BEGIN
            BaremeCalculImpot := FctGetSbaseIndemExonore(SalaryLine."No.", SalaryLine."Employee No.");
            BaremeCalculImpotApCNSS := BaremeCalculImpot - (BaremeCalculImpot * 9.68 / 100);
            BaremeCalculImpotApFraisProf := BaremeCalculImpotApCNSS - (BaremeCalculImpotApCNSS * 0.1)
                                                      - SalaryLine."Deduction Loaded child"
                                                      - SalaryLine."Deduction Family chief";
        END;
        //
        SalLineEngTmp.RESET;
        SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.");
        SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
        SalLineEngTmp.Setrange(Year, SalaryLine.Year);
        SalLineEngTmp.SETRANGE(Taxable, TRUE);
        SalLineEngTmp.SETFILTER(Month, '<%1', SalLineEngTmp.month::"13th Salary");
        IF SalLineEngTmp.FINDSET THEN
            SalLineEngTmp.CALCSUMS("Real taxable");
        TotImposable := SalLineEngTmp."Real taxable";
        NbrPaieEmployee := EmploymentContract."Regular payments";
        SalaryLine."Real taxable (Year)" := TotImposable + (SalaryLine."Real taxable" * (NbrPaieEmployee - SalaryLine."Rec. payments"));

        TableauAmortissementPret.RESET;
        TableauAmortissementPret.SETRANGE("Employee No.", SalaryLine."Employee No.");
        TableauAmortissementPret.SETRANGE(year, SalaryLine.Year);
        TableauAmortissementPret.CALCSUMS("Annual Interest");
        IF TableauAmortissementPret.FINDSET THEN
            MontantPretAmmortissement := TableauAmortissementPret."Annual Interest";


        SalaryLine."Real taxable (Year)" := SalaryLine."Real taxable (Year)" - MntAssVie - MontCapitalReinvesti - MontantPretAmmortissement;
        IF (BaremeCalculImpotApFraisProf * nbr) >= (ParamGrH."Income Tax Calculation Ceiling") THEN BEGIN
            TaxesMgmt.CalcAnnualTaxes(SalaryLine);
        END ELSE BEGIN
            TaxesMgmt.CalcAnnualTaxes(SalaryLine);
        END;
        //<<  -Loi calcul impot 2014
        //<<------------------------------------------------------------------------------------LOI IMPÔT 2014 -------------------------------


        //***************************************************  ************************************
        //>> --Regul d'impôt
        //***************************************************  ************************************
        IF SalaryHeader."Tax Regulation" THEN BEGIN
            SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
            //***************************************************  ************************************
        END;
        //***************************************************  ************************************
        //<<  --Regul d'impôt
        //***************************************************  ************************************

        IF (SalaryLine.Month.AsInteger() > 12) AND (Sim <> 2) THEN BEGIN
            SalaryLine."Deduction Family chief" := 0;
            SalaryLine."Deduction Loaded child" := 0;
        END;
        // Calcul Impôt mensuel

        //ARRONDI AU DINAR SUP

        IF SalaryLine."Rec. payments" < 12 THEN
            SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" - SalaryLine."Total taxes rec.")
                                                         / (NbrPaieEmployee - SalaryLine."Rec. payments")
                                                          , ParamCpta."Amount Rounding Precision")
        ELSE
            SalaryLine."Taxe (Month)" := (SalaryLine."Taxe (Year)" - SalaryLine."Total taxes rec.");
        IF SalaryLine."Taxe (Month)" < 0 THEN
            SalaryLine."Taxe (Month)" := 0;



        //***************************************************  ************************************
        //>> --Regul d'impôt
        //***************************************************  ************************************
        IF SalaryHeader."Tax Regulation" THEN BEGIN
            SalaryLine."Taxe (Month)" := ROUND(SalaryLine."Taxe (Year)" - SalaryLine."Total taxes rec.", ParamCpta."Amount Rounding Precision");
            IF SalaryLine."Taxe (Month)" < 0 THEN
                SalaryLine."Taxe (Month)" := 0;
        END;

        //>>
        IF EmploymentContract."Inclusive ratio" <> 0 THEN
            SalaryLine."Taxe (Month)" := (SalaryLine."Gross Salary" * EmploymentContract."Inclusive ratio") / 100;
        //<<
        //***************************************************  ************************************
        //<<  --Regul d'impôt
        //***************************************************  ************************************
        SalaryLine."Net salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib." +
                                   SalaryLine."Taxable Indem. PR (Not Gross)"
                                 + SalaryLine."Non Taxable indemnities"
                                 + SalaryLine."Mission expenses"
                                 - ROUND(SalaryLine."Taxe (Month)")
                                  , ParamCpta."Amount Rounding Precision");
        //>>

        IF Sim = 1 THEN
            "Mgmt.ofLoansandAdvances".CreateRepaymentLine(SalaryLine);
        SalaryLine."Net salary cashed" := ROUND(SalaryLine."Net salary"
                                                      - SalaryLine.Loans
                                                      - SalaryLine.Advances, ParamCpta."Amount Rounding Precision");
        //arrondissement
        //======================= END ARRONDISSEMENT
        IF (SalaryLine."Taxable salary" = 0) AND (SalaryLine."Net salary" <= 0) THEN
            MgmtSalary2.DeleteLine(SalaryLine)
        ELSE
            SalaryLine.MODIFY;
        EXIT(SalaryLine."Net salary");
    end;

    procedure PaieInverseFeuilleCalcul(var LigneSalaire: Record "WDC Salary Lines"; SBDepart: Decimal; NetVoulu: Decimal; Sim: Option Simulation,Real; PaieInverse: Boolean)
    var
        Empl: Record Employee;
        Line: Record "WDC Salary Lines";
        Ecart: Decimal;
        w: Dialog;
        temp: Decimal;
        Indm: Record "WDC Indemnities";
        paramRSH: Record "Human Resources Setup";
        Def: Record "WDC Indemnity";
        Defaultindem: Record "WDC Default Indemnities";
        EmpContract: Record "Employment Contract";
        RegWork: Record "WDC work Regimes";
        FunctIndemAmount: Decimal;
        TEXT002: TextConst ENU = 'The new basis salary is less than the Basis Salary (Salary Grid) specified in the employee card.', FRA = 'Le nouveau salaire de base est inférieur au Salaire de Base(Grille de Salaire) renseigner au niveau de la fiche signalitique.';
        CurrentAmountComplement: Decimal;
        RHSetUp: Record "Human Resources Setup";
    begin
        ParamCpta.GET;
        paramRSH.GET();
        IF PaieInverse THEN
            w.OPEN('Procédure de calcul inverse en cours :\' +
                  '####################################1#\' +
                  'Salaire de base : ##################2#\' +
                  'Salaire net     : ##################3#')
        ELSE
            w.OPEN('Procédure de mise à jour des salaires :\');
        Line.SETRANGE("No.", LigneSalaire."No.");
        Line.SETRANGE("Employee No.", LigneSalaire."Employee No.");
        IF PaieInverse THEN BEGIN
            RHSetUp.GET();
            Line.SETRANGE("Paied days", RHSetUp."Worked days");
        END;
        IF Line.FINDFIRST THEN;

        SBDepart := Line."Basis salary";
        IF PaieInverse THEN
            NetVoulu := Line."Net salary";
        Defaultindem.RESET;
        Defaultindem.SETRANGE("Emplymt. Contract Code", Empl."Emplymt. Contract Code");
        Defaultindem.SETRANGE("Indemnity Code", paramRSH."Indem Salary Diff.");
        IF Defaultindem.FINDFIRST THEN BEGIN
            Defaultindem."Default amount" := 0;
            Defaultindem."Basis amount" := 0;
            Defaultindem.MODIFY;
        END;

        CalculateSalaryLine(Line, FALSE, 0, 0, TRUE);
        Ecart := CalculateSalaryLine(Line, FALSE, 0, 0, TRUE) - NetVoulu;
        Line.MODIFY;
        IF (Ecart < 0) THEN BEGIN
            //--> Cas 1 : Augmenter le Salaire de Base

            WHILE ((ABS(Ecart) >= 0) AND (Ecart <= 0)) DO BEGIN
                temp := CalculateSalaryLine(Line, FALSE, 0, 0, FALSE);
                Ecart := temp - NetVoulu;
                IF (ABS(Ecart) > 50) THEN
                    Line."Basis salary" := Line."Basis salary" + 20
                ELSE BEGIN
                    IF (ABS(Ecart) > 10) THEN
                        Line."Basis salary" := Line."Basis salary" + 10
                    ELSE BEGIN
                        IF (ABS(Ecart) > 2) THEN
                            Line."Basis salary" := Line."Basis salary" + 2
                        ELSE
                            IF (ABS(Ecart) > 1) THEN
                                Line."Basis salary" := Line."Basis salary" + 0.5

                            ELSE
                                Line."Basis salary" := Line."Basis salary" + 0.0005;
                    END;
                END;
                Line.MODIFY;
                IF PaieInverse THEN BEGIN
                    w.UPDATE(1, Line."No." + ' - ' + Line."Employee No." + ' : ' + Line.Name);
                    w.UPDATE(2, ROUND(Line."Basis salary", ParamCpta."Amount Rounding Precision"));
                    w.UPDATE(3, ROUND(temp, ParamCpta."Amount Rounding Precision"));
                END;
            END;
        END;
        IF (Ecart > 0) THEN BEGIN
            //--> Cas 2 : Diminuer le Salaire de Base

            WHILE ((ABS(Ecart) > 0.0) AND (Ecart >= 0)) DO BEGIN
                temp := CalculateSalaryLine(Line, FALSE, 0, 0, FALSE);
                Ecart := temp - NetVoulu;
                IF (ABS(Ecart) > 50) THEN
                    Line."Basis salary" := Line."Basis salary" - 20
                ELSE BEGIN
                    IF (ABS(Ecart) > 10) THEN
                        Line."Basis salary" := Line."Basis salary" - 10
                    ELSE BEGIN
                        IF (ABS(Ecart) > 2) THEN
                            Line."Basis salary" := Line."Basis salary" - 2
                        ELSE
                            IF (ABS(Ecart) > 1) THEN
                                Line."Basis salary" := Line."Basis salary" - 0.5

                            ELSE
                                Line."Basis salary" := Line."Basis salary" - 0.0005;
                    END;
                END;
                Line.MODIFY;
                IF PaieInverse THEN BEGIN
                    w.UPDATE(1, Line."No." + ' - ' + Line."Employee No." + ' : ' + Line.Name);
                    w.UPDATE(2, Line."Basis salary");
                    w.UPDATE(3, temp);
                END;
            END;
        END;
        IF Sim = 1 THEN BEGIN
            IF Line.Month = Line.Month::Prime THEN BEGIN
                IF Line."Basis salary" <> SBDepart THEN BEGIN
                    paramRSH.GET;
                    paramRSH.TESTFIELD("Indem Bonus diff.");
                    Indm.RESET;
                    Indm.SETFILTER("No.", Line."No.");
                    Indm.SETFILTER("Employee No.", Line."Employee No.");
                    Indm.SETFILTER(Indemnity, paramRSH."Indem Bonus diff.");
                    IF Indm.FINDFIRST THEN BEGIN
                        Indm."Base Amount" := Indm."Base Amount" - (Line."Basis salary" - SBDepart);
                        Indm."Real Amount" := Indm."Real Amount" - (Line."Basis salary" - SBDepart);
                        Indm.MODIFY;
                    END ELSE BEGIN
                        CLEAR(Def);
                        IF Def.GET(paramRSH."Indem Bonus diff.") THEN;
                        Def.TESTFIELD("Not Included in Bonus", FALSE);
                        Indm.INIT;
                        Indm."No." := Line."No.";
                        Indm."Employee No." := Line."Employee No.";
                        Indm.Indemnity := paramRSH."Indem Bonus diff.";
                        Indm."Employee Posting Group" := Line."Employee Posting Group";
                        Indm.Description := Def.Description;
                        Indm.Type := Def.Type;
                        Indm."Evaluation mode" := Def."Evaluation mode";
                        Indm."Base Amount" := (Line."Basis salary" - SBDepart);
                        Indm."Real Amount" := (Line."Basis salary" - SBDepart);
                        Indm.Rate := 100;
                        Indm."Global Dimension 1" := Line."Global Dimension 1";
                        Indm."Global Dimension 2" := Line."Global Dimension 2";
                        Indm."Real Amount PR" := 0;
                        Indm."Minimum value" := Def."Minimum value";
                        Indm."Not incl. Nat. Old Age Insur." := Def."Not incl. Nat. Old Age Insur.";
                        Indm."User ID" := USERID;
                        Indm.Rate := 100;
                        Indm."Indemnity Type" := Def."Indemnity Type";
                        Indm."Not Included in Accounting" := Def."Not Included in Accounting";

                        Indm."Amount Rounding Precision" := Def."Amount Rounding Precision";
                        Indm."Rounding Direction" := Def."Rounding Direction";
                        Indm.INSERT;
                    END;
                    Line."Basis salary" := SBDepart;
                    Line.MODIFY;
                END;
            END;
        END
        ELSE
          //
          BEGIN
            IF Empl.GET(Line."Employee No.") THEN BEGIN
                paramRSH.GET;
                EmpContract.GET(Empl."Emplymt. Contract Code");
                RegWork.GET(EmpContract."Work Regime");
                IF paramRSH."Activate Bonus Type" THEN BEGIN
                    Defaultindem.RESET;
                    Defaultindem.SETRANGE("Emplymt. Contract Code", Empl."Emplymt. Contract Code");
                    Defaultindem.SETRANGE("Indemnity Code", paramRSH."Indem Salary Diff.");
                    IF Defaultindem.FINDFIRST THEN
                        IF Empl."Employee type".AsInteger() = 1 THEN BEGIN
                            FunctIndemAmount := Line."Basis salary" - Empl."Basis salary";
                            Defaultindem."Default amount" := FunctIndemAmount;
                            Defaultindem."Basis amount" := FunctIndemAmount;
                            Defaultindem.MODIFY
                        END ELSE BEGIN
                            FunctIndemAmount := (Line."Basis salary" / RegWork."Work Hours per month" - Empl."Basis salary")
                                                   * RegWork."Work Hours per month";
                            Defaultindem."Default amount" := FunctIndemAmount;
                            Defaultindem."Basis amount" := FunctIndemAmount;
                            Defaultindem.MODIFY
                        END;
                END
                ELSE BEGIN
                    ParamCpta.GET();
                    IF Empl."Employee type".AsInteger() = 1 THEN BEGIN
                        Defaultindem.RESET;
                        Defaultindem.SETRANGE("Emplymt. Contract Code", LigneSalaire."Employee No.");
                        Defaultindem.SETRANGE("Indemnity Code", 'G11');
                        IF Defaultindem.FINDSET THEN BEGIN
                            CurrentAmountComplement := Defaultindem."Default amount" + ROUND((Line."Basis salary" - SBDepart), ParamCpta."Amount Rounding Precision");
                            EMP.GET(LigneSalaire."Employee No.");
                            IF NOT EMP."Hors Grille" THEN BEGIN
                                Defaultindem.DELETE;
                                Defaultindem.RESET;
                                Defaultindem.SETRANGE(Defaultindem."Evaluation mode", 0);
                                Defaultindem.SETRANGE("Emplymt. Contract Code", LigneSalaire."Employee No.");
                                IF Defaultindem.FINDSET THEN
                                    Defaultindem.VALIDATE("Default amount", Defaultindem."Default amount" + CurrentAmountComplement);
                            END
                            ELSE BEGIN
                                EMP."Basis salary" := Line."Basis salary";
                                EMP.MODIFY;
                                SBDepart := Line."Basis salary";
                            END;
                        END
                        ELSE BEGIN
                            IF NOT EMP."Hors Grille" THEN BEGIN
                                Defaultindem.RESET;
                                Defaultindem.INIT;
                                Defaultindem."Emplymt. Contract Code" := LigneSalaire."Employee No.";
                                Defaultindem.VALIDATE("Indemnity Code", 'G11');
                                Defaultindem.VALIDATE("Default amount", ROUND(SBDepart - Line."Basis salary", ParamCpta."Amount Rounding Precision"));
                                IF Defaultindem."Default amount" < 0 THEN
                                    Defaultindem.VALIDATE("Default amount", -Defaultindem."Default amount");
                                Defaultindem.INSERT;
                                COMMIT;
                            END
                            ELSE BEGIN
                                EMP."Basis salary" := Line."Basis salary";
                                EMP.MODIFY;
                                SBDepart := Line."Basis salary";
                            END;
                        END;
                    END;
                    IF NOT EMP."Hors Grille" THEN BEGIN
                        Indm.RESET;
                        Indm.SETRANGE("Employee No.", LigneSalaire."Employee No.");
                        Indm.SETRANGE(Indm."No.", Line."No.");
                        Indm.SETRANGE(Indm.Indemnity, 'G11');
                        IF Indm.FINDSET THEN BEGIN
                            Indm.VALIDATE("Base Amount", Defaultindem."Default amount");
                            Indm.VALIDATE("Real Amount", Defaultindem."Default amount");
                            Indm.MODIFY;
                        END
                        ELSE BEGIN
                            Indm.INIT;
                            Indm."Employee No." := LigneSalaire."Employee No.";
                            Indm."No." := LigneSalaire."No.";
                            Indm.VALIDATE(Indemnity, Defaultindem."Indemnity Code");
                            Indm.VALIDATE("Base Amount", Defaultindem."Default amount");
                            Indm.VALIDATE("Real Amount", Defaultindem."Default amount");
                            Indm.INSERT;
                        END;
                    END;
                END
            END
            ELSE BEGIN
                EMP."Basis salary" := Line."Basis salary";
                EMP.MODIFY;
                SBDepart := Line."Basis salary";
            END
        END;
        IF FunctIndemAmount < 0 THEN
            ERROR(TEXT002);
        IF PaieInverse THEN
            w.CLOSE;
        IF NOT PaieInverse THEN BEGIN
            Line."Basis salary" := SBDepart;
            Line.MODIFY;
            EMP.GET(Line."Employee No.");
            SalaryHeaders.GET(Line."No.");
            CreateSalaryLine(SalaryHeaders, EMP, 0);
        END;
        CalculateSalaryLine(Line, FALSE, 0, 0, FALSE);
    end;


    procedure CreatePayrollSimulation(Employee: Record Employee)
    var
        SalaryHeader: Record "WDC Salary Header";
        SalaryLine: Record "WDC Salary Lines";
        HumanResourceSetup: Record "Human Resources Setup";
    begin
        HumanResourceSetup.GET();
        IF NOT SalaryHeader.GET('SIMULATION') THEN BEGIN
            SalaryHeader."No." := 'SIMULATION';

            SalaryHeader.Description := 'SIMULATION';
            SalaryHeader.Month := SalaryHeader.Month::January;
            SalaryHeader.Year := 0;
            SalaryHeader."Paid days" := HumanResourceSetup."Paid days";
            SalaryHeader."Worked days" := HumanResourceSetup."Worked days";
            SalaryHeader."Posting Date" := TODAY;
            SalaryHeader.INSERT;
        END;

        SalaryLine.SETRANGE("No.", 'SIMULATION');
        SalaryLine.SETRANGE("Employee No.", Employee."No.");
        IF NOT SalaryLine.FINDFIRST THEN
            CreateSalaryLineSimulation(SalaryHeader, Employee, 0);
        SalaryLine.RESET;
        SalaryLine.SETRANGE("No.", 'SIMULATION');
        SalaryLine.SETRANGE("Employee No.", Employee."No.");
        IF SalaryLine.FINDFIRST THEN
            CalculateSalaryLineSimu(SalaryLine, FALSE, 0, 0, FALSE);
    end;

    procedure CalcIndemnityImpCorrect(var SalaryLine: Record "WDC Salary Lines"; NbJour: Decimal)
    var
        SalaryHeader: Record "WDC Salary Header";
        Ind: Record "WDC Indemnities";
        ParamRessHum: Record "Human Resources Setup";
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        bonus: Decimal;
        tmp: Decimal;
        tmp1: Decimal;
        LigneTravail: Record "WDC Occasional Hours Recorded";
        LigneAbsence: Record "WDC Employee's days off Entry";
        LigneTravailEnreg: Record "WDC Overtime hours recorded m";
        Defaultind: Record "WDC Default Indemnities";
        RecIndemnity: Record "WDC Indemnity";
        "RecAbsenceCongé": Record "WDC Employee's days off Entry";
        TotalJoursAbs: Decimal;
        lText001: Textconst ENU = 'Work regime not defined for employee : %1 ',
                             FRA = 'Régime de travail non défini pour le salarié : %1 ';
        lText002: Textconst ENU = ' Check the number of hours worked per month for regime : %1',
                             FRA = 'Vérifier le nombre d heure travaillées par mois pour le régime : %1';
    begin
        //--> Calcul des montants réels des Ind. selon le mode d'évaluation
        SalaryHeader.GET(SalaryLine."No.");
        ParamRessHum.GET();
        IF SalaryLine."Employee Work Regime" = '' THEN
            ERROR(lText001, SalaryLine."Employee No.");
        RegimeWork.RESET;
        RegimeWork.SETRANGE(Code, SalaryLine."Employee Work Regime");
        IF RegimeWork.FINDFIRST THEN
            IF RegimeWork."Work Hours per month" = 0 THEN
                ERROR(lText002, RegimeWork.Code);

        Ind.SETRANGE("No.", SalaryLine."No.");
        Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
        IF Ind.FINDFIRST THEN
            REPEAT
                TotalJoursAbs := 0;
                CASE Ind."Evaluation mode".AsInteger() OF
                    0:
                        BEGIN
                            Ind.Rate := 100;
                            Ind."Real Amount" := Ind."Base Amount" * Ind.Rate / 100;
                            Ind."Real Amount PR" := Ind."Base Amount";
                            Ind."User ID" := USERID;
                        END;
                    1:
                        BEGIN
                            LigneTravail.RESET;
                            LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
                            LigneTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
                            LigneTravail.SETRANGE("Payment Month", SalaryLine.Month);
                            LigneTravail.SETRANGE("Payment Year", SalaryLine.Year);
                            IF ParamRessHum."Activate fortnightly regime" THEN
                                IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                                    LigneTravail.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                            LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                            LigneTravailEnreg.RESET;
                            LigneTravailEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
                            LigneTravailEnreg.SETFILTER("Employee No.", SalaryLine."Employee No.");
                            LigneTravailEnreg.SETRANGE("Payment Month", SalaryLine.Month);
                            LigneTravailEnreg.SETRANGE("Payment Year", SalaryLine.Year);
                            IF ParamRessHum."Activate fortnightly regime" THEN
                                IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                                    LigneTravailEnreg.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                            LigneTravailEnreg.CALCSUMS("Hours Number", "Line amount");
                            //>> DSFT AGA 160410  DEDUCTION DE L'INDEMNITE QU'APARTIRE DU DEPASSEMENT DU NOMBRE DE JOUR ABSENCE

                            CASE SalaryLine."Employee type".AsInteger() OF
                                0:
                                    BEGIN

                                        Ind.Rate := ((SalaryLine."Worked hours") * 100) / GNbHeure;
                                        Ind.Rate := ((LigneTravail."Days Number" * 100) / GNbJour);
                                        IF RecIndemnity.GET(Ind.Indemnity) THEN
                                            IF RecIndemnity."Deduction Base Indemnity/Days" > (GNbJour - LigneTravail."Days Number") THEN
                                                Ind.Rate := 100;
                                        IF Ind.Rate > 100 THEN
                                            Ind.Rate := 100;
                                        // PRIME A BASE DE NOMBRE DE JOURS
                                        IF Ind."Days Number" <> 0 THEN BEGIN
                                            RecAbsenceCongé.RESET;
                                            RecAbsenceCongé.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year", Fortnight, "Absence Reason");
                                            RecAbsenceCongé.SETFILTER("Employee No.", SalaryLine."Employee No.");
                                            RecAbsenceCongé.SETFILTER("Line type", '%1', 3);
                                            RecAbsenceCongé.SETFILTER("Posting month", '%1', SalaryLine.Month);
                                            RecAbsenceCongé.SETFILTER("Posting year", '%1', SalaryLine.Year);
                                            IF (Ind."Non-Deductible Work Accident" = FALSE) THEN BEGIN
                                                RecAbsenceCongé.SETFILTER("Absence Reason", '<>%1', 7);
                                                RecAbsenceCongé.CALCSUMS("Quantity (Days)");
                                                TotalJoursAbs := ABS(RecAbsenceCongé."Quantity (Days)");
                                            END ELSE BEGIN
                                                RecAbsenceCongé.SETFILTER("Absence Reason", '<>%1', 5);
                                                RecAbsenceCongé.CALCSUMS("Quantity (Days)");
                                                TotalJoursAbs := ABS(RecAbsenceCongé."Quantity (Days)");
                                            END;

                                            RecAbsenceCongé.SETFILTER("Line type", '%1', 2);
                                            RecAbsenceCongé.CALCSUMS("Quantity (Days)");

                                            TotalJoursAbs := TotalJoursAbs + ABS(RecAbsenceCongé."Quantity (Days)");
                                            Ind.Rate := ((Ind."Days Number" - TotalJoursAbs) / Ind."Days Number") * 100;
                                        END;
                                        // FIN CALCUL INDEMNITE PAR NOMBRE DE JOURS

                                    END;
                                1:
                                    BEGIN
                                        IF GNbJour > 0 THEN BEGIN
                                            Ind.Rate := ((TotJoursEnreg) * 100) / GNbJour;
                                            IF RecIndemnity.GET(Ind.Indemnity) THEN
                                                IF RecIndemnity."Deduction Base Indemnity/Days" > (GNbJour - TotJoursEnreg) THEN
                                                    Ind.Rate := 100;
                                            IF Ind.Rate > 100 THEN
                                                Ind.Rate := 100;
                                        END;
                                    END;
                            END;
                            // DEV GMS 18/11/2010 PRIME A BASE DE NOMBRE DE JOURS
                            IF Ind."Days Number" <> 0 THEN BEGIN
                                RecAbsenceCongé.RESET;
                                RecAbsenceCongé.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year", Fortnight, "Absence Reason");
                                RecAbsenceCongé.SETFILTER("Employee No.", SalaryLine."Employee No.");

                                RecAbsenceCongé.SETFILTER("Line type", '%1', 3);
                                RecAbsenceCongé.SETFILTER("Posting month", '%1', SalaryLine.Month);
                                RecAbsenceCongé.SETFILTER("Posting year", '%1', SalaryLine.Year);
                                IF (Ind."Non-Deductible Work Accident" = FALSE) THEN BEGIN
                                    RecAbsenceCongé.SETFILTER("Absence Reason", '<>%1', 7);
                                    RecAbsenceCongé.CALCSUMS("Quantity (Days)");
                                    TotalJoursAbs := ABS(RecAbsenceCongé."Quantity (Days)");
                                END ELSE BEGIN
                                    RecAbsenceCongé.SETFILTER("Absence Reason", '<>%1', 5);
                                    RecAbsenceCongé.CALCSUMS("Quantity (Days)");
                                    TotalJoursAbs := ABS(RecAbsenceCongé."Quantity (Days)");
                                END;

                                RecAbsenceCongé.SETFILTER("Line type", '%1', 2);
                                RecAbsenceCongé.CALCSUMS("Quantity (Days)");
                                TotalJoursAbs := TotalJoursAbs + ABS(RecAbsenceCongé."Quantity (Days)");

                                Ind.Rate := ((Ind."Days Number" - TotalJoursAbs) / Ind."Days Number") * 100;
                            END;
                            // FIN CALCUL INDEMNITE PAR NOMBRE DE JOURS

                            Ind."Real Amount" := Ind."Base Amount" * Ind.Rate / 100;
                            Ind."Real Amount PR" := Ind."Base Amount";
                            // MC -------------------------------------------------------------------------------------------------
                            Ind."User ID" := USERID;
                            IF Ind."Real Amount" < 0 THEN
                                Ind."Real Amount" := 0;
                        END;
                    2:
                        BEGIN
                            //>>ABSENCE
                            Ind.Rate := SalaryLine."Assiduity (Worked days)";
                            //>> DEDUCTION DE L'INDEMNITE QU'APARTIRE DU DEPASSEMENT DU NOMBRE DE JOUR ABSENCE
                            CASE SalaryLine."Employee type".AsInteger() OF
                                0:
                                    BEGIN

                                        Ind.Rate := ((SalaryLine."Worked hours") * 100) / GNbHeure;
                                        IF (RecIndemnity."Deduction Base Indemnity/Hour") > (GNbHeure - SalaryLine."Worked hours") THEN
                                            Ind.Rate := 100;
                                    END;
                                1:
                                    BEGIN
                                        Ind.Rate := SalaryLine."Assiduity (Worked days)";
                                        IF RecIndemnity.GET(Ind.Indemnity) THEN
                                            IF RecIndemnity."Deduction Base Indemnity/Days" > (GNbJour - TotJoursEnreg) THEN
                                                Ind.Rate := 100;
                                    END;
                            END;

                            Ind.Rate := SalaryLine."Assiduity (Worked days)";
                            // MC : Prise en compte du Min. garanti ---------------------------------------------------------------
                            tmp := 0;
                            IF Ind."Minimum value" > 0 THEN BEGIN
                                tmp := ROUND(Ind."Base Amount" * Ind.Rate / 100, Ind."Amount Rounding Precision",
                                                                 FORMAT(Ind."Rounding Direction"));
                                IF tmp < Ind."Minimum value" THEN
                                    Ind."Real Amount" := Ind."Minimum value"
                                ELSE
                                    Ind."Real Amount" := tmp;
                            END
                            ELSE
                                Ind."Real Amount" := Ind."Base Amount" * Ind.Rate / 100;
                            Ind."Real Amount PR" := Ind."Base Amount";
                            // MC -------------------------------------------------------------------------------------------------
                            Ind."User ID" := USERID;
                            IF Ind."Real Amount" < 0 THEN
                                Ind."Real Amount" := 0;
                        END;
                    3:
                        BEGIN
                            DecMntHoraire := Ind."Base Amount";
                            DecNBHeureEncouragement := SalaryLine."Worked hours";
                            IF ((RecIndemnity."Deduction Base Indemnity/Hour") > (GNbHeure - SalaryLine."Worked hours"))
                            AND ((GNbHeure - SalaryLine."Worked hours") > 0) THEN
                                DecNBHeureEncouragement := RegimeWork."Work Hours per month";

                            Ind.Rate := SalaryLine."Worked hours" + SalaryLine."Hours off Balacement" +
                                                          SalaryLine."Hours consumption Holiday";//+SalaryLine."Heure Jours Free";
                                                                                                 // MC : Prise en compte du Min. garanti ---------------------------------------------------------------

                            tmp := 0;
                            IF Ind."Minimum value" > 0 THEN BEGIN
                                tmp := Ind."Base Amount" * Ind.Rate;
                                IF tmp < Ind."Minimum value" THEN
                                    Ind."Real Amount" := Ind."Minimum value"
                                ELSE
                                    Ind."Real Amount" := tmp;
                            END
                            ELSE BEGIN
                                IF SalaryLine."Employee type".AsInteger() = 0 THEN
                                    Ind."Real Amount" := DecMntHoraire * DecNBHeureEncouragement
                                ELSE
                                    IF SalaryLine.Month.AsInteger() <> 13 THEN BEGIN
                                        Ind."Real Amount" := (Ind."Base Amount" * (SalaryLine."Paied days") / GNbJour)
                                                                           + (DecMntHoraire * DecNBHeureEncouragement);
                                    END//
                                    ELSE
                                        Ind."Real Amount" := (Ind."Base Amount" * (SalaryLine."Paied days") / GNbJour)
                                                                           + (DecMntHoraire * DecNBHeureEncouragement)
                            END;
                            Ind."Real Amount PR" := Ind."Base Amount" * RegimeWork."Work Hours per month";
                            IF Ind."Real Amount" < 0 THEN
                                Ind."Real Amount" := 0;
                            // MC -------------------------------------------------------------------------------------------------
                            Ind."User ID" := USERID;
                        END;
                    7:
                        BEGIN
                            IF SalaryLine."Employee type".AsInteger() = 1 THEN
                                Ind.Rate := SalaryLine."Worked hours" + SalaryLine."Hours off Balacement"
                            ELSE
                                Ind.Rate := SalaryLine."Worked hours" + SalaryLine."Hours off Balacement" +
                                SalaryLine."Hours consumption Holiday";
                            // MC : Prise en compte du Min. garanti ---------------------------------------------------------------
                            tmp := 0;
                            IF Ind."Minimum value" > 0 THEN BEGIN
                                tmp := ROUND((Ind."Base Amount" * Ind.Rate) / 100
                                                                 , Ind."Amount Rounding Precision", FORMAT(Ind."Rounding Direction"));
                                IF tmp < Ind."Minimum value" THEN
                                    Ind."Real Amount" := Ind."Minimum value"
                                ELSE
                                    Ind."Real Amount" := tmp;
                            END
                            ELSE
                                Ind."Real Amount" := (Ind."Base Amount" * Ind.Rate) / 100;
                            Ind."Real Amount PR" := ROUND(Ind."Real Amount", Ind."Amount Rounding Precision",
                                                                FORMAT(Ind."Rounding Direction"));

                            // MC -------------------------------------------------------------------------------------------------
                            Ind."User ID" := USERID;
                        END;

                    5:
                        BEGIN
                            Ind.Rate := SalaryHeader."Worked days" - SalaryLine.Absences - SalaryLine.Holiday;
                            //>> CALCUL INDEMNITE PAR JOURS DE TRAVAIL

                            LigneTravail.RESET;
                            LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
                            LigneTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
                            LigneTravail.SETRANGE("Payment Month", SalaryLine.Month);
                            LigneTravail.SETRANGE("Payment Year", SalaryLine.Year);
                            IF ParamRessHum."Activate fortnightly regime" THEN
                                IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                                    LigneTravail.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                            LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                            IF Ind."Deduction Base Indemnity/Days" < (SalaryHeader."Worked days" - LigneTravail."Days Number") THEN
                                Ind.Rate := LigneTravail."Days Number"
                            ELSE BEGIN
                                Ind.Rate := SalaryHeader."Worked days";
                                LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                                Ind.Rate := LigneTravail."Days Number"
                            END;
                            IF Ind.Rate < 0 THEN
                                Ind.Rate := 0;
                            // MC : Prise en compte du Min. garanti ---------------------------------------------------------------
                            tmp := 0;
                            IF Ind."Minimum value" > 0 THEN BEGIN
                                tmp := ROUND(Ind."Base Amount" * Ind.Rate, Ind."Amount Rounding Precision",
                                                                 FORMAT(Ind."Rounding Direction"));
                                IF tmp < Ind."Minimum value" THEN
                                    Ind."Real Amount" := Ind."Minimum value"
                                ELSE
                                    Ind."Real Amount" := tmp;
                            END ELSE
                                Ind."Real Amount" := ROUND(Ind."Base Amount" * Ind.Rate, Ind."Amount Rounding Precision", '>');
                            Ind."Real Amount PR" := ROUND(Ind."Base Amount" * SalaryHeader."Worked days"
                                 , Ind."Amount Rounding Precision");
                            // Ind."Real Amount" := ROUND(Ind."Real Amount",0.01,'>') ;
                            // MC -------------------------------------------------------------------------------------------------
                            Ind."User ID" := USERID;
                        END;
                    // Athanor

                    4:
                        BEGIN
                            // MC : Prise en compte du Nombre et Min. garanti -------------------------------------------------------
                            tmp := 0;
                            Ind.Rate := Ind.Rate;
                            IF Ind."Minimum value" > 0 THEN BEGIN
                                tmp := ROUND(Ind."Base Amount" * Ind.Rate, Ind."Amount Rounding Precision",
                                                                FORMAT(Ind."Rounding Direction"));
                                IF tmp < Ind."Minimum value" THEN
                                    Ind."Real Amount" := Ind."Minimum value"
                                ELSE
                                    Ind."Real Amount" := tmp;
                            END
                            ELSE
                                Ind."Real Amount" := Ind."Base Amount" * Ind.Rate;

                            Ind."Real Amount PR" := Ind."Base Amount";
                            // MC -------------------------------------------------------------------------------------------------
                            Ind."User ID" := USERID;
                        END;
                END;
                //NE
                IF (SalaryLine.Month.AsInteger() > 12) AND (SalaryLine.Month.AsInteger() <> 13) AND (Ind."Not Included in Bonus") THEN BEGIN
                    Ind.Rate := 0;
                    Ind."Real Amount" := 0;
                END;
                IF Ind."Evaluation mode" = Ind."Evaluation mode"::Inclusive THEN
                    Ind."Real Amount" := Ind."Base Amount"
                ELSE
                    Ind."Real Amount" := (Ind."Base Amount" * NbJour) / RegimeWork."Worked Day Per Month";
                Ind.MODIFY;
            UNTIL Ind.NEXT = 0;
    end;



    procedure CalculerFieldsPaie(var SalaryLineTmp: Record "WDC Salary Lines"; Sim: Option Simulation,Real)
    var
        lAbsenceMgmt: Codeunit "WDC Absences Management";
    begin
        IF Sim = 1 THEN
            lAbsenceMgmt.CalcAbsence(SalaryLineTmp);
        MgmtSalary2.CalcAllTaxe(SalaryLineTmp);
        IF (SalaryLineTmp.Month.AsInteger() < 12) OR (SalaryLineTmp.Month.AsInteger() = 14) AND (Sim = 1) THEN
            CalcLoanAdv(SalaryLineTmp);
    end;

    procedure "CalcInd&HsupNav"(var SalaryLineTmp: Record "WDC Salary Lines"; Sim: Option Simulation,Real)
    var
        SuppHourLine: Record "WDC Overtime hours recorded m";
        Indem: Record "WDC Indemnities";
        Contrat: Record "Employment Contract";
        Regim: Record "WDC work Regimes";
        HeureTravail: Record "WDC Occasional Hours Recorded";
        RecLPramRessHum: Record "Human Resources Setup";
        "DECNbannéesAnciennité": Decimal;
        RecLEmployee: Record Employee;
        J: Integer;
        "DecDroitCongéAncienneté": Decimal;
        "NbAttrubitionJourAncienneté": Decimal;
        k: Integer;
    begin
        SalaryLineTmp."Taxable indemnities" := 0;
        SalaryLineTmp."Supp. hours" := 0;
        SalaryLineTmp."Taxable Indem. PR (Not Gross)" := 0;
        CLEAR(Contrat);
        CLEAR(Regim);
        RecLPramRessHum.GET();
        IF (SalaryLineTmp.Month.AsInteger() < 12) AND (Sim = 1) THEN BEGIN
            DateJ := DMY2DATE(1, SalaryLineTmp.Month.AsInteger() + 1, SalaryLineTmp.Year);
            IF Contrat.GET(SalaryLineTmp."Emplymt. Contract Code") THEN
                Contrat.CalcFields("Employee type");
            Regim.GET(Contrat."Work Regime");

            HeureTravail.RESET;
            HeureTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
            HeureTravail.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
            HeureTravail.SETRANGE("Payment Month", SalaryLineTmp.Month);
            HeureTravail.SETRANGE("Payment Year", SalaryLineTmp.Year);
            HeureTravail.SETFILTER("Payment No.", '%1', '');
            IF RecLPramRessHum."Activate fortnightly regime" THEN
                IF Regim."Payroll Calculation Type" = Regim."Payroll Calculation Type"::Fortnight THEN
                    HeureTravail.SETFILTER(Fortnight, '%1', SalaryLineTmp.Fortnight);

            HeureTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
            IF Contrat."Employee type".AsInteger() = 0 THEN
                SalaryLineTmp."Monthly Leave Entitlement" := ROUND(Regim."Days off per month" * HeureTravail."Hours Number" /
                                                          Regim."Work Hours per month", ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLineTmp."Monthly Leave Entitlement" := ROUND(Regim."Days off per month" * SalaryLineTmp."Assiduity (Paid days)" / 100,
                                                                ParamCpta."Amount Rounding Precision");
        END;
        IF SalaryLineTmp."Monthly Leave Entitlement" > Regim."Days off per month" THEN
            SalaryLineTmp."Monthly Leave Entitlement" := Regim."Days off per month";

        // calcul nombre de jour de congé d'ancieneté plafoné selon le mode de rétribution
        RecLPramRessHum.GET();
        RecLEmployee.GET(SalaryLineTmp."Employee No.");
        DecDroitCongéAncienneté := 0;
        IF RecLPramRessHum."Apply Retribution for Old Days" = TRUE THEN
            IF SalaryLineTmp.Month.AsInteger() = 11 THEN BEGIN
                DECNbannéesAnciennité := SalaryLineTmp.Year - DATE2DMY(RecLEmployee."Employment Date", 3);
                IF DECNbannéesAnciennité >= Regim."Limite ancienneté" THEN BEGIN
                    FOR J := 0 TO DECNbannéesAnciennité - Regim."Limite ancienneté" DO BEGIN
                        J := J + Regim."Limite ancienneté";
                        IF J = DECNbannéesAnciennité THEN BEGIN
                            NbAttrubitionJourAncienneté := DECNbannéesAnciennité / Regim."Limite ancienneté";
                            FOR k := 0 TO NbAttrubitionJourAncienneté - 1 DO BEGIN
                                DecDroitCongéAncienneté := DecDroitCongéAncienneté + Regim."Rétributions Ancienneté/An";
                                SalaryLineTmp."Seniority leave entitlement" := DecDroitCongéAncienneté;
                            END;
                        END ELSE BEGIN
                            SalaryLineTmp."Seniority leave entitlement" := 0;
                        END;
                        J := J - 1;
                    END;
                    IF DecDroitCongéAncienneté > Regim."Limite ancienneté" THEN
                        SalaryLineTmp."Seniority leave entitlement" := Regim."Plafond Ancienneté/An";
                END;
            END;
        ParamCpta.GET;
        Indem.RESET;
        Indem.SETCURRENTKEY("No.", "Employee No.", Type, "Not incl. Nat. Old Age Insur.", "Conventional Indemnity");
        Indem.SETFILTER("No.", SalaryLineTmp."No.");
        Indem.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        Indem.SETFILTER(Type, '%1', Indem.Type::Imposable);
        Indem.SETFILTER("Not incl. Nat. Old Age Insur.", '%1', FALSE);
        Indem.CALCSUMS("Real Amount", "Real Amount PR");
        IF Indem.FINDFIRST THEN
            REPEAT
                SalaryLineTmp."Taxable indemnities" := SalaryLineTmp."Taxable indemnities" +
                                                       ROUND(Indem."Real Amount", ParamCpta."Amount Rounding Precision");
            UNTIL Indem.NEXT = 0;

        SalaryLineTmp."Taxable indemnities PR" := ROUND(Indem."Real Amount PR", ParamCpta."Amount Rounding Precision");

        Indem.RESET;
        Indem.SETCURRENTKEY("No.", "Employee No.", Type);
        Indem.SETFILTER("No.", SalaryLineTmp."No.");
        Indem.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        Indem.SETFILTER(Type, '%1', 2);
        Indem.CALCSUMS("Real Amount");
        SalaryLineTmp."Taxable Indem. PR (Not Gross)" := ROUND(Indem."Real Amount", ParamCpta."Amount Rounding Precision");
        IF Sim = 1 THEN BEGIN
            SuppHourLine.RESET;
            SuppHourLine.SETCURRENTKEY("Employee No.", "Overtime Rate", "Payment Month", "Payment Year", Fortnight);
            SuppHourLine.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
            SuppHourLine.SETFILTER("Payment Month", '%1', SalaryLineTmp.Month);
            SuppHourLine.SETFILTER("Payment Year", '%1', SalaryLineTmp.Year);
            IF RecLPramRessHum."Activate fortnightly regime" THEN
                IF Regim."Payroll Calculation Type" = Regim."Payroll Calculation Type"::Fortnight THEN
                    SuppHourLine.SETFILTER(Fortnight, '%1', SalaryLineTmp.Fortnight);
            IF SuppHourLine.FINDFIRST THEN
                REPEAT

                    SalaryLineTmp."Supp. hours" := SalaryLineTmp."Supp. hours" + ROUND(SuppHourLine."Line amount"
                                                , ParamCpta."Amount Rounding Precision");

                    SuppHourLine.MODIFYALL("Payment No.", SalaryLineTmp."No.");
                UNTIL SuppHourLine.NEXT = 0;
        END;
    end;



    procedure CalcLoanAdv(var SalaryLineTmp: Record "WDC Salary Lines")
    var
        LoanAdvan: Record "WDC Loan & Advance Lines";
        LoanAD: Record "WDC Loan & Advance Header";
        DateD: Date;
        DateF: Date;
    begin
        IF SalaryLineTmp.Year = 0 THEN
            SalaryLineTmp.Year := DATE2DMY(TODAY, 3);
        IF SalaryLineTmp.Month.AsInteger() < 12 THEN
            DateD := DMY2DATE(1, SalaryLineTmp.Month.AsInteger() + 1, SalaryLineTmp.Year)
        ELSE
            DateD := DMY2DATE(1, DATE2DMY(SalaryLineTmp."Posting Date", 2), SalaryLineTmp.Year);

        DateF := CALCDATE('<+CM>', DateD);
        SalaryLineTmp.Loans := 0;
        LoanAD.RESET;
        LoanAD.SETCURRENTKEY("Employee No.", Type, Status, "No.", "Avance Sur Prime");
        LoanAD.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        LoanAD.SETRANGE(Type, LoanAD.Type::Loan);
        LoanAD.SETRANGE(Status, LoanAD.Status::"In progress");
        LoanAD.SETRANGE("Avance Sur Prime", FALSE);
        LoanAD.SETRANGE("Not include", FALSE);
        IF LoanAD.FINDFIRST THEN
            REPEAT
                SalaryLineTmp.Loans := SalaryLineTmp.Loans + ROUND(LoanAD.CalcMnPrinciPeriode(DateD, DateF),
                                     ParamCpta."Amount Rounding Precision") +
                                     ROUND(LoanAD.CalcMntInetret(DateD, DateF), ParamCpta."Amount Rounding Precision");
            UNTIL LoanAD.NEXT = 0;
        IF LoanAD."Double tranche" = TRUE THEN
            SalaryLineTmp.Loans := SalaryLineTmp.Loans * 2;
        // Advance
        SalaryLineTmp.Advances := 0;
        LoanAD.RESET;
        LoanAD.SETCURRENTKEY("Employee No.", Type, Status, "No.", "Avance Sur Prime");

        LoanAD.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        LoanAD.SETRANGE(Type, LoanAD.Type::Advance);
        LoanAD.SETRANGE(Status, LoanAD.Status::"In progress");
        LoanAD.SETRANGE("Avance Sur Prime", FALSE);
        IF LoanAD.FINDFIRST THEN
            REPEAT
                SalaryLineTmp.Advances := SalaryLineTmp.Advances + ROUND(LoanAD.CalcMnPrinciPeriode(DateD, DateF),
                ParamCpta."Amount Rounding Precision");
            UNTIL LoanAD.NEXT = 0;
        // Advance Sur Prime
    end;


    procedure CalculateSalaryLineSTC(var SalaryLine: Record "WDC Salary Lines"; "SolderDroitCongé": Boolean; Sim: Option Simulation,Real,Prime; nbjsolder: Decimal; Pinverse: Boolean): Decimal
    var
        SalaryHeader: Record "WDC Salary Header";
        Ind: Record "WDC Indemnities";
        SocialContributions: Record "WDC Social Contributions";
        ParamRessHum: Record "Human Resources Setup";
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        Employee: Record Employee;
        SliceImposition: Record "WDC Slices of imposition";
        SliceImpositionX: Record "WDC Slices of imposition";
        deductionChef: Decimal;
        HasPrime13eme: Boolean;
        HasPrimeRend: Boolean;
        Month: Integer;
        temp: Decimal;
        LeaveBalance: Decimal;
        NBmoisTravaille: Decimal;
        nbrMonth: Decimal;
        tmp: Decimal;
        tmp1: Decimal;
        ValConge: Decimal;
        TotImpot: Decimal;
        nbr: Decimal;
        ChefFamille: Decimal;
        bonus: Decimal;
        SalLineEng: Record "WDC Salary Lines";
        TotImposable: Decimal;
        LigneTravail: Record "WDC Occasional Hours Recorded";
        DateFin: Date;
        LigneTravailEnreg: Record "WDC Overtime hours recorded m";
        "Mgmt.ofLoansandAdvances": Codeunit "WDC Mgmt. Loans & Adv";
        droitconge: Record "WDC Employee's days off Entry";
        SalLineEngTmp: Record "WDC Salary Lines";
        MntInd: Decimal;
        DefaultIndemnitiesTmp: Record "WDC Default Indemnities";
        SoldeReport: Decimal;
        EMP1: Record Employee;
        LigneAbsence: Record "WDC Employee's days off Entry";
        AbsEmp: Decimal;
        "RecLJourFérier": Record "WDC Employee's days off Entry";
        RecLDefaultindemnities: Record "WDC Default Indemnities";
        RecLIndemnities: Record "WDC Indemnities";
        DecSalaireBrut: Decimal;
        DateDeb: Date;
        HeureJourTravail: Record "WDC Occasional Hours Recorded";
    begin
        SalaryHeader.GET(SalaryLine."No.");
        ParamRessHum.GET();
        IF NOT SolderDroitCongé THEN
            nbjsolder := 0;
        ParamCpta.GET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        CLEAR(EmploymentContract);
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        RegimeWork.RESET;
        RegimeWork.GET(EmploymentContract."Work Regime");
        MgmtSalary2.initLigne(SalaryLine, Sim);

        GNbJour := SalaryHeader."Worked days";//WDC2308 RegimeWork."Worked Day Per Month"
        GNbHeure := RegimeWork."Work Hours per month";//ParamRessHum."Paid days"*ParamRessHum."From Work day to Work hour";


        //-->calcul de la bonification
        bonus := 1;
        IF (SalaryLine.Month.AsInteger() > 11) AND (SalaryLine.Purcent > 0) THEN BEGIN
            bonus := SalaryLine.Purcent;
            IF ParamRessHum."Type de Note" = 0 THEN
                bonus := bonus / 100;
            //-->Prise en compte de nbre de mois travaillés
            IF SalaryLine."Worked Months" > 0 THEN
                bonus := bonus * (SalaryLine."Worked Months" / 12)
            ELSE
                bonus := 0;
        END;
        //--> Soder droit congé
        IF Sim = 1 THEN
            AbsenceMgmt.CalcAbsence(SalaryLine);

        ParamRessHum.TESTFIELD("Minimum wage guarantee");
        IF SalaryLine.Month.AsInteger() < 12 THEN BEGIN
            IF (DATE2DMY(Employee."Employment Date", 3) = SalaryLine.Year) AND ((DATE2DMY(Employee."Employment Date", 2) - 1) = SalaryLine.Month.AsInteger())
            THEN
                SalaryLine."6 * SMIG" := ROUND(ParamRessHum."Minimum wage guarantee" * 6 *
                      (CALCDATE('<+CM>', Employee."Employment Date") - Employee."Employment Date" + 1), ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLine."6 * SMIG" := ROUND(ParamRessHum."Minimum wage guarantee" * 6, ParamCpta."Amount Rounding Precision");
        END;
        IF SolderDroitCongé THEN BEGIN
            IF ((SalaryLine."Days off remaining" + SalaryLine."Monthly Leave Entitlement") >= nbjsolder) AND (nbjsolder <> 0) THEN
                SalaryLine."Days off balacement" := nbjsolder
            ELSE
                SalaryLine."Days off balacement" := (SalaryLine."Days off remaining" + SalaryLine."Monthly Leave Entitlement");
            droitconge.RESET;
            droitconge.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year");
            droitconge.SETRANGE("Line type", 1);
            droitconge.SETRANGE("Employee No.", SalaryLine."Employee No.");
            droitconge.SETRANGE("Posting month", SalaryLine.Month);
            droitconge.SETRANGE("Posting year", SalaryLine.Year);

            droitconge.CALCSUMS("Quantity (Days)", "Line amount", "Quantity (Hours)");
            SalaryLine."Amount Days Off balacement" := ROUND(Employee."Basis salary" * SalaryLine."Days off balacement" /
                                                     SalaryHeader."Paid days", ParamCpta."Amount Rounding Precision");
            SalaryLine."Assiduity (days off balacement" := ROUND(SalaryLine."Days off balacement" / SalaryHeader."Paid days", 0.0001) * 100;
            SalaryLine."Hours off Balacement" := droitconge."Quantity (Hours)";
        END
        ELSE
            SalaryLine."Days off balacement" := 0;

        // --> Calcul des 2 param. d'assiduité
        MntInd := 0;
        IF Employee."Currency Code" <> '' THEN BEGIN
            DefaultIndemnitiesTmp.RESET;
            DefaultIndemnitiesTmp.SETFILTER("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
            DefaultIndemnitiesTmp.SETRANGE("Evaluation mode", 1, 2);
            DefaultIndemnitiesTmp.SETRANGE("Indemnity Type", 0);
            IF DefaultIndemnitiesTmp.FINDFIRST THEN
                REPEAT
                    MntInd := MntInd + DefaultIndemnitiesTmp."Default amount";
                UNTIL DefaultIndemnitiesTmp.NEXT = 0;
        END;
        IF ParamRessHum."Activate fortnightly regime" THEN
            IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                nbr := 26
            ELSE
                nbr := 12;
        EmploymentContract.RESET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        CASE ParamRessHum."Monthes Number".AsInteger() OF
            0:
                nbr := EmploymentContract."Regular payments";
            1:
                nbr := EmploymentContract."Temporary payments";
            2:
                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
        END;
        IF RegimeWork.GET(SalaryLine."Employee Work Regime") THEN;
        IF ((Sim = 1) OR ((SalaryLine."Basis salary" = 0) AND (Sim = 0))) AND NOT ((Pinverse = TRUE) AND (SalaryLine."Basis salary" = 0)) THEN BEGIN
            IF SalaryLine."Posting Date" = 0D THEN
                SalaryLine."Posting Date" := WORKDATE;
            IF Employee."Currency Code" = '' THEN
                SalaryLine."Basis salary" := Employee."Basis salary"
            ELSE BEGIN
                IF Employee."Taxable Indemnity" <> 0 THEN
                    SalaryLine."Basis salary" :=
                       ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code",
                          Employee."Taxable Indemnity", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"),
                          Employee."Currency Code")
              ) -
                          MntInd, ParamCpta."Amount Rounding Precision")
                ELSE
                    SalaryLine."Basis salary" :=
                         ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code",
                          Employee."Basis salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code")
              )
                          , ParamCpta."Amount Rounding Precision");
            END;
        END;
        //Salaire de base
        CASE SalaryLine."Employee type".AsInteger() OF
            0:
                BEGIN
                    //CALCUL HEURES NORMALES
                    //>> Calc PaidDate
                    IF SalaryLine."Days Number" = 0 THEN
                        TotHeuresEnreg := GNbHeure
                    ELSE
                        TotHeuresEnreg := SalaryLine."Days Number" * RegimeWork."From Work day to Work hour";
                    SalaryLine."Worked hours" := TotHeuresEnreg;
                    SalaryLine."Basis salary" := Employee."Basis salary";

                    SalaryLine."Real basis salary" := ROUND(SalaryLine."Worked hours" * Employee."Basis salary",
                                                      ParamCpta."Amount Rounding Precision");
                    IF (Pinverse = FALSE) THEN
                        SalaryLine."Real basis salary" := ROUND(SalaryLine."Worked hours" * SalaryLine."Basis salary",
                                                        ParamCpta."Amount Rounding Precision");
                    SalaryLine."Assiduity (Paid days)" := (SalaryLine."Worked hours" / SalaryHeader."Worked days") * 100;//WDC2008  RegimeWork."Work Hours per month"
                    IF SalaryLine."Assiduity (Paid days)" > 100 THEN
                        SalaryLine."Assiduity (Paid days)" := 100;
                END;
            1:
                BEGIN
                    SalaryLine."Basis hours" := LigneTravail."Hours Number";
                    IF SalaryLine."Days Number" = 0 THEN
                        TotJoursEnreg := GNbJour - AbsEmp// Nouveau

                    ELSE
                        TotJoursEnreg := SalaryLine."Days Number";

                    //>> Calc PaidDate
                    month := DATE2DMY(SalaryHeader."Posting Date", 2);

                    DateDeb := DMY2DATE(1, month, SalaryHeader.Year);
                    DateFin := SalaryHeader."Posting Date";
                    IF Employee."Employment Date" <= DateDeb THEN
                        GNbJour := Employee."Inactive Date" - DateDeb
                    ELSE BEGIN
                        GNbJour := Employee."Inactive Date" - Employee."Employment Date";
                    END;
                    IF GNbJour > RegimeWork."Worked Day Per Month" THEN
                        GNbJour := RegimeWork."Worked Day Per Month";

                    droitconge.RESET;
                    droitconge.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year");
                    droitconge.SETRANGE("Employee No.", SalaryLine."Employee No.");
                    droitconge.SETRANGE("Posting month", month - 1);
                    droitconge.SETRANGE("Posting year", SalaryLine.Year);
                    IF droitconge.FINDSET THEN BEGIN
                        REPEAT
                            IF (droitconge."Quantity (Days)" < 0) THEN
                                droitconge."Quantity (Days)" := droitconge."Quantity (Days)" * -1;
                            GNbJour := GNbJour - droitconge."Quantity (Days)";
                        UNTIL droitconge.NEXT = 0;
                    END;
                    IF GNbJour < 0 THEN
                        GNbJour := 0;
                    //<< Calc PaidDate
                    SalaryLine.Absences := AbsEmp;
                    //>>D Calc PaidDate

                    TotJoursEnreg := GNbJour;
                    SalaryLine."Paied days" := GNbJour;
                    SalaryLine."Assiduity (Paid days)" := (SalaryHeader."Paid days"
                                                             - SalaryLine.Absences
                                                             - SalaryLine."Adjustment of absences")
                                                             / SalaryHeader."Paid days"
                                                             * 100;
                    SalaryLine."Assiduity (Worked days)" := (SalaryHeader."Worked days"
                                                             - ABS(LigneAbsence.Quantity)
                                                             - ABS(SalaryLine."Days off")
                                                             //-   ABS(SalaryLine."Nbjour ferier")
                                                             - ABS(SalaryLine."Adjustment of absences"))
                                                             / SalaryHeader."Worked days"
                                                             * 100;

                    //<< Calc PaidDate


                    IF (Pinverse = TRUE) THEN
                        SalaryLine."Basis salary" := Employee."Basis salary";
                    // AGA >> assiduité jour payé
                    IF (Pinverse = FALSE) THEN
                        SalaryLine."Real basis salary" := ROUND(((GNbJour * SalaryLine."Basis salary") / RegimeWork."Worked Day Per Month")
                                                         , ParamCpta."Amount Rounding Precision");
                    SalaryLine."Paied days" := GNbJour;
                END;
        END;
        //FIN CALCUL SALAIRE DE BASE
        // CALCUL PRIME DE RENDEMENT MENSUEL
        IF (ParamRessHum."Apply Monthly Perfor. Bonus") THEN BEGIN
            Employee.GET(SalaryLine."Employee No.");
            Employee.CALCFIELDS("Total Holiday Indemnities");
            DecSalaireBrut := Employee."Reel Basis salary";
            //DELETE SI EXISTE -->
            RecLIndemnities.RESET;
            RecLIndemnities.SETRANGE("No.", SalaryLine."No.");
            RecLIndemnities.SETRANGE("Employee No.", SalaryLine."Employee No.");
            RecLIndemnities.SETRANGE(Indemnity, ParamRessHum."Code Monthly Rend. Indem.");
            IF RecLIndemnities.FINDFIRST THEN
                RecLIndemnities.DELETE;
            //MODIFY SI EXISTE <--
            RecLDefaultindemnities.RESET;
            RecLDefaultindemnities.SETRANGE("Emplymt. Contract Code", SalaryLine."Employee No.");
            RecLDefaultindemnities.SETRANGE("Indemnity Code", ParamRessHum."Code Monthly Rend. Indem.");
            IF RecLDefaultindemnities.FINDFIRST THEN BEGIN
                RecLDefaultindemnities."Default amount" := 0;
                EmploymentContract.GET(Employee."No.");
                EmploymentContract.CalcFields("Employee type");
                RegimeWork.GET(EmploymentContract."Work Regime");
                RecLDefaultindemnities."Emplymt. Contract Code" := Employee."No.";
                RecLDefaultindemnities."Indemnity Code" := ParamRessHum."Code Monthly Rend. Indem.";
                IF EmploymentContract."Employee type".AsInteger() = 0 THEN
                    RecLDefaultindemnities."Default amount" := DecSalaireBrut * RecLDefaultindemnities.Rate / 100
                ELSE
                    RecLDefaultindemnities."Default amount" := DecSalaireBrut * RecLDefaultindemnities.Rate / 100;
                RecLDefaultindemnities.MODIFY;
                RecLIndemnities."No." := SalaryLine."No.";
                RecLIndemnities."Employee No." := Employee."No.";
                RecLIndemnities.Indemnity := ParamRessHum."Code Monthly Rend. Indem.";
                RecLIndemnities.VALIDATE(Indemnity);
                RecLIndemnities.Type := RecLDefaultindemnities.Type;
                RecLIndemnities."Indemnity Type" := RecLDefaultindemnities."Indemnity Type";
                IF EmploymentContract."Employee type".AsInteger() = 0 THEN
                    RecLIndemnities."Base Amount" := DecSalaireBrut * RecLDefaultindemnities.Rate / 100
                ELSE
                    RecLIndemnities."Base Amount" := DecSalaireBrut * RecLDefaultindemnities.Rate / 100;
                //>> calc ind Real Amount
                RecLIndemnities."Real Amount" := ((RecLIndemnities."Base Amount") * GNbJour) / RegimeWork."Worked Day Per Month";
                //<< calc ind Real Amount
                RecLIndemnities."User ID" := USERID;
                RecLIndemnities."Employee Posting Group" := Employee."Empl. Posting Group";
                RecLIndemnities.INSERT;
            END;
        END ELSE BEGIN
            RecLDefaultindemnities.RESET;
            RecLDefaultindemnities.SETRANGE("Emplymt. Contract Code", SalaryLine."Employee No.");
            RecLDefaultindemnities.SETRANGE("Indemnity Code", ParamRessHum."Code Monthly Rend. Indem.");
            IF RecLDefaultindemnities.FINDFIRST THEN
                RecLDefaultindemnities."Default amount" := 0;
            RecLIndemnities.RESET;
            RecLIndemnities.SETRANGE("No.", SalaryLine."No.");
            RecLIndemnities.SETRANGE("Employee No.", SalaryLine."Employee No.");
            RecLIndemnities.SETRANGE(Indemnity, ParamRessHum."Code Monthly Rend. Indem.");
            IF RecLIndemnities.FINDFIRST THEN
                RecLIndemnities.DELETE;
        END;
        // Calcul Indemnité
        IF Pinverse AND (SalaryLine.Month.AsInteger() = 14) THEN
            SalaryLine."Amount Days Off balacement" := 0;
        IF ParamRessHum."Leave Balance Calc. Type".AsInteger() = 1 THEN
            SalaryLine."Assiduity (Paid days)" := SalaryLine."Assiduity (Paid days)" + SalaryLine."Assiduity (days off balacement";
        EMP.GET(SalaryLine."Employee No.");
        CreateIndemnityLine(SalaryLine, EMP);
        CalcIndemnityImpCorrect(SalaryLine, SalaryLine."Paied days");
        // calcul droit de congé du mois
        HeureJourTravail.RESET;
        HeureJourTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
        HeureJourTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
        HeureJourTravail.SETFILTER("Payment Month", '%1', SalaryLine.Month);
        HeureJourTravail.SETFILTER("Payment Year", '%1', SalaryLine.Year);
        IF ParamRessHum."Activate fortnightly regime" THEN
            IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN BEGIN
                HeureJourTravail.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
            END;
        HeureJourTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
        IF Employee."Employee type".AsInteger() = 0 THEN
            SalaryLine."Monthly Leave Entitlement" := ROUND(RegimeWork."Days off per month" * HeureJourTravail."Hours Number" /
                                                      RegimeWork."Work Hours per month", ParamCpta."Amount Rounding Precision")
        ELSE
            SalaryLine."Monthly Leave Entitlement" := ROUND(RegimeWork."Days off per month" * SalaryLine."Assiduity (Paid days)" / 100,
                                                            ParamCpta."Amount Rounding Precision");
        IF SalaryLine."Monthly Leave Entitlement" > RegimeWork."Days off per month" THEN
            SalaryLine."Monthly Leave Entitlement" := RegimeWork."Days off per month";
        IF (ParamRessHum."Calculate STC auto.") THEN BEGIN
            Employee.GET(SalaryLine."Employee No.");
            //DELETE SI EXISTE -->
            RecLIndemnities.RESET;
            RecLIndemnities.SETRANGE("No.", SalaryLine."No.");
            RecLIndemnities.SETRANGE("Employee No.", SalaryLine."Employee No.");
            IF RecLIndemnities.FINDFIRST THEN
                RecLIndemnities.DELETE;
            RecLDefaultindemnities.RESET;
            RecLDefaultindemnities.SETRANGE("Emplymt. Contract Code", SalaryLine."Employee No.");
            IF RecLDefaultindemnities.FINDFIRST THEN
                RecLDefaultindemnities.DELETE;
            //DELETE SI EXISTE <--
            BEGIN
                IF RecLIndemnities."Evaluation mode" = RecLIndemnities."Evaluation mode"::Inclusive THEN
                    RecLIndemnities."Real Amount" := RecLIndemnities."Base Amount"
                ELSE
                    RecLIndemnities."Real Amount" := (RecLIndemnities."Base Amount" * GNbJour) / RegimeWork."Worked Day Per Month";

                RecLIndemnities."Real Amount" := (RecLIndemnities."Base Amount" * GNbJour) / RegimeWork."Worked Day Per Month";
                RecLIndemnities."User ID" := USERID;
                RecLIndemnities."Employee Posting Group" := Employee."Empl. Posting Group";

                RecLIndemnities.INSERT;
                SalaryLine."Days off balacement" := -(SalaryLine."Days off remaining" + SalaryLine."Monthly Leave Entitlement");
            END;
        END;
        //--> Calcul du salaire Brut du mois
        EMP.GET(SalaryLine."Employee No.");
        //CréerLignesIndemnités(SalaryLine,EMP);
        "CalcInd&HsupNav"(SalaryLine, Sim);
        SalaryLine."6 * SMIG" := ROUND(ParamRessHum."Minimum wage guarantee" * 6, ParamCpta."Amount Rounding Precision");
        IF (SalaryLine.Month.AsInteger() = 14) THEN
            SalaryLine."Assiduity (Paid days)" := 100;
        CASE SalaryLine."Employee type".AsInteger() OF
            1:
                BEGIN
                    SalaryLine."Gross Salary (Without AV)" := ROUND((bonus * SalaryLine."Real basis salary")
                                                          + SalaryLine."Taxable Indem. PR (Not Gross)"
                                                          + SalaryLine."Taxable indemnities"
                                                          + SalaryLine."Supp. hours"
                                                          , ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary (Without AV) PR" := ROUND((SalaryLine."Basis salary" - SalaryLine."Amount Days Off balacement"
                                                                  ) + SalaryLine."Taxable indemnities PR"
                                                                  , ParamCpta."Amount Rounding Precision") +
                                                                  SalaryLine."Taxable indem. PR (Not Gross)";
                    SalaryLine."Gross Salary" := SalaryLine."Gross Salary (Without AV)";
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary PR" := SalaryLine."Gross Salary (Without AV) PR";
                END;
            0:
                BEGIN
                    SalaryLine."Gross Salary (Without AV)" := ROUND((bonus * SalaryLine."Real basis salary")
                                                        + SalaryLine."Taxable Indem. PR (Not Gross)"
                                                        + SalaryLine."Taxable indemnities"
                                                        + SalaryLine."Supp. hours"


                                                        , ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary (Without AV) PR" := ROUND((SalaryLine."Basis salary" - SalaryLine."Amount Days Off balacement"
         )
                                                        + SalaryLine."Taxable indemnities PR" + SalaryLine."Taxable indem. PR (Not Gross)"
                                                        , ParamCpta."Amount Rounding Precision");
                    SalaryLine."Gross Salary" := SalaryLine."Gross Salary (Without AV)";
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary (Without AV) PR" := SalaryLine."Gross Salary (Without AV) PR";
                END;
        END;
        CalculIndemnityAvNat(SalaryLine);
        Ind.RESET;
        Ind.SETRANGE(Ind."No.", SalaryHeaders."No.");
        Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
        Ind.SETRANGE(Indemnity, 'G134');
        IF Ind.FINDSET THEN BEGIN
            DefaultIndemnitiesTmp.RESET;
            DefaultIndemnitiesTmp.SETRANGE("Indemnity Code", 'G134');
            DefaultIndemnitiesTmp.SETRANGE("Emplymt. Contract Code", SalaryLine."Employee No.");
            IF DefaultIndemnitiesTmp.FINDSET THEN BEGIN
                Ind.VALIDATE("Days Number", DefaultIndemnitiesTmp."Days Number");
                Ind.MODIFY;
            END;
        END;
        //
        //
        Ind.RESET;
        Ind.SETRANGE(Ind."No.", SalaryHeaders."No.");
        Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
        Ind.SETRANGE(Indemnity, 'G137');
        IF Ind.FINDSET THEN BEGIN
            ValConge := ValuationLeaveBalance(EMP);
            LeaveBalance := GetLeaveBalance(EMP);
            Ind.VALIDATE("Base Amount", ValConge);
            Ind.VALIDATE("Real Amount", ValConge);
            Ind.VALIDATE("Days Number", LeaveBalance);
            Ind.MODIFY();
        END
        ELSE
            IF NOT Ind.FINDSET THEN BEGIN
                Ind.RESET;
                Ind.INIT;
                Ind.VALIDATE("No.", SalaryLine."No.");
                Ind.VALIDATE("Employee No.", SalaryLine."Employee No.");
                Ind.VALIDATE(Indemnity, 'G137');
                ValConge := ValuationLeaveBalance(EMP);
                LeaveBalance := GetLeaveBalance(EMP);
                Ind.VALIDATE("Base Amount", ValConge);
                Ind.VALIDATE("Real Amount", ValConge);
                Ind.VALIDATE("Days Number", LeaveBalance);
                Ind.INSERT;
            END;

        //
        CASE SalaryLine."Employee type".AsInteger() OF
            1:
                BEGIN
                    LigneTravail.RESET;
                    LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
                    LigneTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravail.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravail.SETRANGE("Payment Year", SalaryLine.Year);
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN BEGIN
                            LigneTravail.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                        END;
                    LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                    LigneTravail.MODIFYALL("Payment No.", SalaryLine."No.");
                    SalaryLine."Basis hours" := LigneTravail."Hours Number";
                    LigneTravailEnreg.RESET;
                    LigneTravailEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
                    LigneTravailEnreg.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravailEnreg.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravailEnreg.SETRANGE("Payment Year", SalaryLine.Year);
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN BEGIN
                            LigneTravailEnreg.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                        END;
                    LigneTravailEnreg.CALCSUMS("Hours Number", "Line amount");
                    LigneAbsence.RESET;

                    SalaryLine."Gross Salary" := ROUND(
                                                             ROUND(SalaryLine."Real basis salary" * bonus, ParamCpta."Amount Rounding Precision")
                                                           + ROUND(SalaryLine."Taxable indemnities", ParamCpta."Amount Rounding Precision")
                                                           + ROUND(SalaryLine."Supp. hours", ParamCpta."Amount Rounding Precision")
                                                           + ROUND(SalaryLine."Public Holiday Worked Amount")
                                                           + ROUND(SalaryLine."Hours Amount"),
                                                           ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary PR" := ROUND((bonus * SalaryLine."Real basis salary") + SalaryLine.
                                                               "Taxable indemnities PR", ParamCpta."Amount Rounding Precision");
                END;
            0:
                BEGIN
                    LigneTravail.RESET;
                    LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
                    LigneTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravail.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravail.SETRANGE("Payment Year", SalaryLine.Year);
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN BEGIN
                            LigneTravail.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                        END;
                    LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                    LigneTravail.MODIFYALL("Payment No.", SalaryLine."No.");
                    SalaryLine."Basis hours" := LigneTravail."Hours Number";
                    LigneTravailEnreg.RESET;
                    LigneTravailEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
                    LigneTravailEnreg.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravailEnreg.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravailEnreg.SETRANGE("Payment Year", SalaryLine.Year);
                    IF ParamRessHum."Activate fortnightly regime" THEN
                        IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN BEGIN
                            LigneTravailEnreg.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                        END;
                    LigneTravailEnreg.CALCSUMS("Hours Number", "Line amount");
                    LigneAbsence.RESET;
                    SalaryLine."Gross Salary" := ROUND(
                                                             ROUND(SalaryLine."Real basis salary" * bonus, ParamCpta.
            "Amount Rounding Precision")
                                                           + ROUND(SalaryLine."Taxable indemnities", ParamCpta."Amount Rounding Precision")

                                                           + ROUND(SalaryLine."Supp. hours", ParamCpta."Amount Rounding Precision")


                                                           + ROUND(SalaryLine."Public Holiday Worked Amount"),

                                                           ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary PR" := ROUND((SalaryLine."Real basis salary" * bonus)
                                                               + SalaryLine."Taxable indemnities PR"
                                                               , ParamCpta."Amount Rounding Precision");
                END;
        END;
        // --> Calc Cotisation Social
        SalLineEng.RESET;
        SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
        SalLineEng.Setrange(Year, SalaryLine.Year);
        SalLineEng.SETRANGE(Taxable, TRUE);
        SalLineEng.CALCSUMS("Real taxable", "Taxe (Month)", "Taxable salary");
        //>> Modif total imposable
        TotImposable := 0;
        nbrMonth := 0;
        IF SalLineEng.FINDSET THEN
            REPEAT
                IF SalLineEng.Month.AsInteger() < EmploymentContract."Regular payments" THEN
                    nbrMonth += 1
                ELSE BEGIN
                    IF SalLineEng.Month.AsInteger() = 12 THEN
                        HasPrime13eme := TRUE;
                    IF SalLineEng.Month.AsInteger() = 14 THEN
                        HasPrimeRend := TRUE;
                END;
                IF NBmoisTravaille = 0 THEN BEGIN
                    Employee.RESET;
                    Employee.SETRANGE(Employee."No.", SalaryLine."Employee No.");
                    IF Employee.FINDSET THEN BEGIN

                        DateDeb := DMY2DATE(1, 1, SalaryLine.Year);
                        DateFin := DMY2DATE(31, 12, SalaryLine.Year);
                        IF (Employee."Employment Date" < DateDeb) AND (Employee."Inactive Date" = 0D) THEN
                            NBmoisTravaille := nbr
                        ELSE BEGIN
                            IF Employee."Inactive Date" <> 0D THEN
                                NBmoisTravaille := ((Employee."Inactive Date" - DateDeb) / 30)
                            ELSE
                                NBmoisTravaille := ((DateFin - Employee."Employment Date") / 30);
                        END;
                    END;
                END;
                IF NBmoisTravaille > EmploymentContract."Regular payments" THEN
                    NBmoisTravaille := EmploymentContract."Regular payments";
                TotImposable := SalLineEng."Taxable salary";
                TotImpot := SalLineEng."Taxe (Month)";
            UNTIL SalLineEng.NEXT = 0;
        IF EmploymentContract."Has Bonus 13" THEN BEGIN
            IF NOT HasPrimeRend THEN
                SalaryLine."Salaire Brut Prime Rend" := CalcLinePerfermanceBonusSTC(SalaryLine, SolderDroitCongé, Sim, nbjsolder);
            IF NOT HasPrime13eme THEN
                SalaryLine."Salaire Brut Prime Fin Annee" := CalcLineBonus13EMESTC(SalaryLine, SolderDroitCongé, Sim, nbjsolder);
            SalaryLine."Salaire Brut Paie Reel" := SalaryLine."Gross Salary";
            SalaryLine."Gross Salary" += SalaryLine."Salaire Brut Prime Rend" + SalaryLine."Salaire Brut Prime Fin Annee";
        END;
        SalaryLine."Nbr Mois Prime" := NBmoisTravaille;

        SalaryLine."Gross Salary" := SalaryLine."Gross Salary" + Ind."Real Amount";
        SalaryLine.MODIFY;
        //
        IF ParamRessHum."Leave Balance Calc. Type".AsInteger() = 0 THEN
            SalaryLine."Basis salary" := SalaryLine."Basis salary" - SalaryLine."Amount Days Off balacement";
        MgmtSalary2.CalcCotisationSocial1(SalaryLine);
        //--> Calcul du salaire imposable
        MgmtSalary2.CalcAllTaxe(SalaryLine);
        //A AJOUTER CONTROLE NON IMPOSABLE
        Gemployee.GET(SalaryLine."Employee No.");//WDC01
        IF EmploymentContract.Taxable THEN
            // SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib." +
            //                                    SalaryLine."Taxable Indem. PR (Not Gross)"
            //                                      - SalaryLine."Retirement plus"
            //                                                , ParamCpta."Amount Rounding Precision");//WDC01
            SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib." +
                                               SalaryLine."Taxable indemnities(Not Gross)"
                                                 - SalaryLine."Retirement plus"
                                                           , ParamCpta."Amount Rounding Precision");//WDC01

        IF Sim < 2 THEN
            IF EmploymentContract.Taxable THEN
                SalaryLine."Taxable salary PR" := ROUND(SalaryLine."Gross Salary PR" - SalaryLine."Non Taxable Soc. Contrib. PR" +
                                                       SalaryLine."Taxable indem. PR (Not Gross)"
                                                                 , ParamCpta."Amount Rounding Precision");
        // Calc Cotisation Social
        MgmtSalary2.CalcCotisationSocial2(SalaryLine);
        //--> Calcul de l'imposable réel
        IF EmploymentContract.Taxable THEN BEGIN
            IF NOT Employee."Family chief" THEN BEGIN
                SalaryLine."Deduction Family chief" := 0;
                SalaryLine."Deduction Loaded child" := 0;
            END;
            SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Pourcent professional expenses"
                                                          * SalaryLine."Taxable salary");
            //>>
            //******(1)********************Recherche sur les paie enregistr² *********************************
            nbr := 12;
            ImposEnreg := 0;
            NbrPaie := 0;
            FraisEnreg := 0;
            RecGSalayEnr.RESET;
            RecGSalayEnr.SETCURRENTKEY(Year, Month, "Employee No.", "No.");
            RecGSalayEnr.SETRANGE("Employee No.", SalaryLine."Employee No.");
            RecGSalayEnr.SETRANGE(Year, SalaryLine.Year);
            IF RecGSalayEnr.FINDSET THEN
                REPEAT
                    IF RecGSalayEnr.Month.AsInteger() < nbr THEN
                        ImposEnreg := ImposEnreg + RecGSalayEnr."Taxable salary";      //Somme imposable Enregistr²
                    FraisEnreg := FraisEnreg + RecGSalayEnr."Deduction Prof. expenses"; //Somme Frais prof Enregistr²
                    IF RecGSalayEnr.Month.AsInteger() < nbr THEN
                        NbrPaie := NbrPaie + 1;
                UNTIL RecGSalayEnr.NEXT = 0;
            //******(2)********************Si Frais prof enregistr² >= 2000 alors frais prof = zero *********************************
            //@@@@@@@@@@@@@@@@@@   Condition 1
            IF FraisEnreg >= ParamRessHum."Professional Expenses Charges" THEN BEGIN
                SalaryLine."Deduction Prof. expenses" := 0;
            END ELSE BEGIN
                //@@@@@@@@@@@@@@@@@@   Condition 2
                //******(3)********************Si Frais prof annuel <=2000 < alors **********************************************************
                IF ROUND(ParamRessHum."Pourcent professional expenses" * (SalaryLine."Taxable salary" * (nbr - NbrPaie) + ImposEnreg)) <=
        ParamRessHum."Professional Expenses Charges" THEN BEGIN
                    IF ROUND(ParamRessHum."Pourcent professional expenses" * SalaryLine."Taxable salary") >= ROUND(ParamRessHum.
                                                                                        "Professional Expenses Charges" / nbr) THEN
                        SalaryLine."Deduction Prof. expenses" := ROUND((ParamRessHum."Professional Expenses Charges" / nbr) * (NbrPaie + 1) - FraisEnreg)
                    ELSE
                        SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Pourcent professional expenses"
                                                                        * SalaryLine."Taxable salary");
                    //@@@@@@@@@@@@@@@@@@   Condition 3
                    //******(3)********************Si Frais prof annuel <=2000 et avec l'imposable en cour sera >=2000 *********************************
                    //*************************
                END ELSE BEGIN
                    SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Professional Expenses Charges" - FraisEnreg) / (nbr - NbrPaie);
                END;
            END;
            //<<
            IF SalaryLine.Month.AsInteger() < 12 THEN
                SalaryLine."Real taxable" := ROUND(SalaryLine."Taxable salary"
                                                               - SalaryLine."Deduction Family chief"
                                                               - SalaryLine."Deduction Loaded child"
                                                               - SalaryLine."Deduction Prof. expenses", ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLine."Real taxable" := ROUND(SalaryLine."Taxable salary"
                                                               - SalaryLine."Deduction Family chief"
                                                               - SalaryLine."Deduction Loaded child"
                                                               - SalaryLine."Deduction Prof. expenses", ParamCpta."Amount Rounding Precision");
            IF (SalaryLine.Month.AsInteger() < 12) OR (Sim = 2) THEN
                SalaryLine."Real taxable PR" := ROUND(SalaryLine."Taxable salary PR"
                                                               - SalaryLine."Deduction Family chief"
                                                               - SalaryLine."Deduction Loaded child"
                                                               - ROUND(SalaryLine."Taxable salary PR" * ParamRessHum."Pourcent professional expenses" / 100
                                                               , ParamCpta."Amount Rounding Precision"), ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLine."Real taxable PR" := ROUND(SalaryLine."Taxable salary PR"
                                                               - ROUND(SalaryLine."Taxable salary PR" * ParamRessHum."Pourcent professional expenses" / 100
                                                               , ParamCpta."Amount Rounding Precision"), ParamCpta."Amount Rounding Precision");



            SalaryLine."Rec. payments" := 0;
            SalLineEngTmp.RESET;
            SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Taxable);
            SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEngTmp.Setrange(Year, SalaryLine.Year);
            SalLineEngTmp.Setrange(Taxable, TRUE);
            SalLineEngTmp.SETFILTER(Month, '<%1', SalLineEngTmp.month::"13th Salary");
            SalLineEngTmp.CALCSUMS("Real taxable", "Taxe (Month)");
            SalaryLine."Rec. payments" := SalLineEngTmp.COUNT;
            SalLineEngTmp.RESET;
            SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.");
            SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEngTmp.Setrange(Year, SalaryLine.Year);
            DEDUCIMPOT := 0;
            IF SalLineEngTmp.FINDFIRST THEN
                REPEAT
                    DEDUCIMPOT := DEDUCIMPOT + SalLineEngTmp."Deduction Family chief" +
                                  SalLineEngTmp."Deduction Loaded child" + SalLineEngTmp."Deduction Prof. expenses"
                UNTIL SalLineEngTmp.NEXT = 0;
            //--> Calcul de l'Imposable Réel
            EmploymentContract.RESET;
            Employee.GET(SalaryLine."Employee No.");
            EmploymentContract.GET(Employee."Emplymt. Contract Code");
            MntAssVie := 0;
            RecAssVie.RESET;
            RecAssVie.SETRANGE(Year, SalaryLine.Year);
            RecAssVie.SETRANGE("Employee No.", SalaryLine."Employee No.");
            IF RecAssVie.FINDFIRST THEN
                REPEAT
                    MntAssVie := MntAssVie + RecAssVie.Amount;
                UNTIL RecAssVie.NEXT = 0;
            MontCapitalReinvesti := 0;
            CASE Sim OF
                0:
                    BEGIN
                        CASE ParamRessHum."Monthes Number".AsInteger() OF
                            0:
                                nbr := EmploymentContract."Regular payments";
                            1:
                                nbr := EmploymentContract."Temporary payments";
                            2:
                                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
                        END;
                        SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" * nbr,
                                                                               ParamCpta."Amount Rounding Precision");
                    END;
                1, 2:
                    BEGIN
                        nbr := 12;
                        EmploymentContract.RESET;
                        Employee.GET(SalaryLine."Employee No.");
                        EmploymentContract.GET(Employee."Emplymt. Contract Code");
                        CASE ParamRessHum."Monthes Number".AsInteger() OF
                            0:
                                nbr := EmploymentContract."Regular payments";
                            1:
                                nbr := EmploymentContract."Temporary payments";
                            2:
                                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
                        END;

                        ParamRessHum."Regulation Taxe" := ParamRessHum."Regulation Taxe"::"13th and more";
                        CASE ParamRessHum."Regulation Taxe".AsInteger() OF
                            0:
                                BEGIN
                                    IF SalaryLine.Month.AsInteger() < 12 THEN BEGIN
                                        IF (Employee."Working Relationship".AsInteger() = 2) OR (Employee."Working Relationship".AsInteger() = 3) THEN
                                            SalaryLine."Real taxable (Year)" := ROUND((SalaryLine."Real taxable" +
                                                        (SalaryLine."Real taxable" * (nbr - SalaryLine."Rec. payments" - 1)))
                                                        + SalaryLine."Total taxable rec."
                                                        , ParamCpta."Amount Rounding Precision")
                                        ELSE
                                            SalaryLine."Real taxable (Year)" := ROUND(((SalaryLine."Real taxable" * (nbr)))
                                                                               , ParamCpta."Amount Rounding Precision");
                                    END
                                    ELSE
                                        SalaryLine."Real taxable (Year)" := ROUND((SalaryLine."Real taxable" +
                                                                            ((SalaryLine."Real taxable PR")
                                                                             * (nbr - SalaryLine."Rec. payments")))
                                                                            + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                                    IF SalaryLine.Month.AsInteger() < 13 THEN
                                        SalaryLine."Real Taxable PR (Year)" := ROUND((SalaryLine."Real taxable PR" +
                                                                            (SalaryLine."Real taxable PR" * (nbr - SalaryLine."Rec. payments" - 1)))
                                                                            + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        SalaryLine."Real Taxable PR (Year)" := ROUND((
                                                                            ((SalaryLine."Real taxable PR")
                                                                             * (nbr - SalaryLine."Rec. payments")))
                                                                            + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                                END;
                            1:
                                BEGIN



                                    SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" * nbr,


                                                                                   ParamCpta."Amount Rounding Precision");

                                    SalaryLine."Real Taxable PR (Year)" := ROUND(SalaryLine."Real taxable PR" * nbr,
                                                                                    ParamCpta."Amount Rounding Precision");
                                END;
                        END;
                    END;
            END;
            //RECALCUL REAL TAXABLE*****************************************10/03/2009
            IF Employee."Working Relationship".AsInteger() = 2 THEN BEGIN
                SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Taxable salary" * (nbr - SalaryLine."Rec. payments") +
                                                            SalaryLine."Total taxable rec." + DEDUCIMPOT, ParamCpta."Amount Rounding Precision");
                SalaryLine."Real taxable (Year)" := SalaryLine."Real taxable (Year)" - ROUND(ParamRessHum.

            "Pourcent professional expenses"


                                                           * SalaryLine."Real taxable (Year)");
                SalaryLine."Real taxable (Year)" := SalaryLine."Real taxable (Year)" - (SalaryLine."Deduction Family chief" * nbr)
                                                                 - (SalaryLine."Deduction Loaded child" * nbr)
                                                            - MntAssVie - MontCapitalReinvesti
                                                                 ;
            END;


            //*****************************************END 10/03/2009
            // Calcul Impôt Annuel

            TotImposable := TotImposable + SalaryLine."Taxable salary";
            TotImposable := TotImposable - TotImposable * ParamRessHum."Pourcent professional expenses";
            IF Employee."Family chief" THEN BEGIN
                Employee.CALCFIELDS(Employee."Deduction Loaded child");
                ChefFamille := ParamRessHum."Deduction for Familly Chief";
            END
            ELSE
                ChefFamille := 0;
            SalaryLine."Real taxable (Year)" := TotImposable - ChefFamille - Employee."Deduction Loaded child";
            SalaryLine."Real taxable (Year)" := SalaryLine."Real taxable (Year)" - MntAssVie - MontCapitalReinvesti;
            //>>  -Loi calcul impot 2014
            ParamGrH.GET();
            IF ParamGrH."Active IRPP Ceiling" THEN BEGIN
                BaremeCalculImpot := FctGetSbaseIndemExonore(SalaryLine."No.", SalaryLine."Employee No.");
                BaremeCalculImpotApCNSS := BaremeCalculImpot - (BaremeCalculImpot * 9.68 / 100);
                BaremeCalculImpotApFraisProf := BaremeCalculImpotApCNSS - (BaremeCalculImpotApCNSS * 0.1);
                BaremeCalculImpotApFraisProf := BaremeCalculImpotApFraisProf - (SalaryLine."Deduction Family chief" + SalaryLine."Deduction Loaded child");
                IF (BaremeCalculImpotApFraisProf * nbr) >= (ParamGrH."Income Tax Calculation Ceiling") THEN BEGIN
                    TaxesMgmt.CalcAnnualTaxes(SalaryLine);
                END;
            END ELSE BEGIN
                TaxesMgmt.CalcAnnualTaxes(SalaryLine);
            END;

            //<<  -Loi calcul impot 2014
            //>>------------------------------------------------------------------------------------LOI IMPÔT 2014 -------------------------------
            //<<  -Loi calcul impot 2014
            //<<------------------------------------------------------------------------------------LOI IMPÔT 2014 -------------------------------
            // Calcul Impôt mensuel
            CASE ParamRessHum."Regulation Taxe".AsInteger() OF
                0:
                    BEGIN
                        IF SalaryLine.Month.AsInteger() < nbr THEN BEGIN
                            //*******************************************************
                            IF Employee."Working Relationship".AsInteger() = 2 THEN BEGIN
                                IF (nbr - SalaryLine."Rec. payments") <> 0 THEN
                                    SalaryLine."Taxe PR (Month)" := ROUND((SalaryLine."Taxe PR (Year)" - SalaryLine."Total taxes rec.")
                                                                  / (nbr - SalaryLine."Rec. payments"), ParamCpta."Amount Rounding Precision");
                                IF SalaryLine.Month.AsInteger() < 12 THEN
                                    SalaryLine."Taxe (Month)" := ROUND(((SalaryLine."Taxe (Year)" - SalaryLine."Total taxes rec.")
                                                                 / (nbr - SalaryLine."Rec. payments")), ParamCpta."Amount Rounding Precision")
                                ELSE
                                    SalaryLine."Taxe (Month)" := (SalaryLine."Taxe (Year)" - SalaryLine."Taxe PR (Year)");
                                IF (-SalaryLine."Taxe (Month)" >= SalaryLine."Total taxes rec.") AND (SalaryLine."Taxe (Month)" < 0) THEN
                                    SalaryLine."Taxe (Month)" := -SalaryLine."Total taxes rec.";
                            END
                            ELSE BEGIN

                                SalaryLine."Taxe PR (Month)" := ROUND((SalaryLine."Taxe PR (Year)" / nbr)
                                                              , ParamCpta."Amount Rounding Precision");
                                SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" / nbr), ParamCpta."Amount Rounding Precision");
                            END;
                            IF SalaryLine."Taxe (Month)" < 0 THEN
                                SalaryLine."Taxe (Month)" := 0;
                            //*******************************************************
                        END ELSE BEGIN
                            IF (nbr - SalaryLine."Rec. payments" + 1) <> 0 THEN
                                SalaryLine."Taxe PR (Month)" := ROUND((SalaryLine."Taxe PR (Year)" - SalaryLine."Total taxes rec.")
                                                               / (nbr - SalaryLine."Rec. payments" + 1), ParamCpta."Amount Rounding Precision");
                            IF SalaryLine.Month.AsInteger() < 12 THEN
                                SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" - SalaryLine."Taxe PR (Year)") +
                                                             SalaryLine."Taxe PR (Month)", ParamCpta."Amount Rounding Precision")
                            ELSE
                                SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" - SalaryLine."Taxe PR (Year)")
                                                             , ParamCpta."Amount Rounding Precision");
                            IF (-SalaryLine."Taxe (Month)" >= SalaryLine."Total taxes rec.") AND (SalaryLine."Taxe (Month)" < 0) THEN
                                SalaryLine."Taxe (Month)" := -SalaryLine."Total taxes rec.";
                            IF SalaryLine."Taxe (Month)" < 0 THEN
                                SalaryLine."Taxe (Month)" := 0;
                        END;
                    END;
                1:
                    BEGIN
                        IF SalaryLine."Rec. payments" < nbr THEN
                            SalaryLine."Taxe PR (Month)" := ROUND(SalaryLine."Taxe PR (Year)" / nbr, ParamCpta.
                                                                           "Amount Rounding Precision")
                        ELSE
                            SalaryLine."Taxe PR (Month)" := 0;

                        SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)"
                                                                       / nbr), ParamCpta."Amount Rounding Precision");
                        IF SalaryLine."Taxe (Month)" < 0 THEN
                            SalaryLine."Taxe (Month)" := 0;
                    END;
            END;

            SalaryLine."Taxe (Month)" := ROUND(SalaryLine."Taxe (Year)" - TotImpot, ParamCpta."Amount Rounding Precision");
            IF SalaryLine."Taxe (Month)" < 0 THEN
                SalaryLine."Taxe (Month)" := 0;
        END;
        IF EmploymentContract."Inclusive ratio" <> 0 THEN
            SalaryLine."Taxe (Month)" := (SalaryLine."Gross Salary" * EmploymentContract."Inclusive ratio") / 100;

        SalaryLine."Net salary" := ROUND(SalaryLine."Gross Salary"
                                 - SalaryLine."Non Taxable Soc. Contrib."
                                 + SalaryLine."Taxable Indem. PR (Not Gross)"
                                 + SalaryLine."Non Taxable indemnities"
                                 + SalaryLine."Mission expenses"
                                 - SalaryLine."Taxable Soc. Contrib."
                                 - SalaryLine."Taxe (Month)"

                                  , ParamCpta."Amount Rounding Precision");
        IF Sim = 1 THEN
            "Mgmt.ofLoansandAdvances".CreateRepaymentLine(SalaryLine);

        SalaryLine."Net salary cashed" := ROUND(SalaryLine."Net salary"
                                                       - SalaryLine.Loans
                                                       - SalaryLine.Advances, ParamCpta."Amount Rounding Precision");


        //======================= END ARRONDISSEMENT
        IF (SalaryLine."Taxable salary" = 0) AND (SalaryLine."Net salary" <= 0) AND (Sim = 1) THEN
            MgmtSalary2.DeleteLine(SalaryLine)
        ELSE
            SalaryLine.MODIFY;

        EXIT(SalaryLine."Net salary");
    end;


    procedure CalculIndemnityAvNat(var SalaryLine: Record "WDC Salary Lines")
    var
        SalaryHeader: Record "WDC Salary Header";
        Ind: Record "WDC Indemnities";
        ParamRessHum: Record "Human Resources Setup";
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        bonus: Decimal;
        tmp: Decimal;
        tmp1: Decimal;
    begin
        // calc Indemnité avec Taux
        Ind.SETRANGE("No.", SalaryLine."No.");
        Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
        Ind.SETRANGE("Evaluation mode", 6);
        IF Ind.FINDFIRST THEN
            REPEAT
                Ind."Base Amount" := SalaryLine."Gross Salary (Without AV)";

                Ind.Rate := SalaryLine."Assiduity (Paid days)";
                // MC : Prise en compte du Min. garanti ---------------------------------------------------------------
                tmp := 0;
                IF Ind."Minimum value" > 0 THEN BEGIN
                    tmp := ROUND(Ind."Base Amount" * Ind.Rate / 100, Ind."Amount Rounding Precision",
                                                       FORMAT(Ind."Rounding Direction"));
                    IF tmp < Ind."Minimum value" THEN
                        Ind."Real Amount" := Ind."Minimum value"
                    ELSE
                        Ind."Real Amount" := tmp;
                END
                ELSE
                    Ind."Real Amount" := Ind."Base Amount" * Ind.Rate / 100;

                Ind."Real Amount PR" := ROUND(SalaryLine."Gross Salary (Without AV) PR" * Ind.Rate / 100
                                                         , Ind."Amount Rounding Precision", FORMAT(Ind."Rounding Direction"));

                // MC -------------------------------------------------------------------------------------------------
                Ind."User ID" := USERID;
                IF (SalaryLine.Month.AsInteger() > 12) AND (Ind."Not Included in Bonus") THEN BEGIN
                    Ind.Rate := 0;
                    Ind."Real Amount" := 0;
                END;
                IF Ind."Indemnity Type" = Ind."Indemnity Type"::"Not Regular" THEN
                    Ind."Real Amount PR" := 0;

                Ind.MODIFY;
            UNTIL Ind.NEXT = 0;
    end;


    procedure CalcLinePerfermanceBonusSTC(SalaryLine: Record "WDC Salary Lines"; "SolderDroitCongé": Boolean; Sim: Option Simulation,Real; nbjsolder: Decimal) result: Decimal
    var
        SalaryHeader: Record "WDC Salary Header";
        Ind: Record "WDC Indemnities";
        SocialContributions: Record "WDC Social Contributions";
        ParamRessHum: Record "Human Resources Setup";
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        Employee: Record Employee;
        SliceImposition: Record "WDC Slices of imposition";
        temp: Decimal;
        tmp: Decimal;
        TotImpot: Decimal;
        tmp1: Decimal;
        nbr: Decimal;
        bonus: Decimal;
        SalLineEng: Record "WDC Posted Salary Lines";
        EntEng: Record "WDC Posted Salary Header";
        LigneTravail: Record "WDC Occasional Hours Recorded";
        WorkedD: Decimal;
        "Mgmt.ofLoansandAdvances": Codeunit "WDC Mgmt. Loans & Adv";
        droitconge: Record "WDC Employee's days off Entry";
        SalLineEngTmp: Record "WDC Posted Salary Lines";
        SalLineEngTmp2: Record "WDC Posted Salary Lines";
        NbreMT: Decimal;
        RecHSuppEnreg: Record "WDC Overtime hours recorded m";
        DecGJourNormal: Decimal;
        DecGJourSupp: Decimal;
        DecGJourConge: Decimal;
        DecGHeureNormal: Decimal;
        DecGHeureConge: Decimal;
        DecGHeureSupp: Decimal;
        DecGNBJourAN: Decimal;
        DecGNBHeureAN: Decimal;
        SoldeReport: Decimal;
        RecGIndemnites: Record "WDC Indemnities";
        DecMontantIdem: Decimal;
        DecGJournuit: Decimal;
        DecGheurenuit: Decimal;
        NBmoisTravaille: Decimal;
        NBMOIS: Integer;
        "RecIndemnité": Record "WDC Indemnities";
        "recindemnitéEnreg": Record "WDC Rec. Indemnities";
        DecSommeSalBase: Decimal;
        DateDeb: Date;
        EMP1: Record Employee;
        DateFin: Date;
        deductionChef: Decimal;
        TotImposable: Decimal;
    begin
        //>> Prime PrimeRendSTC
        bonus := 1;
        nbr := 12;
        SalaryHeader.GET(SalaryLine."No.");
        ParamRessHum.GET();
        ParamCpta.GET;
        EmploymentContract.RESET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        RegimeWork.RESET;
        RegimeWork.GET(SalaryLine."Employee Work Regime");
        MgmtSalary2.initLigne(SalaryLine, Sim);
        SalaryLine.Taxable := EmploymentContract.Taxable;
        CASE ParamRessHum."Monthes Number".AsInteger() OF
            0:
                nbr := EmploymentContract."Regular payments";
            1:
                nbr := EmploymentContract."Temporary payments";
            2:
                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
        END;

        DecGNBJourAN := ParamRessHum."Annual Days Number";
        DecGNBHeureAN := ParamRessHum."Annual Hours Number";
        CASE SalaryLine."Employee type".AsInteger() OF
            0:
                BEGIN
                    //Jours normal
                    IF ParamRessHum."Bonus calculation Type".AsInteger() <> 2 THEN BEGIN
                        LigneTravail.RESET;
                        LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Payment No.");
                        LigneTravail.SETRANGE("Payment Year", SalaryHeader.Year);
                        LigneTravail.SETFILTER("Payment No.", '<>%1', '');
                        LigneTravail.SETRANGE("Employee No.", SalaryLine."Employee No.");
                        LigneTravail.CALCSUMS("Hours Number");
                        DecGHeureNormal := LigneTravail."Hours Number";
                        //jour Conge
                        IF ParamRessHum."Include leave entitlement days" THEN BEGIN
                            droitconge.RESET;
                            droitconge.SETCURRENTKEY("Employee No.", "Posting month", "Posting year", "Line type", "Payment No.");
                            droitconge.SETRANGE("Posting year", SalaryHeader.Year);
                            droitconge.SETFILTER("Payment No.", '<>%1', '');
                            droitconge.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            droitconge.SETRANGE("Line type", 1);
                            droitconge.CALCSUMS("Quantity (Hours)");
                            DecGHeureConge := droitconge."Quantity (Hours)";
                        END;
                        //jours supp
                        IF ParamRessHum."Include Overtime Hours" THEN BEGIN
                            RecHSuppEnreg.RESET;
                            RecHSuppEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Posting Date", "Payment No.", "Day Type");
                            RecHSuppEnreg.SETRANGE("Payment Year", SalaryHeader.Year);
                            RecHSuppEnreg.SETFILTER("Payment No.", '<>%1', '');
                            RecHSuppEnreg.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            RecHSuppEnreg.SETRANGE("Day Type", 0);
                            RecHSuppEnreg.CALCSUMS("Hours Number");
                            DecGHeureSupp := RecHSuppEnreg."Hours Number";
                            GNbHeure := DecGHeureNormal + DecGHeureConge + DecGHeureSupp;
                        END;
                        IF ParamRessHum."Include Night Hours" THEN BEGIN
                            RecHSuppEnreg.RESET;
                            RecHSuppEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Posting Date", "Payment No.", "Day Type");
                            RecHSuppEnreg.SETRANGE("Payment Year", SalaryHeader.Year);
                            RecHSuppEnreg.SETFILTER("Payment No.", '<>%1', '');
                            RecHSuppEnreg.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            RecHSuppEnreg.SETRANGE("Day Type", 3);
                            RecHSuppEnreg.CALCSUMS("Hours Number");
                            DecGheurenuit := RecHSuppEnreg."Hours Number";
                        END;
                        GNbHeure := DecGHeureNormal + DecGHeureConge + DecGHeureSupp + DecGheurenuit;
                    END;
                    IF (ParamRessHum."Bonus calculation Type".AsInteger() = 2)
                    OR (ParamRessHum."Bonus calculation Type".AsInteger() = 6)
                    OR (ParamRessHum."Bonus calculation Type".AsInteger() = 8) THEN BEGIN
                        "RecGRec. Salary Lines".SETCURRENTKEY("Employee No.", Year, Month);
                        "RecGRec. Salary Lines".Setrange(Year, SalaryLine.Year);
                        "RecGRec. Salary Lines".SETFILTER(Month, '<%1', "RecGRec. Salary Lines".month::"13th Salary");
                        "RecGRec. Salary Lines".SETFILTER("Employee No.", SalaryLine."Employee No.");
                        "RecGRec. Salary Lines".CALCSUMS("Gross Salary", "Supp. hours", "Real basis salary");
                        DecGTotSalaireBrut := "RecGRec. Salary Lines"."Gross Salary";
                        IF (ParamRessHum."Bonus calculation Type".AsInteger() = 2) THEN
                            DecGTotSalaireBrut := "RecGRec. Salary Lines"."Gross Salary" - "RecGRec. Salary Lines"."Supp. hours";
                        IF (ParamRessHum."Bonus calculation Type".AsInteger() = 8) THEN
                            DecSommeSalBase := "RecGRec. Salary Lines"."Real basis salary"
                    END;
                END;
            //MENSUEL********************************************************************
            1:
                BEGIN
                    //jours normal
                    IF ParamRessHum."Bonus calculation Type".AsInteger() <> 2 THEN BEGIN
                        LigneTravail.RESET;
                        LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Payment No.");
                        LigneTravail.SETRANGE("Payment Year", SalaryHeader.Year);
                        LigneTravail.SETFILTER("Payment No.", '<>%1', '');
                        LigneTravail.SETRANGE("Employee No.", SalaryLine."Employee No.");
                        LigneTravail.CALCSUMS("Days Number");
                        DecGJourNormal := LigneTravail."Days Number";
                        //jour Conge
                        IF ParamRessHum."Include leave entitlement days" THEN BEGIN
                            droitconge.RESET;
                            droitconge.SETCURRENTKEY("Employee No.", "Posting month", "Posting year", "Line type", "Payment No.");
                            droitconge.SETRANGE("Posting year", SalaryHeader.Year);
                            droitconge.SETFILTER("Payment No.", '<>%1', '');
                            droitconge.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            droitconge.SETRANGE("Line type", 1);
                            droitconge.CALCSUMS("Quantity (Days)");
                            DecGJourConge := droitconge."Quantity (Days)";
                        END;
                        //jours supp
                        IF ParamRessHum."Include Overtime Hours" THEN BEGIN
                            RecHSuppEnreg.RESET;
                            RecHSuppEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Posting Date", "Payment No.", "Day Type");
                            RecHSuppEnreg.SETRANGE("Payment Year", SalaryHeader.Year);
                            RecHSuppEnreg.SETFILTER("Payment No.", '<>%1', '');
                            RecHSuppEnreg.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            RecHSuppEnreg.SETRANGE("Day Type", 0);
                            RecHSuppEnreg.CALCSUMS("Hours Number");
                            DecGJourSupp := RecHSuppEnreg."Hours Number";
                            DecGJourSupp := ROUND(DecGJourSupp * RegimeWork."Worked Day Per Month" / RegimeWork."Work Hours per month",
                                            ParamCpta."Amount Rounding Precision");
                        END;
                        // heures nuit
                        IF ParamRessHum."Include Night Hours" THEN BEGIN
                            RecHSuppEnreg.RESET;
                            RecHSuppEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Posting Date", "Payment No.", "Day Type");
                            RecHSuppEnreg.SETRANGE("Payment Year", SalaryHeader.Year);
                            RecHSuppEnreg.SETFILTER("Payment No.", '<>%1', '');
                            RecHSuppEnreg.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            RecHSuppEnreg.SETRANGE("Day Type", 3);
                            RecHSuppEnreg.CALCSUMS("Hours Number");
                            DecGJournuit := RecHSuppEnreg."Hours Number";
                            DecGJournuit := ROUND(DecGJournuit * RegimeWork."Worked Day Per Month" / RegimeWork."Work Hours per month",
                                        ParamCpta."Amount Rounding Precision");
                        END;
                        GNbJour := DecGJourNormal + DecGJourConge + DecGJourSupp + DecGJournuit;
                    END;
                    IF (ParamRessHum."Bonus calculation Type".AsInteger() = 2)
                     OR (ParamRessHum."Bonus calculation Type".AsInteger() = 6)
                     OR (ParamRessHum."Bonus calculation Type".AsInteger() = 8) THEN BEGIN
                        "RecGRec. Salary Lines".SETCURRENTKEY("Employee No.", Year, Month);
                        "RecGRec. Salary Lines".Setrange(Year, SalaryLine.Year);
                        "RecGRec. Salary Lines".SETFILTER(Month, '<%1', 17);
                        "RecGRec. Salary Lines".SETFILTER("Employee No.", SalaryLine."Employee No.");
                        "RecGRec. Salary Lines".CALCSUMS("Gross Salary", "Supp. hours", "Real basis salary");
                        DecGTotSalaireBrut := "RecGRec. Salary Lines"."Gross Salary";
                        IF (ParamRessHum."Bonus calculation Type".AsInteger() = 2) THEN
                            DecGTotSalaireBrut := "RecGRec. Salary Lines"."Gross Salary" - "RecGRec. Salary Lines"."Supp. hours";
                        IF (ParamRessHum."Bonus calculation Type".AsInteger() = 8) THEN
                            DecSommeSalBase := "RecGRec. Salary Lines"."Real basis salary"
                    END;
                END;
        END;

        GRecNote.RESET;
        GRecNote.SETFILTER(GRecNote.Year, '%1', SalaryLine.Year);
        GRecNote.SETFILTER(GRecNote."Employee No.", SalaryLine."Employee No.");
        IF GRecNote.FINDFIRST THEN BEGIN
            SalaryLine.Note := GRecNote.Note;
            SalaryLine.Purcent := GRecNote.Purcent;
        END;
        //<<   Calc Nombre Mois travaillé
        IF NBmoisTravaille = 0 THEN BEGIN
            Employee.RESET;
            Employee.SETRANGE(Employee."No.", SalaryLine."Employee No.");
            IF Employee.FINDSET THEN BEGIN

                DateDeb := DMY2DATE(1, 1, SalaryLine.Year);
                DateFin := DMY2DATE(31, 12, SalaryLine.Year);
                IF (Employee."Employment Date" < DateDeb) AND (Employee."Inactive Date" = 0D) THEN
                    NBmoisTravaille := nbr
                ELSE BEGIN
                    IF Employee."Inactive Date" <> 0D THEN
                        NBmoisTravaille := ((Employee."Inactive Date" - DateDeb) / 30)
                    ELSE
                        NBmoisTravaille := ((DateFin - Employee."Employment Date") / 30);
                END;
            END;
        END;
        IF NBmoisTravaille > EmploymentContract."Regular payments" THEN
            NBmoisTravaille := EmploymentContract."Regular payments";

        RecIndemnité.RESET;
        RecIndemnité.SETFILTER(RecIndemnité.Type, '%1', RecIndemnité.Type::Imposable);
        IF RecIndemnité.FINDFIRST THEN
            REPEAT
                DecMontantIdem := DecMontantIdem + RecIndemnité."Base Amount";
            UNTIL RecIndemnité.NEXT = 0;

        SalaryLine.Purcent := GRecNote.Purcent;
        SalaryLine.Note := GRecNote.Note;
        //>>   CalcPaiedDay
        SalaryLine."Paied days" := NBmoisTravaille;
        //<<    CalcPaiedDay
        IF SalaryLine."Employee type".AsInteger() = 1 THEN BEGIN
            SalaryLine."Real basis salary" := ROUND((((SalaryLine."Basis salary")
                                                  * GRecNote.Purcent / 100)
                                              * NBmoisTravaille) / EmploymentContract."Regular payments"

                                              , ParamCpta."Amount Rounding Precision");
            SalaryLine."Taxable indemnities" := ROUND(((DecMontantIdem
                                                * GRecNote.Purcent / 100
                                                )
                                                * NBmoisTravaille / EmploymentContract."Regular payments")
                                                ,
                                               ParamCpta."Amount Rounding Precision");
            SalaryLine."Gross Salary" := ROUND(((SalaryLine."Real basis salary" + SalaryLine."Taxable indemnities"))
                                              , ParamCpta."Amount Rounding Precision");
        END ELSE BEGIN
            SalaryLine."Real basis salary" := ROUND((((SalaryLine."Basis salary") * RegimeWork."Work Hours per month"
                                                  * GRecNote.Purcent / 100)
                                              * NBmoisTravaille) / EmploymentContract."Regular payments"

                                              , ParamCpta."Amount Rounding Precision");

            SalaryLine."Taxable indemnities" := ROUND(((DecMontantIdem
                                                * GRecNote.Purcent / 100
                                                )
                                                * NBmoisTravaille / nbr)
                                                ,
                                               ParamCpta."Amount Rounding Precision");

            SalaryLine."Gross Salary" := ROUND(((SalaryLine."Real basis salary" + SalaryLine."Taxable indemnities"))
                                              , ParamCpta."Amount Rounding Precision");
        END;
        result := SalaryLine."Gross Salary";
        //<< Prime PrimeRendSTC
    end;

    procedure CalcLineBonus13EMESTC(SalaryLine: Record "WDC Salary Lines"; "SolderDroitCongé": Boolean; Sim: Option Simulation,Real; nbjsolder: Decimal) result: Decimal
    var
        SalaryHeader: Record "WDC Salary Header";
        Ind: Record "WDC Indemnities";
        SocialContributions: Record "WDC Social Contributions";
        ParamRessHum: Record "Human Resources Setup";
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        Employee: Record Employee;
        SalaryLine13eme: Record "WDC Salary Lines";
        SliceImposition: Record "WDC Slices of imposition";
        SliceImpositionX: Record "WDC Slices of imposition";
        temp: Decimal;
        tmp: Decimal;
        HasPrime13eme: Boolean;
        HasPrimeRend: Boolean;
        tmp1: Decimal;
        Cot: Record "WDC Default Soc. Contribution";
        TotImpot: Decimal;
        NbrPaie: Decimal;
        nbr: Decimal;
        bonus: Decimal;
        SalLineEng: Record "WDC Salary Lines";
        LigneTravail: Record "WDC Occasional Hours Recorded";
        "Mgmt.ofLoansandAdvances": Codeunit "WDC Mgmt. Loans & Adv";
        droitconge: Record "WDC Employee's days off Entry";
        SalLineEngTmp: Record "WDC Salary Lines";
        SalLineEngTmp2: Record "WDC Salary Lines";
        NbreMT: Decimal;
        RecHSuppEnreg: Record "WDC Overtime hours recorded m";
        DecGJourNormal: Decimal;
        DecGJourSupp: Decimal;
        DecGJourConge: Decimal;
        DecGHeureNormal: Decimal;
        DecGHeureConge: Decimal;
        DecGHeureSupp: Decimal;
        DecGNBJourAN: Decimal;
        DecGNBHeureAN: Decimal;
        SoldeReport: Decimal;
        RecGIndemnites: Record "WDC Indemnities";
        DecMontantIdem: Decimal;
        DecGJournuit: Decimal;
        DecGheurenuit: Decimal;
        NBmoisTravaille: Decimal;
        NBMOIS: Integer;
        "RecIndemnité": Record "WDC Indemnities";
        "recindemnitéEnreg": Record "WDC Rec. Indemnities";
        DecSommeSalBase: Decimal;
        DateDeb: Date;
        EMP1: Record Employee;
        DateFin: Date;
        deductionChef: Decimal;
        TotImposable: Decimal;
    begin

        //>> Prime 13emeSTC
        SalaryLine13eme.TRANSFERFIELDS(SalaryLine);

        bonus := 1;
        nbr := 12;
        SalaryHeader.GET(SalaryLine."No.");
        ParamRessHum.GET();
        ParamCpta.GET;
        EmploymentContract.RESET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        RegimeWork.RESET;
        RegimeWork.GET(SalaryLine."Employee Work Regime");
        MgmtSalary2.initLigne(SalaryLine, Sim);
        SalaryLine.Taxable := EmploymentContract.Taxable;
        CASE ParamRessHum."Monthes Number".AsInteger() OF
            0:
                nbr := EmploymentContract."Regular payments";
            1:
                nbr := EmploymentContract."Temporary payments";
            2:
                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
        END;

        DecGNBJourAN := ParamRessHum."Annual Days Number";
        DecGNBHeureAN := ParamRessHum."Annual Hours Number";
        CASE SalaryLine."Employee type".AsInteger() OF
            0:
                BEGIN
                    //Jours normal
                    IF ParamRessHum."Bonus calculation Type".AsInteger() <> 2 THEN BEGIN
                        LigneTravail.RESET;
                        LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Payment No.");
                        LigneTravail.SETRANGE("Payment Year", SalaryHeader.Year);
                        LigneTravail.SETFILTER("Payment No.", '<>%1', '');
                        LigneTravail.SETRANGE("Employee No.", SalaryLine."Employee No.");
                        LigneTravail.CALCSUMS("Hours Number");
                        DecGHeureNormal := LigneTravail."Hours Number";
                        //jour Conge
                        IF ParamRessHum."Include leave entitlement days" THEN BEGIN
                            droitconge.RESET;
                            droitconge.SETCURRENTKEY("Employee No.", "Posting month", "Posting year", "Line type", "Payment No.");
                            droitconge.SETRANGE("Posting year", SalaryHeader.Year);
                            droitconge.SETFILTER("Payment No.", '<>%1', '');
                            droitconge.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            droitconge.SETRANGE("Line type", 1);
                            droitconge.CALCSUMS("Quantity (Hours)");
                            DecGHeureConge := droitconge."Quantity (Hours)";
                        END;
                        //jours supp
                        IF ParamRessHum."Include Overtime Hours" THEN BEGIN
                            RecHSuppEnreg.RESET;
                            RecHSuppEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Posting Date", "Payment No.", "Day Type");
                            RecHSuppEnreg.SETRANGE("Payment Year", SalaryHeader.Year);
                            RecHSuppEnreg.SETFILTER("Payment No.", '<>%1', '');
                            RecHSuppEnreg.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            RecHSuppEnreg.SETRANGE("Day Type", 0);
                            RecHSuppEnreg.CALCSUMS("Hours Number");
                            DecGHeureSupp := RecHSuppEnreg."Hours Number";
                            GNbHeure := DecGHeureNormal + DecGHeureConge + DecGHeureSupp;
                        END;
                        IF ParamRessHum."Include Night Hours" THEN BEGIN
                            RecHSuppEnreg.RESET;
                            RecHSuppEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Posting Date", "Payment No.", "Day Type");
                            RecHSuppEnreg.SETRANGE("Payment Year", SalaryHeader.Year);
                            RecHSuppEnreg.SETFILTER("Payment No.", '<>%1', '');
                            RecHSuppEnreg.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            RecHSuppEnreg.SETRANGE("Day Type", 3);
                            RecHSuppEnreg.CALCSUMS("Hours Number");
                            DecGheurenuit := RecHSuppEnreg."Hours Number";
                        END;
                        GNbHeure := DecGHeureNormal + DecGHeureConge + DecGHeureSupp + DecGheurenuit;
                    END;
                    IF (ParamRessHum."Bonus calculation Type".AsInteger() = 2)
                    OR (ParamRessHum."Bonus calculation Type".AsInteger() = 6)
                    OR (ParamRessHum."Bonus calculation Type".AsInteger() = 8) THEN BEGIN
                        "RecGRec. Salary Lines".SETCURRENTKEY("Employee No.", Year, Month);
                        "RecGRec. Salary Lines".Setrange(Year, SalaryLine.Year);
                        "RecGRec. Salary Lines".SETFILTER(Month, '<%1', "RecGRec. Salary Lines".month::"13th Salary");
                        "RecGRec. Salary Lines".SETFILTER("Employee No.", SalaryLine."Employee No.");
                        "RecGRec. Salary Lines".CALCSUMS("Gross Salary", "Supp. hours", "Real basis salary");
                        DecGTotSalaireBrut := "RecGRec. Salary Lines"."Gross Salary";
                        IF (ParamRessHum."Bonus calculation Type".AsInteger() = 2) THEN
                            DecGTotSalaireBrut := "RecGRec. Salary Lines"."Gross Salary" - "RecGRec. Salary Lines"."Supp. hours";
                        IF (ParamRessHum."Bonus calculation Type".AsInteger() = 8) THEN
                            DecSommeSalBase := "RecGRec. Salary Lines"."Real basis salary"
                    END;
                END;
            //MENSUEL********************************************************************
            1:
                BEGIN
                    //jours normal
                    IF ParamRessHum."Bonus calculation Type".AsInteger() <> 2 THEN BEGIN


                        LigneTravail.RESET;
                        LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Payment No.");
                        LigneTravail.SETRANGE("Payment Year", SalaryHeader.Year);
                        LigneTravail.SETFILTER("Payment No.", '<>%1', '');
                        LigneTravail.SETRANGE("Employee No.", SalaryLine."Employee No.");
                        LigneTravail.CALCSUMS("Days Number");
                        DecGJourNormal := LigneTravail."Days Number";
                        //jour Conge
                        IF ParamRessHum."Include leave entitlement days" THEN BEGIN
                            droitconge.RESET;
                            droitconge.SETCURRENTKEY("Employee No.", "Posting month", "Posting year", "Line type", "Payment No.");
                            droitconge.SETRANGE("Posting year", SalaryHeader.Year);
                            droitconge.SETFILTER("Payment No.", '<>%1', '');
                            droitconge.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            droitconge.SETRANGE("Line type", 1);
                            droitconge.CALCSUMS("Quantity (Days)");
                            DecGJourConge := droitconge."Quantity (Days)";
                        END;
                        //jours supp
                        IF ParamRessHum."Include Overtime Hours" THEN BEGIN
                            RecHSuppEnreg.RESET;
                            RecHSuppEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Posting Date", "Payment No.", "Day Type");
                            RecHSuppEnreg.SETRANGE("Payment Year", SalaryHeader.Year);
                            RecHSuppEnreg.SETFILTER("Payment No.", '<>%1', '');
                            RecHSuppEnreg.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            RecHSuppEnreg.SETRANGE("Day Type", 0);
                            RecHSuppEnreg.CALCSUMS("Hours Number");
                            DecGJourSupp := RecHSuppEnreg."Hours Number";
                            DecGJourSupp := ROUND(DecGJourSupp * RegimeWork."Worked Day Per Month" / RegimeWork."Work Hours per month",
                                            ParamCpta."Amount Rounding Precision");
                        END;
                        // heures nuit
                        IF ParamRessHum."Include Night Hours" THEN BEGIN
                            RecHSuppEnreg.RESET;
                            RecHSuppEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", "Posting Date", "Payment No.", "Day Type");
                            RecHSuppEnreg.SETRANGE("Payment Year", SalaryHeader.Year);
                            RecHSuppEnreg.SETFILTER("Payment No.", '<>%1', '');
                            RecHSuppEnreg.SETRANGE("Employee No.", SalaryLine."Employee No.");
                            RecHSuppEnreg.SETRANGE("Day Type", 3);
                            RecHSuppEnreg.CALCSUMS("Hours Number");
                            DecGJournuit := RecHSuppEnreg."Hours Number";
                            DecGJournuit := ROUND(DecGJournuit * RegimeWork."Worked Day Per Month" / RegimeWork."Work Hours per month",
                                        ParamCpta."Amount Rounding Precision");
                        END;
                        GNbJour := DecGJourNormal + DecGJourConge + DecGJourSupp + DecGJournuit;
                    END;
                    IF (ParamRessHum."Bonus calculation Type".AsInteger() = 2)
                     OR (ParamRessHum."Bonus calculation Type".AsInteger() = 6)
                     OR (ParamRessHum."Bonus calculation Type".AsInteger() = 8) THEN BEGIN
                        "RecGRec. Salary Lines".SETCURRENTKEY("Employee No.", Year, Month);
                        "RecGRec. Salary Lines".Setrange(Year, SalaryLine.Year);
                        "RecGRec. Salary Lines".SETFILTER(Month, '<%1', 17);
                        "RecGRec. Salary Lines".SETFILTER("Employee No.", SalaryLine."Employee No.");
                        "RecGRec. Salary Lines".CALCSUMS("Gross Salary", "Supp. hours", "Real basis salary");
                        DecGTotSalaireBrut := "RecGRec. Salary Lines"."Gross Salary";
                        IF (ParamRessHum."Bonus calculation Type".AsInteger() = 2) THEN
                            DecGTotSalaireBrut := "RecGRec. Salary Lines"."Gross Salary" - "RecGRec. Salary Lines"."Supp. hours";
                        IF (ParamRessHum."Bonus calculation Type".AsInteger() = 8) THEN
                            DecSommeSalBase := "RecGRec. Salary Lines"."Real basis salary"
                    END;
                END;
        END;

        //<<   Calc Nombre Mois travaillé
        IF NBmoisTravaille = 0 THEN BEGIN
            Employee.RESET;
            Employee.SETRANGE(Employee."No.", SalaryLine."Employee No.");
            IF Employee.FINDSET THEN BEGIN

                DateDeb := DMY2DATE(1, 1, SalaryLine13eme.Year);
                DateFin := DMY2DATE(31, 12, SalaryLine13eme.Year);
                BEGIN
                    IF Employee."Inactive Date" <> 0D THEN
                        NBmoisTravaille := ((Employee."Inactive Date" - DateDeb) / 30)
                    ELSE
                        NBmoisTravaille := ((DateFin - Employee."Employment Date") / 30);
                END;
            END;
        END;
        IF NBmoisTravaille > EmploymentContract."Regular payments" THEN
            NBmoisTravaille := EmploymentContract."Regular payments";

        //>>  Calc Nombre Mois travaillé
        //
        // calcul montant des primes
        RecIndemnité.RESET;
        IF RecIndemnité.FINDSET THEN
            REPEAT
                DecMontantIdem := DecMontantIdem + RecIndemnité."Base Amount";
            UNTIL RecIndemnité.NEXT = 0;
        CASE SalaryLine13eme."Employee type".AsInteger() OF
            0:
                BEGIN
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 0 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND((SalaryLine13eme."Basis salary" *
                                                          (GNbHeure * RegimeWork."Work Hours per month") / (DecGNBHeureAN)) * (GRecNote.Purcent / 100)
                                                          , ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Taxable indemnities" := ROUND(DecMontantIdem, ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 1 THEN BEGIN
                        SalaryLine13eme.Purcent := ROUND((GNbHeure * GRecNote.Note) / (20 * DecGNBHeureAN), ParamCpta."Amount Rounding Precision"
                );
                        SalaryLine13eme."Real basis salary" := ROUND(SalaryLine13eme."Basis salary" *
                                                          (GNbJour / DecGNBJourAN) * (GRecNote.Purcent / 100)
                                                          , ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Taxable indemnities" := ROUND(DecMontantIdem, ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 2 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND((DecGTotSalaireBrut
                                                          ) * (GRecNote.Purcent / 100)
                                                          , ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary", ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 3 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND((SalaryLine13eme."Basis salary" *
                                                          (GNbHeure * RegimeWork."Work Hours per month") / (DecGNBHeureAN)) * (GRecNote.Purcent / 100)
                                                          , ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Taxable indemnities" := ROUND(DecMontantIdem, ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 4 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND(SalaryLine13eme."Basis salary" * RegimeWork."From Work day to Work hour" * 22
                                                          * (GRecNote.Note / 20)
                                                          , ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Taxable indemnities" := ROUND(DecMontantIdem, ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 5 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND(((((SalaryLine13eme."Basis salary") +
                                                                (DecMontantIdem / RegimeWork."Work Hours per month"))
                                                                ) * 2 * ParamRessHum."From Work day to Work hour"
                                                          * GRecNote.Note * NBmoisTravaille / nbr)
                                                          , ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Taxable indemnities" := 0;
                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 6 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND((DecGTotSalaireBrut
                                                          ) * (10 / 100)
                                                          , ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary", ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 7 THEN BEGIN
                        SalaryLine13eme.Purcent := GRecNote.Purcent;
                        SalaryLine13eme."Real basis salary" := ROUND(((((SalaryLine13eme."Basis salary")
                                                              * (RegimeWork."Work Hours per month"
                                                             )
                                                          * NBmoisTravaille) / nbr) / 2), ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Taxable indemnities" := ROUND((((DecMontantIdem / RegimeWork."Work Hours per month") *
                                                            (RegimeWork."Work Hours per month")
                                                            * NBmoisTravaille / nbr) / 2),
                                                           ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Real basis salary" := ROUND(SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"
                                                         , ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary"
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 8 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND(((DecSommeSalBase + DecMontantIdem)
                                                          * GRecNote.Purcent / 100)
                                                          , ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary", ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 9 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND(
                                                         ((8 * SalaryLine13eme."Basis salary" * 22) +
                                                           ((DecMontantIdem / 26) * 22))
                                                          * (GRecNote.Note / 20)
                                                          , ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary", ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 10 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND(
                                                          ((SalaryLine13eme."Basis salary" * 8) +
                                                           (DecMontantIdem / RegimeWork."Worked Day Per Month"))
                                                          * (GRecNote.Note
                                                          )
                                                          , ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary", ParamCpta."Amount Rounding Precision");
                    END;
                END;
            1:
                BEGIN
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 0 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND(SalaryLine13eme."Basis salary" *
                                                          (GNbJour / DecGNBJourAN) * (GRecNote.Purcent / 100)
                                                          , ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Taxable indemnities" := ROUND(DecMontantIdem, ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 1 THEN BEGIN
                        SalaryLine13eme.Purcent := ROUND((GNbJour * GRecNote.Note) / (20 * DecGNBJourAN), ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Real basis salary" := ROUND(SalaryLine13eme."Basis salary" *
                                                          (GNbJour / DecGNBJourAN) * (GRecNote.Purcent / 100)
                                                          , ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Taxable indemnities" := ROUND(DecMontantIdem, ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 2 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND((DecGTotSalaireBrut) * (GRecNote.Purcent / 100)
                                                          , ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary", ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 3 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND(SalaryLine13eme."Basis salary" *
                                                          (GNbJour / DecGNBJourAN) * (GRecNote.Purcent / 100)
                                                          , ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Taxable indemnities" := ROUND(DecMontantIdem, ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 4 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND(SalaryLine13eme."Basis salary" *
                                                          (22 / RegimeWork."Worked Day Per Month") * (GRecNote.Note / 20)
                                                          , ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Taxable indemnities" := ROUND(DecMontantIdem, ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 5 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND((
                                                          ((SalaryLine13eme."Basis salary" + DecMontantIdem) / RegimeWork."Work Hours per month")
                                                          * 2 * ParamRessHum."From Work day to Work hour" *
                                                          GRecNote.Note * (NBmoisTravaille / nbr))
                                                          , ParamCpta."Amount Rounding Precision");
                        SalaryLine13eme."Taxable indemnities" := 0;

                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 6 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND((DecGTotSalaireBrut
                                                          ) * (10 / 100)
                                                          , ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary", ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 7 THEN BEGIN

                        SalaryLine13eme."Real basis salary" := ROUND(((((SalaryLine13eme."Basis salary" / RegimeWork."Worked Day Per Month")
                                                              * (RegimeWork."Worked Day Per Month")
                                                          * NBmoisTravaille) / nbr
                                                         )
                                                          / 2), ParamCpta."Amount Rounding Precision");
                        //>>    CalcPaiedDay
                        SalaryLine13eme."Paied days" := NBmoisTravaille;
                        //<<    CalcPaiedDay
                        SalaryLine13eme."Taxable indemnities" := ROUND((((DecMontantIdem / RegimeWork."Worked Day Per Month") *
                                                            (RegimeWork."Worked Day Per Month")
                                                            * NBmoisTravaille / nbr)),
                                                           ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Gross Salary" := ROUND(((SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"))
                                                          , ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 8 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND(((DecSommeSalBase + DecMontantIdem)
                                                          * GRecNote.Purcent / 100)
                                                          , ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary", ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 9 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND(((
                                                           (SalaryLine13eme."Basis salary" +
                                                           DecMontantIdem) / RegimeWork."Worked Day Per Month") * 22)
                                                          * (GRecNote.Note / 20)
                                                          , ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary", ParamCpta."Amount Rounding Precision");
                    END;
                    IF ParamRessHum."Bonus calculation Type".AsInteger() = 10 THEN BEGIN
                        SalaryLine13eme."Real basis salary" := ROUND((
                                                           (SalaryLine13eme."Basis salary" +
                                                           DecMontantIdem) / RegimeWork."Worked Day Per Month")
                                                          * (GRecNote.Note)
                                                          , ParamCpta."Amount Rounding Precision");

                        SalaryLine13eme."Gross Salary" := ROUND(SalaryLine13eme."Real basis salary", ParamCpta."Amount Rounding Precision");
                    END;
                END;
        END;
        IF SalaryLine13eme."Employee type".AsInteger() = 1 THEN BEGIN
            SalaryLine13eme."Real basis salary" := ROUND((((SalaryLine13eme."Basis salary"
                                              * NBmoisTravaille) / EmploymentContract."Regular payments"
                                             )
                                              ), ParamCpta."Amount Rounding Precision");
            //>>    CalcPaiedDay
            SalaryLine13eme."Paied days" := NBmoisTravaille;
            //<<    CalcPaiedDay
            SalaryLine13eme."Taxable indemnities" := ROUND(((DecMontantIdem
                                        * NBmoisTravaille / EmploymentContract."Regular payments")),
                                       ParamCpta."Amount Rounding Precision");

            SalaryLine13eme."Gross Salary" := ROUND(((SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"))
                                              , ParamCpta."Amount Rounding Precision");
        END ELSE BEGIN
            SalaryLine13eme."Real basis salary" := ROUND((((SalaryLine13eme."Basis salary" * RegimeWork."Work Hours per month"
                                              * NBmoisTravaille) / EmploymentContract."Regular payments"
                                             )
                                              ), ParamCpta."Amount Rounding Precision");
            //>>    CalcPaiedDay
            SalaryLine13eme."Paied days" := NBmoisTravaille;
            //<<    CalcPaiedDay
            SalaryLine13eme."Taxable indemnities" := ROUND(((DecMontantIdem
                                        * NBmoisTravaille / EmploymentContract."Regular payments")),
                                       ParamCpta."Amount Rounding Precision");

            SalaryLine13eme."Gross Salary" := ROUND(((SalaryLine13eme."Real basis salary" + SalaryLine13eme."Taxable indemnities"))
                                              , ParamCpta."Amount Rounding Precision");
        END;

        result := SalaryLine13eme."Gross Salary";
    end;

    procedure CreateSalaryLineSimulation(SalaryHeader: Record "WDC Salary Header"; Employee: Record Employee; Sim: Option Simulation,Real) OK: Boolean
    var
        EmploymentContract: Record "Employment Contract";
        err1: TextConst ENU = 'Regime of work empty on Employment contract : %1',
                        FRA = 'Code de régime de travail vide sur le Contrat de travail : %1';
        err2: TextConst ENU = 'Employment contract empty for the employee : %1',
                        FRA = 'Contrat de travail vide pour l''employé : %1';
        DefaultSocContribution: Record "WDC Default Soc. Contribution";
        SocialContributions: Record "WDC Social Contributions";
        SocialContribution: Record "WDC Social Contribution";
        DefaultIndemnities: Record "WDC Default Indemnities";
        Indemnities: Record "WDC Indemnities";
        confMess: TextConst ENU = 'Replace the existing line ?', FRA = 'Remplacer la ligne existante ?';
        nbr: Decimal;
        ParamRessHum: Record "Human Resources Setup";
        dateD: Date;
        SB: Decimal;
        DateF: Date;
        NBJ: Decimal;
        DefaultIndemnitiesTmp: Record "WDC Default Indemnities";
        MntInd: Decimal;
        err3: TextConst ENU = 'Tax bracket code empty on Employment contract : %1', FRA = 'Code tranche d''imposition vide sur Contrat de travail : %1';
        regimeofwork: Record "WDC work Regimes";
        RecHeureSupplEnreg: Record "WDC Overtime hours recorded m";
        LoanAD: Record "WDC Loan & Advance";
        SalaryLine: Record "WDC Salary Lines";
    begin

        SalaryLine.RESET;
        Employee.MAJDeductions;
        ParamCpta.GET;
        SalaryLine.SETRANGE("No.", SalaryHeader."No.");
        SalaryLine.SETRANGE("Employee No.", Employee."No.");
        IF SalaryLine.FINDFIRST THEN BEGIN
            IF CONFIRM(confMess + '\%1\', FALSE, SalaryLine."No." + ' : ' + SalaryLine.Name)
              THEN
                DeleteLineSimu(SalaryLine)
            ELSE
                EXIT(FALSE);
        END;


        SalaryLine.INIT;

        ParamRessHum.GET();
        SalaryLine."No." := SalaryHeader."No.";
        SalaryLine."Employee No." := Employee."No.";
        SalaryLine.Name := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
        SalaryLine."Employee Posting Group" := Employee."Empl. Posting Group";
        SalaryLine."Statistics Group Code" := Employee."Statistics Group Code";
        SalaryLine."Global Dimension 1" := Employee."Global Dimension 1 Code";
        SalaryLine."Global Dimension 2" := Employee."Global Dimension 2 Code";
        //>>          -Liaison d'integration  paie en compta avec AX
        SalaryLine."Posting Date" := SalaryHeader."Posting Date";
        IF Employee."Emplymt. Contract Code" <> '' THEN BEGIN
            EmploymentContract.GET(Employee."Emplymt. Contract Code");
            SalaryLine."Emplymt. Contract Code" := Employee."Emplymt. Contract Code";
            IF EmploymentContract."Work Regime" <> '' THEN
                SalaryLine."Employee Work Regime" := EmploymentContract."Work Regime"
            ELSE
                ERROR(err1, EmploymentContract.Code + ' - ' + EmploymentContract.Description);
            IF EmploymentContract.Taxable THEN
                IF EmploymentContract."Slice of imposition" = '' THEN
                    ERROR(err3, EmploymentContract.Code + ' - ' + EmploymentContract.Description);
        END ELSE
            ERROR(err2, Employee."No." + ' - ' + Employee."First Name" + ' ' + Employee."Last Name");
        CLEAR(Bnk);
        IF Employee."Default Bank Account Code" <> '' THEN
            Bnk.GET(Employee."No.", Employee."Default Bank Account Code");
        SalaryLine."Account No." := Bnk."Bank Account No.";
        SalaryLine.Description := SalaryHeader.Description;
        SalaryLine.Month := SalaryHeader.Month;
        SalaryLine.Year := SalaryHeader.Year;
        CASE DATE2DMY(SalaryHeader."Posting Date", 2) OF
            1, 2, 3:
                SalaryLine.Trimestre := SalaryLine.Trimestre::"1St";
            4, 5, 6:
                SalaryLine.Trimestre := SalaryLine.Trimestre::"2nd";
            7, 8, 9:
                SalaryLine.Trimestre := SalaryLine.Trimestre::"3rd";
            10, 11, 12:
                SalaryLine.Trimestre := SalaryLine.Trimestre::"4th";
        END;
        SalaryLine."Bank Account Code" := Employee."Default Bank Account Code";
        SalaryLine."Employee type" := Employee."Employee type";
        SalaryLine."Company Bank Account No." := Employee."Company Bank Account No.";
        SalaryLine."Adjustment of absences" := 0;
        SalaryLine."Assiduity (Paid days)" := 0;
        SalaryLine."Assiduity (Worked days)" := 0;
        SalaryLine.Note := 0;
        SalaryLine.Purcent := 0;
        SalaryLine.Charge := Employee.Charge;
        SalaryLine.Management := Employee.Management;
        SalaryLine.Service := Employee.Service;
        SalaryLine.Section := Employee.Section;
        SalaryLine."Amount Days Off balacement" := 0;
        SalaryLine.Holiday := 0;
        SalaryLine."Assiduity (days off balacement" := 0;
        SalaryLine."Worked Months" := EmploymentContract."Regular payments";
        SalaryLine."Statistics Group Code" := Employee."Statistics Group Code";
        SalaryLine."Employee Contract Type" := Employee."Employee Contract Type";
        SalaryLine."CNSS No." := Employee."Social Security No.";
        SalaryLine."CIN No." := Employee."CIN No.";
        SalaryLine."Payment Method Code" := Employee."Payment Method Code";
        SalaryLine."Report en -" := Employee."Report Employee en -";
        Bnk.RESET;
        Bnk.SETRANGE(Code, Employee."Default Bank Account Code");
        IF Bnk.FINDFIRST THEN
            SalaryLine."Salary RIB" := Bnk."Bank Branch No." + Bnk."Agency Code" + Bnk."Bank Account No." + FORMAT(Bnk."RIB Key");
        Carr.RESET;
        Carr.SETCURRENTKEY("Employee No.", "Decision Date");
        SB := 0;
        NBJ := 0;

        MntInd := 0;
        IF SalaryLine."Posting Date" = 0D THEN
            SalaryLine."Posting Date" := WORKDATE;
        IF Employee."Currency Code" <> '' THEN BEGIN
            DefaultIndemnitiesTmp.RESET;
            DefaultIndemnitiesTmp.SETFILTER("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
            DefaultIndemnitiesTmp.SETRANGE("Evaluation mode", 1, 2);
            DefaultIndemnitiesTmp.SETRANGE("Indemnity Type", 0);
            IF DefaultIndemnitiesTmp.FINDFIRST THEN
                REPEAT
                    MntInd := MntInd + DefaultIndemnitiesTmp."Default amount";
                UNTIL DefaultIndemnitiesTmp.NEXT = 0;
        END;

        TotAbs := 0;
        TotHeuresEnreg := 0;
        DiffHours := 0;
        IF SalaryLine."Employee No." <> '' THEN BEGIN
            IF Sim = 1 THEN BEGIN
                Carr.ASCENDING;
                Carr.SETCURRENTKEY("Employee No.", "Posting Date");
                Carr.SETFILTER("Employee No.", SalaryLine."Employee No.");
                IF ParamRessHum."Payroll Calculation Date" <> 0 THEN BEGIN
                    IF DATE2DMY(SalaryHeader."Posting Date", 2) = 1 THEN
                        dateD := DMY2DATE(ParamRessHum."Payroll Calculation Date" + 1, 12, SalaryHeader.Year - 1)
                    ELSE
                        IF SalaryHeader.Month.AsInteger() <> 1 THEN
                            DateF := DMY2DATE(ParamRessHum."Payroll Calculation Date", DATE2DMY(SalaryHeader."Posting Date", 2), SalaryHeader.Year)
                        ELSE
                            DateF := DMY2DATE(28, DATE2DMY(SalaryHeader."Posting Date", 2), SalaryHeader.Year);
                    dateD := DMY2DATE(ParamRessHum."Payroll Calculation Date" + 1, DATE2DMY(SalaryHeader."Posting Date", 2) - 1, SalaryHeader.Year);
                END ELSE BEGIN
                    dateD := DMY2DATE(1, DATE2DMY(SalaryHeader."Posting Date", 2), SalaryHeader.Year);
                    DateF := CALCDATE('<+CM>', dateD);
                END;

                Carr.SETRANGE("Posting Date", dateD, DateF);
                Carr.SETFILTER("Base Salary", '<>0');
                NBJ := (DateF - dateD) + 1;
                IF Carr.COUNT <> 0 THEN BEGIN
                    Carr.SETRANGE("Posting Date", dateD, DateF);
                    IF Carr.FINDFIRST THEN BEGIN  // RAMZI
                        Carr.SETRANGE("Posting Date", 0D, DateF);
                        REPEAT
                            IF Carr."Posting Date" > dateD THEN BEGIN
                                BEGIN
                                    IF Carr."Base Salary" <> 0 THEN
                                        SB := ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code",

                                              Carr."Base Salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code")) -
                                              MntInd, ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        SB := ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code",
                                              Carr."Base Salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code"))
                                              , ParamCpta."Amount Rounding Precision");
                                END;
                            END
                            ELSE BEGIN
                                IF Carr."Currency Code" = '' THEN
                                    SB := Carr."Base Salary"
                                ELSE BEGIN
                                    IF Carr."Gross Salary" <> 0 THEN
                                        SB := ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code",
                                              Carr."Gross Salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code")) -
                                              MntInd, ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        SB := ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code",
                                              Carr."Base Salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Carr."Currency Code"))
                                              , ParamCpta."Amount Rounding Precision");
                                END;
                            END;
                            DateF := CALCDATE('<-1J>', Carr."Posting Date");
                        UNTIL (Carr.NEXT = 0) OR (DateF <= dateD);
                    END;
                END;
            END;
            IF SB <> 0 THEN
                SalaryLine."Basis salary" := SB
            ELSE BEGIN
                IF Employee."Currency Code" = '' THEN
                    SalaryLine."Basis salary" := Employee."Basis salary"
                ELSE BEGIN
                    IF Employee."Gross Salary" <> 0 THEN
                        SalaryLine."Basis salary" :=
                           ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code",
                              Employee."Gross Salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code")
                  ) -
                              MntInd, ParamCpta."Amount Rounding Precision")
                    ELSE
                        SalaryLine."Basis salary" :=
                             ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code",
                              Employee."Basis salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code")
                  )
                              , ParamCpta."Amount Rounding Precision");
                END;
            END;
        END;
        IF (Sim = 0) THEN
            SalaryLine."Basis salary" := Employee."Basis salary";

        EmploymentContract.RESET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        nbr := 12;
        CASE ParamRessHum."Monthes Number".AsInteger() OF
            0:
                nbr := EmploymentContract."Regular payments";
            1:
                nbr := EmploymentContract."Temporary payments";
            2:
                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
        END;
        IF TRUE THEN BEGIN
            IF (Employee."Family chief") AND NOT (Employee.Abattement) THEN
                SalaryLine."Deduction Family chief" := ROUND(ParamRessHum."Deduction for Familly Chief" / nbr,
                                                      ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLine."Deduction Family chief" := 0;
            Employee.CALCFIELDS("Deduction Loaded child");
            SalaryLine."Deduction Loaded child" := ROUND(Employee."Deduction Loaded child" / nbr,
                                                    ParamCpta."Amount Rounding Precision");
        END
        ELSE BEGIN
            SalaryLine."Deduction Family chief" := 0;
            SalaryLine."Deduction Loaded child" := 0;
        END;
        SalaryLine."Deduction Prof. expenses" := 0;
        CalculerFieldsPaie(SalaryLine, Sim);
        IF SalaryLine.INSERT THEN BEGIN
            // Liste des indemnités du salarié en cour
            DefaultIndemnities.SETRANGE("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
            IF (SalaryLine.Month.AsInteger() > 12) THEN
                DefaultIndemnities.SETRANGE("Indemnity Type", 0);
            IF (SalaryLine.Month.AsInteger() = 14) THEN
                DefaultIndemnities.SETRANGE("Application Month", FORMAT(14));
            IF DefaultIndemnities.FINDFIRST THEN
                REPEAT
                    found := FALSE;
                    SH.SETFILTER(Month, '%1', SalaryLine.Month);
                    IF SH.FINDFIRST THEN
                        REPEAT
                            IF SH."No." = SH."No." THEN
                                found := TRUE;
                        UNTIL SH.NEXT = 0;
                    IF found THEN BEGIN
                        Indemnities.INIT;
                        Indemnities."No." := SalaryLine."No.";
                        Indemnities."Employee No." := SalaryLine."Employee No.";
                        Indemnities.Indemnity := DefaultIndemnities."Indemnity Code";
                        Indemnities."Employee Posting Group" := SalaryLine."Employee Posting Group";
                        Indemnities."Global Dimension 1" := SalaryLine."Global Dimension 1";
                        Indemnities."Global Dimension 2" := SalaryLine."Global Dimension 2";
                        Indemnities."Employee Statistic Group" := SalaryLine."Statistics Group Code";
                        Indemnities.Management := SalaryLine.Management;
                        Indemnities.service := SalaryLine.Service;
                        Indemnities.section := SalaryLine.Section;
                        Indemnities.Description := DefaultIndemnities.Description;
                        Indemnities.Type := DefaultIndemnities.Type;
                        Indemnities."Evaluation mode" := DefaultIndemnities."Evaluation mode";
                        Indemnities."Indemnity Type" := DefaultIndemnities."Indemnity Type";
                        Indemnities."Not Included in Bonus" := DefaultIndemnities."Not Included in Bonus";
                        Indemnities."Amount Rounding Precision" := DefaultIndemnities."Amount Rounding Precision";
                        Indemnities."Rounding Direction" := DefaultIndemnities."Rounding Direction";
                        // MC : Minimum ganati -------------------------------------------------------------------------------------
                        Indemnities."Minimum value" := DefaultIndemnities."Minimum value";
                        Indemnities.Name := Employee.FullName();
                        Indemnities."Days Number" := DefaultIndemnities."Days Number";
                        Indemnities."Included Breastfeeding Hours" := DefaultIndemnities."Included Breastfeeding Hours";
                        Indemnities."Included in UGTT Hours" := DefaultIndemnities."Included in UGTT Hours";
                        Indemnities."Includes Extra Days" := DefaultIndemnities."Includes Extra Days";
                        Indemnities."User ID" := USERID;
                        Indemnities.Rate := DefaultIndemnities.Rate;
                        IF (SalaryLine.Month.AsInteger() > 12) AND (DefaultIndemnities."Not Included in Bonus" = TRUE) THEN
                            Indemnities.Rate := 0;
                        IF EmploymentContract."Adjust indemnity amount" THEN BEGIN
                            CASE DefaultIndemnities."Evaluation mode".AsInteger() OF
                                0, 4, 9:
                                    Indemnities."Base Amount" := DefaultIndemnities."Default amount";
                                1:
                                    Indemnities."Base Amount" := DefaultIndemnities."Default amount"
                                                                 * SalaryHeader."Paid days"
                                                                 / ParamRessHum."Paid days";
                                2:
                                    Indemnities."Base Amount" := (DefaultIndemnities."Default amount"
                                                                 * SalaryHeader."Worked days"
                                                                 / ParamRessHum."Worked days");
                                7:
                                    Indemnities."Base Amount" := (SalaryLine."Basis salary");
                                3, 8:
                                    Indemnities."Base Amount" := (DefaultIndemnities."Default amount");
                            END;
                        END
                        ELSE
                            Indemnities."Base Amount" := (DefaultIndemnities."Default amount");

                        Indemnities."Real Amount" := 0;
                        Indemnities."Not incl. Nat. Old Age Insur." := DefaultIndemnities."Not incl. Nat. Old Age Insur.";
                        Ins := TRUE;
                        IF Indemnities."Indemnity Type".AsInteger() = 1 THEN BEGIN
                            Ins := FALSE;
                            ParamRessHum.GET();
                            IF ParamRessHum."Activate Alert Other Payroll" THEN BEGIN
                                IF CONFIRM(STRSUBSTNO('Indemnité %1 Pour L''Employer %2 Montant de Base est de %3 n''est Pas une Indemnité Régulière',
                                 Indemnities.Description, Indemnities."Employee No." + ' ' + Indemnities.Name, Indemnities."Base Amount"), FALSE, TRUE) THEN
                                    Ins := TRUE;
                            END ELSE BEGIN
                                Ins := TRUE;
                            END;
                        END;
                        IF Ins THEN
                            IF Indemnities.INSERT THEN BEGIN
                                // Cotisations à appliquer à des Indmennités particulières
                                DefaultSocContribution.RESET;
                                DefaultSocContribution.SETRANGE("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
                                DefaultSocContribution.SETRANGE("Indemnity Code", DefaultIndemnities."Indemnity Code");
                                ParamRessHum.GET;
                                IF NOT ParamRessHum."Activate Bonus Type" THEN BEGIN
                                    IF SalaryLine.Month = SalaryLine.Month::Prime THEN
                                        DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
                                END ELSE BEGIN
                                    IF ((SalaryLine.Month.AsInteger() > 12)) THEN// OR (PrimeType.Fonction<>2) THEN      WDC0904
                                        DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
                                END;
                                IF DefaultSocContribution.FINDFIRST THEN
                                    REPEAT
                                        SocialContributions.INIT;
                                        SocialContributions."No." := SalaryLine."No.";
                                        SocialContributions."Calculate Year" := SalaryLine."Calculate Year";
                                        SocialContributions."Employee No." := SalaryLine."Employee No.";
                                        SocialContributions.Indemnity := DefaultIndemnities."Indemnity Code";
                                        SocialContributions."Social Contribution" := DefaultSocContribution."Social Contribution Code";
                                        SocialContributions."Basis of calculation" := DefaultSocContribution."Basis of calculation";
                                        SocialContributions."Employee Posting Group" := SalaryLine."Employee Posting Group";
                                        SocialContributions."Employee Statistic Group" := SalaryLine."Statistics Group Code";
                                        SocialContributions."Global Dimension 1" := SalaryLine."Global Dimension 1";
                                        SocialContributions."Global Dimension 2" := SalaryLine."Global Dimension 2";
                                        SocialContributions.Management := SalaryLine.Management;
                                        SocialContributions.service := SalaryLine.Service;
                                        SocialContributions.section := SalaryLine.Section;
                                        IF SocialContribution.GET(DefaultSocContribution."Social Contribution Code") THEN
                                            SocialContributions.Description := SocialContribution.Description;
                                        SocialContributions."Employer's part" := DefaultSocContribution."Employer's part";
                                        SocialContributions."Employee's part" := DefaultSocContribution."Employee's part";
                                        SocialContributions."Base Amount" := 0;
                                        SocialContributions."Real Amount : Employee" := 0;
                                        SocialContributions."Real Amount : Employer" := 0;
                                        SocialContributions."Deductible of taxable basis" := DefaultSocContribution."Deductible of taxable basis";
                                        SocialContributions."Maximum value - Employee" := DefaultSocContribution."Maximum value - Employee";
                                        SocialContributions."Maximum value - Employer" := DefaultSocContribution."Maximum value - Employer";

                                        SocialContributions."Evaluation Mode" := DefaultSocContribution."Evaluation Mode";
                                        SocialContributions."Salary Package" := DefaultSocContribution."Salary Package";
                                        SocialContributions."Employer contribution" := DefaultSocContribution."Employer contribution";
                                        SocialContributions.INSERT;
                                    UNTIL DefaultSocContribution.NEXT = 0;
                            END;
                    END;
                UNTIL DefaultIndemnities.NEXT = 0;

            // Cotisations à appliquer à toutes les indemnités
            DefaultSocContribution.SETRANGE("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
            DefaultSocContribution.SETRANGE("Indemnity Code", '');
            ParamRessHum.GET;
            IF NOT ParamRessHum."Activate Bonus Type" THEN BEGIN
                IF SalaryLine.Month = SalaryLine.Month::Prime THEN
                    DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
            END ELSE BEGIN
                IF ((SalaryLine.Month.AsInteger() > 12)) THEN
                    DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
            END;
            IF DefaultSocContribution.FINDFIRST THEN
                REPEAT
                    SocialContributions.INIT;
                    SocialContributions."No." := SalaryLine."No.";
                    SocialContributions."Employee No." := SalaryLine."Employee No.";
                    SocialContributions."Calculate Year" := SalaryLine."Calculate Year";

                    SocialContributions.Indemnity := '';
                    SocialContributions."Social Contribution" := DefaultSocContribution."Social Contribution Code";
                    SocialContributions."Employee Posting Group" := SalaryLine."Employee Posting Group";
                    SocialContributions."Employee Statistic Group" := SalaryLine."Statistics Group Code";
                    SocialContributions."Global Dimension 1" := SalaryLine."Global Dimension 1";
                    SocialContributions."Global Dimension 2" := SalaryLine."Global Dimension 2";
                    SocialContributions.Management := SalaryLine.Management;
                    SocialContributions.service := SalaryLine.Service;
                    SocialContributions.section := SalaryLine.Section;
                    IF SocialContribution.GET(DefaultSocContribution."Social Contribution Code") THEN
                        SocialContributions.Description := SocialContribution.Description;
                    SocialContributions."Basis of calculation" := DefaultSocContribution."Basis of calculation";

                    SocialContributions."Employer's part" := DefaultSocContribution."Employer's part";
                    SocialContributions."Employee's part" := DefaultSocContribution."Employee's part";
                    SocialContributions."Base Amount" := 0;
                    SocialContributions."Real Amount : Employee" := 0;
                    SocialContributions."Real Amount : Employer" := 0;
                    SocialContributions."Deductible of taxable basis" := DefaultSocContribution."Deductible of taxable basis";
                    SocialContributions."Maximum value - Employee" := DefaultSocContribution."Maximum value - Employee";
                    SocialContributions."Maximum value - Employer" := DefaultSocContribution."Maximum value - Employer";

                    SocialContributions."Evaluation Mode" := DefaultSocContribution."Evaluation Mode";
                    SocialContributions."Salary Package" := DefaultSocContribution."Salary Package";
                    SocialContributions."Employer contribution" := DefaultSocContribution."Employer contribution";
                    SocialContributions.INSERT;
                UNTIL DefaultSocContribution.NEXT = 0;
            OK := TRUE;
        END
        ELSE
            OK := FALSE;
    end;

    procedure CalculateSalaryLineSimu(var SalaryLine: Record "WDC Salary Lines"; "SolderDroitCongé": Boolean; Sim: Option Simulation,Real,Prime; nbjsolder: Decimal; Pinverse: Boolean): Decimal
    var
        PosGlob: Integer;
        NumChifre: Code[1];
        SalaryHeader: Record "WDC Salary Header";
        Ind: Record "WDC Indemnities";
        SocialContributions: Record "WDC Social Contributions";
        ParamRessHum: Record "Human Resources Setup";
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        Employee: Record Employee;
        SliceImposition: Record "WDC Slices of imposition";
        SliceImpositionX: Record "WDC Slices of imposition";
        temp: Decimal;
        tmp: Decimal;
        tmp1: Decimal;
        Cot: Record "WDC Default Soc. Contribution";
        nbr: Decimal;
        bonus: Decimal;
        SalLineEng: Record "WDC Posted Salary Lines";
        EntEng: Record "WDC Posted Salary Header";
        LigneTravail: Record "WDC Occasional Hours Recorded";
        LigneTravailEnreg: Record "WDC Overtime hours recorded m";
        WorkedD: Decimal;
        "Mgmt.ofLoansandAdvances": Codeunit "WDC Mgmt. Loans & Adv";
        droitconge: Record "WDC Employee's days off Entry";
        SalLineEngTmp: Record "WDC Salary Lines";
        MntInd: Decimal;
        DefaultIndemnitiesTmp: Record "WDC Default Indemnities";
        SoldeReport: Decimal;
        EMP1: Record Employee;
        LigneAbsence: Record "WDC Employee's days off Entry";
        AbsEmp: Decimal;
        "RecLJourFérier": Record "WDC Employee's days off Entry";
        RecLDefaultindemnities: Record "WDC Default Indemnities";
        RecLIndemnities: Record "WDC Indemnities";
        HeureJourTravail: Record "WDC Overcharge of hour cost";
    begin

        SalaryHeader.GET(SalaryLine."No.");
        ParamRessHum.GET();
        IF NOT SolderDroitCongé THEN
            nbjsolder := 0;
        ParamCpta.GET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        CLEAR(EmploymentContract);
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        RegimeWork.RESET;
        RegimeWork.GET(EmploymentContract."Work Regime");
        MgmtSalary2.initLigne(SalaryLine, Sim);
        GNbJour := RegimeWork."Worked Day Per Month";
        GNbHeure := RegimeWork."Work Hours per month";
        //-->calcul la bonification
        bonus := 1;
        IF (SalaryLine.Month.AsInteger() > 11) AND (SalaryLine.Purcent > 0) THEN BEGIN
            bonus := SalaryLine.Purcent;
            IF ParamRessHum."Type de Note" = 0 THEN
                bonus := bonus / 100;
            //-->Prise en compte de nbre de mois travaillés
            IF SalaryLine."Worked Months" > 0 THEN
                bonus := bonus * (SalaryLine."Worked Months" / 12)
            ELSE
                bonus := 0;
        END;
        //--> Soder droit congé
        IF Sim = 1 THEN
            ParamRessHum.TESTFIELD("Minimum wage guarantee");

        //CreerLignetransport(SalaryLine);
        IF SalaryLine.Month.AsInteger() < 12 THEN BEGIN
            IF (DATE2DMY(Employee."Employment Date", 3) = SalaryLine.Year) AND ((DATE2DMY(Employee."Employment Date", 2) - 1) = SalaryLine.Month.AsInteger())
            THEN
                SalaryLine."6 * SMIG" := ROUND(ParamRessHum."Minimum wage guarantee" * 6 *
                      (CALCDATE('<+CM>', Employee."Employment Date") - Employee."Employment Date" + 1), ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLine."6 * SMIG" := ROUND(ParamRessHum."Minimum wage guarantee" * 6, ParamCpta."Amount Rounding Precision");
        END;
        IF SolderDroitCongé THEN BEGIN
            IF ((SalaryLine."Days off remaining" + SalaryLine."Monthly Leave Entitlement") >= nbjsolder) AND (nbjsolder <> 0) THEN
                SalaryLine."Days off balacement" := nbjsolder
            ELSE
                SalaryLine."Days off balacement" := (SalaryLine."Days off remaining" + SalaryLine."Monthly Leave Entitlement");
            droitconge.RESET;
            droitconge.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year");
            droitconge.SETRANGE("Line type", 1);
            droitconge.SETRANGE("Employee No.", SalaryLine."Employee No.");
            droitconge.SETRANGE("Posting month", SalaryLine.Month);
            droitconge.SETRANGE("Posting year", SalaryLine.Year);
            droitconge.CALCSUMS("Quantity (Days)", "Line amount", "Quantity (Hours)");
            SalaryLine."Amount Days Off balacement" := ROUND(Employee."Basis salary" * SalaryLine."Days off balacement" /
                                                     SalaryHeader."Paid days", ParamCpta."Amount Rounding Precision");
            SalaryLine."Assiduity (days off balacement" := ROUND(SalaryLine."Days off balacement" / SalaryHeader."Paid days", 0.0001) * 100;
            SalaryLine."Hours off Balacement" := droitconge."Quantity (Hours)";
        END
        ELSE
            SalaryLine."Days off balacement" := 0;
        // --> Calcul des 2 param. d'assiduité
        MntInd := 0;
        IF Employee."Currency Code" <> '' THEN BEGIN
            DefaultIndemnitiesTmp.RESET;
            DefaultIndemnitiesTmp.SETFILTER("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
            DefaultIndemnitiesTmp.SETRANGE("Evaluation mode", 1, 2);
            DefaultIndemnitiesTmp.SETRANGE("Indemnity Type", 0);
            IF DefaultIndemnitiesTmp.FINDFIRST THEN
                REPEAT
                    MntInd := MntInd + DefaultIndemnitiesTmp."Default amount";
                UNTIL DefaultIndemnitiesTmp.NEXT = 0;
        END;
        nbr := 12;
        EmploymentContract.RESET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        CASE ParamRessHum."Monthes Number".AsInteger() OF
            0:
                nbr := EmploymentContract."Regular payments";
            1:
                nbr := EmploymentContract."Temporary payments";
            2:
                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
        END;
        IF RegimeWork.GET(SalaryLine."Employee Work Regime") THEN;
        IF ((Sim = 1) OR ((SalaryLine."Basis salary" = 0) AND (Sim = 0))) AND NOT ((Pinverse = TRUE) AND (SalaryLine."Basis salary" = 0)) THEN BEGIN
            IF SalaryLine."Posting Date" = 0D THEN
                SalaryLine."Posting Date" := WORKDATE;
            IF Employee."Currency Code" = '' THEN
                SalaryLine."Basis salary" := Employee."Basis salary"
            ELSE BEGIN
                IF Employee."Gross Salary" <> 0 THEN
                    SalaryLine."Basis salary" :=
                       ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code",
                          Employee."Gross Salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code")
              ) -
                          MntInd, ParamCpta."Amount Rounding Precision")
                ELSE
                    SalaryLine."Basis salary" :=
                         ROUND(Tchange.ExchangeAmtFCYToLCY(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code",
                          Employee."Basis salary", Tchange.ExchangeRate(CALCDATE('<-1M+FM+1J>', SalaryLine."Posting Date"), Employee."Currency Code")
              )
                          , ParamCpta."Amount Rounding Precision");
            END;
        END;
        //Salaire de base
        CASE SalaryLine."Employee type".AsInteger() OF
            0:
                BEGIN
                    LigneAbsence.RESET;
                    LigneAbsence.SETCURRENTKEY("Employee No.", "Posting year", "Posting month", "Absence Reason", Week);
                    LigneAbsence.SETFILTER("Absence Reason", '<>%1', 6);
                    LigneAbsence.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneAbsence.SETRANGE("Posting month", SalaryLine.Month);
                    LigneAbsence.SETRANGE("Posting year", SalaryLine.Year);
                    LigneAbsence.CALCSUMS(Quantity);
                    SalaryLine."Assiduity (Paid days)" := (SalaryHeader."Paid days"
                                                             - SalaryLine.Absences
                                                             - SalaryLine."Adjustment of absences")
                                                             / SalaryHeader."Paid days"
                                                             * 100;

                    //CALCUL HEURES NORMALES
                    Heuresoccaenregm.RESET;
                    Heuresoccaenregm.SETFILTER("Employee No.", Employee."No.");
                    Heuresoccaenregm.SETFILTER("Payment Month", '%1', SalaryHeader.Month);
                    Heuresoccaenregm.SETFILTER("Payment Year", '%1', SalaryHeader.Year);
                    IF Heuresoccaenregm.FINDFIRST THEN
                        REPEAT
                            TotHeuresEnreg := TotHeuresEnreg + Heuresoccaenregm."Hours Number";
                        UNTIL Heuresoccaenregm.NEXT = 0;
                    IF Sim = 0 THEN
                        TotHeuresEnreg := GNbHeure;
                    SalaryLine."Worked hours" := TotHeuresEnreg;
                    IF (Pinverse = TRUE) THEN
                        SalaryLine."Basis salary" := Employee."Basis salary";
                    IF GNbHeure > TotHeuresEnreg THEN
                        SalaryLine."Real basis salary" := ROUND(SalaryLine."Worked hours" * Employee."Basis salary",
                                                 ParamCpta."Amount Rounding Precision");
                    IF (Pinverse = FALSE) THEN
                        SalaryLine."Real basis salary" := ROUND(SalaryLine."Worked hours" * SalaryLine."Basis salary",
                                                        ParamCpta."Amount Rounding Precision");
                    //<<MBY
                END;
            1:
                BEGIN
                    SalaryLine."Basis hours" := LigneTravail."Hours Number";
                    LigneAbsence.RESET;
                    LigneAbsence.SETCURRENTKEY("Employee No.", "Posting year", "Posting month", "Line type", Week);
                    LigneAbsence.SETFILTER(LigneAbsence."Line type", '=%1', 3);
                    LigneAbsence.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneAbsence.SETRANGE("Posting month", SalaryLine.Month);
                    LigneAbsence.SETRANGE("Posting year", SalaryLine.Year);
                    LigneAbsence.CALCSUMS(Quantity);
                    AbsEmp := LigneAbsence.Quantity;
                    //CALCUL JOUR NORMALES 
                    TotJoursEnreg := 0;
                    Heuresoccaenregm.RESET;
                    Heuresoccaenregm.SETFILTER("Employee No.", Employee."No.");
                    Heuresoccaenregm.SETFILTER("Payment Month", '%1', SalaryHeader.Month);
                    Heuresoccaenregm.SETFILTER("Payment Year", '%1', SalaryHeader.Year);
                    IF Heuresoccaenregm.FINDFIRST THEN
                        REPEAT
                            TotJoursEnreg := TotJoursEnreg + Heuresoccaenregm."Days Number";
                        UNTIL Heuresoccaenregm.NEXT = 0;
                    TotJoursEnreg := GNbJour;
                    IF Sim = 0 THEN
                        TotJoursEnreg := GNbJour;
                    TotJoursEnreg := GNbJour;
                    SalaryLine."Paied days" := TotJoursEnreg;
                    SalaryLine."Assiduity (Paid days)" := (SalaryHeader."Paid days"
                                                             - SalaryLine.Absences
                                                             - SalaryLine."Adjustment of absences")
                                                             / SalaryHeader."Paid days"
                                                             * 100;
                    IF (Pinverse = TRUE) THEN
                        SalaryLine."Basis salary" := Employee."Basis salary";

                    SalaryLine."Real basis salary" := ROUND((TotJoursEnreg) * Employee."Basis salary" / GNbJour
                                                             , ParamCpta."Amount Rounding Precision");
                    IF (Pinverse = FALSE) THEN
                        SalaryLine."Real basis salary" := ROUND((TotJoursEnreg) * SalaryLine."Basis salary" / GNbJour
                                                                 , ParamCpta."Amount Rounding Precision");
                END;
        END;
        //FIN CALCUL SALAIRE DE BASE
        // Calcul Indemnité
        IF Pinverse AND (SalaryLine.Month = SalaryLine.Month::Prime) THEN
            SalaryLine."Amount Days Off balacement" := 0;
        IF ParamRessHum."Leave Balance Calc. Type".AsInteger() = 1 THEN
            SalaryLine."Assiduity (Paid days)" := SalaryLine."Assiduity (Paid days)" + SalaryLine."Assiduity (days off balacement";
        TaxesMgmt.CalcTaxableIndemnity(SalaryLine, GNbJour, GNbHeure, TotJoursEnreg);
        //--> Calcul du salaire Brut du mois
        "CalcInd&HsupNav"(SalaryLine, Sim);
        SalaryLine."6 * SMIG" := ROUND(ParamRessHum."Minimum wage guarantee" * 6, ParamCpta."Amount Rounding Precision");
        IF (SalaryLine.Month = SalaryLine.Month::Prime) THEN
            SalaryLine."Assiduity (Paid days)" := 100;
        CASE SalaryLine."Employee type".AsInteger() OF
            1:
                BEGIN
                    SalaryLine."Gross Salary (Without AV)" := ROUND((bonus * SalaryLine."Real basis salary")
                                                          + SalaryLine."Taxable Indem. PR (Not Gross)"
                                                          + SalaryLine."Taxable indemnities"
                                                          + SalaryLine."Supp. hours", ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary (Without AV) PR" := ROUND((SalaryLine."Basis salary" - SalaryLine."Amount Days Off balacement"
                                                                  ) + SalaryLine."Taxable indemnities PR"
                                                                  , ParamCpta."Amount Rounding Precision") +
                                                                  SalaryLine."Taxable indem. PR (Not Gross)";
                    SalaryLine."Gross Salary" := SalaryLine."Gross Salary (Without AV)";
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary PR" := SalaryLine."Gross Salary (Without AV) PR";
                END;
            0:
                BEGIN
                    SalaryLine."Gross Salary (Without AV)" := ROUND((bonus * SalaryLine."Real basis salary")
                                                        + SalaryLine."Taxable Indem. PR (Not Gross)"
                                                        + SalaryLine."Taxable indemnities"
                                                        + SalaryLine."Supp. hours", ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary (Without AV) PR" := ROUND((SalaryLine."Basis salary" - SalaryLine."Amount Days Off balacement")
                                                        + SalaryLine."Taxable indemnities PR" + SalaryLine."Taxable indem. PR (Not Gross)"
                                                        , ParamCpta."Amount Rounding Precision");
                    SalaryLine."Gross Salary" := SalaryLine."Gross Salary (Without AV)";
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary (Without AV) PR" := SalaryLine."Gross Salary (Without AV) PR";
                END;
        END;
        CalculIndemnityAvNat(SalaryLine);
        CASE SalaryLine."Employee type".AsInteger() OF
            1:
                BEGIN
                    LigneTravail.RESET;
                    LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year");
                    LigneTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravail.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravail.SETRANGE("Payment Year", SalaryLine.Year);
                    LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                    LigneTravail.MODIFYALL("Payment No.", SalaryLine."No.");
                    SalaryLine."Basis hours" := LigneTravail."Hours Number";
                    LigneTravailEnreg.RESET;
                    LigneTravailEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year");
                    LigneTravailEnreg.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravailEnreg.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravailEnreg.SETRANGE("Payment Year", SalaryLine.Year);
                    LigneTravailEnreg.CALCSUMS("Hours Number", "Line amount");
                    LigneAbsence.RESET;

                    SalaryLine."Gross Salary" := ROUND(
                                                             ROUND(SalaryLine."Real basis salary" * bonus, ParamCpta."Amount Rounding Precision")
                                                           + ROUND(SalaryLine."Taxable indemnities", ParamCpta."Amount Rounding Precision")
                                                           + ROUND(SalaryLine."Supp. hours", ParamCpta."Amount Rounding Precision"),
                                                           ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary PR" := ROUND((bonus * SalaryLine."Real basis salary") + SalaryLine.
                                                               "Taxable indemnities PR", ParamCpta."Amount Rounding Precision");
                END;
            0:
                BEGIN
                    LigneTravail.RESET;
                    //LigneTravail.SETCURRENTKEY("Employee No.","Payment Month","Payment Year");
                    LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year");
                    LigneTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravail.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravail.SETRANGE("Payment Year", SalaryLine.Year);
                    LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                    LigneTravail.MODIFYALL("Payment No.", SalaryLine."No.");
                    SalaryLine."Basis hours" := LigneTravail."Hours Number";
                    LigneTravailEnreg.RESET;
                    LigneTravailEnreg.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year");
                    LigneTravailEnreg.SETFILTER("Employee No.", SalaryLine."Employee No.");
                    LigneTravailEnreg.SETRANGE("Payment Month", SalaryLine.Month);
                    LigneTravailEnreg.SETRANGE("Payment Year", SalaryLine.Year);
                    LigneTravailEnreg.CALCSUMS("Hours Number", "Line amount");
                    LigneAbsence.RESET;
                    SalaryLine."Gross Salary" := ROUND(
                                                             ROUND(SalaryLine."Real basis salary" * bonus, ParamCpta."Amount Rounding Precision")
                                                           + ROUND(SalaryLine."Taxable indemnities", ParamCpta."Amount Rounding Precision")
                                                           + ROUND(SalaryLine."Supp. hours", ParamCpta."Amount Rounding Precision"),
                                                           ParamCpta."Amount Rounding Precision");
                    IF Sim < 2 THEN
                        SalaryLine."Gross Salary PR" := ROUND((SalaryLine."Real basis salary" * bonus)
                                                               + SalaryLine."Taxable indemnities PR"
                                                               , ParamCpta."Amount Rounding Precision");
                END;
        END;
        // --> Calc Cotisation Social
        IF ParamRessHum."Leave Balance Calc. Type".AsInteger() = 0 THEN
            SalaryLine."Basis salary" := SalaryLine."Basis salary" - SalaryLine."Amount Days Off balacement";
        MgmtSalary2.CalcCotisationSocial1(SalaryLine);
        //--> Calcul du salaire imposable
        MgmtSalary2.CalcAllTaxe(SalaryLine);
        //A AJOUTER CONTROLE NON IMPOSABLE
        Gemployee.GET(SalaryLine."Employee No.");     //WDC01
        IF EmploymentContract.Taxable THEN
            // SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib." +
            //                                    SalaryLine."Taxable Indem. PR (Not Gross)"
            //                                    - SalaryLine."Retirement plus"
            //                                                , ParamCpta."Amount Rounding Precision");  //WDC01
                   SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib." +
                                               SalaryLine."Taxable indemnities(Not Gross)"
                                               - SalaryLine."Retirement plus"
                                                           , ParamCpta."Amount Rounding Precision");  //WDC01
        IF Sim < 2 THEN
            IF EmploymentContract.Taxable THEN
                SalaryLine."Taxable salary PR" := ROUND(SalaryLine."Gross Salary PR" - SalaryLine."Non Taxable Soc. Contrib. PR" +
                                                       SalaryLine."Taxable indem. PR (Not Gross)"
                                                                 , ParamCpta."Amount Rounding Precision");
        // Calc Cotisation Social
        MgmtSalary2.CalcCotisationSocial2(SalaryLine);
        //--> Calcul de l'imposable réel
        IF EmploymentContract.Taxable THEN BEGIN
            IF NOT Employee."Family chief" THEN BEGIN
                SalaryLine."Deduction Family chief" := 0;
                SalaryLine."Deduction Loaded child" := 0;
            END;
            SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Pourcent professional expenses"
                                                          * SalaryLine."Taxable salary");
            IF SalaryLine.Month.AsInteger() < 13 THEN
                SalaryLine."Real taxable" := ROUND(SalaryLine."Taxable salary"
                                                               - SalaryLine."Deduction Family chief"
                                                               - SalaryLine."Deduction Loaded child"
                                                               - SalaryLine."Deduction Prof. expenses", ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLine."Real taxable" := ROUND(SalaryLine."Taxable salary"
                                                               - SalaryLine."Deduction Prof. expenses", ParamCpta."Amount Rounding Precision");
            IF (SalaryLine.Month.AsInteger() < 13) OR (Sim = 2) THEN
                SalaryLine."Real taxable PR" := ROUND(SalaryLine."Taxable salary PR"
                                                               - SalaryLine."Deduction Family chief"
                                                               - SalaryLine."Deduction Loaded child"
                                                               - ROUND(SalaryLine."Taxable salary PR" * ParamRessHum."Pourcent professional expenses" / 100
                                                               , ParamCpta."Amount Rounding Precision"), ParamCpta."Amount Rounding Precision")
            ELSE
                SalaryLine."Real taxable PR" := ROUND(SalaryLine."Taxable salary PR"
                                                               - ROUND(SalaryLine."Taxable salary PR" * ParamRessHum."Pourcent professional expenses" / 100
                                                               , ParamCpta."Amount Rounding Precision"), ParamCpta."Amount Rounding Precision");


            //--> Calcul de l'imposable réel par an
            SalLineEng.RESET;
            SalLineEng.SETCURRENTKEY(Year, "Employee No.", "No.");
            SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEng.Setrange(Year, SalaryLine.Year);
            SalLineEng.CALCSUMS("Real taxable", "Taxe (Month)");
            SalaryLine."Total taxable rec." := SalLineEng."Real taxable";
            SalaryLine."Total taxes rec." := SalLineEng."Taxe (Month)";
            SalaryLine."Rec. payments" := 0;
            SalLineEngTmp.RESET;
            SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.");
            SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEngTmp.Setrange(Year, SalaryLine.Year);
            SalLineEngTmp.SETFILTER(Month, '<%1', SalLineEngTmp.month::"13th Salary");
            SalLineEngTmp.CALCSUMS("Real taxable", "Taxe (Month)");
            IF Employee."Working Relationship".AsInteger() = 2 THEN
                SalaryLine."Rec. payments" := SalLineEngTmp.COUNT
            ELSE
                SalaryLine."Rec. payments" := 0;

            SalLineEngTmp.RESET;
            SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.");
            SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEngTmp.Setrange(Year, SalaryLine.Year);
            DEDUCIMPOT := 0;
            IF SalLineEngTmp.FINDFIRST THEN
                REPEAT
                    DEDUCIMPOT := DEDUCIMPOT + SalLineEngTmp."Deduction Family chief" +
                                  SalLineEngTmp."Deduction Loaded child" + SalLineEngTmp."Deduction Prof. expenses"
                UNTIL SalLineEngTmp.NEXT = 0;
            //--> Calcul de l'Imposable Réel
            EmploymentContract.RESET;
            Employee.GET(SalaryLine."Employee No.");
            EmploymentContract.GET(Employee."Emplymt. Contract Code");
            // ASSVIE
            MntAssVie := 0;
            RecAssVie.RESET;
            RecAssVie.SETRANGE(Year, SalaryLine.Year);
            RecAssVie.SETRANGE("Employee No.", SalaryLine."Employee No.");
            IF RecAssVie.FINDFIRST THEN
                REPEAT
                    MntAssVie := MntAssVie + RecAssVie.Amount;
                UNTIL RecAssVie.NEXT = 0;
            CASE Sim OF
                0:
                    BEGIN
                        CASE ParamRessHum."Monthes Number".AsInteger() OF
                            0:
                                nbr := EmploymentContract."Regular payments";
                            1:
                                nbr := EmploymentContract."Temporary payments";
                            2:
                                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
                        END;
                        SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" * nbr,
                                                                               ParamCpta."Amount Rounding Precision");
                    END;
                1, 2:
                    BEGIN
                        nbr := 12;
                        EmploymentContract.RESET;
                        Employee.GET(SalaryLine."Employee No.");
                        EmploymentContract.GET(Employee."Emplymt. Contract Code");
                        CASE ParamRessHum."Monthes Number".AsInteger() OF
                            0:
                                nbr := EmploymentContract."Regular payments";
                            1:
                                nbr := EmploymentContract."Temporary payments";
                            2:
                                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
                        END;
                        CASE ParamRessHum."Regulation Taxe".AsInteger() OF
                            0:
                                BEGIN
                                    IF SalaryLine.Month.AsInteger() < 13 THEN BEGIN
                                        IF Employee."Working Relationship".AsInteger() = 2 THEN
                                            SalaryLine."Real taxable (Year)" := ROUND((SalaryLine."Real taxable" +
                                                                               (SalaryLine."Real taxable" * (nbr - SalaryLine."Rec. payments" - 1)))
                                                                               + SalaryLine."Total taxable rec."
                                                                               , ParamCpta."Amount Rounding Precision")
                                        ELSE
                                            SalaryLine."Real taxable (Year)" := ROUND(((SalaryLine."Real taxable" * (nbr)))
                                                                               , ParamCpta."Amount Rounding Precision");
                                    END
                                    ELSE
                                        SalaryLine."Real taxable (Year)" := ROUND((SalaryLine."Real taxable" +
                                                                            ((SalaryLine."Real taxable PR")//- SalaryLine."Deduction Family chief"
                                                                             * (nbr - SalaryLine."Rec. payments")))
                                                                            + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                                    IF SalaryLine.Month.AsInteger() < 13 THEN
                                        SalaryLine."Real Taxable PR (Year)" := ROUND((SalaryLine."Real taxable PR" +
                                                                            (SalaryLine."Real taxable PR" * (nbr - SalaryLine."Rec. payments" - 1)))
                                                                            + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        SalaryLine."Real Taxable PR (Year)" := ROUND((
                                                                            ((SalaryLine."Real taxable PR")//-SalaryLine."Deduction Family chief"
                                                                             * (nbr - SalaryLine."Rec. payments")))
                                                                            + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                                END;
                            1:
                                BEGIN
                                    IF SalaryLine."Rec. payments" < 12 THEN
                                        SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" * nbr,
                                                                                       ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" + SalaryLine."Total taxable rec.",
                                                                                       ParamCpta."Amount Rounding Precision");
                                    IF SalaryLine."Rec. payments" < 12 THEN
                                        SalaryLine."Real Taxable PR (Year)" := ROUND(SalaryLine."Real taxable PR" * nbr,
                                                                                       ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        SalaryLine."Real Taxable PR (Year)" := ROUND(SalaryLine."Real taxable PR" + SalaryLine."Total taxable rec.",
                                                                                       ParamCpta."Amount Rounding Precision");
                                END;
                        END;
                    END;
            END;
            //RECALCUL REAL TAXABLE
            IF Employee."Working Relationship".AsInteger() = 2 THEN BEGIN
                SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Taxable salary" * (nbr - SalaryLine."Rec. payments") +
                                                            SalaryLine."Total taxable rec." + DEDUCIMPOT, ParamCpta."Amount Rounding Precision");
                SalaryLine."Real taxable (Year)" := SalaryLine."Real taxable (Year)" - ROUND(ParamRessHum."Pourcent professional expenses"
                                                           * SalaryLine."Real taxable (Year)");
                SalaryLine."Real taxable (Year)" := SalaryLine."Real taxable (Year)" - (SalaryLine."Deduction Family chief" * nbr)
                                                                 - (SalaryLine."Deduction Loaded child" * nbr)
                                                            //MBY ASSVIE
                                                            - MntAssVie
                                                                 ;
            END;
            //*****************************************END 10/03/2009
            // Calcul Impôt Annuel
            //MBY SAMI ARRONDI AU DINAR SUP 13/01/2009
            DecVar := ROUND(SalaryLine."Real taxable (Year)", 1) - SalaryLine."Real taxable (Year)";
            //>> ----Eliminer l'arrondis


            TaxesMgmt.CalcAnnualTaxes(SalaryLine);
            //<< -Loi calcul impot 2014
            //<<------------------------------------------------------------------------------------LOI IMPÔT 2014 -------------------------------

            IF (SalaryLine.Month.AsInteger() > 12) AND (Sim <> 2) THEN BEGIN
                SalaryLine."Deduction Family chief" := 0;
                SalaryLine."Deduction Loaded child" := 0;
            END;
            // Calcul Impôt mensuel
            CASE ParamRessHum."Regulation Taxe".AsInteger() OF
                0:
                    BEGIN
                        IF SalaryLine.Month.AsInteger() < nbr THEN BEGIN
                            //*******************************************************
                            IF Employee."Working Relationship".AsInteger() = 2 THEN BEGIN
                                IF (nbr - SalaryLine."Rec. payments") <> 0 THEN
                                    SalaryLine."Taxe PR (Month)" := ROUND((SalaryLine."Taxe PR (Year)" - SalaryLine."Total taxes rec.")
                                                                  / (nbr - SalaryLine."Rec. payments"), ParamCpta."Amount Rounding Precision");
                                IF SalaryLine.Month.AsInteger() < 13 THEN
                                    SalaryLine."Taxe (Month)" := ROUND(((SalaryLine."Taxe (Year)" - SalaryLine."Total taxes rec.")
                                                                 / (nbr - SalaryLine."Rec. payments")), ParamCpta."Amount Rounding Precision")
                                ELSE
                                    SalaryLine."Taxe (Month)" := (SalaryLine."Taxe (Year)" - SalaryLine."Taxe PR (Year)");
                                IF (-SalaryLine."Taxe (Month)" >= SalaryLine."Total taxes rec.") AND (SalaryLine."Taxe (Month)" < 0) THEN
                                    SalaryLine."Taxe (Month)" := -SalaryLine."Total taxes rec.";
                            END
                            ELSE BEGIN
                                SalaryLine."Taxe PR (Month)" := ROUND((SalaryLine."Taxe PR (Year)" / nbr)
                                                              , ParamCpta."Amount Rounding Precision");
                                SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" / nbr), ParamCpta."Amount Rounding Precision");
                            END;
                            IF SalaryLine."Taxe (Month)" < 0 THEN
                                SalaryLine."Taxe (Month)" := 0;
                            //*******************************************************
                        END ELSE BEGIN
                            IF (nbr - SalaryLine."Rec. payments" + 1) <> 0 THEN
                                SalaryLine."Taxe PR (Month)" := ROUND((SalaryLine."Taxe PR (Year)" - SalaryLine."Total taxes rec.")
                                                               / (nbr - SalaryLine."Rec. payments" + 1), ParamCpta."Amount Rounding Precision");
                            IF SalaryLine.Month.AsInteger() < 13 THEN
                                SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" - SalaryLine."Taxe PR (Year)") +
                                                             SalaryLine."Taxe PR (Month)", ParamCpta."Amount Rounding Precision")
                            ELSE
                                SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" - SalaryLine."Taxe PR (Year)")
                                                             , ParamCpta."Amount Rounding Precision");
                            IF (-SalaryLine."Taxe (Month)" >= SalaryLine."Total taxes rec.") AND (SalaryLine."Taxe (Month)" < 0) THEN
                                SalaryLine."Taxe (Month)" := -SalaryLine."Total taxes rec.";
                            IF SalaryLine."Taxe (Month)" < 0 THEN
                                SalaryLine."Taxe (Month)" := 0;
                        END;
                    END;
                1:
                    BEGIN
                        IF SalaryLine."Rec. payments" < 12 THEN
                            SalaryLine."Taxe PR (Month)" := ROUND(SalaryLine."Taxe PR (Year)" / nbr, ParamCpta.
                                                                           "Amount Rounding Precision")
                        ELSE
                            SalaryLine."Taxe PR (Month)" := 0;
                        IF SalaryLine."Rec. payments" < 12 THEN
                            SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" - SalaryLine."Taxe PR (Year)") +
                                                                           SalaryLine."Taxe PR (Month)", ParamCpta."Amount Rounding Precision")
                        ELSE
                            SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" - SalaryLine."Taxe PR (Year)") +
                                                                           SalaryLine."Taxe PR (Month)", ParamCpta."Amount Rounding Precision");
                        IF SalaryLine."Taxe (Month)" < 0 THEN
                            SalaryLine."Taxe (Month)" := 0;
                    END;
            END;
            IF Sim = 0 THEN BEGIN
                SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" / nbr), ParamCpta."Amount Rounding Precision");
            END;
        END;
        IF EmploymentContract."Taxes Calculation Mode".AsInteger() = 1 THEN
            SalaryLine."Taxe (Month)" := EmploymentContract."Inclusive ratio";
        IF EmploymentContract."Inclusive ratio" <> 0 THEN
            SalaryLine."Taxe (Month)" := (SalaryLine."Gross Salary" * EmploymentContract."Inclusive ratio") / 100;
        SalaryLine."Net salary" := ROUND(SalaryLine."Gross Salary"
                                 - SalaryLine."Non Taxable Soc. Contrib."
                                 + SalaryLine."Taxable Indem. PR (Not Gross)"
                                 + SalaryLine."Non Taxable indemnities"
                                 + SalaryLine."Mission expenses"
                                 - SalaryLine."Taxable Soc. Contrib."
                                 - SalaryLine."Taxe (Month)"
                                  , ParamCpta."Amount Rounding Precision");
        IF Sim = 1 THEN
            "Mgmt.ofLoansandAdvances".CreateRepaymentLine(SalaryLine);
        SalaryLine."Net salary cashed" := ROUND(SalaryLine."Net salary"
                                                       - SalaryLine.Loans

                                                       - SalaryLine.Advances, ParamCpta."Amount Rounding Precision");
        IF SalaryLine."Net salary cashed" < 0 THEN
            MESSAGE(Text001, SalaryLine."Employee No.");
        IF (SalaryLine."Taxable salary" = 0) AND (SalaryLine."Net salary" <= 0) AND (Sim = 1) THEN
            MgmtSalary2.DeleteLine(SalaryLine)
        ELSE
            SalaryLine.MODIFY;
        EXIT(SalaryLine."Net salary");
    end;

    procedure DeleteLineSimu(var SalaryLine: Record "WDC Salary Lines")
    var
        Indemnities: Record "WDC Indemnities";
        SocialContribution: Record "WDC Social Contributions";
        LoanAdvanceLines: Record "WDC Loan & Advance Lines";
    begin
        //>>    Calcul simulation paie 
        CLEAR(Indemnities);
        Indemnities.SETRANGE("No.", SalaryLine."No.");
        Indemnities.SETRANGE("Employee No.", SalaryLine."Employee No.");
        IF Indemnities.FINDSET THEN BEGIN
            Indemnities.DELETEALL(TRUE);
        END;
        CLEAR(SocialContribution);
        SocialContribution.SETRANGE("No.", SalaryLine."No.");
        SocialContribution.SETRANGE("Employee No.", SalaryLine."Employee No.");
        IF SocialContribution.FINDFIRST THEN
            SocialContribution.DELETEALL(TRUE);

        CLEAR(LoanAdvanceLines);
        LoanAdvanceLines.SETRANGE("Payment No.", SalaryLine."No.");
        LoanAdvanceLines.SETRANGE("Employee No.", SalaryLine."Employee No.");
        LoanAdvanceLines.SETRANGE(Paid, FALSE);
        IF LoanAdvanceLines.FINDFIRST THEN
            LoanAdvanceLines.DELETEALL(TRUE);

        SalaryLine.DELETE;
        //<<    Clcul simulation paie
    end;



    procedure CheckChieldOnCharge(DatePaie: Date)
    var
        RecLEmployRelat: Record 5205;
    begin
        RecLEmployRelat.RESET;
        RecLEmployRelat.SETFILTER("Holding on end date", '<%1', DatePaie);
        IF RecLEmployRelat.FINDSET THEN BEGIN
            IF RecLEmployRelat."Holding on end date" <> 0D THEN
                RecLEmployRelat.MODIFYALL("Not Covered", TRUE);
        END;
    end;

    procedure FctGetSbaseIndemExonore(PaieNo: Code[20]; Employ: Code[20]) Return: Decimal
    var
        RecLIndemnities: Record "WDC Indemnities";
        RecLEmploy: Record Employee;
        ReclRegWork: Record "WDC work Regimes";
        EmploymentContract: Record "Employment Contract";
        Dectarif: Decimal;
        DecMntBase: Decimal;
        RecLdefIndemnities: Record "WDC Default Indemnities";
    begin
        //>> ----Test avant de calcul Impot exonoré ou nn
        RecLEmploy.RESET;
        ReclRegWork.FINDFIRST;
        IF EmploymentContract.GET(Employ) THEN
            EmploymentContract.CalcFields("Employee type");
        ReclRegWork.GET(EmploymentContract."Work Regime");
        RecLEmploy.SETRANGE("No.", Employ);
        Dectarif := 0;
        IF EmploymentContract."Employee type".AsInteger() = 1 THEN BEGIN
            RecLdefIndemnities.RESET;
            RecLdefIndemnities.SETRANGE("Emplymt. Contract Code", Employ);
            RecLdefIndemnities.SETRANGE("Tax-exempt (-5000 DT)", FALSE);
            IF RecLdefIndemnities.FINDFIRST THEN
                REPEAT
                    Dectarif := Dectarif + RecLdefIndemnities."Basis amount";
                UNTIL RecLdefIndemnities.NEXT = 0;
        END ELSE BEGIN
            //--------Horaire
            RecLdefIndemnities.RESET;
            RecLdefIndemnities.SETRANGE("Emplymt. Contract Code", Employ);
            RecLdefIndemnities.SETRANGE("Tax-exempt (-5000 DT)", FALSE);
            IF RecLdefIndemnities.FINDFIRST THEN
                REPEAT
                    Dectarif := Dectarif + RecLdefIndemnities."Basis amount";
                UNTIL RecLdefIndemnities.NEXT = 0;
            //------------------Modif ; base de calcul default indemnitie
        END;


        RecLEmploy.GET(Employ);
        IF RecLEmploy.FINDFIRST THEN BEGIN
            DecMntBase := RecLEmploy."Basis salary";
            //--------Mensuel
            IF RecLEmploy."Employee type" = RecLEmploy."Employee type"::"Month based" THEN BEGIN
                Return := DecMntBase + Dectarif;
            END ELSE BEGIN
                //--------Horaire
                IF RecLEmploy."Employee type" = RecLEmploy."Employee type"::"Hour based" THEN BEGIN
                    ReclRegWork.FINDFIRST;
                    Return := (DecMntBase * 173.333) + Dectarif;
                END;
            END;
        END;
        //<< ----Test avant de calcul Impot exonoré ou nn

    end;

    procedure ValuationLeaveBalance(Employee: Record Employee) Result: Decimal
    var
        RecGContrat: Record "Employment Contract";
        SoldeCong: Decimal;
        RecGRegimeWork: Record "WDC work Regimes";
        EmployeAbscence: Record "WDC Employee's days off Entry";
        NbreHJ: Decimal;
    begin
        IF RecGContrat.GET(Employee."Emplymt. Contract Code") THEN BEGIN
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
        SoldeCong := GetLeaveBalance(Employee);
        CASE Employee."Employee type" OF
            Employee."Employee type"::"Hour based":
                BEGIN
                    Result := ROUND((((Employee."Basis salary") * NbreHJ) / 26) * SoldeCong, 0.001);
                END;
            Employee."Employee type"::"Month based":
                BEGIN
                    Result := ROUND(((Employee."Basis salary") / NbreHJ) * SoldeCong, 0.001);
                END;
        END;
    end;

    procedure GetLeaveBalance(Employee: Record Employee) Result: Decimal
    var
        SoldeCong: Decimal;
        EmployeAbscence: Record "WDC Employee's days off Entry";
    begin
        SoldeCong := 0;
        EmployeAbscence.RESET;
        EmployeAbscence.SETFILTER(EmployeAbscence."Employee No.", Employee."No.");
        EmployeAbscence.SETFILTER(EmployeAbscence."To Date", '<=%1', TODAY);
        EmployeAbscence.SETFILTER(EmployeAbscence."Line type", '<=2');
        IF EmployeAbscence.FINDSET THEN BEGIN
            REPEAT
            BEGIN
                IF EmployeAbscence."Line type".AsInteger() <> 2 THEN
                    SoldeCong += EmployeAbscence."Quantity (Days)"
                ELSE
                    SoldeCong := SoldeCong - EmployeAbscence."Quantity (Days)";
            END;
            UNTIL (EmployeAbscence.NEXT = 0);
        END;
        Result := SoldeCong;
    end;

    procedure CalcAnnualTaxesCSS(var SalaryLine: Record "WDC Salary Lines")
    var
        ParamRessHum: Record "Human Resources Setup";
        temp: Decimal;
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        Employee: Record Employee;
        lSliceImposition: Record "WDC Slices of imposition";
        lSliceImpositionX: Record "WDC Slices of imposition";

    begin
        //>>
        //--> Calcul de l'impôt
        Employee.GET(SalaryLine."Employee No.");
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            //--> Barème standard
                            temp := 0;
                            lSliceImposition.RESET;
                            lSliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF lSliceImposition.FINDFIRST THEN
                                REPEAT
                                    //--> Cumul des tranches inf.
                                    IF ((SalaryLine."Real taxable (Year)" > lSliceImposition."Lower limit")
                                        AND
                                        (SalaryLine."Real taxable (Year)" > lSliceImposition."Superior limit")
                                       ) THEN
                                        temp := temp + lSliceImposition."Slice amount";

                                    //--> Recherche de la tranche d'imposition
                                    IF ((lSliceImposition."Lower limit" < SalaryLine."Real taxable (Year)")
                                        AND
                                        (SalaryLine."Real taxable (Year)" <= lSliceImposition."Superior limit")
                                       )
                                       OR
                                       ((SalaryLine."Real taxable (Year)" > lSliceImposition."Superior limit")
                                        AND
                                        (SalaryLine."Real taxable (Year)" > lSliceImposition."Lower limit")
                                        AND
                                        (lSliceImposition."Lower limit" > lSliceImposition."Superior limit")
                                       ) THEN
                                        lSliceImpositionX.COPY(lSliceImposition);
                                UNTIL lSliceImposition.NEXT = 0;

                            SalaryLine."Annual CSS Tax" := ROUND(((SalaryLine."Real taxable (Year)" - lSliceImpositionX."Lower limit")
                                                        * lSliceImpositionX.Rate / 100) + temp, ParamCpta."Amount Rounding Precision");
                        END;
                    1:
                        BEGIN
                            //--> Forfait
                            SalaryLine."Annual CSS Tax" := ROUND(SalaryLine."Real taxable (Year)"
                                                            * EmploymentContract."Inclusive ratio" / 100, ParamCpta."Amount Rounding Precision")
             ;
                        END;
                END;
            END
            ELSE
                SalaryLine."Annual CSS Tax" := 0;
        END;
        //--> Calcul de l'impôt PR
        Employee.GET(SalaryLine."Employee No.");
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            //--> Barème standard
                            temp := 0;
                            lSliceImposition.RESET;
                            lSliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF lSliceImposition.FINDFIRST THEN
                                REPEAT
                                    //--> Cumul des tranches inf.
                                    IF ((SalaryLine."Real Taxable PR (Year)" > lSliceImposition."Lower limit")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" > lSliceImposition."Superior limit")
                                       ) THEN
                                        temp := temp + lSliceImposition."Slice amount";

                                    //--> Recherche de la tranche d'imposition
                                    IF ((lSliceImposition."Lower limit" < SalaryLine."Real taxable (Year)")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" < lSliceImposition."Superior limit")
                                       )
                                       OR
                                       ((SalaryLine."Real Taxable PR (Year)" > lSliceImposition."Superior limit")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" > lSliceImposition."Lower limit")
                                        AND
                                        (lSliceImposition."Lower limit" > lSliceImposition."Superior limit")
                                       ) THEN
                                        lSliceImpositionX.COPY(lSliceImposition);
                                UNTIL lSliceImposition.NEXT = 0;

                            SalaryLine."Taxe PR (Year) CSS" := ROUND(((SalaryLine."Real Taxable PR (Year)" - lSliceImpositionX."Lower limit")
                                                        * lSliceImpositionX.Rate / 100) + temp, ParamCpta."Amount Rounding Precision");
                        END;
                    1:
                        BEGIN
                            //--> Forfait
                            SalaryLine."Taxe PR (Year) CSS" := ROUND(SalaryLine."Real Taxable PR (Year)"
                                                            * EmploymentContract."Inclusive ratio" / 100, ParamCpta."Amount Rounding Precision")
             ;
                        END;
                END;
            END
            ELSE
                SalaryLine."Taxe PR (Year) CSS" := 0;
        END;
        // Calcul Impôt mensuel
        Employee.GET(SalaryLine."Employee No.");
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            //--> Barème standard
                            temp := 0;
                            lSliceImposition.RESET;
                            lSliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF lSliceImposition.FINDFIRST THEN
                                REPEAT
                                    //--> Cumul des tranches inf.
                                    IF ((SalaryLine."Real Taxable PR (Year)" > lSliceImposition."Lower limit")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" > lSliceImposition."Superior limit")
                                       ) THEN
                                        temp := temp + lSliceImposition."Slice amount";

                                    //--> Recherche de la tranche d'imposition
                                    IF ((lSliceImposition."Lower limit" < SalaryLine."Real Taxable PR (Year)")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" < lSliceImposition."Superior limit")
                                       )
                                       OR
                                       ((SalaryLine."Real Taxable PR (Year)" > lSliceImposition."Superior limit")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" > lSliceImposition."Lower limit")
                                        AND
                                        (lSliceImposition."Lower limit" > lSliceImposition."Superior limit")
                                       ) THEN
                                        lSliceImpositionX.COPY(lSliceImposition);
                                UNTIL lSliceImposition.NEXT = 0;

                            SalaryLine."Taxe PR (Year) CSS" := ROUND(((SalaryLine."Real Taxable PR (Year)" - lSliceImpositionX."Lower limit")
                                                        * lSliceImpositionX.Rate / 100) + temp, ParamCpta."Amount Rounding Precision");
                        END;
                    1:
                        BEGIN
                            //--> Forfait
                            SalaryLine."Taxe PR (Year) CSS" := ROUND(SalaryLine."Real Taxable PR (Year)"
                                                            * EmploymentContract."Inclusive ratio" / 100, ParamCpta."Amount Rounding Precision");
                        END;
                END;
            END
            ELSE
                SalaryLine."Taxe PR (Year) CSS" := 0;
        END;
    end;

    procedure CalcAnnualTaxesRegul(var SalaryLine: Record "WDC Salary Lines")
    var
        ParamRessHum: Record "Human Resources Setup";
        temp: Decimal;
        EmploymentContract: Record "Employment Contract";
        Employee: Record Employee;
        SliceImposition: Record "WDC Slices of imposition";
        ChefFamille: Decimal;
        ChildDeduction: Decimal;
        Prof: Decimal;
        BaseCalcul: Decimal;
        TEMPcss: Decimal;
        RecSalLine: Record "WDC Salary Lines";
        NombreM: Integer;
        FactMonth: Decimal;
        SliceImposition_CSS: Record "WDC Slices of imposition_CSS";
    begin
        //WDCREGUL
        CLEAR(ChefFamille);
        CLEAR(ChildDeduction);
        CLEAR(Prof);
        CLEAR(BaseCalcul);
        CLEAR(temp);
        CLEAR(TEMPcss);
        ParamRessHum.GET;
        Employee.GET(SalaryLine."Employee No.");
        //>>Calcul du nombre de mois
        CLEAR(NombreM);
        CLEAR(RecSalLine);
        CLEAR(Tresource);
        Tresource.DELETEALL;
        RecSalLine.SETRANGE("Employee No.", SalaryLine."Employee No.");
        RecSalLine.SETRANGE(Year, SalaryLine.Year);
        RecSalLine.SETFILTER("Taxe (Month)", '<>%1', 0);
        IF RecSalLine.FINDSET THEN
            REPEAT
                Tresource.INIT;
                Tresource."No." := FORMAT(DATE2DMY(RecSalLine."Posting Date", 2));
                IF DATE2DMY(RecSalLine."Posting Date", 2) <> DATE2DMY(SalaryLine."Posting Date", 2) THEN BEGIN
                    IF Tresource.INSERT THEN;
                END;
            UNTIL RecSalLine.NEXT = 0;
        NombreM := Tresource.COUNT + 1;
        IF NombreM >= 12 THEN
            FactMonth := 1 ELSE
            FactMonth := NombreM / 12;

        //<<Calcul du nombre de mois
        IF (Employee."Family chief") AND NOT (Employee.Abattement) THEN
            ChefFamille := ROUND(ParamRessHum."Deduction for Familly Chief" * FactMonth, ParamCpta."Amount Rounding Precision")
        ELSE
            ChefFamille := 0;
        SalaryLine."Real taxable (Year)" := SalaryLine."Cumulative Taxable Salary" + SalaryLine."Taxable salary";
        Employee.CALCFIELDS("Deduction Loaded child");
        ChildDeduction := ROUND(Employee."Deduction Loaded child" * FactMonth, ParamCpta."Amount Rounding Precision");
        Prof := ROUND(ParamRessHum."Pourcent professional expenses" * SalaryLine."Real taxable (Year)", ParamCpta."Amount Rounding Precision");
        IF Prof >= (ParamRessHum."Professional Expenses Charges" * FactMonth) THEN
            Prof := ParamRessHum."Professional Expenses Charges" * FactMonth;
        BaseCalcul := SalaryLine."Cumulative Taxable Salary" + SalaryLine."Taxable salary" - Prof - ChildDeduction - ChefFamille;//WDC1003

        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            temp := 0;
                            SliceImposition.RESET;
                            SliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF SliceImposition.FINDSET THEN // AVANT  ('-')
                                REPEAT
                                    IF ((BaseCalcul > SliceImposition."Lower limit" * FactMonth) AND (BaseCalcul > SliceImposition."Superior limit" * FactMonth)) THEN
                                        SliceImposition."Slice amount" := ROUND((((SliceImposition."Superior limit" * FactMonth) - (SliceImposition."Lower limit" * FactMonth)) * (SliceImposition.Rate / 100)), ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        IF (BaseCalcul > ROUND(SliceImposition."Lower limit" * FactMonth, ParamCpta."Amount Rounding Precision")) AND (BaseCalcul < ROUND(SliceImposition."Superior limit" * FactMonth, ParamCpta."Amount Rounding Precision")) THEN
                                        SliceImposition."Slice amount" := ROUND((BaseCalcul - ((SliceImposition."Lower limit") * FactMonth)) * (SliceImposition.Rate / 100), ParamCpta."Amount Rounding Precision")
                                        ELSE
                                            IF (BaseCalcul < ROUND(SliceImposition."Lower limit" * FactMonth, ParamCpta."Amount Rounding Precision")) THEN
                                            SliceImposition."Slice amount" := 0;
                                    temp += SliceImposition."Slice amount";
                                UNTIL SliceImposition.NEXT = 0;
                            SalaryLine."Taxe (Year)" := ROUND(temp, ParamCpta."Amount Rounding Precision");
                        END;
                    1:
                        BEGIN
                            //--> Forfait
                            SalaryLine."Taxe (Year)" := ROUND(SalaryLine."Real taxable (Year)"
                                                            * EmploymentContract."Inclusive ratio" / 100, ParamCpta."Amount Rounding Precision");
                        END;
                END;
            END
            ELSE
                SalaryLine."Taxe (Year)" := 0;
        END;
        //--> Calcul CSS
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            SliceImposition_CSS.RESET;
                            SliceImposition_CSS.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF SliceImposition_CSS.FINDSET THEN
                                REPEAT
                                    IF ((BaseCalcul > SliceImposition_CSS."Lower limit" * FactMonth) AND (BaseCalcul > SliceImposition_CSS."Superior limit" * FactMonth)) THEN
                                        SliceImposition_CSS."Slice amount" := ROUND((((SliceImposition_CSS."Superior limit" * FactMonth) - (SliceImposition_CSS."Lower limit" * FactMonth))) * (SliceImposition_CSS.Rate / 100), ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        IF (BaseCalcul > ROUND(SliceImposition_CSS."Lower limit" * FactMonth, ParamCpta."Amount Rounding Precision")) AND (BaseCalcul < ROUND(SliceImposition_CSS."Superior limit" * FactMonth, ParamCpta."Amount Rounding Precision")) THEN
                                        SliceImposition_CSS."Slice amount" := ROUND((BaseCalcul - ((SliceImposition_CSS."Lower limit") * FactMonth)) * (SliceImposition_CSS.Rate / 100), ParamCpta."Amount Rounding Precision")
                                        ELSE
                                            IF (BaseCalcul < ROUND(SliceImposition_CSS."Lower limit" * FactMonth, ParamCpta."Amount Rounding Precision")) THEN
                                            SliceImposition_CSS."Slice amount" := 0;

                                    TEMPcss += SliceImposition_CSS."Slice amount";
                                UNTIL SliceImposition_CSS.NEXT = 0;
                            SalaryLine."Annual CSS Tax" := ROUND(TEMPcss - temp, ParamCpta."Amount Rounding Precision");
                        END;
                    1:
                        BEGIN
                            //--> Forfait
                            SalaryLine."Annual CSS Tax" := ROUND(SalaryLine."Real taxable (Year)"
                                                              * EmploymentContract."Inclusive ratio" / 100, ParamCpta."Amount Rounding Precision")
                        END;
                END;
            END
            ELSE
                SalaryLine."Annual CSS Tax" := 0;
        END;
    end;

    procedure CalcImpotMensuel(var SalaryLine: Record "WDC Salary Lines"; NombreM: Integer)
    var
        ParamRessHum: Record "Human Resources Setup";
        temp: Decimal;
        EmploymentContract: Record "Employment Contract";
        Employee: Record Employee;
        SliceImposition: Record "WDC Slices of imposition";
        ChefFamille: Decimal;
        ChildDeduction: Decimal;
        Prof: Decimal;
        BaseCalcul: Decimal;
        SliceImposition_CSS: Record "WDC Slices of imposition_CSS";
        TEMPcss: Decimal;
    begin
        //WDCREGUL
        CLEAR(ChefFamille);
        CLEAR(ChildDeduction);
        CLEAR(Prof);
        CLEAR(BaseCalcul);
        CLEAR(temp);
        CLEAR(TEMPcss);
        ParamRessHum.GET;
        Employee.GET(SalaryLine."Employee No.");
        IF (Employee."Family chief") AND NOT (Employee.Abattement) THEN
            ChefFamille := ROUND(ParamRessHum."Deduction for Familly Chief", ParamCpta."Amount Rounding Precision")
        ELSE
            ChefFamille := 0;
        Employee.CALCFIELDS("Deduction Loaded child");
        ChildDeduction := ROUND(Employee."Deduction Loaded child", ParamCpta."Amount Rounding Precision");
        Prof := ROUND(ParamRessHum."Pourcent professional expenses" * SalaryLine."Taxable salary" * NombreM, ParamCpta."Amount Rounding Precision");  //>SalaryLine."Real taxable (Year)"
        IF Prof > ParamRessHum."Professional Expenses Charges" THEN
            Prof := ParamRessHum."Professional Expenses Charges";
        BaseCalcul := SalaryLine."Taxable salary" - ROUND(Prof / NombreM, ParamCpta."Amount Rounding Precision") - ROUND(ChildDeduction / NombreM, ParamCpta."Amount Rounding Precision") - ROUND(ChefFamille / NombreM, ParamCpta."Amount Rounding Precision");//WDC1003
        SalaryLine."Real taxable (Year)" := SalaryLine."Cumulative Taxable Salary" + SalaryLine."Taxable salary";
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            temp := 0;
                            SliceImposition.RESET;
                            SliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF SliceImposition.FINDSET THEN
                                REPEAT
                                    IF (BaseCalcul > ROUND(SliceImposition."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) AND (BaseCalcul > ROUND(SliceImposition."Superior limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                        SliceImposition."Slice amount" := ROUND((((SliceImposition."Superior limit" / NombreM) - (SliceImposition."Lower limit" / NombreM)) * (SliceImposition.Rate / 100)), ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        IF (BaseCalcul > ROUND(SliceImposition."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) AND (BaseCalcul < ROUND(SliceImposition."Superior limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                        SliceImposition."Slice amount" := ROUND((BaseCalcul - (SliceImposition."Lower limit" / NombreM)) * (SliceImposition.Rate / 100), ParamCpta."Amount Rounding Precision")
                                        ELSE
                                            IF (BaseCalcul < ROUND(SliceImposition."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                            SliceImposition."Slice amount" := 0;
                                    temp += SliceImposition."Slice amount";
                                UNTIL SliceImposition.NEXT = 0;
                            SalaryLine."Taxe (Month)" := ROUND(temp, ParamCpta."Amount Rounding Precision");
                        END;
                END;
            END
            ELSE
                SalaryLine."Taxe (Month)" := 0;
        END;
        //--> Calcul CSS
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            SliceImposition_CSS.RESET;
                            SliceImposition_CSS.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF SliceImposition_CSS.FINDSET THEN
                                REPEAT
                                    IF (BaseCalcul > ROUND(SliceImposition_CSS."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) AND (BaseCalcul > ROUND(SliceImposition_CSS."Superior limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                        SliceImposition_CSS."Slice amount" := ROUND((((SliceImposition_CSS."Superior limit" / NombreM) - (SliceImposition_CSS."Lower limit" / NombreM)) * (SliceImposition_CSS.Rate / 100)), ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        IF (BaseCalcul > ROUND(SliceImposition_CSS."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) AND (BaseCalcul < ROUND(SliceImposition_CSS."Superior limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                        SliceImposition_CSS."Slice amount" := ROUND((BaseCalcul - (SliceImposition_CSS."Lower limit" / NombreM)) * (SliceImposition_CSS.Rate / 100), ParamCpta."Amount Rounding Precision")
                                        ELSE
                                            IF (BaseCalcul < ROUND(SliceImposition_CSS."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                            SliceImposition_CSS."Slice amount" := 0;
                                    TEMPcss += SliceImposition_CSS."Slice amount";
                                UNTIL SliceImposition_CSS.NEXT = 0;
                            SalaryLine."CSS Tax" := ROUND((TEMPcss - temp), ParamCpta."Amount Rounding Precision");
                        END;
                END;
            END
            ELSE
                SalaryLine."CSS Tax" := 0;
        END;
    end;

    procedure CalcImpotMensuelNew(var SalaryLine: Record "WDC Salary Lines"; NombreM: Integer)
    var
        ParamRessHum: Record "Human Resources Setup";
        temp: Decimal;
        EmploymentContract: Record "Employment Contract";
        Employee: Record Employee;
        SliceImposition: Record "WDC Slices of imposition";
        ChefFamille: Decimal;
        ChildDeduction: Decimal;
        Prof: Decimal;
        BaseCalcul: Decimal;
        SliceImposition_CSS: Record "WDC Slices of imposition_CSS";
        TEMPcss: Decimal;
    begin
        //WDCREGUL
        NombreM := 1;
        MoisPaye := 14;
        CLEAR(ChefFamille);
        CLEAR(ChildDeduction);
        CLEAR(Prof);
        CLEAR(BaseCalcul);
        CLEAR(temp);
        CLEAR(TEMPcss);
        ParamRessHum.GET;
        Employee.GET(SalaryLine."Employee No.");
        IF (Employee."Family chief") AND NOT (Employee.Abattement) THEN
            ChefFamille := ROUND(ParamRessHum."Deduction for Familly Chief", ParamCpta."Amount Rounding Precision")
        ELSE
            ChefFamille := 0;
        Employee.CALCFIELDS("Deduction Loaded child");
        ChildDeduction := ROUND(Employee."Deduction Loaded child", ParamCpta."Amount Rounding Precision");
        Prof := ROUND(ParamRessHum."Pourcent professional expenses" * SalaryLine."Real taxable (Year)" * NombreM, ParamCpta."Amount Rounding Precision");
        IF Prof > ParamRessHum."Professional Expenses Charges" THEN
            Prof := ParamRessHum."Professional Expenses Charges";
        BaseCalcul := (SalaryLine."Taxable salary" * MoisPaye) -
        ROUND(Prof / NombreM, ParamCpta."Amount Rounding Precision") - ROUND(ChildDeduction / NombreM, ParamCpta."Amount Rounding Precision") - ROUND(ChefFamille / NombreM, ParamCpta."Amount Rounding Precision");//WDC1003
        SalaryLine."Real taxable (Year)" := SalaryLine."Cumulative Taxable Salary";
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            temp := 0;
                            SliceImposition.RESET;
                            SliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF SliceImposition.FINDSET THEN
                                REPEAT
                                    IF (BaseCalcul > ROUND(SliceImposition."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) AND (BaseCalcul > ROUND(SliceImposition."Superior limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                        SliceImposition."Slice amount" := ROUND((((SliceImposition."Superior limit" / NombreM) - (SliceImposition."Lower limit" / NombreM)) * (SliceImposition.Rate / 100)), ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        IF (BaseCalcul > ROUND(SliceImposition."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) AND (BaseCalcul < ROUND(SliceImposition."Superior limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                        SliceImposition."Slice amount" := ROUND((BaseCalcul - (SliceImposition."Lower limit" / NombreM)) * (SliceImposition.Rate / 100), ParamCpta."Amount Rounding Precision")
                                        ELSE
                                            IF (BaseCalcul < ROUND(SliceImposition."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                            SliceImposition."Slice amount" := 0;
                                    temp += SliceImposition."Slice amount";
                                UNTIL SliceImposition.NEXT = 0;
                            SalaryLine."Taxe (Month)" := ROUND(temp / MoisPaye, ParamCpta."Amount Rounding Precision");
                        END;
                END;
            END
            ELSE
                SalaryLine."Taxe (Month)" := 0;
        END;
        //--> Calcul CSS
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            SliceImposition_CSS.RESET;
                            SliceImposition_CSS.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF SliceImposition_CSS.FINDSET THEN
                                REPEAT
                                    IF (BaseCalcul > ROUND(SliceImposition_CSS."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) AND (BaseCalcul > ROUND(SliceImposition_CSS."Superior limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                        SliceImposition_CSS."Slice amount" := ROUND((((SliceImposition_CSS."Superior limit" / NombreM) - (SliceImposition_CSS."Lower limit" / NombreM)) * (SliceImposition_CSS.Rate / 100)), ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        IF (BaseCalcul > ROUND(SliceImposition_CSS."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) AND (BaseCalcul < ROUND(SliceImposition_CSS."Superior limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                        SliceImposition_CSS."Slice amount" := ROUND((BaseCalcul - (SliceImposition_CSS."Lower limit" / NombreM)) * (SliceImposition_CSS.Rate / 100), ParamCpta."Amount Rounding Precision")
                                        ELSE
                                            IF (BaseCalcul < ROUND(SliceImposition_CSS."Lower limit" / NombreM, ParamCpta."Amount Rounding Precision")) THEN
                                            SliceImposition_CSS."Slice amount" := 0;
                                    TEMPcss += SliceImposition_CSS."Slice amount";
                                UNTIL SliceImposition_CSS.NEXT = 0;
                            SalaryLine."CSS Tax" := ROUND((TEMPcss - temp) / MoisPaye, ParamCpta."Amount Rounding Precision");
                        END;
                END;
            END
            ELSE
                SalaryLine."CSS Tax" := 0;
        END;
    end;


    procedure Calc13EmeLine(SalaryLine: Record "WDC Salary Lines"; "SolderDroitCongé": Boolean; Sim: Option Simulation,Real; nbjsolder: Decimal): Decimal
    var
        SalaryHeader: Record "WDC Salary Header";
        Ind: Record 55007;
        SocialContributions: Record 55033;
        ParamRessHum: Record 5218;
        EmploymentContract: Record 5211;
        RegimeWork: Record 55003;
        Employee: Record Employee;
        SliceImposition: Record 55002;
        SliceImpositionX: Record 55002;
        temp: Decimal;
        tmp: Decimal;
        tmp1: Decimal;
        ChefFamille: Decimal;
        deductionChef: Decimal;
        EMP1: Record Employee;
        DateFin: Date;
        TableauAmortissementPret: Record 55049;
        MontantPretAmmortissement: Decimal;
        TotImpot: Decimal;
        Cot: Record 55005;
        DateDeb: Date;
        NbrPaieEmployee: Decimal;
        nbr: Decimal;
        bonus: Decimal;
        SalLineEng: Record 55025;
        EntEng: Record 55024;
        LigneTravail: Record 55009;
        TotImposable: Decimal;
        WorkedD: Decimal;
        "Mgmt.ofLoansandAdvances": Codeunit "WDC Mgmt. Loans & Adv";
        droitconge: Record 55021;
        SalLineEngTmp: Record 55025;
        SalLineEngTmp2: Record 55025;
        NbreMT: Decimal;
        RecHSuppEnreg: Record 55016;
        DecGJourNormal: Decimal;
        DecGJourSupp: Decimal;
        DecGJourConge: Decimal;
        DecGHeureNormal: Decimal;
        DecGHeureConge: Decimal;
        DecGHeureSupp: Decimal;
        DecGNBJourAN: Decimal;
        DecGNBHeureAN: Decimal;
        SoldeReport: Decimal;
        RecGIndemnites: Record 55007;
        DecMontantIdem: Decimal;
        DecGJournuit: Decimal;
        DecGheurenuit: Decimal;
        NBmoisTravaille: Decimal;
        NBMOIS: Integer;
        "RecIndemnité": Record 55004;
        "recindemnitéEnreg": Record 55026;
        DecSommeSalBase: Decimal;
        "PourcentagePrésence": Decimal;
        Lnote: Decimal;
        LPourcentage: Decimal;
        "LPourcentagePrésence": Decimal;
    begin
        //>>WDCPrime rendement
        bonus := 1;
        nbr := 14;  //2112 
        SalaryHeader.GET(SalaryLine."No.");
        ParamRessHum.GET();
        ParamCpta.GET;
        EmploymentContract.RESET;
        Employee.RESET;
        Employee.GET(SalaryLine."Employee No.");
        EmploymentContract.GET(Employee."Emplymt. Contract Code");
        RegimeWork.RESET;
        RegimeWork.GET(SalaryLine."Employee Work Regime");
        MgmtSalary2.initLigne(SalaryLine, Sim);
        SalaryLine.Taxable := EmploymentContract.Taxable;
        CASE ParamRessHum."Monthes Number".AsInteger() OF
            0:
                nbr := EmploymentContract."Regular payments";
            1:
                nbr := EmploymentContract."Temporary payments";
            2:
                nbr := EmploymentContract."Regular payments" + EmploymentContract."Temporary payments";
        END;
        DecGNBJourAN := 360;
        DecGNBHeureAN := 2079.96;
        CLEAR(Lnote);
        CLEAR(LPourcentage);
        CLEAR(LPourcentagePrésence);
        SalaryLine.Note := Employee.Note;
        SalaryLine.Purcent := Employee.Purcent;
        PourcentagePrésence := Employee."Presence Percent";
        Lnote := Employee.Note;
        LPourcentage := Employee.Purcent;
        LPourcentagePrésence := Employee."Presence Percent";
        //>>WDCPRIME A Modifier pour Gratifification
        Lnote := 0;
        LPourcentage := 100;
        LPourcentagePrésence := Employee."Presence Percent";
        //>>WDCPRIME A Modifier pour Gratifification
        Ind.RESET;
        Ind.SETRANGE("No.", SalaryHeader."No.");
        Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
        IF Ind.FINDSET THEN
            REPEAT
                DecMontantIdem := DecMontantIdem + Ind."Base Amount";
                Ind."Real Amount" := (Ind."Base Amount" * LPourcentage / 100) * (LPourcentagePrésence / 100);
                Ind.MODIFY;
            UNTIL Ind.NEXT = 0;
        SalaryLine.Purcent := LPourcentage;
        SalaryLine.Note := Lnote;
        IF SalaryLine."Employee type".AsInteger() = 1 THEN BEGIN
            SalaryLine."Real basis salary" := ROUND((
                                            (SalaryLine."Basis salary"
                                            * LPourcentage / 100)
                                            * (LPourcentagePrésence / 100))
                                            , ParamCpta."Amount Rounding Precision");
            SalaryLine."Taxable indemnities" := ROUND(((DecMontantIdem
                                              * LPourcentage / 100
                                              )
                                              * (LPourcentagePrésence / 100))
                                              ,
                                              ParamCpta."Amount Rounding Precision");
            SalaryLine."Gross Salary" := ROUND(SalaryLine."Real basis salary" + SalaryLine."Taxable indemnities"
                                            , ParamCpta."Amount Rounding Precision");
        END ELSE BEGIN
            SalaryLine."Real basis salary" := ROUND((
                                            (SalaryLine."Basis salary" * RegimeWork."Work Hours per month"
                                            * LPourcentage / 100)
                                            * (LPourcentagePrésence / 100))
                                            , ParamCpta."Amount Rounding Precision");
            SalaryLine."Taxable indemnities" := ROUND(((DecMontantIdem
                                              * LPourcentage / 100
                                              )
                                              * (LPourcentagePrésence / 100))
                                              ,
                                              ParamCpta."Amount Rounding Precision");
            SalaryLine."Gross Salary" := ROUND(SalaryLine."Real basis salary" + SalaryLine."Taxable indemnities"
                                            , ParamCpta."Amount Rounding Precision");
        END;
        //WDC Cotisation Social
        SalaryLine."6 * SMIG" := ROUND(ParamRessHum."Minimum wage guarantee" * 6, ParamCpta."Amount Rounding Precision");
        MgmtSalary2.CalcCotisationSocial1(SalaryLine);
        SalaryLine.MODIFY;
        MgmtSalary2.CalcAllTaxe(SalaryLine);
        MgmtSalary2.CalcCotisationSocial2(SalaryLine);
        SalaryLine.MODIFY;
        BEGIN
            //--> Calcul de l'imposable réel
            IF EmploymentContract.Taxable THEN BEGIN
                Gemployee.GET(SalaryLine."Employee No.");  //WDC01
                SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib."
                                                 - SalaryLine."Retirement plus", ParamCpta."Amount Rounding Precision");//WDC01
                SalLineEng.RESET;
                SalLineEng.SETCURRENTKEY(Year, "Employee No.", "No.");
                SalLineEng.Setrange(Year, SalaryLine.Year);
                SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
                IF SalLineEng.FIND('+') THEN
                    SalaryLine."Taxable salary PR" := SalLineEng."Taxable salary"
                ELSE
                    SalaryLine."Taxable salary PR" := SalLineEngTmp2."Taxable salary PR";
                IF Employee."Family chief" THEN BEGIN
                    SalaryLine."Deduction Family chief" := ROUND(ParamRessHum."Deduction for Familly Chief" / 14, //2112
                                                            ParamCpta."Amount Rounding Precision");
                    Employee.CALCFIELDS("Deduction Loaded child");
                    SalaryLine."Deduction Loaded child" := ROUND(Employee."Deduction Loaded child" / 14, //2112
                                                            ParamCpta."Amount Rounding Precision")
                END
                ELSE BEGIN
                    SalaryLine."Deduction Family chief" := 0;
                    SalaryLine."Deduction Loaded child" := 0;
                END;
                //WDC Recherche sur les paie enregistrée
                nbr := 14; //2112
                ImposEnreg := 0;
                NbrPaie := 0;
                FraisEnreg := 0;
                RecGSalayEnr.RESET;
                RecGSalayEnr.SETCURRENTKEY(Year, Month, "Employee No.", "No.");
                RecGSalayEnr.SETRANGE("Employee No.", SalaryLine."Employee No.");
                RecGSalayEnr.SETRANGE(Year, SalaryLine.Year);
                IF RecGSalayEnr.FINDSET THEN
                    REPEAT
                        ImposEnreg := ImposEnreg + RecGSalayEnr."Taxable salary";
                        FraisEnreg := FraisEnreg + RecGSalayEnr."Deduction Prof. expenses";
                        IF RecGSalayEnr.Month.AsInteger() < nbr THEN
                            NbrPaie := NbrPaie + 1;
                    UNTIL RecGSalayEnr.NEXT = 0;
                IF FraisEnreg >= ParamRessHum."Professional Expenses Charges" THEN BEGIN
                    SalaryLine."Deduction Prof. expenses" := 0;
                END ELSE BEGIN
                    IF ROUND(ParamRessHum."Pourcent professional expenses" * (SalaryLine."Taxable salary" * (nbr - NbrPaie) + ImposEnreg)) <=
                        ParamRessHum."Professional Expenses Charges" THEN BEGIN
                        IF ROUND(ParamRessHum."Pourcent professional expenses" * SalaryLine."Taxable salary") >= ROUND(ParamRessHum.
                                                                                            "Professional Expenses Charges" / nbr) THEN
                            SalaryLine."Deduction Prof. expenses" := ROUND((ParamRessHum."Professional Expenses Charges" / nbr) * (NbrPaie + 1) - FraisEnreg)
                        ELSE
                            SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Pourcent professional expenses"
                                                                            * SalaryLine."Taxable salary");
                    END ELSE BEGIN
                        SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Professional Expenses Charges" - FraisEnreg) / (nbr - NbrPaie);
                    END;
                END;
                IF SalaryLine."Deduction Prof. expenses" > ParamRessHum."Professional Expenses Charges" / nbr THEN
                    SalaryLine."Deduction Prof. expenses" := ParamRessHum."Professional Expenses Charges" / nbr;
                IF SalaryLine."Deduction Prof. expenses" + FraisEnreg > ParamRessHum."Professional Expenses Charges" THEN
                    SalaryLine."Deduction Prof. expenses" := ParamRessHum."Professional Expenses Charges" - FraisEnreg;
                SalaryLine."Real taxable" := ROUND(SalaryLine."Taxable salary"
                                                        - SalaryLine."Deduction Prof. expenses" - SalaryLine."Deduction Family chief" - SalaryLine."Deduction Loaded child" - SalaryLine."Retirement plus", ParamCpta."Amount Rounding Precision"); //WDC03 RET+

                SalaryLine."Real taxable PR" := ROUND(SalaryLine."Taxable salary PR"
                                                      - SalaryLine."Deduction Family chief"
                                                      - SalaryLine."Deduction Loaded child"
                                                      - ROUND(SalaryLine."Taxable salary PR" * ParamRessHum."Pourcent professional expenses"
                                                      , ParamCpta."Amount Rounding Precision"), ParamCpta."Amount Rounding Precision");
            END;
            //--> Calcul de l'imposable réel par an
            SalLineEng.RESET;
            SalLineEng.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Imposable);
            SalLineEng.Setrange(Year, SalaryLine.Year);
            SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEng.SETFILTER(Imposable, '%1', TRUE);
            //>> CSS
            SalLineEng.CALCSUMS("Real taxable", "Taxe (Month)", "Taxable salary", "CSS Tax");//WDCREGUL REMPLACEMENT "Monthly CSS Tax"
            SalaryLine."Total CSS Tax Recorded" := SalLineEng."CSS Tax";   //WDCREGUL REMPLACEMENT "Monthly CSS Tax"
                                                                           //<< CSS
            SalaryLine."Total taxable rec." := SalLineEng."Real taxable";
            SalaryLine."Total taxes rec." := SalLineEng."Taxe (Month)";
            SalaryLine."Rec. payments" := 0;
            SalLineEngTmp.RESET;
            SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Imposable);
            SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEngTmp.Setrange(Year, SalaryLine.Year);
            SalLineEng.SETFILTER(Imposable, '%1', TRUE);
            SalLineEngTmp.SETFILTER(Month, '<%1', SalLineEngTmp.month::"13th Salary");
            SalaryLine."Rec. payments" := SalLineEngTmp.COUNT;
            CASE Sim OF
                0:
                    BEGIN
                        SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" * nbr,
                                                                            ParamCpta."Amount Rounding Precision");
                    END;
                1:
                    BEGIN
                        CASE ParamRessHum."Regulation Taxe".AsInteger() OF
                            0:
                                BEGIN //DYNAMIQUE

                                    IF SalaryLine.Month.AsInteger() > (nbr - 1) THEN BEGIN
                                        IF (nbr - SalaryLine."Rec. payments") > 0 THEN BEGIN
                                            SalaryLine."Real taxable (Year)" := ROUND((SalaryLine."Real taxable" +
                                                                                ((SalaryLine."Real taxable")
                                                                                  * (nbr - SalaryLine."Rec. payments")))
                                                                                + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                                        END
                                        ELSE BEGIN
                                            SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" +
                                                                                +SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                                        END;


                                        SalaryLine."Real Taxable PR (Year)" := ROUND((
                                                                            ((SalaryLine."Real taxable")
                                                                            * (nbr - SalaryLine."Rec. payments" - 1)))
                                                                          + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                                    END ELSE BEGIN
                                        SalaryLine."Real taxable (Year)" := ROUND((SalaryLine."Real taxable" +
                                                                            (SalaryLine."Real taxable" * (nbr - SalaryLine."Rec. payments" - 1)))
                                                                            + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                                        SalaryLine."Real Taxable PR (Year)" := ROUND((SalaryLine."Real taxable" +
                                                                            (SalaryLine."Real taxable" * (nbr - SalaryLine."Rec. payments" - 1)))
                                                                            + SalaryLine."Total taxable rec.", ParamCpta."Amount Rounding Precision");
                                    END;
                                END;
                            1:
                                BEGIN
                                    SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" * nbr,
                                                                                      ParamCpta."Amount Rounding Precision");
                                END;
                            2:
                                BEGIN
                                    SalaryLine."Real taxable (Year)" := ROUND(SalaryLine."Real taxable" * nbr,
                                                                                    ParamCpta."Amount Rounding Precision");

                                    SalaryLine."Real Taxable PR (Year)" := ROUND(SalaryLine."Real taxable PR" * nbr,
                                                                                    ParamCpta."Amount Rounding Precision");
                                END;
                        END;
                    END;
            END;
            TableauAmortissementPret.RESET;
            TableauAmortissementPret.SETRANGE("Employee No.", SalaryLine."Employee No.");
            TableauAmortissementPret.SETRANGE(Year, SalaryLine.Year);
            TableauAmortissementPret.CALCSUMS("Annual Interest");
            IF TableauAmortissementPret.FINDSET THEN
                MontantPretAmmortissement := TableauAmortissementPret."Annual Interest";

            SalaryLine."Real taxable (Year)" := SalaryLine."Real taxable (Year)" - MntAssVie - MontCapitalReinvesti - MontantPretAmmortissement;
            //WDCPRIME Calcul Impôt mensuel
            TaxesMgmt.CalcAnnualTaxes(SalaryLine); //123
            CalcAnnualTaxesCSS(SalaryLine); //123
            EmploymentContract.GET(SalaryLine."Employee No.");
            IF EmploymentContract.Taxable = FALSE THEN
                SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib." +  //WDC01
                                                   SalaryLine."Taxable Indem. PR (Not Gross)"
                                                   - SalaryLine."Non Taxable indemnities" + (SalaryLine."Non Taxable indemnities" * 9.68 / 100)
                                                   - SalaryLine."Retirement plus"//WDC01

                                                               , ParamCpta."Amount Rounding Precision");

            SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" / nbr)
                                                            , ParamCpta."Amount Rounding Precision");

            SalaryLine."Monthly CSS Tax" := ROUND((SalaryLine."Annual CSS Tax" / nbr)
                                                                 , ParamCpta."Amount Rounding Precision");
            SalaryLine."CSS Tax" := SalaryLine."Monthly CSS Tax" - SalaryLine."Taxe (Month)";
            IF SalaryLine."Taxe (Month)" < 0 THEN
                SalaryLine."Taxe (Month)" := 0;
            IF SalaryLine."Monthly CSS Tax" < 0 THEN
                SalaryLine."Monthly CSS Tax" := 0;

            //----ARRONDI-------------------------------------ANCIEN--------------------
            SalaryLine."Net salary" := ROUND(SalaryLine."Gross Salary"
                                     - SalaryLine."Non Taxable Soc. Contrib."
                                     + SalaryLine."Taxable Indem. PR (Not Gross)"
                                     + SalaryLine."Non Taxable indemnities"
                                     + SalaryLine."Mission expenses"
                                     - SalaryLine."CSS Tax"
                                     - IndConvent
                                     //WDC03 - SalaryLine."Taxable Soc. Contrib."
                                     - SalaryLine."Taxe (Month)"
                                     - SalaryLine."Retirement plus" //WDC03 RET+
                                      , ParamCpta."Amount Rounding Precision");

            //CALCUL INDEMNITE AVENTAGE EN NATURE
            Ind.RESET;
            Ind.SETCURRENTKEY("No.", "Employee No.", Indemnity, "Benefit in Kind");
            Ind.SETRANGE("No.", SalaryLine."No.");
            Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
            Ind.SETRANGE("Benefit in Kind", TRUE);
            Ind.CALCSUMS("Real Amount");
            IF Sim = 1 THEN                                                       //1911
                IF SalaryHeader."Disable loan calculation" = FALSE THEN           //1911
                    "Mgmt.ofLoansandAdvances".CreateRepaymentLine(SalaryLine);    //1911
                                                                                  //>>
            SalaryLine."Net salary cashed" := SalaryLine."Net salary"
                                                           - SalaryLine.Loans
                                                           - SalaryLine.Advances
                                                           - Ind."Real Amount"
                                                           - SalaryLine."Amount retained cash FS";
            IF SalaryLine."Net salary cashed" < 0 THEN
                MESSAGE(Text001, SalaryLine."Employee No.");
            //arrondissement
            IF ParamRessHum."Rounded Amount" > 0 THEN BEGIN
                EMP1.SETRANGE("No.", SalaryLine."Employee No.");
                IF SalaryLine."Net salary cashed" >= 0 THEN
                    IF EMP1.FIND('-') THEN BEGIN
                        SalaryLine."Net salary cashed" := SalaryLine."Net salary cashed" - EMP1."Report Employee en -";
                        SoldeReport := 0;
                        IF SoldeReport > ParamRessHum."Rounded Amount" THEN BEGIN
                            SoldeReport := SoldeReport - ParamRessHum."Rounded Amount";
                            SalaryLine."Ajout  en +" := ABS(SoldeReport);
                            SalaryLine."Net salary cashed" := ABS(SalaryLine."Net salary cashed") + (ABS(SoldeReport));
                        END
                        ELSE BEGIN
                            SalaryLine."Ajout  en +" := ABS(SoldeReport);
                            SalaryLine."Net salary cashed" := ABS(SalaryLine."Net salary cashed") + (ABS(SoldeReport));
                        END;
                    END;
            END;
            //======================= END ARRONDISSEMENT
            IF (SalaryLine."Taxable salary" = 0) AND (SalaryLine."Net salary" <= 0) AND (Sim = 1) THEN
                MgmtSalary2.DeleteLine(SalaryLine)
            ELSE
                SalaryLine.MODIFY;
            EXIT(SalaryLine."Net salary");
        END;
        //FIN WDC PRIME

    end;

}

