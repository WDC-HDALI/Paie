report 55010 "WDC Employer Declaration"
{
    CaptionML = ENU = 'Employer Declaration', FRA = 'Déclaration Employeur';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/DéclarationEmployeur.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(Matricule; Employee."No.")
            {
            }
            column(Sym; Employee."No.")
            {
            }
            column(NumCIN; "CIN No.")
            {
            }
            column(NometPrenom; "First Name" + ' ' + "Last Name")
            {
            }
            column(Fonction; Title)
            {
            }
            column(Adresse; Address)
            {
            }
            column(chef; cheffam)
            {
            }
            column(City; City)
            {
            }
            column(CodePostal; "Post Code")
            {
            }
            column(SituationFamiliale; SIT)
            {
            }
            column(NombreEnfant; "Loaded childs")
            {
            }
            column(DateDebut; DATEDEB)
            {
            }
            column(DateFin; DATEFIN)
            {
            }
            column(RevenuImposable; "Taxable salary")
            {
            }
            column(RevenuBrutImposable; "Tot Brut salary")
            {
            }
            column(MontantdesRetenues; "Taxe (Month)")
            {
            }
            column(RetPlus; Retplus)
            {
            }
            column(Net; Net)
            {
            }
            column(Line; Line)
            {
            }
            column(Year; Year)
            {
            }
            column(Pagination; Partition2)
            {
            }
            column("NomSociété"; CompanyInf.Name)
            {
            }
            column("AdresseSociété"; CompanyInf.Address)
            {
            }
            column(RegistreCommerce; CompanyInf."Trade Register")
            {
            }
            column(CNSS; CompanyInf."Executive Director 2")
            {
            }
            column(AdresseCompany; CompanyInf.Address)
            {
            }
            column(RCGC; RCGC)
            {
            }
            column(NombreLigne; NombreLigne)
            {
            }
            column(TotNet; TotNet)
            {
            }
            column(TotTaxe; TotTaxe)
            {
            }
            column(TotRCGC; TotRCGC)
            {
            }
            column(TotTaxSalary; TotTaxSalary)
            {
            }
            column(T3; T3)
            {
            }
            column(CSS; CSS1)
            {
            }
            column(TOTCSS; TotCSS)
            {
            }
            column(TotRetPlus; TotRetPlus)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF "Residence Permit" = TRUE THEN
                    Sym := 3
                ELSE
                    Sym := 2;

                IF "Family Situation A" = "Family Situation A"::Single THEN
                    SIT := 1
                ELSE IF "Family Situation A" = "Family Situation A"::Married THEN
                    SIT := 2
                ELSE IF "Family Situation A" = "Family Situation A"::Divorced THEN
                    SIT := 3
                ELSE IF "Family Situation A" = "Family Situation A"::Widowed THEN SIT := 4;


                IF "Family chief" THEN cheffam := 'Oui' ELSE cheffam := 'Non';
                //DATEW := 0D;
                //DATEFW := 0D;
                JW := 1;
                MW := 1;
                AW := Year;//DATE2DMY(WORKDATE,3); MBY
                DATEW := DMY2DATE(JW, MW, AW);

                IF "Employment Date" < DATEW THEN
                    DATEDEB := DATEW
                ELSE
                    DATEDEB := "Employment Date";

                JFW := 31;
                MFW := 12;
                AFW := Year;//DATE2DMY(WORKDATE,3);
                DATEFW := DMY2DATE(JFW, MFW, AFW);
                IF DATE2DMY(WORKDATE, 3) = Year THEN
                    DATEFW := WORKDATE;

                DATEFIN := DATEFW;
                IF "Inactive Date" <> 0D THEN
                    IF "Inactive Date" < DATEFW THEN
                        DATEFIN := "Inactive Date";

                Line := Line + 1;
                "Rec. Salary Lines".RESET;
                "Rec. Salary Lines".SETRANGE(Year, Year);
                "Rec. Salary Lines".SETRANGE("Employee No.", "No.");
                Net := 0;
                "Taxe (Month)" := 0;
                "Taxable salary" := 0;
                "Tot Brut salary" := 0;
                TotCSS := 0;
                CSS1 := 0;
                Retplus := 0;
                RCGC := 0;
                //WDC01 "Rec. Salary Lines".SETFILTER("Non Taxable Soc. Contrib.",'<>%1',0);
                IF "Rec. Salary Lines".FINDFIRST THEN
                    REPEAT
                        Net := Net + ("Rec. Salary Lines"."Taxable salary" - "Rec. Salary Lines"."Taxe (Month)" -
                                            "Rec. Salary Lines"."CSS Tax");
                        "Taxe (Month)" := "Taxe (Month)" + "Rec. Salary Lines"."Taxe (Month)";
                        "Taxable salary" := "Taxable salary" + "Rec. Salary Lines"."Taxable salary";
                        "Tot Brut salary" := "Tot Brut salary" + "Rec. Salary Lines"."Taxable salary";
                        CSS1 := CSS1 + "Rec. Salary Lines"."CSS Tax";
                        Retplus += "Rec. Salary Lines"."Retirement plus"
                    UNTIL "Rec. Salary Lines".NEXT = 0;
                IF Net = 0 THEN
                    CurrReport.SKIP;
                //>>
                "Rec. Salary Lines".RESET;
                "Rec. Salary Lines".SETRANGE(Year, Year);
                IF "Rec. Salary Lines".FINDSET THEN BEGIN
                    TotNet := 0;
                    TotTaxe := 0;
                    TotRCGC := 0;
                    TotTaxSalary := 0;
                    TotRetPlus := 0;
                    REPEAT
                        TotNet += ("Rec. Salary Lines"."Taxable salary" - "Rec. Salary Lines"."Taxe (Month)" -
                                    "Rec. Salary Lines"."CSS Tax");
                        TotTaxe := TotTaxe + "Rec. Salary Lines"."Taxe (Month)";
                        TotTaxSalary := TotTaxSalary + "Rec. Salary Lines"."Taxable salary";
                        TotCSS := TotCSS + "Rec. Salary Lines"."CSS Tax";
                        TotRetPlus := "Rec. Salary Lines"."Retirement plus"
                    UNTIL "Rec. Salary Lines".NEXT = 0;
                END;
                //---------------------
                //<<
                increment += 1;
                NombreLigne := 10;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Year; Year)
                {
                    CaptionML = ENU = 'Year', FRA = 'Année';
                    ApplicationArea = all;
                }
            }
        }

    }


    trigger OnInitReport()
    begin
        CompanyInf.GET;
        Line := 0;
        Year := DATE2DMY(WORKDATE, 3);
        T1 := 0;
        T2 := 0;
        T3 := 0;
        T4 := 0;
    end;

    var
        Year: Integer;
        Line: Integer;
        "Rec. Salary Lines": Record "WDC Salary Lines";
        Net: Decimal;
        "Taxe (Month)": Decimal;
        "Taxable salary": Decimal;
        T1: Decimal;
        T2: Decimal;
        T3: Decimal;
        Sym: Integer;
        SIT: Integer;
        "Tot Brut salary": Decimal;
        T4: Decimal;
        JW: Integer;
        MW: Integer;
        AW: Integer;
        JFW: Integer;
        MFW: Integer;
        AFW: Integer;
        DATEDEB: Date;
        DATEFIN: Date;
        DATEW: Date;
        DATEFW: Date;
        increment: Integer;
        NombreLigne: Integer;
        Partition2: Integer;
        CompanyInf: Record 79;
        RCGC: Decimal;
        TotNet: Decimal;
        TotTaxe: Decimal;
        TotRCGC: Decimal;
        TotTaxSalary: Decimal;
        cheffam: Text[5];
        CSS1: Decimal;
        TotCSS: Decimal;
        Retplus: Decimal;
        TotRetPlus: Decimal;
}

