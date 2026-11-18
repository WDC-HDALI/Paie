report 55026 "WDC Loan & Advance List"
{
    captionML = ENU = 'Loan & Advance List', FRA = 'Liste prêts & avances';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/ListePrêtAvance.rdlc';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Name; "Company Information".Name)
            {
            }
            column(AdresseCompany; "Company Information".Address)
            {
            }
            column(Picture; "Company Information".Picture)
            {
            }
        }
        dataitem("Loan & Advance Lines"; "WDC Loan & Advance Lines")
        {
            DataItemTableView = SORTING("Employee No.", Type, "Posting Date")
                                WHERE("Employee No." = FILTER(<> ''));
            RequestFilterFields = "Document type", "Payment No.", Year, Month;
            column(No; "Loan & Advance Lines"."No.")
            {
            }
            column(Employee; "Loan & Advance Lines"."Employee No.")
            {
            }
            column(FullName; FullName)
            {
            }
            column(Documenttype; "Loan & Advance Lines"."Document type")
            {
            }
            column(LineAmount; "Loan & Advance Lines"."Line Amount")
            {
            }
            column(PaymentNo; "Loan & Advance Lines"."Payment No.")
            {
            }
            column("TypesPrêt"; TypesPrêt)
            {
            }
            column(PaieNo; PaieNo)
            {
            }
            column(Year; Year)
            {
            }
            column(Mois; Month)
            {
            }
            column(ChoixAn; GETFILTER(Year))
            {
            }
            column(ChoixMois; GETFILTER(Month))
            {
            }

            trigger OnAfterGetRecord()
            begin
                TypesPrêt := 'Total' + ' ' + FORMAT("Loan & Advance Lines".Type);
                PaieNo := GetPaieNo("Loan & Advance Lines"."Payment No.");
            end;
        }
    }


    trigger OnPreReport()
    begin
        TypesPrêt := FORMAT("Loan & Advance Lines".Type);
    end;

    var
        "TypesPrêt": Text[20];
        PaieNo: Code[20];


    procedure GetPaieNo(Numpaie: Code[20]) Return: Code[20]
    var
        RecLLignePret: Record "WDC Loan & Advance Lines";
    begin
        RecLLignePret.RESET;
        RecLLignePret.SETRANGE("Payment No.", Numpaie);
        IF RecLLignePret.FINDSET THEN BEGIN
            Return := "Loan & Advance Lines"."Payment No.";
        END;
    end;
}

