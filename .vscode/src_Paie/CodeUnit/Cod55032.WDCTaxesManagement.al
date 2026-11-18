codeunit 55032 "WDC Taxes Management"
{

    var
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
        NbreM: Decimal;
        EMP: Record Employee;
        EmployeeAbsence2: Record "WDC Employee's days off Entry";
        SalaryHeaders: Record "WDC Salary Header";
        Heuresoccaenregm: Record "WDC Occasional Hours Recorded";
        DiffHours: Decimal;
        AbsenceEnreg1: Record "WDC Employee's days off Entry";
        AbsenceEnreg: Record "WDC Employee's days off Entry";
        //GNbJour: Decimal;
        //GNbHeure: Decimal;
        GRecNote: Record "WDC Notes";
        RecGhumainressource: Record "Human Resources Setup";
        RecGIndemnity: Record "WDC Indemnity";
        //TotJoursEnreg: Decimal;
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


    procedure CalcAnnualTaxes(var SalaryLine: Record "WDC Salary Lines")
    var
        ParamRessHum: Record "Human Resources Setup";
        temp: Decimal;
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        Employee: Record Employee;
        SliceImposition: Record "WDC Slices of imposition";
        SliceImpositionX: Record "WDC Slices of imposition";
        a: Decimal;
        b: Decimal;
        c: Decimal;
        d: Decimal;
        e: Decimal;
    begin
        //--> Calcul de l'impôt
        Employee.GET(SalaryLine."Employee No.");
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            //--> Barème standard
                            temp := 0;
                            SliceImposition.RESET;
                            SliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF SliceImposition.FINDFIRST THEN
                                REPEAT
                                    //--> Cumul des tranches inf.
                                    IF ((SalaryLine."Real taxable (Year)" > SliceImposition."Lower limit")
                                        AND
                                        (SalaryLine."Real taxable (Year)" > SliceImposition."Superior limit")
                                       ) THEN
                                        temp := temp + SliceImposition."Slice amount";

                                    //--> Recherche de la tranche d'imposition
                                    IF ((SliceImposition."Lower limit" < SalaryLine."Real taxable (Year)")
                                        AND
                                        (SalaryLine."Real taxable (Year)" <= SliceImposition."Superior limit")
                                       )
                                       OR
                                       ((SalaryLine."Real taxable (Year)" > SliceImposition."Superior limit")
                                        AND
                                        (SalaryLine."Real taxable (Year)" > SliceImposition."Lower limit")
                                        AND
                                        (SliceImposition."Lower limit" > SliceImposition."Superior limit")
                                       ) THEN
                                        SliceImpositionX.COPY(SliceImposition);

                                UNTIL SliceImposition.NEXT = 0;

                            SalaryLine."Taxe (Year)" := ROUND(((SalaryLine."Real taxable (Year)" - SliceImpositionX."Lower limit")
                                                        * SliceImpositionX.Rate / 100) + temp, ParamCpta."Amount Rounding Precision");


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
        //--> Calcul de l'impôt
        Employee.GET(SalaryLine."Employee No.");
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            //--> Barème standard
                            temp := 0;
                            SliceImposition.RESET;
                            SliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF SliceImposition.FINDFIRST THEN
                                REPEAT
                                    //--> Cumul des tranches inf.
                                    IF ((SalaryLine."Real taxable (Year)" > SliceImposition."Lower limit")
                                        AND
                                        (SalaryLine."Real taxable (Year)" > SliceImposition."Superior limit")
                                       ) THEN
                                        temp := temp + SliceImposition."Slice amount";

                                    //--> Recherche de la tranche d'imposition
                                    IF ((SliceImposition."Lower limit" < SalaryLine."Real taxable (Year)")
                                        AND
                                        (SalaryLine."Real taxable (Year)" < SliceImposition."Superior limit")
                                       )
                                       OR
                                       ((SalaryLine."Real taxable (Year)" > SliceImposition."Superior limit")
                                        AND
                                        (SalaryLine."Real taxable (Year)" > SliceImposition."Lower limit")
                                        AND
                                        (SliceImposition."Lower limit" > SliceImposition."Superior limit")
                                       ) THEN
                                        SliceImpositionX.COPY(SliceImposition);

                                UNTIL SliceImposition.NEXT = 0;

                            SalaryLine."Taxe (Year)" := ROUND(((SalaryLine."Real taxable (Year)" - SliceImpositionX."Lower limit")
                                                        * SliceImpositionX.Rate / 100) + temp, ParamCpta."Amount Rounding Precision");

                        END;
                    1:
                        BEGIN
                            //--> Forfait
                            SalaryLine."Taxe (Year)" := ROUND(SalaryLine."Real taxable (Year)"
                                                            * EmploymentContract."Inclusive ratio" / 100, ParamCpta."Amount Rounding Precision")
             ;
                        END;
                END;
            END
            ELSE
                SalaryLine."Taxe (Year)" := 0;

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
                            SliceImposition.RESET;
                            SliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF SliceImposition.FINDFIRST THEN
                                REPEAT
                                    //--> Cumul des tranches inf.
                                    IF ((SalaryLine."Real Taxable PR (Year)" > SliceImposition."Lower limit")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" > SliceImposition."Superior limit")
                                       ) THEN
                                        temp := temp + SliceImposition."Slice amount";

                                    //--> Recherche de la tranche d'imposition
                                    IF ((SliceImposition."Lower limit" < SalaryLine."Real taxable (Year)")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" < SliceImposition."Superior limit"))
                                       OR
                                       ((SalaryLine."Real Taxable PR (Year)" > SliceImposition."Superior limit")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" > SliceImposition."Lower limit")
                                        AND
                                        (SliceImposition."Lower limit" > SliceImposition."Superior limit")
                                       ) THEN
                                        SliceImpositionX.COPY(SliceImposition);

                                UNTIL SliceImposition.NEXT = 0;

                            SalaryLine."Taxe PR (Year)" := ROUND(((SalaryLine."Real Taxable PR (Year)" - SliceImpositionX."Lower limit")
                                                        * SliceImpositionX.Rate / 100) + temp, ParamCpta."Amount Rounding Precision");

                        END;
                    1:
                        BEGIN
                            //--> Forfait
                            SalaryLine."Taxe PR (Year)" := ROUND(SalaryLine."Real Taxable PR (Year)"
                                                            * EmploymentContract."Inclusive ratio" / 100, ParamCpta."Amount Rounding Precision");
                        END;
                END;
            END
            ELSE
                SalaryLine."Taxe PR (Year)" := 0;

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
                            SliceImposition.RESET;
                            SliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            IF SliceImposition.FINDFIRST THEN
                                REPEAT
                                    //--> Cumul des tranches inf.
                                    IF ((SalaryLine."Real Taxable PR (Year)" > SliceImposition."Lower limit")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" > SliceImposition."Superior limit")
                                       ) THEN
                                        temp := temp + SliceImposition."Slice amount";

                                    //--> Recherche de la tranche d'imposition
                                    IF ((SliceImposition."Lower limit" < SalaryLine."Real Taxable PR (Year)")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" < SliceImposition."Superior limit"))
                                       OR
                                       ((SalaryLine."Real Taxable PR (Year)" > SliceImposition."Superior limit")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" > SliceImposition."Lower limit")
                                        AND
                                        (SliceImposition."Lower limit" > SliceImposition."Superior limit")
                                       ) THEN
                                        SliceImpositionX.COPY(SliceImposition);

                                UNTIL SliceImposition.NEXT = 0;

                            SalaryLine."Taxe PR (Year)" := ROUND(((SalaryLine."Real Taxable PR (Year)" - SliceImpositionX."Lower limit")
                                                        * SliceImpositionX.Rate / 100) + temp, ParamCpta."Amount Rounding Precision");

                        END;
                    1:
                        BEGIN
                            //--> Forfait
                            SalaryLine."Taxe PR (Year)" := ROUND(SalaryLine."Real Taxable PR (Year)"
                                                            * EmploymentContract."Inclusive ratio" / 100, ParamCpta."Amount Rounding Precision")
             ;
                        END;
                END;
            END
            ELSE
                SalaryLine."Taxe PR (Year)" := 0;

        END;
    end;


    procedure CalcTaxableIndemnity(var SalaryLine: Record "WDC Salary Lines"; pNbJour: decimal; pNbHeure: decimal; pTotJoursEnreg: decimal)
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
                            Ind."Real Amount" := Ind."Base Amount";
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
                            //>> DEDUCTION DE L'INDEMNITE QU'APARTIRE DU DEPASSEMENT DU NOMBRE DE JOUR ABSENCE
                            CASE SalaryLine."Employee type".AsInteger() OF
                                0:
                                    BEGIN
                                        Ind.Rate := ((SalaryLine."Worked hours") * 100) / pNbHeure;//-SalaryLine.Absences
                                                                                                   //WDC 1112 IF SalaryLine.Month=16 THEN
                                                                                                   //WDC 1112   Ind.Rate := ((SalaryLine."Days off remaining"*100)/pNbJour);
                                        IF RecIndemnity.GET(Ind.Indemnity) THEN
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

                                    END;
                                1:
                                    BEGIN
                                        IF SalaryLine.Month.AsInteger() < 12 THEN
                                            Ind.Rate := ((pTotJoursEnreg) * 100) / pNbJour
                                        ELSE
                                            Ind.Rate := (pNbJour / 12) * 100;
                                        IF RecIndemnity.GET(Ind.Indemnity) THEN
                                            IF RecIndemnity."Deduction Base Indemnity/Days" > (pNbJour - pTotJoursEnreg) THEN
                                                Ind.Rate := 100;
                                        IF Ind.Rate > 100 THEN
                                            Ind.Rate := 100;
                                    END;
                            END;
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
                                Ind.Rate := ((Ind."Days Number" - TotalJoursAbs - SalaryLine."Public Holidays") / Ind."Days Number") * 100;
                            END;
                            // FIN CALCUL INDEMNITE PAR NOMBRE DE JOURS
                            Ind."Real Amount" := Ind."Base Amount" * Ind.Rate / 100;
                            Ind."Real Amount PR" := Ind."Base Amount";
                            Ind."User ID" := USERID;
                            IF Ind."Real Amount" < 0 THEN
                                Ind."Real Amount" := 0;
                        END;
                    2:
                        BEGIN
                            //>> DSFT-AGA 04/07/2010   ABSENCE
                            Ind.Rate := SalaryLine."Assiduity (Worked days)";
                            //>> DSFT AGA 160410  DEDUCTION DE L'INDEMNITE QU'APARTIRE DU DEPASSEMENT DU NOMBRE DE JOUR ABSENCE
                            CASE SalaryLine."Employee type".AsInteger() OF
                                0:
                                    BEGIN
                                        Ind.Rate := ((SalaryLine."Worked hours") * 100) / pNbHeure;//-SalaryLine.Absences
                                        IF (RecIndemnity."Deduction Base Indemnity/Hour") > (pNbHeure - SalaryLine."Worked hours") THEN
                                            Ind.Rate := 100;
                                    END;
                                1:
                                    BEGIN
                                        // Ind.Rate := ((pTotJoursEnreg) *100)/pNbJour;//-SalaryLine.Absences
                                        Ind.Rate := SalaryLine."Assiduity (Worked days)";
                                        IF RecIndemnity.GET(Ind.Indemnity) THEN
                                            IF RecIndemnity."Deduction Base Indemnity/Days" > (pNbJour - pTotJoursEnreg) THEN
                                                Ind.Rate := 100;
                                    END;
                            END;

                            //<< DSFT AGA 160410
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
                            IF ((RecIndemnity."Deduction Base Indemnity/Hour") > (pNbHeure - SalaryLine."Worked hours"))
                            AND ((pNbHeure - SalaryLine."Worked hours") > 0) THEN
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
                                    Ind."Real Amount" := DecMntHoraire * DecNBHeureEncouragement //* Ind.Rate;
                                ELSE
                                    IF SalaryLine.Month.AsInteger() <> 13 THEN BEGIN //pour simulation janvier fevrier mars 2009
                                        Ind."Real Amount" := (Ind."Base Amount" * (SalaryLine."Paied days") / pNbJour)
                                                                           //-SalaryLine.Absences
                                                                           + (DecMntHoraire * DecNBHeureEncouragement);

                                    END//
                                    ELSE
                                        Ind."Real Amount" := (Ind."Base Amount" * (SalaryLine."Paied days") / pNbJour)
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
                            //Ind.Rate                          := SalaryLine."Worked hours"+ SalaryLine."Hours off Balacement";
                            IF SalaryLine."Employee type".AsInteger() = 1 THEN
                                Ind.Rate := SalaryLine."Worked hours" + SalaryLine."Hours off Balacement"
                            ELSE
                                Ind.Rate := SalaryLine."Worked hours" + SalaryLine."Hours off Balacement" +
                                SalaryLine."Hours consumption Holiday";//+ SalaryLine."Heure Jours Free" ;
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
                            //>> DSFT AGA 12/05/2010 CALCUL INDEMNITE PAR JOURS DE TRAVAIL
                            //>>
                            IF SalaryHeader.Month.AsInteger() = 16 THEN BEGIN
                                LigneTravail.RESET;
                                LigneTravail.SETCURRENTKEY("Transaction No.", "Line No.", "Employee No.");
                                LigneTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
                                LigneTravail.SETRANGE("Payment Month", SalaryLine.Month);
                                LigneTravail.SETRANGE("Payment Year", SalaryLine.Year);
                                LigneTravail.FINDLAST;
                                //LigneTravail.CALCSUMS("Hours Number","Line amount","Days Number");

                            END ELSE BEGIN
                                //>>
                                LigneTravail.RESET;
                                LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year", Fortnight);
                                LigneTravail.SETFILTER("Employee No.", SalaryLine."Employee No.");
                                LigneTravail.SETRANGE("Payment Month", SalaryLine.Month);
                                LigneTravail.SETRANGE("Payment Year", SalaryLine.Year);
                                IF ParamRessHum."Activate fortnightly regime" THEN
                                    IF RegimeWork."Payroll Calculation Type" = RegimeWork."Payroll Calculation Type"::Fortnight THEN
                                        LigneTravail.SETFILTER(Fortnight, '%1', SalaryHeader.Fortnight);
                                LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                                //>>
                            END;
                            //<<
                            IF Ind."Deduction Base Indemnity/Days" < (SalaryHeader."Worked days" - LigneTravail."Days Number") THEN
                                Ind.Rate := LigneTravail."Days Number"
                            ELSE BEGIN
                                Ind.Rate := SalaryHeader."Worked days";
                                LigneTravail.CALCSUMS("Hours Number", "Line amount", "Days Number");
                                Ind.Rate := LigneTravail."Days Number"
                            END;
                            IF Ind.Rate < 0 THEN
                                Ind.Rate := 0;
                            tmp := 0;
                            IF Ind."Minimum value" > 0 THEN BEGIN
                                tmp := ROUND(Ind."Base Amount" * Ind.Rate, Ind."Amount Rounding Precision",
                                                                 FORMAT(Ind."Rounding Direction"));
                                IF tmp < Ind."Minimum value" THEN
                                    Ind."Real Amount" := Ind."Minimum value"
                                ELSE
                                    Ind."Real Amount" := tmp;
                            END
                            ELSE
                                Ind."Real Amount" := ROUND(Ind."Base Amount" * Ind.Rate, Ind."Amount Rounding Precision", '>');
                            Ind."Real Amount PR" := ROUND(Ind."Base Amount" * SalaryHeader."Worked days"
                                 , Ind."Amount Rounding Precision");
                            // MC -------------------------------------------------------------------------------------------------
                            Ind."User ID" := USERID;
                        END;


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
                NbreM := 12;
                IF (SalaryLine.Month.AsInteger() = 12) THEN
                    //>>
                    IF Ind."Evaluation mode" = Ind."Evaluation mode"::Inclusive THEN
                        Ind."Real Amount" := Ind."Base Amount" ELSE
                        //<<
                        Ind."Real Amount" := (Ind."Base Amount" * pNbJour) / NbreM;
                //
                Ind.MODIFY;
            UNTIL Ind.NEXT = 0;

    end;



}