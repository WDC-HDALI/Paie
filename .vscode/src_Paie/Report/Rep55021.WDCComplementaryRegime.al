report 55021 "WDC Complementary Regime"
{
    CaptionML = ENU = 'Complementary Regime', FRA = 'Régime Complémentaire';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/RegimeComplementaire.rdlc';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Cname; "Company Information".Name)
            {
            }
            column(Cadresse; "Company Information".Address)
            {
            }
            column(CCNSS; "Company Information"."Executive Director 2")
            {
            }
            column(CMatF; "Company Information"."VAT Registration No.")
            {
            }
            column("Année"; Year)
            {
            }
            column(Xtrimestre; XTrimester)
            {
            }
            dataitem(Employee; Employee)
            {
                DataItemTableView = SORTING("Social Security No.")
                                    ORDER(Ascending)
                                    WHERE("Social Security No." = FILTER(<> ''),
                                          "No." = FILTER(<> 1000 & <> 2027));
                column(Matricule; Employee."No.")
                {
                }
                column(NomPrenom; Employee."First Name" + '  ' + Employee."Last Name")
                {
                }
                column(Fonction; Employee.Title)
                {
                }
                column(Adresse; Employee.Address)
                {
                }
                column(Libmois1; LibMois1)
                {
                }
                column(Libmois2; LibMois2)
                {
                }
                column(Libmois3; LibMois3)
                {
                }
                column(Mois1; mois1)
                {
                }
                column(Mois2; mois2)
                {
                }
                column(Mois3s; mois3)
                {
                }
                column(Total; Total)
                {
                }
                column(NumCNSS; Employee."Social Security No.")
                {
                }
                column(NombreLigne; Nombreligne)
                {
                }
                column(TotalLigne; TotalLigne)
                {
                }
                column(Pagination; pagination)
                {
                }
                column(Cumtotal; cumtotal)
                {
                }
                column(TexteTotal; TexteTotal)
                {
                }
                column(Plafonne; Plafonne)
                {
                }
                column(EmploymentDate; "Employment Date")
                {
                }
                column(Differentiel; Differentiel)
                {
                }
                column(TotBrut; TotBrut)
                {
                }
                column(TotPlafond; TotPlafond)
                {
                }
                column(TotDif; TotDif)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    HRSetup.GET;
                    CLEAR(LigneSalaireEnreg1);
                    CLEAR(LigneSalaireEnreg2);
                    CLEAR(LigneSalaireEnreg3);
                    CLEAR(LigneSalaireEnreg);
                    mois1 := 0;
                    mois2 := 0;
                    mois3 := 0;
                    Total2 := Total2 + Total3;
                    Total := 0;
                    Differentiel := 0;
                    Nbrpaie := 0;
                    CASE xTrimester OF
                        0:
                            Plafonne := 6 * HRSetup."Minimum wage guarantee" * 3;
                        1:
                            Plafonne := 6 * HRSetup."Minimum wage guarantee" * 12;
                    END;

                    Total := 0;
                    PlafondCAVIS := 0;
                    LigneSalaireEnreg.RESET;
                    LigneSalaireEnreg.SETRANGE("Employee No.", Employee."No.");
                    LigneSalaireEnreg.SETRANGE(LigneSalaireEnreg.Year, Year);
                    LigneSalaireEnreg.SETRANGE(LigneSalaireEnreg."Posting Date", FilterDate1, FilterDate2);
                    IF LigneSalaireEnreg.FINDSET THEN
                        Nbrpaie := LigneSalaireEnreg.COUNT;
                    REPEAT
                        Total := Total + LigneSalaireEnreg."Gross Salary";
                        PlafondCAVIS += LigneSalaireEnreg."6 SMIG";// supprilmer aprè-s dec 2022
                    UNTIL LigneSalaireEnreg.NEXT = 0;
                    IF Nbrpaie = 0 THEN CurrReport.SKIP;
                    IF PlafondCAVIS >= Total THEN CurrReport.SKIP;
                    IF Nbrpaie >= 12 THEN BEGIN
                        PlafondCAVIS := (PlafondCAVIS / Nbrpaie) * 12; // supprilmer aprè-s dec 2022
                        Nbrpaie := 12;
                        //Plafonne:=6*HRSetup."Minimum wage guarantee"*Nbrpaie; // activer aprè-s dec 2022
                        Plafonne := PlafondCAVIS;// supprilmer aprè-s dec 2022
                    END;
                    IF Plafonne > 30240 THEN Plafonne := 30240;
                    Total := ROUND(Total, 0.001);
                    Total3 := ROUND(Total, 0.001);
                    Differentiel := Total - Plafonne;
                    IF Differentiel < 0 THEN
                        CurrReport.SKIP;

                    IF Differentiel > 0 THEN
                        i := i + 1;

                    //Hatem
                    IF Differentiel > 0 THEN BEGIN
                        TotBrut := TotBrut + Total;
                        TotPlafond := TotPlafond + Plafonne;
                        TotDif := TotDif + Differentiel;
                        Nombreligne := Nombreligne + 1;
                        TotalLigne := TotalLigne + 1;
                    END;


                    PageLigne := 12;
                    CASE TotalLigne OF
                        1 .. PageLigne:
                            pagination := 1;
                        PageLigne + 1 .. (PageLigne) * 2:
                            pagination := 2;
                        (PageLigne * 2) + 1 .. (PageLigne * 3):
                            pagination := 3;
                        (PageLigne * 3) + 1 .. (PageLigne * 4):
                            pagination := 4;
                        (PageLigne * 4) + 1 .. (PageLigne * 5):
                            pagination := 5;
                        (PageLigne * 5) + 1 .. (PageLigne * 6):
                            pagination := 6;
                        (PageLigne * 6) + 1 .. (PageLigne * 7):
                            pagination := 7;
                        (PageLigne * 7) + 1 .. (PageLigne * 8):
                            pagination := 8;
                        (PageLigne * 8) + 1 .. (PageLigne * 9):
                            pagination := 9;
                        (PageLigne * 9) + 1 .. (PageLigne * 10):
                            pagination := 10;
                        (PageLigne * 10) + 1 .. (PageLigne * 11):
                            pagination := 11;
                        (PageLigne * 11) + 1 .. (PageLigne * 12):
                            pagination := 12;
                        (PageLigne * 12) + 1 .. (PageLigne * 13):
                            pagination := 13;
                        (PageLigne * 13) + 1 .. (PageLigne * 14):
                            pagination := 14;
                        (PageLigne * 14) + 1 .. (PageLigne * 15):
                            pagination := 15;
                    END;


                    TexteTotal := '';
                    Convert."Montant en texte sans millimes"(TexteTotal, TotBrut);
                end;

                trigger OnPreDataItem()
                begin

                    i := 0;
                    j := 0;
                    m := 0;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Year"; Year)
                {
                    captionML = ENU = 'Year', FRA = 'Année';
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        EVALUATE(FilterDate1, '01/01/' + FORMAT(Year));
                        EVALUATE(FilterDate2, '31/12/' + FORMAT(Year));
                        FilterDate1 := FilterDate1;
                        FilterDate2 := FilterDate2;
                    end;
                }
                field(Trimester; xTrimester)
                {
                    captionML = ENU = 'Trimester', FRA = 'Trimestre';
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        IF xTrimester = 0 THEN BEGIN
                            FilterDate1 := 0D;
                            FilterDate2 := 0D;
                        END ELSE BEGIN
                            EVALUATE(FilterDate1, '01/01/' + FORMAT(Year));
                            EVALUATE(FilterDate2, '31/12/' + FORMAT(Year));
                            FilterDate1 := FilterDate1;
                            FilterDate2 := FilterDate2;

                        END;
                    end;
                }
                field("Start Date"; FilterDate1)
                {
                    captionML = ENU = 'Start Date', FRA = 'Date début';
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        IF DATE2DMY(FilterDate1, 3) <> Year THEN ERROR(errordate, Year);
                    end;
                }
                field("End Date"; FilterDate2)
                {
                    captionML = ENU = 'End Date', FRA = 'Date fin';
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        IF DATE2DMY(FilterDate2, 3) <> Year THEN ERROR(errordate, Year);
                    end;
                }
            }
        }

        trigger OnOpenPage()
        begin
            xTrimester := 1;
        end;
    }


    trigger OnInitReport()
    begin
        cumtotal := 0;
        Year := DATE2DMY(WORKDATE, 3);
        EVALUATE(FilterDate1, '01/01/' + FORMAT(Year));
        EVALUATE(FilterDate2, '31/12/' + FORMAT(Year));
        FilterDate1 := FilterDate1;
        FilterDate2 := FilterDate2;
    end;

    trigger OnPreReport()
    begin
        IF CODECNSS <> '' THEN
            TCNSS := CODECNSS;
    end;

    var
        LigneSalaireEnreg: Record "WDC Posted Salary Lines";
        LigneSalaireEnreg1: Record "WDC Posted Salary Lines";
        LigneSalaireEnreg2: Record "WDC Posted Salary Lines";
        LigneSalaireEnreg3: Record "WDC Posted Salary Lines";
        xTrimester: Option Trimestre,Année;

        Year: Integer;
        Total: Decimal;
        Total2: Decimal;
        Total3: Decimal;
        mois1: Decimal;
        mois2: Decimal;
        mois3: Decimal;
        i: Integer;
        j: Integer;
        m: Integer;
        LibMois1: Text[30];
        LibMois2: Text[30];
        LibMois3: Text[30];
        TCNSS: Code[20];
        Convert: Codeunit 55028;
        CODECNSS: Code[20];
        Nombreligne: Integer;
        TotalLigne: Integer;
        pagination: Integer;
        PageLigne: Integer;
        TexteTotal: Text[1024];
        cumtotal: Decimal;
        HRSetup: Record "Human Resources Setup";
        Plafonne: Decimal;
        Differentiel: Decimal;
        TotBrut: Decimal;
        TotPlafond: Decimal;
        TotDif: Decimal;
        FilterDate1: Date;
        FilterDate2: Date;
        errordate: Label 'Date doit appertenir à l''Year %1';
        Nbrpaie: Integer;
        PlafondCAVIS: Decimal;

}

