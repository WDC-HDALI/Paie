table 55011 "WDC Loan & Advance"
{
    CaptionML = ENU = 'Loan & Advance', FRA = 'Prêt & Avance';
    DataCaptionFields = "Employee No.";
    DrillDownPageID = 55013;
    LookupPageID = 55013;

    fields
    {
        field(1; "No."; Code[20])
        {
            captionML = ENU = 'No.', FRA = 'N°';
            trigger OnValidate()
            var
                HumanResSetup: Record "Human Resources Setup";
                NoSeriesMgt: Codeunit "No. Series";
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Loan & Advance Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            captionML = ENU = 'Employee No.', FRA = 'N° employé';
            trigger OnValidate()
            var
                lLoanadvance: Record "WDC Loan & Advance";
                lEmployee: Record Employee;
                lLoanAdvanceType: Record "WDC Loan & Advance Type";
            begin
                lLoanadvance.RESET;
                lLoanadvance.SETRANGE("Employee No.", "Employee No.");
                lEmployee.GET("Employee No.");
                Name := lEmployee."First Name" + ' ' + lEmployee."Last Name";

                "Job Title" := lEmployee.Title;
                "Employee Posting Group" := lEmployee."Empl. Posting Group";
                "Employee Statistic Group" := lEmployee."Statistics Group Code";
                "Employee type" := lEmployee."Employee type";
                Management := lEmployee.Management;
                Service := lEmployee.Service;
                Section := lEmployee.Section;
                "Global dimension 1" := lEmployee."Global Dimension 1 Code";
                "Global dimension 2" := lEmployee."Global Dimension 2 Code";

                lLoanAdvanceType.RESET;
                lLoanAdvanceType.SETRANGE(Type, Type);
                lLoanAdvanceType.SETRANGE("Default Type", TRUE);
                IF lLoanAdvanceType.Findfirst() THEN
                    VALIDATE("Document type", lLoanAdvanceType.Code);
            end;
        }
        field(3; Name; Text[60])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';
            Editable = false;
        }
        field(4; "Job Title"; Text[50])
        {
            CaptionML = ENU = 'Job Title', FRA = 'Poste';
            Editable = false;
        }
        field(5; "Employee Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe compta. employé';
            Editable = false;
            TableRelation = "WDC Employee Posting Group";
        }
        field(6; Type; Enum "WDC Loan & Advance Type")
        {
            captionML = ENU = 'Type', FRA = 'Type';
        }
        field(7; "Document type"; Code[20])
        {
            CaptionML = ENU = 'Document type', FRA = 'Type document';
            TableRelation = "WDC Loan & Advance Type" WHERE(Type = FIELD(Type));

            trigger OnValidate()
            var
                lLoanAdvanceType: Record 55010;
            begin
                IF lLoanAdvanceType.GET("Document type") THEN BEGIN
                    "Repayment slices" := lLoanAdvanceType."Repayment slices";
                    IF "Repayment slices" = 0 THEN
                        VALIDATE("Repayment slices", 1);
                    "Bal. Account Type" := lLoanAdvanceType."Bal. Account Type";
                    "Bal. Account No." := lLoanAdvanceType."Bal. Account No.";
                    "Depreciation type" := lLoanAdvanceType."Depreciation type";
                    "Advance on Bonus" := lLoanAdvanceType."Advance on Bonus";
                    "Interest %" := lLoanAdvanceType."Interest %";
                    "Aid Advance" := lLoanAdvanceType."Aid Advance";
                    "Precision Arrondi Principale" := lLoanAdvanceType."Precision Arrondi Principale";
                    "Meal Advance" := lLoanAdvanceType."Meal Advance";
                    "Payment Type" := lLoanAdvanceType."Payment Type";
                    "Advance on Holiday" := lLoanAdvanceType."Advance on Holiday";
                END;
            end;
        }
        field(10; Amount; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Amount', FRA = 'Montant';
            trigger OnValidate()
            var
                PramRessHum: Record "Human Resources Setup";
                empl: Record Employee;
                TEXT01: TextConst ENU = 'You have exceeded the authorized loan advance limit', FRA = 'Vous avez dépassé la limite de prêt avance autorisé';
                TypePretAvance: Record 55010;
                EntetAvancePret: Record "WDC Loan & Advance Header";
                MontantTranche: Decimal;
            begin
                "Total to repay" := Amount;
                "Interest %" := 0;

                PramRessHum.GET();
                empl.GET("Employee No.");
                empl.CALCFIELDS("Taxable Indemnity");
                TypePretAvance.GET("Document type");
                EntetAvancePret.RESET;
                EntetAvancePret.SETRANGE("Employee No.", "Employee No.");
                EntetAvancePret.SETRANGE(Status, 0);
                IF EntetAvancePret.Findfirst() THEN
                    REPEAT
                        MontantTranche := MontantTranche + EntetAvancePret."Slice Amount";
                    UNTIL EntetAvancePret.NEXT = 0;

                IF TypePretAvance.Type.AsInteger() = 0 THEN BEGIN
                    IF PramRessHum."Loan Limit Mode" = 0 THEN BEGIN
                        IF (Amount + MontantTranche) > ((PramRessHum.Value * (empl."Taxable Indemnity" + empl."Reel Basis salary")) / 100) THEN
                            ERROR(TEXT01);
                    END ELSE BEGIN
                        IF (Amount + MontantTranche) > PramRessHum.Value THEN
                            ERROR(TEXT01);
                    END;
                END;
                "Slice Amount" := "Total to repay";
            end;
        }
        field(11; "Interest %"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                "Total to repay" := Amount + CalcMntInetret("Effective date", "End date Loan");

                IF "Repayment slices" > 0 THEN
                    "Slice Amount" := "Total to repay" / "Repayment slices"
                ELSE
                    "Slice Amount" := "Total to repay";
            end;
        }
        field(12; "Total to repay"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Total to repay', FRA = 'Total à rembourser';
            Editable = false;
            InitValue = 0;
        }
        field(15; "Repayment slices"; Integer)
        {
            CaptionML = ENU = 'Repayment slices', FRA = 'Tranches remboursement';

            trigger OnValidate()
            var
                DateT: Date;
                PramRessHum: Record "Human Resources Setup";
                empl: Record Employee;
                TypePretAvance: Record 55010;
                lText001: TextConst ENU = 'You have exceeded the authorized loan advance limit', FRA = 'Vous avez dépassé la limite de prêt avance autorisé';
                lText002: TextConst ENU = 'Reimbursement Tranches must be > 0', FRA = 'Tranches de Remboursement doivent être > 0 ';
            begin
                PramRessHum.GET();
                IF PramRessHum."Loan Calculation Type" = 0 THEN BEGIN
                    IF "Repayment slices" <= 0 THEN
                        ERROR(lText002);
                    DateT := "Effective date";
                    "End date Loan" := CALCDATE(STRSUBSTNO('<+%1M>', "Repayment slices" - 1), DateT);
                    "Total to repay" := Amount + CalcMntInetret("Effective date", "End date Loan");
                    "Unlock Date" := CALCDATE(STRSUBSTNO('<+%1M>', "Repayment slices" - 1), DateT + 30);
                    IF "Repayment slices" > 0 THEN
                        "Slice Amount" := "Total to repay" / "Repayment slices"
                    ELSE
                        "Slice Amount" := "Total to repay";
                END;

                PramRessHum.GET();
                empl.GET("Employee No.");
                empl.CALCFIELDS("Taxable Indemnity");
                TypePretAvance.GET("Document type");
                IF TypePretAvance.Type.AsInteger() = 0 THEN BEGIN
                    IF PramRessHum."Loan Limit Mode" = 0 THEN BEGIN
                        IF "Slice Amount" > ((PramRessHum.Value * (empl."Taxable Indemnity" + empl."Reel Basis salary")) / 100) THEN
                            ERROR(lText001);
                    END ELSE BEGIN
                        IF "Slice Amount" > PramRessHum.Value THEN
                            ERROR(lText001);
                    END;
                END;
            end;
        }
        field(20; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series', FRA = 'N° Série';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(30; "Global dimension 1"; Code[20])
        {
            CaptionML = ENU = 'Global dimension 1', FRA = 'Code département';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(31; "Global dimension 2"; Code[20])
        {
            CaptionML = ENU = 'Global dimension 2', FRA = 'Code dossier';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(110; "Advance on Bonus"; Boolean)
        {
            CaptionML = ENU = 'Advance on Allowance', FRA = 'Avance sur Prime';
        }
        field(50000; "Advance on Holiday"; Boolean)
        {
            CaptionML = ENU = 'Advance on Holiday', FRA = 'Avance sur congé';
        }
        field(50001; Periodicity; Enum "Wdc Periodicity")
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
        field(50005; "Include Other Payroll"; Boolean)
        {
            CaptionML = ENU = 'Include Other Payroll', FRA = 'Inclus Paie Autre';
        }

        field(50200; "Slice Amount"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            CaptionML = ENU = 'Slice Amount', FRA = 'Montant tranche';
            trigger OnValidate()
            begin
                HumanResSetup.GET();
                IF HumanResSetup."Loan Calculation Type" = 0 THEN BEGIN
                    IF ("Total to repay" MOD "Slice Amount") > 0
                     THEN
                        VALIDATE("Repayment slices", ("Total to repay" DIV "Slice Amount") + 1)
                    ELSE
                        VALIDATE("Repayment slices", "Total to repay" / "Slice Amount");
                END;
            end;
        }
        field(50300; "Unlock Date"; Date)
        {
            CaptionML = ENU = 'Unlock Date', FRA = 'Date déblocage';
        }
        field(50400; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
        }
        field(50500; "Effective date"; Date)
        {
            CaptionML = ENU = 'Effective date', FRA = 'Date d''effet';
            trigger OnValidate()
            begin
                IF ("End date Loan" < "Effective date") OR ("End date Loan" = 0D) THEN
                    "End date Loan" := CALCDATE('<+CM>', "Effective date");//WDC CM REMPLACE FM
                IF ("Unlock Date" = 0D) OR (Type = Type::Advance) THEN
                    "Unlock Date" := "Effective date";

                VALIDATE("Interest %");
                "Repayment slices" := CalcNbreMois;
                Month := Enum::"WDC Payroll Month".FromInteger(DATE2DMY("Effective date", 2) - 1);
                Year := DATE2DMY("Effective date", 3);
                MODIFY;
            end;
        }
        field(50501; "End date Loan"; Date)
        {
            CaptionML = ENU = 'End date Loan', FRA = 'Date fin Prêt';
            trigger OnValidate()
            var
                lText001: TextConst ENU = 'Delivery Date Must Be > Effective Date',
                                    FRA = 'Date fin prêt doit être > Date effet';
            begin
                IF "End date Loan" < "Effective date" THEN
                    ERROR(lText001);
                "Repayment slices" := CalcNbreMois;
                VALIDATE("Interest %");
            end;
        }
        field(50505; "External Document No."; Code[20])
        {
            CaptionML = ENU = 'External Document No.', FRA = 'N° document externe';
        }
        field(39001432; "Bal. Account Type"; Enum "Payment Balance Account Type")
        {
            CaptionML = ENU = 'Bal. Account Type', FRA = 'Type compte contrepartie';
        }
        field(39001433; "Bal. Account No."; Text[20])
        {
            CaptionML = ENU = 'Bal. Account No.', FRA = 'N° compte contrepartie';
            TableRelation = IF ("Bal. Account Type" = FILTER("G/L Account")) "G/L Account"
            ELSE IF ("Bal. Account Type" = FILTER("Bank Account")) "Bank Account" WHERE("Currency Code" = FILTER(''));
        }
        field(39001450; "Depreciation Type"; Enum "WDC Depreciation Type")
        {
            CaptionML = ENU = '"Depreciation Type"', FRA = 'Type d''amortissement';
            trigger OnValidate()
            begin
                "Total to repay" := Amount + CalcMntInetret("Effective date", "End date Loan");

                IF "Repayment slices" > 0 THEN
                    "Slice Amount" := "Total to repay" / "Repayment slices"
                ELSE
                    "Slice Amount" := "Total to repay";
            end;
        }

        field(39001455; "Employee type"; Enum "WDC Employee type")
        {
            CaptionML = ENU = 'Employee type', FRA = 'Type d''employé';
        }
        field(39001460; "Total Month Advance"; Decimal)
        {
            CaptionML = ENU = 'Total Month Advance', FRA = 'Total Avance Mois';
            AutoFormatType = 2;
            CalcFormula = Sum("WDC Loan & Advance Header".Amount WHERE("Employee No." = FIELD("Employee No."),
                                                                    "Posting Date" = FIELD("Date Filter"),
                                                                    Type = FIELD(Type)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39001461; "Date Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter', FRA = 'Filtre Date';
            FieldClass = FlowFilter;
        }
        field(39001470; "Aid Advance"; Boolean)
        {
            CaptionML = ENU = 'Aid Advance', FRA = 'Avance sur aide';
        }
        field(39001490; "Precision Arrondi Principale"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            CaptionML = ENU = 'Principal Rounding Precision', FRA = 'Précision Arrondi Principale';
        }
        field(39001491; "Allocation Difference Rounding"; Enum "WDC Satrt-End")
        {
            CaptionML = ENU = 'Allocation Difference Rounding', FRA = 'Arrondi diff. affectation';
        }
        field(39001495; "Meal Advance"; Boolean)
        {
            CaptionML = ENU = 'Meal Advance', FRA = 'Avance repas';
        }
        field(39001496; "Payment Type"; Text[30])
        {
            CaptionML = ENU = 'Payment Type', FRA = 'Type réglement';
        }
        field(39001497; "Employee Statistic Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe compta. employé';
            Editable = false;
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
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.")
        {
        }
        key(Key3; Type)
        {
        }
        key(Key4; "Document type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
    begin
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Loan & Advance Nos.");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Loan & Advance Nos.", WorkDate(), FALSE);
        END;

        "Depreciation type" := "Depreciation Type"::Constant;
        "Posting Date" := WORKDATE;
        "Effective date" := WORKDATE;
        Month := Enum::"WDC Payroll Month".FromInteger(DATE2DMY(WORKDATE, 2) - 2);
        Year := DATE2DMY(WORKDATE, 3);
    end;

    var
        HumanResSetup: Record 5218;
        LoanAdvance: Record "WDC Loan & Advance";


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
        DateDeb := "Effective date";
        DateFin := "End date Loan";
        NbrMois := 0;
        REPEAT
            NbrMois := NbrMois + 1;
        UNTIL CALCDATE(STRSUBSTNO('<+%1M>', NbrMois), DateDeb) > DateFin;

        MntRet := 0;
        IF (DateDebT = 0D) OR (DateFinT = 0D) OR (DateFinT < "Effective date") OR (DateDebT > "End date Loan")
           OR ("Effective date" = "End date Loan") THEN
            EXIT;
        DateDebT := DateDebT;
        DateFinT := DateFinT;
        DateJ := DateDeb;
        // Amortissement Dégrissif
        CASE "Depreciation type".AsInteger() OF
            0:
                BEGIN
                    j := -1;
                    REPEAT
                        j := j + 1;
                        IF DateDebT <= CALCDATE(STRSUBSTNO('<+%1M>', j), DateDeb) THEN
                            IF CALCDATE('<+1D>', "Effective date") >= CALCDATE(STRSUBSTNO('<+%1M>', j), DateDeb) THEN
                                MntRet := MntRet + ROUND(((MontiniT * "Interest %" * (CALCDATE(STRSUBSTNO('<+%1M>', j), DateDeb) -
                                          "Unlock Date" + 1)) / 36000), 0.001)
                            ELSE
                                MntRet := MntRet + ROUND(((MontiniT * "Interest %" * (CALCDATE(STRSUBSTNO('<+%1M>', j), DateDeb) -
                                          CALCDATE(STRSUBSTNO('<+%1M>', j - 1), DateDeb))) / 36000), 0.001);

                        IF (NbrMois - j) <> 0 THEN
                            MontiniT := MontiniT - ROUND((MontiniT / (NbrMois - j)), 0.001);

                    UNTIL (DateFinT <= CALCDATE(STRSUBSTNO('<+%1M>', j), DateDeb)) OR
                          (DateFin <= CALCDATE(STRSUBSTNO('<+%1M>', j), DateDeb));
                END;
            // Amortissement Linéaire
            1:
                BEGIN
                    j := -1;
                    REPEAT
                        j := j + 1;
                        MntRet := MntRet + ROUND(((MontiniT * "Interest %") / 36000), 0.001);
                        IF (NbrMois - j) <> 0 THEN
                            MontiniT := MontiniT - ROUND((MontiniT / (NbrMois - j)), 0.001);
                        IF ("Allocation Difference Rounding".AsInteger() = 0) AND (j = 0) THEN
                            MontiniT := MontiniT - ROUND((MontiniT / (NbrMois - 1)), "Precision Arrondi Principale")
                        ELSE
                            IF (DateFin <= CALCDATE(STRSUBSTNO('<+%1M>', j + 1), DateDeb)) THEN BEGIN
                                IF (NbrMois - j) <> 0 THEN
                                    MontiniT := MontiniT - MontiniT - ROUND((MontiniT / (NbrMois - j)), 0.001);
                            END
                            ELSE
                                IF (NbrMois - j) <> 0 THEN
                                    MontiniT := MontiniT - ROUND((MontiniT / (NbrMois - j)), "Precision Arrondi Principale");
                    UNTIL (DateFin <= CALCDATE(STRSUBSTNO('<+%1M>', j), DateDeb));

                    Mnt := ROUND(MntRet / NbrMois, "Precision Arrondi Principale", '<');
                    Mnt1 := MntRet - (Mnt * (NbrMois - 1));
                    j := -1;
                    MntRet := 0;
                    REPEAT
                        j := j + 1;
                        IF (DateDebT <= CALCDATE(STRSUBSTNO('<+%1M>', j), DateDeb)) THEN
                            IF (CALCDATE('<+CM>', DateDebT) = CALCDATE(STRSUBSTNO('<+%1M>', j), DateDeb)) AND (j = 0) THEN       //WDC
                                MntRet := MntRet + Mnt1
                            ELSE
                                MntRet := MntRet + Mnt;
                    UNTIL (DateFinT <= CALCDATE(STRSUBSTNO('<+%1M>', j), DateDeb)) OR
                          (DateFin <= CALCDATE(STRSUBSTNO('<+%1M>', j), DateDeb));
                END;
            2:
                BEGIN
                    MntRet := MontiniT * "Interest %" * NbrMois / 1200;
                END;
        END;

    end;


    procedure CalcNbreMois() NbrMois: Integer
    var
        DateDeb: Date;
        DateFin: Date;
    begin
        DateDeb := "Effective date";
        DateFin := "End date Loan";
        NbrMois := 0;
        REPEAT
            NbrMois := NbrMois + 1;
        UNTIL CALCDATE(STRSUBSTNO('<+%1M>', NbrMois), DateDeb) > DateFin;
    end;

}

