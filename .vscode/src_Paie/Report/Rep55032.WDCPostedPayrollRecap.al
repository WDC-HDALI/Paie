report 55032 "WDC Posted Payroll Recap."
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/Recappaieeng.rdlc';
    captionML = ENU = 'Posted Payroll Recap.', FRA = 'Recap. paie eng.';

    dataset
    {
        dataitem("Rec. Salary Lines"; "WDC Posted Salary Lines")
        {
            DataItemTableView = SORTING("No.", "Employee No.");
            RequestFilterFields = Year, Month;
            column(Emp__Search_Name; Emp."Search Name")
            {
            }
            column(Salary_Lines_Name; Name)
            {
            }
            column(Title; Title)
            {
            }
            column(Salary_Lines_Loans; Loans)
            {
                DecimalPlaces = 3 : 3;
            }
            column(Salary_Lines__Net_salary_cashed; "Net salary cashed")
            {
                DecimalPlaces = 3 : 3;
            }
            column(Salary_Lines__Basis_salary; "Basis salary")
            {
                DecimalPlaces = 3 : 3;
            }
            column(Salary_Lines__Taxable_indemnities; "Taxable indemnities")
            {
            }
            column(Salary_Lines__Gross_Salary; "Gross Salary")
            {
                DecimalPlaces = 3 : 3;
            }
            column(Salary_Lines__Non_Taxable_Soc__Contrib; "Non Taxable Soc. Contrib.")
            {
                DecimalPlaces = 3 : 3;
            }
            column(Salary_Lines__Taxable_salary; "Taxable salary")
            {
                DecimalPlaces = 3 : 3;
            }
            column(Salary_Lines__Taxe__Month; "Taxe (Month)")
            {
                DecimalPlaces = 3 : 3;
                IncludeCaption = true;
            }
            column(Salary_Lines__Net_salary; "Net salary")
            {
                DecimalPlaces = 3 : 3;
            }
            column(Salary_Lines__Description; Description)
            {
            }
            column(Salary_Lines__Advances; Advances)
            {
                DecimalPlaces = 3 : 3;
            }
            column(Advances_Loans; Advances + Loans)
            {
            }
            column(I; I)
            {
            }
            column(DecGTotSalBase; DecGTotSalBase)
            {
                DecimalPlaces = 3 : 3;
            }
            column(DecGTotCotImposable; DecGTotCotImposable)
            {
                DecimalPlaces = 3 : 3;
            }
            column(DecGTotSalBrut; DecGTotSalBrut)
            {
                DecimalPlaces = 3 : 3;
            }
            column(DecGTotRetCNSS; DecGTotRetCNSS)
            {
                DecimalPlaces = 3 : 3;
            }
            column(DecGTotSalImposable; DecGTotSalImposable)
            {
                DecimalPlaces = 3 : 3;
            }
            column(DecGTotImpot; DecGTotImpot)
            {
                DecimalPlaces = 3 : 3;
            }
            column(DecGTotSalNet; DecGTotSalNet)
            {
                DecimalPlaces = 3 : 3;
            }
            column(DecGTotPret; DecGTotPret)
            {
                DecimalPlaces = 3 : 3;
            }
            column(DecGTotNetServi; DecGTotNetServi)
            {
                DecimalPlaces = 3 : 3;
            }
            column(DecGTotAccompte; DecGTotAccompte)
            {
                DecimalPlaces = 3 : 3;
            }
            column(DecGTotChargePat; DecGTotChargePat)
            {
                DecimalPlaces = 3 : 3;
            }
            column(CurrReport_PAGENO; '')
            {
            }
            column(FORMAT_TODAY_0_4; FORMAT(TODAY, 0, 4))
            {
            }
            column(RecGCompanyInfo__N__CNSS_Employeur; RecGCompanyInfo."Executive Director 2")
            {
            }
            column(CURRENTDATETIME; CURRENTDATETIME)
            {
            }
            column(DecGHeureSupp; TotalHeureSup)
            {
                DecimalPlaces = 3 : 3;
            }
            column(RecGCompanyInfo_Name; RecGCompanyInfo.Name)
            {
            }
            column(Salary_Lines_No_; "No.")
            {
            }
            column(Salary_Lines_Employee; "Employee No.")
            {
            }
            column(Salary_Lines_Employee_Posting_Group; "Employee Posting Group")
            {
            }
            column(RetenueCGC; DocNonImposableNonCotisable)
            {
            }
            column(Total___FIELDCAPTION__Employee_Posting_Group; Text001 + FIELDCAPTION("Employee Posting Group"))
            {
            }
            column(CurrReport_PAGENO__Caption; Text002)
            {
            }
            column(Text003__Caption; Text003)
            {
            }
            column(Text004__Caption; Text004)
            {
            }
            column(Text005__Caption; Text005)
            {
            }
            column(Text006__Caption; Text006)
            {
            }
            column(Text007__Caption; Text007)
            {
            }
            column(Text008__Caption; Text008)
            {
            }
            column(DecGTotSalBase__Caption; Text009)
            {
            }
            column(Text010__Caption; Text010)
            {
            }
            column(DecGHeureSupp__Caption; Text011)
            {
            }
            column(DecGTotCotImposable__Caption; Text012)
            {
            }
            column(DecGTotSalBrut__Caption; Text013)
            {
            }
            column(DecGTotRetCNSS__Caption; Text014)
            {
            }
            column(Text015__Caption; Text015)
            {
            }
            column(Text016__Caption; Text016)
            {
            }
            column(DecGTotSalImposable__Caption; Text017)
            {
            }
            column(DecGTotImpot__Caption; Text018)
            {
            }
            column(Text019__Caption; Text019)
            {
            }
            column(Text020__Caption; Text020)
            {
            }
            column(DecGTotSalNet__Caption; Text021)
            {
            }
            column(DecGTotAccompte__Caption; Text022)
            {
            }
            column(DecGTotPret__Caption; Text023)
            {
            }
            column(Text024__Caption; Text024)
            {
            }
            column(Text025__Caption; Text025)
            {
            }
            column(Text026__Caption; Text026)
            {
            }
            column(DecGTotNetServi__Caption; Text027)
            {
            }
            column(DecGTotChargePat__Caption; Text028)
            {
            }
            column(Text029_RetenuCGC; Text029)
            {
            }
            column(DeductionCOVID_RecSalaryLines; 0)
            {
            }
            column(ArrondiNet; ArrondiNet)
            {
            }
            column(ReportArrondi; ReportArrondi)
            {
            }
            column(Descrption_COVID; DescCOVID)
            {
            }
            column(MontantCovid; MontCOVID)
            {
            }

            trigger OnAfterGetRecord()
            var
                tite: Text[30];
            begin
                I := I + 1;

                //>>
                RecGSocialContr.RESET;
                RecGSocialContr.SETRANGE("Employee No.", "Rec. Salary Lines"."Employee No.");
                RecGSocialContr.SETRANGE("No.", "Rec. Salary Lines"."No.");
                RecGSocialContr.SETRANGE("Social Contribution", 'COVID');
                IF RecGSocialContr.FINDSET THEN BEGIN
                    MontCOVID := RecGSocialContr."Real Amount : Employee";
                    DescCOVID := RecGSocialContr.Description;
                END;
                //<<

                IF I = 1 THEN
                    Title := STRSUBSTNO(Text003, "Rec. Salary Lines".Month, "Rec. Salary Lines".Year);

                Emp.RESET;
                Emp.SETRANGE("No.", "Employee No.");
                IF Emp.FINDFIRST THEN BEGIN

                    DateEntré := Emp."Employment Date";
                    CIN := Emp."CIN No.";
                    SalJour := Emp."Taxable Indemnity" / 26;

                    MntHeureSup := 0;
                    TotAbs := 0;
                    TotHS := 0;
                    RecGCompanyInfo.GET;
                    EmployeesdaysoffEntry.RESET;
                    EmployeesdaysoffEntry.SETFILTER("Posting month", '%1', Month);
                    EmployeesdaysoffEntry.SETFILTER("Posting year", '%1', Year);
                    EmployeesdaysoffEntry.SETFILTER("Employee No.", '%1', "Employee No.");
                    EmployeesdaysoffEntry.SETFILTER("Line type", '%1', EmployeesdaysoffEntry."Line type"::"Not Paid");
                    IF EmployeesdaysoffEntry.FINDFIRST THEN
                        REPEAT
                            TotAbs := TotAbs + EmployeesdaysoffEntry.Quantity;
                        UNTIL EmployeesdaysoffEntry.NEXT = 0;
                    IF Emp."Employee type" = Emp."Employee type"::"Month based" THEN
                        TotAbs := TotAbs + EmployeesdaysoffEntry.Quantity
                    ELSE
                        TotAbs := TotAbs + EmployeesdaysoffEntry.Quantity / 8;
                    NBJT := 26 - TotAbs;
                    MntSalJour := NBJT * SalJour;
                    Heuressuperegistréesm.RESET;
                    Heuressuperegistréesm.SETRANGE("Payment No.", "Rec. Salary Lines"."No.");
                    Heuressuperegistréesm.SETFILTER("Payment Year", '%1', Year);
                    Heuressuperegistréesm.SETFILTER("Payment Month", '%1', Month);
                    IF Heuressuperegistréesm.FINDFIRST THEN
                        REPEAT
                        BEGIN
                            TotHS := TotHS + Heuressuperegistréesm."Hours Number";
                            DecGHeureSupp := DecGHeureSupp + Heuressuperegistréesm."Line amount";
                            TotalHeureSup := DecGHeureSupp;
                        END
                        UNTIL Heuressuperegistréesm.NEXT = 0;
                END;
                DefaultIndemnities.RESET;
                DefaultIndemnities.SETRANGE("Emplymt. Contract Code", Emp."Emplymt. Contract Code");
                DefaultIndemnities.SETRANGE("Not Included in Bonus", TRUE);
                IF DefaultIndemnities.FINDFIRST THEN
                    Prime := DefaultIndemnities."Default amount";
                RecGSalaryLine.RESET;
                RecGSalaryLine.SETRANGE("No.", "No.");
                IF RecGSalaryLine.FINDSET THEN BEGIN
                    DecGTotSalBase := 0;
                    DecGTotCotImposable := 0;
                    DecGTotSalBrut := 0;
                    DecGTotRetCNSS := 0;
                    DecGTotSalImposable := 0;
                    DecGTotImpot := 0;
                    DecGTotSalNet := 0;
                    DecGHeureSupp := 0;
                    DecGTotAccompte := 0;
                    DecGTotPret := 0;
                    DecGTotNetServi := 0;
                    DecGTotChargePat := 0;
                    DocNonImposableNonCotisable := 0;
                    ArrondiNet := 0;
                    ReportArrondi := 0;
                    MontCOVID := 0;
                    REPEAT

                        DecGTotSalBase := DecGTotSalBase + RecGSalaryLine."Real basis salary";
                        DecGTotCotImposable := DecGTotCotImposable + RecGSalaryLine."Taxable indemnities";
                        DecGTotSalBrut := DecGTotSalBrut + RecGSalaryLine."Gross Salary";
                        DecGTotRetCNSS := DecGTotRetCNSS + RecGSalaryLine."Non Taxable Soc. Contrib.";
                        DecGTotSalImposable := DecGTotSalImposable + RecGSalaryLine."Taxable salary";
                        DecGTotImpot := DecGTotImpot + RecGSalaryLine."Taxe (Month)";
                        DecGTotSalNet := DecGTotSalNet + RecGSalaryLine."Net salary";
                        DecGTotAccompte := DecGTotAccompte + RecGSalaryLine.Advances;
                        DecGTotPret := DecGTotPret + RecGSalaryLine.Loans;
                        ArrondiNet := ArrondiNet + RecGSalaryLine."Ajout  en +";
                        ReportArrondi := ReportArrondi + RecGSalaryLine."Report en -";
                        DocNonImposableNonCotisable := DocNonImposableNonCotisable + RecGSalaryLine."Non Taxable indemnities";
                        DecGTotNetServi := DecGTotNetServi + RecGSalaryLine."Net salary cashed";
                        DecGTotChargePat := DecGTotChargePat + RecGSalaryLine.Charge.AsInteger();
                    UNTIL RecGSalaryLine.NEXT = 0;

                END;

                RecGCompanyInfo.GET;
                DecGPourcentageImpot := 0;
                DecGTotChargePat := 0;
                IF DecGTotSalImposable <> 0 THEN
                    DecGPourcentageImpot := (DecGTotImpot / DecGTotSalImposable) * 100;
                IF RecGSalaryHeader.GET("Rec. Salary Lines"."No.") THEN
                    RecGSalaryHeader.CALCFIELDS("Total Employer Contributions");
                DecGTotChargePat := RecGSalaryHeader."Total Employer Contributions";
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("Employee Posting Group");
            end;
        }
    }


    var
        LastFieldNo: Integer;
        Text001: TextConst ENU = 'Total', FRA = 'Total';
        I: Integer;
        CIN: Code[20];
        "DateEntré": Date;
        NBJT: Decimal;
        SalJour: Decimal;
        MntSalJour: Decimal;
        HeureSup: Decimal;
        MntHeureSup: Decimal;
        Prime: Decimal;
        Emp: Record Employee;
        EmployeesdaysoffEntry: Record "WDC Employee's days off Entry";
        TotAbs: Decimal;
        "Heuressuperegistréesm": Record "WDC Overtime hours recorded m";
        Title: Text;
        TotHS: Decimal;
        DefaultIndemnities: Record "WDC Default Indemnities";
        DecGTotSalBase: Decimal;
        DecGTotCotImposable: Decimal;
        DecGTotSalBrut: Decimal;
        DecGTotRetCNSS: Decimal;
        DecGTotSalImposable: Decimal;
        DecGTotImpot: Decimal;
        DecGTotSalNet: Decimal;
        DecGTotAccompte: Decimal;
        DecGTotNetServi: Decimal;
        DecGTotPret: Decimal;
        RecGCompanyInfo: Record 79;
        DecGPourcentageImpot: Decimal;
        DecGTotChargePat: Decimal;
        RecGSalaryHeader: Record "WDC Posted Salary Header";
        DecGHeureSupp: Decimal;
        RecCompanyInfo: Record 79;
        Text002: TextConst ENU = 'Page', FRA = 'Page';
        Text003: TextConst ENU = 'Payroll recap:', FRA = 'Récapitulatif paie :';
        Text004: TextConst ENU = 'Employees', FRA = 'Employés';
        Text005: TextConst ENU = 'Employer CNSS No :', FRA = 'N° CNSS employeur :';
        Text006: TextConst ENU = 'Wording', FRA = 'Libellé';
        Text007: TextConst ENU = 'To keep', FRA = 'À conserver';
        Text008: TextConst ENU = 'To settle', FRA = 'À solder';
        Text009: TextConst ENU = 'Base Salary', FRA = 'Salaire de base';
        Text010: TextConst ENU = 'Absences', FRA = 'Absences';
        Text011: TextConst ENU = 'Overtime', FRA = 'Heures supplémentaires';
        Text012: TextConst ENU = 'Contributory Elements', FRA = 'Éléments contributifs';
        Text013: TextConst ENU = 'Gross Pay', FRA = 'Salaire brut';
        Text014: TextConst ENU = 'Withholding CNSS', FRA = 'Retenue CNSS';
        Text015: TextConst ENU = 'Group insurance', FRA = 'Assurance groupe';
        Text016: TextConst ENU = 'Taxable Items', FRA = 'Éléments imposables';
        Text017: TextConst ENU = 'Taxable Salary', FRA = 'Salaire imposable';
        Text018: TextConst ENU = 'Income tax', FRA = 'Impôt sur le revenu';
        Text019: TextConst ENU = 'Taxable Items', FRA = 'Éléments imposables';
        Text020: TextConst ENU = 'Net Elements', FRA = 'Éléments nets';
        Text021: TextConst ENU = 'Net Salary', FRA = 'Salaire net';
        Text022: TextConst ENU = 'Deposit', FRA = 'Dépôt';
        Text023: TextConst ENU = 'Ready restraint', FRA = 'Retenue prête';
        Text024: TextConst ENU = 'Rounding Net to Pay', FRA = 'Arrondi Net à payer';
        Text025: TextConst ENU = 'Rounding Report', FRA = 'Rapport d''arrondi';
        Text026: TextConst ENU = 'Optional Elements', FRA = 'Éléments facultatifs';
        Text027: TextConst ENU = 'Net Pay', FRA = 'Net à payer';
        Text028: TextConst ENU = 'Employer charges', FRA = 'Charges employeurs';
        RecGSalaryLine: Record "WDC Salary Lines";
        DocNonImposableNonCotisable: Decimal;
        Text029: TextConst ENU = 'Commission', FRA = 'Commission';
        ArrondiNet: Decimal;
        ReportArrondi: Decimal;
        TotalHeureSup: Decimal;
        MontCOVID: Decimal;
        DescCOVID: Text[50];
        RecGSocialContr: Record "WDC Social Contributions";


    procedure fctGetvalue(Nopaie: Code[20]) Return: Decimal
    var
        RecLSalaryLine: Record "WDC Salary Lines";
        X: Decimal;
    begin
        RecLSalaryLine.RESET;
        RecLSalaryLine.SETRANGE("No.", Nopaie);
        IF RecLSalaryLine.FINDSET THEN BEGIN
            X := 0;
            REPEAT
                X := X + RecLSalaryLine."Basis salary";
            UNTIL RecLSalaryLine.NEXT = 0;
            Return := X;
        END;
    end;
}

