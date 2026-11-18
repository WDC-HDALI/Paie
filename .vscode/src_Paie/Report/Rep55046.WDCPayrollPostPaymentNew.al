report 55046 "WDC Payroll Post Payment New"
{
    captionML = ENU = 'Valider paie', FRA = 'Post Paiement';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Rec. Salary Headers"; "WDC Posted Salary Header")
        {
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Payment to post';

            trigger OnAfterGetRecord()
            begin
                Window.OPEN('############################################1####\' +
                             'North Africa Payroll V2.00                       \' +
                             FORMAT(WORKDATE) + ' - ' + COMPANYNAME);
                Window.UPDATE(1, win1);
                SalaireBrutSIVP := 0;
                SalaireBrutSansSIVP := 0;
                IndemnNonCot := 0;
                ChargeSoc := 0;
                CNSS := 0;
                Assurance := 0;
                AGAStar := 0;
                IRPP := 0;
                CSS := 0;
                RetraiteP := 0;
                NetSalary := 0;
                CLEAR(Ass5);
                CLEAR(Ass9);
                CLEAR(Ass09);
                CLEAR(Ass8);
                CLEAR(Ass12);
                CLEAR(CumAss);
                CLEAR(AGAss);
                CLEAR(RetCar);
                //
                CLEAR(PretCNSS);
                CLEAR(RecLoan);
                RecLoan.SETRANGE("Payment No.", "Rec. Salary Headers"."No.");
                RecLoan.SETRANGE(Type, RecLoan.Type::Loan);
                RecLoan.SETRANGE("Document type", 'PRETCNSS');
                IF RecLoan.FINDSET THEN
                    REPEAT
                        PretCNSS += RecLoan."Line Amount";
                    UNTIL RecLoan.NEXT = 0;
                //
                SalaryLine.RESET;
                SalaryLine.SETRANGE("No.", "Rec. Salary Headers"."No.");
                IF SalaryLine.FINDSET THEN
                    REPEAT
                        IF SalaryLine."Non Taxable Soc. Contrib." = 0 THEN
                            SalaireBrutSIVP += SalaryLine."Gross Salary"
                        ELSE
                            SalaireBrutSansSIVP += SalaryLine."Gross Salary";
                        IndemnNonCot += SalaryLine."Taxable indemnities(Not Gross)";
                        CNSS += SalaryLine."Non Taxable Soc. Contrib.";
                        Assurance += SalaryLine.Assurance;
                        IRPP += SalaryLine."Taxe (Month)";
                        CSS += SalaryLine."CSS Tax";
                        Avance += (SalaryLine.Advances + SalaryLine.Shems + SalaryLine.Bus + SalaryLine.Phone + SalaryLine.DSAM);
                        Pret += SalaryLine.Loans;
                        RetraiteP += SalaryLine."Retirement plus";
                        RetCar += SalaryLine.Car;
                        NetSalary += SalaryLine."Net salary cashed"
                   UNTIL SalaryLine.NEXT = 0;
                Pret := Pret - PretCNSS;
                Avance := Avance + PretCNSS;
                //Calcul AGA Assurance
                Ass5 := (Assurance / 4) * 5.5;
                Ass9 := (Ass5 / 5.5) * 9.5;
                Ass09 := (Ass9 / 9.5) * 0.9;
                Ass8 := (Ass09 / 0.9) * 8.6;
                Ass12 := (Ass8 * 12) / 100;
                CumAss := Ass8 + Ass12 + Ass09;
                AGAss := CumAss - Assurance;
                //Ligne de Salaire Brut sans SIVP
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '64110');
                GenJournalLine.Description := 'Salaires-Appointements de fabrication';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Debit Amount", ROUND(SalaireBrutSansSIVP, 0.001));
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //Ligne de Salaire Brut SIVP
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '64110');
                GenJournalLine.Description := 'Salaires-Appointements de fabrication (SIVP)';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Debit Amount", ROUND(SalaireBrutSIVP, 0.001));
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //Ligne Indemnité Imposable non cotisable
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '64110');
                GenJournalLine.Description := 'Prov. pour grat./primes';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Debit Amount", ROUND(IndemnNonCot, 0.001));
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //Charge sociale 17,37%
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '64710');
                GenJournalLine.Description := 'Charges Soc.Légal-Cotis.Patr. 17,87%';//WDC01 17,37
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Debit Amount", ROUND(SalaireBrutSansSIVP * 0.1787, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //AGA Star  Debit
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '64910');
                GenJournalLine.Description := 'AGA STAR 6,36 %';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Debit Amount", ROUND(AGAss, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //CNSS
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '45310');
                GenJournalLine.Description := 'Charges Soc. 9,18 % ';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Credit Amount", ROUND(CNSS, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //IRPP
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '43220');
                GenJournalLine.Description := 'IRPP';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Credit Amount", ROUND(IRPP, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //CSS
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '43222');
                GenJournalLine.Description := 'CSS';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Credit Amount", ROUND(CSS, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //Avance
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '42100');
                GenJournalLine.Description := 'Avance sur salaire';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Credit Amount", ROUND(Avance, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //Retenue Car
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '79000');
                GenJournalLine.Description := 'Retenue Car';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Credit Amount", ROUND(RetCar, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //Assurance
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '45320');
                GenJournalLine.Description := 'Assurance du personnel 4 % ';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Credit Amount", ROUND(Assurance, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;

                //Retaite Plus
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '45330');
                GenJournalLine.Description := 'Assurance Retraite +';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Credit Amount", ROUND(RetraiteP, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //Pret
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '42110');
                GenJournalLine.Description := 'Prêt';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Credit Amount", ROUND(Pret, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //Salaire net
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '42510');
                GenJournalLine.Description := 'Obligations d´appointements';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Credit Amount", ROUND(NetSalary, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //CNSS 17,37%
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '45310');
                GenJournalLine.Description := 'CNSS AG-Anteil';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Credit Amount", ROUND(SalaireBrutSansSIVP * 0.1787, 0.001));   //WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
                //AGA Star Credit
                Window.UPDATE(1, win2);
                GenJournalLine.RESET;
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                GenJournalLine.VALIDATE("Line No.", ln);
                GenJournalLine.VALIDATE("Document Type", 0);
                GenJournalLine.VALIDATE("Account Type", 0);
                GenJournalLine.VALIDATE("Account No.", '45320');
                GenJournalLine.Description := 'AGA STAR';
                GenJournalLine.VALIDATE("Posting Date", PostingDate);
                GenJournalLine.VALIDATE("Document No.", SalaryLine."No.");
                GenJournalLine.VALIDATE("Credit Amount", ROUND(AGAss, 0.001));//WDC01
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalaryLine."Global dimension 1");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", SalaryLine."Global dimension 2");
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                ;
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Source Code" := Model."Source Code";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                ln := ln + 10000;
            end;

            trigger OnPostDataItem()
            begin
                "Rec. Salary Headers"."Integrated in accounting" := TRUE;
                "Rec. Salary Headers".MODIFY;
            end;

            trigger OnPreDataItem()
            var
                lText001: TextConst ENU = 'Payroll already processed, please check your entry',
                                    FRA = 'Paie déja comptabilisée, vérifier votre saisie';
            begin
                IF SalaryHead.GET("Rec. Salary Headers".GETFILTER("No.")) THEN
                    IF SalaryHead."Integrated in accounting" THEN ERROR(lText001);
                HumanResourcesSetup.GET;
                CLEAR(GenJournalLine);
                GenJournalLine.SETRANGE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                GenJournalLine.SETRANGE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                IF GenJournalLine.FINDSET THEN
                    GenJournalLine.DELETEALL;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    CaptionML = ENU = 'Options', FRA = 'Options';
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
                    }
                    field(PostingMode; PostingMode)
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'Posting Mode', FRA = 'Mode validation';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        NbreLigne := 0;
        NbreLigneIndemnity := 0;
        NbrLigneHS := 0;
        NbreLigneIndemnity1 := 0;
        IntEntpret := 0;
        PostingDate := WORKDATE;
        HumanResourcesSetup.GET();

        CLEAR(Model);
        IF Model.GET(HumanResourcesSetup."General Journal Template") THEN;
        GenJournalLine.SETRANGE("Journal Template Name", HumanResourcesSetup."General Journal Template");
        GenJournalLine.SETRANGE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
        IF GenJournalLine.FINDLAST() THEN
            ln := GenJournalLine."Line No." + 10000
        ELSE
            ln := 10000;
        First := ln;
    end;

    trigger OnPostReport()
    Var
        lText001: TextConst ENU = 'Payroll processing successfully completed',
                            FRA = 'Comptabilisation de paie terminée avec succès';

    begin
        MESSAGE(lText001);
        Window.CLOSE;
    end;

    var
        Window: Dialog;
        PostingMode: Option "Par feuille de saisie",Directe;
        GenJournalLine: Record 81;
        HumanResourcesSetup: Record "Human Resources Setup";
        PostingDate: Date;
        ln: Integer;
        First: Integer;
        Model: Record 80;
        win1: TextConst ENU = 'Creating records.',
                        FRA = 'Création des enregistrements.';
        win2: TextConst ENU = 'Inserting Net salary cashed lines.',
                        FRA = 'Insertion des lignes salaire net encaissé.';
        NbreLigne: Integer;
        NbreLigneIndemnity: Integer;
        NbrLigneHS: Integer;
        NbreLigneIndemnity1: Integer;
        IntEntpret: Integer;
        SalaireBrutSIVP: Decimal;
        SalaireBrutSansSIVP: Decimal;
        SalaryLine: Record "WDC Salary Lines";
        IndemnNonCot: Decimal;
        ChargeSoc: Decimal;
        CNSS: Decimal;
        AGAStar: Decimal;
        Assurance: Decimal;
        IRPP: Decimal;
        CSS: Decimal;
        Avance: Decimal;
        Pret: Decimal;
        RetraiteP: Decimal;
        NetSalary: Decimal;
        Ass5: Decimal;
        Ass9: Decimal;
        Ass09: Decimal;
        Ass8: Decimal;
        Ass12: Decimal;
        CumAss: Decimal;
        AGAss: Decimal;
        SalaryHead: Record 55024;
        RetCar: Decimal;
        RecLoan: Record "WDC Loan & Advance Lines";
        PretCNSS: Decimal;
}

