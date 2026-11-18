report 55009 "WDC Employee Tax Declaration"
{
    CaptionML = ENU = 'Employees Tax Declaration', FRA = 'Déclaration d''impôts salariés';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/Déclarationdimpôtsalarié.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column("NomSociété"; CompanyInf.Name)
            {
            }
            column("AdresseSociété"; CompanyInf.Address)
            {
            }
            column("AdresseSociété2"; CompanyInf."Address 2")
            {
            }
            column(RegistreCommerce; CompanyInf."Registration No.")
            {
            }
            column(CNSS; CompanyInf."Executive Director 2")
            {
            }
            column(AdresseCompany; CompanyInf.Address)
            {
            }
            column(CodePost; CompanyInf."Post Code")
            {
            }
            column(Ville; CompanyInf.City)
            {
            }
            column(Picture; CompanyInf.Picture)
            {
            }
            column(Matricule; Employee."No.")
            {
            }
            column(Employee_Echelon; Employee.Echelon)
            {
            }
            column(Employee_N_Passeport; Employee."Passeport No.")
            {
            }
            column(NumCIN; "CIN No.")
            {
            }
            column(NometPrenom; "Last Name" + ' ' + "First Name")
            {
            }
            column(Last_Name; Employee."Last Name")
            {
            }
            column(Fonction; Employee.Title)
            {
            }
            column(Employee_Middle_Name; Employee."Middle Name")
            {
            }
            column(Adresse; Address)
            {
            }
            column(City; City)
            {
            }
            column(CodePostal; "Post Code")
            {
            }
            column(NombreEnfant; "Loaded childs")
            {
            }
            column(Year; Year)
            {
            }
            column("CNSSSalarié"; "Social Security No.")
            {
            }
            column(CompanyCity; CompanyInf.City)
            {
            }
            column(SituationFamTexte; "Family Situation A")
            {
            }
            column(Employee_College; Employee.College)
            {
            }
            column(Employee_Familly_chief; verify)
            {
            }
            column(Employee_Deduction_Loaded_child; Employee."Deduction Loaded child")
            {
            }
            column(NBMOIS; NBMOIS)
            {
            }
            column(SalaireImposableAnnuel; SalaireImposableAnnuel)
            {
            }
            column(SalaireBrutAnnuel; SalaireBrutAnnuel)
            {
            }
            column(ImpotAnnuel; ImpotAnnuel)
            {
            }
            column(RCGC; RCGC)
            {
            }
            column(RetraitePlus; RetraitePlus)
            {
            }
            column(NbEnfant; Employee."Loaded childs")
            {
            }
            column(SitFam; Employee."Family Situation A")
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Employee."Family chief" THEN BEGIN
                    verify := 'OUI';
                END ELSE
                    verify := 'NON';
                ImpotAnnuel := 0;
                SalaireNetAnnuel := 0;
                SalaireImposableAnnuel := 0;
                SalaireBrutAnnuel := 0;
                RetraitePlus := 0;
                RCGC := 0;
                NBMOIS := 0;
                RecSalaryLines.RESET;
                RecSalaryLines.SETRANGE(RecSalaryLines."Employee No.", Employee."No.");
                RecSalaryLines.SETRANGE(RecSalaryLines.Year, Year);
                //WDC01 RecSalaryLines.SETFILTER(RecSalaryLines."Non Taxable Soc. Contrib.",'<>%1',0);
                IF RecSalaryLines.FINDFIRST THEN BEGIN
                    REPEAT
                        NBMOIS := NBMOIS + 1;
                    UNTIL RecSalaryLines.NEXT = 0;
                END ELSE
                    CurrReport.SKIP;
                IF NBMOIS > 12 THEN NBMOIS := 12;
                RecSalaryLines.RESET;
                RecSalaryLines.SETRANGE(RecSalaryLines."Employee No.", Employee."No.");
                RecSalaryLines.SETRANGE(RecSalaryLines.Year, Year);
                //WDC01 RecSalaryLines.SETFILTER(RecSalaryLines."Non Taxable Soc. Contrib.",'<>%1',0);
                IF RecSalaryLines.FINDFIRST THEN BEGIN
                    REPEAT
                        ImpotAnnuel := ImpotAnnuel + RecSalaryLines."Taxe (Month)";
                        ;
                        SalaireImposableAnnuel := SalaireImposableAnnuel + RecSalaryLines."Taxable salary";
                        SalaireNetAnnuel := SalaireNetAnnuel + RecSalaryLines."Net salary";
                        SalaireBrutAnnuel := SalaireBrutAnnuel + RecSalaryLines."Gross Salary";
                        RetraitePlus += RecSalaryLines."Retirement plus";
                        RCGC := RCGC + RecSalaryLines."CSS Tax";
                    UNTIL RecSalaryLines.NEXT = 0;
                END ELSE
                    CurrReport.SKIP;

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
                    ApplicationArea = all;
                }
            }
        }
    }



    trigger OnInitReport()
    begin
        CompanyInf.GET;
        CompanyInf.CALCFIELDS(Picture);
        Year := DATE2DMY(WORKDATE, 3);
    end;

    var
        "Compte bancaire salarié": Record "WDC Employee Bank Account";
        CompanyInf: Record 79;
        LnSalaireEnreg: Record "WDC Salary Lines";
        Year: Integer;
        ln: Integer;
        txt: Text[50];
        ImpotAnnuel: Decimal;
        SalaireImposableAnnuel: Decimal;
        SalaireNetAnnuel: Decimal;
        SalaireBrutAnnuel: Decimal;
        RecSalaryLines: Record "WDC Salary Lines";
        NBMOIS: Integer;
        RCGC: Decimal;
        verify: Text[20];
        RetraitePlus: Decimal;
        SitFam: Text[12];
}

