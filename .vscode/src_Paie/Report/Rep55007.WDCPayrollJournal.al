report 55007 "WDC Payroll Journal"
{
    CaptionML = ENU = 'Payroll Journal', FRA = 'Journal de Paie';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/JournaldePaie.rdlc';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = SORTING("Primary Key")
                                ORDER(Ascending);
            column(Company_Information_Name; Name)
            {
            }
            column(Company_Information_Address; Address)
            {
            }
            column(Company_Information__Address_2_; "Address 2")
            {
            }
            column(City____________Post_Code_; City + ' - ' + "Post Code")
            {
            }
            column(Company_Information__N__CNSS_Employeur_; "Executive Director 2")
            {
            }
            column(Page_____FORMAT__CurrReport_PAGENO_; 'Page : ' + '')
            {
            }
            column(Company_Information__N__CNSS_Employeur_Caption; FIELDCAPTION("Executive Director 2"))
            {
            }
            column(Company_Information_Primary_Key; "Primary Key")
            {
            }
            column(picture; "Company Information".Picture)
            {
            }
            dataitem("Salary Headers"; "WDC Salary Header")
            {
                column(Salary_Headers__Paid_days_; "Paid days")
                {
                }
                column(Salary_Headers__Worked_days_; "Worked days")
                {
                }
                column(Salary_Headers__Last_Date_Modified_; "Last Date Modified")
                {
                }
                column(Salary_Headers_Description; Description)
                {
                }
                column(Salary_Headers__No__; "No.")
                {
                }
                column(Salary_Headers_Month; Month)
                {
                }
                column(Salary_Headers_Year; Year)
                {
                }
                column(Directeur; Directeur)
                {
                }
                column(Nbre_de_personnel____FORMAT_SalLines_COUNT_; 'Nbre de personnel: ' + FORMAT(SalLines.COUNT))
                {
                }
                column(Salary_Headers__Loans_repaiment_total_; "Loans repaiment total")
                {
                    DecimalPlaces = 3 : 3;
                }
                column(Salary_Headers__Advances_repaiment_total_; "Advances repaiment total")
                {
                    DecimalPlaces = 3 : 3;
                }
                column(Salary_Headers__Taxes_total_; "Taxes total")
                {
                    DecimalPlaces = 3 : 3;
                }
                column(Salary_Headers__Net_salary_cashed_; "Net salary cashed")
                {
                    DecimalPlaces = 3 : 3;
                }
                column(Salary_Headers__Total_taxable_; "Total taxable")
                {
                    DecimalPlaces = 3 : 3;
                }
                column(ROUND__Total_taxable__0_001_; ROUND("Total taxable", 0.001))
                {
                    DecimalPlaces = 3 : 3;
                }
                column(ROUND__Taxes_total__0_001_; ROUND("Taxes total", 0.001))
                {
                    DecimalPlaces = 3 : 3;
                }
                column(ROUND__Net_salary_cashed__0_001_; ROUND("Net salary cashed", 0.001))
                {
                    DecimalPlaces = 3 : 3;
                }
                column(Salary_Headers__Retenue_CGC_; '')
                {
                }
                column(Salary_Headers__Salary_basis_total_; "Total Basis Salary")
                {
                    AutoFormatType = 3;
                    DecimalPlaces = 3 : 3;
                }
                column(Salary_Headers__Taxable_indemnities_total_; "Total Taxable indemnities")
                {
                    DecimalPlaces = 3 : 3;
                }
                column(Salary_Headers__Total_Gross_salary_; "Total Gross salary")
                {
                    DecimalPlaces = 3 : 3;
                }
                column(Salary_Headers__Total_Supp__Hours_; "Total Supp. Hours")
                {
                    DecimalPlaces = 3 : 3;
                }
                column(CNS1; CNS1)
                {
                    DecimalPlaces = 3 : 3;
                }
                column(Salary_Headers__No___Control1000000045; "No.")
                {
                }
                column(Salary_Headers_Month_Control1000000046; Month)
                {
                }
                column(Salary_Headers_Year_Control1000000047; Year)
                {
                }
                column(Salary_Headers__Paid_days_Caption; FIELDCAPTION("Paid days"))
                {
                }
                column(Salary_Headers__Worked_days_Caption; FIELDCAPTION("Worked days"))
                {
                }
                column(Salary_Headers__Last_Date_Modified_Caption; FIELDCAPTION("Last Date Modified"))
                {
                }
                column(Salary_Headers_DescriptionCaption; FIELDCAPTION(Description))
                {
                }
                column(Salary_Headers__No__Caption; FIELDCAPTION("No."))
                {
                }
                column(Salary_Headers_MonthCaption; FIELDCAPTION(Month))
                {
                }
                column(Salary_Headers_YearCaption; FIELDCAPTION(Year))
                {
                }
                column(Journal_de_Paie_Caption; Journal_de_Paie_CaptionLbl)
                {
                }
                column("Direction_GénéraleCaption"; Direction_GénéraleCaptionLbl)
                {
                }
                column("Prêts_Caption"; Prêts_CaptionLbl)
                {
                }
                column(Avances_Caption; Avances_CaptionLbl)
                {
                }
                column("Total_Impôt_Caption"; Total_Impôt_CaptionLbl)
                {
                }
                column("Total_Net_perçu_Caption"; Total_Net_perçu_CaptionLbl)
                {
                }
                column(Salaires_imposables__Caption; Salaires_imposables__CaptionLbl)
                {
                }
                column(Retenu_CGC_Caption; Retenu_CGC_CaptionLbl)
                {
                }
                column(Salaires_bruts_Caption; Salaires_bruts_CaptionLbl)
                {
                }
                column(Salaire_de_base_Caption; Salaire_de_base_CaptionLbl)
                {
                }
                column(Ind__Imposable_Caption; Ind__Imposable_CaptionLbl)
                {
                }
                column(Heures_Sup__Caption; Heures_Sup__CaptionLbl)
                {
                }
                column(C_N_S_S_Caption; C_N_S_S_CaptionLbl)
                {
                }
                column(TotalisationCaption; TotalisationCaptionLbl)
                {
                }
                column(Salary_Headers__No___Control1000000045Caption; FIELDCAPTION("No."))
                {
                }
                column(Salary_Headers_Month_Control1000000046Caption; FIELDCAPTION(Month))
                {
                }
                column(Salary_Headers_Year_Control1000000047Caption; FIELDCAPTION(Year))
                {
                }
                column(Afficher; Afficher)
                {
                }
                dataitem("Salary Lines"; "WDC Salary Lines")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemTableView = SORTING("Employee Posting Group")
                                        ORDER(Ascending);
                    column(CAVIS; 0)
                    {
                    }
                    column(FORMAT_Month___________FORMAT_Year_; FORMAT(Month) + '  ' + FORMAT(Year))
                    {
                    }
                    column(Salary_Lines__Posting_Date_; "Posting Date")
                    {
                    }
                    column("Groupe_compta__salarié______________Employee_Posting_Group_"; 'Groupe compta. salarié : ' + ' ' + "Employee Posting Group")
                    {
                    }
                    column(Salary_Lines_Name; Name)
                    {
                    }
                    column(Salary_Lines__Taxable_indemnities_; "Taxable indemnities")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Supp__hours_; "Supp. hours")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(RealSalBasis; Realbasissalary)
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Gross_Salary_; "Gross Salary")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(ROUND__Non_Taxable_Soc__Contrib___0_001_; ROUND("Non Taxable Soc. Contrib.", 0.001))
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Taxable_salary_; "Taxable salary")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Taxe__Month__; "Taxe (Month)")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines_Loans; Loans)
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines_Advances; Advances)
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Net_salary_cashed_; "Net salary cashed")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines_Employee; "Employee No.")
                    {
                    }
                    column(Salary_Lines__Retenue_CGC_; '')
                    {
                    }
                    column(DeductionCOVID_SalaryLines; 0)
                    {
                    }
                    column(Salary_Lines__Real_basis_salary__Control1180250088; "Real basis salary")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Taxable_indemnities__Control1180250089; "Taxable indemnities")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Supp__hours__Control1180250093; "Supp. hours")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Taxable_salary__Control1180250096; "Taxable salary")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Taxe__Month___Control1180250097; "Taxe (Month)")
                    {
                        AutoFormatType = 0;
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines_Loans_Control1180250106; Loans)
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines_Advances_Control1180250107; Advances)
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Net_salary_cashed__Control1180250109; "Net salary cashed")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Gross_Salary__Control1180250110; "Gross Salary")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Total________Employee_Posting_Group_; 'Total : ' + "Employee Posting Group")
                    {
                    }
                    column(Salary_Lines__Non_Taxable_Soc__Contrib__; "Non Taxable Soc. Contrib.")
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(ROUND__Non_Taxable_Soc__Contrib___0_001__Control1120006; ROUND("Non Taxable Soc. Contrib.", 0.001))
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Salary_Lines__Retenue_CGC__Control1000000010; '')
                    {
                    }
                    column("Heures_supplém_Caption"; Heures_supplém_CaptionLbl)
                    {
                    }
                    column("Indemnités_imposablesCaption"; Indemnités_imposablesCaptionLbl)
                    {
                    }
                    column(Salaire_de_baseCaption; Salaire_de_baseCaptionLbl)
                    {
                    }
                    column(EmployeeCaption; EmployeeCaptionLbl)
                    {
                    }
                    column(EmployeeCaption_Control1000000077; EmployeeCaption_Control1000000077Lbl)
                    {
                    }
                    column(Journal_de_Paie_Caption_Control1000000035; Journal_de_Paie_Caption_Control1000000035Lbl)
                    {
                    }
                    column(Salaire_BrutCaption; Salaire_BrutCaptionLbl)
                    {
                    }
                    column(C_N_S_SCaption; C_N_S_SCaptionLbl)
                    {
                    }
                    column(Salaire_ImposableCaption; Salaire_ImposableCaptionLbl)
                    {
                    }
                    column(I_R_P_PCaption; I_R_P_PCaptionLbl)
                    {
                    }
                    column("PrêtsCaption"; PrêtsCaptionLbl)
                    {
                    }
                    column(AvancesCaption; AvancesCaptionLbl)
                    {
                    }
                    column(C_G_CCaption; C_G_CCaptionLbl)
                    {
                    }
                    column("Salaire_net_perçueCaption"; Salaire_net_perçueCaptionLbl)
                    {
                    }
                    column(Salary_Lines_No_; "No.")
                    {
                    }
                    column(Salary_Lines_Employee_Posting_Group; "Employee Posting Group")
                    {
                    }
                    column(LineCount; LineCount)
                    {
                    }
                    column(Commision; MontantCommision)
                    {
                    }
                    column(CSS; "CSS Tax")
                    {
                    }
                    column(ACCORD_2021; ACCORD_2021)
                    {
                    }
                    column(AUG_2021; AUG_2021)
                    {
                    }
                    column(A_PRIME; A_PRIME)
                    {
                    }
                    column(P_KBE; P_KBE)
                    {
                    }
                    column(P_REND; P_REND)
                    {
                    }
                    column(I_FONC; I_FONC)
                    {
                    }
                    column(I_PANIER; I_PANIER)
                    {
                    }
                    column(I_PRES; I_PRES)
                    {
                    }
                    column(I_TRAN; I_TRAN)
                    {
                    }
                    column(P_KBETRS; P_KBETRS)
                    {
                    }
                    column(D_SAM; D_SAM)
                    {
                    }
                    column(J_SUPP; J_SUPP)
                    {
                    }
                    column(I_VOIT; I_VOIT)
                    {
                    }
                    column(I_Essence; I_Essence)
                    {
                    }
                    column(Assurance; Assurance)
                    {
                    }
                    column(Bus; Bus)
                    {
                    }
                    column(Shems; Shems)
                    {
                    }
                    column("Téléphone"; Phone)
                    {
                    }
                    column(Voiture; Car)
                    {
                    }
                    column(DSAM; DSAM)
                    {
                    }
                    column(Matricule; GEmployee."No.")
                    {
                    }
                    column(SituationFam; FORMAT(GEmployee."Family Situation A"))
                    {
                    }
                    column(nombreEnfant; GEmployee."Loaded childs")
                    {
                    }
                    column(Nom; GEmployee."First Name" + ' ' + GEmployee."Last Name")
                    {
                    }
                    column(Fonction; GEmployee.Title)
                    {
                    }
                    column("Catégorie"; FORMAT(GEmployee.College) + FORMAT(GEmployee.Scale) + '  ' + FORMAT(GEmployee.Echelon))
                    {
                    }
                    column(HorsGrille; GEmployee."Hors Grille")
                    {
                    }
                    column(THJP; THJP)
                    {
                    }
                    column(THJE; THJE)
                    {
                    }
                    column(JFER; JFER)
                    {
                    }
                    column(RetPlus; "Retirement plus")
                    {
                    }
                    column(C_PAYE; C_PAYE)
                    {
                    }
                    column(INDNCOT; INDNCOT)
                    {
                    }
                    column(HS25; HS25)
                    {
                    }
                    column(HS50; HS50)
                    {
                    }
                    column(HS; HS)
                    {
                    }
                    column(CP; CP)
                    {
                    }
                    column(JourSupp; JourSupp)
                    {
                    }
                    column(MontantJourF; "Public Holiday Amount")
                    {
                    }
                    column(IndAidKebirC; I_AKEBIRC)
                    {
                    }
                    column(DonNaissance; D_NAI)
                    {
                    }
                    column(DonMarriage; D_MAR)
                    {
                    }
                    column(DonAidFitr; D_AFITR)
                    {
                    }
                    column(DonAidKebir; D_AKEBIR)
                    {
                    }
                    column(DonrentSco; D_RENTSCO)
                    {
                    }
                    column(SalBrutSIVP; SalBrutSIVP)
                    {
                    }
                    column(Mensuel; Mensuel)
                    {
                    }
                    column(PretCNSS; PretCNSS)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        RecSocialContributions.RESET;
                        CAV := 0;
                        CNS := 0;
                        CUMCNS := 0;
                        RecSocialContributions.SETRANGE("No.", "No.");
                        RecSocialContributions.SETRANGE("Employee No.", "Employee No.");
                        RecSocialContributions.SETFILTER("Social Contribution", '%1|%2', 'COT001', 'COT002');
                        IF RecSocialContributions.FINDFIRST THEN
                            CNS := RecSocialContributions."Real Amount : Employee";

                        //Code section
                        // CurrReport.SHOWOUTPUT(OP = OP::JP);
                        CNS1 := CNS1 + "Non Taxable Soc. Contrib.";
                        compteur := compteur + 1;
                        //
                        MontantCommision := 0;
                        Commision.RESET;
                        Commision.SETRANGE("Employee No.", "Salary Lines"."Employee No.");
                        Commision.SETRANGE(Indemnity, 'G112');
                        IF Commision.FINDSET THEN
                            MontantCommision := Commision."Real Amount";
                        //
                        //>>WDC01
                        GEmployee.GET("Employee No.");
                        Mensuel := '';
                        IF GEmployee."Employee type" = GEmployee."Employee type"::"Hour based" THEN
                            Mensuel := 'H'
                        ELSE
                            Mensuel := 'M';
                        GEmployee.CALCFIELDS("Loaded childs");
                        //GEmployee.CALCFIELDS("Job Title");
                        A_PRIME := 0;
                        P_KBE := 0;
                        P_REND := 0;
                        I_FONC := 0;
                        I_PANIER := 0;
                        I_PRES := 0;
                        I_TRAN := 0;
                        I_VOIT := 0;
                        P_KBETRS := 0;
                        ACCORD_2021 := 0;
                        AUG_2021 := 0;
                        I_AKEBIRC := 0;
                        D_MAR := 0;
                        D_NAI := 0;
                        C_PAYE := 0;
                        THJP := 0;
                        THJE := 0;
                        JFER := 0;
                        HJFER := 0;
                        HS := 0;
                        CP := 0;
                        D_SAM := 0;
                        J_SUPP := 0;
                        INDNCOT := 0;
                        HS25 := 0;
                        HS50 := 0;
                        I_AKEBIRC := 0;
                        D_AFITR := 0;
                        D_AKEBIR := 0;
                        D_RENTSCO := 0;
                        SalBrutSIVP := 0;
                        I_Essence := 0;
                        Realbasissalary := "Real basis salary";
                        CLEAR(GIndemnities);
                        GIndemnities.SETRANGE("No.", "Salary Lines"."No.");
                        GIndemnities.SETRANGE("Employee No.", "Salary Lines"."Employee No.");
                        GIndemnities.SETFILTER("Real Amount", '<>%1', 0);
                        IF GIndemnities.FINDSET THEN
                            REPEAT
                                IF ((GIndemnities.Indemnity = 'ACCORD 2021') OR (GIndemnities.Indemnity = 'ACC 2021')) AND (GIndemnities."Real Amount" <> 0) THEN ACCORD_2021 := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'AUG  20-21') AND (GIndemnities."Real Amount" <> 0) THEN AUG_2021 := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'D.MAR') AND (GIndemnities."Real Amount" <> 0) THEN D_MAR := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'D.NAISS') AND (GIndemnities."Real Amount" <> 0) THEN D_NAI := GIndemnities."Real Amount";

                                IF (GIndemnities.Indemnity = 'P.KBE') AND (GIndemnities."Real Amount" <> 0) THEN P_KBE := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'P.REND') AND (GIndemnities."Real Amount" <> 0) THEN P_REND := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'A.PRIME') AND (GIndemnities."Real Amount" <> 0) THEN A_PRIME := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'P.KBETRS') AND (GIndemnities."Real Amount" <> 0) THEN P_KBETRS := GIndemnities."Real Amount";

                                IF (GIndemnities.Indemnity = 'I.FONC') AND (GIndemnities."Real Amount" <> 0) THEN I_FONC := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'I.PANIER') AND (GIndemnities."Real Amount" <> 0) THEN I_PANIER := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'I.PRES') AND (GIndemnities."Real Amount" <> 0) THEN I_PRES := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'I.TRAN') AND (GIndemnities."Real Amount" <> 0) THEN I_TRAN := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'I.A KEBIRC') AND (GIndemnities."Real Amount" <> 0) THEN I_AKEBIRC := GIndemnities."Real Amount";

                                IF (GIndemnities.Indemnity = 'I.FONC') AND (GIndemnities."Real Amount" <> 0) THEN I_FONC := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'I.PANIER') AND (GIndemnities."Real Amount" <> 0) THEN I_PANIER := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'I.PRES') AND (GIndemnities."Real Amount" <> 0) THEN I_PRES := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'I.TRAN') AND (GIndemnities."Real Amount" <> 0) THEN I_TRAN := GIndemnities."Real Amount";


                                IF (GIndemnities.Indemnity = 'D.A FITR') AND (GIndemnities."Real Amount" <> 0) THEN D_AFITR := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'D.A KEBIR') AND (GIndemnities."Real Amount" <> 0) THEN D_AKEBIR := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'D.RENT SCO') AND (GIndemnities."Real Amount" <> 0) THEN D_RENTSCO := GIndemnities."Real Amount";

                                IF (GIndemnities.Indemnity = 'C.PAYE') AND (GIndemnities."Real Amount" <> 0) THEN C_PAYE := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'D.SAM') AND (GIndemnities."Real Amount" <> 0) THEN D_SAM := GIndemnities."Real Amount";
                                IF (GIndemnities.Indemnity = 'J.SUPP') AND (GIndemnities."Real Amount" <> 0) THEN J_SUPP := GIndemnities."Real Amount";

                                IF (GIndemnities.Indemnity = 'I.ESSENCE') AND (GIndemnities."Real Amount" <> 0) THEN I_Essence := GIndemnities."Real Amount";

                                IF (GIndemnities.Indemnity = 'I.VOIT') AND (GIndemnities."Real Amount" <> 0) THEN I_VOIT := GIndemnities."Real Amount";



                                IF (GIndemnities.Type.AsInteger() = 2) AND (GIndemnities."Real Amount" <> 0) THEN INDNCOT += GIndemnities."Real Amount";
                            UNTIL GIndemnities.NEXT = 0;
                        //<<WDC01
                        CLEAR(PretCNSS);
                        CLEAR(RecLoan);
                        RecLoan.SETRANGE("Payment No.", "No.");
                        RecLoan.SETRANGE("Employee No.", "Employee No.");
                        RecLoan.SETRANGE(Type, RecLoan.Type::Loan);
                        RecLoan.SETRANGE("Document type", 'PRETCNSS');
                        IF RecLoan.FINDSET THEN
                            REPEAT
                                PretCNSS += RecLoan."Line Amount";
                            UNTIL RecLoan.NEXT = 0;

                        //>>WDC02
                        Realbasissalary := "Real basis salary";
                        IF GEmployee."Employee type".AsInteger() = 0 THEN BEGIN
                            CLEAR(HeureTrav);
                            HeureTrav.SETRANGE("Employee No.", "Employee No.");
                            HeureTrav.SETRANGE(HeureTrav."Payment No.", "No.");
                            HeureTrav.SETRANGE("Payment Month", Month);
                            HeureTrav.SETRANGE("Payment Year", Year);
                            IF HeureTrav.FINDSET THEN BEGIN
                                THJP := HeureTrav."Hours Number";
                                JFER := HeureTrav."Pulic Holiday Days" * 8;
                            END;
                            CLEAR(Absence);
                            Absence.SETRANGE("Employee No.", "Employee No.");
                            Absence.SETRANGE("Payment No.", "No.");
                            Absence.SETRANGE("Posting month", Month);
                            Absence.SETRANGE("Posting year", Year);
                            Absence.SETRANGE("Line type", Absence."Line type"::"Day off Consumption");
                            IF Absence.FINDSET THEN BEGIN
                                CP := Absence.Quantity * 8;
                            END;
                        END
                        ELSE
                            IF GEmployee."Employee type".AsInteger() = 1 THEN BEGIN
                                THJP := "Salary Lines"."Paied days";
                                CLEAR(HeureTrav);
                                HeureTrav.SETRANGE("Employee No.", "Employee No.");
                                HeureTrav.SETRANGE(HeureTrav."Payment No.", "No.");
                                HeureTrav.SETRANGE("Payment Month", Month);
                                HeureTrav.SETRANGE("Payment Year", Year);
                                IF HeureTrav.FINDSET THEN BEGIN
                                    JFER := HeureTrav."Pulic Holiday Days";
                                END;
                                CLEAR(Absence);
                                Absence.SETRANGE("Employee No.", "Employee No.");
                                Absence.SETRANGE("Payment No.", "No.");
                                Absence.SETRANGE("Posting month", Month);
                                Absence.SETRANGE("Posting year", Year);
                                Absence.SETRANGE("Line type", Absence."Line type"::"Day off Consumption");
                                IF Absence.FINDSET THEN BEGIN
                                    CP := Absence.Quantity;
                                END;
                                JourSupp := 0;
                                RecIndemJS.RESET;
                                RecIndemJS.SETRANGE("Employee No.", "Employee No.");
                                RecIndemJS.SETRANGE("No.", "No.");
                                RecIndemJS.SETFILTER(Indemnity, '%1', 'J.SUPP');
                                IF RecIndemJS.FINDSET THEN
                                    JourSupp := RecIndemJS."Days Number"
                                ELSE
                                    JourSupp := 0;

                            END;
                        THJE := THJP + JFER + CP + JourSupp;
                        CLEAR(HeureSupp);
                        HeureSupp.SETRANGE("Employee No.", "Employee No.");
                        HeureSupp.SETRANGE("Payment No.", "No.");
                        HeureSupp.SETRANGE("Payment Month", Month);
                        HeureSupp.SETRANGE("Payment Year", Year);
                        IF HeureSupp.FINDSET THEN
                            REPEAT
                                IF HeureSupp."Overtime Rate" = 0 THEN HS += HeureSupp."Line amount";
                                IF HeureSupp."Overtime Rate" = 0.25 THEN HS25 += HeureSupp."Line amount";
                                IF HeureSupp."Overtime Rate" = 0.5 THEN HS50 += HeureSupp."Line amount";
                            UNTIL HeureSupp.NEXT = 0;
                        IF ROUND("Non Taxable Soc. Contrib.", 0.001) = 0 THEN
                            SalBrutSIVP := "Gross Salary"
                        ELSE
                            SalBrutSIVP := 0;

                        //<<WDC02
                    end;
                }
                dataitem(DataItem5879; 55007)
                {
                    DataItemLink = "Employee No." = FIELD("No.");
                    DataItemTableView = SORTING("Employee Posting Group", Type, "No.", "Employee No.")
                                        ORDER(Ascending);
                }
                dataitem(DataItem7980; 55033)
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemTableView = SORTING("No.", "Employee No.", Indemnity, "Social Contribution")
                                        ORDER(Ascending);
                }
                dataitem(DataItem4143; 55013)
                {
                    DataItemLink = "Payment No." = FIELD("No.");
                    DataItemTableView = SORTING("Document type")
                                        ORDER(Ascending);

                    trigger OnPreDataItem()
                    begin
                        //CurrReport.CREATETOTALS ("Loan & Advance Lines"."Line Amount");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Afficher := TRUE;
                    IF Month.AsInteger() > 12 THEN Afficher := FALSE;
                end;

                trigger OnPostDataItem()
                begin
                    //  CurrReport.SHOWOUTPUT(OP = OP::JP);
                    HumanR.GET();
                    //Directeur :=HumanR."Directeur général" ;
                    SalLines.SETFILTER("No.", "Salary Headers"."No.");
                end;
            }

            trigger OnPreDataItem()
            begin
                CALCFIELDS(Picture);
            end;
        }
    }


    trigger OnInitReport()
    begin
        PrintStatPages := TRUE;
        SalLines.FINDFIRST;
        LineCount := 0;
    end;

    trigger OnPreReport()
    begin
        compteur := 0;
    end;

    var
        PrintStatPages: Boolean;
        OP: Option JP,JPC;
        CAV: Decimal;
        CNS: Decimal;
        CNS1: Decimal;
        RecSocialContributions: Record "WDC Social Contributions";
        RecSocialContributions1: Record "WDC Social Contributions";
        compteur: Integer;
        Directeur: Text[30];
        HumanR: Record "Human Resources Setup";
        CUMCNS: Decimal;
        SalLines: Record "WDC Salary Header";
        Journal_de_Paie_CaptionLbl: Label 'Journal de Paie ';
        "Direction_GénéraleCaptionLbl": Label 'Direction Générale';
        "Prêts_CaptionLbl": Label 'Prêts:';
        Avances_CaptionLbl: Label 'Avances:';
        "Total_Impôt_CaptionLbl": Label 'Total Impôt:';
        "Total_Net_perçu_CaptionLbl": Label 'Total Net perçu:';
        Salaires_imposables__CaptionLbl: Label 'Salaires imposables :';
        Retenu_CGC_CaptionLbl: Label 'Retenu CGC:';
        Salaires_bruts_CaptionLbl: Label 'Salaires bruts:';
        Salaire_de_base_CaptionLbl: Label 'Salaire de base:';
        Ind__Imposable_CaptionLbl: Label 'Ind. Imposable:';
        Heures_Sup__CaptionLbl: Label 'Heures Sup.:';
        C_N_S_S_CaptionLbl: Label 'C.N.S.S:';
        TotalisationCaptionLbl: Label 'Totalisation';
        "Heures_supplém_CaptionLbl": Label 'Heures supplém.';
        "Indemnités_imposablesCaptionLbl": Label 'Indemnités imposables';
        Salaire_de_baseCaptionLbl: Label 'Salaire de base';
        EmployeeCaptionLbl: Label 'Employee';
        EmployeeCaption_Control1000000077Lbl: Label 'Employee';
        Journal_de_Paie_Caption_Control1000000035Lbl: Label 'Journal de Paie ';
        Salaire_BrutCaptionLbl: Label 'Salaire Brut';
        C_N_S_SCaptionLbl: Label 'C.N.S.S';
        Salaire_ImposableCaptionLbl: Label 'Salaire Imposable';
        I_R_P_PCaptionLbl: Label 'I.R.P.P';
        "PrêtsCaptionLbl": Label 'Prêts';
        AvancesCaptionLbl: Label 'Avances';
        C_G_CCaptionLbl: Label 'C.G.C';
        "Salaire_net_perçueCaptionLbl": Label 'Salaire net perçue';
        LineCount: Integer;
        Commision: Record "WDC Indemnities";
        MontantCommision: Decimal;
        A_PRIME: Decimal;
        P_KBE: Decimal;
        P_REND: Decimal;
        I_FONC: Decimal;
        I_PANIER: Decimal;
        I_PRES: Decimal;
        I_TRAN: Decimal;
        P_KBETRS: Decimal;
        ACCORD_2021: Decimal;
        AUG_2021: Decimal;
        GIndemnities: Record "WDC Indemnities";
        C_PAYE: Decimal;
        GEmployee: Record Employee;
        THJP: Decimal;
        THJE: Decimal;
        HeureTrav: Record "WDC Occasional Hours Recorded";
        JFER: Decimal;
        Absence: Record "WDC Employee's days off Entry";
        CP: Decimal;
        HJFER: Decimal;
        Realbasissalary: Decimal;
        INDNCOT: Decimal;
        HS25: Decimal;
        HS50: Decimal;
        HeureSupp: Record "WDC Overtime hours recorded m";
        HS: Decimal;
        D_MAR: Decimal;
        D_NAI: Decimal;
        I_AKEBIRC: Decimal;
        D_AFITR: Decimal;
        D_AKEBIR: Decimal;
        D_RENTSCO: Decimal;
        SalBrutSIVP: Decimal;
        D_SAM: Decimal;
        J_SUPP: Decimal;
        JourSupp: Decimal;
        IndemJS: Record "WDC Default Indemnities";
        Mensuel: Code[1];
        Afficher: Boolean;
        I_VOIT: Decimal;
        I_Essence: Decimal;
        RecIndemJS: Record "WDC Indemnities";
        PretCNSS: Decimal;
        RecLoan: Record "WDC Loan & Advance Lines";
}

