report 55022 "WDC CNSS Declaration"
{
    CaptionML = ENU = 'CNSS Declaration', FRA = 'Déclaration CNSS';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/DeclarationCNSS.rdlc';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Cname; Name)
            {
            }
            column(Cadresse; "Company Information".Address + ' ' + "Company Information"."Address 2")
            {
            }
            column(CCNSS; "Company Information"."Executive Director 2")
            {
            }
            column(CMatF; "VAT Registration No.")
            {
            }
            column("Année"; Year)
            {
            }
            column(Xtrimestre; xTrimestre)
            {
            }
            column(Picture; "Company Information".Picture)
            {
            }
            column(CodeExploit; CodeExploit)
            {
            }
            column(BureauCNSS; "APE Code")
            {
            }
            dataitem(Employee; Employee)
            {
                DataItemTableView = SORTING("No.")
                                    ORDER(Ascending);
                column(Matricule; Employee."No.")
                {
                }
                column(NomPrenom; Employee."Last Name" + ' ' + Employee."First Name")
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
                column(Mois3; mois3)
                {
                }
                column(Total; Total)
                {
                }
                column(NumCNSS; "Social Security No.")
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
                column(Reportss; Reportss)
                {
                }

                trigger OnAfterGetRecord()
                var
                    CdumngSalary: Codeunit 55023;
                begin
                    CLEAR(RecGCnssEnreg[1]);
                    CLEAR(RecGCnssEnreg[2]);
                    CLEAR(RecGCnssEnreg[3]);
                    CLEAR(RecGCnssEnreg[4]);
                    mois1 := 0;
                    mois2 := 0;
                    mois3 := 0;
                    Total2 := Total2 + Total3;
                    Total := 0;

                    RecGCnssEnreg[1].RESET;
                    RecGCnssEnreg[1].SETRANGE("Employee No.", "No.");
                    RecGCnssEnreg[1].SETRANGE(Year, Year);
                    RecGCnssEnreg[1].SETRANGE("Social Contribution", CODECNSS);

                    IF ActivFiltrePaie THEN
                        RecGCnssEnreg[1].SETFILTER("No.", PaieFrom."No.");
                    IF RecGCnssEnreg[1].FINDSET THEN BEGIN
                        CASE xTrimestre OF
                            0:
                                BEGIN
                                    RecGCnssEnreg[2].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[2].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[2].SETRANGE("Posting date", DMY2DATE(1, 1, Year), DMY2DATE(31, 1, Year));
                                    RecGCnssEnreg[2].SETFILTER("Base Amount", '<>%1', 0);

                                    RecGCnssEnreg[3].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[3].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[3].SETRANGE("Posting date", DMY2DATE(1, 2, Year), DMY2DATE(28, 2, Year));
                                    RecGCnssEnreg[3].SETFILTER("Base Amount", '<>%1', 0);

                                    RecGCnssEnreg[4].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[4].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[4].SETRANGE("Posting date", DMY2DATE(1, 3, Year), DMY2DATE(31, 3, Year));
                                    RecGCnssEnreg[4].SETFILTER("Base Amount", '<>%1', 0);

                                END;

                            1:
                                BEGIN
                                    RecGCnssEnreg[2].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[2].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[2].SETRANGE("Posting date", DMY2DATE(1, 4, Year), DMY2DATE(30, 4, Year));
                                    RecGCnssEnreg[2].SETFILTER("Base Amount", '<>%1', 0);

                                    RecGCnssEnreg[3].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[3].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[3].SETRANGE("Posting date", DMY2DATE(1, 5, Year), DMY2DATE(31, 5, Year));
                                    RecGCnssEnreg[3].SETFILTER("Base Amount", '<>%1', 0);

                                    RecGCnssEnreg[4].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[4].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[4].SETRANGE("Posting date", DMY2DATE(1, 6, Year), DMY2DATE(30, 6, Year));
                                    RecGCnssEnreg[4].SETFILTER("Base Amount", '<>%1', 0);
                                END;
                            2:
                                BEGIN
                                    RecGCnssEnreg[2].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[2].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[2].SETRANGE("Posting date", DMY2DATE(1, 7, Year), DMY2DATE(31, 7, Year));
                                    RecGCnssEnreg[2].SETFILTER("Base Amount", '<>%1', 0);

                                    RecGCnssEnreg[3].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[3].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[3].SETRANGE("Posting date", DMY2DATE(1, 8, Year), DMY2DATE(31, 8, Year));
                                    RecGCnssEnreg[3].SETFILTER("Base Amount", '<>%1', 0);

                                    RecGCnssEnreg[4].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[4].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[4].SETRANGE("Posting date", DMY2DATE(1, 9, Year), DMY2DATE(30, 9, Year));
                                    RecGCnssEnreg[4].SETFILTER("Base Amount", '<>%1', 0);


                                END;

                            3:
                                BEGIN
                                    RecGCnssEnreg[2].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[2].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[2].SETRANGE("Posting date", DMY2DATE(1, 10, Year), DMY2DATE(31, 10, Year));
                                    RecGCnssEnreg[2].SETFILTER("Base Amount", '<>%1', 0);

                                    RecGCnssEnreg[3].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[3].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[3].SETRANGE("Posting date", DMY2DATE(1, 11, Year), DMY2DATE(30, 11, Year));
                                    RecGCnssEnreg[3].SETFILTER("Base Amount", '<>%1', 0);

                                    RecGCnssEnreg[4].COPYFILTERS(RecGCnssEnreg[1]);
                                    RecGCnssEnreg[4].SETRANGE("Social Contribution", RecGCnssEnreg[1]."Social Contribution");
                                    RecGCnssEnreg[4].SETRANGE("Posting date", DMY2DATE(1, 12, Year), DMY2DATE(31, 12, Year));
                                    RecGCnssEnreg[4].SETFILTER("Base Amount", '<>%1', 0);



                                END;
                        END;

                        IF RecGCnssEnreg[2].FINDFIRST THEN BEGIN
                            REPEAT
                                CLEAR(RecSalary);
                                RecSalary.SETRANGE("No.", RecGCnssEnreg[2]."No.");
                                RecSalary.SETRANGE("Employee No.", RecGCnssEnreg[2]."Employee No.");
                                RecSalary.SETFILTER("Non Taxable Soc. Contrib.", '<>%1', 0); //WDC
                                IF RecSalary.FINDSET THEN
                                    IF RecSalary."Non Taxable Soc. Contrib." <> 0 THEN BEGIN
                                        Total := Total + RecGCnssEnreg[2]."Base Amount";
                                        mois1 := mois1 + RecGCnssEnreg[2]."Base Amount";
                                    END;
                            UNTIL RecGCnssEnreg[2].NEXT = 0
                        END;
                        IF RecGCnssEnreg[3].FINDFIRST THEN BEGIN
                            REPEAT
                                CLEAR(RecSalary);
                                RecSalary.SETRANGE("No.", RecGCnssEnreg[3]."No.");
                                RecSalary.SETRANGE("Employee No.", RecGCnssEnreg[3]."Employee No.");
                                RecSalary.SETFILTER("Non Taxable Soc. Contrib.", '<>%1', 0); //WDC
                                IF RecSalary.FINDSET THEN
                                    IF RecSalary."Non Taxable Soc. Contrib." <> 0 THEN BEGIN
                                        Total := Total + RecGCnssEnreg[3]."Base Amount";
                                        mois2 := mois2 + RecGCnssEnreg[3]."Base Amount";
                                    END;
                            UNTIL RecGCnssEnreg[3].NEXT = 0
                        END;

                        IF RecGCnssEnreg[4].FINDFIRST THEN BEGIN
                            REPEAT
                                CLEAR(RecSalary);
                                RecSalary.SETRANGE("No.", RecGCnssEnreg[4]."No.");
                                RecSalary.SETRANGE("Employee No.", RecGCnssEnreg[4]."Employee No.");
                                RecSalary.SETFILTER("Non Taxable Soc. Contrib.", '<>%1', 0); //WDC
                                IF RecSalary.FINDSET THEN
                                    IF RecSalary."Non Taxable Soc. Contrib." <> 0 THEN BEGIN
                                        Total := Total + RecGCnssEnreg[4]."Base Amount";
                                        mois3 := mois3 + RecGCnssEnreg[4]."Base Amount";
                                    END;
                            UNTIL RecGCnssEnreg[4].NEXT = 0
                        END;

                        Total := ROUND(Total, 0.001);
                        Reportss := Reportss + Total;
                        Total3 := ROUND(Total, 0.001);
                        IF Total > 0 THEN
                            i := i + 1;
                    END;
                    //Hatem
                    IF Total > 0 THEN BEGIN
                        Nombreligne := Nombreligne + 1;
                        TotalLigne := TotalLigne + 1;
                    END;
                    IF Nombreligne > 12 THEN
                        Nombreligne := 1;
                    //Hatem
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

                    //Fin
                    TexteTotal := '';
                    cumtotal := cumtotal + Total;
                    Convert."Montant en texte sans millimes"(TexteTotal, cumtotal);

                    IF NOT (RecGCnssEnreg[1].FINDSET AND (Total > 0)) THEN CurrReport.SKIP;
                end;

                trigger OnPreDataItem()
                begin

                    LastFieldNo := FIELDNO("No.");
                    Total2 := 0;
                    i := 0;
                    j := 0;
                    m := 0;
                    //*** HK DSFT
                    GLSetup.GET;
                    //DMin:= GLSetup."Allow Posting From";
                    DMin := 20010101D;
                    An := DATE2DMY(DMin, 3);

                    CASE xTrimestre OF
                        0:
                            BEGIN
                                LibMois1 := FORMAT(CALCDATE('+0M', DMin), 0, '<Month text>');
                                LibMois2 := FORMAT(CALCDATE('+1M', DMin), 0, '<Month text>');
                                LibMois3 := FORMAT(CALCDATE('+2M', DMin), 0, '<Month text>');
                            END;

                        1:
                            BEGIN
                                LibMois1 := FORMAT(CALCDATE('+3M', DMin), 0, '<Month text>');
                                LibMois2 := FORMAT(CALCDATE('+4M', DMin), 0, '<Month text>');
                                LibMois3 := FORMAT(CALCDATE('+5M', DMin), 0, '<Month text>');

                            END;
                        2:
                            BEGIN

                                LibMois1 := FORMAT(CALCDATE('+6M', DMin), 0, '<Month text>');
                                LibMois2 := FORMAT(CALCDATE('+7M', DMin), 0, '<Month text>');
                                LibMois3 := FORMAT(CALCDATE('+8M', DMin), 0, '<Month text>');


                            END;

                        3:
                            BEGIN
                                LibMois1 := FORMAT(CALCDATE('+9M', DMin), 0, '<Month text>');
                                LibMois2 := FORMAT(CALCDATE('+10M', DMin), 0, '<Month text>');
                                LibMois3 := FORMAT(CALCDATE('+11M', DMin), 0, '<Month text>');

                            END;
                    END;

                    //*** HK DSFT
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "Company Information".CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Activer Filtre "; ActivFiltrePaie)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        IF NOT ActivFiltrePaie THEN PaieFrom."No." := '';
                    end;
                }
                field(FiltrePaie; PaieFrom."No.")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    var
                        lText001: TextConst ENU = 'Warning: Activate the filter to be able to use the pay option',
                                            FRA = 'Attention : Activer le filtre, pour pouvoir Utiliser le choix paie ';
                    begin
                        IF NOT ActivFiltrePaie THEN ERROR(lText001);
                        CLEAR(F39001471);
                        IF F39001471.RUNMODAL = ACTION::LookupOK
                          THEN BEGIN
                            F39001471.GETRECORD(PaieFrom);
                            Year := PaieFrom.Year;
                            Trimestre := PaieFrom.Month.AsInteger() MOD 2;
                        END;

                        RequestOptionsPage.UPDATE;
                    end;
                }
                field("Year"; Year)
                {
                    ApplicationArea = all;
                }
                field(Trimestre; xTrimestre)
                {
                    ApplicationArea = all;
                }
                field("Code CNSS"; CODECNSS)
                {
                    ApplicationArea = all;
                    TableRelation = "WDC Social Contribution";

                    trigger OnValidate()
                    begin
                        RecGSocContribution.RESET;
                        IF RecGSocContribution.GET(CODECNSS) THEN
                            CodeExploit := RecGSocContribution."Exploitation Code" ELSE
                            CodeExploit := '';
                    end;
                }
                field(CodeExploit; CodeExploit)
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
            }
        }

        trigger OnOpenPage()
        begin
            ActivFiltrePaie := FALSE;
        end;
    }

    trigger OnInitReport()
    begin
        cumtotal := 0;
        Year := DATE2DMY(WORKDATE, 3);

        xTrimestre := (DATE2DMY(WORKDATE, 2) - 1) DIV 3;
    end;

    trigger OnPreReport()
    begin
        IF CODECNSS <> '' THEN
            TCNSS := CODECNSS;
    end;

    var
        F39001471: Page 55044;
        PaieFrom: Record "WDC Posted Salary Header";
        LastFieldNo: Integer;
        xTrimestre: Option "1er trimetre","2ème trimestre","3ème trimestre","4ème trimestre";
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
        DMin: Date;
        An: Integer;
        GLSetup: Record 98;
        TCNSS: Code[20];
        Convert: Codeunit 55028;
        CODECNSS: Code[20];
        Nombreligne: Integer;
        TotalLigne: Integer;
        pagination: Integer;
        PageLigne: Integer;
        TexteTotal: Text[1024];
        cumtotal: Decimal;
        Trimestre: Integer;
        ActivFiltrePaie: Boolean;
        RecGSocContribution: Record "WDC Social Contribution";
        CodeExploit: Code[20];
        Reportss: Decimal;
        RecGCnssEnreg: array[4] of Record "WDC Rec. Social Contributions";
        RecSalary: Record "WDC Posted Salary Lines";
}

