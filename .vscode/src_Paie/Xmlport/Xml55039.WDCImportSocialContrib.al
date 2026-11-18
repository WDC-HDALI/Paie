xmlport 55039 "WDC Import Social Contrib."
{
    captionML = ENU = 'Import Social Contribution', FRA = 'Import Cotisations Sociales';
    Direction = Import;
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Social Contributions"; 55033)
            {
                XmlName = 'ContactHeader';
                fieldelement(Paie; "Social Contributions"."No.")
                {
                }
                fieldelement(Employee; "Social Contributions"."Employee No.")
                {
                }
                fieldelement(NamEmployee; "Social Contributions"."Employee Posting Group")
                {
                }
                fieldelement(Month; "Social Contributions".Indemnity)
                {
                }
                fieldelement(Year; "Social Contributions"."Social Contribution")
                {
                    Width = 12;
                }
                fieldelement(TaxableIndemnities; "Social Contributions".Description)
                {
                }
                fieldelement(GrossSalary; "Social Contributions"."Employer's part")
                {
                }
                fieldelement(CNSS; "Social Contributions"."Employee's part")
                {
                }
                fieldelement(TaxablSalary; "Social Contributions"."Base Amount")
                {
                }
                fieldelement(ChefFamille; "Social Contributions"."Real Amount : Employee")
                {
                }
                fieldelement(EnfantDeduit; "Social Contributions"."Real Amount : Employer")
                {
                }
                fieldelement(RealTaxable; "Social Contributions"."Calculate Year")
                {
                }
                fieldelement(ProfOfExpenses; "Social Contributions"."Salary Package")
                {
                }
                fieldelement(TotalTaxeRec; "Social Contributions"."Employer contribution")
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

