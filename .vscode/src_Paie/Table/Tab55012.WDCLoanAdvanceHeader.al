table 55012 "WDC Loan & Advance Header"
{
    CaptionML = ENU = 'Loan & Advance Header', FRA = 'En-tête Prêt & Avance';
    DrillDownPageID = "WDC Loan & Advance Hdr";
    LookupPageID = "WDC Loan & Advance Hdr";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° Employé';
            TableRelation = Employee;
        }
        field(3; Name; Text[100])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';
        }
        field(4; "Job Title"; Text[100])
        {
            CaptionML = ENU = 'Job Title', FRA = 'Poste';
        }
        field(5; "Employee Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe compta. Employé';
            Editable = true;
            TableRelation = "WDC Employee Posting Group";
        }
        field(6; Type; Enum "WDC Loan & Advance Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';
            Editable = false;
        }
        field(7; "Document type"; Code[20])
        {
            CaptionML = ENU = 'Document type', FRA = 'Type document';
            TableRelation = "WDC Loan & Advance Type" WHERE(Type = FIELD(Type));
        }
        field(10; Amount; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Amount', FRA = 'Montant';

            trigger OnValidate()
            begin
                IF Type = Type::Advance THEN BEGIN
                    CLEAR(AdvanceEntry);
                    AdvanceEntry.SETRANGE("No.", "No.");
                    AdvanceEntry.SETRANGE("Employee No.", "Employee No.");
                    IF AdvanceEntry.FINDSET THEN BEGIN
                        AdvanceEntry."Line Amount" := Amount;
                        AdvanceEntry.MODIFY;
                    END;
                END;
            end;
        }
        field(11; "Interest %"; Decimal)
        {
            CaptionML = ENU = 'Interest %', FRA = '% Interet';
            DecimalPlaces = 0 : 5;
            Editable = true;
        }
        field(12; "Total to repay"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Total to repay', FRA = 'Total à rembourser';
            InitValue = 0;
        }
        field(15; "Repayment slices"; Integer)
        {
            CaptionML = ENU = 'Repayment slices', FRA = 'Nombre de tranches';
            Editable = true;
        }
        field(20; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series', FRA = 'Série N°';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(25; "Validation Date"; Date)
        {
            CaptionML = ENU = 'Validation Date', FRA = 'Date validation';
            Editable = false;
        }
        field(30; "Repaiment lines"; Integer)
        {
            CalcFormula = Count("WDC Loan & Advance Lines" WHERE("No." = FIELD("No."),
                                                              Paid = FILTER(TRUE)));
            CaptionML = ENU = 'Repayment lines', FRA = 'Lignes remboursement';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Repaid amount"; Decimal)
        {
            CalcFormula = Sum("WDC Loan & Advance Lines"."Line Amount" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Repaid amount', FRA = 'Montant remboursé';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Repaid %"; Decimal)
        {
            CalcFormula = Sum("WDC Loan & Advance Lines"."Line %" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Repaid %', FRA = '% remboursé';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; Status; Enum "WDC Status")
        {
            CaptionML = ENU = 'Status', FRA = 'Statut';
        }
        field(40; "Global dimension 1"; Code[20])
        {
            CaptionML = ENU = 'Global dimension 1', FRA = 'Code département';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(41; "Global dimension 2"; Code[20])
        {
            CaptionML = ENU = 'Global dimension 2', FRA = 'Code dossier';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50; "Principal Amount"; Decimal)
        {
            AutoFormatType = 2;
            FieldClass = FlowField;
            CalcFormula = Sum("WDC Loan & Advance Lines"."Principal Amount" WHERE("No." = FIELD("No."),
                                                                               "Employee No." = FIELD("Employee No."),
                                                                               Type = FIELD(Type),
                                                                               Status = FIELD(Status)));
            CaptionML = ENU = 'Principal Amount', FRA = 'Montant principal';
            Editable = false;
        }
        field(51; "Interest Amount"; Decimal)
        {
            FieldClass = FlowField;
            AutoFormatType = 2;
            CalcFormula = Sum("WDC Loan & Advance Lines"."Interest Amount" WHERE("No." = FIELD("No."),
                                                                              "Employee No." = FIELD("Employee No."),
                                                                              Type = FIELD(Type),
                                                                              Status = FIELD(Status)));
            CaptionML = ENU = 'Interest Amount', FRA = 'Montant intérêts';
            Editable = false;

        }
        field(110; "Avance Sur Prime"; Boolean)
        {
            CaptionML = ENU = 'Advance on premium', FRA = 'Avance sur prime';
        }
        field(50000; "Advance on Holiday"; Boolean)
        {
            CaptionML = ENU = 'Leave advance', FRA = 'Avance sur congé';
        }
        field(50001; "Périodicité"; Enum "WDC Periodicity")
        {
            CaptionML = ENU = 'Periodicity', FRA = 'Périodicité';
        }
        field(50002; "Type Tranche"; Enum "WDC Slice Type")
        {
            CaptionML = ENU = 'Installment Type', FRA = 'Type de tranche';
        }
        field(50003; Month; Enum "WDC Payroll Month")
        {
            CaptionML = ENU = 'Month', FRA = 'Mois';
        }
        field(50004; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';
        }
        field(50005; "Inclus Paie Autre"; Boolean)
        {
            CaptionML = ENU = 'Include in other payroll', FRA = 'Inclus paie autre';
        }
        field(50006; "Inclus Paie13"; Boolean)
        {
            CaptionML = ENU = 'Include 13th payroll', FRA = 'Inclus Paie13';
        }
        field(50200; "Slice Amount"; Decimal)
        {
            CaptionML = ENU = 'Installment amount', FRA = 'Montant tranche';
            DecimalPlaces = 3 : 3;

            trigger OnValidate()
            begin
                PramRessHum.GET();
                IF PramRessHum."Loan Calculation Type" = 0 THEN BEGIN
                    IF "Slice Amount" > ("Total to repay" - "Repaid amount") THEN BEGIN
                        "Slice Amount" := 0;
                        ERROR(ERR1);
                    END;
                END;
                IF Type = Type::Advance THEN BEGIN
                    CLEAR(AdvanceEntry);
                    AdvanceEntry.SETRANGE("No.", "No.");
                    AdvanceEntry.SETRANGE("Employee No.", "Employee No.");
                    IF AdvanceEntry.FINDSET THEN BEGIN
                        AdvanceEntry."Line Amount" := "Slice Amount";
                        AdvanceEntry.MODIFY;
                    END;
                END;
            end;
        }
        field(50400; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
        }
        field(50500; "Effective date"; Date)
        {
            CaptionML = ENU = 'Effective Date', FRA = 'Date d''effet';

            trigger OnValidate()
            begin
                Month := Enum::"WDC Payroll Month".FromInteger(DATE2DMY("Effective date", 2) - 3);
                Year := DATE2DMY("Effective date", 3);
            end;
        }
        field(50501; "End date Loan"; Date)
        {
            CaptionML = ENU = 'Loan End Date', FRA = 'Date fin prêt';
        }
        field(50505; "External Document No."; Code[20])
        {
            CaptionML = ENU = 'External Document No.', FRA = 'N° document externe';
        }
        field(50600; "Not include"; Boolean)
        {
            CaptionML = ENU = 'Not included', FRA = 'Non inclus';

            trigger OnValidate()
            begin
                IF "Not include" = TRUE THEN
                    "Double tranche" := FALSE;
            end;
        }

        field(39001432; "Bal. Account Type"; Enum "Payment Balance Account Type")
        {
            CaptionML = ENU = 'Bal. Account Type', FRA = 'Type compte solde';
        }
        field(39001433; "Bal. Account No."; Code[20])
        {
            CaptionML = ENU = 'Bal. Account No.', FRA = 'N° compte contrepartie';
            TableRelation = IF ("Bal. Account Type" = FILTER("G/L Account")) "G/L Account"
            ELSE IF ("Bal. Account Type" = FILTER("Bank Account")) "Bank Account" WHERE("Currency Code" = FILTER(''));
        }
        field(39001450; "Depreciation type"; Enum "WDC Depreciation Type")
        {
            CaptionML = ENU = 'Depreciation type', FRA = 'Type d''apriciation';
        }
        field(39001470; "Aid Advance"; Boolean)
        {
            CaptionML = ENU = 'Aid Advance', FRA = 'Avance aide';
        }
        field(39001490; "Precision Arrondi Principale"; Decimal)
        {
            CaptionML = ENU = 'Principal Rounding Precision', FRA = 'Précision arrondi principale';
            DecimalPlaces = 0 : 3;
        }
        field(39001491; "Allocation Difference Rounding"; Enum "WDC Satrt-End")
        {
            CaptionML = ENU = 'Allocation Difference Rounding', FRA = 'Affectation Diff Arrondi';
        }
        field(39001492; "Arround Type"; Enum "WDC Arround Type")
        {
            CaptionML = ENU = 'Arround Type', FRA = 'Type arrondi';
        }
        field(39001495; "Meal Advance"; Boolean)
        {
            CaptionML = ENU = 'Meal Advance', FRA = 'Avance repas';
        }
        field(39001496; "Payment Type"; Text[30])
        {
            CaptionML = ENU = 'Payment Type', FRA = 'Type règlement';
        }
        field(39001497; "Employee Statistic Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Statistic Group', FRA = 'Groupe statistique employé';
            Editable = true;
            TableRelation = "Employee Statistics Group";
        }
        field(39001498; Management; Code[20])
        {
            CaptionML = ENU = 'Management', FRA = 'Direction';
        }
        field(39001499; Service; Code[20])
        {
            CaptionML = ENU = 'Service', FRA = 'Service';
        }
        field(39001500; Section; Code[20])
        {
            CaptionML = ENU = 'Section', FRA = 'Section';
        }
        field(39001501; "Double tranche"; Boolean)
        {
            CaptionML = ENU = 'Double installment', FRA = 'Double tranche';

            trigger OnValidate()
            begin
                IF "Double tranche" = TRUE THEN
                    "Nombre tranche" := 2;
                "Not include" := FALSE;
            end;
        }
        field(39001502; "Nombre tranche"; Integer)
        {
            CaptionML = ENU = 'Number of installments', FRA = 'Nombre tranche';
        }
        field(39001503; "Nombre Tranches"; Decimal)
        {
            CaptionML = ENU = 'Number of installments', FRA = 'Nombre tranches';
            DecimalPlaces = 3 : 3;

        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", Type, "Document type", Status, "No.", "Avance Sur Prime")
        {
        }
        key(Key3; "Employee No.")
        {
        }
        key(Key4; Type)
        {
        }
        key(Key5; "Document type")
        {
        }
        key(Key6; Status)
        {
        }
        key(Key7; "Employee No.", Type, Status, "No.", "Avance Sur Prime")
        {
            SumIndexFields = Amount;
        }
        key(Key8; Status, "Not include", "No.")
        {
        }
        key(Key9; "Employee No.", Type, "Posting Date")
        {
            SumIndexFields = Amount;
        }
        key(Key10; "Employee No.", Type, "Effective date", Status)
        {
            SumIndexFields = Amount;
        }
    }


    trigger OnDelete()
    begin
        //>>
        RecGLignePrêt.RESET;
        RecGLignePrêt.SETRANGE("No.", "No.");
        RecGLignePrêt.SETRANGE(RecGLignePrêt.Type, Type);
        RecGLignePrêt.SETRANGE("Employee No.", "Employee No.");
        IF RecGLignePrêt.FINDSET THEN BEGIN
            RecGLignePrêt.DELETEALL();

        END;
        RecGEcrPrêt.RESET;
        RecGEcrPrêt.SETRANGE("No.", "No.");
        RecGEcrPrêt.SETRANGE(RecGEcrPrêt.Type, Type);
        RecGEcrPrêt.SETRANGE("Employee No.", "Employee No.");
        IF RecGEcrPrêt.FINDSET THEN BEGIN
            RecGEcrPrêt.DELETEALL();
        END;
    end;

    trigger OnInsert()
    begin
        Month := Enum::"WDC Payroll Month".FromInteger(DATE2DMY(WORKDATE, 2) - 3);
        Year := DATE2DMY(WORKDATE, 3);
    end;

    var
        MntLn: Decimal;
        MntLn1: Decimal;
        ERR1: TextConst ENU = 'Check tranche amount',
                        FRA = 'Vérifiez montant tranche';
        PramRessHum: Record "Human Resources Setup";
        "RecGLignePrêt": Record 55013;
        "RecGEcrPrêt": Record 55014;
        AdvanceEntry: Record "WDC Loan & Advance Lines";


    procedure CalcMnPrinciPeriode(DateDebT: Date; DateFinT: Date) MntPrin: Decimal
    var
        MontiniT: Decimal;
        DateDeb: Date;
        DateFin: Date;
        NbrMois: Decimal;
        j: Integer;
        DateJ: Date;
        Mnt1: Decimal;
        Mnt: Decimal;
    begin

        MontiniT := Amount;
        DateDeb := CALCDATE('<-27D+CM>', "Effective date");
        DateFin := CALCDATE('<-27D+CM+1D>', "End date Loan");
        NbrMois := 0;
        REPEAT
            NbrMois := NbrMois + 1;
        UNTIL CALCDATE(STRSUBSTNO('<+%1M+CM>', NbrMois), DateDeb) > DateFin;

        MntPrin := 0;
        IF (DateDebT = 0D) OR (DateFinT = 0D) OR (DateFinT < "Effective date") OR (DateDebT > "End date Loan")
           OR ("Effective date" = "End date Loan") THEN
            EXIT;
        DateDebT := CALCDATE('<-27D+CM+1D>', DateDebT);
        DateFinT := CALCDATE('<-27D+CM>', DateFinT);
        DateJ := DateDeb;
        // Amortissement Dégressif
        CASE "Depreciation type".AsInteger() OF
            0:
                BEGIN
                    //IF "Depreciation type"=0 THEN BEGIN
                    j := -1;
                    REPEAT
                        j := j + 1;
                        IF DateDebT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb) THEN
                            MntPrin := MntPrin + ROUND((MontiniT / (NbrMois - j)), 0.001);

                        IF (NbrMois - j) <> 0 THEN
                            MontiniT := MontiniT - ROUND((MontiniT / (NbrMois - j)), 0.001);
                    UNTIL (DateFinT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) OR
                          (DateFin <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb));
                END;
            1:
                BEGIN
                    //ELSE BEGIN
                    MntPrin := 0;
                    Mnt := 0;
                    Mnt1 := 0;
                    IF NbrMois <> 0 THEN
                        Mnt := ROUND(MontiniT / NbrMois, 0.5);
                    Mnt1 := MontiniT - (Mnt * (NbrMois - 1));
                    j := -1;
                    REPEAT
                        j := j + 1;

                        IF (DateDebT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) THEN
                            IF (CALCDATE('<+CM>', DateDebT) = CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) AND (j = 0) THEN
                                MntPrin := MntPrin + Mnt1
                            ELSE
                                MntPrin := MntPrin + Mnt;
                    UNTIL (DateFinT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) OR
                          (DateFin <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb));
                END;
            2:
                BEGIN
                    MntPrin := 0;
                    Mnt := 0;
                    Mnt1 := 0;
                    IF NbrMois <> 0 THEN
                        Mnt := ROUND(MontiniT / NbrMois, 0.001);
                    Mnt1 := MontiniT - (Mnt * (NbrMois - 1));
                    j := -1;
                    REPEAT
                        j := j + 1;

                        IF (DateDebT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) THEN
                            IF (CALCDATE('<+CM>', DateDebT) = CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) AND (j = 0) THEN
                                MntPrin := MntPrin + Mnt1
                            ELSE
                                MntPrin := MntPrin + Mnt;
                    UNTIL (DateFinT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) OR
                          (DateFin <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb));
                END;
        END;
    end;


    procedure CalcMntInetret(DateDebT: Date; DateFinT: Date) MntRet: Decimal
    var
        MontiniT: Decimal;
        DateDeb: Date;
        DateFin: Date;
        NbrMois: Decimal;
        j: Integer;
        DateJ: Date;
        Mnt: Decimal;
        Mnt1: Decimal;
    begin

        MontiniT := Amount;
        DateDeb := CALCDATE('<-27D+CM>', "Effective date");
        DateFin := CALCDATE('<-27D+CM+1D>', "End date Loan");
        NbrMois := 0;
        REPEAT
            NbrMois := NbrMois + 1;
        UNTIL CALCDATE(STRSUBSTNO('<+%1M+CM>', NbrMois), DateDeb) > DateFin;
        MntRet := 0;
        IF (DateDebT = 0D) OR (DateFinT = 0D) OR (DateFinT < "Effective date") OR (DateDebT > "End date Loan")
             OR ("Effective date" = "End date Loan") THEN
            EXIT;
        DateDebT := CALCDATE('<-27D+CM+1D>', DateDebT);
        DateFinT := CALCDATE('<-27D+CM>', DateFinT);
        DateJ := DateDeb;
        // Amortissement Dégressif
        CASE "Depreciation type".AsInteger() OF
            0:
                BEGIN
                    // IF "Depreciation type"=0 THEN BEGIN
                    j := -1;
                    REPEAT
                        j := j + 1;
                        IF DateDebT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb) THEN
                            MntRet := MntRet + ROUND(((MontiniT * "Interest %") / 1200), 0.001);
                        IF (NbrMois - j) <> 0 THEN
                            MontiniT := MontiniT - ROUND((MontiniT / (NbrMois - j)), 0.001);
                    UNTIL (DateFinT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) OR
                       (DateFin <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb));
                END;
            1:
                BEGIN
                    // ELSE BEGIN
                    j := -1;
                    REPEAT
                        j := j + 1;

                        //IF DateDebT<=CALCDATE(STRSUBSTNO('+%1M+FM',j),DateDeb) THEN
                        MntRet := MntRet + ROUND(((MontiniT * "Interest %") / 1200), 0.001);
                        IF (NbrMois - j) <> 0 THEN
                            MontiniT := MontiniT - ROUND((MontiniT / (NbrMois - j)), 0.001);
                    UNTIL (DateFin <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb));

                    Mnt := ROUND(MntRet / NbrMois, 0.5, '<');
                    Mnt1 := MntRet - (Mnt * (NbrMois - 1));
                    j := -1;
                    MntRet := 0;
                    REPEAT
                        j := j + 1;
                        IF (DateDebT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) THEN
                            IF (CALCDATE('<+CM>', DateDebT) = CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) AND (j = 0) THEN
                                MntRet := MntRet + Mnt1
                            ELSE
                                MntRet := MntRet + Mnt;
                    UNTIL (DateFinT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) OR
                       (DateFin <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb));

                END;
            2:
                BEGIN
                    MntRet := MontiniT * "Interest %" / 1200;
                END;
        END;
    end;


    procedure CalcMntInetretAvPrime(DateFinT: Date) MntRet: Decimal
    var
        MontiniT: Decimal;
        DateDeb: Date;
        DateFin: Date;
        NbrMois: Decimal;
        j: Integer;
        DateJ: Date;
        Mnt: Decimal;
        Mnt1: Decimal;
        LignePret: Record "WDC Loan & Advance Lines";
        LignePretTmp: Record "WDC Loan & Advance Lines";
    begin
        LignePret.RESET;
        LignePret.SETCURRENTKEY("No.", Status, Type, "Employee No.", Paid);
        LignePret.SETFILTER("No.", "No.");
        LignePret.SETRANGE(Status, Status);
        LignePret.SETRANGE(Type, Type);
        LignePret.SETFILTER("Employee No.", "Employee No.");
        LignePret.SETRANGE(Paid, TRUE);
        LignePret.CALCSUMS("Principal Amount");
        MntRet := 0;
        IF (DateFinT = 0D) THEN
            ERROR('Verifier Date Effet ou date du Calcul Interrêt !!!');
        MontiniT := Amount - LignePret."Principal Amount";

        LignePretTmp.RESET;
        LignePretTmp.SETCURRENTKEY("No.", Status, Type, "Employee No.", Paid);
        LignePretTmp.SETFILTER("No.", "No.");
        LignePretTmp.SETRANGE(Status, Status);
        LignePretTmp.SETRANGE(Type, Type);
        LignePretTmp.SETFILTER("Employee No.", "Employee No.");
        LignePretTmp.SETRANGE(Paid, TRUE);
        IF LignePretTmp.Findlast() THEN
            DateDeb := LignePretTmp."Payroll Date"
        ELSE
            DateDeb := "Effective date";

        MntRet := (MontiniT * ("Interest %" / 100) * (DateFinT - DateDeb)) / 365;
    end;


    procedure CalcMnPRincipaleRemb() MntRest: Decimal
    var
        MontiniT: Decimal;
        DateDeb: Date;
        DateFin: Date;
        NbrMois: Decimal;
        j: Integer;
        DateJ: Date;
        Mnt: Decimal;
        Mnt1: Decimal;
        LignePret: Record "WDC Loan & Advance Lines";
    begin
        LignePret.RESET;
        LignePret.SETCURRENTKEY("No.", Status, Type, "Employee No.", Paid);
        LignePret.SETFILTER("No.", "No.");
        LignePret.SETRANGE(Status, Status);
        LignePret.SETRANGE(Type, Type);
        LignePret.SETFILTER("Employee No.", "Employee No.");
        LignePret.SETRANGE(Paid, TRUE);
        LignePret.CALCSUMS("Principal Amount");
        MntRest := 0;
        MntRest := Amount - LignePret."Principal Amount";
    end;


    procedure CalcMnPrinciPeriodeeng(DateDebT: Date; DateFinT: Date) MntPrin: Decimal
    var
        MontiniT: Decimal;
        DateDeb: Date;
        DateFin: Date;
        NbrMois: Decimal;
        j: Integer;
        DateJ: Date;
        Mnt1: Decimal;
        Mnt: Decimal;
        LignePret: Record "WDC Loan & Advance Lines";
    begin

        LignePret.RESET;
        LignePret.SETCURRENTKEY("No.", Status, Type, "Employee No.", Paid);
        LignePret.SETFILTER("No.", "No.");
        LignePret.SETRANGE(Status, Status);
        LignePret.SETRANGE(Type, Type);
        LignePret.SETFILTER("Employee No.", "Employee No.");
        LignePret.SETRANGE(Paid, TRUE);
        LignePret.CALCSUMS("Principal Amount");
        MontiniT := ROUND(Amount - LignePret."Principal Amount", 0.001);

        DateDeb := CALCDATE('<-27D+CM+1D>', "Effective date");
        DateFin := CALCDATE('<-27D+CM>', "End date Loan");
        NbrMois := "Repayment slices" - LignePret.COUNT;
        MntPrin := 0;

        IF (DateDebT = 0D) OR (DateFinT = 0D) OR (NbrMois = 0) OR (MontiniT = 0) OR (DateDebT >= DateFinT)
          OR (DateDeb >= DateFinT) THEN
            EXIT;
        DateDebT := CALCDATE('<-27D+CM+1D>', DateDebT);
        DateFinT := CALCDATE('<-27D+CM>', DateFinT);
        DateJ := DateDeb;
        // Amortissement Dégressif

        CASE "Depreciation type".AsInteger() OF
            0:
                BEGIN
                    j := -1;
                    IF ("Repayment slices") <> 0 THEN
                        MntLn := Amount / ("Repayment slices");
                    MntLn1 := MontiniT - (MntLn * ("Repayment slices" - 1));
                    REPEAT
                        j := j + 1;

                        IF (NbrMois - j) <> 0 THEN
                            MntPrin := MntPrin + ROUND((MontiniT / (NbrMois - j)), 0.001);

                        IF (NbrMois - j) <> 0 THEN
                            MontiniT := MontiniT - ROUND((MontiniT / (NbrMois - j)), 0.001);

                    UNTIL (DateFinT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDebT));
                END;
            1:
                BEGIN
                    MntPrin := 0;
                    Mnt := 0;
                    Mnt1 := 0;
                    IF NbrMois <> 0 THEN
                        Mnt := ROUND(MontiniT / NbrMois, "Precision Arrondi Principale", FORMAT("Arround Type"));
                    Mnt1 := MontiniT - (Mnt * (NbrMois - 1));
                    j := -1;
                    REPEAT
                        j := j + 1;
                        CASE j + (LignePret.COUNT) OF
                            0:
                                BEGIN
                                    IF "Allocation Difference Rounding".AsInteger() = 0 THEN
                                        MntPrin := Mnt1
                                    ELSE
                                        MntPrin := Mnt;
                                END;
                            (NbrMois - 1):
                                BEGIN
                                    IF "Allocation Difference Rounding".AsInteger() = 0 THEN
                                        MntPrin := Mnt + MntPrin
                                    ELSE
                                        MntPrin := Mnt + Mnt1;
                                END
                            ELSE
                                MntPrin := Mnt + MntPrin;
                        END;
                    UNTIL (DateFinT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDebT));
                END;
            2:
                BEGIN
                    MntPrin := 0;
                    Mnt := 0;
                    Mnt1 := 0;
                    CALCFIELDS("Repaid amount");
                    PramRessHum.GET();
                    IF PramRessHum."Loan Calculation Type" = 0 THEN BEGIN
                        IF "Repayment slices" <> 0 THEN
                            Mnt := ROUND(Amount / "Repayment slices", 0.001);// ROUND("Slice Amount",0.001);
                        Mnt1 := ROUND("Slice Amount", 0.001);
                        IF Mnt <= ("Total to repay" - "Repaid amount") THEN
                            MntPrin := Mnt
                        ELSE
                            MntPrin := "Total to repay" - "Repaid amount";

                    END ELSE BEGIN

                        Mnt := ROUND("Slice Amount", 0.001);// ROUND("Slice Amount",0.001);
                        Mnt1 := ROUND("Slice Amount", 0.001);

                        IF Mnt <= ("Total to repay" - "Repaid amount") THEN
                            MntPrin := Mnt
                        ELSE
                            MntPrin := "Total to repay" - "Repaid amount";


                    END;

                END;
        END;
    end;


    procedure CalcMntInetretEng1(DateDebT: Date; DateFinT: Date) MntRet: Decimal
    var
        MontiniT: Decimal;
        DateDeb: Date;
        DateFin: Date;
        NbrMois: Decimal;
        j: Integer;
        DateJ: Date;
        Mnt: Decimal;
        Mnt1: Decimal;
        LignePret: Record "WDC Loan & Advance Lines";
    begin
        LignePret.RESET;
        LignePret.SETCURRENTKEY("No.", Status, Type, "Employee No.", Paid);
        LignePret.SETFILTER("No.", "No.");
        LignePret.SETRANGE(Status, Status);
        LignePret.SETRANGE(Type, Type);
        LignePret.SETFILTER("Employee No.", "Employee No.");
        LignePret.SETRANGE(Paid, TRUE);
        LignePret.CALCSUMS("Principal Amount");
        MontiniT := ROUND(Amount - LignePret."Principal Amount", 0.001);

        DateDeb := CALCDATE('<-27D+CM+1D>', "Effective date");
        DateFin := CALCDATE('<-27D+CM>', "End date Loan");
        NbrMois := 0;
        NbrMois := "Repayment slices" - LignePret.COUNT;

        MntRet := 0;
        IF (DateDebT = 0D) OR (DateFinT = 0D) OR (NbrMois = 0) OR (MontiniT = 0) OR (DateDebT >= DateFinT)
        OR (DateDeb >= DateFinT) THEN
            EXIT;

        DateDebT := CALCDATE('<-27D+CM+1D>', DateDebT);
        DateFinT := CALCDATE('<-27D+CM>', DateFinT);
        DateJ := DateDeb;
        // Amortissement Dégressif
        CASE "Depreciation type".AsInteger() OF
            0:
                BEGIN
                    j := -1;
                    REPEAT
                        j := j + 1;
                        MntRet := MntRet + ROUND(((MontiniT * "Interest %") / 1200), 0.001);
                        IF (NbrMois - j) <> 0 THEN
                            MontiniT := MontiniT - ROUND((MontiniT / (NbrMois - j)), 0.001);
                    UNTIL (DateFinT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDebT));
                END;
            1:
                BEGIN
                    j := -1;
                    REPEAT
                        j := j + 1;
                        MntRet := MntRet + ROUND(((MontiniT * "Interest %") / 1200), 0.001);
                        IF (NbrMois - j) <> 0 THEN
                            MontiniT := MontiniT - ROUND((MontiniT / (NbrMois - j)), 0.001);
                    UNTIL (DateFin <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb));

                    Mnt := ROUND(MntRet / NbrMois, 0.5, '<');
                    Mnt1 := MntRet - (Mnt * (NbrMois - 1));
                    j := -1;
                    MntRet := 0;
                    REPEAT
                        j := j + 1;
                        IF (DateDebT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) THEN
                            IF (CALCDATE('<+CM>', DateDebT) = CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) AND (j = 0) THEN
                                MntRet := MntRet + Mnt1
                            ELSE
                                MntRet := MntRet + Mnt;
                    UNTIL (DateFinT <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb)) OR
                          (DateFin <= CALCDATE(STRSUBSTNO('<+%1M+CM>', j), DateDeb));
                END;
            2:
                BEGIN
                    MntRet := MntRet + ROUND(((Amount * "Interest %") / 1200), 0.001);

                END;
        END;

    end;


}

