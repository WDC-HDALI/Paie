codeunit 55024 "WDC Absences Management"
{

    trigger OnRun()
    begin
    end;

    var
        R5218: Record "Human Resources Setup";
        employee: Record Employee;
        Hdeb: Time;
        Hfin: Time;
        Tim: Time;
        Description: Text[100];
        CodeCal: Code[20];

    procedure CalcJourHeureAbs(EmplAbsence: Record "Employee Absence"; var Journ: Integer) Nbj: Decimal
    var
        T1: Record 2000000007;
        CalendarMgmt: Codeunit 7600;
        NbreHJ: Decimal;
        NbH: Decimal;
        Hfin: Time;
        Hdeb: Time;
        Temps: Decimal;
        HeureDM: Time;
        HeureFM: Time;
        HeureDA: Time;
        HeureFA: Time;
        Nonworking: Boolean;
        NbreHJTmp: Decimal;
        Roul: Boolean;
        Tm: Decimal;
        TA: Decimal;
        JourFree: Boolean;
        Free: Boolean;
        lText001: TextConst ENU = 'Unit must be Day',
                            FRA = 'Unité Doit être Journée';
    begin
        //WITH Rec DO BEGIN
        Journ := EmplAbsence.Unit.AsInteger();
        IF ((EmplAbsence."From Date" <> EmplAbsence."To Date") AND (EmplAbsence.Unit.AsInteger() = 1)) THEN
            ERROR(lText001);
        Nbj := 0;
        NbH := 0;
        Free := FALSE;
        IF EmplAbsence."From Date" <> EmplAbsence."To Date" THEN BEGIN
            T1.RESET;
            T1.SETFILTER("Period Type", '%1', T1."Period Type"::Date);
            T1.SETFILTER("Period Start", '%1..%2', EmplAbsence."From Date", EmplAbsence."To Date");
            IF T1.FINDFIRST THEN
                REPEAT
                    NbreHJ := 0;
                    NbreHJTmp := 0;
                    CalcHJour(EmplAbsence."Employee No.", T1."Period Start", HeureDM, HeureFM, HeureDA, HeureFA, Nonworking, Roul, JourFree);

                    IF NOT Nonworking THEN
                        Free := FALSE;

                    IF JourFree THEN
                        Free := TRUE;
                    NbreHJ := CalcTemp(HeureDM, HeureFM, HeureDA, HeureFA, JourFree);
                    IF HeureDA = 0T THEN
                        Hdeb := HeureDM
                    ELSE
                        Hdeb := HeureDA;
                    Hfin := CalcHfin(HeureFM, HeureFA);
                    Temps := 0;
                    // Date = Date Début
                    IF EmplAbsence."From Date" = T1."Period Start" THEN BEGIN
                        IF NbreHJ <> 0 THEN BEGIN
                            IF EmplAbsence."Starting Time" = 0T THEN
                                Temps := NbreHJ
                            ELSE
                                Temps := calcheureMissjour(EmplAbsence."Employee No.", T1."Period Start", EmplAbsence."Starting Time", Hfin);
                            IF NbreHJ <> 0 THEN
                                Nbj := Nbj + ROUND(Temps / NbreHJ, 0.001);
                            NbH := NbH + Temps;
                        END;
                    END
                    ELSE BEGIN
                        // Date = Date Fin
                        IF EmplAbsence."To Date" = T1."Period Start" THEN BEGIN
                            IF EmplAbsence."Ending Time" = 0T THEN
                                Temps := NbreHJ
                            ELSE
                                Temps := calcheureMissjour(EmplAbsence."Employee No.", T1."Period Start", Hdeb, EmplAbsence."Ending Time");
                            IF NbreHJ <> 0 THEN
                                Nbj := Nbj + ROUND(Temps / NbreHJ, 0.001);
                            NbH := NbH + Temps;
                            IF NbreHJ = 0 THEN BEGIN
                                CalcHJour(EmplAbsence."Employee No.", (T1."Period Start" - 1), HeureDM, HeureFM, HeureDA, HeureFA, Nonworking, Roul, JourFree);

                                NbreHJTmp := CalcTemp(HeureDM, HeureFM, HeureDA, HeureFA, JourFree);

                                IF NbreHJTmp = 0 THEN
                                    Nbj := Nbj - 1;
                            END;
                        END
                        // Date diff de Datedeb and Date Fin
                        ELSE BEGIN
                            IF (JourFree = FALSE) AND (NOT Free) THEN
                                Nbj := Nbj + 1;
                            IF NbreHJ = 0 THEN BEGIN
                                CalcHJour(EmplAbsence."Employee No.", (T1."Period Start" - 1), HeureDM, HeureFM, HeureDA, HeureFA, Nonworking, Roul, JourFree);
                                NbreHJTmp := CalcTemp(HeureDM, HeureFM, HeureDA, HeureFA, JourFree);
                                IF ((NbreHJTmp = 0) AND (JourFree = FALSE)) AND (NOT Free) THEN
                                    Nbj := Nbj - 1;
                            END;
                        END;
                    END;
                UNTIL T1.NEXT = 0;
        END
        // Même Jour
        ELSE BEGIN
            Temps := 0;
            NbreHJ := 0;
            CalcHJour(EmplAbsence."Employee No.", EmplAbsence."From Date", HeureDM, HeureFM, HeureDA, HeureFA, Nonworking, Roul, JourFree);

            NbreHJ := CalcTemp(HeureDM, HeureFM, HeureDA, HeureFA, JourFree);

            Temps := calcheureMissjour(EmplAbsence."Employee No.", EmplAbsence."From Date", EmplAbsence."Starting Time", EmplAbsence."Ending Time");
            IF NbreHJ <> 0 THEN
                Nbj := Nbj + ROUND(Temps / NbreHJ, 0.001);
            NbH := NbH + Temps;
        END;
        // Calcul Jour D'après

        Hfin := CalcHfin(HeureFM, HeureFA);
        NbreHJ := 0;
        CalcHJour(EmplAbsence."Employee No.", (EmplAbsence."To Date" + 1), HeureDM, HeureFM, HeureDA, HeureFA, Nonworking, Roul, JourFree);

        NbreHJ := CalcTemp(HeureDM, HeureFM, HeureDA, HeureFA, JourFree);

        Temps := 0;
        IF (NbreHJ = 0) AND ((Hfin = EmplAbsence."Ending Time") OR ((EmplAbsence."Ending Time" = 0T) AND (EmplAbsence.Unit.AsInteger() = 0))) AND (Roul = FALSE) THEN BEGIN
            IF (NOT JourFree) AND (NOT Free) THEN
                Nbj := Nbj + 1;
            IF (Journ = 1) AND ((EmplAbsence."From Date" <> EmplAbsence."To Date") OR (Nbj > 1)) THEN
                Journ := 0;
        END;
        IF (Journ = 1) THEN
            Nbj := NbH;
        //END;
    end;

    procedure CalcHfin(HeureFM: Time; HeureFA: Time) Hfin: Time
    begin
        IF HeureFA = 0T THEN
            Hfin := HeureFM
        ELSE
            Hfin := HeureFA;
    end;

    procedure CalcTemp(var HeureDM: Time; var HeureFM: Time; var HeureDA: Time; var HeureFA: Time; Jourfree: Boolean) TimeT: Decimal
    var
        Tm: Decimal;
        TA: Decimal;
    begin
        TimeT := 0;
        IF NOT Jourfree THEN BEGIN
            Tm := 0;
            TA := 0;
            IF HeureFM < HeureDM THEN
                Tm := (((235959T - HeureDM) + (HeureFM - 000000T) + 1) / 3600000)
            ELSE
                Tm := (HeureFM - HeureDM) / 3600000;
            IF HeureFA < HeureDA THEN
                TA := (((235959T - HeureDA) + (HeureFA - 000000T) + 1) / 3600000)
            ELSE
                TA := (HeureFA - HeureDA) / 3600000;
            TimeT := Tm + TA;
        END;
    end;

    procedure calcheureMissjour(var NSal: Code[20]; DateT: Date; HeureDeb: Time; HeureFin: Time) HeurT: Decimal
    var
        datdeb1: Time;
        dateDeb2: Time;
        datefin1: Time;
        dateFin2: Time;
        NoWork: Boolean;
        CalendarMgmt: Codeunit 7600;
        lSalaryMgt2: Codeunit "WDC Salary Management 2";
        ContratT: Record "Employment Contract";
        Jour: Decimal;
        HeureDeb1: Time;
        heureFin1: Time;
        DatedebR: Date;
        Jourfree: Boolean;
        Roul: Boolean;

    begin
        Jour := 0;
        HeurT := 0;
        employee.GET(NSal);
        datdeb1 := 000000T;
        datefin1 := 000000T;
        dateDeb2 := 000000T;
        dateFin2 := 000000T;

        Tim := 000000T;
        DatedebR := 0D;
        CLEAR(contratT);
        contratT.GET(employee."Emplymt. Contract Code");
        contratT.TESTFIELD("Code Calendar");

        BEGIN
            HeurT := 0;
            //nowork := CalendarMgmt.CheckDateStatus(CodeCal, DateT, txt);
            nowork := CheckDateStatus(CodeCal, DateT, Description);
            IF nowork = FALSE THEN BEGIN

                IF (dateFin2 = 0T) AND (dateDeb2 = 0T) THEN
                    Jour := ((datefin1 - datdeb1)) / 3600000;
                IF (datefin1 = 0T) AND (datdeb1 = 0T) THEN
                    Jour := ((dateFin2 - dateDeb2)) / 3600000;

                IF (datefin1 <> 0T) AND (datdeb1 <> 0T) AND (dateFin2 <> 0T) AND (dateDeb2 <> 0T) THEN
                    Jour := ((datefin1 - datdeb1) + (dateFin2 - dateDeb2)) / 3600000;

                IF ((HeureDeb <= datdeb1) AND (HeureDeb <> 0T)) OR (HeureDeb = 0T) AND (datdeb1 <> 0T) THEN
                    HeureDeb := datdeb1;
                IF ((HeureDeb <= dateDeb2) AND (HeureDeb >= datefin1)) AND (HeureDeb <> 0T) AND (dateDeb2 <> 0T) THEN
                    HeureDeb := dateDeb2;
                IF ((HeureFin >= datefin1) AND (dateFin2 = 0T)) THEN
                    HeureFin := datefin1;

                IF (HeureFin <= dateDeb2) AND (HeureFin <> 0T) THEN
                    HeurT := (datefin1 - HeureDeb) / 3600000;
                IF (HeureFin <= datefin1) THEN
                    HeurT := (HeureFin - HeureDeb) / 3600000;

                IF (HeureFin >= dateDeb2) AND (dateDeb2 <> 0T) THEN BEGIN
                    IF HeureDeb <= datefin1 THEN
                        HeurT := ((datefin1 - HeureDeb) + (HeureFin - dateDeb2)) / 3600000
                    ELSE
                        HeurT := (HeureFin - HeureDeb) / 3600000;
                END;
            END
        END;

    end;


    Procedure CheckDateStatus(CalendarCode: Code[10]; TargetDate: Date; VAR Description: Text[50]): Boolean
    var
        lBaseCalChange: Record "Customized Calendar Change";
    begin
        lBaseCalChange.RESET;
        lBaseCalChange.SETRANGE("Base Calendar Code", CalendarCode);
        IF lBaseCalChange.FINDSET THEN
            REPEAT
                CASE lBaseCalChange."Recurring System" OF
                    lBaseCalChange."Recurring System"::" ":
                        IF TargetDate = lBaseCalChange.Date THEN BEGIN
                            Description := lBaseCalChange.Description;
                            EXIT(lBaseCalChange.Nonworking);
                        END;
                    lBaseCalChange."Recurring System"::"Weekly Recurring":
                        IF DATE2DWY(TargetDate, 1) = lBaseCalChange.Day THEN BEGIN
                            Description := lBaseCalChange.Description;
                            EXIT(lBaseCalChange.Nonworking);
                        END;
                    lBaseCalChange."Recurring System"::"Annual Recurring":
                        IF (DATE2DMY(TargetDate, 2) = DATE2DMY(lBaseCalChange.Date, 2)) AND
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(lBaseCalChange.Date, 1))
                        THEN BEGIN
                            Description := lBaseCalChange.Description;
                            EXIT(lBaseCalChange.Nonworking);
                        END;
                END;
            UNTIL lBaseCalChange.NEXT = 0;
        Description := '';
    end;




    procedure ValidateEmployeeAbsence(Transaction: Integer; EmployeeAbsence: Record "Employee Absence"; var seq: Integer)
    var
        HumanResSetup: Record "Human Resources Setup";
        Saved: Record "WDC Employee's days off Entry";
        err: TextConst ENU = 'Impossible to proceed to conversion Work day / Work hour.\From Work day to Work hour nul in Human Resources Setup.',
                       FRA = 'Impossible de procéder à la conversion Jour de travail / Heure de travail.\De Jour de travail à Heure de travail nul dans les paramètres de Ressources Humaines.';
        HumanResourceCommentLine: Record "Human Resource Comment Line";
        SavedHumResCommentLine: Record "Human Resource Comment Line";
        ContEmp: Record 5211;
        Sal: Record Employee;
        Regim: Record 55003;
        ParamCpt: Record 98;
        SavedTmp: Record 55021;
        LSalaryHeaders: Record 55022;
    begin

        R5218.GET();
        HumanResSetup.RESET;
        HumanResSetup.FINDFIRST;
        Saved.RESET;
        Saved.INIT;
        Saved."Transaction No." := Transaction;
        Saved."Entry No." := seq;
        Saved."Employee No." := EmployeeAbsence."Employee No.";
        Saved."From Date" := EmployeeAbsence."From Date";
        Saved."To Date" := EmployeeAbsence."To Date";
        Saved."Cause of Absence Code" := EmployeeAbsence."Cause of Absence Code";
        Saved.Description := EmployeeAbsence.Description;
        Saved.Quantity := EmployeeAbsence.Quantity;
        Saved."Starting Time" := EmployeeAbsence."Starting Time";
        Saved."Ending Time" := EmployeeAbsence."Ending Time";
        Saved.Unit := EmployeeAbsence.Unit;
        Saved."Impute on days off" := EmployeeAbsence."To impute on days off";
        Saved."Posting month" := EmployeeAbsence."Posting month";
        Saved."Posting year" := EmployeeAbsence."Posting year";
        Saved."Line type" := EmployeeAbsence."Line type";
        Saved."Validity Date" := EmployeeAbsence."Validity Date";
        Saved."Absence Reason" := EmployeeAbsence."Absence Reason";
        LSalaryHeaders.RESET;
        IF LSalaryHeaders.FINDSET THEN
            Saved.VALIDATE("Payment No.", LSalaryHeaders."No.");
        IF EmployeeAbsence."Line type".AsInteger() = 6 THEN
            Saved."Recovery Entry No." := Saved."Entry No.";
        IF EmployeeAbsence."Line type".AsInteger() = 7 THEN BEGIN
            Saved."Recovery Entry No." := EmployeeAbsence."Recovery Entry No.";
            CLEAR(SavedTmp);
            Saved."Validity Date" := WORKDATE;
        END;
        IF EmployeeAbsence."Line type".AsInteger() = 1 THEN
            IF employee.GET(EmployeeAbsence."Employee No.") THEN BEGIN
                Saved."Employee Posting Group" := employee."Empl. Posting Group";
                Saved."Global dimension 1" := employee."Global Dimension 1 Code";
                Saved."Global dimension 2" := employee."Global Dimension 2 Code";
            END;

        Saved."User ID" := USERID;
        Saved."Last Modified Date" := WORKDATE;
        Sal.GET(EmployeeAbsence."Employee No.");
        ContEmp.GET(Sal."Emplymt. Contract Code");
        Regim.GET(ContEmp."Work Regime");

        CASE EmployeeAbsence.Unit.AsInteger() OF
            0:
                BEGIN
                    CASE EmployeeAbsence."Line type".AsInteger() OF
                        0:
                            Saved."Quantity (Days)" := +EmployeeAbsence.Quantity;
                        1, 6:
                            Saved."Quantity (Days)" := +EmployeeAbsence.Quantity;
                        2, 5, 7, 8:
                            Saved."Quantity (Days)" := -EmployeeAbsence.Quantity;
                        3:
                            Saved."Quantity (Days)" := -EmployeeAbsence.Quantity;
                        4, 9:
                            BEGIN
                                IF (EmployeeAbsence.Quantity - R5218."1/2 solde à partir de") > 0
                                  THEN
                                    Saved."Quantity (Days)" := -(EmployeeAbsence.Quantity - R5218."1/2 solde à partir de") / 2
                                ELSE
                                    Saved."Quantity (Days)" := 0;
                            END;
                    END;
                    CASE EmployeeAbsence."Line type".AsInteger() OF
                        0:
                            Saved."Quantity (Hours)" := +EmployeeAbsence.Quantity * (Regim."Work Hours per month" / Regim."Worked Day Per Month");
                        1, 6:
                            Saved."Quantity (Hours)" := +EmployeeAbsence.Quantity * (Regim."Work Hours per month" / Regim."Worked Day Per Month");
                        2, 5, 7, 8:
                            Saved."Quantity (Hours)" := -EmployeeAbsence.Quantity * (Regim."Work Hours per month" / Regim."Worked Day Per Month");
                        3:
                            Saved."Quantity (Hours)" := -EmployeeAbsence.Quantity * (Regim."Work Hours per month" / Regim."Worked Day Per Month");
                        4, 9:
                            BEGIN
                                IF (EmployeeAbsence.Quantity - R5218."1/2 solde à partir de") > 0
                                  THEN
                                    Saved."Quantity (Hours)" := -(EmployeeAbsence.Quantity *
                                                                 (Regim."Work Hours per month" / Regim."Worked Day Per Month"))
                                                               - (R5218."1/2 solde à partir de" *
                                                                (Regim."Work Hours per month" / Regim."Worked Day Per Month")) / 2
                                ELSE
                                    Saved."Quantity (Hours)" := 0;
                            END;
                    END;

                END;
            1:
                BEGIN
                    IF (Regim."Work Hours per month" <= 0) OR (Regim."Worked Day Per Month" <= 0) THEN
                        ERROR(err);
                    CASE EmployeeAbsence."Line type".AsInteger() OF
                        0:
                            Saved."Quantity (Hours)" := +EmployeeAbsence.Quantity;
                        1, 6:
                            Saved."Quantity (Hours)" := +EmployeeAbsence.Quantity;
                        2, 5, 7, 8:
                            Saved."Quantity (Hours)" := -EmployeeAbsence.Quantity;
                        3:
                            Saved."Quantity (Hours)" := -EmployeeAbsence.Quantity;
                        4, 9:
                            BEGIN
                                IF (EmployeeAbsence.Quantity - R5218."1/2 solde à partir de") > 0
                                  THEN
                                    Saved."Quantity (Hours)" := -(EmployeeAbsence.Quantity - R5218."1/2 solde à partir de") / 2
                                ELSE
                                    Saved."Quantity (Hours)" := 0;
                            END;
                    END;
                    CASE EmployeeAbsence."Line type".AsInteger() OF
                        0:
                            Saved."Quantity (Days)" := +EmployeeAbsence.Quantity / (Regim."Work Hours per month" / Regim."Worked Day Per Month");
                        1, 6:
                            Saved."Quantity (Days)" := +EmployeeAbsence.Quantity / (Regim."Work Hours per month" / Regim."Worked Day Per Month");
                        2, 5, 7, 8:
                            Saved."Quantity (Days)" := -EmployeeAbsence.Quantity / (Regim."Work Hours per month" / Regim."Worked Day Per Month");
                        3:
                            Saved."Quantity (Days)" := -EmployeeAbsence.Quantity / (Regim."Work Hours per month" / Regim."Worked Day Per Month");
                        4, 9:
                            BEGIN
                                IF (EmployeeAbsence.Quantity - R5218."1/2 solde à partir de") > 0
                                  THEN
                                    Saved."Quantity (Days)" := -(EmployeeAbsence.Quantity /
                                                                 (Regim."Work Hours per month" / Regim."Worked Day Per Month"))
                                                               - (R5218."1/2 solde à partir de" /
                                                                (Regim."Work Hours per month" / Regim."Worked Day Per Month")) / 2
                                ELSE
                                    Saved."Quantity (Days)" := 0;
                            END;
                    END;
                END;
        END;
        //NE
        Saved."Quantity (Days)" := ROUND(Saved."Quantity (Days)", 0.01);
        Saved."Quantity (Hours)" := ROUND(Saved."Quantity (Hours)", 0.01);
        // Verif autoris
        IF (EmployeeAbsence.Unit.AsInteger() = 0) AND (EmployeeAbsence."From Date" <> EmployeeAbsence."To Date") THEN BEGIN
            Hdeb := 000000T;
            Hfin := 235959T;
        END ELSE BEGIN
            Hdeb := EmployeeAbsence."Starting Time";
            Hfin := EmployeeAbsence."Ending Time";
        END;
        HumanResourceCommentLine.SETRANGE("Table Name", 4);
        HumanResourceCommentLine.SETRANGE("Table Line No.", EmployeeAbsence."Entry No.");

        IF HumanResourceCommentLine.FINDFIRST THEN
            REPEAT
                SavedHumResCommentLine.RESET;
                SavedHumResCommentLine.COPY(HumanResourceCommentLine);
                SavedHumResCommentLine.Code := EmployeeAbsence."Employee No.";
                SavedHumResCommentLine."Table Name" := Enum::"Human Resources Comment Table Name".FromInteger(7);
                SavedHumResCommentLine.INSERT;
                HumanResourceCommentLine.DELETE;
            UNTIL HumanResourceCommentLine.NEXT = 0;
        ParamCpt.GET;
        IF EmployeeAbsence."Line type".AsInteger() = 1 THEN
            Saved."Line amount" := ROUND((Sal."Basis salary" / Regim."Worked Day Per Month") * Saved."Quantity (Days)"
                                   , ParamCpt."Amount Rounding Precision");
        IF EmployeeAbsence."Line type".AsInteger() = 3 THEN
            IF EmployeeAbsence."To impute on days off" THEN BEGIN
                SavedTmp.INIT;
                SavedTmp := Saved;
                SavedTmp."Entry No." := Saved."Entry No." + 1;
                SavedTmp."Transaction No." := Saved."Transaction No." + 1;
                SavedTmp."Impute on days off" := TRUE;
                SavedTmp."Line type" := SavedTmp."Line type"::"Day off Consumption";
                IF SavedTmp.INSERT THEN BEGIN
                    Saved."Impute on days off" := FALSE;
                    Transaction := Transaction + 1;
                    seq := seq + 1;
                END;
            END;
        IF EmployeeAbsence."Line type".AsInteger() = 9 THEN BEGIN
            SavedTmp.INIT;
            SavedTmp := Saved;
            SavedTmp."Entry No." := Saved."Entry No." + 1;
            SavedTmp."Transaction No." := Saved."Transaction No." + 1;
            SavedTmp."Line type" := SavedTmp."Line type"::"Deductible from bonus";
            CASE EmployeeAbsence.Unit.AsInteger() OF
                0:
                    BEGIN
                        SavedTmp."Quantity (Hours)" := -EmployeeAbsence.Quantity * (Regim."Work Hours per month" / Regim."Worked Day Per Month");
                        SavedTmp."Quantity (Days)" := -EmployeeAbsence.Quantity;
                    END;
                1:
                    BEGIN
                        SavedTmp."Quantity (Days)" := -EmployeeAbsence.Quantity / (Regim."Work Hours per month" / Regim."Worked Day Per Month");
                        SavedTmp."Quantity (Hours)" := -EmployeeAbsence.Quantity;
                    END;
            END;
            IF SavedTmp.INSERT THEN BEGIN
                Saved."Line type" := Saved."Line type"::"1/2 Paid";
                Saved."Impute on days off" := FALSE;
                Transaction := Transaction + 1;
                seq := seq + 1;
            END;
        END;

        IF Saved.INSERT THEN BEGIN
            IF (EmployeeAbsence."From Date" = DMY2DATE(1, EmployeeAbsence."Posting month".AsInteger() + 1, EmployeeAbsence."Posting year")) AND
               (EmployeeAbsence."To Date" = CALCDATE('<+CM>', EmployeeAbsence."From Date")) AND
               (EmployeeAbsence."Line type".AsInteger() = 3) AND
                (WORKDATE <= EmployeeAbsence."To Date") THEN BEGIN
                Sal.RESET;
                Sal.GET(EmployeeAbsence."Employee No.");
                Sal.Status := Sal.Status::Inactive;
                Sal.MODIFY;
            END;
        END;
        IF EmployeeAbsence.DELETE THEN;

    end;

    procedure "SoderDroitCongé"(Transaction: Integer; var SalaryLine: Record "WDC Salary Lines")
    var
        DaysOffEntry: Record 55021;
        Temp: Decimal;
        SalaryHeader: Record 55022;
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record 55003;
        txtStd: TextConst ENU = 'Balance Day off :',
                          FRA = 'Solde congés :';
        DaysOffEntryTmp: Record "WDC Salary Grid Lines";
        ij: Integer;
        QtyEnCours: Integer;
    begin
        ij := 0;
        DaysOffEntryTmp.RESET;
        IF DaysOffEntryTmp.FINDLAST() THEN
            ij := DaysOffEntryTmp."Entry No.";
        ij := ij + 1;
        IF (SalaryLine."Days off balacement" <> 0) THEN BEGIN
            DaysOffEntry.RESET;
            DaysOffEntry."Transaction No." := Transaction;
            DaysOffEntry."Entry No." := ij;
            DaysOffEntry."Employee No." := SalaryLine."Employee No.";
            DaysOffEntry."From Date" := 0D;
            DaysOffEntry."To Date" := 0D;
            DaysOffEntry."Cause of Absence Code" := '';
            DaysOffEntry.Description := 'AUTO --> ' + txtStd + ' ' + FORMAT(WORKDATE);
            DaysOffEntry.Quantity := -ABS(SalaryLine."Days off balacement");
            DaysOffEntry.Unit := DaysOffEntry.Unit::Workday;
            DaysOffEntry."Impute on days off" := FALSE;
            DaysOffEntry."Posting month" := SalaryLine.Month;
            DaysOffEntry."Posting year" := SalaryLine.Year;
            DaysOffEntry."Line type" := DaysOffEntry."Line type"::"Day off Right";
            IF SalaryHeader.GET(SalaryLine."No.") THEN
                IF EmploymentContract.GET(SalaryLine."Emplymt. Contract Code") THEN
                    IF RegimeWork.GET(SalaryLine."Employee Work Regime") THEN
                        IF RegimeWork."Assignement mode".AsInteger() = 1 THEN BEGIN
                            QtyEnCours := RegimeWork."Days off per month";
                        END
                        ELSE BEGIN
                            QtyEnCours := ROUND(RegimeWork."Days off per month" * SalaryLine."Assiduity (Paid days)" /
                            100, 0.001);
                        END;
            DaysOffEntry."Quantity (Days)" := -ABS(SalaryLine."Days off balacement" + QtyEnCours);
            DaysOffEntry."Payment No." := SalaryLine."No.";
            DaysOffEntry."Absence Reason" := DaysOffEntry."Absence Reason"::"Special Leave";
            DaysOffEntry."User ID" := USERID;
            DaysOffEntry.Management := SalaryLine.Management;
            DaysOffEntry.service := SalaryLine.Service;
            DaysOffEntry.section := SalaryLine.Section;
            DaysOffEntry.INSERT;
        END
    end;


    procedure ValidAbsence(var EmployeeAbsence: Record 5207)
    var
        SavedTmp: Record "WDC Employee's days off Entry";
        i: Integer;
        J: Integer;
        Window: Dialog;
        K: Integer;
        lText001: TextConst ENU = 'Absence validation successfully completed',
                            FRA = 'Validation absences terminée avec succès';
    begin
        SavedTmp.RESET;
        i := 0;
        J := 0;
        K := 0;
        IF SavedTmp.FINDLAST() THEN BEGIN
            i := SavedTmp."Entry No.";
            J := SavedTmp."Transaction No.";
        END;
        IF EmployeeAbsence.FINDFIRST THEN BEGIN
            Window.OPEN('Validatation Absence :           \' +
                        '                                 \' +
                        'N° Salariée  #1##################\' +
                        '@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ');
            REPEAT
                i := i + 1;
                K := K + 1;
                J := J + 1;
                Window.UPDATE(1, EmployeeAbsence."Employee No.");
                Window.UPDATE(2, ROUND(K / EmployeeAbsence.COUNT, 0.01) * 100000);
                // NE NE
                EmployeeAbsence.TestField("Line type");
                IF VerifAbsNonComptabiliser(EmployeeAbsence, J, i) THEN BEGIN
                    ValidateEmployeeAbsence((J), EmployeeAbsence, i);
                    IF EmployeeAbsence."Cause of Absence Code" <> 'ABNJ' THEN //WDC
                        EmployeeAbsence.InsertionCP(EmployeeAbsence."Employee No.");//WDC INSERTION
                                                                                    // InsertDetailConge(EmployeeAbsence."Employee No.",i);
                END;
            UNTIL EmployeeAbsence.NEXT = 0;
        END;
        MESSAGE(lText001);
    end;



    procedure VerifAbsNonComptabiliser(EmployeeAbsence: Record "Employee Absence"; Transaction: Integer; seq: Integer) NFalse: Boolean
    var
        CauseAbs: Record 5206;
        AbsEnreg: Record "WDC Employee's days off Entry";
        ContEmp: Record "Employment Contract";
        Regim: Record "WDC work Regimes";
        Sal: Record Employee;
        QteJ: Decimal;
        HumanResSetup: Record "Human Resources Setup";
        EmployeeAbsenceTmp: Record "Employee Absence";
        CauseAbsTmp: Record 5206;
        EmployeeAbsenceTmp1: Record "Employee Absence";
        QteX: Decimal;
        Seq1: Integer;
        Trans1: Integer;
        EmployeeAbsenceTmp2: Record "Employee Absence";
        EmployeeAbsenceTmp3: Record "Employee Absence";
        EmployeeAbs: Record "Employee Absence";
    begin
        CLEAR(CauseAbs);
        EmployeeAbs := EmployeeAbsence;
        HumanResSetup.GET;
        NFalse := TRUE;
        QteJ := 0;
        IF CauseAbs.GET(EmployeeAbsence."Cause of Absence Code") THEN;
        IF (CauseAbs.Type.AsInteger() IN [5, 8, 9]) AND (CauseAbs."Authorized Days number" <> 0) THEN BEGIN
            CLEAR(AbsEnreg);
            AbsEnreg.RESET;
            AbsEnreg.SETCURRENTKEY("Posting year", "Line type", "Cause of Absence Code", "Employee No.");
            AbsEnreg.SETRANGE("Posting year", EmployeeAbsence."Posting year");
            AbsEnreg.SETRANGE("Line type", 5);
            AbsEnreg.SETRANGE("Cause of Absence Code", EmployeeAbsence."Cause of Absence Code");
            AbsEnreg.SETRANGE("Employee No.", EmployeeAbsence."Employee No.");
            AbsEnreg.CALCSUMS("Quantity (Days)");

            CLEAR(Sal);
            Sal.GET(EmployeeAbsence."Employee No.");
            CLEAR(ContEmp);
            ContEmp.GET(Sal."Emplymt. Contract Code");
            CLEAR(Regim);
            Regim.GET(ContEmp."Work Regime");
            IF EmployeeAbsence.Unit.AsInteger() = 0 THEN
                QteJ := EmployeeAbsence.Quantity
            ELSE
                QteJ := ROUND((EmployeeAbsence.Quantity / (Regim."Work Hours per month" / Regim."Worked Day Per Month")), 0.01);
            IF ABS(AbsEnreg."Quantity (Days)") + QteJ <= CauseAbs."Authorized Days number" THEN BEGIN
                NFalse := FALSE;
                ValidateEmployeeAbsence(Transaction, EmployeeAbsence, seq);

            END ELSE BEGIN
                // abs 1
                IF (ABS(AbsEnreg."Quantity (Days)") + QteJ) <=
                    (CauseAbs."Auth. Days number Period 1" + CauseAbs."Authorized Days number") THEN BEGIN
                    EmployeeAbsenceTmp := EmployeeAbs;
                    NFalse := FALSE;
                    QteX := CauseAbs."Authorized Days number" - ABS(AbsEnreg."Quantity (Days)");
                    IF QteX < 0 THEN
                        QteX := 0;
                    IF EmployeeAbsence.Unit.AsInteger() = 0 THEN
                        EmployeeAbsence.VALIDATE(Quantity, QteX)
                    ELSE
                        EmployeeAbsence.VALIDATE(Quantity, QteX *
                            (Regim."Work Hours per month" / Regim."Worked Day Per Month"));
                    IF QteX <> 0 THEN
                        ValidateEmployeeAbsence(Transaction, EmployeeAbsence, seq);
                    EmployeeAbsenceTmp."From Date" := EmployeeAbsence."To Date" + 1;
                    EmployeeAbsenceTmp.VALIDATE(Quantity, (EmployeeAbsenceTmp.Quantity - EmployeeAbsence.Quantity));
                    CauseAbs.TESTFIELD("Cause Code Period 1");
                    EmployeeAbsenceTmp.VALIDATE("Cause of Absence Code", CauseAbs."Cause Code Period 1");
                    IF QteX <> 0 THEN BEGIN
                        Transaction := Transaction + 1;
                        seq := seq + 1;
                        ValidateEmployeeAbsence(Transaction, EmployeeAbsenceTmp, seq);
                    END
                    ELSE
                        ValidateEmployeeAbsence(Transaction, EmployeeAbsenceTmp, seq);
                    // fin Abs 1
                END ELSE BEGIN
                    IF (ABS(AbsEnreg."Quantity (Days)") + QteJ) <=
                        (CauseAbs."Auth. Days number Period 1" + CauseAbs."Authorized Days number"
                         + CauseAbs."Auth. Days number Period 2") THEN BEGIN
                        EmployeeAbsenceTmp := EmployeeAbs;
                        EmployeeAbsenceTmp1 := EmployeeAbs;
                        QteX := CauseAbs."Authorized Days number" - ABS(AbsEnreg."Quantity (Days)");
                        IF QteX < 0 THEN
                            QteX := 0;
                        NFalse := FALSE;
                        IF EmployeeAbsence.Unit.AsInteger() = 0 THEN
                            EmployeeAbsence.VALIDATE(Quantity, QteX)
                        ELSE
                            EmployeeAbsence.VALIDATE(Quantity, (QteX) *
                             (Regim."Work Hours per month" / Regim."Worked Day Per Month"));
                        IF QteX <> 0 THEN
                            ValidateEmployeeAbsence(Transaction, EmployeeAbsence, seq);
                        Seq1 := seq;
                        Trans1 := Transaction;
                        IF QteX <> 0 THEN BEGIN
                            Seq1 := seq + 1;
                            Trans1 := Transaction + 1;
                        END;
                        QteX := CauseAbs."Auth. Days number Period 1" - ABS(AbsEnreg."Quantity (Days)") - QteX;
                        IF QteX < 0 THEN
                            QteX := 0;
                        IF EmployeeAbsenceTmp.Unit.AsInteger() = 0 THEN
                            EmployeeAbsenceTmp.VALIDATE(Quantity, (QteX))
                        ELSE
                            EmployeeAbsenceTmp.VALIDATE(Quantity, (QteX) *
                                       (Regim."Work Hours per month" / Regim."Worked Day Per Month"));
                        CauseAbs.TESTFIELD("Cause Code Period 1");
                        EmployeeAbsenceTmp.VALIDATE("Cause of Absence Code", CauseAbs."Cause Code Period 1");
                        IF QteX <> 0 THEN BEGIN
                            ValidateEmployeeAbsence(Trans1, EmployeeAbsenceTmp, Seq1);
                            Seq1 := Seq1 + 1;
                            Trans1 := Trans1 + 1;
                        END;
                        CauseAbs.TESTFIELD("Cause Code Period 2");
                        EmployeeAbsenceTmp1.VALIDATE("Cause of Absence Code", CauseAbs."Cause Code Period 2");
                        EmployeeAbsenceTmp1.VALIDATE(Quantity, (EmployeeAbsenceTmp1.Quantity -
                            EmployeeAbsence.Quantity - EmployeeAbsenceTmp.Quantity));
                        ValidateEmployeeAbsence(Trans1, EmployeeAbsenceTmp1, Seq1);
                    END
                    ELSE BEGIN
                        IF (ABS(AbsEnreg."Quantity (Days)") + QteJ) <=
                            (CauseAbs."Auth. Days number Period 1" + CauseAbs."Authorized Days number"
                             + CauseAbs."Auth. Days number Period 2" + CauseAbs."Auth. Days Number Period 3") THEN BEGIN
                            EmployeeAbsenceTmp := EmployeeAbs;
                            EmployeeAbsenceTmp1 := EmployeeAbs;
                            EmployeeAbsenceTmp2 := EmployeeAbs;

                            QteX := CauseAbs."Authorized Days number" - ABS(AbsEnreg."Quantity (Days)");
                            IF QteX < 0 THEN
                                QteX := 0;
                            NFalse := FALSE;
                            IF EmployeeAbsence.Unit.AsInteger() = 0 THEN
                                EmployeeAbsence.VALIDATE(Quantity, QteX)
                            ELSE
                                EmployeeAbsence.VALIDATE(Quantity, (QteX) *
                                 (Regim."Work Hours per month" / Regim."Worked Day Per Month"));
                            IF QteX <> 0 THEN
                                ValidateEmployeeAbsence(Transaction, EmployeeAbsence, seq);
                            Seq1 := seq;
                            Trans1 := Transaction;
                            IF QteX <> 0 THEN BEGIN
                                Seq1 := seq + 1;
                                Trans1 := Transaction + 1;
                            END;
                            QteX := CauseAbs."Auth. Days number Period 1" - ABS(AbsEnreg."Quantity (Days)") - QteX;
                            IF QteX < 0 THEN
                                QteX := 0;
                            IF EmployeeAbsenceTmp.Unit.AsInteger() = 0 THEN
                                EmployeeAbsenceTmp.VALIDATE(Quantity, (QteX))
                            ELSE
                                EmployeeAbsenceTmp.VALIDATE(Quantity, (QteX) *
                                           (Regim."Work Hours per month" / Regim."Worked Day Per Month"));
                            CauseAbs.TESTFIELD("Cause Code Period 1");
                            EmployeeAbsenceTmp.VALIDATE("Cause of Absence Code", CauseAbs."Cause Code Period 1");
                            IF QteX <> 0 THEN BEGIN
                                ValidateEmployeeAbsence(Trans1, EmployeeAbsenceTmp, Seq1);
                                Seq1 := Seq1 + 1;
                                Trans1 := Trans1 + 1;
                            END;
                            CauseAbs.TESTFIELD("Cause Code Period 2");
                            EmployeeAbsenceTmp1.VALIDATE("Cause of Absence Code", CauseAbs."Cause Code Period 2");
                            QteX := CauseAbs."Auth. Days number Period 2" - ABS(AbsEnreg."Quantity (Days)") - QteX;
                            IF EmployeeAbsenceTmp1.Unit.AsInteger() = 0 THEN
                                EmployeeAbsenceTmp1.VALIDATE(Quantity, (QteX))
                            ELSE
                                EmployeeAbsenceTmp1.VALIDATE(Quantity, (QteX) *
                                (Regim."Work Hours per month" / Regim."Worked Day Per Month"));
                            IF QteX <> 0 THEN BEGIN
                                ValidateEmployeeAbsence(Trans1, EmployeeAbsenceTmp1, Seq1);
                                Seq1 := Seq1 + 1;
                                Trans1 := Trans1 + 1;
                            END;
                            CauseAbs.TESTFIELD("Cause Code Period 3");
                            EmployeeAbsenceTmp2.VALIDATE("Cause of Absence Code", CauseAbs."Cause Code Period 3");
                            EmployeeAbsenceTmp2.VALIDATE(Quantity, (EmployeeAbsenceTmp2.Quantity -
                                EmployeeAbsence.Quantity - EmployeeAbsenceTmp.Quantity - EmployeeAbsenceTmp1.Quantity));
                            ValidateEmployeeAbsence(Trans1, EmployeeAbsenceTmp2, Seq1);

                        END
                        ELSE BEGIN

                            QteX := CauseAbs."Authorized Days number" - ABS(AbsEnreg."Quantity (Days)");
                            IF QteX < 0 THEN
                                QteX := 0;
                            NFalse := FALSE;
                            IF EmployeeAbsence.Unit.AsInteger() = 0 THEN
                                EmployeeAbsence.VALIDATE(Quantity, QteX)
                            ELSE
                                EmployeeAbsence.VALIDATE(Quantity, (QteX) *
                                 (Regim."Work Hours per month" / Regim."Worked Day Per Month"));
                            IF QteX <> 0 THEN
                                ValidateEmployeeAbsence(Transaction, EmployeeAbsence, seq)
                            ELSE BEGIN
                                EmployeeAbsence.Quantity := 0;
                                EmployeeAbsence.DELETE;
                            END;
                            Seq1 := seq;
                            Trans1 := Transaction;
                            IF QteX <> 0 THEN BEGIN
                                Seq1 := seq + 1;
                                Trans1 := Transaction + 1;
                            END;
                            QteX := CauseAbs."Auth. Days number Period 1" - ABS(AbsEnreg."Quantity (Days)") - QteX;
                            IF QteX < 0 THEN
                                QteX := 0;
                            IF CauseAbs."Auth. Days number Period 1" <> 0 THEN BEGIN
                                EmployeeAbsenceTmp := EmployeeAbs;

                                IF EmployeeAbsenceTmp.Unit.AsInteger() = 0 THEN
                                    EmployeeAbsenceTmp.VALIDATE(Quantity, (QteX))
                                ELSE
                                    EmployeeAbsenceTmp.VALIDATE(Quantity, (QteX) *
                                               (Regim."Work Hours per month" / Regim."Worked Day Per Month"));

                                CauseAbs.TESTFIELD("Cause Code Period 1");
                                EmployeeAbsenceTmp.VALIDATE("Cause of Absence Code", CauseAbs."Cause Code Period 1");

                                IF QteX <> 0 THEN BEGIN
                                    ValidateEmployeeAbsence(Trans1, EmployeeAbsenceTmp, Seq1);
                                    Seq1 := Seq1 + 1;
                                    Trans1 := Trans1 + 1;
                                END;
                            END;
                            IF CauseAbs."Auth. Days number Period 2" <> 0 THEN BEGIN
                                EmployeeAbsenceTmp1 := EmployeeAbs;

                                CauseAbs.TESTFIELD("Cause Code Period 2");
                                EmployeeAbsenceTmp1.VALIDATE("Cause of Absence Code", CauseAbs."Cause Code Period 2");

                                QteX := CauseAbs."Auth. Days number Period 2" - ABS(AbsEnreg."Quantity (Days)") - QteX;
                                IF QteX < 0 THEN
                                    QteX := 0;

                                IF EmployeeAbsenceTmp1.Unit.AsInteger() = 0 THEN
                                    EmployeeAbsenceTmp1.VALIDATE(Quantity, (QteX))
                                ELSE
                                    EmployeeAbsenceTmp1.VALIDATE(Quantity, (QteX) *
                                    (Regim."Work Hours per month" / Regim."Worked Day Per Month"));
                                IF QteX <> 0 THEN BEGIN
                                    ValidateEmployeeAbsence(Trans1, EmployeeAbsenceTmp1, Seq1);
                                    Seq1 := Seq1 + 1;
                                    Trans1 := Trans1 + 1;
                                END;
                            END;
                            IF CauseAbs."Auth. Days Number Period 3" <> 0 THEN BEGIN
                                EmployeeAbsenceTmp2 := EmployeeAbs;

                                CauseAbs.TESTFIELD("Cause Code Period 3");
                                EmployeeAbsenceTmp2.VALIDATE("Cause of Absence Code", CauseAbs."Cause Code Period 3");

                                IF EmployeeAbsenceTmp2.Unit.AsInteger() = 0 THEN
                                    QteX := EmployeeAbsenceTmp2.Quantity - ABS(AbsEnreg."Quantity (Days)") - QteX
                                ELSE
                                    QteX := EmployeeAbsenceTmp2.Quantity - ((ABS(AbsEnreg."Quantity (Days)") - QteX) *
                                          (Regim."Work Hours per month" / Regim."Worked Day Per Month"));
                                IF QteX < 0 THEN QteX := 0;

                                EmployeeAbsenceTmp2.VALIDATE(Quantity, QteX);
                                IF QteX <> 0 THEN BEGIN
                                    ValidateEmployeeAbsence(Trans1, EmployeeAbsenceTmp2, Seq1);
                                    Seq1 := Seq1 + 1;
                                    Trans1 := Trans1 + 1;
                                END;
                            END;
                            EmployeeAbsenceTmp3 := EmployeeAbs;

                            NFalse := FALSE;

                            HumanResSetup.TESTFIELD("Absence Reason for Expense");
                            EmployeeAbsenceTmp3.VALIDATE("Cause of Absence Code", HumanResSetup."Absence Reason for Expense");
                            EmployeeAbsenceTmp3.VALIDATE(Quantity, (EmployeeAbsenceTmp3.Quantity -
                                EmployeeAbsence.Quantity - EmployeeAbsenceTmp.Quantity - EmployeeAbsenceTmp1.Quantity -
                                EmployeeAbsenceTmp2.Quantity));
                            IF EmployeeAbsenceTmp3.Quantity > 0 THEN
                                ValidateEmployeeAbsence(Trans1, EmployeeAbsenceTmp3, Seq1);
                        END;
                    END;
                END;
            END;
        END;
    end;

    procedure CalcHJour(Nsal: Code[20]; DateM: Date; var HeureDM: Time; var HeureFM: Time; var HeureDA: Time; var HeureFA: Time; var Nonworking: Boolean; var Roul: Boolean; var JourFree: Boolean)
    var
        Sal: Record Employee;
        Cnt: Record "Employment Contract";
        Desc: Text[80];
        CalendarMgmt: Codeunit 7600;
    begin
        CLEAR(Cnt);
        Sal.GET(Nsal);
        Cnt.GET(Sal."Emplymt. Contract Code");

        HeureDM := 000000T;
        HeureFM := 000000T;
        HeureDA := 000000T;
        HeureFA := 000000T;
        Roul := FALSE;

        IF FORMAT(HeureDM) = '' THEN
            HeureDM := 000000T;
        IF FORMAT(HeureFM) = '' THEN
            HeureFM := 000000T;
        IF FORMAT(HeureDA) = '' THEN
            HeureDA := 000000T;
        IF FORMAT(HeureFA) = '' THEN
            HeureFA := 000000T;
    end;


    Procedure UnValidateEmployeeAbsence(Saved: Record "WDC Employee's days off Entry")
    var
        HumanResSetup: Record "Human Resources Setup";
        LastEmployeeAbsence: Record "Employee Absence";
        ln: Integer;
        EmployeeAbsence: Record "Employee Absence";
        HumanResourceCommentLine: Record "Human Resource Comment Line";
        SavedHumanResCommentLine: Record "Human Resource Comment Line";
    begin
        EmployeeAbsence.RESET;
        IF EmployeeAbsence.FindLast() THEN
            ln := EmployeeAbsence."Entry No." + 1
        ELSE
            ln := 1;
        EmployeeAbsence.RESET;
        EmployeeAbsence."Entry No." := ln;
        EmployeeAbsence."Employee No." := Saved."Employee No.";
        EmployeeAbsence.Name := Saved.Name;
        EmployeeAbsence.Surname := Saved."First Name";
        EmployeeAbsence."From Date" := Saved."From Date";
        EmployeeAbsence."To Date" := Saved."To Date";
        EmployeeAbsence."Cause of Absence Code" := Saved."Cause of Absence Code";
        EmployeeAbsence.Description := Saved.Description;
        EmployeeAbsence.Quantity := Saved.Quantity;
        EmployeeAbsence."Quantity (Base)" := Saved."Quantity (Days)";
        EmployeeAbsence."Quantity en Hours" := Saved."Quantity (Hours)";
        EmployeeAbsence.Unit := Saved.Unit;
        EmployeeAbsence."To impute on days off" := Saved."Impute on days off";
        EmployeeAbsence."Posting month" := Saved."Posting month";
        EmployeeAbsence."Posting year" := Saved."Posting year";
        EmployeeAbsence."Line type" := Saved."Line type";
        EmployeeAbsence."Absence Reason" := Saved."Absence Reason";
        EmployeeAbsence.Week := Saved.Week;

        EmployeeAbsence.Management := Saved.Management;
        EmployeeAbsence.Service := Saved.service;
        EmployeeAbsence.Section := Saved.Section;
        SavedHumanResCommentLine.SETRANGE("Table Name", 7);
        SavedHumanResCommentLine.SETRANGE("Table Line No.", Saved."Entry No.");
        IF SavedHumanResCommentLine.FindFirst() THEN
            REPEAT
                HumanResourceCommentLine.RESET;
                HumanResourceCommentLine.COPY(SavedHumanResCommentLine);
                HumanResourceCommentLine."Table Name" := HumanResourceCommentLine."Table Name"::"Employee Absence";
                HumanResourceCommentLine."Table Line No." := ln;
                HumanResourceCommentLine.INSERT;
                SavedHumanResCommentLine.DELETE;
            UNTIL SavedHumanResCommentLine.NEXT = 0;
        EmployeeAbsence.INSERT;
        Saved.DELETE(TRUE);
    end;


    procedure CalcAbsence(var SalaryLineTmp: Record "WDC Salary Lines")
    var
        EmployeDayOff: Record "WDC Employee's days off Entry";
        SuppHourLine: Record "WDC Overtime hours recorded m";
        lEmploymentContract: Record "Employment Contract";
        T2: Record "WDC work Regimes";
        T3: Record Employee;
        EntSal: Record "WDC Salary Header";
        SalaryLineeng: Record "WDC Salary Lines";
        DateJ: Date;
        CalendarMgmt: Codeunit 7600;
        Nonworking: Boolean;
        Contrat: Record "Employment Contract";
        JF: Boolean;
        Regim: Record "WDC work Regimes";
        X: Integer;
        HeureTravail: Record "WDC Overcharge of hour cost";
        EntSalEng: Record "WDC Posted Salary Header";
        ParamRessHum: Record "Human Resources Setup";
        SalaryLineengTmp: Record "WDC Salary Lines";
    begin
        SalaryLineTmp."Days off remaining" := 0;
        ParamRessHum.GET;
        SalaryLineTmp.Absences := 0;
        SalaryLineTmp."Days off" := 0;
        SalaryLineTmp."Worked hours" := 0;
        SalaryLineTmp."Basis hours" := 0;
        SalaryLineTmp.Holiday := 0;
        SalaryLineTmp."Free Day Hours" := 0;
        CLEAR(T3);
        IF T3.GET(SalaryLineTmp."Employee No.") THEN;
        CLEAR(lEmploymentContract);
        IF lEmploymentContract.GET(T3."Emplymt. Contract Code") THEN;
        CLEAR(T2);
        IF T2.GET(lEmploymentContract."Work Regime") THEN;
        CLEAR(EntSal);
        IF EntSal.GET(SalaryLineTmp."No.") THEN;
        IF Regim.GET(lEmploymentContract."Work Regime") THEN;

        EmployeDayOff.RESET;
        EmployeDayOff.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year", Fortnight, "Absence Reason");
        EmployeDayOff.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        EmployeDayOff.SETFILTER("Line type", '%1|%2', EmployeDayOff."Line type"::"Day off Right",
        EmployeDayOff."Line type"::"Day off Consumption");
        EmployeDayOff.CALCSUMS("Quantity (Days)", Quantity, "Quantity (Hours)");
        SalaryLineTmp."Days off remaining" := EmployeDayOff."Quantity (Days)";
        IF ParamRessHum."Activate fortnightly regime" THEN
            IF Regim."Payroll Calculation Type" = Regim."Payroll Calculation Type"::Fortnight THEN BEGIN
                EmployeDayOff.SETFILTER(Fortnight, '%1', EntSal.Fortnight);
                EmployeDayOff.CALCSUMS("Quantity (Days)", Quantity, "Quantity (Hours)");
                SalaryLineTmp."Days off remaining" := EmployeDayOff."Quantity (Days)";
            END;

        IF SalaryLineTmp.Month.AsInteger() < 12 THEN BEGIN
            EmployeDayOff.RESET;
            EmployeDayOff.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year", Fortnight, "Absence Reason");
            EmployeDayOff.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
            EmployeDayOff.SETFILTER("Line type", '%1|%2', EmployeDayOff."Line type"::"Not Paid",
            EmployeDayOff."Line type"::"1/2 Paid");
            EmployeDayOff.SETFILTER("Posting month", '%1', SalaryLineTmp.Month);
            EmployeDayOff.SETFILTER("Posting year", '%1', SalaryLineTmp.Year);
            EmployeDayOff.CALCSUMS("Quantity (Days)", Quantity, "Quantity (Hours)");
            IF SalaryLineTmp."Employee type".AsInteger() = 0 THEN
                SalaryLineTmp.Absences := -EmployeDayOff."Quantity (Hours)"
            ELSE
                SalaryLineTmp.Absences := -EmployeDayOff."Quantity (Days)";
            IF ParamRessHum."Activate fortnightly regime" THEN
                IF Regim."Payroll Calculation Type" = Regim."Payroll Calculation Type"::Fortnight THEN BEGIN
                    EmployeDayOff.SETFILTER(Fortnight, '%1', EntSal.Fortnight);
                    EmployeDayOff.CALCSUMS("Quantity (Days)", Quantity, "Quantity (Hours)");
                    IF SalaryLineTmp."Employee type".AsInteger() = 0 THEN
                        SalaryLineTmp.Absences := -EmployeDayOff."Quantity (Hours)"
                    ELSE
                        SalaryLineTmp.Absences := -EmployeDayOff."Quantity (Days)";
                END;


            EmployeDayOff.RESET;
            EmployeDayOff.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year", Fortnight, "Absence Reason");
            EmployeDayOff.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
            EmployeDayOff.SETFILTER("Line type", '%1', EmployeDayOff."Line type"::"Day off Consumption");
            EmployeDayOff.SETFILTER("Posting month", '%1', SalaryLineTmp.Month);
            EmployeDayOff.SETFILTER("Posting year", '%1', SalaryLineTmp.Year);
            EmployeDayOff.CALCSUMS("Quantity (Days)", "Quantity (Hours)");
            IF SalaryLineTmp."Employee type".AsInteger() = 0 THEN
                SalaryLineTmp.Holiday := -EmployeDayOff."Quantity (Hours)"
            ELSE
                SalaryLineTmp.Holiday := -EmployeDayOff."Quantity (Days)";
            IF ParamRessHum."Activate fortnightly regime" THEN
                IF Regim."Payroll Calculation Type" = Regim."Payroll Calculation Type"::Fortnight THEN BEGIN
                    EmployeDayOff.SETFILTER(Fortnight, '%1', EntSal.Fortnight);
                    EmployeDayOff.CALCSUMS("Quantity (Days)", Quantity, "Quantity (Hours)");
                    IF SalaryLineTmp."Employee type".AsInteger() = 0 THEN
                        SalaryLineTmp.Holiday := -EmployeDayOff."Quantity (Hours)"
                    ELSE
                        SalaryLineTmp.Holiday := -EmployeDayOff."Quantity (Days)";

                END;

            SalaryLineTmp."Free Day Hours" := 0;
            lEmploymentContract.RESET;
            CLEAR(Contrat);
            X := -1;
            CLEAR(Regim);

            IF SalaryLineTmp.Month.AsInteger() < 12 THEN BEGIN
                DateJ := DMY2DATE(1, SalaryLineTmp.Month.AsInteger() + 1, SalaryLineTmp.Year);
                IF Contrat.GET(SalaryLineTmp."Emplymt. Contract Code") THEN;
                Regim.GET(Contrat."Work Regime");
                SuppHourLine.RESET;
                SuppHourLine.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year");
                SuppHourLine.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
                SuppHourLine.SETFILTER("Payment Month", '%1', SalaryLineTmp.Month);
                SuppHourLine.SETFILTER("Payment Year", '%1', SalaryLineTmp.Year);
                SuppHourLine.CALCSUMS("Hours Number");
                SuppHourLine.RESET;
                SuppHourLine.SETCURRENTKEY("Employee No.", "Overtime Rate", "Payment Month", "Payment Year", Fortnight);
                SuppHourLine.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
                SuppHourLine.SETFILTER("Payment Month", '%1', SalaryLineTmp.Month);
                SuppHourLine.SETFILTER("Payment Year", '%1', SalaryLineTmp.Year);
                SuppHourLine.CALCSUMS("Hours Number");
                SalaryLineTmp."Basis hours" := SuppHourLine."Hours Number";
                IF ParamRessHum."Activate fortnightly regime" THEN
                    IF Regim."Payroll Calculation Type" = Regim."Payroll Calculation Type"::Fortnight THEN BEGIN
                        SuppHourLine.SETFILTER(Fortnight, '%1', EntSal.Fortnight);
                        SuppHourLine.CALCSUMS("Hours Number");
                        SalaryLineTmp."Basis hours" := SuppHourLine."Hours Number";
                    END;


            END;
        END;
        IF (SalaryLineTmp.Month.AsInteger() = 12) OR (SalaryLineTmp.Month.AsInteger() = 13) OR (SalaryLineTmp.Month = SalaryLineTmp.Month::Prime) THEN BEGIN
            SalaryLineeng.RESET;
            SalaryLineeng.SETCURRENTKEY(Year, Month, "Employee No.", "No.");
            SalaryLineeng.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
            SalaryLineeng.SETFILTER(Month, '0..11');
            IF SalaryLineTmp."Posting Date" = DMY2DATE(26, 3, 2005) THEN
                SalaryLineeng.SETFILTER(Month, '0..2');
            IF (SalaryLineTmp.Month = SalaryLineTmp.Month::Prime) THEN
                SalaryLineeng.SETRANGE(Year, SalaryLineTmp."Calculate Year")
            ELSE
                SalaryLineeng.SETRANGE(Year, SalaryLineTmp.Year);
            SalaryLineeng.CALCSUMS("Days off remaining", "Days off balacement", Absences, "Days off");
            SalaryLineengTmp.RESET;
            SalaryLineengTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.");
            SalaryLineengTmp.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
            SalaryLineengTmp.SETFILTER(Month, '0..11');
            IF SalaryLineTmp."Posting Date" = DMY2DATE(26, 3, 2005) THEN
                SalaryLineengTmp.SETFILTER(Month, '0..2');
            IF (SalaryLineTmp.Month = SalaryLineTmp.Month::Prime) THEN
                SalaryLineengTmp.SETRANGE(Year, SalaryLineTmp."Calculate Year")
            ELSE
                SalaryLineengTmp.SETRANGE(Year, SalaryLineTmp.Year);
            IF SalaryLineengTmp.FINDFIRST THEN
                EntSalEng.RESET;
            EntSalEng.SETFILTER(Month, '0..11');
            IF SalaryLineTmp."Posting Date" = DMY2DATE(26, 3, 2005) THEN
                EntSalEng.SETFILTER(Month, '0..2');

            IF (SalaryLineTmp.Month = SalaryLineTmp.Month::Prime) THEN
                EntSalEng.SETRANGE(Year, SalaryLineTmp."Calculate Year")
            ELSE
                EntSalEng.SETRANGE(Year, SalaryLineTmp.Year);
            IF EntSalEng.FINDLAST() THEN;
            IF EntSalEng.COUNT <> 0 THEN BEGIN
                SalaryLineTmp.Absences := ROUND((SalaryLineeng.Absences + ((EntSalEng.COUNT - SalaryLineengTmp.COUNT)
                * ParamRessHum."Paid days")) / EntSalEng.COUNT, 0.01);
                SalaryLineTmp."Days off" := ROUND(SalaryLineeng."Days off" / EntSalEng.COUNT, 0.01);
            END;
        END;

    end;



}

