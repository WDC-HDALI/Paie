codeunit 55030 "WDC Salary Management 2"
{

    procedure CalculerLignePRIMEWDC(SalaryLine: Record "WDC Salary Lines";
     SolderDroitCongé: Boolean; Sim: Option Simulation,Real; nbjsolder: Decimal): Decimal;
    //>>WDCPrime rendement
    Var
        SalaryHeader: Record "WDC Salary Header";
        Ind: Record "WDC Indemnities";
        SocialContributions: Record "WDC Social Contributions";
        ParamRessHum: Record "Human Resources Setup";
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        Employee: Record Employee;
        temp: Decimal;
        tmp: Decimal;
        tmp1: Decimal;
        ChefFamille: Decimal;
        deductionChef: Decimal;
        EMP1: Record Employee;
        DateFin: Date;
        TableauAmortissementPret: Record "WDC Tablau amortissement prêt";
        MontantPretAmmortissement: Decimal;
        TotImpot: Decimal;
        Cot: Record "WDC Default Soc. Contribution";
        DateDeb: Date;
        NbrPaieEmployee: Decimal;
        nbr: Decimal;
        bonus: Decimal;
        SalLineEng: Record "WDC Posted Salary Lines";
        SalLineEngTmp: Record "WDC Posted Salary Lines";
        SalLineEngTmp2: Record "WDC Posted Salary Lines";
        DecGJourSupp: Decimal;
        DecGJourConge: Decimal;
        DecGHeureNormal: Decimal;
        DecGHeureConge: Decimal;
        DecGHeureSupp: Decimal;
        DecGNBJourAN: Decimal;
        DecGNBHeureAN: Decimal;
        SoldeReport: Decimal;
        DecMontantIdem: Decimal;
        DecGJournuit: Decimal;
        DecGheurenuit: Decimal;
        NBmoisTravaille: Decimal;
        PourcentagePrésence: Decimal;
        Lnote: Decimal;
        LPourcentage: Decimal;
        LPourcentagePrésence: Decimal;
    Begin
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
        initLigne(SalaryLine, Sim);
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
        LPourcentagePrésence := 100;
        Ind.RESET;
        Ind.SETRANGE("No.", SalaryHeader."No.");
        Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
        IF Ind.FINDSET THEN
            Ind.DELETEALL;
        //>>WDCPRIME A Modifier pour Gratifification

        SalaryLine.Purcent := LPourcentage;
        SalaryLine.Note := Lnote;
        SalaryLine."Basis salary" := Employee."Brut prime";
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
        CalcCotisationSocial1(SalaryLine);
        SalaryLine.MODIFY;
        CalcAllTaxe(SalaryLine);
        CalcCotisationSocial2(SalaryLine);
        SalaryLine.MODIFY;
        BEGIN
            //--> Calcul de l'imposable réel
            IF EmploymentContract.Taxable THEN BEGIN
                Gemployee.GET(SalaryLine."Employee No.");  //WDC01
                SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib."
                                                 - SalaryLine."Retirement plus", ParamCpta."Amount Rounding Precision");//WDC01
                SalLineEng.RESET;
                SalLineEng.SETCURRENTKEY(Year, "Employee No.", "No.");
                SalLineEng.SETFILTER(Year, '%1', SalaryLine.Year);
                SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
                IF SalLineEng.FIND('+') THEN
                    SalaryLine."Taxable salary PR" := SalLineEng."Taxable salary"
                ELSE
                    SalaryLine."Taxable salary PR" := SalLineEngTmp2."Taxable salary PR";

                IF Employee."Family chief" THEN BEGIN
                    SalaryLine."Deduction Family Chief" := ROUND(ParamRessHum."Deduction for Familly Chief" / 14, //2112
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
            SalLineEng.SETFILTER(Year, '%1', SalaryLine.Year);
            SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEng.SETFILTER(Imposable, '%1', TRUE);
            //>> CSS
            SalLineEng.CALCSUMS("Real taxable", "Taxe (Month)", "Taxable salary", "CSS Tax"); //WDCREGUL REMPLACEMENT "Monthly CSS Tax"
            SalaryLine."Total CSS Tax Recorded" := SalLineEng."CSS Tax";//WDCREGUL REMPLACEMENT "Monthly CSS Tax"
                                                                        //<< CSS
            SalaryLine."Total taxable rec." := SalLineEng."Real taxable";
            SalaryLine."Total taxes rec." := SalLineEng."Taxe (Month)";
            SalaryLine."Rec. payments" := 0;
            SalLineEngTmp.RESET;
            SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Imposable);
            SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEngTmp.SETFILTER(Year, '%1', SalaryLine.Year);
            SalLineEng.SETFILTER(Imposable, '%1', TRUE);
            SalLineEngTmp.SETFILTER(Month, '<%1', 12);
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
            CalcImpotAn(SalaryLine);
            CalcImpotAnCSS(SalaryLine);
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


            IF Sim = 1 THEN
                IF SalaryHeader."Disable loan calculation" = FALSE THEN
                    MgmtofLoansandAdvances.CreateRepaymentLine(SalaryLine);
            SalaryLine."Net salary cashed" := SalaryLine."Net salary"
                                                           - SalaryLine.Loans
                                                           - SalaryLine.Advances
                                                           - Ind."Real Amount"
                                                           - SalaryLine."Amount retained cash FS";
            IF SalaryLine."Net salary cashed" < 0 THEN
                MESSAGE(Text002, SalaryLine."Employee No.");
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
                DeleteLine(SalaryLine)
            ELSE
                SalaryLine.MODIFY;
            EXIT(SalaryLine."Net salary");
        END;
        //FIN WDC PRIME
    End;


    procedure DeleteLine(var SalaryLine: Record "WDC Salary Lines")
    var
        Indemnities: Record "WDC Indemnities";
        SocialContribution: Record "WDC Social Contributions";
        LoanAdvanceLines: Record "WDC Loan & Advance Lines";
    begin
        Indemnities.SETRANGE("No.", SalaryLine."No.");
        Indemnities.SETRANGE("Employee No.", SalaryLine."Employee No.");
        IF Indemnities.FINDFIRST THEN
            Indemnities.DELETEALL;

        SocialContribution.SETRANGE("No.", SalaryLine."No.");
        SocialContribution.SETRANGE("Employee No.", SalaryLine."Employee No.");
        IF SocialContribution.FINDFIRST THEN
            SocialContribution.DELETEALL;

        LoanAdvanceLines.SETRANGE("Payment No.", SalaryLine."No.");
        LoanAdvanceLines.SETRANGE("Employee No.", SalaryLine."Employee No.");
        LoanAdvanceLines.SETRANGE(Paid, FALSE);
        IF LoanAdvanceLines.FINDFIRST THEN
            LoanAdvanceLines.DELETEALL;

        SalaryLine.DELETE;
    end;



    procedure CalcCotisationSocial1(var SalaryLine: Record "WDC Salary Lines")
    var
        Ind: Record "WDC Indemnities";
        SocialContributions: Record "WDC Social Contributions";
        ParamRessHum: Record "Human Resources Setup";
        temp: Decimal;
        tmp: Decimal;
        tmp1: Decimal;
        bonus: Decimal;
        Cot: Record "WDC Default Soc. Contribution";
        nbr: Decimal;
        LigSalEng: Record "WDC Salary Lines";
        SocialCont: Record "WDC Rec. Social Contributions";
        RecDefaultIndemnities: Record "WDC Default Indemnities";
        LigSalEng1: Record "WDC Salary Lines";
    begin
        //--> Calcul des cotisations sociales

        SocialContributions.SETRANGE("No.", SalaryLine."No.");
        SocialContributions.SETRANGE("Employee No.", SalaryLine."Employee No.");
        IF SocialContributions.FINDFIRST THEN
            REPEAT

                CASE SocialContributions."Evaluation Mode".AsInteger() OF
                    0:
                        BEGIN // Montant = Base * Taux
                            IF SocialContributions.Indemnity = ''
                             THEN BEGIN
                                Cot.RESET;
                                Cot.SETRANGE("Emplymt. Contract Code", SalaryLine."Emplymt. Contract Code");
                                Cot.SETRANGE("Social Contribution Code", SocialContributions."Social Contribution");
                                IF NOT Cot.FINDFIRST THEN
                                    ERROR(Text001,
                                           Cot."Social Contribution Code", Cot."Emplymt. Contract Code");
                                CASE Cot."Basis of calculation".AsInteger() OF
                                    0:
                                        IF Cot."Active Max" THEN BEGIN

                                            IF SalaryLine."Gross Salary" > 6000 THEN BEGIN
                                                SocialContributions."Base Amount" := ROUND(6000, ParamCpta."Amount Rounding Precision");
                                            END ELSE BEGIN
                                                SocialContributions."Base Amount" := ROUND(SalaryLine."Gross Salary", ParamCpta."Amount Rounding Precision");
                                            END;
                                        END ELSE BEGIN
                                            SocialContributions."Base Amount" := ROUND(SalaryLine."Gross Salary", ParamCpta."Amount Rounding Precision");

                                        END;
                                    2:
                                        BEGIN
                                            SocialContributions."Base Amount" := ROUND(SalaryLine."Basis salary", ParamCpta."Amount Rounding Precision");


                                            //>>MBY 19/02/2010 ENDA
                                            RecDefaultIndemnities.RESET;
                                            RecDefaultIndemnities.SETRANGE("Emplymt. Contract Code", SalaryLine."Emplymt. Contract Code");
                                            RecDefaultIndemnities.SETRANGE("Included in Insurance Base", TRUE);
                                            IF RecDefaultIndemnities.FINDFIRST THEN
                                                REPEAT
                                                    SocialContributions."Base Amount" := ROUND(SocialContributions."Base Amount" + RecDefaultIndemnities.
                                     "Default amount"
                                                                                           , ParamCpta."Amount Rounding Precision");

                                                UNTIL RecDefaultIndemnities.NEXT = 0
                                            //<<MBY 19/02/2010 ENDA
                                        END;
                                    1:
                                        BEGIN
                                            // NE cotisation
                                            SocialCont.RESET;
                                            SocialCont.SETCURRENTKEY("Social Contribution", "Employee No.", "Calculate Year");
                                            SocialCont.SETFILTER("Social Contribution", SocialContributions."Social Contribution");
                                            SocialCont.SETFILTER("Employee No.", SalaryLine."Employee No.");
                                            SocialCont.SETRANGE("Calculate Year", SalaryLine."Calculate Year");
                                            SocialCont.CALCSUMS("Base Amount");

                                            LigSalEng.RESET;
                                            LigSalEng.SETCURRENTKEY("Employee No.", "Calculate Year", Month, "Bonus Type");
                                            LigSalEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
                                            LigSalEng.SETFILTER("Calculate Year", '%1', SalaryLine."Calculate Year");
                                            LigSalEng.CALCSUMS("Gross Salary");
                                            //MESSAGE(FORMAT(LigSalEng."Gross Salary"));

                                            //STA25

                                            //<<STA25
                                            IF SalaryLine."Gross Salary" > SalaryLine."6 * SMIG" THEN BEGIN
                                                SocialContributions."Base Amount" := ROUND(SalaryLine."Gross Salary" - SalaryLine."6 * SMIG", ParamCpta."Amount Rounding Precision");
                                            END
                                            ELSE
                                                SocialContributions."Base Amount" := 0;
                                            //>>STA25
                                            IF SocialContributions."Salary Package" > 0
                                              THEN BEGIN
                                                SocialContributions."Real Amount : Employee" := ROUND(SocialContributions."Salary Package",
                                                                                          ParamCpta."Amount Rounding Precision");
                                            END;
                                            IF SocialContributions."Employer contribution" > 0
                                              THEN
                                                SocialContributions."Real Amount : Employer" := ROUND(SocialContributions."Employer contribution",
                                                                                                ParamCpta."Amount Rounding Precision");
                                            SocialContributions."Real Amount : Employee PR" := ROUND(SocialContributions."Salary Package",
                                                                                                   ParamCpta."Amount Rounding Precision");
                                        END;


                                END;
                            END
                            ELSE BEGIN
                                Ind.RESET;
                                Ind.SETRANGE("No.", SalaryLine."No.");
                                Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
                                Ind.SETRANGE(Indemnity, SocialContributions.Indemnity);
                                IF Ind.FINDFIRST THEN
                                    SocialContributions."Base Amount" := ROUND(Ind."Real Amount", ParamCpta."Amount Rounding Precision");
                            END;
                            SocialContributions."Real Amount : Employee" := ROUND(SocialContributions."Base Amount"
                                                                          * SocialContributions."Employee's part"
                                                                          / 100, ParamCpta."Amount Rounding Precision");
                            IF Cot."Basis of calculation".AsInteger() = 0 THEN
                                SocialContributions."Real Amount : Employee PR" := ROUND(SalaryLine."Gross Salary PR"
                                                                              * SocialContributions."Employee's part"
                                                                              / 100, ParamCpta."Amount Rounding Precision");

                            IF SocialContributions."Maximum value - Employee" > 0 THEN BEGIN
                                IF SocialContributions."Real Amount : Employee" > SocialContributions."Maximum value - Employee" THEN
                                    SocialContributions."Real Amount : Employee" := SocialContributions."Maximum value - Employee";
                            END;

                            SocialContributions."Real Amount : Employer" := ROUND(SocialContributions."Base Amount"
                                                                          * SocialContributions."Employer's part"
                                                                          / 100, ParamCpta."Amount Rounding Precision");
                            IF SocialContributions."Maximum value - Employer" > 0 THEN BEGIN
                                IF SocialContributions."Real Amount : Employer" > SocialContributions."Maximum value - Employer" THEN
                                    SocialContributions."Real Amount : Employer" := SocialContributions."Maximum value - Employer";
                            END;
                        END;

                    3:
                        BEGIN
                            IF SocialContributions.Indemnity = ''
                             THEN BEGIN
                                Cot.RESET;
                                Cot.SETRANGE("Emplymt. Contract Code", SalaryLine."Emplymt. Contract Code");
                                Cot.SETRANGE("Social Contribution Code", SocialContributions."Social Contribution");
                                IF NOT Cot.FINDFIRST THEN
                                    ERROR(Text001,
                                           Cot."Social Contribution Code", Cot."Emplymt. Contract Code");
                                CASE Cot."Basis of calculation".AsInteger() OF

                                    0:
                                        SocialContributions."Base Amount" := ROUND(SalaryLine."Gross Salary (Without AV)"
                                                                                 , ParamCpta."Amount Rounding Precision");
                                    2:
                                        BEGIN
                                            SocialContributions."Base Amount" := SalaryLine."Basis salary";
                                        END;

                                    1:
                                        BEGIN
                                            tmp1 := 0;
                                            tmp1 := 6 * ParamRessHum."Minimum wage guarantee";
                                            IF (tmp1 < SalaryLine."Gross Salary (Without AV)") THEN
                                                SocialContributions."Base Amount" := ROUND(SalaryLine."Gross Salary (Without AV)" - tmp1,
                                                                                     ParamCpta."Amount Rounding Precision")
                                            ELSE
                                                SocialContributions."Base Amount" := 0;
                                            IF SocialContributions."Salary Package" > 0
                                              THEN
                                                SocialContributions."Real Amount : Employee" := ROUND(SocialContributions."Salary Package",
                                                                                                ParamCpta."Amount Rounding Precision");
                                            IF SocialContributions."Employer contribution" > 0
                                              THEN
                                                SocialContributions."Real Amount : Employer" := ROUND(SocialContributions."Employer contribution",
                                                                                                ParamCpta."Amount Rounding Precision");
                                            SocialContributions."Real Amount : Employee PR" := ROUND(SocialContributions."Salary Package",
                                                                                                    ParamCpta."Amount Rounding Precision");
                                        END;
                                END;
                            END

                            ELSE BEGIN
                                Ind.RESET;
                                Ind.SETRANGE("No.", SalaryLine."No.");
                                Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
                                Ind.SETRANGE(Indemnity, SocialContributions.Indemnity);
                                IF Ind.FINDFIRST THEN
                                    SocialContributions."Base Amount" := ROUND(Ind."Real Amount", ParamCpta."Amount Rounding Precision");
                            END;
                            SocialContributions."Real Amount : Employee" := ROUND(SocialContributions."Base Amount"
                                                                          * SocialContributions."Employee's part"
                                                                          / 100, ParamCpta."Amount Rounding Precision");
                            IF Cot."Basis of calculation".AsInteger() = 0 THEN
                                SocialContributions."Real Amount : Employee PR" := ROUND(SalaryLine."Gross Salary (Without AV) PR"
                                                                              * SocialContributions."Employee's part"
                                                                              / 100, ParamCpta."Amount Rounding Precision");

                            IF SocialContributions."Maximum value - Employee" > 0 THEN BEGIN
                                IF SocialContributions."Real Amount : Employee" > SocialContributions."Maximum value - Employee" THEN
                                    SocialContributions."Real Amount : Employee" := SocialContributions."Maximum value - Employee";
                            END;

                            SocialContributions."Real Amount : Employer" := ROUND(SocialContributions."Base Amount"
                                                                          * SocialContributions."Employer's part"
                                                                          / 100, ParamCpta."Amount Rounding Precision");
                            IF SocialContributions."Maximum value - Employer" > 0 THEN BEGIN
                                IF SocialContributions."Real Amount : Employer" > SocialContributions."Maximum value - Employer" THEN
                                    SocialContributions."Real Amount : Employer" := SocialContributions."Maximum value - Employer";
                            END;
                        END;
                    2:
                        SocialContributions."Base Amount" := ROUND(SalaryLine."Basis salary", ParamCpta."Amount Rounding Precision");

                    1:
                        BEGIN
                            // Montant forfaitaire
                            //>>WDC02
                            ParamCpta.GET;
                            SocialContributions."Base Amount" := ROUND(SocialContributions."Salary Package", ParamCpta."Amount Rounding Precision");
                            //<<WDC02
                            SocialContributions."Real Amount : Employee" := SocialContributions."Salary Package";
                            SocialContributions."Real Amount : Employee PR" := SocialContributions."Salary Package";
                            SocialContributions."Real Amount : Employer" := SocialContributions."Employer contribution";
                        END;
                END;

                //>>
                IF (SocialContributions."Base Amount" = 0) AND (SocialContributions."Social Contribution" <> 'LOI2014') THEN      //WDC2002  LOI2014
                    SocialContributions.DELETE
                ELSE
                    SocialContributions.MODIFY;

            UNTIL SocialContributions.NEXT = 0;
    end;


    procedure CalcCotisationSocial2(var SalaryLine: Record "WDC Salary Lines")
    var
        Ind: Record "WDC Indemnities";
        SocialContributions: Record "WDC Social Contributions";
        ParamRessHum: Record "Human Resources Setup";
        temp: Decimal;
        tmp: Decimal;
        tmp1: Decimal;
        bonus: Decimal;
        Cot: Record "WDC Default Soc. Contribution";
        nbr: Decimal;
        RecDefaultIndemnities: Record "WDC Default Indemnities";
    begin
        // calc cotisation Social
        SocialContributions.SETRANGE("No.", SalaryLine."No.");
        SocialContributions.SETRANGE("Employee No.", SalaryLine."Employee No.");
        SocialContributions.SETFILTER("Evaluation Mode", '%1', 2);
        IF SocialContributions.FINDFIRST THEN
            REPEAT

                IF SocialContributions.Indemnity = ''
                 THEN BEGIN
                    Cot.RESET;
                    Cot.SETRANGE("Emplymt. Contract Code", SalaryLine."Emplymt. Contract Code");
                    Cot.SETRANGE("Social Contribution Code", SocialContributions."Social Contribution");
                    IF NOT Cot.FINDFIRST THEN
                        ERROR(Text001, Cot."Social Contribution Code", Cot."Emplymt. Contract Code");
                    CASE Cot."Basis of calculation".AsInteger() OF
                        0:
                            SocialContributions."Base Amount" := ROUND(SalaryLine."Taxable salary"
                                                                    , ParamCpta."Amount Rounding Precision");
                        2:
                            BEGIN
                                SocialContributions."Base Amount" := SalaryLine."Basis salary";
                                RecDefaultIndemnities.RESET;
                                RecDefaultIndemnities.SETRANGE("Emplymt. Contract Code", SalaryLine."Emplymt. Contract Code");
                                RecDefaultIndemnities.SETRANGE("Included in Insurance Base", TRUE);
                                IF RecDefaultIndemnities.FINDFIRST THEN
                                    REPEAT
                                        SocialContributions."Base Amount" := ROUND(SocialContributions."Base Amount" + RecDefaultIndemnities."Default amount"
                                       , ParamCpta."Amount Rounding Precision");
                                    UNTIL RecDefaultIndemnities.NEXT = 0

                            END;
                        1:
                            BEGIN
                                tmp1 := 0;
                                tmp1 := 6 * ParamRessHum."Minimum wage guarantee";
                                IF (tmp1 < SalaryLine."Gross Salary") THEN
                                    SocialContributions."Base Amount" := ROUND(SalaryLine."Taxable salary" - tmp1,
                                                                         ParamCpta."Amount Rounding Precision")
                                ELSE
                                    SocialContributions."Base Amount" := 0;
                                IF SocialContributions."Salary Package" > 0
                                  THEN
                                    SocialContributions."Real Amount : Employee" := ROUND(SocialContributions."Salary Package",
                                                                                    ParamCpta."Amount Rounding Precision");
                                IF SocialContributions."Employer contribution" > 0
                                  THEN
                                    SocialContributions."Real Amount : Employer" := ROUND(SocialContributions."Employer contribution",
                                                                                    ParamCpta."Amount Rounding Precision");
                            END;
                    END;
                END
                ELSE BEGIN
                    Ind.RESET;
                    Ind.SETRANGE("No.", SalaryLine."No.");
                    Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
                    Ind.SETRANGE(Indemnity, SocialContributions.Indemnity);
                    IF Ind.FINDFIRST THEN
                        SocialContributions."Base Amount" := ROUND(Ind."Real Amount", ParamCpta."Amount Rounding Precision");
                END;
                SocialContributions."Real Amount : Employee" := ROUND(SocialContributions."Base Amount"
                                                              * SocialContributions."Employee's part"
                                                              / 100, ParamCpta."Amount Rounding Precision");
                IF SocialContributions."Maximum value - Employee" > 0 THEN BEGIN
                    IF SocialContributions."Real Amount : Employee" > SocialContributions."Maximum value - Employee" THEN
                        SocialContributions."Real Amount : Employee" := SocialContributions."Maximum value - Employee";
                END;

                SocialContributions."Real Amount : Employer" := ROUND(SocialContributions."Base Amount"
                                                              * SocialContributions."Employer's part"
                                                              / 100, ParamCpta."Amount Rounding Precision");
                IF SocialContributions."Maximum value - Employer" > 0 THEN BEGIN
                    IF SocialContributions."Real Amount : Employer" > SocialContributions."Maximum value - Employer" THEN
                        SocialContributions."Real Amount : Employer" := SocialContributions."Maximum value - Employer";
                END;
                //END;
                SocialContributions.MODIFY;

            UNTIL SocialContributions.NEXT = 0;
        CalcAllTaxe(SalaryLine);
    end;

    procedure CalcAllTaxe(var SalaryLineTmp: Record "WDC Salary Lines")
    var
        SocialContr: Record "WDC Social Contributions";
        SalLine: Record "WDC Salary Lines";
        Indem: Record "WDC Indemnities";
    begin
        SalaryLineTmp."Non Taxable Soc. Contrib." := 0;
        SalaryLineTmp."Total taxable rec." := 0;
        SalaryLineTmp."Total taxes rec." := 0;
        SalaryLineTmp."Non Taxable indemnities" := 0;
        SalaryLineTmp."Taxable Soc. Contrib." := 0;
        SalaryLineTmp."Mission expenses" := 0;
        ParamCpta.GET;
        SocialContr.RESET;
        SocialContr.SETCURRENTKEY("No.", "Employee No.", "Deductible of taxable basis");
        SocialContr.SETCURRENTKEY("No.", "Employee No.", "Deductible of taxable basis", "Basis of calculation");

        SocialContr.SETFILTER("No.", SalaryLineTmp."No.");
        SocialContr.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        SocialContr.SETFILTER("Deductible of taxable basis", '%1', TRUE);
        SocialContr.SETFILTER(SocialContr."Basis of calculation", '<>%1', 3);

        SocialContr.CALCSUMS("Real Amount : Employee", "Real Amount : Employee PR");
        SalaryLineTmp."Non Taxable Soc. Contrib." := ROUND(SocialContr."Real Amount : Employee", ParamCpta."Amount Rounding Precision");
        SalaryLineTmp."Non Taxable Soc. Contrib. PR" := ROUND(SocialContr."Real Amount : Employee PR",
                                                        ParamCpta."Amount Rounding Precision");
        SalLine.RESET;
        SalLine.SETCURRENTKEY(Year, "Employee No.", "Global dimension 1", "Global dimension 2");
        SalLine.SETFILTER(Year, '%1', SalaryLineTmp.Year);
        SalLine.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        SalLine.CALCSUMS("Real taxable", "Taxe (Month)");
        SalaryLineTmp."Total taxable rec." := SalLine."Real taxable";
        SalaryLineTmp."Total taxes rec." := SalLine."Taxe (Month)";

        Indem.RESET;
        Indem.SETCURRENTKEY("No.", "Employee No.", Type);
        Indem.SETFILTER("No.", SalaryLineTmp."No.");
        Indem.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        Indem.SETFILTER(Type, '%1', Indem.Type::"Not Taxable");
        Indem.CALCSUMS("Real Amount");
        SalaryLineTmp."Non Taxable indemnities" := Indem."Real Amount";
        IndConvent := 0;
        Indem.RESET;
        Indem.SETFILTER("No.", SalaryLineTmp."No.");
        Indem.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        Indem.SETFILTER("Conventional Indemnity", '%1', TRUE);
        IF Indem.FINDFIRST THEN
            REPEAT
                SalaryLineTmp."Non Taxable indemnities" := SalaryLineTmp."Non Taxable indemnities" + Indem."Real Amount";
                IndConvent := IndConvent + Indem."Real Amount";
            UNTIL Indem.NEXT = 0;

        SocialContr.RESET;
        SocialContr.SETCURRENTKEY("No.", "Employee No.", "Deductible of taxable basis", "Basis of calculation");

        SocialContr.SETFILTER("No.", SalaryLineTmp."No.");
        SocialContr.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        SocialContr.SETFILTER("Deductible of taxable basis", '%1', FALSE);
        SocialContr.SETFILTER(SocialContr."Basis of calculation", '<>%1', 3);

        SocialContr.CALCSUMS("Real Amount : Employee");
        SalaryLineTmp."Taxable Soc. Contrib." := SocialContr."Real Amount : Employee";

    end;



    procedure CalcImpotAn(var SalaryLine: Record "WDC Salary Lines")
    var
        ParamRessHum: Record "Human Resources Setup";
        temp: Decimal;
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        Employee: Record Employee;
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
                                                            * EmploymentContract."Inclusive ratio" / 100, ParamCpta."Amount Rounding Precision")
             ;
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
                            //MBY 20/01/2009
                            SliceImposition.RESET;
                            SliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            //END MBY

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
                            //MBY 20/01/2009
                            SliceImposition.RESET;
                            SliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            //END MBY

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
                                        (SalaryLine."Real Taxable PR (Year)" < SliceImposition."Superior limit")
                                       )
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
        // Calcul Impôt mensuel
        Employee.GET(SalaryLine."Employee No.");
        IF EmploymentContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
            IF EmploymentContract.Taxable THEN BEGIN
                CASE EmploymentContract."Taxes Calculation Mode".AsInteger() OF
                    0:
                        BEGIN
                            //--> Barème standard
                            temp := 0;
                            //MBY 20/01/2009
                            SliceImposition.RESET;
                            SliceImposition.SETRANGE(Code, EmploymentContract."Slice of imposition");
                            //END MBY

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
                                        (SalaryLine."Real Taxable PR (Year)" < SliceImposition."Superior limit")
                                       )
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
    end;


    procedure CalcImpotAnCSS(var SalaryLine: Record "WDC Salary Lines")
    var
        ParamRessHum: Record "Human Resources Setup";
        temp: Decimal;
        EmploymentContract: Record "Employment Contract";
        RegimeWork: Record "WDC work Regimes";
        Employee: Record Employee;

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

                            SalaryLine."Annual CSS Tax" := ROUND(((SalaryLine."Real taxable (Year)" - SliceImpositionX."Lower limit")
                                                        * SliceImpositionX.Rate / 100) + temp, ParamCpta."Amount Rounding Precision");

                        END;
                    1:
                        BEGIN
                            //--> Forfait
                            SalaryLine."Annual CSS Tax" := ROUND(SalaryLine."Real taxable (Year)"
                                                            * EmploymentContract."Inclusive ratio" / 100, ParamCpta."Amount Rounding Precision")
                        END;
                END;
            END ELSE
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
                                        (SalaryLine."Real Taxable PR (Year)" < SliceImposition."Superior limit")
                                       )
                                       OR
                                       ((SalaryLine."Real Taxable PR (Year)" > SliceImposition."Superior limit")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" > SliceImposition."Lower limit")
                                        AND
                                        (SliceImposition."Lower limit" > SliceImposition."Superior limit")
                                       ) THEN
                                        SliceImpositionX.COPY(SliceImposition);

                                UNTIL SliceImposition.NEXT = 0;

                            SalaryLine."Taxe PR (Year) CSS" := ROUND(((SalaryLine."Real Taxable PR (Year)" - SliceImpositionX."Lower limit")
                                                        * SliceImpositionX.Rate / 100) + temp, ParamCpta."Amount Rounding Precision");

                        END;
                    1:
                        BEGIN
                            //--> Forfait
                            SalaryLine."Taxe PR (Year) CSS" := ROUND(SalaryLine."Real Taxable PR (Year)"
                                                            * EmploymentContract."Inclusive ratio" / 100, ParamCpta."Amount Rounding Precision")
             ;
                        END;
                END;
            END ELSE
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
                                        (SalaryLine."Real Taxable PR (Year)" < SliceImposition."Superior limit")
                                       )
                                       OR
                                       ((SalaryLine."Real Taxable PR (Year)" > SliceImposition."Superior limit")
                                        AND
                                        (SalaryLine."Real Taxable PR (Year)" > SliceImposition."Lower limit")
                                        AND
                                        (SliceImposition."Lower limit" > SliceImposition."Superior limit")
                                       ) THEN
                                        SliceImpositionX.COPY(SliceImposition);

                                UNTIL SliceImposition.NEXT = 0;

                            SalaryLine."Taxe PR (Year) CSS" := ROUND(((SalaryLine."Real Taxable PR (Year)" - SliceImpositionX."Lower limit")
                                                        * SliceImpositionX.Rate / 100) + temp, ParamCpta."Amount Rounding Precision");

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

    end;

    procedure initLigne(var SalaryLineTmp: Record "WDC Salary Lines"; Sim: Option Simulation,Real,Prime)
    var
        SuppHourLine: Record "WDC Overtime hours recorded m";
        LigneTravail: Record "WDC Occasional Hours Recorded";
        Salheader: Record "WDC Salary Header";
        LignePaie: Record "WDC Salary Lines";
        lText001: TextConst ENU = 'You must validate the payroll %1 before!!!!',
                            FRA = 'Vous devez Valider La Paie %1 Avant  !!!!';
    begin
        LignePaie.RESET;
        LignePaie.SETFILTER("No.", '<>%1', SalaryLineTmp."No.");
        LignePaie.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        IF LignePaie.FINDFIRST AND (Sim = 1) THEN
            ERROR(lText001, LignePaie."No.");
        LigneTravail.RESET;
        LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year");
        LigneTravail.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        LigneTravail.SETRANGE("Payment Month", SalaryLineTmp.Month);
        LigneTravail.SETRANGE("Payment Year", SalaryLineTmp.Year);
        //AGA ---------------------------------------------------------------------------------------
        LigneTravail.SETFILTER("Payment No.", '%1|%2', SalaryLineTmp."No.", '');

        LigneTravail.MODIFYALL("Payment No.", '');

        SuppHourLine.RESET;
        SuppHourLine.SETCURRENTKEY("Employee No.", "Overtime Rate", "Payment Month", "Payment Year");
        SuppHourLine.SETFILTER("Employee No.", SalaryLineTmp."Employee No.");
        SuppHourLine.SETFILTER("Payment Month", '%1', SalaryLineTmp.Month);
        SuppHourLine.SETFILTER("Payment Year", '%1', SalaryLineTmp.Year);
        //AGA ---------------------------------------------------------------------------------------
        SuppHourLine.SETFILTER("Payment No.", '%1|%2', SalaryLineTmp."No.", '');

        SuppHourLine.MODIFYALL("Payment No.", '');

        CLEAR(Salheader);
        Salheader.GET(SalaryLineTmp."No.");
        SalaryLineTmp."Calculate Year" := Salheader."Calculate Year";
        SalaryLineTmp."Posting Date" := Salheader."Posting Date";
        SalaryLineTmp."Taxable indemnities" := 0;
        SalaryLineTmp."Amount Days Off balacement" := 0;
        SalaryLineTmp."Assiduity (days off balacement" := 0;
        SalaryLineTmp."Hours off Balacement" := 0;
        SalaryLineTmp."Supp. hours" := 0;
        SalaryLineTmp."Gross Salary" := 0;
        SalaryLineTmp."Non Taxable Soc. Contrib." := 0;
        SalaryLineTmp."Gross Salary (Without AV)" := 0;
        SalaryLineTmp."Taxable Indem. PR (Not Gross)" := 0;
        IF Sim < 2 THEN
            SalaryLineTmp."Gross Salary (Without AV) PR" := 0;
        SalaryLineTmp."Taxable salary" := 0;
        SalaryLineTmp."Deduction Prof. expenses" := 0;
        SalaryLineTmp."Real taxable" := 0;
        SalaryLineTmp."Total taxable rec." := 0;
        SalaryLineTmp."Real taxable (Year)" := 0;
        SalaryLineTmp."Taxe (Year)" := 0;
        SalaryLineTmp."Total taxes rec." := 0;
        SalaryLineTmp."Taxe (Month)" := 0;
        SalaryLineTmp."Non Taxable indemnities" := 0;
        SalaryLineTmp."Taxable Soc. Contrib." := 0;
        SalaryLineTmp."Mission expenses" := 0;
        IF SalaryLineTmp.Month <> SalaryLineTmp.Month::Prime THEN
            SalaryLineTmp."Net salary" := 0;
        SalaryLineTmp.Loans := 0;
        SalaryLineTmp.Advances := 0;
        SalaryLineTmp."Net salary cashed" := 0;
        IF Sim < 2 THEN
            SalaryLineTmp."Taxable indemnities PR" := 0;
        IF Sim < 2 THEN
            SalaryLineTmp."Gross Salary PR" := 0;
        IF Sim < 2 THEN
            SalaryLineTmp."Non Taxable Soc. Contrib. PR" := 0;
        SalaryLineTmp."Taxable indem. PR (Not Gross)" := 0;
        IF Sim < 2 THEN
            SalaryLineTmp."Taxable salary PR" := 0;
        IF Sim < 2 THEN
            SalaryLineTmp."Real taxable PR" := 0;
        SalaryLineTmp."Real Taxable PR (Year)" := 0;
        SalaryLineTmp."Taxe PR (Month)" := 0;
        SalaryLineTmp."Taxe PR (Year)" := 0;
        SalaryLineTmp."6 * SMIG" := 0;
        SalaryLineTmp.Month := SalaryLineTmp.Month;
        LignePaie.Year := SalaryLineTmp.Year;

        CASE DATE2DMY(Salheader."Posting Date", 2) OF
            1, 2, 3:
                SalaryLineTmp.Trimestre := SalaryLineTmp.Trimestre::"1St";
            4, 5, 6:
                SalaryLineTmp.Trimestre := SalaryLineTmp.Trimestre::"2nd";
            7, 8, 9:
                SalaryLineTmp.Trimestre := SalaryLineTmp.Trimestre::"3rd";
            10, 11, 12:
                SalaryLineTmp.Trimestre := SalaryLineTmp.Trimestre::"4th";
        END;
    end;



    procedure PaieInverseFeuilleCalcul13e(var LigneSalaire: Record "WDC Salary Lines"; SBDepart: Decimal; NetVoulu: Decimal; Sim: Option Simulation,Real)
    var
        Empl: Record 5200;
        Line: Record "WDC Salary Lines";
        Coef: Decimal;
        Ecart: Decimal;
        Window: Dialog;
        temp: Decimal;
        Indm: Record "WDC Indemnities";
        paramRSH: Record 5218;
        Def: Record 55000;
        Defaultindem: Record 55004;
        EmpContract: Record 5211;
        RegWork: Record 55003;
        FunctIndemAmount: Decimal;
        RecLCotisationPaie: Record 55033;
        SalaryManagement: Codeunit "WDC Salary Management";
    begin
        ParamCpta.GET;
        paramRSH.GET();
        Window.OPEN('Procédure de calcul inverse en cours :\' +
                '####################################1#\' +
                'Salaire de base : ##################2#\' +
                'Salaire net     : ##################3#');

        Line.SETRANGE("No.", LigneSalaire."No.");
        Line.SETRANGE("Employee No.", LigneSalaire."Employee No.");
        IF Line.FindSet() THEN;

        SBDepart := Line."Basis salary";
        NetVoulu := Line."Net salary" + paramRSH."Exceptional Bonus Amount";
        Defaultindem.RESET;
        Defaultindem.SETRANGE("Emplymt. Contract Code", Empl."Emplymt. Contract Code");
        Defaultindem.SETRANGE("Indemnity Code", paramRSH."Exceptional Bonus");
        IF Defaultindem.FIND('-') THEN BEGIN
            Defaultindem."Default amount" := 0;
            Defaultindem."Basis amount" := 0;
            Defaultindem.MODIFY;
        END;

        SalaryManagement.CalculateSalaryLine(Line, FALSE, 0, 0, FALSE);
        Ecart := SalaryManagement.CalculateSalaryLine(Line, FALSE, 0, 0, FALSE) - NetVoulu;
        Line.MODIFY;

        IF (Ecart < 0) THEN BEGIN
            //--> Cas 1 : Augmenter le Salaire de Base

            WHILE ((ABS(Ecart) > 0.001) AND (Ecart <= 0)) DO BEGIN
                temp := SalaryManagement.CalculateSalaryLine(Line, FALSE, 0, 0, FALSE);
                Ecart := temp - NetVoulu;
                IF (ABS(Ecart) > 50) THEN
                    Line."Basis salary" := Line."Basis salary" + 50
                ELSE BEGIN
                    IF (ABS(Ecart) > 40) THEN
                        Line."Basis salary" := Line."Basis salary" + 40
                    ELSE BEGIN
                        IF (ABS(Ecart) > 30) THEN
                            Line."Basis salary" := Line."Basis salary" + 30
                        ELSE
                            IF (ABS(Ecart) > 20) THEN
                                Line."Basis salary" := Line."Basis salary" + 20
                            ELSE
                                IF (ABS(Ecart) > 10) THEN
                                    Line."Basis salary" := Line."Basis salary" + 10
                                ELSE
                                    IF (ABS(Ecart) > 5) THEN
                                        Line."Basis salary" := Line."Basis salary" + 5
                                    ELSE
                                        IF (ABS(Ecart) > 3) THEN
                                            Line."Basis salary" := Line."Basis salary" + 3
                                        ELSE
                                            IF (ABS(Ecart) > 2) THEN
                                                Line."Basis salary" := Line."Basis salary" + 2
                                            ELSE
                                                IF (ABS(Ecart) > 1) THEN
                                                    Line."Basis salary" := Line."Basis salary" + 1

                                                ELSE
                                                    IF (ABS(Ecart) > 0.5) THEN
                                                        Line."Basis salary" := Line."Basis salary" + 0.5
                                                    ELSE
                                                        IF (ABS(Ecart) > 0.1) THEN
                                                            Line."Basis salary" := Line."Basis salary" + 0.1
                                                        ELSE
                                                            IF (ABS(Ecart) > 0.05) THEN
                                                                Line."Basis salary" := Line."Basis salary" + 0.05
                                                            ELSE
                                                                IF (ABS(Ecart) > 0.03) THEN
                                                                    Line."Basis salary" := Line."Basis salary" + 0.03
                                                                ELSE
                                                                    IF (ABS(Ecart) > 0.02) THEN
                                                                        Line."Basis salary" := Line."Basis salary" + 0.02
                                                                    ELSE
                                                                        Line."Basis salary" := Line."Basis salary" + 0.001;

                    END;
                END;
                Line.MODIFY;

                window.UPDATE(1, Line."No." + ' - ' + Line."Employee No." + ' : ' + Line.Name);
                window.UPDATE(2, ROUND(Line."Basis salary", ParamCpta."Amount Rounding Precision"));
                window.UPDATE(3, ROUND(temp, ParamCpta."Amount Rounding Precision"));

            END;

        END;

        IF (Ecart > 0) THEN BEGIN
            //--> Cas 2 : Diminuer le Salaire de Base

            WHILE ((ABS(Ecart) > 0.001) AND (Ecart >= 0)) DO BEGIN
                temp := SalaryManagement.CalculateSalaryLine(Line, FALSE, 0, 0, FALSE);
                Ecart := temp - NetVoulu;
                IF (ABS(Ecart) > 50) THEN
                    Line."Basis salary" := Line."Basis salary" - 50
                ELSE BEGIN
                    IF (ABS(Ecart) > 40) THEN
                        Line."Basis salary" := Line."Basis salary" - 40
                    ELSE BEGIN
                        IF (ABS(Ecart) > 30) THEN
                            Line."Basis salary" := Line."Basis salary" - 30
                        ELSE
                            IF (ABS(Ecart) > 20) THEN
                                Line."Basis salary" := Line."Basis salary" - 20
                            ELSE
                                IF (ABS(Ecart) > 10) THEN
                                    Line."Basis salary" := Line."Basis salary" - 10
                                ELSE
                                    IF (ABS(Ecart) > 5) THEN
                                        Line."Basis salary" := Line."Basis salary" - 5
                                    ELSE
                                        IF (ABS(Ecart) > 3) THEN
                                            Line."Basis salary" := Line."Basis salary" - 3
                                        ELSE
                                            IF (ABS(Ecart) > 2) THEN
                                                Line."Basis salary" := Line."Basis salary" - 2
                                            ELSE

                                                IF (ABS(Ecart) > 1) THEN
                                                    Line."Basis salary" := Line."Basis salary" - 1

                                                ELSE
                                                    IF (ABS(Ecart) > 0.5) THEN
                                                        Line."Basis salary" := Line."Basis salary" - 0.5
                                                    ELSE
                                                        IF (ABS(Ecart) > 0.1) THEN
                                                            Line."Basis salary" := Line."Basis salary" - 0.1
                                                        ELSE
                                                            IF (ABS(Ecart) > 0.05) THEN
                                                                Line."Basis salary" := Line."Basis salary" - 0.05
                                                            ELSE
                                                                IF (ABS(Ecart) > 0.03) THEN
                                                                    Line."Basis salary" := Line."Basis salary" - 0.03
                                                                ELSE
                                                                    IF (ABS(Ecart) > 0.02) THEN
                                                                        Line."Basis salary" := Line."Basis salary" - 0.02
                                                                    ELSE
                                                                        Line."Basis salary" := Line."Basis salary" - 0.001;
                    END;
                END;
                Line.MODIFY;

                window.UPDATE(1, Line."No." + ' - ' + Line."Employee No." + ' : ' + Line.Name);
                window.UPDATE(2, ROUND(Line."Basis salary", ParamCpta."Amount Rounding Precision"));
                window.UPDATE(3, ROUND(temp, ParamCpta."Amount Rounding Precision"));

            END;

        END;
        IF Sim = 1 THEN BEGIN
            IF Line."Basis salary" <> SBDepart THEN BEGIN
                FunctIndemAmount := Line."Basis salary" - SBDepart;
                paramRSH.GET;
                paramRSH.TESTFIELD("Exceptional Bonus");
                Indm.RESET;
                Indm.SETFILTER("No.", Line."No.");
                Indm.SETFILTER("Employee No.", Line."Employee No.");
                Indm.SETFILTER(Indemnity, paramRSH."Exceptional Bonus");
                IF Indm.FIND('-') THEN BEGIN
                    Indm."Base Amount" := Indm."Base Amount" - (Line."Basis salary" - SBDepart);
                    Indm."Real Amount" := Indm."Real Amount" - (Line."Basis salary" - SBDepart);
                    Indm.MODIFY;
                END ELSE BEGIN
                    CLEAR(Def);
                    Indm.INIT;
                    Indm."No." := Line."No.";
                    Indm."Employee No." := Line."Employee No.";
                    Indm.Indemnity := paramRSH."Exceptional Bonus";
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
                    //Indm.Nom:=
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
                Defaultindem.RESET;
                Defaultindem.SETRANGE("Emplymt. Contract Code", Empl."Emplymt. Contract Code");
                Defaultindem.SETRANGE("Indemnity Code", paramRSH."Exceptional Bonus");
                IF Defaultindem.FINDSET THEN BEGIN
                    Defaultindem."Default amount" := FunctIndemAmount;
                    Defaultindem."Basis amount" := FunctIndemAmount;
                    Defaultindem.MODIFY
                END ELSE BEGIN
                    Defaultindem.INIT;
                    Defaultindem."Emplymt. Contract Code" := Line."Employee No.";
                    Defaultindem.VALIDATE("Indemnity Code", paramRSH."Exceptional Bonus");
                    Defaultindem.VALIDATE("Default amount", FunctIndemAmount);
                    IF NOT Defaultindem.INSERT THEN
                        Defaultindem.MODIFY;

                END;
            END;

        END
        ELSE
            window.CLOSE;
        //CalculateSalaryLine (Line,FALSE,0,0,FALSE);
    end;


    procedure CreateBonusLines(var SalaryHeader: Record 55022; Employee: Record 5200) OK: Boolean
    var
        SalaryLine: Record 55023;
        EmploymentContract: Record 5211;
        err1: TextConst ENU = 'Regime of work empty on Employment contract : %1',
                      FRA = 'Régime de travail vide sur contrat de travail : %1';
        err2: TextConst ENU = 'Employment contract empty for the employee : %1',
                      FRA = 'Contrat de travail vide pour l''employé : %1';
        DefaultSocContribution: Record 55005;
        SocialContributions: Record 55033;
        SocialContribution: Record 55001;
        DefaultIndemnities: Record 55004;
        Indemnities: Record 55007;
        confMess: TextConst ENU = 'Replace the existing line ?',
                           FRA = 'Remplacer la ligne existante ?';
        creator: TextConst ENU = 'Line created by :',
                         FRA = 'Ligne créée par :';
        lText001: TextConst ENU = 'Do you want to include the employee loan?',
                            FRA = 'Voulez-vous inclure le prêt du salarié';
        lText002: TextConst ENU = 'for the month',
                            FRA = ' pour le mois de ';
        nbr: Decimal;
        ParamRessHum: Record 5218;
        EntPaie2: Record 55024;
        LoanAD: Record 55012;
    begin


        SalaryLine.RESET;
        Employee.MAJDeductions;
        ParamCpta.GET;
        SalaryLine.SETRANGE("No.", SalaryHeader."No.");
        SalaryLine.SETRANGE("Employee No.", Employee."No.");
        IF SalaryLine.FindFirst() THEN BEGIN
            IF CONFIRM(confMess + '\%1\', FALSE, Employee."No." + ' : ' + Employee.FullName)
              THEN
                DeleteLine(SalaryLine)
            ELSE
                EXIT(FALSE);
        END;
        SalaryLine.RESET;
        ParamRessHum.GET();
        SalaryLine."No." := SalaryHeader."No.";
        SalaryLine."Employee No." := Employee."No.";
        SalaryLine.Name := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
        SalaryLine."Employee Posting Group" := Employee."Empl. Posting Group";
        SalaryLine."Statistics Group Code" := Employee."Statistics Group Code";
        SalaryLine."Global Dimension 1" := Employee."Global Dimension 1 Code";
        SalaryLine."Global Dimension 2" := Employee."Global Dimension 2 Code";
        SalaryLine."Payment Method Code" := Employee."Payment Method Code";
        SalaryLine."Posting Date" := SalaryHeader."Posting Date";
        SalaryLine."Bank Account Code" := Employee."Bank Account Number";
        IF Employee."Emplymt. Contract Code" <> '' THEN BEGIN
            EmploymentContract.GET(Employee."Emplymt. Contract Code");
            SalaryLine."Emplymt. Contract Code" := Employee."Emplymt. Contract Code";
            IF EmploymentContract."Work Regime" <> '' THEN
                SalaryLine."Employee Work Regime" := EmploymentContract."Work Regime"
            ELSE
                ERROR(err1, EmploymentContract.Code + ' - ' + EmploymentContract.Description);
        END ELSE
            ERROR(err2, Employee."No." + ' - ' + Employee."First Name" + ' ' + Employee."Last Name");
        CLEAR(Bnk);
        Bnk.RESET;
        IF Employee."Default Bank Account Code" <> '' THEN
            Bnk.GET(Employee."No.", Employee."Default Bank Account Code");
        SalaryLine."Account No." := Bnk."Bank Account No.";

        EntPaie2.RESET;
        EntPaie2.SETRANGE("Calculate Year", SalaryHeader."Calculate Year");
        EntPaie2.SETRANGE(Month, 0, 11);
        IF SalaryHeader."Posting Date" = DMY2DATE(26, 3, 2005) THEN
            EntPaie2.SETRANGE(Month, 0, 2);

        IF EntPaie2.FINDLAST THEN
            CASE DATE2DMY(EntPaie2."Posting Date", 2) OF
                3:
                    SalaryLine.Trimestre := SalaryLine.Trimestre::"1St";
                6:
                    SalaryLine.Trimestre := SalaryLine.Trimestre::"2nd";
                9:
                    SalaryLine.Trimestre := SalaryLine.Trimestre::"3rd";
                12:
                    SalaryLine.Trimestre := SalaryLine.Trimestre::"4th";
            END;

        SalaryLine.Description := SalaryHeader.Description;
        SalaryLine.Month := SalaryHeader.Month;
        SalaryLine.Year := SalaryHeader.Year;
        SalaryLine."Bank Account Code" := Employee."Default Bank Account Code";
        SalaryLine."Employee type" := Employee."Employee type";
        SalaryLine."Adjustment of absences" := 0;
        SalaryLine."Assiduity (Paid days)" := 0;
        SalaryLine."Assiduity (Worked days)" := 0;
        SalaryLine.Note := 0;
        SalaryLine.Purcent := 0;
        SalaryLine."Amount Days Off balacement" := 0;
        SalaryLine."Assiduity (days off balacement" := 0;
        SalaryLine."Worked Months" := EmploymentContract."Regular payments";
        SalaryLine."Basis salary" := Employee."Basis salary";
        LoanAD.RESET;
        LoanAD.SETFILTER("Employee No.", SalaryLine."Employee No.");
        LoanAD.SETRANGE(Type, LoanAD.Type::Loan);
        LoanAD.SETRANGE(Status, LoanAD.Status::"In progress");
        IF LoanAD.FIND('-') THEN BEGIN
            IF SalaryHeader.Month.AsInteger() < 12 THEN BEGIN
                IF CONFIRM(lText001
                   + ' ' + FORMAT(SalaryLine."Employee No.") + ' '
                   + SalaryLine.Name + lText002 + FORMAT(SalaryLine.Month), TRUE, FALSE) THEN BEGIN
                    LoanAD."Not include" := FALSE;
                    LoanAD.MODIFY;
                END;
            END;
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
        //>>
        //IF Employee."Familly chief" THEN
        IF (Employee."Family chief") AND NOT (Employee.Abattement) THEN
            //<<
              SalaryLine."Deduction Family chief" := ROUND(ParamRessHum."Deduction for Familly Chief" / nbr,
                                                      ParamCpta."Amount Rounding Precision")
        ELSE
            SalaryLine."Deduction Family chief" := 0;
        Employee.CALCFIELDS("Deduction Loaded child");
        SalaryLine."Deduction Loaded child" := ROUND(Employee."Deduction Loaded child" / nbr,
                                                ParamCpta."Amount Rounding Precision");

        SalaryLine."Deduction Prof. expenses" := 0;
        SalaryMgmt.CalculerFieldsPaie(SalaryLine, 1);
        IF SalaryLine.INSERT THEN BEGIN
            // Liste des indemnités du salarié en cour
            DefaultIndemnities.RESET;
            DefaultIndemnities.SETRANGE("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
            IF (SalaryLine.Month.AsInteger() >= 15) THEN
                DefaultIndemnities.SETRANGE("Evaluation mode", 0);

            IF DefaultIndemnities.FIND('-') THEN
                REPEAT
                BEGIN
                    Indemnities.INIT;
                    Indemnities."No." := SalaryLine."No.";
                    Indemnities."Employee No." := SalaryLine."Employee No.";
                    Indemnities.Indemnity := DefaultIndemnities."Indemnity Code";
                    Indemnities."Employee Posting Group" := SalaryLine."Employee Posting Group";
                    Indemnities."Employee Statistic Group" := SalaryLine."Statistics Group Code";
                    Indemnities."Global Dimension 1" := SalaryLine."Global Dimension 1";
                    Indemnities."Global Dimension 2" := SalaryLine."Global Dimension 2";
                    Indemnities.Description := DefaultIndemnities.Description;
                    Indemnities.Type := DefaultIndemnities.Type;
                    Indemnities."Evaluation mode" := DefaultIndemnities."Evaluation mode";
                    Indemnities."Indemnity Type" := DefaultIndemnities."Indemnity Type";
                    Indemnities."Minimum value" := DefaultIndemnities."Minimum value";
                    Indemnities.Name := Employee.FullName();
                    Indemnities."Amount Rounding Precision" := DefaultIndemnities."Amount Rounding Precision";
                    Indemnities."Rounding Direction" := DefaultIndemnities."Rounding Direction";

                    //>>
                    Indemnities."Days Number" := DefaultIndemnities."Days Number";
                    Indemnities."Tax-exempt (-5000 DT)" := DefaultIndemnities."Tax-exempt (-5000 DT)";


                    //<<

                    Indemnities."User ID" := USERID;
                    Indemnities."Last Modified Date" := WORKDATE;
                    Indemnities.Rate := DefaultIndemnities.Rate;
                    Indemnities."Base Amount" := (DefaultIndemnities."Default amount");

                    Indemnities."Real Amount" := 0;
                    Indemnities."Not incl. Nat. Old Age Insur." := DefaultIndemnities."Not incl. Nat. Old Age Insur.";
                    Indemnities."Not Included in Bonus" := DefaultIndemnities."Not Included in Bonus";
                    Indemnities."Not included in vacation days" := DefaultIndemnities."Not included in vacation days";

                    Ins := TRUE;
                    IF Indemnities."Indemnity Type" = Indemnities."Indemnity Type"::"Not Regular" THEN BEGIN
                        Ins := FALSE;
                        IF ParamRessHum."Activate Alert Other Payroll" THEN BEGIN
                            IF CONFIRM(STRSUBSTNO('Indemnité %1 Pour L''Employer %2 Montant de Base est de %3 n''est Pas une Indemnité Régulière',
                             Indemnities.Description, Indemnities."Employee No." + ' ' + Indemnities.name, Indemnities."Base Amount"), FALSE, TRUE) THEN
                                Ins := TRUE;
                        END ELSE BEGIN
                            Ins := TRUE;
                        END;
                        //<<

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

                                IF ((SalaryLine.Month.AsInteger() > 12)) THEN //OR (PrimeType.Fonction<>2) THEN     WDC0902
                                    DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
                            END;
                            IF DefaultSocContribution.FindFirst() THEN
                                REPEAT
                                    SocialContributions.RESET;
                                    SocialContributions.INIT;
                                    SocialContributions."No." := SalaryLine."No.";
                                    SocialContributions."Employee No." := SalaryLine."Employee No.";
                                    SocialContributions.Indemnity := DefaultIndemnities."Indemnity Code";
                                    SocialContributions."Social Contribution" := DefaultSocContribution."Social Contribution Code";
                                    SocialContributions."Employee Posting Group" := SalaryLine."Employee Posting Group";
                                    SocialContributions."Employee Statistic Group" := SalaryLine."Statistics Group Code";
                                    SocialContributions."Global Dimension 1" := SalaryLine."Global Dimension 1";
                                    SocialContributions."Global Dimension 2" := SalaryLine."Global Dimension 2";
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
            DefaultSocContribution.RESET;
            DefaultSocContribution.SETRANGE("Emplymt. Contract Code", Employee."Emplymt. Contract Code");
            DefaultSocContribution.SETRANGE("Indemnity Code", '');
            ParamRessHum.GET;
            IF NOT ParamRessHum."Activate Bonus Type" THEN BEGIN
                IF SalaryLine.Month = SalaryLine.Month::Prime THEN
                    DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
            END ELSE BEGIN
                IF ((SalaryLine.Month.AsInteger() > 12)) THEN //OR (PrimeType.Fonction<>2) THEN      WDC0903
                    DefaultSocContribution.SETRANGE("Not Included in Bonus", FALSE);
            END;
            IF DefaultSocContribution.FIND('-') THEN
                REPEAT
                    SocialContributions.RESET;
                    SocialContributions.INIT;
                    SocialContributions."No." := SalaryLine."No.";
                    SocialContributions."Employee No." := SalaryLine."Employee No.";
                    SocialContributions.Indemnity := '';
                    SocialContributions."Social Contribution" := DefaultSocContribution."Social Contribution Code";
                    SocialContributions."Employee Posting Group" := SalaryLine."Employee Posting Group";
                    SocialContributions."Employee Statistic Group" := SalaryLine."Statistics Group Code";
                    SocialContributions."Global Dimension 1" := SalaryLine."Global Dimension 1";
                    SocialContributions."Global Dimension 2" := SalaryLine."Global Dimension 2";
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

                    IF SocialContributions.INSERT THEN;
                UNTIL DefaultSocContribution.NEXT = 0;
            OK := TRUE;
        END ELSE
            OK := FALSE;

    end;



    procedure CalculerLigneBONUSWDC(SalaryLine: Record 55023; "SolderDroitCongé": Boolean; Sim: Option Simulation,Real; nbjsolder: Decimal): Decimal
    var
        SalaryHeader: Record 55022;
        Ind: Record 55007;
        SocialContributions: Record 55033;
        ParamRessHum: Record 5218;
        EmploymentContract: Record 5211;
        RegimeWork: Record 55003;
        Employee: Record 5200;
        temp: Decimal;
        tmp: Decimal;
        tmp1: Decimal;
        ChefFamille: Decimal;
        deductionChef: Decimal;
        EMP1: Record 5200;
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
        "Mgmt.ofLoansandAdvances": Codeunit 55025;
        droitconge: Record 55021;
        SalLineEngTmp: Record 55025;
        SalLineEngTmp2: Record 55025;
        typemnt: Option SalaireNet,SalaireBrut;
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
        initLigne(SalaryLine, Sim);
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
        CalcCotisationSocial1(SalaryLine);
        SalaryLine.MODIFY;
        CalcAllTaxe(SalaryLine);
        CalcCotisationSocial2(SalaryLine);
        SalaryLine.MODIFY;
        BEGIN
            //--> Calcul de l'imposable réel
            IF EmploymentContract.Taxable THEN BEGIN
                Gemployee.GET(SalaryLine."Employee No.");  //WDC01
                SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib."
                                                 - SalaryLine."Retirement plus", ParamCpta."Amount Rounding Precision");//WDC01
                SalLineEng.RESET;
                SalLineEng.SETCURRENTKEY(Year, "Employee No.", "No.");
                SalLineEng.SETFILTER(Year, '%1', SalaryLine.Year);
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
                        ///
                        IF ROUND(ParamRessHum."Pourcent professional expenses" * (SalaryLine."Taxable salary" * (nbr - NbrPaie) + ImposEnreg)) <= ParamRessHum."Professional Expenses Charges" THEN BEGIN
                            IF ROUND(ParamRessHum."Pourcent professional expenses" * SalaryLine."Taxable salary") >= ROUND(ParamRessHum.
                                                                                                "Professional Expenses Charges" / nbr) THEN
                                SalaryLine."Deduction Prof. expenses" := ROUND((ParamRessHum."Professional Expenses Charges" / nbr) * (NbrPaie + 1) - FraisEnreg)
                            ELSE
                                SalaryLine."Deduction Prof. expenses" := ROUND(ParamRessHum."Pourcent professional expenses"
                                                                                * SalaryLine."Taxable salary");
                        END;
                    END;
                END;

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
            SalLineEng.SETFILTER(Year, '%1', SalaryLine.Year);
            SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEng.SETFILTER(Imposable, '%1', TRUE);
            //>> CSS
            SalLineEng.CALCSUMS("Real taxable", "Taxe (Month)", "Taxable salary", "CSS Tax"); //WDCREGUL REMPLACEMENT "Monthly CSS Tax"
            SalaryLine."Total CSS Tax Recorded" := SalLineEng."CSS Tax";    //WDCREGUL REMPLACEMENT "Monthly CSS Tax"
                                                                            //<< CSS
            SalaryLine."Total taxable rec." := SalLineEng."Real taxable";
            SalaryLine."Total taxes rec." := SalLineEng."Taxe (Month)";
            SalaryLine."Rec. payments" := 0;
            SalLineEngTmp.RESET;
            SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Imposable);
            SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEngTmp.SETFILTER(Year, '%1', SalaryLine.Year);
            SalLineEng.SETFILTER(Imposable, '%1', TRUE);
            SalLineEngTmp.SETFILTER(Month, '<%1', 12);
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
            CalcImpotAn(SalaryLine);
            CalcImpotAnCSS(SalaryLine);
            SalaryMgmt.CalcImpotMensuelNew(SalaryLine, 1);
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

            // CALCUL INDEMNITE AVENTAGE EN NATURE
            Ind.RESET;
            Ind.SETCURRENTKEY("No.", "Employee No.", Type, "Not incl. Nat. Old Age Insur.");
            Ind.SETRANGE("No.", SalaryLine."No.");
            Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
            Ind.SETRANGE("Not incl. Nat. Old Age Insur.", false);
            Ind.CALCSUMS("Real Amount");


            IF Sim = 1 THEN
                IF SalaryHeader."Disable loan calculation" = FALSE THEN
                    "Mgmt.ofLoansandAdvances".CreateRepaymentLine(SalaryLine);

            SalaryLine."Net salary cashed" := SalaryLine."Net salary"
                                                           - SalaryLine.Loans
                                                           - SalaryLine.Advances
                                                           - Ind."Real Amount"
                                                           - SalaryLine."Amount retained cash FS";
            IF SalaryLine."Net salary cashed" < 0 THEN
                MESSAGE(Text002, SalaryLine."Employee No.");
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
                DeleteLine(SalaryLine)
            ELSE
                SalaryLine.MODIFY;
            EXIT(SalaryLine."Net salary");
        END;
        //FIN WDC PRIME
    end;



    procedure CalculerLigneGratification(SalaryLine: Record 55023; "SolderDroitCongé": Boolean; Sim: Option Simulation,Real; nbjsolder: Decimal): Decimal
    var
        SalaryHeader: Record 55022;
        Ind: Record 55007;
        SocialContributions: Record 55033;
        ParamRessHum: Record 5218;
        EmploymentContract: Record 5211;
        RegimeWork: Record 55003;
        Employee: Record 5200;
        temp: Decimal;
        tmp: Decimal;
        tmp1: Decimal;
        ChefFamille: Decimal;
        deductionChef: Decimal;
        EMP1: Record 5200;
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
        "Mgmt.ofLoansandAdvances": Codeunit 55025;
        droitconge: Record 55021;
        SalLineEngTmp: Record 55025;
        SalLineEngTmp2: Record 55025;
        typemnt: Option SalaireNet,SalaireBrut;
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
        //>>WDCPrime Rendement
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
        initLigne(SalaryLine, Sim);
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
        LPourcentagePrésence := 100;
        //>>WDCPRIME A Modifier pour Gratifification
        Ind.RESET;
        Ind.SETRANGE("No.", SalaryHeader."No.");
        Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
        IF Ind.FINDSET THEN
            REPEAT
                DecMontantIdem := DecMontantIdem + Ind."Base Amount";
                MESSAGE('%1', (Ind."Base Amount" * (LPourcentage / 100)) * (LPourcentagePrésence / 100));//WDC0911
                Ind."Real Amount" := (Ind."Base Amount" * (LPourcentage / 100)) * (LPourcentagePrésence / 100);
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
        CalcCotisationSocial1(SalaryLine);
        SalaryLine.MODIFY;
        CalcAllTaxe(SalaryLine);
        CalcCotisationSocial2(SalaryLine);
        SalaryLine.MODIFY;
        BEGIN
            //--> Calcul de l'imposable réel
            IF EmploymentContract.Taxable THEN BEGIN
                Gemployee.GET(SalaryLine."Employee No.");  //WDC01
                SalaryLine."Taxable salary" := ROUND(SalaryLine."Gross Salary" - SalaryLine."Non Taxable Soc. Contrib."
                                                 - SalaryLine."Retirement plus", ParamCpta."Amount Rounding Precision");//WDC01
                SalLineEng.RESET;
                SalLineEng.SETCURRENTKEY(Year, "Employee No.", "No.");
                SalLineEng.SETFILTER(Year, '%1', SalaryLine.Year);
                SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
                IF SalLineEng.FindLast() THEN
                    SalaryLine."Taxable salary PR" := SalLineEng."Taxable salary"
                ELSE
                    SalaryLine."Taxable salary PR" := SalLineEngTmp2."Taxable salary PR";

                IF Employee."Family chief" THEN BEGIN
                    SalaryLine."Deduction Family chief" := ROUND(ParamRessHum."Deduction for Familly Chief" / 12,
                                                            ParamCpta."Amount Rounding Precision");
                    Employee.CALCFIELDS("Deduction Loaded child");
                    SalaryLine."Deduction Loaded child" := ROUND(Employee."Deduction Loaded child" / 12,
                                                            ParamCpta."Amount Rounding Precision")
                END
                ELSE BEGIN
                    SalaryLine."Deduction Family chief" := 0;
                    SalaryLine."Deduction Loaded child" := 0;
                END;
                //WDC Recherche sur les paie enregistrée
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
                                                        - SalaryLine."Deduction Prof. expenses" - SalaryLine."Deduction Family chief" - SalaryLine."Deduction Loaded child", ParamCpta."Amount Rounding Precision");

                SalaryLine."Real taxable PR" := ROUND(SalaryLine."Taxable salary PR"
                                                      - SalaryLine."Deduction Family chief"
                                                      - SalaryLine."Deduction Loaded child"
                                                      - ROUND(SalaryLine."Taxable salary PR" * ParamRessHum."Pourcent professional expenses"
                                                      , ParamCpta."Amount Rounding Precision"), ParamCpta."Amount Rounding Precision");
            END;
            //--> Calcul de l'imposable réel par an
            SalLineEng.RESET;
            SalLineEng.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Imposable);
            SalLineEng.SETFILTER(Year, '%1', SalaryLine.Year);
            SalLineEng.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEng.SETFILTER(Imposable, '%1', TRUE);
            //>> CSS
            SalLineEng.CALCSUMS("Real taxable", "Taxe (Month)", "Taxable salary", "CSS Tax");//WDCREGUL REMPLACEMENT "Monthly CSS Tax"
            SalaryLine."Total CSS Tax Recorded" := SalLineEng."CSS Tax";//WDCREGUL REMPLACEMENT "Monthly CSS Tax"
                                                                        //<< CSS
            SalaryLine."Total taxable rec." := SalLineEng."Real taxable";
            SalaryLine."Total taxes rec." := SalLineEng."Taxe (Month)";
            SalaryLine."Rec. payments" := 0;
            SalLineEngTmp.RESET;
            SalLineEngTmp.SETCURRENTKEY(Year, Month, "Employee No.", "No.", Imposable);
            SalLineEngTmp.SETFILTER("Employee No.", SalaryLine."Employee No.");
            SalLineEngTmp.SETFILTER(Year, '%1', SalaryLine.Year);
            SalLineEng.SETFILTER(Imposable, '%1', TRUE);
            SalLineEngTmp.SETFILTER(Month, '<%1', 12);
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
            CalcImpotAn(SalaryLine);
            CalcImpotAnCSS(SalaryLine);
            //WDCPRIME Calcul Impôt mensuel
            CASE ParamRessHum."Regulation Taxe".AsInteger() OF
                0:
                    BEGIN
                        IF SalaryLine.Month.AsInteger() < nbr THEN BEGIN
                            IF (Employee."Working Relationship".AsInteger() = 2) OR (Employee."Working Relationship".AsInteger() = 3) THEN BEGIN
                                IF (nbr - SalaryLine."Rec. payments") > 0 THEN BEGIN

                                    SalaryLine."Taxe PR (Month)" := ROUND((SalaryLine."Taxe PR (Year)" - SalaryLine."Total taxes rec.")
                                                                  / (nbr - SalaryLine."Rec. payments"), ParamCpta."Amount Rounding Precision");

                                    IF (SalaryLine.Month.AsInteger() < 13) THEN
                                        SalaryLine."Taxe (Month)" := ROUND(((SalaryLine."Taxe (Year)" - SalaryLine."Total taxes rec.")
                                                                     / (nbr - SalaryLine."Rec. payments")), ParamCpta."Amount Rounding Precision")
                                    ELSE
                                        SalaryLine."Taxe (Month)" := (SalaryLine."Taxe (Year)" - SalaryLine."Total taxes rec.");
                                END ELSE
                                    SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" - SalaryLine."Total taxes rec.")
                                                                 , ParamCpta."Amount Rounding Precision");

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
                            IF (nbr - SalaryLine."Rec. payments") <> 0 THEN BEGIN
                                SalaryLine."Taxe PR (Year)" := SalaryLine."Taxe (Year)";

                                SalaryLine."Taxe PR (Month)" := ROUND((SalaryLine."Taxe PR (Year)" - SalaryLine."Total taxes rec.")
                                                                / (nbr - SalaryLine."Rec. payments"), ParamCpta."Amount Rounding Precision");
                                SalaryLine."Taxe (Month)" := SalaryLine."Taxe PR (Month)";

                            END
                            ELSE BEGIN
                                SalaryLine."Taxe PR (Month)" := ROUND((SalaryLine."Taxe PR (Year)" - SalaryLine."Total taxes rec.")
                                                                , ParamCpta."Amount Rounding Precision");
                                SalaryLine."Taxe (Month)" := SalaryLine."Taxe PR (Month)";
                            END;
                            //<<   CalcPai
                        END;

                    END;

                1:
                    BEGIN
                        SalaryLine."Taxe (Month)" := ROUND((SalaryLine."Taxe (Year)" / nbr)
                                                                        , ParamCpta."Amount Rounding Precision");

                        SalaryLine."Monthly CSS Tax" := ROUND((SalaryLine."Annual CSS Tax" / nbr)
                                                                             , ParamCpta."Amount Rounding Precision");

                        IF SalaryLine."Taxe (Month)" < 0 THEN
                            SalaryLine."Taxe (Month)" := 0;
                        IF SalaryLine."Monthly CSS Tax" < 0 THEN
                            SalaryLine."Monthly CSS Tax" := 0;
                    END;
                // aga impot statique
                2:
                    BEGIN
                        SalaryLine."Taxe PR (Month)" := ROUND(SalaryLine."Taxe PR (Year)" / nbr, ParamCpta.
                                                                       "Amount Rounding Precision");
                        SalaryLine."Taxe (Month)" := ROUND(SalaryLine."Taxe (Year)" / nbr, ParamCpta.
                                                                       "Amount Rounding Precision");
                        IF SalaryLine."Taxe (Month)" < 0 THEN
                            SalaryLine."Taxe (Month)" := 0;


                    END;
            END;


            IF SalaryLine."Taxe (Month)" < 0 THEN
                SalaryLine."Taxe (Month)" := 0;
            IF EmploymentContract."Inclusive ratio" <> 0 THEN SalaryLine."Taxe (Month)" := (SalaryLine."Gross Salary" * EmploymentContract."Inclusive ratio") / 100;
            IF EmploymentContract."Inclusive ratio" <> 0 THEN SalaryLine."Monthly CSS Tax" := (SalaryLine."Gross Salary" * (EmploymentContract."Inclusive ratio" + 1)) / 100;
            ImpotCSS := 0;
            ImpotCSS := SalaryLine."Monthly CSS Tax" - SalaryLine."Taxe (Month)";
            IF ImpotCSS > 0 THEN BEGIN
                CreateLigneCSS(SalaryLine);
                SalaryLine."CSS Tax" := ROUND(SalaryLine."Monthly CSS Tax" - SalaryLine."Taxe (Month)", ParamCpta."Amount Rounding Precision");
            END ELSE BEGIN
                SalaryLine."CSS Tax" := 0;
            END;

            //----ARRONDI-------------------------------------ANCIEN--------------------
            SalaryLine."Net salary" := ROUND(SalaryLine."Gross Salary"
                                     - SalaryLine."Non Taxable Soc. Contrib."
                                     + SalaryLine."Taxable Indem. PR (Not Gross)"
                                     + SalaryLine."Non Taxable indemnities"
                                     + SalaryLine."Mission expenses"
                                     - SalaryLine."CSS Tax"
                                     - IndConvent
                                     - SalaryLine."Taxable Soc. Contrib."
                                     - SalaryLine."Taxe (Month)"
                                      , ParamCpta."Amount Rounding Precision");

            //CALCUL INDEMNITE AVENTAGE EN NATURE
            Ind.RESET;
            Ind.SETCURRENTKEY("No.", "Employee No.", Indemnity, "Not incl. Nat. Old Age Insur.");
            Ind.SETRANGE("No.", SalaryLine."No.");
            Ind.SETRANGE("Employee No.", SalaryLine."Employee No.");
            Ind.SETRANGE("Not incl. Nat. Old Age Insur.", TRUE);
            Ind.CALCSUMS("Real Amount");


            IF Sim = 1 THEN
                IF SalaryHeader."Disable loan calculation" = FALSE THEN
                    "Mgmt.ofLoansandAdvances".CreateRepaymentLine(SalaryLine);
            SalaryLine."Net salary cashed" := SalaryLine."Net salary"
                                                           - SalaryLine.Loans
                                                           - SalaryLine.Advances
                                                           - Ind."Real Amount"
                                                           - SalaryLine."Amount retained cash FS";
            IF SalaryLine."Net salary cashed" < 0 THEN
                MESSAGE(Text002, SalaryLine."Employee No.");
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
                DeleteLine(SalaryLine)
            ELSE
                SalaryLine.MODIFY;
            EXIT(SalaryLine."Net salary");
        END;
        //FIN WDC PRIME
    end;

    procedure CreateLigneCSS(var SalaryLine: Record 55023)
    var
        SocialContributions: Record 55033;
        SocialContribution: Record 55001;
        ParamRessHum: Record 5218;
        DefaultSocContribution: Record 55005;
    begin
        ParamRessHum.GET;
        DefaultSocContribution.RESET;
        DefaultSocContribution.SETRANGE("Social Contribution Code", ParamRessHum."Code CSS Contribution");
        DefaultSocContribution.SETRANGE("Emplymt. Contract Code", SalaryLine."Employee No.");
        IF DefaultSocContribution.FINDSET THEN BEGIN
            SocialContributions.RESET;
            SocialContributions.SETRANGE("No.", SalaryLine."No.");
            SocialContributions.SETRANGE("Employee No.", SalaryLine."Employee No.");
            SocialContributions.SETRANGE("Social Contribution", ParamRessHum."Code CSS Contribution");
            IF SocialContributions.FINDSET THEN
                SocialContributions.DELETE;
            SocialContributions.INIT;
            SocialContributions."No." := SalaryLine."No.";
            SocialContributions."Calculate Year" := SalaryLine."Calculate Year";
            SocialContributions."Employee No." := SalaryLine."Employee No.";
            SocialContributions."Social Contribution" := DefaultSocContribution."Social Contribution Code";
            SocialContributions."Basis of calculation" := DefaultSocContribution."Basis of calculation";
            SocialContributions."Employee Posting Group" := SalaryLine."Employee Posting Group";
            SocialContributions."Employee Statistic Group" := SalaryLine."Statistics Group Code";
            SocialContributions."Global Dimension 1" := SalaryLine."Global Dimension 1";
            SocialContributions."Global Dimension 2" := SalaryLine."Global Dimension 2";
            SocialContributions.Management := SalaryLine.Management;
            SocialContributions.Service := SalaryLine.Service;
            SocialContributions.Section := SalaryLine.Section;
            IF SocialContribution.GET(DefaultSocContribution."Social Contribution Code") THEN
                SocialContributions.Description := SocialContribution.Description;
            SocialContributions."Employer's part" := DefaultSocContribution."Employer's part";
            SocialContributions."Employee's part" := DefaultSocContribution."Employee's part";
            SocialContributions."Base Amount" := ROUND(SalaryLine."Monthly CSS Tax" - SalaryLine."Taxe (Month)");
            SocialContributions."Real Amount : Employee" := ROUND(SalaryLine."Monthly CSS Tax" - SalaryLine."Taxe (Month)");
            SocialContributions."Deductible of taxable basis" := DefaultSocContribution."Deductible of taxable basis";
            SocialContributions."Maximum value - Employee" := DefaultSocContribution."Maximum value - Employee";
            SocialContributions."Maximum value - Employer" := DefaultSocContribution."Maximum value - Employer";

            SocialContributions."Evaluation Mode" := DefaultSocContribution."Evaluation Mode";
            SocialContributions."Salary Package" := DefaultSocContribution."Salary Package";
            SocialContributions."Employer contribution" := DefaultSocContribution."Employer contribution";
            SocialContributions.INSERT;
        END;
    end;

    procedure PaieInverseFeuilleCalculCommission(var LigneSalaire: Record 55023; SBDepart: Decimal; NetVoulu: Decimal; Sim: Option Simulation,Real; PaieInverse: Boolean)
    var
        Empl: Record 5200;
        Line: Record 55023;
        Coef: Decimal;
        Ecart: Decimal;
        window: Dialog;
        temp: Decimal;
        Indm: Record 55007;
        paramRSH: Record 5218;
        Def: Record 55000;
        Defaultindem: Record 55004;
        EmpContract: Record 5211;
        RegWork: Record 55003;
        FunctIndemAmount: Decimal;
        TEXT002: TextConst ENU = 'The new base salary is lower than the Base Salary (Salary Scale) entered in the employee information sheet.',
                           FRA = 'Le nouveau salaire de base est inférieur au Salaire de Base(Grille de Salaire) renseigner au niveau de la fiche signalitique.';
        CurrentAmountComplement: Decimal;
        RHSetUp: Record 5218;
    begin
        ParamCpta.GET;
        paramRSH.GET();
        IF PaieInverse THEN
            window.OPEN('Procédure de calcul inverse en cours :\' +
                  '####################################1#\' +
                  'Salaire de base : ##################2#\' +
                  'Salaire net     : ##################3#')
        ELSE
            window.OPEN('Procédure de mise à jour des salaires :\');
        Line.SETRANGE("No.", LigneSalaire."No.");
        Line.SETRANGE("Employee No.", LigneSalaire."Employee No.");
        IF PaieInverse THEN BEGIN
            RHSetUp.GET();
            Line.SETRANGE("Paied days", RHSetUp."Worked days");
        END;
        IF Line.FIND('-') THEN;

        SBDepart := Line."Basis salary";
        IF PaieInverse THEN
            NetVoulu := Line."Net salary";
        Defaultindem.RESET;
        Defaultindem.SETRANGE("Emplymt. Contract Code", Empl."Emplymt. Contract Code");
        Defaultindem.SETRANGE("Indemnity Code", paramRSH."Indem Salary Diff.");
        IF Defaultindem.FIND('-') THEN BEGIN
            Defaultindem."Default amount" := 0;
            Defaultindem."Basis amount" := 0;
            Defaultindem.MODIFY;
        END;

        SalaryMgmt.CalculateSalaryLine(Line, FALSE, 0, 0, TRUE);//AGA
        Ecart := SalaryMgmt.CalculateSalaryLine(Line, FALSE, 0, 0, TRUE) - NetVoulu;
        Line.MODIFY;

        IF (Ecart < 0) THEN BEGIN
            //--> Cas 1 : Augmenter le Salaire de Base
            WHILE ((ABS(Ecart) >= 0) AND (Ecart <= 0)) DO BEGIN
                temp := SalaryMgmt.CalculateSalaryLine(Line, FALSE, 0, 0, FALSE);
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
                    window.UPDATE(1, Line."No." + ' - ' + Line."Employee No." + ' : ' + Line.Name);
                    window.UPDATE(2, ROUND(Line."Basis salary", ParamCpta."Amount Rounding Precision"));
                    window.UPDATE(3, ROUND(temp, ParamCpta."Amount Rounding Precision"));
                END;
            END;

        END;

        IF (Ecart > 0) THEN BEGIN
            //--> Cas 2 : Diminuer le Salaire de Base
            WHILE ((ABS(Ecart) > 0.0) AND (Ecart >= 0)) DO BEGIN
                temp := SalaryMgmt.CalculateSalaryLine(Line, FALSE, 0, 0, FALSE);
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
                    window.UPDATE(1, Line."No." + ' - ' + Line."Employee No." + ' : ' + Line.Name);
                    window.UPDATE(2, Line."Basis salary");
                    window.UPDATE(3, temp);
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
                    IF Indm.FIND('-') THEN BEGIN
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
                        Indm."Last Modified Date" := WORKDATE;
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
        ELSE BEGIN

            // AGA 06 03 10
            IF Empl.GET(Line."Employee No.") THEN BEGIN
                paramRSH.GET;
                EmpContract.GET(Empl."Emplymt. Contract Code");
                RegWork.GET(EmpContract."Work Regime");
                IF paramRSH."Activate Bonus Type" THEN BEGIN
                    Defaultindem.RESET;
                    Defaultindem.SETRANGE("Emplymt. Contract Code", Empl."Emplymt. Contract Code");
                    Defaultindem.SETRANGE("Indemnity Code", paramRSH."Indem Salary Diff.");
                    IF Defaultindem.FIND('-') THEN
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
                        Defaultindem.SETRANGE("Indemnity Code", paramRSH.Commission);
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
                                Defaultindem.VALIDATE("Indemnity Code", paramRSH.Commission);
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
                        Indm.SETRANGE(Indm.Indemnity, paramRSH.Commission);
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
            window.CLOSE;
        IF NOT PaieInverse THEN BEGIN
            Line."Basis salary" := SBDepart;
            Line.MODIFY;
            EMP.GET(Line."Employee No.");
            SalaryHeaders.GET(Line."No.");
            SalaryMgmt.CreateSalaryLine(SalaryHeaders, EMP, 0);
        END;
        SalaryMgmt.CalculateSalaryLine(Line, FALSE, 0, 0, FALSE);

    end;

    procedure MajQualif()
    var
        Employee: Record 5200;
        GEmployee: Record 5200;
        EmployeeQualification: Record 5203;
    begin
        //>>WDC
        CLEAR(Employee);
        IF Employee.FINDFIRST THEN
            REPEAT
                EmployeeQualification.RESET;
                EmployeeQualification.SETCURRENTKEY("Employee No.", "Line No.");
                EmployeeQualification.SETRANGE("Employee No.", Employee."No.");
                IF EmployeeQualification.FINDLAST THEN BEGIN
                    IF GEmployee.GET(Employee."No.") THEN BEGIN
                        GEmployee."Qualification Code" := EmployeeQualification."Qualification Code";
                        GEmployee.MODIFY;
                    END;
                END;
            UNTIL Employee.NEXT = 0;
    end;

    var
        ImpotCSS: Decimal;
        ParamCpta: Record "General Ledger Setup";
        IndConvent: Decimal;
        SalaryMgmt: Codeunit "WDC Salary Management";
        Ins: Boolean;
        RecGSalayEnr: Record "WDC Posted Salary Lines";
        FraisEnreg: Decimal;
        ImposEnreg: Decimal;
        Bnk: Record "WDC Employee Bank Account";
        NbrPaie: Integer;
        EMP: Record Employee;
        SalaryHeaders: Record "WDC Salary Header";

        MntAssVie: Decimal;

        MontCapitalReinvesti: Decimal;
        Gemployee: Record Employee;
        MgmtofLoansandAdvances: Codeunit "WDC Mgmt. Loans & Adv";
        SliceImposition: Record "WDC Slices of imposition";
        SliceImpositionX: Record "WDC Slices of imposition";
        Text001: TextConst ENU = 'Social security contribution %1 not found on employment contract: %2.',
                           FRA = 'Cotisation sociale %1 introuvable sur contrat de travail : %2.';
        Text002: TextConst ENU = 'Employee salary %1 must not be negative',
                            FRA = 'Salaire de l''employé %1 ne doit pas être négatif';
}