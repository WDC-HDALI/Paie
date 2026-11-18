report 55003 "WDC Post Payment"
{
    Caption = 'Post Payment';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Rec. Salary Header"; "WDC Posted Salary Header")
        {
            DataItemTableView = WHERE("Integrated in accounting" = CONST(false));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Payment to post';
            dataitem("Rec. Salary Lines"; "WDC Posted Salary Lines")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Employee Posting Group", "Global dimension 1", "Global dimension 2")
                                    ORDER(Ascending);

                trigger OnAfterGetRecord()
                begin
                    MontantVirement += ROUND("Net salary cashed", 0.001);
                    SalaireBrut += ROUND("Real basis salary" + "Public Holiday Amount" + "Supp. hours", 0.001);
                    RetraitePlus += ROUND("Retirement plus", 0.001);
                    AddData();
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FIELDNO("Global dimension 2");
                    CLEAR(SalaireBrut);
                    CLEAR(RetraitePlus);
                end;
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    ORDER(Ascending)
                                    WHERE(Number = FILTER(1 ..));

                trigger OnAfterGetRecord()
                begin
                    RecGSalaryLine.RESET;
                    RecGSalaryLine.SETRANGE(Number, Number);
                    IF RecGSalaryLine.FINDSET THEN BEGIN
                        EmployeePostingGrp.GET(RecGSalaryLine."Employee Posting Group");
                        //Ligne de Salaire Net
                        Window.UPDATE(1, win2);
                        GenJournalLine.RESET;
                        GenJournalLine.INIT;
                        GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                        GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                        GenJournalLine.VALIDATE("Line No.", ln);
                        GenJournalLine.VALIDATE("Document Type", 0);
                        GenJournalLine.VALIDATE("Account Type", 0);
                        GenJournalLine.VALIDATE("Account No.", EmployeePostingGrp."Net Salary Account No.");
                        GenJournalLine.VALIDATE("Posting Date", PostingDate);
                        GenJournalLine.VALIDATE("Document No.", RecGSalaryLine."No.");
                        GenJournalLine.VALIDATE("Credit Amount", ROUND(RecGSalaryLine."Net salary cashed", 0.001));
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", RecGSalaryLine."Global dimension 1");
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", RecGSalaryLine."Global dimension 2");
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

                        Window.UPDATE(1, win3);
                        GenJournalLine.RESET;
                        GenJournalLine.INIT;
                        GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                        GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                        GenJournalLine.VALIDATE("Line No.", ln);

                        GenJournalLine.VALIDATE("Account Type", 0);
                        GenJournalLine.VALIDATE("Account No.", EmployeePostingGrp."Basis Salary Account No.");
                        GenJournalLine.Description := GenJournalLine.Description;
                        GenJournalLine.VALIDATE("Posting Date", PostingDate);
                        GenJournalLine.VALIDATE("Document Type", 0);
                        GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");
                        GenJournalLine.VALIDATE("Debit Amount", ROUND(SalaireBrut, 0.001)); //WDC0611 AJOUT "Public Holiday Amount" +ROUND(RecGSalaryLine."Public Holiday Amount",0.001)

                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", RecGSalaryLine."Global dimension 1");
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", RecGSalaryLine."Global dimension 2");
                        GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                        GenJournalLine."Gen. Bus. Posting Group" := '';
                        GenJournalLine."Gen. Prod. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                        GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                        GenJournalLine."VAT Bus. Posting Group" := '';
                        GenJournalLine."VAT Prod. Posting Group" := '';
                        GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                        GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                        GenJournalLine."Source Code" := Model."Source Code";
                        IF GenJournalLine."Account No." = '' THEN
                            ERROR(Text001, EmployeePostingGrp.FIELDCAPTION("Basis Salary Account No."),
                                RecGSalaryLine."Employee Posting Group");

                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        ln := ln + 10000;
                        //>>Retraite plus
                        IF RetraitePlus <> 0 THEN BEGIN
                            GenJournalLine.RESET;
                            GenJournalLine.INIT;
                            GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                            GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                            GenJournalLine.VALIDATE("Line No.", ln);

                            GenJournalLine.VALIDATE("Account Type", 0);
                            GenJournalLine.VALIDATE("Account No.", '45330');
                            GenJournalLine.Description := 'Retraite plus';
                            GenJournalLine.VALIDATE("Posting Date", PostingDate);
                            GenJournalLine.VALIDATE("Document Type", 0);
                            GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");
                            GenJournalLine.VALIDATE("Credit Amount", ROUND(RetraitePlus, 0.001)); //WDC0611 AJOUT "Public Holiday Amount" +ROUND(RecGSalaryLine."Public Holiday Amount",0.001)
                            GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", RecGSalaryLine."Global dimension 1");
                            GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", RecGSalaryLine."Global dimension 2");
                            GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                            GenJournalLine."Gen. Bus. Posting Group" := '';
                            GenJournalLine."Gen. Prod. Posting Group" := '';
                            GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                            GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                            GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                            GenJournalLine."VAT Bus. Posting Group" := '';
                            GenJournalLine."VAT Prod. Posting Group" := '';
                            GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                            GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                            GenJournalLine."Source Code" := Model."Source Code";
                            IF GenJournalLine.Amount <> 0 THEN
                                GenJournalLine.INSERT;
                            ln := ln + 10000;
                        END;
                        //<<Retraite Plus
                        // Ligne de totalisation du Impôt
                        GenJournalLine.RESET;
                        GenJournalLine.INIT;
                        Window.UPDATE(1, win4);
                        GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                        GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                        GenJournalLine.VALIDATE("Line No.", ln);
                        GenJournalLine.VALIDATE("Account Type", 0);
                        GenJournalLine.VALIDATE("Account No.", EmployeePostingGrp."Taxes Account No.");
                        GenJournalLine.Description := GenJournalLine.Description;
                        GenJournalLine.VALIDATE("Posting Date", PostingDate);

                        GenJournalLine.VALIDATE("Document Type", 0);
                        GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");

                        GenJournalLine.VALIDATE("Credit Amount", ROUND(RecGSalaryLine."Taxe (Month)", 0.001));
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", RecGSalaryLine."Global dimension 1");
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", RecGSalaryLine."Global dimension 2");
                        GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                        GenJournalLine."Gen. Bus. Posting Group" := '';
                        GenJournalLine."Gen. Prod. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                        GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                        GenJournalLine."VAT Bus. Posting Group" := '';
                        GenJournalLine."VAT Prod. Posting Group" := '';
                        GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                        GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                        IF GenJournalLine."Account No." = '' THEN
                            ERROR(Text001, EmployeePostingGrp.FIELDCAPTION("Taxes Account No."),
                                RecGSalaryLine."Employee Posting Group");

                        GenJournalLine."Source Code" := Model."Source Code";
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        ln := ln + 10000;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, NbreLigne);
                end;
            }
            dataitem("<Rec. Indemnities Imp>"; "WDC Rec. Indemnities")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Employee Posting Group", "Global dimension 1", "Global dimension 2", Indemnity)
                                    ORDER(Ascending)
                                    WHERE(Type = FILTER(Imposable),
                                          "Integrated into accounting" = FILTER(FALSE));

                trigger OnAfterGetRecord()
                begin
                    //
                    AddDataIndemnity();//WDC 0307
                    //
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FIELDNO("Global dimension 2");
                end;
            }
            dataitem("<Integer1>"; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    ORDER(Ascending)
                                    WHERE(Number = FILTER(1 ..));

                trigger OnAfterGetRecord()
                var
                    LGen: Record 81;
                    Indemnity: Record "WDC Indemnity";
                begin
                    PostedIndemnity.RESET;
                    PostedIndemnity.SETRANGE(Numero, Number);
                    IF PostedIndemnity.FINDSET THEN BEGIN
                        EmployeePostingGrp.GET(PostedIndemnity."Employee Posting Group");
                        // Ligne de totalisation des Indemnités Imposables
                        GenJournalLine.RESET;
                        GenJournalLine.INIT;
                        Window.UPDATE(1, win5);
                        GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                        GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                        GenJournalLine.VALIDATE("Line No.", ln);

                        GenJournalLine.VALIDATE("Document Type", 0);

                        GenJournalLine.VALIDATE("Account Type", 0);
                        GenJournalLine.VALIDATE("Account No.", EmployeePostingGrp."Taxable Indemnities Acc. No.");
                        GenJournalLine.Description := GenJournalLine.Description;
                        //GenJournalLine.Description := '(' + "Employee Posting Group" + ') - ' + GenJournalLine.Description;

                        GenJournalLine.VALIDATE("Posting Date", PostingDate);

                        GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");

                        GenJournalLine.VALIDATE("Debit Amount", ROUND(PostedIndemnity."Real Amount", 0.001));
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PostedIndemnity."Global dimension 1");
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PostedIndemnity."Global dimension 2");
                        GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                        GenJournalLine."Gen. Bus. Posting Group" := '';
                        GenJournalLine."Gen. Prod. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                        GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                        GenJournalLine."VAT Bus. Posting Group" := '';
                        GenJournalLine."VAT Prod. Posting Group" := '';
                        GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                        GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                        IF GenJournalLine."Account No." = '' THEN
                            ERROR(Text001, EmployeePostingGrp.FIELDCAPTION("Taxable Indemnities Acc. No."),
                                PostedIndemnity."Employee Posting Group");

                        GenJournalLine."Source Code" := Model."Source Code";
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        ln := ln + 10000;
                    END;
                    // END;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, NbreLigneIndemnity);
                end;
            }
            dataitem("<Heures sup. eregistrées m>"; "WDC Overtime hours recorded m")
            {
                DataItemLink = "Payment No." = FIELD("No.");
                DataItemTableView = SORTING("Payment No.", "Employee Posting Group", "Department Code", "Folder Code", "Employee No.")
                                    ORDER(Ascending);

                trigger OnAfterGetRecord()
                begin

                    //AddDataHSup();
                end;
            }
            dataitem("<Integer2>"; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    ORDER(Ascending)
                                    WHERE(Number = FILTER(1 ..));

                trigger OnAfterGetRecord()
                begin
                    HoursSup.RESET;
                    HoursSup.SETRANGE(Number, Number);
                    IF HoursSup.FINDSET THEN BEGIN
                        EmployeePostingGrp.GET(HoursSup."Employee Posting Group");

                        GenJournalLine.RESET;
                        GenJournalLine.INIT;
                        Window.UPDATE(1, win6);
                        GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                        GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                        GenJournalLine.VALIDATE("Line No.", ln);

                        GenJournalLine.VALIDATE("Account Type", 0);
                        GenJournalLine.VALIDATE("Account No.", EmployeePostingGrp."Supp. Hours Account No.");
                        GenJournalLine.Description := GenJournalLine.Description;

                        GenJournalLine.VALIDATE("Posting Date", PostingDate);

                        GenJournalLine.VALIDATE("Document Type", 0);
                        GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");

                        GenJournalLine.VALIDATE("Debit Amount", ROUND(HoursSup."Line amount", 0.001));
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HoursSup."Department Code");
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", HoursSup."Folder Code");
                        GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                        GenJournalLine."Gen. Bus. Posting Group" := '';
                        GenJournalLine."Gen. Prod. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                        GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                        GenJournalLine."VAT Bus. Posting Group" := '';
                        GenJournalLine."VAT Prod. Posting Group" := '';
                        GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                        GenJournalLine."Bal. VAT Prod. Posting Group" := '';

                        IF GenJournalLine."Account No." = '' THEN
                            ERROR(Text001, EmployeePostingGrp.FIELDCAPTION("Supp. Hours Account No."),
                                HoursSup."Employee Posting Group");

                        GenJournalLine."Source Code" := Model."Source Code";
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        ln := ln + 10000;
                    END;

                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, NbrLigneHS);
                end;
            }
            dataitem("<Rec. Indemnities Non Imp>"; 55026)
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Employee Posting Group", "Global dimension 1", "Global dimension 2", Indemnity)
                                    ORDER(Ascending)
                                    WHERE(Type = FILTER("Taxable (Not Subject to Social Security)"));

                trigger OnAfterGetRecord()
                begin
                    AddDataIndemnity1();//WDC 0307
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FIELDNO("Global dimension 2");
                end;
            }
            dataitem("<Integer3>"; Integer)
            {

                trigger OnAfterGetRecord()
                begin
                    PostedIndemnity1.RESET;
                    IF PostedIndemnity1.FINDSET THEN BEGIN
                        EmployeePostingGrp.GET(PostedIndemnity1."Employee Posting Group");
                        GenJournalLine.RESET;
                        GenJournalLine.INIT;
                        Window.UPDATE(1, win7);
                        GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                        GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                        GenJournalLine.VALIDATE("Line No.", ln);

                        GenJournalLine.VALIDATE("Account Type", 0);
                        GenJournalLine.VALIDATE("Account No.", EmployeePostingGrp."Non Tax. Indemnities Acc. No.");
                        GenJournalLine.Description := GenJournalLine.Description;

                        GenJournalLine.VALIDATE("Posting Date", PostingDate);

                        GenJournalLine.VALIDATE("Document Type", 0);
                        GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");

                        GenJournalLine.VALIDATE("Debit Amount", ROUND(PostedIndemnity1."Real Amount", 0.001));
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PostedIndemnity1."Global dimension 1");
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PostedIndemnity1."Global dimension 2");
                        GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                        GenJournalLine."Gen. Bus. Posting Group" := '';
                        GenJournalLine."Gen. Prod. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                        GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                        GenJournalLine."VAT Bus. Posting Group" := '';
                        GenJournalLine."VAT Prod. Posting Group" := '';
                        GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                        GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                        IF GenJournalLine."Account No." = '' THEN
                            ERROR(Text001, EmployeePostingGrp.FIELDCAPTION("Non Tax. Indemnities Acc. No."),
                                PostedIndemnity1."Employee Posting Group");

                        GenJournalLine."Source Code" := Model."Source Code";
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        ln := ln + 10000;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, NbreLigneIndemnity1);
                end;
            }
            dataitem("Rec. Social Contributions"; "WDC Rec. Social Contributions")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Social Contribution", "Globlal dimension 1", "Global dimension 2")
                                    ORDER(Ascending)
                                    WHERE("Integrated into accounting" = FILTER(FALSE));

                trigger OnAfterGetRecord()
                begin
                    AddDataCNSS();
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FIELDNO("Global dimension 2");
                end;
            }
            dataitem("<Integer5>"; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    ORDER(Ascending)
                                    WHERE(Number = FILTER(1 ..));

                trigger OnAfterGetRecord()
                begin
                    PstdSocialContrCNSS.RESET;
                    PstdSocialContrCNSS.SETRANGE(Number, Number);
                    IF PstdSocialContrCNSS.FINDSET THEN BEGIN


                        IF SocialContribution.GET(PstdSocialContrCNSS."Social Contribution") THEN
                            // Ligne de Cotisation Sociale : Part salarié (une ligne en Crédit uniquement)
                            GenJournalLine.RESET;
                        GenJournalLine.INIT;
                        Window.UPDATE(1, win9);
                        GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                        GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                        GenJournalLine.VALIDATE("Line No.", ln);

                        GenJournalLine.VALIDATE("Document Type", 0);

                        GenJournalLine.VALIDATE("Account Type", 0);
                        GenJournalLine.VALIDATE("Account No.", SocialContribution."Employee Account No.");
                        IF "G/LAccount".GET(SocialContribution."Employee Account No.") THEN
                            GenJournalLine.Description := '(Salariale) - ' + "G/LAccount".Name;

                        GenJournalLine.VALIDATE("Bal. Account Type", 0);
                        GenJournalLine.VALIDATE("Bal. Account No.", '');

                        GenJournalLine.VALIDATE("Posting Date", PostingDate);

                        GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");

                        GenJournalLine.VALIDATE("Credit Amount", ROUND(PstdSocialContrCNSS."Real Amount : Employee", 0.001));
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PstdSocialContrCNSS."Globlal dimension 1");
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PstdSocialContrCNSS."Global dimension 2");
                        GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                        GenJournalLine."Gen. Bus. Posting Group" := '';
                        GenJournalLine."Gen. Prod. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                        GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Prod. Posting Group" := '';

                        GenJournalLine."VAT Bus. Posting Group" := '';
                        GenJournalLine."VAT Prod. Posting Group" := '';
                        GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                        GenJournalLine."Bal. VAT Prod. Posting Group" := '';

                        IF GenJournalLine."Account No." = '' THEN
                            ERROR(Text002, SocialContribution.FIELDCAPTION("Employee Account No."),
                                SocialContribution.Code);

                        GenJournalLine."Source Code" := Model."Source Code";
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        ln := ln + 10000;

                        // Ligne de Cotisation Sociale : Part patronale
                        GenJournalLine.RESET;
                        GenJournalLine.INIT;
                        Window.UPDATE(1, win10);
                        GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                        GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                        GenJournalLine.VALIDATE("Line No.", ln);

                        GenJournalLine.VALIDATE("Account Type", 0);
                        GenJournalLine.VALIDATE("Account No.", SocialContribution."Employer Account No.");
                        //"G/LAccount".GET (SocialContribution."Employer Account No.");
                        GenJournalLine.Description := '(Patronale) - ' + SocialContribution.Description;

                        GenJournalLine.VALIDATE("Bal. Account Type", 0);
                        GenJournalLine.VALIDATE("Bal. Account No.", SocialContribution."Employer : Bal. Account No.");


                        GenJournalLine.VALIDATE("Posting Date", PostingDate);

                        GenJournalLine.VALIDATE("Document Type", 0);
                        GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");

                        GenJournalLine.VALIDATE("Debit Amount", ROUND(PstdSocialContrCNSS."Real Amount : Employer", 0.001));
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PstdSocialContrCNSS."Globlal dimension 1");
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PstdSocialContrCNSS."Global dimension 2");
                        GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                        GenJournalLine."Gen. Bus. Posting Group" := '';
                        GenJournalLine."Gen. Prod. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                        GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                        GenJournalLine."VAT Bus. Posting Group" := '';
                        GenJournalLine."VAT Prod. Posting Group" := '';
                        GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                        GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                        IF GenJournalLine."Account No." = '' THEN
                            ERROR(Text002, SocialContribution.FIELDCAPTION("Employer Account No."),
                                SocialContribution.Code);
                        IF GenJournalLine."Bal. Account No." = '' THEN
                            ERROR(Text002, SocialContribution.FIELDCAPTION("Employer : Bal. Account No."),
                                SocialContribution.Code);

                        GenJournalLine."Source Code" := Model."Source Code";
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        ln := ln + 10000;

                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, PstdSocialContrCNSSLine);
                end;
            }
            dataitem("Loan & Advance Lines"; "WDC Loan & Advance Lines")
            {
                DataItemLink = "Payment No." = FIELD("No.");
                DataItemTableView = SORTING("Document type", "Global dimension 1", "Global dimension 2", "Employee No.")
                                    ORDER(Ascending)
                                    WHERE(Paid = FILTER(TRUE));

                trigger OnAfterGetRecord()
                begin
                    GenJournalLine.RESET;
                    GenJournalLine.INIT;
                    LoanAdvanceType.GET("Document type");
                    BEGIN

                        Window.UPDATE(1, win11);
                        GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                        GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                        GenJournalLine.VALIDATE("Line No.", ln);

                        CASE LoanAdvanceType."Account Type".AsInteger() OF
                            0:
                                BEGIN
                                    GenJournalLine.VALIDATE("Account Type", 0);
                                    IF "G/LAccount".GET(LoanAdvanceType."Account No.") THEN NewDescription := "G/LAccount".Name;
                                END;
                            1:
                                BEGIN
                                    GenJournalLine.VALIDATE("Account Type", 3);
                                    IF BankAccount.GET(LoanAdvanceType."Account No.") THEN NewDescription := BankAccount.Name;
                                END;
                        END;
                        GenJournalLine.VALIDATE("Account No.", LoanAdvanceType."Account No.");
                        GenJournalLine.Description := '(' + "Document type" + ') - ' + NewDescription;

                        GenJournalLine.VALIDATE("Bal. Account Type", 0);
                        GenJournalLine.VALIDATE("Bal. Account No.", '');

                        GenJournalLine.VALIDATE("Posting Date", PostingDate);

                        GenJournalLine.VALIDATE("Document Type", 0);
                        GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");
                        GenJournalLine.VALIDATE("External Document No.", '----------');

                        GenJournalLine.VALIDATE("Credit Amount", ROUND("Principal Amount", 0.001));
                        GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee; //::5 Migration Hamdi;
                        GenJournalLine."Source No." := "Employee No.";
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", "Global dimension 1");
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", "Global dimension 2");
                        GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                        GenJournalLine."Gen. Bus. Posting Group" := '';
                        GenJournalLine."Gen. Prod. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                        GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                        GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                        IF GenJournalLine."Account No." = '' THEN
                            ERROR(Text002, LoanAdvanceType.FIELDCAPTION("Account No."),
                             LoanAdvanceType.Code);

                        GenJournalLine."Source Code" := Model."Source Code";
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                        ln := ln + 10000;
                        // inserer Inetret
                        IF AdvanceLinePret."Interest Amount" <> 0 THEN BEGIN
                            GenJournalLine.RESET;
                            GenJournalLine.INIT;
                            GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                            GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                            GenJournalLine.VALIDATE("Line No.", ln);

                            GenJournalLine.VALIDATE("Account Type", 0);
                            IF "G/LAccount".GET(LoanAdvanceType."Interest Account No.") THEN NewDescription := "G/LAccount".Name;

                            GenJournalLine.VALIDATE("Account No.", LoanAdvanceType."Interest Account No.");
                            GenJournalLine.Description := '(' + AdvanceLinePret."Document type" + ') - ' + NewDescription;

                            GenJournalLine.VALIDATE("Bal. Account Type", 0);
                            GenJournalLine.VALIDATE("Bal. Account No.", '');

                            GenJournalLine.VALIDATE("Posting Date", PostingDate);

                            GenJournalLine.VALIDATE("Document Type", 0);
                            GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");
                            GenJournalLine.VALIDATE("External Document No.", '----------');

                            GenJournalLine.VALIDATE("Credit Amount", ROUND("Interest Amount", 0.001));
                            GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee; //::5 Migration Hamdi;
                            GenJournalLine."Source No." := AdvanceLinePret."Employee No.";

                            GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", "Global dimension 1");
                            GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", "Global dimension 2");
                            GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                            GenJournalLine."Gen. Bus. Posting Group" := '';
                            GenJournalLine."Gen. Prod. Posting Group" := '';
                            GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                            GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                            GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                            GenJournalLine."VAT Bus. Posting Group" := '';
                            GenJournalLine."VAT Prod. Posting Group" := '';
                            GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                            GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                            IF GenJournalLine."Account No." = '' THEN
                                ERROR(Text002, LoanAdvanceType.FIELDCAPTION("Interest Account No."),
                                LoanAdvanceType.Code);

                            GenJournalLine."Source Code" := Model."Source Code";
                            IF GenJournalLine.Amount <> 0 THEN
                                GenJournalLine.INSERT;
                            ln := ln + 10000;
                        END;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FIELDNO("Global dimension 2");
                end;
            }
            dataitem("<Integer6>"; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    ORDER(Ascending)
                                    WHERE(Number = FILTER(1 ..));

                trigger OnAfterGetRecord()
                begin
                    AdvanceLinePret.RESET;
                    AdvanceLinePret.SETRANGE(Number, Number);
                    IF AdvanceLinePret.FINDSET THEN BEGIN

                        // Ligne de Remboursement de Prêt & Avance
                        // Décomposéeen 2 lignes :
                        // - 1ère ligne au Débit du salarié
                        // - 2ème ligne au Crédit du compte de contre partie selon le type du document (Dans le GroupFooter)
                        GenJournalLine.RESET;
                        GenJournalLine.INIT;
                        LoanAdvanceType.GET(AdvanceLinePret."Document type");

                        BEGIN

                            Window.UPDATE(1, win11);
                            GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                            GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                            GenJournalLine.VALIDATE("Line No.", ln);

                            CASE LoanAdvanceType."Account Type".AsInteger() OF
                                0:
                                    BEGIN
                                        GenJournalLine.VALIDATE("Account Type", 0);
                                        IF "G/LAccount".GET(LoanAdvanceType."Account No.") THEN NewDescription := "G/LAccount".Name;
                                    END;
                                1:
                                    BEGIN
                                        GenJournalLine.VALIDATE("Account Type", 3);
                                        IF BankAccount.GET(LoanAdvanceType."Account No.") THEN NewDescription := BankAccount.Name;
                                    END;
                            END;
                            GenJournalLine.VALIDATE("Account No.", LoanAdvanceType."Account No.");
                            GenJournalLine.Description := '(' + AdvanceLinePret."Document type" + ') - ' + NewDescription;

                            GenJournalLine.VALIDATE("Bal. Account Type", 0);
                            GenJournalLine.VALIDATE("Bal. Account No.", '');

                            GenJournalLine.VALIDATE("Posting Date", PostingDate);

                            GenJournalLine.VALIDATE("Document Type", 0);
                            GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");
                            GenJournalLine.VALIDATE("External Document No.", '----------');

                            GenJournalLine.VALIDATE("Credit Amount", ROUND(AdvanceLinePret."Principal Amount", 0.001));
                            GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee; //::5 Migration Hamdi
                            GenJournalLine."Source No." := AdvanceLinePret."Employee No.";
                            GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", AdvanceLinePret."Global dimension 1");
                            GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", AdvanceLinePret."Global dimension 2");
                            GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                            GenJournalLine."Gen. Bus. Posting Group" := '';
                            GenJournalLine."Gen. Prod. Posting Group" := '';
                            GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                            GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                            GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                            IF GenJournalLine."Account No." = '' THEN
                                ERROR(Text002, LoanAdvanceType.FIELDCAPTION("Account No."),
                                 LoanAdvanceType.Code);

                            GenJournalLine."Source Code" := Model."Source Code";
                            IF GenJournalLine.Amount <> 0 THEN
                                GenJournalLine.INSERT;
                            ln := ln + 10000;
                            // inserer Inetret
                            IF AdvanceLinePret."Interest Amount" <> 0 THEN BEGIN
                                GenJournalLine.RESET;
                                GenJournalLine.INIT;
                                GenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
                                GenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                                GenJournalLine.VALIDATE("Line No.", ln);

                                GenJournalLine.VALIDATE("Account Type", 0);
                                IF "G/LAccount".GET(LoanAdvanceType."Interest Account No.") THEN NewDescription := "G/LAccount".Name;

                                GenJournalLine.VALIDATE("Account No.", LoanAdvanceType."Interest Account No.");
                                GenJournalLine.Description := '(' + AdvanceLinePret."Document type" + ') - ' + NewDescription;

                                GenJournalLine.VALIDATE("Bal. Account Type", 0);
                                GenJournalLine.VALIDATE("Bal. Account No.", '');

                                GenJournalLine.VALIDATE("Posting Date", PostingDate);

                                GenJournalLine.VALIDATE("Document Type", 0);
                                GenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");
                                GenJournalLine.VALIDATE("External Document No.", '----------');

                                GenJournalLine.VALIDATE("Credit Amount", ROUND(AdvanceLinePret."Interest Amount", 0.001));
                                GenJournalLine."Source Type" := GenJournalLine."Source Type"::Employee; //::5 Migration Hamdi;
                                GenJournalLine."Source No." := AdvanceLinePret."Employee No.";

                                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", AdvanceLinePret."Global dimension 1");
                                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", AdvanceLinePret."Global dimension 2");
                                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                                GenJournalLine."Gen. Bus. Posting Group" := '';
                                GenJournalLine."Gen. Prod. Posting Group" := '';
                                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                                GenJournalLine."VAT Bus. Posting Group" := '';
                                GenJournalLine."VAT Prod. Posting Group" := '';
                                GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                                GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                                IF GenJournalLine."Account No." = '' THEN
                                    ERROR(Text002, LoanAdvanceType.FIELDCAPTION("Interest Account No."),
                                    LoanAdvanceType.Code);

                                GenJournalLine."Source Code" := Model."Source Code";
                                IF GenJournalLine.Amount <> 0 THEN
                                    GenJournalLine.INSERT;
                                ln := ln + 10000;
                            END;
                        END;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, AdvanceLinePretLine);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Window.OPEN('############################################1####\' +
                             'Posting..                       \' +
                             FORMAT(WORKDATE) + ' - ' + COMPANYNAME);

                IF "Rec. Salary Header"."No." = 'SIMULATION' THEN
                    ERROR(errSIM);
                LignePrêt.RESET;
                LignePrêt.SETCURRENTKEY("Document type", "Global dimension 1", "Global dimension 2", "Employee No.");
                LignePrêt.SETRANGE("Payment No.", "Rec. Salary Header"."No.");
                LignePrêt.SETFILTER(Paid, '%1', FALSE);
                IF LignePrêt.FINDSET THEN BEGIN
                    LignePrêt.MODIFYALL(Paid, TRUE);
                END;
                Window.UPDATE(1, win1);
            end;

            trigger OnPostDataItem()
            begin
                "Rec. Salary Header"."Integrated in accounting" := TRUE;
                "Rec. Salary Header".MODIFY;
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
                    Caption = 'Options';

                    field(PostingDate; PostingDate)
                    {
                        Caption = 'Date de validation';
                        ApplicationArea = all;
                    }
                    field(PostingMode; PostingMode)
                    {
                        Caption = 'Mode de validation';
                        ApplicationArea = all;
                    }
                }
            }
        }
    }


    trigger OnInitReport()
    begin
        //>>
        NbreLigne := 0;
        NbreLigneIndemnity := 0;
        NbrLigneHS := 0;
        NbreLigneIndemnity1 := 0;
        IntEntpret := 0;
        PstdSocialContrCNSSLine := 0;
        AdvanceLinePretLine := 0;
        //<<
        PostingDate := WORKDATE;

        HumanResourcesSetup.GET();
        CLEAR(Model);
        IF Model.GET(HumanResourcesSetup."General Journal Template") THEN;
        GenJournalLine.SETRANGE("Journal Template Name", HumanResourcesSetup."General Journal Template");
        GenJournalLine.SETRANGE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
        IF GenJournalLine.FindLast() THEN
            ln := GenJournalLine."Line No." + 10000
        ELSE
            ln := 10000;

        First := ln;

    end;

    trigger OnPostReport()
    begin

        Last := ln;

        LastGenJnlLine.RESET;
        LastGenJnlLine.SETRANGE("Journal Template Name", HumanResourcesSetup."General Journal Template");
        LastGenJnlLine.SETRANGE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
        LastGenJnlLine.SETFILTER("Line No.", '%1..%2', First, Last);
        IF LastGenJnlLine.FIND('+') THEN;


        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", HumanResourcesSetup."General Journal Template");
        GenJournalLine.SETRANGE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
        GenJournalLine.SETFILTER("Line No.", '%1..%2', First, Last);
        IF GenJournalLine.Findfirst THEN BEGIN

            Test := FALSE;
            GenJnlManagement.CalcBalance(GenJournalLine, LastGenJnlLine, Balance, TotalBalance, Test, Test);

            RoundGenJnlLine.RESET;
            RoundGenJnlLine.INIT;

            RoundGenJnlLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
            RoundGenJnlLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
            RoundGenJnlLine.VALIDATE("Line No.", Last + 10000);

            RoundGenJnlLine.VALIDATE("Account Type", 0);
            RoundGenJnlLine.VALIDATE("Account No.", HumanResourcesSetup."Loss on rounding amounts");

            RoundGenJnlLine.VALIDATE("Posting Date", PostingDate);
            RoundGenJnlLine.VALIDATE("Document Type", 0);
            RoundGenJnlLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");
            RoundGenJnlLine.VALIDATE("External Document No.", 'PAYROLL');
            IF TotalBalance < 0 THEN
                RoundGenJnlLine.VALIDATE("Debit Amount", ABS(TotalBalance))
            ELSE
                RoundGenJnlLine.VALIDATE("Credit Amount", ABS(TotalBalance));
            RoundGenJnlLine."Source Code" := Model."Source Code";
            RoundGenJnlLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
            RoundGenJnlLine."Gen. Bus. Posting Group" := '';
            RoundGenJnlLine."Gen. Prod. Posting Group" := '';
            RoundGenJnlLine."Bal. Gen. Posting Type" := RoundGenJnlLine."Bal. Gen. Posting Type"::" ";
            RoundGenJnlLine."Bal. Gen. Bus. Posting Group" := '';
            RoundGenJnlLine."Bal. Gen. Prod. Posting Group" := '';
            RoundGenJnlLine."VAT Bus. Posting Group" := '';
            RoundGenJnlLine."VAT Prod. Posting Group" := '';
            IF TotalBalance <> 0 THEN
                RoundGenJnlLine.INSERT;
            Last := Last + 10000;
        END;

        //>>
        Last := Last + 10000;
        RGenJournalLine.INIT;
        RGenJournalLine.VALIDATE("Journal Template Name", HumanResourcesSetup."General Journal Template");
        RGenJournalLine.VALIDATE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
        RGenJournalLine.VALIDATE("Line No.", Last);
        RGenJournalLine.VALIDATE("Posting Date", WORKDATE);
        RGenJournalLine.VALIDATE("Document No.", "Rec. Salary Header"."No.");
        RGenJournalLine.VALIDATE("Account Type", RGenJournalLine."Account Type"::"G/L Account");
        IF recBanqueVirement.GET(HumanResourcesSetup."Transfer ATB Bank") THEN BEGIN
            recGpeComptaBanque.GET(recBanqueVirement."Bank Acc. Posting Group");
            RGenJournalLine.VALIDATE("Account No.", recGpeComptaBanque."G/L Account No.");
        END;
        //

        //>>
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", HumanResourcesSetup."General Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
        GenJnlLine.SETFILTER("Line No.", '%1..%2', First, Last);
        IF GenJnlLine.Findfirst THEN BEGIN
            CASE PostingMode OF
                0:
                    MESSAGE(messOK, HumanResourcesSetup."General Journal Template", HumanResourcesSetup."Gen. Journal Batch (Payroll)");
                1:
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
            END;
        END;


        IF Header.GET("DocNo.") THEN BEGIN
            Header.DELETE;
            Lines.SETRANGE("No.", "DocNo.");
            IF Lines.Findfirst THEN
                Lines.DELETEALL;
            Indemnities.SETRANGE("No.", "DocNo.");
            IF Indemnities.Findfirst THEN
                Indemnities.DELETEALL;
            SocialContributions.SETRANGE("No.", "DocNo.");
            IF SocialContributions.Findfirst THEN
                SocialContributions.DELETEALL;
        END;



        Window.CLOSE;

    end;

    var
        Window: Dialog;
        PostingMode: Option "Par feuille de saisie",Directe;
        "G/LAccount": Record 15;
        BankAccount: Record 270;
        GenJournalLine: Record 81;
        GenJnlLine: Record 81;
        LastGenJnlLine: Record 81;
        RoundGenJnlLine: Record 81;
        HumanResourcesSetup: Record "Human Resources Setup";
        EmployeePostingGrp: Record 55029;
        SocialContribution: Record "WDC Social Contribution";
        LoanAdvanceType: Record 55010;
        PostingDate: Date;
        "DocNo.": Code[20];
        ln: Integer;
        NewDescription: Text[50];
        First: Integer;
        Last: Integer;
        GenJnlManagement: Codeunit GenJnlManagement;
        Balance: Decimal;
        TotalBalance: Decimal;
        Test: Boolean;
        Header: Record "WDC Employee's days off Entry";
        Lines: Record "WDC Salary Header";
        Indemnities: Record "WDC Indemnities";
        SocialContributions: Record "WDC Social Contributions";
        Model: Record 80;
        LastFieldNo: Integer;
        Text001: TextConst ENU = 'Please Check %1 for the Employee %2 group',
                          FRA = 'Veuillez vérifier %1 pour le groupe Salarié %2';
        Text002: TextConst ENU = 'Please check %1 for Social Contribution %2',
                          FRA = 'Veuillez vérifier %1 pour la Contribution Social  %2';
        messOK: TextConst ENU = 'Lines inserted in Employees''s Journals: %1 - %2.',
                          FRA = 'Lignes insérées dans les journaux des employés : %1 - %2.';
        win1: TextConst ENU = 'Creating records.',
                        FRA = 'Création des enregistrements.';
        win2: TextConst ENU = 'Inserting Net salary cashed lines.',
                        FRA = 'Insertion des lignes de salaire net encaissé.';
        win3: TextConst ENU = 'Inserting Real basis salary lines.',
                        FRA = 'Insertion des lignes du salaire de base réel.';
        win4: TextConst ENU = 'Inserting Taxes lines.',
                        FRA = 'Insertion des lignes d''impôts.';
        win5: TextConst ENU = 'Inserting Taxable indemnities lines.',
                        FRA = 'Insertion des lignes d''indemnités imposables.';
        win6: TextConst ENU = 'Inserting Sup. hours salary lines.',
                        FRA = 'Insertion des lignes de salaire heures supplémentaires.';
        win7: TextConst ENU = 'Inserting Non Taxable indemnities lines.',
                        FRA = 'Insertion des lignes d''indemnités non imposables.';
        win9: TextConst ENU = 'Inserting Employees''s Charge lines.',
                        FRA = 'Insertion des lignes de charges des employés.';
        win10: TextConst ENU = 'Inserting Employer''s Charge lines.',
                         FRA = 'Insertion des lignes de charges patronales.';
        win11: TextConst ENU = 'Inserting Loans & Advances repayment lines.',
                         FRA = 'Insertion des lignes de remboursement de prêts et avances.';
        errSIM: TextConst ENU = 'SIMULATION payment cannot be posted.',
                          FRA = 'Le paiement SIMULATION ne peut pas être validé.';
        MontantVirement: Decimal;
        RGenJournalLine: Record 81;
        recBanqueVirement: Record 270;
        recGpeComptaBanque: Record 277;
        RecGSalaryLine: Record "WDC Posted Salary Lines" temporary;
        NbreLigne: Integer;
        PostedIndemnity: Record "WDC Rec. Indemnities" temporary;
        NbreLigneIndemnity: Integer;
        HoursSup: Record "WDC Overtime hours recorded m" temporary;
        NbrLigneHS: Integer;
        PostedIndemnity1: Record "WDC Rec. Indemnities" temporary;
        NbreLigneIndemnity1: Integer;
        IntEntpret: Integer;
        PstdSocialContrCNSS: Record "WDC Rec. Social Contributions" temporary;
        PstdSocialContrCNSSLine: Integer;
        AdvanceLinePret: Record "WDC Loan & Advance Lines" temporary;
        AdvanceLinePretLine: Integer;
        "LignePrêt": Record "WDC Loan & Advance Lines";
        SalaireBrut: Decimal;
        RetraitePlus: Decimal;

    procedure AddData()
    begin
        //>>
        RecGSalaryLine.RESET;
        RecGSalaryLine.SETRANGE("Employee Posting Group", "Rec. Salary Lines"."Employee Posting Group");
        RecGSalaryLine.SETRANGE("No.", "Rec. Salary Lines"."No.");
        IF NOT RecGSalaryLine.FINDFIRST THEN BEGIN
            NbreLigne := NbreLigne + 1;
            RecGSalaryLine.TRANSFERFIELDS("Rec. Salary Lines");
            RecGSalaryLine.Number := NbreLigne;
            RecGSalaryLine.INSERT;
        END ELSE BEGIN
            RecGSalaryLine."Net salary cashed" := RecGSalaryLine."Net salary cashed" + "Rec. Salary Lines"."Net salary cashed";
            //
            RecGSalaryLine."Gross Salary" := RecGSalaryLine."Gross Salary" + "Rec. Salary Lines"."Gross Salary";
            RecGSalaryLine."Real basis salary" := RecGSalaryLine."Real basis salary" + "Rec. Salary Lines"."Real basis salary";
            //
            RecGSalaryLine."Non Taxable indemnities" := RecGSalaryLine."Non Taxable indemnities" + "Rec. Salary Lines"."Non Taxable indemnities";
            RecGSalaryLine."Taxe (Month)" := RecGSalaryLine."Taxe (Month)" + "Rec. Salary Lines"."Taxe (Month)";
            RecGSalaryLine.MODIFY;
        END;
        //<<
    end;


    procedure AddDataIndemnity()
    var
        lindemnities: Record "WDC Rec. Indemnities";
    begin
        //>>
        //>>
        PostedIndemnity.RESET;
        PostedIndemnity.SETRANGE("No.", "<Rec. Indemnities Imp>"."No.");
        PostedIndemnity.SETRANGE("Indemnity Account No.", "<Rec. Indemnities Imp>"."Indemnity Account No.");
        PostedIndemnity.SETRANGE(Type, PostedIndemnity.Type::Imposable); //WDC 0307
        IF NOT PostedIndemnity.FINDFIRST THEN BEGIN
            NbreLigneIndemnity := NbreLigneIndemnity + 1;
            PostedIndemnity.TRANSFERFIELDS("<Rec. Indemnities Imp>");
            PostedIndemnity.Numero := NbreLigneIndemnity;
            PostedIndemnity.INSERT;
        END ELSE BEGIN
            PostedIndemnity."Real Amount" := PostedIndemnity."Real Amount" + "<Rec. Indemnities Imp>"."Real Amount";
            PostedIndemnity.MODIFY;
        END;
        //<<

        //<<
    end;

    procedure AddDataIndemnity1()
    begin
        //>>
        PostedIndemnity1.RESET;
        PostedIndemnity1.SETRANGE("No.", "<Rec. Indemnities Non Imp>"."No.");
        PostedIndemnity1.SETRANGE("Indemnity Account No.", "<Rec. Indemnities Non Imp>"."Indemnity Account No.");
        PostedIndemnity1.SETRANGE(Type, PostedIndemnity1.Type::"Taxable (Not Subject to Social Security)"); //WDC 0307
        IF NOT PostedIndemnity1.FINDFIRST THEN BEGIN
            NbreLigneIndemnity1 := NbreLigneIndemnity1 + 1;
            PostedIndemnity1.TRANSFERFIELDS("<Rec. Indemnities Non Imp>");
            PostedIndemnity1.Numero := NbreLigneIndemnity1;
            PostedIndemnity1.INSERT;
        END ELSE BEGIN
            PostedIndemnity1."Real Amount" := PostedIndemnity1."Real Amount" + "<Rec. Indemnities Non Imp>"."Real Amount";
            PostedIndemnity1.MODIFY;
        END;
        //<<
    end;


    procedure AddDataCNSS()
    begin
        //>>
        PstdSocialContrCNSS.RESET;
        PstdSocialContrCNSS.SETRANGE("Social Contribution", "Rec. Social Contributions"."Social Contribution");
        PstdSocialContrCNSS.SETRANGE("No.", "Rec. Social Contributions"."No.");
        IF NOT PstdSocialContrCNSS.FINDFIRST THEN BEGIN
            PstdSocialContrCNSSLine := PstdSocialContrCNSSLine + 1;
            PstdSocialContrCNSS.TRANSFERFIELDS("Rec. Social Contributions");
            PstdSocialContrCNSS.Number := PstdSocialContrCNSSLine;
            PstdSocialContrCNSS.INSERT;
        END ELSE BEGIN
            PstdSocialContrCNSS."Real Amount : Employee" := PstdSocialContrCNSS."Real Amount : Employee" + "Rec. Social Contributions"."Real Amount : Employee";
            PstdSocialContrCNSS."Real Amount : Employer" := PstdSocialContrCNSS."Real Amount : Employer" + "Rec. Social Contributions"."Real Amount : Employer";
            PstdSocialContrCNSS.MODIFY;
        END;
        //<<
    end;


    procedure AddDataLignePret()
    begin
        //>>
        AdvanceLinePret.RESET;
        AdvanceLinePret.SETRANGE("Employee Posting Group", "Loan & Advance Lines"."Employee Posting Group");
        AdvanceLinePret.SETRANGE("Payment No.", "Loan & Advance Lines"."Payment No.");
        AdvanceLinePret.SETRANGE(Type, "Loan & Advance Lines".Type);
        IF NOT AdvanceLinePret.FINDFIRST THEN BEGIN
            AdvanceLinePretLine := AdvanceLinePretLine + 1;
            AdvanceLinePret.TRANSFERFIELDS("Loan & Advance Lines");
            AdvanceLinePret.Number := AdvanceLinePretLine;
            AdvanceLinePret.INSERT;
        END ELSE BEGIN
            AdvanceLinePret."Principal Amount" := AdvanceLinePret."Principal Amount" + "Loan & Advance Lines"."Principal Amount";
            AdvanceLinePret."Interest Amount" := AdvanceLinePret."Interest Amount" + "Loan & Advance Lines"."Interest Amount";
            AdvanceLinePret.MODIFY;
        END;
        //<<
    end;
}

