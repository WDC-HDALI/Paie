page 55040 "WDC Calculation of Salaries"
{
    CaptionML = ENU = 'Calculation of salaries', FRA = 'Calcul des salaires';
    PageType = Card;
    SourceTable = "WDC Salary Header";
    SourceTableView = WHERE("No." = FILTER(<> 'SIMULATION'));
    ApplicationArea = All;
    layout
    {

        area(Content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Month"; Rec."Month")
                {
                    ApplicationArea = All;
                }
                field("Year"; Rec."Year")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Paid days"; Rec."Paid days")
                {
                    ApplicationArea = All;
                }
                field("Worked days"; Rec."Worked days")
                {
                    ApplicationArea = All;
                }
                field("Tax Regulation"; Rec."Tax Regulation")
                {
                    ApplicationArea = All;
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
            }

            part("Calculation lines"; "WDC Calculation lines")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Salary Line', FRA = 'Ligne salaire';
                SubPageLink = "No." = field("No.");
            }

            group("Cumulated salaries")
            {
                CaptionML = ENU = 'Cumulated salaries', FRA = 'Salaires cumulés';
                field("Employee No. filter"; Rec."Employee No. filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filtre N° salarié';
                }
                field("Employee posting grp. filter"; Rec."Employee posting grp. filter")
                {
                    ApplicationArea = All;
                }
                field("Total Basis Salary"; Rec."Total Basis Salary")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Supp. Hours"; Rec."Total Supp. Hours")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Taxable indemnities"; Rec."Total Taxable indemnities")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Gross salary"; Rec."Total Gross salary")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Non Taxable Soc. Contrib."; Rec."Non Taxable Soc. Contrib.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Taxable indemnities(Not Gross)"; Rec."Taxable indemnities(Not Gross)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total taxable"; Rec."Total taxable")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Taxable Soc. Contrib."; Rec."Taxable Soc. Contrib.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Taxes total"; Rec."Taxes total")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Not Taxable indemnities"; Rec."Total Not Taxable indemnities")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Mission expenses total"; Rec."Mission expenses total")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Net salary total"; Rec."Net salary total")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Loans repaiment total"; Rec."Loans repaiment total")
                {
                    ApplicationArea = All;
                }
                field("Advances repaiment total"; Rec."Advances repaiment total")
                {
                    ApplicationArea = All;
                }
                field("Ajout en +"; Rec."Ajout en +")
                {
                    ApplicationArea = All;
                }
                field("Report en -"; Rec."Report en -")
                {
                    ApplicationArea = All;
                }
                field("Net salary cashed"; Rec."Net salary cashed")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 1 Filter"; Rec."Global Dimension 1 Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filtre département';
                }
                field("Global Dimension 2 Filter"; Rec."Global Dimension 2 Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filtre dossier';
                }
                field("Salary lines"; Rec."Salary lines")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Statistic Group Filter"; Rec."Statistic Group Filter")
                {
                    ApplicationArea = All;
                }
                field("Management Filter"; Rec."Management Filter")
                {
                    ApplicationArea = All;
                }
                field("Filter Service"; Rec."Filter Service")
                {
                    ApplicationArea = All;
                }
                field("Filter Section"; Rec."Filter Section")
                {
                    ApplicationArea = All;
                }
            }

            group("Payement balance")
            {
                CaptionML = ENU = 'Payement balance', FRA = 'Balance de paiement';
                field("Employee No. filter2"; Rec."Employee No. filter")
                {
                    ApplicationArea = All;
                }
                field("Employee posting grp. filter2"; Rec."Employee posting grp. filter")
                {
                    ApplicationArea = All;
                }
                field("Salary lines2"; Rec."Salary lines")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Salary basis total2"; Rec."Total Basis Salary")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Supp. Hours2"; Rec."Total Supp. Hours")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Taxable indemnities total2"; Rec."Total Taxable indemnities")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Taxable indemnities(Not Gross)2"; Rec."Taxable indemnities(Not Gross)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Non Taxable indemnities T2"; Rec."Total Taxable indemnities")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Mission expenses total2"; Rec."Mission expenses total")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total"; Rec."Total Gross salary" + Rec."Mission expenses total" + Rec."Total Not Taxable indemnities" + Rec."Taxable indemnities(Not Gross)")
                {
                    ApplicationArea = All;
                    Caption = 'Total';
                    Editable = false;
                }
                field("Global Dimension 1 Filter2"; Rec."Global Dimension 1 Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filtre département';
                }
                field("Global Dimension 2 Filter2"; Rec."Global Dimension 2 Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filtre dossier';
                }
                field("Statistic Group Filter2"; Rec."Statistic Group Filter")
                {
                    ApplicationArea = All;
                }
                field("Non Taxable Soc. Contrib.2"; Rec."Non Taxable Soc. Contrib.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Taxable Soc. Contrib.2"; Rec."Taxable Soc. Contrib.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Loans repaiment total2"; Rec."Loans repaiment total")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Advances repaiment total2"; Rec."Advances repaiment total")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Taxes total2"; Rec."Taxes total")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Net salary cashed2"; Rec."Net salary cashed")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ajout en +2"; Rec."Ajout en +")
                {
                    ApplicationArea = All;
                    Caption = 'Ajout en + 2';
                }
                field("Report en -2"; Rec."Report en -")
                {
                    ApplicationArea = All;
                    Caption = 'Report en - 2';
                }
                field("Total Deductions Balance"; Rec."Taxable Soc. Contrib." + Rec."Non Taxable Soc. Contrib." + Rec."Loans repaiment total" + Rec."Advances repaiment total" + Rec."Taxes total" + Rec."Net salary cashed" + Rec."Report en -" - Rec."Ajout en +")
                {
                    ApplicationArea = All;
                    Caption = 'Total';
                    Editable = false;
                }
            }

            group("Human Ress. cost")
            {
                captionML = ENU = 'Human Ress. cost', FRA = 'Coût ressources humaines';
                field("Employee No. filter3"; Rec."Employee No. filter")
                {
                    ApplicationArea = All;
                }
                field("Employee posting grp. filter3"; Rec."Employee posting grp. filter")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Filter3"; Rec."Global Dimension 1 Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filter département';
                }
                field("Global Dimension 2 Filter3"; Rec."Global Dimension 2 Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filtre dossier';
                }
                field("Salary lines3"; Rec."Salary lines")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Filter gpe statistic3"; Rec."Statistic Group Filter")
                {
                    ApplicationArea = All;
                }
                field("Salary basis total3"; Rec."Total Basis Salary")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Taxable indemnities total3"; Rec."Total Taxable indemnities")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Taxable indemnities Not3"; Rec."Taxable indemnities(Not Gross)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Non Taxable indemnities T3"; Rec."Total Not Taxable indemnities")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Mission expenses total3"; Rec."Mission expenses total")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Supp. Hours3"; Rec."Total Supp. Hours")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Charges patronales"; Rec."Total Charges patronales")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("HR Total Cost"; Rec."Total Basis Salary" + Rec."Total Taxable indemnities" + Rec."Total Not Taxable indemnities" + Rec."Mission expenses total" + Rec."Total Supp. Hours" + Rec."Total Charges patronales" + Rec."Taxable indemnities(Not Gross)")
                {
                    ApplicationArea = All;
                    captionML = ENU = 'HR Total Cost', FRA = 'Coût total RH';
                    Editable = false;
                }
                field("HR Cost Per Employee"; (Rec."Total Basis Salary" + Rec."Total Taxable indemnities" + Rec."Total Not Taxable indemnities" + Rec."Mission expenses total" + Rec."Total Supp. Hours" + Rec."Total Charges patronales" + Rec."Taxable indemnities(Not Gross)" / Nvl(Rec."Salary lines", 1)))
                {
                    ApplicationArea = All;
                    captionML = ENU = 'HR Cost Per Employee', FRA = 'Coût RH par salarié';
                    Editable = false;
                }
            }

            group("Absences/Days off")
            {
                CaptionML = ENU = 'Absences/Days off', FRA = 'Absences/Jours fériés';
                field("Employee No. filter4"; Rec."Employee No. filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filtre N° salarié';
                }
                field("Employee posting grp. filter4"; Rec."Employee posting grp. filter")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Filter4"; Rec."Global Dimension 1 Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filtre département';
                }
                field("Global Dimension 2 Filter4"; Rec."Global Dimension 2 Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filtre dossier';
                }
                field("Salary lines4"; Rec."Salary lines")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Abcences"; Rec."Abcences")
                {
                    ApplicationArea = All;
                }
                field("Holidays taken"; Rec."Holidays taken")
                {
                    ApplicationArea = All;
                }
                field("Filter gpe statistic4"; Rec."Statistic Group Filter")
                {
                    ApplicationArea = All;
                }
            }

            group("Loans/Advances")
            {
                CaptionML = ENU = 'Loans/Advances', FRA = 'Prêts/Avances';
                field("Employee No. filter5"; Rec."Employee No. filter")
                {
                    ApplicationArea = All;
                }
                field("Employee posting grp. filter5"; Rec."Employee posting grp. filter")
                {
                    ApplicationArea = All;
                }
                field("Loan & Advance Type filter"; Rec."Loan & Advance Type filter")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Filter5"; Rec."Global Dimension 1 Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filtre département';
                }
                field("Global Dimension 2 Filter5"; Rec."Global Dimension 2 Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Filtre dossier';
                }
                field("Loans repaiment total5"; Rec."Loans repaiment total")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Advances repaiment total5"; Rec."Advances repaiment total")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Disable loan calculation"; Rec."Disable loan calculation")
                {
                    ApplicationArea = All;
                }
                field("Filter gpe statistic5"; Rec."Statistic Group Filter")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Fonction&s")
            {
                CaptionML = ENU = 'Functions', FRA = 'Fonctions';
                action("Extract allowances by type")
                {
                    CaptionML = ENU = 'Extract allowances by type', FRA = 'Extraire les Ind. par type';
                    Image = TeamSales;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        Ind.RESET;
                        CLEAR(PageIndemnity);
                        Header.FINDFIRST;
                        IF PageIndemnity.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            PageIndemnity.GETRECORD(Ind);
                            IndLN.SETRANGE("No.", Header."No.");
                            IndLN.SETRANGE(Indemnity, Ind.Code);
                            PAGE.RUN(PAGE::"WDC Indemnities", IndLN);
                        END;
                    end;
                }
                action(Contributions)
                {
                    CaptionML = ENU = 'Contributions', FRA = 'Cotisations';
                    Image = CancelledEntries;
                    RunObject = Page 55041;
                    ApplicationArea = all;
                }
                action("Import Bonus aid")
                {
                    CaptionML = ENU = 'Import Bonus aid', FRA = 'Import Prime aid';
                    Image = EmployeeAgreement;
                    RunObject = XMLport 55060;
                    ApplicationArea = all;
                }
                action("Import gross Bonus")
                {
                    CaptionML = ENU = 'Import gross Bonus', FRA = 'Import Brut des primes';
                    Image = AdjustEntries;
                    RunObject = XMLport 55052;
                    ApplicationArea = all;
                }
                action("Import Bonus IRPP")
                {
                    CaptionML = ENU = 'Import Bonus IRPP', FRA = 'Import IRPP des primes';
                    Image = Agreement;
                    RunObject = XMLport 55053;
                    ApplicationArea = all;
                }
                // action("Propose Salary Lines")
                // {
                //     CaptionML = ENU = 'Propose Salary Lines', FRA = 'Proposer lignes salaires';
                //     ApplicationArea = all;
                //     Image = GetLines;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     trigger OnAction()
                //     var
                //         lText001: TextConst ENU = 'Worked days et Paid Days ne peuvent pas être null',
                //                             FRA = 'Les jours travaillés et les jours payés ne peuvent pas être nuls';
                //     begin
                //         IF Rec."No." = '' THEN
                //             ERROR(Text001);
                //         IF (Rec."Paid days" = 0) OR (Rec."Worked days" = 0) THEN
                //             ERROR(lText001);

                //         Header.RESET;
                //         Header.SETRANGE("No.", Rec."No.");
                //         IF Header.FINDFIRST THEN
                //             IF Header."Posting Date" = 0D THEN
                //                 ERROR(Text002);

                //         IF Header.FINDFIRST THEN
                //             REPORT.RUNMODAL(REPORT::"Payroll : Fill Payment Form", TRUE, TRUE, Header);

                //         CurrPage.SAVERECORD;
                //         CurrPage.UPDATE(TRUE);
                //     end;
                // }
                action("Calculate Salary Lines")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Calculate Salary Lines', FRA = 'Calculer lignes salaires';
                    Image = Calculate;
                    ShortCutKey = 'Ctrl+F7';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        PayrollCalculatePayment: REPORT "WDC Calculate Payment";
                    begin
                        ProposeSalaries;
                        Salary.RESET;
                        Salary.SETRANGE("No.", 'SIMULATION');
                        IF Salary.FINDFIRST THEN
                            Salary.DELETE(TRUE);
                        COMMIT;
                        Header.RESET;
                        Header.SETRANGE("No.", Rec."No.");
                        IF Header.FINDFIRST THEN begin
                            PayrollCalculatePayment.SetTableView(Header);
                            PayrollCalculatePayment.UseRequestPage(False);
                            PayrollCalculatePayment.Run();
                        end;
                        //REPORT.RUN(REPORT::"Payroll : Calculate Payment", TRUE, TRUE, Header);
                        CurrPage.SAVERECORD;
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                action("Reverse payroll")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Reverse payroll', FRA = 'Paie inverse';
                    Image = CalculateHierarchy;
                    Visible = false;

                    trigger OnAction()
                    var
                        Temp1: Decimal;
                        Temp2: Decimal;
                        w: Dialog;
                        SBDepart: Decimal;
                        NetVoulu: Decimal;
                        Ecart: Decimal;
                        Coef: Decimal;
                    begin
                        CLEAR(Line);
                        CurrPage."Calculation lines".PAGE.GETRECORD(Line);

                        "Management of salary".PaieInverseFeuilleCalcul(Line, Line."Basis salary", Line."Net salary", 1, FALSE);
                    end;
                }

                action("Post payroll")
                {
                    CaptionML = ENU = 'Post payroll', FRA = 'Valider paie';
                    Image = SaveasStandardJournal;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        PayrollPost: Codeunit "WDC Payroll Post";
                    begin
                        IF CONFIRM(MESSG1) THEN BEGIN
                            PayrollPost.PostPayroll(Rec);
                            ManagHours.IntialiserAzeroIndemnite();
                            IF Rec.Month.AsInteger() = 14 THEN BEGIN
                                RECNotes.DELETEALL;
                            END;
                            Rec.DELETE;
                        END ELSE
                            MESSAGE(MESSG2);
                    end;
                }
                action("Update salaries")
                {
                    CaptionML = ENU = 'Update salaries', FRA = 'Mise à jour des salaires';
                    Image = UpdateUnitCost;
                    Visible = false;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        SalaryLines: Record "WDC Salary Lines";
                        RecSaalryLine: Record "WDC Posted Salary Lines";
                        managementOfSalary: Codeunit "WDC Salary Management";
                        SalaryLineSimulation: Record "WDC Salary Lines";
                        Employee: Record 5200;
                    begin
                        SalaryLines.RESET;
                        SalaryLines.SETRANGE(SalaryLines."No.", Rec."No.");
                        SalaryLines.SETRANGE(SalaryLines."Paied days", Rec."Paid days");
                        IF SalaryLines.FINDSET THEN
                            REPEAT
                                RecSaalryLine.RESET;
                                RecSaalryLine.SETRANGE("Employee No.", SalaryLines."Employee No.");
                                RecSaalryLine.SETRANGE("Paied days", Rec."Paid days");
                                RecSaalryLine.SETFILTER(Month, '<%1', Rec.Month);
                                RecSaalryLine.SETRANGE(RecSaalryLine.Year, Rec.Year);
                                IF RecSaalryLine.FINDLAST THEN BEGIN
                                    IF RecSaalryLine."Net salary" <> SalaryLines."Net salary" THEN
                                        managementOfSalary.PaieInverseFeuilleCalcul(SalaryLines, SalaryLines."Basis salary", RecSaalryLine."Net salary", 0, FALSE);
                                END;
                            UNTIL SalaryLines.NEXT = 0;
                        CurrPage.UPDATE;
                    end;
                }
                group("Changer mode paiement")
                {
                    CaptionML = ENU = 'Change payment mode', FRA = 'Changer mode paiement';
                    Image = Change;
                    Visible = false;
                    action(Cash)
                    {
                        CaptionML = ENU = 'Cash', FRA = 'Espèce';
                        ApplicationArea = all;
                        trigger OnAction()
                        begin
                            ModeP := 0;
                            CurrPage."Calculation lines".PAGE.ChangerModePaiement('ESPECE');
                            CurrPage.UPDATE;
                        end;
                    }
                    action(Transfer)
                    {
                        CaptionML = ENU = 'Transfer', FRA = 'Virement';
                        ApplicationArea = all;
                        trigger OnAction()
                        begin
                            ModeP := 2;
                            CurrPage."Calculation lines".PAGE.ChangerModePaiement('VIREMENT');
                            CurrPage.UPDATE;
                        end;
                    }
                    action("Import Don Samedi et autres")
                    {
                        Image = "Action";
                        Promoted = true;
                        RunObject = XMLport 55048;
                        ApplicationArea = all;
                    }
                }
            }
        }
        area(reporting)
        {
            group(Payslip)
            {
                CaptionML = ENU = 'Payslip', FRA = 'Fiche de paie';
                action("Impression  Fiche de Paie")
                {
                    CaptionML = ENU = 'Print payslip', FRA = 'Fiche de paie';
                    Image = PrintVAT;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        CLEAR(Line);
                        NumEmployee := CurrPage."Calculation lines".PAGE.GetEmployeeNo();
                        SalaryLine.SETRANGE("No.", Rec."No.");
                        SalaryLine.SETRANGE("Employee No.", NumEmployee);
                        IF SalaryLine.FINDSET THEN;
                        REPORT.RUN(55005, TRUE, TRUE, SalaryLine);
                    end;
                }
                //     action("Envoi  Fiche de Paie 2 P")
                //     {
                //         Caption = 'Envoi  Fiche de Paie 2 P';
                //         Image = SendElectronicDocument;
                //         Visible = false;

                //         trigger OnAction()
                //         var
                //             lSalaryLine: Record 55023;
                //             lFileName: Text;
                //             lEmployee: Record 5200;
                //             lMail: Codeunit 397;
                //             FileManagement: Codeunit 419;
                //             SMTPMailSetup: Record 409;
                //             SMTPMail: Codeunit Mail;
                //             lFileDirectory: Text;
                //         begin
                //             //<<WDC01
                //             CLEAR(lSalaryLine);
                //             lSalaryLine.SETRANGE("No.", Rec."No.");
                //             IF lSalaryLine.FINDSET THEN BEGIN
                //                 REPEAT
                //                     lEmployee.GET(lSalaryLine."Employee No.");
                //                     IF lEmployee."E-Mail" <> '' THEN BEGIN
                //                         CLEAR(lFileDirectory);
                //                         lFileDirectory := '\\192.168.80.228\Paie\';
                //                         lFileName := lSalaryLine."No." + ' ' + lSalaryLine.Name + '.pdf';
                //                         REPORT.SAVEASPDF(55005, lFileDirectory + lFileName, lSalaryLine);
                //                         SMTPMailSetup.GET;
                //                         SMTPMail.CreateMessage('', SMTPMailSetup."User ID", lEmployee."E-Mail", 'Fiche de paie', '', FALSE);
                //                         SMTPMail.AddAttachment(lFileDirectory + lFileName, lFileName);
                //                         SMTPMail.AppendBody('Objet : Fiche de paie');
                //                         SMTPMail.AppendBody('<br><br>');
                //                         SMTPMail.AppendBody('Sousse le:' + FORMAT(WORKDATE));
                //                         SMTPMail.AppendBody('<br><br>');
                //                         SMTPMail.AppendBody('A l''attention de Mr/Mme:' + ' ' + FORMAT(lEmployee."Last Name") + ' ' + FORMAT(lEmployee."First Name"));
                //                         SMTPMail.AppendBody('<br><br>');
                //                         SMTPMail.AppendBody('Envoyé par   :' + ' ' + USERID);
                //                         SMTPMail.AppendBody('<br><br>');
                //                         SMTPMail.AppendBody('Description :' + Rec.Description);
                //                         SMTPMail.AppendBody('<br><br>');
                //                         SMTPMail.AppendBody('Journal de paie n° :' + ' ' + Rec."No.");
                //                         SMTPMail.AppendBody('<br><br>');
                //                         SMTPMail.Send;
                //                     END;
                //                 UNTIL lSalaryLine.NEXT = 0;
                //                 MESSAGE('Envoi fiche de paie avec succés');
                //             END;
                //             //>>WDC01
                //         end;
                //     }
            }
            group("Payroll Journal")
            {
                CaptionML = ENU = 'Payroll Journal', FRA = 'Journal de paie';
                action("Print Payroll Journal")
                {
                    CaptionML = ENU = 'Print Payroll Journal', FRA = 'Impression Journal de paie';
                    Image = PrintReport;

                    trigger OnAction()
                    begin
                        Header.SETRANGE("No.", Rec."No.");
                        IF Header.FINDSET THEN BEGIN
                            REPORT.RUN(REPORT::"WDC Payroll Journal", TRUE, TRUE, Header);
                        END;
                    end;
                }

                action("Print Payroll Summary")
                {
                    CaptionML = ENU = 'Print Payroll Summary', FRA = 'Récapitulatif de paie';
                    Image = PrintVAT;
                    RunObject = Report 55031;
                    Visible = false;
                }
                // action("Variation des variables") //Hamdi Migration
                // {
                //     Image = PrintVAT;
                //     RunObject = Report "Etat de controle variable paie";
                //     Visible = false;
                // }
            }
            group("Journal de paie 13ième")
            {
                CaptionML = ENU = 'Payroll Journal 13th', FRA = 'Journal de paie 13ième';
                action("Print Payroll Journal 13th")
                {
                    CaptionML = ENU = 'Print Payroll Journal 13th', FRA = 'Impression Journal de paie 13ième';
                    Image = PrintReport;

                    trigger OnAction()
                    begin
                        Header.SETRANGE("No.", Rec."No.");
                        IF Header.FINDSET THEN BEGIN
                            REPORT.RUN(REPORT::"WDC 13th Salary Journal", TRUE, TRUE, Header);
                        END;
                    end;
                }
            }
            group(Payment)
            {
                CaptionML = ENU = 'Payment', FRA = 'Paiement';
                Visible = true;
                action("Print Transfer Order")
                {
                    CaptionML = ENU = 'Print Transfer Order', FRA = 'Impression Ordre de virement';
                    Image = PrintVAT;

                    trigger OnAction()
                    begin
                        Header.SETRANGE("No.", Rec."No.");
                        REPORT.RUNMODAL(55013, TRUE, TRUE, Header);
                    end;
                }
                action("Print Cash Payment")
                {
                    CaptionML = ENU = 'Print Cash Payment', FRA = 'Impression Paiement espèce';
                    Image = PrintReport;

                    trigger OnAction()
                    begin
                        Header.SETRANGE("No.", Rec."No.");
                        REPORT.RUN(55036, TRUE, TRUE, Header);
                    end;
                }
                action("Print Loan & Advance List")
                {
                    CaptionML = ENU = 'Print Loan & Advance List', FRA = 'Liste Prêt et Avance';
                    Image = Account;

                    trigger OnAction()
                    begin
                        RecGLignePrêt.RESET;
                        RecGLignePrêt.SETRANGE("Payment No.", Rec."No.");
                        IF RecGLignePrêt.FINDSET THEN
                            REPORT.RUN(55026, TRUE, FALSE, RecGLignePrêt);
                    end;
                }

                action("Print BIAT Transfer")
                {
                    CaptionML = ENU = 'Print BIAT Transfer', FRA = 'Virement BIAT';
                    Image = BankAccountLedger;

                    trigger OnAction()
                    begin
                        Line.SETRANGE("No.", Rec."No.");
                        XMLPORT.RUN(55051, FALSE, FALSE, Line);
                    end;
                }



            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Rec.Month <> Rec.Month::Prime THEN
            ShowYearOfCalc := FALSE
        ELSE
            ShowYearOfCalc := TRUE;
    end;

    trigger OnInit()
    begin
        Rec.SETFILTER("No.", '<> SIMULATION')
    end;

    trigger OnOpenPage()
    begin
        Test := 0;
        IF Rec.Month <> Rec.Month::Prime THEN
            ShowYearOfCalc := FALSE
        ELSE
            ShowYearOfCalc := TRUE;

        ParamRsh.GET;
        IF Rec."Fortnight Regim" <> '' THEN
            IF RecGRegimesofwork.GET(Rec."Fortnight Regim") THEN
                IF RecGRegimesofwork."Payroll Calculation Type".AsInteger() = 1 THEN
                    ShowQuinzaine := TRUE
                ELSE
                    ShowQuinzaine := FALSE;

        ShowTypePrime := FALSE;
        ShowRegimeQuinzaine := ParamRsh."Activate fortnightly regime";
        ShowQuinzaine := ParamRsh."Activate fortnightly regime";
    end;

    var
        "Management of salary 2": Codeunit "WDC Salary Management 2";
        "Management of salary": Codeunit "WDC Salary Management";
        Header: Record "WDC Salary Header";
        Line: Record "WDC Salary Lines";
        SalaryLine: Record "WDC Salary Lines";
        Test: Integer;
        Ind: Record "WDC Indemnity";
        IndLN: Record "WDC Indemnities";
        Salary: Record "WDC Salary Header";
        ModeP: Option Virement,"Espèse";
        ParamRsh: Record 5218;
        MESSG1: TextConst ENU = 'Warning: Validation cannot be cancelled, do you want to continue?',
                           FRA = 'Attention : La validation ne peut pas être annulée, Voulez vous continuer?';
        MESSG2: TextConst ENU = 'Record cancelled.',
                           FRA = 'Enregistrement annulé.';
        RECNotes: Record "WDC Notes";
        RecGRegimesofwork: Record "WDC work Regimes";
        PageIndemnity: Page "WDC Indemnities List";
        ShowYearOfCalc: Boolean;
        ShowQuinzaine: Boolean;
        ShowTypePrime: Boolean;
        ShowRegimeQuinzaine: Boolean;
        Text001: TextConst ENU = 'Specify the salary calculation sheet number.',
                           FRA = 'Précisez le numéro de la fiche calcul des salaires.';
        Text002: TextConst ENU = 'Specify the posting date.',
                           FRA = 'Précisez la date de comptabilisation.';
        ManagHours: Codeunit "WDC Management of Work Hours";
        "RecGLignePrêt": Record "WDC Loan & Advance Lines";
        NumEmployee: Code[20];

    procedure Nvl(Var1: Decimal; Var2: Decimal) SlrMoyen: Decimal
    begin
        SlrMoyen := Var1;
        IF Var1 = 0 THEN
            SlrMoyen := Var2;
    end;

    procedure ProposeSalaries()
    Var
        lText001: TextConst ENU = 'Worked days et Paid Days ne peuvent pas être null',
                                            FRA = 'Les jours travaillés et les jours payés ne peuvent pas être nuls';
    begin
        IF Rec."No." = '' THEN
            ERROR(Text001);
        IF (Rec."Paid days" = 0) OR (Rec."Worked days" = 0) THEN
            ERROR(lText001);

        Header.RESET;
        Header.SETRANGE("No.", Rec."No.");
        IF Header.FINDFIRST THEN
            IF Header."Posting Date" = 0D THEN
                ERROR(Text002);

        IF Header.FINDFIRST THEN
            REPORT.RUNMODAL(REPORT::"WDC Propose Salaries", TRUE, TRUE, Header);

        CurrPage.SAVERECORD;
        CurrPage.UPDATE(TRUE);
    end;
}

