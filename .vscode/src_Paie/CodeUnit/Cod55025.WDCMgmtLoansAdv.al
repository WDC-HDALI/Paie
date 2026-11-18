codeunit 55025 "WDC Mgmt. Loans & Adv"
{
    trigger OnRun()
    begin
    end;

    var
        errValidate: TextConst ENU = 'Validation interrupted. Task canceled.',
                               FRA = 'Validation interrompue. Tâche annulée.';
        Test: Boolean;
        MsgAtten: TextConst ENU = ' Warning: Employee %1, has a %2, No. %3, of type %4',
                            FRA = 'Attention : le salarié %1, \ possède un %2, N° %3,de type %4';
        Text001: textconst ENU = 'Document is already fully repaid.',
                            FRA = 'Ce document a fait l''objet d''un remboursement complet !';
        Text002: textconst ENU = 'Document successfully canceled.',
                           FRA = 'Annulation Réussite';

        Text003: TextConst ENU = 'Document status = %1, unable to proceed!',
                           FRA = 'Statut du document = %1, impossible de poursuivre !';
        Text004: TextConst ENU = 'Please check the payment',
                           FRA = 'Veuillez vérifier le réglement';

    procedure CreateRepaymentLine(var SalaryLineTmp: Record "WDC Salary Lines")
    var
        LoanAdvanceHeader: Record "WDC Loan & Advance Header";
        LoanAdvanceLines: Record "WDC Loan & Advance Lines";
        LALines: Record "WDC Loan & Advance Lines";
        ExistLoanAdvanceLine: Record "WDC Loan & Advance Lines";
        ln: Integer;
        Employee: Record Employee;
        DateD: Date;
        DateF: Date;
        LoanAD: Record "WDC Loan & Advance Header";
        Mnt: Decimal;
        MntTmp: Decimal;
        EntSal: Record "WDC Salary Header";
        PrimeType: Record "WDC Bonus";
        "TotalPrêt": Decimal;
    begin
        IF SalaryLineTmp.Month.AsInteger() < 12 THEN BEGIN
            DateD := DMY2DATE(1, SalaryLineTmp.Month.AsInteger() + 1, SalaryLineTmp.Year);
            DateF := CALCDATE('<+CM>', DateD);//WDC
        END ELSE BEGIN
            EntSal.RESET;
            EntSal.SETCURRENTKEY(Year, Month, "No.");
            EntSal.SETRANGE(Year, SalaryLineTmp.Year);
            EntSal.SETFILTER(Month, '%1..%2', 0, 16);
            IF EntSal.FINDFIRST THEN;
            DateD := DMY2DATE(1, DATE2DMY(SalaryLineTmp."Posting Date", 2), SalaryLineTmp.Year);
            DateF := CALCDATE('<+CM>', DateD);  //WDC
        END;

        SalaryLineTmp.Loans := 0;
        SalaryLineTmp.Advances := 0;

        LoanAdvanceLines.RESET;
        LoanAdvanceLines.SETCURRENTKEY("Payment No.", Paid, "Employee No.");
        LoanAdvanceLines.SETFILTER("Payment No.", SalaryLineTmp."No.");
        LoanAdvanceLines.SETRANGE(Paid, FALSE);
        LoanAdvanceLines.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        LoanAdvanceLines.DELETEALL;

        IF (SalaryLineTmp.Month.AsInteger() < 12) OR (SalaryLineTmp.Month.AsInteger() = 14) OR (SalaryLineTmp.Month.AsInteger() = 15) OR (SalaryLineTmp.Month.AsInteger() = 12) OR (SalaryLineTmp.Month.AsInteger() = 16) THEN BEGIN
            LoanAD.RESET;
            LoanAD.SETCURRENTKEY("Employee No.", Type, Status, "No.", "Avance Sur Prime");
            LoanAD.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
            LoanAD.SETRANGE(Type, LoanAD.Type::Loan);
            LoanAD.SETRANGE(Status, LoanAD.Status::"In progress");
            LoanAD.SETFILTER("Type Tranche", '<>%1', LoanAD."Type Tranche"::Report);
            LoanAD.SETRANGE("Not include", FALSE);
            IF (SalaryLineTmp.Month.AsInteger() = 12) THEN LoanAD.SETRANGE("Inclus Paie13", TRUE);
            IF (SalaryLineTmp.Month.AsInteger() = 14) THEN LoanAD.SETRANGE("Avance Sur Prime", TRUE);
            IF (SalaryLineTmp.Month.AsInteger() = 16) THEN LoanAD.SETRANGE(LoanAD."Inclus Paie Autre", TRUE);


            LoanAD.SETRANGE("Meal Advance", FALSE);
            IF LoanAD.FINDFIRST THEN
                REPEAT
                    IF calcSolde(LoanAD, SalaryLineTmp) THEN BEGIN
                        IF LoanAD."Type Tranche" = LoanAD."Type Tranche"::Salary THEN BEGIN
                            SalaryLineTmp.Loans := SalaryLineTmp.Loans + ROUND(LoanAD.CalcMnPrinciPeriodeeng(DateD, DateF), 0.001) +
                                                 ROUND(LoanAD.CalcMntInetretEng1(DateD, DateF), 0.001);
                        END;
                        IF (ROUND(LoanAD.CalcMnPrinciPeriodeeng(DateD, DateF), 0.001) <> 0) OR
                           (ROUND(LoanAD.CalcMntInetretEng1(DateD, DateF), 0.001) <> 0) THEN BEGIN
                            InsererLigne(SalaryLineTmp, LoanAD, ROUND(LoanAD.CalcMnPrinciPeriodeeng(DateD, DateF), 0.001),
                            ROUND(LoanAD.CalcMntInetretEng1(DateD, DateF), 0.001));
                            IF LoanAD."Double tranche" = TRUE THEN BEGIN
                                InsererLigne(SalaryLineTmp, LoanAD, ROUND((LoanAD.CalcMnPrinciPeriodeeng(DateD, DateF) * LoanAD."Nombre Tranches"), 0.001),
                                ROUND(LoanAD.CalcMntInetretEng1(DateD, DateF), 0.001));
                                LoanAdvanceLines.RESET;
                                LoanAdvanceLines.SETRANGE("Payment No.", SalaryLineTmp."No.");
                                LoanAdvanceLines.SETRANGE("Employee No.", SalaryLineTmp."Employee No.");
                                LoanAdvanceLines.SETRANGE(Type, LoanAdvanceLines.Type::Loan);
                                IF LoanAdvanceLines.FINDSET THEN BEGIN
                                    TotalPrêt := 0;
                                    REPEAT
                                        TotalPrêt := TotalPrêt + LoanAdvanceLines."Line Amount";
                                    UNTIL LoanAdvanceLines.NEXT = 0;
                                END;
                                SalaryLineTmp.Loans := TotalPrêt;
                                SalaryLineTmp.MODIFY;
                            END;
                        END;

                    END;
                UNTIL LoanAD.NEXT = 0;

            // Advance
            IF (SalaryLineTmp.Month.AsInteger() <> 12) THEN BEGIN
                LoanAD.RESET;
                LoanAD.SETCURRENTKEY("Employee No.", Type, Status, "No.", "Avance Sur Prime");
                LoanAD.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
                LoanAD.SETRANGE(Type, LoanAD.Type::Advance);
                LoanAD.SETRANGE(Status, LoanAD.Status::"In progress");

                IF (SalaryLineTmp.Month.AsInteger() = 14) THEN
                    LoanAD.SETRANGE("Avance Sur Prime", TRUE)
                ELSE
                    IF (SalaryLineTmp.Month.AsInteger() = 16) THEN
                        LoanAD.SETRANGE("Advance on Holiday", TRUE)
                    ELSE BEGIN
                        LoanAD.SETRANGE("Avance Sur Prime", FALSE);
                        LoanAD.SETRANGE("Advance on Holiday", FALSE);
                    END;
                LoanAD.SETRANGE("Not include", FALSE);
                LoanAD.SETRANGE("Meal Advance", FALSE);
                IF LoanAD.FINDFIRST THEN
                    REPEAT
                        IF calcSolde(LoanAD, SalaryLineTmp) THEN BEGIN
                            SalaryLineTmp.Advances := SalaryLineTmp.Advances + ROUND(LoanAD.CalcMnPrinciPeriodeeng(DateD, DateF), 0.001);
                            IF (ROUND(LoanAD.CalcMnPrinciPeriodeeng(DateD, DateF), 0.001) <> 0) THEN
                                InsererLigne(SalaryLineTmp, LoanAD, ROUND(LoanAD.CalcMnPrinciPeriodeeng(DateD, DateF), 0.001), 0);
                        END;

                    UNTIL LoanAD.NEXT = 0;

            END ELSE

                IF (SalaryLineTmp.Month = SalaryLineTmp.Month::Other) AND (SalaryLineTmp.Month = SalaryLineTmp.Month::Prime) THEN BEGIN
                    Mnt := 0;
                    Mnt := SalaryLineTmp."Net salary";
                    CLEAR(PrimeType);
                    IF PrimeType.GET(SalaryLineTmp."Bonus Type") THEN;

                    IF Mnt <> 0 THEN BEGIN
                        LoanAD.RESET;
                        LoanAD.SETCURRENTKEY("Employee No.", Type, Status, "No.", "Avance Sur Prime");
                        LoanAD.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
                        LoanAD.SETRANGE(Type, LoanAD.Type::Loan);
                        LoanAD.SETRANGE(Status, LoanAD.Status::"In progress");
                        IF PrimeType."Calculation Type".AsInteger() = 3 THEN
                            LoanAD.SETRANGE("Meal Advance", TRUE)
                        ELSE
                            LoanAD.SETRANGE("Avance Sur Prime", TRUE);
                        LoanAD.SETRANGE("Not include", FALSE);

                        IF LoanAD.FINDFIRST THEN
                            REPEAT

                                MntTmp := 0;
                                MntTmp := ROUND(LoanAD.CalcMntInetretAvPrime(DateF), 0.001);
                                IF Mnt < MntTmp THEN BEGIN
                                    SalaryLineTmp.Loans := SalaryLineTmp.Loans + Mnt;
                                    InsererLigne(SalaryLineTmp, LoanAD, (Mnt - MntTmp), MntTmp);
                                    Mnt := 0;
                                END
                                ELSE BEGIN
                                    IF (Mnt - MntTmp) < LoanAD.CalcMnPRincipaleRemb THEN BEGIN
                                        SalaryLineTmp.Loans := SalaryLineTmp.Loans + Mnt;
                                        InsererLigne(SalaryLineTmp, LoanAD, (Mnt - MntTmp), MntTmp);
                                        Mnt := 0;
                                    END ELSE BEGIN
                                        SalaryLineTmp.Loans := SalaryLineTmp.Loans + LoanAD.CalcMnPRincipaleRemb;
                                        InsererLigne(SalaryLineTmp, LoanAD, LoanAD.CalcMnPRincipaleRemb, MntTmp);
                                        Mnt := Mnt - (MntTmp + LoanAD.CalcMnPRincipaleRemb);
                                    END;
                                END;
                            UNTIL (LoanAD.NEXT = 0) OR (Mnt = 0);
                    END;
                    // Advance sur prime
                    LoanAD.RESET;
                    LoanAD.SETCURRENTKEY("Employee No.", Type, Status, "No.", "Avance Sur Prime");
                    LoanAD.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
                    LoanAD.SETRANGE(Type, LoanAD.Type::Advance);
                    LoanAD.SETRANGE(Status, LoanAD.Status::"In progress");
                    IF PrimeType."Calculation Type".AsInteger() = 3 THEN
                        LoanAD.SETRANGE("Meal Advance", TRUE)
                    ELSE
                        LoanAD.SETRANGE("Avance Sur Prime", TRUE);

                    LoanAD.SETRANGE("Not include", FALSE);
                    IF LoanAD.FINDFIRST THEN
                        REPEAT

                            MntTmp := 0;
                            MntTmp := ROUND(LoanAD.CalcMntInetretAvPrime(DateF), 0.001);
                            IF Mnt < MntTmp THEN BEGIN
                                SalaryLineTmp.Advances := SalaryLineTmp.Advances + Mnt;
                                InsererLigne(SalaryLineTmp, LoanAD, (Mnt - MntTmp), MntTmp);
                                Mnt := 0;
                            END
                            ELSE BEGIN
                                IF (Mnt - MntTmp) < LoanAD.CalcMnPRincipaleRemb THEN BEGIN
                                    SalaryLineTmp.Advances := SalaryLineTmp.Advances + Mnt;
                                    InsererLigne(SalaryLineTmp, LoanAD, (Mnt - MntTmp), MntTmp);
                                    Mnt := 0;
                                END ELSE BEGIN
                                    SalaryLineTmp.Advances := SalaryLineTmp.Advances + LoanAD.CalcMnPRincipaleRemb;
                                    InsererLigne(SalaryLineTmp, LoanAD, LoanAD.CalcMnPRincipaleRemb, MntTmp);
                                    Mnt := Mnt - (MntTmp + LoanAD.CalcMnPRincipaleRemb);
                                END;
                            END;
                        UNTIL (LoanAD.NEXT = 0) OR (Mnt = 0);
                    IF PrimeType."Calculation Type".AsInteger() <> 3 THEN BEGIN
                        LoanAD.RESET;
                        LoanAD.SETCURRENTKEY("Employee No.", Type, Status, "No.", "Avance Sur Prime");
                        LoanAD.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
                        LoanAD.SETRANGE(Type, LoanAD.Type::Advance);
                        LoanAD.SETRANGE(Status, LoanAD.Status::"In progress");
                        LoanAD.SETRANGE("Avance Sur Prime", FALSE);
                        LoanAD.SETRANGE("Aid Advance", FALSE);
                        LoanAD.SETRANGE("Not include", FALSE);
                        IF LoanAD.FINDFIRST THEN
                            REPEAT
                                MntTmp := 0;
                                MntTmp := ROUND(LoanAD.CalcMntInetretAvPrime(DateF), 0.001);
                                IF Mnt < MntTmp THEN BEGIN
                                    SalaryLineTmp.Advances := SalaryLineTmp.Advances + Mnt;
                                    InsererLigne(SalaryLineTmp, LoanAD, (Mnt - MntTmp), MntTmp);
                                    Mnt := 0;
                                END
                                ELSE BEGIN
                                    IF (Mnt - MntTmp) < LoanAD.CalcMnPRincipaleRemb THEN BEGIN
                                        SalaryLineTmp.Advances := SalaryLineTmp.Advances + Mnt;
                                        InsererLigne(SalaryLineTmp, LoanAD, (Mnt - MntTmp), MntTmp);
                                        Mnt := 0;
                                    END ELSE BEGIN
                                        SalaryLineTmp.Advances := SalaryLineTmp.Advances + LoanAD.CalcMnPRincipaleRemb;
                                        InsererLigne(SalaryLineTmp, LoanAD, LoanAD.CalcMnPRincipaleRemb, MntTmp);
                                        Mnt := Mnt - (MntTmp + LoanAD.CalcMnPRincipaleRemb);
                                    END;
                                END;
                            UNTIL (LoanAD.NEXT = 0) OR (Mnt = 0);
                    END;
                END;
        END;
    end;


    procedure CloturerDocument(Header: Record "WDC Loan & Advance Header")
    var
        Lines: Record "WDC Loan & Advance Lines";
        LoanAdvanceEntry: Record "WDC Loan & Advance Lines";
    begin
        Header.CALCFIELDS("Repaid amount", "Repaid %", "Principal Amount");
        IF ((Header."Principal Amount" = Header.Amount)) THEN BEGIN
            Test := TRUE;
            Lines.SETRANGE("No.", Header."No.");
            IF Lines.FINDFIRST THEN
                REPEAT
                    IF NOT Lines.Paid THEN
                        Test := FALSE;
                UNTIL Lines.NEXT = 0;
            IF Test THEN BEGIN
                Header.Status := Header.Status::Enclosed;
                Header.MODIFY;

                Lines.RESET;
                Lines.SETRANGE("No.", Header."No.");
                IF Lines.FINDFIRST THEN BEGIN
                    Lines.Status := Lines.Status::Enclosed;
                    Lines.MODIFY;
                END;
                LoanAdvanceEntry.RESET;
                LoanAdvanceEntry.SETRANGE("No.", Header."No.");
                IF LoanAdvanceEntry.FINDFIRST THEN
                    REPEAT
                        LoanAdvanceEntry.Status := LoanAdvanceEntry.Status::Enclosed;
                        LoanAdvanceEntry.MODIFY;
                    UNTIL LoanAdvanceEntry.NEXT = 0;
            END;
        END;
    end;


    procedure EnregDocument(LoanAdvance: Record "WDC Loan & Advance"; DateCompta: Date)
    var
        LoanAdvanceHeader: Record "WDC Loan & Advance Header";
        errMC: TextConst ENU = 'Validation impossible.\Some important parameter aren''t mentionned.',
                         FRA = 'Validation impossible.\Some important parameter aren''t mentionned.';
        LoanAdvanceEntry: Record "WDC Loan & Advance Entry";
    begin
        IF NOT TestValiditeDocument(LoanAdvance) THEN
            ERROR(errMC);

        IF ((LoanAdvance."Repayment slices" <> 0)
            AND
            (LoanAdvance.Amount <> 0)
           ) THEN BEGIN
            LoanAdvanceHeader.RESET;
            LoanAdvanceHeader.INIT;
            LoanAdvanceHeader.TRANSFERFIELDS(LoanAdvance);
            LoanAdvanceHeader."No." := LoanAdvance."No.";
            LoanAdvanceHeader."Employee No." := LoanAdvance."Employee No.";
            LoanAdvanceHeader.Name := LoanAdvance.Name;
            LoanAdvanceHeader."Job Title" := LoanAdvance."Job Title";
            LoanAdvanceHeader."Employee Posting Group" := LoanAdvance."Employee Posting Group";
            LoanAdvanceHeader."Employee Statistic Group" := LoanAdvance."Employee Statistic Group";
            LoanAdvanceHeader."Global dimension 1" := LoanAdvance."Global dimension 1";
            LoanAdvanceHeader."Global dimension 2" := LoanAdvance."Global dimension 2";
            LoanAdvanceHeader.Management := LoanAdvance.Management;
            LoanAdvanceHeader.service := LoanAdvance.service;
            LoanAdvanceHeader.section := LoanAdvance.section;
            LoanAdvanceHeader.Type := LoanAdvance.Type;
            LoanAdvanceHeader."Document type" := LoanAdvance."Document type";
            LoanAdvanceHeader.Amount := LoanAdvance.Amount;
            LoanAdvanceHeader."Interest %" := LoanAdvance."Interest %";
            LoanAdvanceHeader."Total to repay" := LoanAdvance."Total to repay";
            LoanAdvanceHeader."External Document No." := LoanAdvance."External Document No.";
            LoanAdvanceHeader."Slice Amount" := LoanAdvance."Slice Amount";
            LoanAdvanceHeader."Effective date" := LoanAdvance."Effective date";
            LoanAdvanceHeader."Type Tranche" := LoanAdvance."Type Tranche";
            LoanAdvanceHeader."Avance Sur Prime" := LoanAdvance."Advance on Bonus";
            LoanAdvanceHeader."Advance on Holiday" := LoanAdvance."Advance on Holiday";
            LoanAdvanceHeader."Repayment slices" := LoanAdvance."Repayment slices";
            LoanAdvanceHeader."No. Series" := LoanAdvance."No. Series";
            //LoanAdvanceHeader."Validation date" := WORKDATE;
            LoanAdvanceHeader."Posting Date" := DateCompta;
            LoanAdvanceHeader.Status := LoanAdvanceHeader.Status::"In progress";
            LoanAdvanceHeader."Meal Advance" := LoanAdvance."Meal Advance";
            IF LoanAdvanceHeader.INSERT THEN BEGIN
                LoanAdvanceEntry.RESET;
                LoanAdvanceEntry.INIT;
                LoanAdvanceEntry."No." := LoanAdvance."No.";
                LoanAdvanceEntry."Entry No." := 0;
                LoanAdvanceEntry."Employee No." := LoanAdvance."Employee No.";
                LoanAdvanceEntry.Name := LoanAdvance.Name;
                LoanAdvanceEntry."Employee Posting Group" := LoanAdvance."Employee Posting Group";
                LoanAdvanceEntry."Employee Statistic Group" := LoanAdvance."Employee Statistic Group";
                LoanAdvanceEntry."Global dimension 1" := LoanAdvance."Global dimension 1";
                LoanAdvanceEntry."Global dimension 2" := LoanAdvance."Global dimension 2";
                LoanAdvanceEntry.Management := LoanAdvance.Management;
                LoanAdvanceEntry.service := LoanAdvance.service;
                LoanAdvanceEntry.section := LoanAdvance.section;
                LoanAdvanceEntry.Month := Enum::"WDC Payroll Month".FromInteger(DATE2DMY(DateCompta, 2) - 1);
                LoanAdvanceEntry.Year := DATE2DMY(DateCompta, 3);
                LoanAdvanceEntry."Payroll Date" := DateCompta;
                LoanAdvanceEntry.Type := LoanAdvance.Type;
                LoanAdvanceEntry."Document type" := LoanAdvance."Document type";
                LoanAdvanceEntry."Entry type" := LoanAdvanceEntry."Entry type"::Payment;
                LoanAdvanceEntry.Amount := LoanAdvance."Total to repay";
                LoanAdvanceEntry."Meal Advance" := LoanAdvance."Meal Advance";
                LoanAdvanceEntry.INSERT;
                LoanAdvance.DELETE;
            END
            ELSE
                ERROR(errValidate);
        END
    end;


    procedure TestValiditeDocument(LoanAdvance: Record "WDC Loan & Advance"): Boolean
    var
        TypeDoc: Record "WDC Loan & Advance Type";
    begin
        CLEAR(TypeDoc);
        TypeDoc.GET(LoanAdvance."Document type");
        IF TypeDoc."Accounting Posting".AsInteger() = 0 THEN BEGIN
            IF ((LoanAdvance."Employee No." <> '')
                AND (LoanAdvance."Employee Posting Group" <> '')
                AND (LoanAdvance."Document type" <> '')
                AND (LoanAdvance.Amount > 0)
                AND (LoanAdvance."Total to repay" > 0)
                AND (LoanAdvance."Repayment slices" > 0)
                AND (LoanAdvance."Bal. Account No." <> '')
               ) THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END ELSE
            IF ((LoanAdvance."Employee No." <> '')
                AND (LoanAdvance."Employee Posting Group" <> '')
                AND (LoanAdvance."Document type" <> '')
                AND (LoanAdvance.Amount > 0)
                AND (LoanAdvance."Total to repay" > 0)
                AND (LoanAdvance."Repayment slices" > 0)
                   ) THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
    end;


    procedure EcrComptaPaiement(LoanAdvance: Record "WDC Loan & Advance"; DateValidation: Date; TypeValidation: Option)
    var
        HumResSetup: Record "Human Resources Setup";
        errConfig: TextConst ENU = 'General Journal Template empty in Human Resource Parameter.',
                              FRA = 'Modèle de journal général vide dans les paramètres de ressources humaines.';
        LAType: Record "WDC Loan & Advance Type";
        errLATypeMissing: TextConst ENU = 'Loan & Advance Type missing.',
                                    FRA = 'Type de prêt & avance manquant.';
        errWrongParam: TextConst ENU = 'Account No. or Bal. Account No. empty in Loan & Advance type parameter.',
                                 FRA = 'Compte ou compte auxiliaire vide dans le paramètre de type de prêt & avance.';
        GenJournalLine: Record 81;
        GenJournalBatch: Record 232;
        GenJnlPostLine: Codeunit 12;
        Line: Integer;
        BankAccount: Record 270;
        CourtT: Decimal;
        LongT: Decimal;
    begin
        HumResSetup.GET();
        IF NOT LAType.GET(LoanAdvance."Document type") THEN
            ERROR(errLATypeMissing);
        IF ((LAType."Account No." = '') OR (LAType."Bal. Account No." = '')) THEN
            ERROR(errWrongParam);
        IF TypeValidation <> 2 THEN BEGIN
            IF (HumResSetup."General Journal Template" = '') THEN
                ERROR(errConfig);
            GenJournalLine.SETRANGE("Journal Template Name", HumResSetup."General Journal Template");
            GenJournalLine.SETRANGE("Journal Batch Name", HumResSetup."Gen. Journal Batch (L&A)");
            GenJournalLine.SETRANGE("Document No.", LoanAdvance."No.");
            GenJournalLine.DELETEALL;
            GenJournalLine.RESET;
            GenJournalLine.SETRANGE("Journal Template Name", HumResSetup."General Journal Template");
            GenJournalLine.SETRANGE("Journal Batch Name", HumResSetup."Gen. Journal Batch (L&A)");
            IF GenJournalLine.FINDLAST() THEN
                Line := GenJournalLine."Line No." + 10000
            ELSE
                Line := 10000;

            GenJournalLine.RESET;
            GenJournalLine."Journal Template Name" := HumResSetup."General Journal Template";
            IF HumResSetup."Gen. Journal Batch (L&A)" <> '' THEN
                GenJournalLine."Journal Batch Name" := HumResSetup."Gen. Journal Batch (L&A)"
            ELSE BEGIN
                GenJournalBatch.SETRANGE("Journal Template Name", HumResSetup."General Journal Template");
                IF GenJournalBatch.FINDFIRST THEN
                    GenJournalLine."Journal Batch Name" := HumResSetup."Gen. Journal Batch (Payroll)";
            END;

            GenJournalLine.VALIDATE("Line No.", Line);
            GenJournalLine.VALIDATE("Posting Date", DateValidation);
            CASE LAType."Account Type".AsInteger() OF
                0:
                    GenJournalLine.VALIDATE("Account Type", 0);
                1:
                    BEGIN
                        GenJournalLine.VALIDATE("Account Type", 3);
                        IF BankAccount.GET(LAType."Bal. Account No.") THEN
                            GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                    END;
            END;

            GenJournalLine.VALIDATE("Account No.", LAType."Account No.");
            GenJournalLine.VALIDATE("Posting Date", DateValidation);
            GenJournalLine."Source Code" := LAType."Source Code";
            GenJournalLine.VALIDATE("Document Type", 0);
            GenJournalLine.VALIDATE("Document No.", LoanAdvance."No.");
            CASE LAType."Bal. Account Type".AsInteger() OF
                0:
                    BEGIN
                        GenJournalLine.VALIDATE("Bal. Account Type", 0);
                        GenJournalLine.VALIDATE("Currency Code", '');
                    END;
                1:
                    BEGIN
                        GenJournalLine.VALIDATE("Bal. Account Type", 3);
                        IF BankAccount.GET(LAType."Bal. Account No.") THEN
                            GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                    END;
            END;

            GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee;
            GenJournalLine."Source No." := LoanAdvance."Employee No.";
            GenJournalLine."External Document No." := LoanAdvance."External Document No.";
            IF LoanAdvance.Type.AsInteger() = 0 THEN BEGIN
                GenJournalLine.VALIDATE("Bal. Account No.", LoanAdvance."Bal. Account No.");
                GenJournalLine.VALIDATE("Debit Amount", LoanAdvance.Amount);
                GenJournalLine.INSERT;
            END ELSE BEGIN
                CourtT := LoanAdvance.Amount;
                LongT := LoanAdvance."Total to repay" - LoanAdvance.Amount;
                GenJournalLine.VALIDATE("Posting Date", DateValidation);
                IF CourtT <> 0 THEN BEGIN
                    CASE LAType."Account Type".AsInteger() OF
                        0:
                            BEGIN
                                GenJournalLine.VALIDATE("Account Type", 0);
                                GenJournalLine.VALIDATE("Account No.", LAType."Account No.");
                                GenJournalLine.VALIDATE("Currency Code", '');
                            END;
                        1:
                            BEGIN
                                GenJournalLine.VALIDATE("Account Type", 3);
                                GenJournalLine.VALIDATE("Account No.", LAType."Account No.");
                                IF BankAccount.GET(LAType."Account No.") THEN
                                    GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                            END;
                    END;
                    GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee;
                    GenJournalLine."Source No." := LoanAdvance."Employee No.";
                    GenJournalLine.VALIDATE("Debit Amount", CourtT);
                    GenJournalLine.INSERT;
                END;
                IF LongT <> 0 THEN BEGIN
                    Line := Line + 10000;
                    GenJournalLine."Line No." := Line;
                    GenJournalLine.VALIDATE("Posting Date", DateValidation);

                    CASE LAType."Long Term Account Type".AsInteger() OF
                        0:
                            BEGIN
                                GenJournalLine.VALIDATE("Account Type", 0);
                                GenJournalLine.VALIDATE("Account No.", LAType."Long Term Account No.");
                                GenJournalLine.VALIDATE("Currency Code", '');
                            END;
                        1:
                            BEGIN
                                GenJournalLine.VALIDATE("Account Type", 3);
                                GenJournalLine.VALIDATE("Account No.", LAType."Long Term Account No.");
                                IF BankAccount.GET(LAType."Long Term Account No.") THEN
                                    GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                            END;
                    END;
                    GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee;
                    GenJournalLine."External Document No." := LoanAdvance."External Document No.";
                    GenJournalLine."Source No." := LoanAdvance."Employee No.";
                    GenJournalLine.VALIDATE("Credit Amount", LongT);
                    GenJournalLine.INSERT;
                END;
                //
                Line := Line + 10000;
                GenJournalLine."Line No." := Line;
                GenJournalLine.VALIDATE("Posting Date", DateValidation);

                CASE LoanAdvance."Bal. Account Type".AsInteger() OF
                    0:
                        BEGIN
                            GenJournalLine.VALIDATE("Bal. Account Type", 0);
                            GenJournalLine.VALIDATE("Account No.", LoanAdvance."Bal. Account No.");
                            GenJournalLine.VALIDATE("Currency Code", '');
                        END;
                    1:
                        BEGIN
                            GenJournalLine.VALIDATE("Account Type", 3);
                            GenJournalLine.VALIDATE("Account No.", LoanAdvance."Bal. Account No.");
                            IF BankAccount.GET(LoanAdvance."Bal. Account No.") THEN
                                GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                        END;
                END;
                GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee;
                GenJournalLine."Source No." := LoanAdvance."Employee No.";
                GenJournalLine."External Document No." := LoanAdvance."External Document No.";
                GenJournalLine.VALIDATE("Credit Amount", CourtT);
                GenJournalLine.INSERT;
                IF LongT <> 0 THEN BEGIN
                    Line := Line + 10000;
                    GenJournalLine."Line No." := Line;
                    GenJournalLine.VALIDATE("Posting Date", DateValidation);

                    CASE LAType."Account Type".AsInteger() OF
                        0:
                            BEGIN
                                GenJournalLine.VALIDATE("Account Type", 0);
                                GenJournalLine.VALIDATE("Account No.", LAType."Account No.");
                                GenJournalLine.VALIDATE("Currency Code", '');
                            END;
                        1:
                            BEGIN
                                GenJournalLine.VALIDATE("Account Type", 3);
                                GenJournalLine.VALIDATE("Account No.", LAType."Account No.");
                                IF BankAccount.GET(LAType."Account No.") THEN
                                    GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                            END;
                    END;
                    GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee;
                    GenJournalLine."Source No." := LoanAdvance."Employee No.";
                    GenJournalLine."External Document No." := LoanAdvance."External Document No.";
                    GenJournalLine.VALIDATE("Debit Amount", LongT);
                    GenJournalLine.INSERT;
                END;

            END;

        END;

    end;


    procedure Solder(var Header: Record "WDC Loan & Advance Header"; var Datecompta: Date; var TypeCpt: Enum "Gen. Journal Account Type"; NumCpt: Code[20]; NumDoc: Code[20]; DateP: Date)
    var
        Lines: Record "WDC Loan & Advance Lines";
        ln: Integer;
        DateF: Date;
        ResSetup: Record "Human Resources Setup";
        MontantPrin: Decimal;
        Montantint: Decimal;
        Mnttot: Decimal;
        Ltype: Record "WDC Loan & Advance Type";

    begin
        Header.CALCFIELDS("Repaid amount", "Repaid %", "Principal Amount", "Interest Amount");
        IF Header."Repaid amount" >= Header."Total to repay" THEN
            ERROR(Text001);
        IF Header.Status.AsInteger() = 1 THEN
            ERROR(Text003, Header.Status);
        ResSetup.GET;
        DateF := CALCDATE(STRSUBSTNO('<-%1J+CM>', ResSetup."Apply Loan After"), Datecompta);
        MontantPrin := Header.Amount - Header."Principal Amount";
        Montantint := Header.CalcMntInetretEng1(Header."Effective date", Datecompta) - Header."Interest Amount";
        CLEAR(Ltype);
        Ltype.GET(Header."Document type");

        IF CONFIRM('Etes vous sur de vouloir solder ce document ?\' +
                    'N° document : %1 au bénéfice de %2\' +
                    'Type : %3 - %4\' +
                    'Reste à rembourser : %5', FALSE, Header."No.", Header."Employee No." + ' ' + Header.Name,
                    Header.Type, Header."Document type", ROUND(MontantPrin + Montantint, 0.001))
          THEN BEGIN
            Lines.SETRANGE("No.", Header."No.");
            Lines.SETRANGE(Type, Header.Type);
            Lines.SETRANGE("Document type", Header."Document type");
            IF Lines.FINDLAST() THEN
                ln := Lines."Entry No." + 10000
            ELSE
                ln := 10000;
            Mnttot := (MontantPrin + Montantint);
            IF Ltype."Accounting Posting".AsInteger() = 0 THEN
                IF NOT CreateTreasuryEntries(Header, Datecompta, TypeCpt, NumCpt, NumDoc, Mnttot) THEN
                    ERROR(Text004);

            Lines.INIT;
            Lines."No." := Header."No.";
            Lines."Entry No." := ln;
            Lines."Employee No." := Header."Employee No.";
            Lines."Employee Posting Group" := Header."Employee Posting Group";
            Lines."Employee Statistic Group" := Header."Employee Statistic Group";
            Lines."Global dimension 1" := Header."Global dimension 1";
            Lines."Global dimension 2" := Header."Global dimension 2";
            Lines.Type := Header.Type;
            Lines."Document type" := Header."Document type";
            Lines."Line Amount" := MontantPrin + Montantint;
            Lines."Line %" := ROUND(MontantPrin / Header.Amount, 0.0001) * 100;
            Lines.Status := Lines.Status::"In progress";
            Lines."Payment No." := 'SLD MANUEL';
            Lines."Payroll Date" := DateP;
            Lines."Posting Date" := DateP;
            Lines.Month := Enum::"WDC Payroll Month".FromInteger(DATE2DMY(DateP, 2) - 1);
            Lines.Year := DATE2DMY(DateP, 3);

            Lines.Paid := TRUE;
            Lines."Principal Amount" := MontantPrin;
            Lines."Interest Amount" := Montantint;
            Lines."Account Type" := TypeCpt;
            Lines."Account No." := NumCpt;
            Lines."External Document No." := NumDoc;
            Lines."Meal Advance" := Header."Meal Advance";
            Lines.INSERT;
            CreateEntryLigne(Lines);

        END;
    end;


    procedure SolderDepasser(var Header: Record "WDC Loan & Advance Header"; var Datecompta: Date; TypeCpt: Enum "Gen. Journal Account Type"; NumCpt: Code[20]; NumDoc: Code[20]; DateP: Date)
    var
        Lines: Record "WDC Loan & Advance Lines";
        ln: Integer;
        DateF: Date;
        ResSetup: Record "Human Resources Setup";
        MontantPrin: Decimal;
        Montantint: Decimal;
        Mnttot: Decimal;
        Ltype: Record "WDC Loan & Advance Type";
    begin
        Header.CALCFIELDS("Repaid amount", "Repaid %", "Principal Amount", "Interest Amount");
        IF Header."Repaid amount" >= Header."Total to repay" THEN
            ERROR(Text001);
        IF Header.Status.AsInteger() = 1 THEN
            ERROR(Text003, Header.Status);
        ResSetup.GET;
        DateF := CALCDATE(STRSUBSTNO('<-%1J+CM>', ResSetup."Apply Loan After"), Datecompta);
        MontantPrin := Header.CalcMnPrinciPeriodeeng(Header."Effective date", DateF) - Header."Principal Amount";
        Montantint := Header.CalcMntInetretEng1(Header."Effective date", DateF) - Header."Interest Amount";
        CLEAR(Ltype);
        Ltype.GET(Header."Document type");

        IF CONFIRM('Etes vous sur de vouloir solder ce document ?\' +
                    'N° document : %1 au bénéfice de %2\' +
                    'Type : %3 - %4\' +
                    'Reste à rembourser : %5', FALSE, Header."No.", Header."Employee No." + ' ' + Header.Name,
                    Header.Type, Header."Document type", ROUND(MontantPrin + Montantint, 0.001))
          THEN BEGIN
            Lines.SETRANGE("No.", Header."No.");
            Lines.SETRANGE(Type, Header.Type);
            Lines.SETRANGE("Document type", Header."Document type");
            IF Lines.FINDLAST() THEN
                ln := Lines."Entry No." + 10000
            ELSE
                ln := 10000;
            Mnttot := (MontantPrin + Montantint);
            IF Ltype."Accounting Posting".AsInteger() = 0 THEN
                IF NOT CreateTreasuryEntries(Header, Datecompta, TypeCpt, NumCpt, NumDoc, Mnttot) THEN
                    ERROR(Text004);
            ;
            Lines.INIT;
            Lines."No." := Header."No.";
            Lines."Entry No." := ln;
            Lines."Employee No." := Header."Employee No.";
            Lines."Employee Posting Group" := Header."Employee Posting Group";
            Lines."Employee Statistic Group" := Header."Employee Statistic Group";
            Lines."Global dimension 1" := Header."Global dimension 1";
            Lines."Global dimension 2" := Header."Global dimension 2";
            Lines.Management := Header.Management;
            Lines.service := Header.service;
            Lines.section := Header.section;
            Lines.Type := Header.Type;
            Lines."Document type" := Header."Document type";
            Lines."Line Amount" := MontantPrin + Montantint;
            Lines."Line %" := 100 - Header."Repaid %";
            Lines.Status := Lines.Status::"In progress";
            Lines."Payment No." := 'SLD MANUEL';
            Lines."Payroll Date" := DateP;
            Lines.Month := Enum::"WDC Payroll Month".FromInteger(DATE2DMY(DateP, 2) - 1);
            Lines.Year := DATE2DMY(DateP, 3);

            Lines.Paid := TRUE;
            Lines."Principal Amount" := MontantPrin;
            Lines."Interest Amount" := Montantint;
            Lines."Account Type" := TypeCpt;
            Lines."Account No." := NumCpt;
            Lines."External Document No." := NumDoc;
            Lines."Meal Advance" := Header."Meal Advance";
            Lines.INSERT;
            CreateEntryLigne(Lines);

        END;
    end;


    procedure ReglerMnt(var Header: Record "WDC Loan & Advance Header"; var Datecompta: Date; TypeCpt: Enum "Gen. Journal Account Type"; NumCpt: Code[20]; NumDoc: Code[20]; Mntreg: Decimal; DateP: Date)
    var
        Lines: Record "WDC Loan & Advance Lines";
        ln: Integer;
        DateF: Date;
        ResSetup: Record "Human Resources Setup";
        MontantPrin: Decimal;
        Montantint: Decimal;
        Mnttot: Decimal;
        Ltype: Record "WDC Loan & Advance Type";
    begin
        Header.CALCFIELDS("Repaid amount", "Repaid %", "Principal Amount", "Interest Amount");
        IF Header."Repaid amount" >= Header."Total to repay" THEN
            ERROR(Text001);
        IF Header.Status.AsInteger() = 1 THEN
            ERROR(Text003, Header.Status);
        ResSetup.GET;
        DateF := CALCDATE(STRSUBSTNO('<-%1J+CM>', ResSetup."Apply Loan After"), Datecompta);
        Montantint := Header.CalcMntInetretEng1(Header."Effective date", DateF) - Header."Interest Amount";
        IF (Header.Amount - Header."Principal Amount") >= (Mntreg - Montantint) THEN
            MontantPrin := (Mntreg - Montantint)
        ELSE
            MontantPrin := (Header.Amount - Header."Principal Amount");
        CLEAR(Ltype);
        Ltype.GET(Header."Document type");
        IF CONFIRM('Voulez-vous solder ce document ?\' +
                    'N° document : %1 au bénéfice de %2\' +
                    'Type : %3 - %4\' +
                    'Reste à rembourser : %5', FALSE, Header."No.", Header."Employee No." + ' ' + Header.Name,
                    Header.Type, Header."Document type", ROUND(MontantPrin + Montantint, 0.001))
          THEN BEGIN
            Lines.SETRANGE("No.", Header."No.");
            Lines.SETRANGE(Type, Header.Type);
            Lines.SETRANGE("Document type", Header."Document type");
            IF Lines.FINDLAST() THEN
                ln := Lines."Entry No." + 10000
            ELSE
                ln := 10000;
            Mnttot := (MontantPrin + Montantint);
            IF Ltype."Accounting Posting".AsInteger() = 0 THEN
                IF NOT CreateTreasuryEntries(Header, Datecompta, TypeCpt, NumCpt, NumDoc, Mnttot) THEN
                    ERROR(Text004);
            Lines.INIT;
            Lines."No." := Header."No.";
            Lines."Entry No." := ln;
            Lines."Employee No." := Header."Employee No.";
            Lines."Employee Posting Group" := Header."Employee Posting Group";
            Lines."Employee Statistic Group" := Header."Employee Statistic Group";
            Lines."Global dimension 1" := Header."Global dimension 1";
            Lines."Global dimension 2" := Header."Global dimension 2";
            Lines.Management := Header.Management;
            Lines.service := Header.service;
            Lines.section := Header.section;
            Lines.Type := Header.Type;
            Lines."Document type" := Header."Document type";
            Lines."Line Amount" := MontantPrin + Montantint;
            Lines."Line %" := ROUND(MontantPrin / Header.Amount, 0.0001) * 100;
            Lines.Status := Lines.Status::"In progress";
            Lines."Payment No." := 'SLD MANUEL';
            Lines.Paid := TRUE;
            Lines."Payroll Date" := DateP;
            Lines.Month := Enum::"WDC Payroll Month".FromInteger(DATE2DMY(DateP, 2) - 1);
            Lines.Year := DATE2DMY(DateP, 3);
            Lines."Principal Amount" := MontantPrin;
            Lines."Interest Amount" := Montantint;
            Lines."Account Type" := TypeCpt;
            Lines."Account No." := NumCpt;
            Lines."External Document No." := NumDoc;
            Lines."Meal Advance" := Header."Meal Advance";
            Lines.INSERT;
            CreateEntryLigne(Lines);
        END;
    end;


    procedure CreateTreasuryEntries(var Header: Record "WDC Loan & Advance Header"; Datecompta: Date; TypeCpt: Enum "Gen. Journal Account Type"; NumCpt: Code[20]; NumDoc: Code[20]; Mnt: Decimal): Boolean
    var
        HumResSetup: Record "Human Resources Setup";
        LAType: Record "WDC Loan & Advance Type";
        GenJournalLine: Record 81;
        GenJournalBatch: Record 232;
        GenJnlPostLine: Codeunit 12;
        errConfig: TextConst ENU = 'General Journal Template empty in Human Resource Parameter.', FRA = 'Modèle de journal général vide dans les paramètres de ressources humaines.';
        errLATypeMissing: TextConst ENU = 'Loan & Advance Type missing.', FRA = 'Type de prêt & avance manquant.';
        errWrongParam: TextConst ENU = 'Account No. or Bal. Account No. empty in Loan & Advance type parameter.', FRA = 'Compte ou compte auxiliaire vide dans le paramètre de type de prêt & avance.';


        lText001: TextConst ENU = ' Please check the amount !!!',
                            FRA = 'Veuillez vérifier le montant !!!';
        Line: Integer;
        BankAccount: Record 270;

    begin
        HumResSetup.GET();
        IF NOT LAType.GET(Header."Document type")
          THEN
            ERROR(errLATypeMissing);
        IF Mnt = 0 THEN
            ERROR(lText001);
        IF LAType."Accounting Posting".AsInteger() = 1 THEN
            EXIT(TRUE);

        IF ((LAType."Account No." = '')
            OR
            (LAType."Bal. Account No." = ''))
          THEN
            ERROR(errWrongParam);
        BEGIN
            IF (HumResSetup."General Journal Template" = '')
              THEN
                ERROR(errConfig);
            GenJournalLine.SETRANGE("Journal Template Name", HumResSetup."General Journal Template");
            GenJournalLine.SETRANGE("Journal Batch Name", HumResSetup."Gen. Journal Batch (L&A)");
            GenJournalLine.SETRANGE("Document No.", Header."No.");
            GenJournalLine.DELETEALL;
            GenJournalLine.RESET;
            GenJournalLine.SETRANGE("Journal Template Name", HumResSetup."General Journal Template");
            GenJournalLine.SETRANGE("Journal Batch Name", HumResSetup."Gen. Journal Batch (L&A)");

            IF GenJournalLine.FINDLAST() THEN
                Line := GenJournalLine."Line No." + 10000
            ELSE
                Line := 10000;

            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name" := HumResSetup."General Journal Template";
            GenJournalLine."Journal Batch Name" := HumResSetup."Gen. Journal Batch (L&A)";


            GenJournalLine.VALIDATE("Line No.", Line);
            GenJournalLine.VALIDATE("Posting Date", Datecompta);

            CASE LAType."Account Type".AsInteger() OF
                0:
                    GenJournalLine.VALIDATE("Account Type", 0);
                1:
                    BEGIN
                        GenJournalLine.VALIDATE("Account Type", 3);
                        IF BankAccount.GET(LAType."Account No.") THEN
                            GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                    END;
            END;
            GenJournalLine.VALIDATE("Account No.", LAType."Account No.");
            GenJournalLine.VALIDATE("Posting Date", Datecompta);
            GenJournalLine."Source Code" := LAType."Source Code";
            GenJournalLine.VALIDATE("Document Type", 0);
            GenJournalLine.VALIDATE("Document No.", Header."No.");
            GenJournalLine."External Document No." := NumDoc;
            GenJournalLine.VALIDATE("Bal. Account Type", TypeCpt);
            GenJournalLine.VALIDATE("Bal. Account No.", NumCpt);
            GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee;
            GenJournalLine."Source No." := Header."Employee No.";

            GenJournalLine.VALIDATE("Credit Amount", Mnt);

            CODEUNIT.RUN(12, GenJournalLine);
            EXIT(TRUE);
        END;
    end;


    procedure InsererLigne(var SalaryLine: Record "WDC Salary Lines"; LoanAdvanceHeader: Record "WDC Loan & Advance Header"; MntPrinc: Decimal; MntInt: Decimal)
    var
        LoanAdvanceLines: Record "WDC Loan & Advance Lines";
        LALines: Record "WDC Loan & Advance Lines";
        ExistLoanAdvanceLine: Record "WDC Loan & Advance Lines";
        ln: Integer;
        Employee: Record Employee;
    begin
        LoanAdvanceLines.RESET;
        LoanAdvanceLines.SETRANGE("No.", LoanAdvanceHeader."No.");
        IF LoanAdvanceLines.FINDLAST() THEN
            ln := LoanAdvanceLines."Entry No." + 10000
        ELSE
            ln := 10000;

        LoanAdvanceLines.RESET;
        LoanAdvanceLines.SETCURRENTKEY("Payment No.", Paid, "Employee No.");
        LoanAdvanceLines.SETFILTER("No.", LoanAdvanceHeader."No.");
        LoanAdvanceLines.SETRANGE(Paid, FALSE);
        LoanAdvanceLines.SETFILTER("Employee No.", SalaryLine."Employee No.");
        LoanAdvanceLines.DELETEALL;
        Employee.GET(SalaryLine."Employee No.");

        LoanAdvanceLines.RESET;
        LoanAdvanceLines.INIT;
        LoanAdvanceLines."No." := LoanAdvanceHeader."No.";
        LoanAdvanceLines."Entry No." := ln;
        LoanAdvanceLines."Employee No." := LoanAdvanceHeader."Employee No.";
        LoanAdvanceLines."Employee Posting Group" := Employee."Empl. Posting Group";
        LoanAdvanceLines."Employee Statistic Group" := Employee."Statistics Group Code";
        LoanAdvanceLines."Global dimension 1" := Employee."Global Dimension 1 Code";
        LoanAdvanceLines."Global dimension 2" := Employee."Global Dimension 2 Code";
        LoanAdvanceLines.Management := Employee.Management;
        LoanAdvanceLines.service := Employee.Service;
        LoanAdvanceLines.section := Employee.Section;

        LoanAdvanceLines.Type := LoanAdvanceHeader.Type;
        LoanAdvanceLines."Document type" := LoanAdvanceHeader."Document type";
        LoanAdvanceLines.Month := SalaryLine.Month;
        LoanAdvanceLines.Year := SalaryLine.Year;

        LoanAdvanceLines."Line Amount" := MntPrinc + MntInt;
        LoanAdvanceLines."Principal Amount" := MntPrinc;
        LoanAdvanceLines."Interest Amount" := MntInt;
        LoanAdvanceLines."Line %" := (LoanAdvanceLines."Line Amount" * 100) / LoanAdvanceHeader.
"Total to repay";

        LoanAdvanceLines.Status := LoanAdvanceLines.Status::"In progress";
        LoanAdvanceLines.Paid := FALSE;
        //---Si on ve pas retrancher le mointant pour ce mois aors on doit Modifier le champ en espèce
        IF LoanAdvanceHeader."Type Tranche" = LoanAdvanceHeader."Type Tranche"::Salary THEN BEGIN
            LoanAdvanceLines."Payment No." := SalaryLine."No.";
            LoanAdvanceLines."Type Tranche" := LoanAdvanceLines."Type Tranche"::Salary;
        END ELSE BEGIN
            LoanAdvanceLines."Payment No." := 'ESPECE';
            LoanAdvanceLines."Type Tranche" := LoanAdvanceLines."Type Tranche"::Cash;
            //MESSAGE(MsgAtten, LoanAdvanceHeader."Employee No.", LoanAdvanceHeader."Document type", LoanAdvanceHeader."No.", LoanAdvanceHeader."Type Tranche");
        END;
        LoanAdvanceLines."Payroll Date" := SalaryLine."Posting Date";
        LoanAdvanceLines."Meal Advance" := LoanAdvanceHeader."Meal Advance";
        IF LoanAdvanceLines.INSERT THEN;
    end;



    procedure CalcSolde(Header: Record "WDC Loan & Advance Header"; var SalaryLineTmp: Record "WDC Salary Lines") Verif: Boolean
    var
        Lines: Record "WDC Loan & Advance Lines";
        Mnt: Decimal;
    begin
        Verif := TRUE;
        Mnt := 0;
        Lines.RESET;
        Lines.SETCURRENTKEY("No.", "Employee No.", Paid);
        Lines.SETFILTER("No.", Header."No.");
        Lines.SETFILTER("Employee No.", Header."Employee No.");
        Lines.SETRANGE(Paid, TRUE);
        Lines.CALCSUMS("Principal Amount", "Line Amount");
        Mnt := Lines."Principal Amount";
        IF ROUND(Header.Amount - Mnt, 0.1) = 0 THEN
            Verif := FALSE
        ELSE BEGIN
            Lines.SETRANGE(Year, SalaryLineTmp.Year);
            Lines.SETRANGE(Month, SalaryLineTmp.Month);
            Lines.SETFILTER("Payment No.", '<>SLD MANUEL');
            Lines.SETFILTER("Line Amount", '<>0');
        END;

    end;


    procedure CreateEntryLigne(LoanAdvanceLine: Record "WDC Loan & Advance Lines")
    var
        LoanAdvanceEntry: Record "WDC Loan & Advance entry";
        nbr: Integer;
        LoanAdvanceHeader: Record "WDC Loan & Advance Header";
    begin
        LoanAdvanceEntry.SETRANGE("No.", LoanAdvanceLine."No.");
        LoanAdvanceEntry.ASCENDING(TRUE);
        IF LoanAdvanceEntry.FINDLAST() THEN
            nbr := LoanAdvanceEntry."Entry No." + 1
        ELSE
            nbr := 1;

        LoanAdvanceEntry.INIT;
        LoanAdvanceEntry."No." := LoanAdvanceLine."No.";
        LoanAdvanceEntry."Entry No." := nbr;
        LoanAdvanceEntry."Employee No." := LoanAdvanceLine."Employee No.";
        IF LoanAdvanceHeader.GET(LoanAdvanceLine."No.") THEN
            LoanAdvanceEntry.Name := LoanAdvanceHeader.Name;
        LoanAdvanceEntry."Employee Posting Group" := LoanAdvanceLine."Employee Posting Group";
        LoanAdvanceEntry."Employee Statistic Group" := LoanAdvanceLine."Employee Statistic Group";
        LoanAdvanceEntry."Global dimension 1" := LoanAdvanceLine."Global dimension 1";
        LoanAdvanceEntry."Global dimension 2" := LoanAdvanceLine."Global dimension 2";
        LoanAdvanceEntry.Management := LoanAdvanceLine.Management;
        LoanAdvanceEntry.service := LoanAdvanceLine.service;
        LoanAdvanceEntry.section := LoanAdvanceLine.section;

        LoanAdvanceEntry.Month := LoanAdvanceLine.Month;
        LoanAdvanceEntry.Year := LoanAdvanceLine.Year;
        LoanAdvanceEntry."Payroll Date" := LoanAdvanceLine."Payroll Date";
        LoanAdvanceEntry."Payment No." := LoanAdvanceLine."Payment No.";
        LoanAdvanceEntry.Type := LoanAdvanceLine.Type;
        LoanAdvanceEntry."Document type" := LoanAdvanceLine."Document type";
        LoanAdvanceEntry."Entry type" := LoanAdvanceEntry."Entry type"::Repayment;
        LoanAdvanceEntry.Amount := -LoanAdvanceLine."Line Amount";
        LoanAdvanceEntry.Status := LoanAdvanceLine.Status;
        LoanAdvanceEntry."Meal Advance" := LoanAdvanceLine."Meal Advance";

        LoanAdvanceEntry.INSERT;

        IF LoanAdvanceHeader.GET(LoanAdvanceLine."No.") THEN
            CloturerDocument(LoanAdvanceHeader);
    end;


    procedure AnEcrComptaPaiement(LoanAdvanceeng: Record "WDC Loan & Advance Header")
    var
        HumResSetup: Record "Human Resources Setup";
        errConfig: TextConst ENU = 'General Journal Template empty in Human Resource Parameter.', FRA = 'Modèle de journal général vide dans les paramètres de ressources humaines.';
        LAType: Record "WDC Loan & Advance Type";
        errLATypeMissing: TextConst ENU = 'Loan & Advance Type missing.', FRA = 'Type de prêt & avance manquant.';
        errWrongParam: TextConst ENU = 'Account No. or Bal. Account No. empty in Loan & Advance type parameter.', FRA = 'Compte ou compte auxiliaire vide dans le paramètre de type de prêt & avance.';
        GenJournalLine: Record 81;
        GenJournalBatch: Record 232;
        GenJnlPostLine: Codeunit 12;
        Line: Integer;
        BankAccount: Record 270;
        CourtT: Decimal;
        LongT: Decimal;
        LoanAdvance: Record "WDC Loan & Advance";
    begin
        HumResSetup.GET();

        IF NOT LAType.GET(LoanAdvanceeng."Document type")
          THEN
            ERROR(errLATypeMissing);

        IF ((LAType."Account No." = '')
            OR
            (LAType."Bal. Account No." = ''))
          THEN
            ERROR(errWrongParam);

        IF (HumResSetup."General Journal Template" = '') THEN
            ERROR(errConfig);

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", HumResSetup."General Journal Template");
        GenJournalLine.SETRANGE("Journal Batch Name", HumResSetup."Gen. Journal Batch (L&A)");
        GenJournalLine.SETRANGE("Document No.", LoanAdvanceeng."No.");
        GenJournalLine.DELETEALL;
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", HumResSetup."General Journal Template");
        GenJournalLine.SETRANGE("Journal Batch Name", HumResSetup."Gen. Journal Batch (L&A)");

        IF GenJournalLine.FINDLAST() THEN
            Line := GenJournalLine."Line No." + 10000
        ELSE
            Line := 10000;

        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := HumResSetup."General Journal Template";
        GenJournalLine."Journal Batch Name" := HumResSetup."Gen. Journal Batch (L&A)";

        GenJournalLine.VALIDATE("Line No.", Line);
        GenJournalLine.VALIDATE("Posting Date", LoanAdvanceeng."Posting Date");

        CASE LAType."Account Type".AsInteger() OF
            0:
                GenJournalLine.VALIDATE("Account Type", 0);
            1:
                BEGIN
                    GenJournalLine.VALIDATE("Account Type", 3);
                    IF BankAccount.GET(LAType."Bal. Account No.") THEN
                        GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                END;
        END;
        GenJournalLine.VALIDATE("Account No.", LAType."Account No.");
        GenJournalLine.VALIDATE("Posting Date", LoanAdvanceeng."Posting Date");
        GenJournalLine."Source Code" := LAType."Source Code";
        GenJournalLine.VALIDATE("Document Type", 0);
        GenJournalLine.VALIDATE("Document No.", LoanAdvanceeng."No.");
        CASE LAType."Bal. Account Type".AsInteger() OF
            0:
                BEGIN
                    GenJournalLine.VALIDATE("Bal. Account Type", 0);
                    GenJournalLine.VALIDATE("Currency Code", '');
                END;
            1:
                BEGIN
                    GenJournalLine.VALIDATE("Bal. Account Type", 3);
                    IF BankAccount.GET(LAType."Bal. Account No.") THEN
                        GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                END;
        END;
        GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee;
        GenJournalLine."Source No." := LoanAdvanceeng."Employee No.";
        GenJournalLine."External Document No." := LoanAdvanceeng."External Document No.";
        IF LoanAdvanceeng.Type.AsInteger() = 0 THEN BEGIN
            GenJournalLine.VALIDATE("Bal. Account No.", LoanAdvanceeng."Bal. Account No.");
            GenJournalLine.VALIDATE("Credit Amount", LoanAdvanceeng.Amount);  // Credit
            GenJournalLine.Description := 'Annulation Avance ' + LoanAdvanceeng."No.";
            GenJournalLine.INSERT;
        END ELSE BEGIN
            //LoanAdvanceeng.CalcPrêtLongetCourtTerme(CourtT,LongT);
            CourtT := LoanAdvanceeng.Amount;
            LongT := LoanAdvanceeng."Total to repay" - LoanAdvanceeng.Amount;
            GenJournalLine.VALIDATE("Posting Date", LoanAdvanceeng."Posting Date");
            IF CourtT <> 0 THEN BEGIN
                CASE LAType."Account Type".AsInteger() OF
                    0:
                        BEGIN
                            GenJournalLine.VALIDATE("Account Type", 0);
                            GenJournalLine.VALIDATE("Account No.", LAType."Account No.");
                            GenJournalLine.VALIDATE("Currency Code", '');
                        END;
                    1:
                        BEGIN
                            GenJournalLine.VALIDATE("Account Type", 3);
                            GenJournalLine.VALIDATE("Account No.", LAType."Account No.");
                            IF BankAccount.GET(LAType."Account No.") THEN
                                GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                        END;
                END;
                GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee;
                GenJournalLine."Source No." := LoanAdvanceeng."Employee No.";
                GenJournalLine.VALIDATE("Credit Amount", CourtT);  // Credit
                GenJournalLine.Description := 'Annulation Avance ' + LoanAdvanceeng."No.";
                GenJournalLine.INSERT;
            END;
            //
            IF LongT <> 0 THEN BEGIN
                Line := Line + 10000;
                GenJournalLine."Line No." := Line;
                GenJournalLine.VALIDATE("Posting Date", LoanAdvanceeng."Posting Date");

                CASE LAType."Long Term Account Type".AsInteger() OF
                    0:
                        BEGIN
                            GenJournalLine.VALIDATE("Account Type", 0);
                            GenJournalLine.VALIDATE("Account No.", LAType."Long Term Account No.");
                            GenJournalLine.VALIDATE("Currency Code", '');
                        END;
                    1:
                        BEGIN
                            GenJournalLine.VALIDATE("Account Type", 3);
                            GenJournalLine.VALIDATE("Account No.", LAType."Long Term Account No.");

                            IF BankAccount.GET(LAType."Long Term Account No.") THEN
                                GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                        END;
                END;
                GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee;
                GenJournalLine."External Document No." := LoanAdvanceeng."External Document No.";

                GenJournalLine."Source No." := LoanAdvanceeng."Employee No.";
                GenJournalLine.VALIDATE("Debit Amount", LongT);  // debit
                GenJournalLine.Description := 'Annulation Avance ' + LoanAdvanceeng."No.";
                GenJournalLine.INSERT;
            END;
            //
            Line := Line + 10000;
            GenJournalLine."Line No." := Line;
            CASE LoanAdvanceeng."Bal. Account Type".AsInteger() OF
                0:
                    BEGIN
                        GenJournalLine.VALIDATE("Bal. Account Type", 0);
                        GenJournalLine.VALIDATE("Account No.", LoanAdvanceeng."Bal. Account No.");
                        GenJournalLine.VALIDATE("Currency Code", '');
                    END;
                1:
                    BEGIN
                        GenJournalLine.VALIDATE("Account Type", 3);
                        GenJournalLine.VALIDATE("Account No.", LoanAdvanceeng."Bal. Account No.");

                        IF BankAccount.GET(LoanAdvanceeng."Bal. Account No.") THEN
                            GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                    END;
            END;
            GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee;
            GenJournalLine."Source No." := LoanAdvanceeng."Employee No.";
            GenJournalLine."External Document No." := LoanAdvanceeng."External Document No.";
            GenJournalLine.VALIDATE("Debit Amount", LoanAdvanceeng.Amount);
            GenJournalLine.Description := 'Annulation Avance ' + LoanAdvanceeng."No.";

            GenJournalLine.INSERT;
            IF LongT <> 0 THEN BEGIN
                Line := Line + 10000;
                GenJournalLine."Line No." := Line;
                GenJournalLine.VALIDATE("Posting Date", LoanAdvanceeng."Posting Date");

                CASE LAType."Account Type".AsInteger() OF
                    0:
                        BEGIN
                            GenJournalLine.VALIDATE("Account Type", 0);
                            GenJournalLine.VALIDATE("Account No.", LAType."Account No.");
                            GenJournalLine.VALIDATE("Currency Code", '');
                        END;
                    1:
                        BEGIN
                            GenJournalLine.VALIDATE("Account Type", 3);
                            GenJournalLine.VALIDATE("Account No.", LAType."Account No.");
                            IF BankAccount.GET(LAType."Account No.") THEN
                                GenJournalLine.VALIDATE("Currency Code", BankAccount."Currency Code");
                        END;
                END;
                GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee;
                GenJournalLine."Source No." := LoanAdvanceeng."Employee No.";
                GenJournalLine."External Document No." := LoanAdvanceeng."External Document No.";
                GenJournalLine.VALIDATE("Credit Amount", LongT);
                GenJournalLine.INSERT;
            END;

        END;

    end;


    procedure AnnEnregDocument(LoanAdvanceHeader: Record "WDC Loan & Advance Header")
    var
        LoanAdvanceEntry: Record "WDC Loan & Advance Lines";
        LoanAdvance: Record "WDC Loan & Advance";
        LAType: Record "WDC Loan & Advance Type";
        lText001: TextConst ENU = 'You cannot cancel an paied advance',
                            FRA = 'Vous ne pouvez pas annuler un avance payé !!!';
    begin
        LoanAdvanceHeader.CALCFIELDS("Principal Amount");
        IF LoanAdvanceHeader."Principal Amount" <> 0 THEN
            ERROR(lText001);
        LAType.GET(LoanAdvanceHeader."Document type");
        IF LAType."Accounting Posting".AsInteger() = 0 THEN
            AnEcrComptaPaiement(LoanAdvanceHeader);
        IF ((LoanAdvanceHeader."Repayment slices" <> 0)
            AND
            (LoanAdvanceHeader."Total to repay" <> 0)
           ) THEN BEGIN
            LoanAdvance.RESET;
            LoanAdvance.INIT;
            LoanAdvance.TRANSFERFIELDS(LoanAdvance);
            LoanAdvance."No." := LoanAdvanceHeader."No.";
            LoanAdvance."Employee No." := LoanAdvanceHeader."Employee No.";
            LoanAdvance.Month := LoanAdvanceHeader.Month;
            LoanAdvance.Year := LoanAdvanceHeader.Year;
            LoanAdvance.Name := LoanAdvanceHeader.Name;
            LoanAdvance."Job Title" := LoanAdvanceHeader."Job Title";
            LoanAdvance."Employee Posting Group" := LoanAdvanceHeader."Employee Posting Group";
            LoanAdvance."Employee Statistic Group" := LoanAdvanceHeader."Employee Statistic Group";
            LoanAdvance."Global dimension 1" := LoanAdvanceHeader."Global dimension 1";
            LoanAdvance."Global dimension 2" := LoanAdvanceHeader."Global dimension 2";
            LoanAdvance.Management := LoanAdvanceHeader.Management;
            LoanAdvance.service := LoanAdvanceHeader.service;
            LoanAdvance.section := LoanAdvanceHeader.section;
            LoanAdvance.Type := LoanAdvanceHeader.Type;
            LoanAdvance."Document type" := LoanAdvanceHeader."Document type";
            LoanAdvance."Type Tranche" := LoanAdvanceHeader."Type Tranche";
            LoanAdvance.Amount := LoanAdvanceHeader.Amount;
            LoanAdvance."Bal. Account Type" := LoanAdvanceHeader."Bal. Account Type";
            LoanAdvance."Bal. Account No." := LoanAdvanceHeader."Bal. Account No.";
            LoanAdvance."Total to repay" := LoanAdvanceHeader."Total to repay";
            LoanAdvance."External Document No." := LoanAdvanceHeader."External Document No.";
            LoanAdvance."Slice Amount" := LoanAdvanceHeader."Slice Amount";
            LoanAdvance."Effective date" := LoanAdvanceHeader."Effective date";
            LoanAdvance."Posting Date" := LoanAdvanceHeader."Posting Date";
            LoanAdvance."End date Loan" := LoanAdvanceHeader."End date Loan";
            LoanAdvance."Advance on Bonus" := LoanAdvanceHeader."Avance Sur Prime";
            LoanAdvance."Advance on Holiday" := LoanAdvanceHeader."Advance on Holiday";
            LoanAdvance."Repayment slices" := LoanAdvanceHeader."Repayment slices";
            LoanAdvance."No. Series" := LoanAdvanceHeader."No. Series";
            LoanAdvance."Precision Arrondi Principale" := LoanAdvanceHeader."Precision Arrondi Principale";
            LoanAdvance."Allocation Difference Rounding" := LoanAdvanceHeader."Allocation Difference Rounding";
            LoanAdvance."Meal Advance" := LoanAdvanceHeader."Meal Advance";

            IF LoanAdvance.INSERT THEN BEGIN
                LoanAdvanceEntry.RESET;
                LoanAdvanceEntry.SETCURRENTKEY("No.", "Employee No.", "Entry No.");
                LoanAdvanceEntry.SETFILTER("No.", LoanAdvanceHeader."No.");
                LoanAdvanceEntry.SETFILTER("Employee No.", LoanAdvanceHeader."Employee No.");
                LoanAdvanceEntry.DELETEALL;

                IF LoanAdvanceHeader.DELETE THEN
                    MESSAGE(Text002);
                ;
            END
            ELSE
                ERROR(errValidate);
        END
    end;



}

