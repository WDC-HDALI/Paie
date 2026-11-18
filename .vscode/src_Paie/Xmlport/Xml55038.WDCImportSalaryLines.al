xmlport 55038 "WDC Import Salary Lines"
{
    captionML = ENU = 'Import Salary Lines', FRA = 'Import Lignes de Salaire';
    Direction = Import;
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Salary Lines"; "WDC Salary Lines")
            {
                XmlName = 'ContactHeader';
                fieldelement(Paie; "Salary Lines"."No.")
                {
                }
                fieldelement(Employee; "Salary Lines"."Employee No.")
                {
                }
                fieldelement(Month; "Salary Lines".Month)
                {
                }
                fieldelement(Year; "Salary Lines".Year)
                {
                    Width = 12;
                }
                fieldelement(TaxableIndemnities; "Salary Lines"."Taxable indemnities")
                {
                }
                fieldelement(GrossSalary; "Salary Lines"."Gross Salary")
                {
                }
                fieldelement(TaxablSalary; "Salary Lines"."Taxable salary")
                {
                }
                fieldelement(ChefFamille; "Salary Lines"."Deduction Family chief")
                {
                }
                fieldelement(EnfantDeduit; "Salary Lines"."Deduction Loaded child")
                {
                }
                fieldelement(RealTaxable; "Salary Lines"."Real taxable")
                {
                }
                fieldelement(ProfOfExpenses; "Salary Lines"."Deduction Prof. expenses")
                {
                }
                fieldelement(TotalTaxeRec; "Salary Lines"."Total taxable rec.")
                {
                }
                fieldelement(RecPayement; "Salary Lines"."Rec. payments")
                {
                }
                fieldelement(RealTaxeYear; "Salary Lines"."Real taxable (Year)")
                {
                }
                fieldelement(TaxessYear; "Salary Lines"."Taxe (Year)")
                {
                }
                fieldelement(TotalTaxe; "Salary Lines"."Total taxes rec.")
                {
                }
                fieldelement(TaxeMonth; "Salary Lines"."Taxe (Month)")
                {
                }
                fieldelement(NobTaxableInde; "Salary Lines"."Non Taxable indemnities")
                {
                }
                fieldelement(NetSalary; "Salary Lines"."Net salary")
                {
                }
                fieldelement(Loans; "Salary Lines".Loans)
                {
                }
                fieldelement(Advances; "Salary Lines".Advances)
                {
                }
                fieldelement(NetSalaryCashe; "Salary Lines"."Net salary cashed")
                {
                }
            }
        }
    }



    trigger OnPostXmlPort()
    begin

        MESSAGE(Text001);
    end;

    var
        Text001: TextConst ENU = 'Import complete',
                           FRA = 'Import terminé';
        "Employee No.": Record Employee;
        RecGHeurOccas: Record "WDC Occasional Hours";
}

