report 55027 "WDC Cash Pay Slip"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/ReçuePaieEspece.rdlc';
    captionML = ENU = 'Cash Pay Slip', FRA = 'Reçue paie espèce';

    dataset
    {
        dataitem("Loan & Advance Lines"; "WDC Loan & Advance Lines")
        {
            DataItemTableView = SORTING("No.", "Entry No.")
                                ORDER(Ascending)
                                WHERE("Payment No." = FILTER('SLD MANUEL'));
            RequestFilterFields = "No.", "Payment No.";
            column(Date_Report; FORMAT(WORKDATE, 0, 4))
            {
            }
            column(Name_CompanyInfo; COMPANYNAME)
            {
            }
            column(No; "Loan & Advance Lines"."No.")
            {
            }
            column(Montant; "Loan & Advance Lines"."Line Amount")
            {
            }
            column(Text011; RecEmployee."First Name")
            {
            }
            column(MontantLettre; MontantLettre)
            {
            }
            column(Datess; "Loan & Advance Lines"."Payroll Date")
            {
            }
            column(EmployName; EmployName)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //
                CduMntLettre."Montant en texte sans millimes"(MontantLettre, "Loan & Advance Lines"."Line Amount");
                RecGAdvHead.RESET;
                IF RecGAdvHead.GET("Loan & Advance Lines"."No.") THEN BEGIN
                    RecEmployee.GET(RecGAdvHead."Employee No.");
                    EmployName := RecEmployee."First Name";
                END;
            end;
        }
    }

    trigger OnPreReport()
    begin
        RecRHSetup.GET;
        RecCompanyInfo.GET;

        IF RecCompanyInfo.Name = 'SOUAD DIFFUSION' THEN
            Representant := Text008
        ELSE
            Representant := Text009;
    end;

    var
        RecRHSetup: Record "Human Resources Setup";
        Text001: Label 'Contrat de Prêt';
        Text002: Label 'Entre les soussignés : ';
        Text003: Label 'ARTICLE 1 : ';
        RecCompanyInfo: Record 79;
        RecEmployee: Record Employee;
        Text004: Label 'ARTICLE 2 : ';
        Text005: Label 'ARTICLE 3 : ';
        Text006: Label 'Signature de l''emprunteur';
        Text007: Label 'Signature de l''employeur';
        Text008: Label 'Mr. Mohamed Taleb KAMMOUN';
        Text009: Label 'Mr.Mounir BEN FREDJ';
        Representant: Text[100];
        MontantLettre: Text[250];
        Text010: Label 'La Société %1 représentée par %2  d''une part,';
        Text011: Label 'Et %1  titulaire de CIN N° %2 délivrée le %3, ci-après l''emprunteur d''autre part, il a été convenu ce qui suit:';
        Text013: Label 'La Société %1 consent à %2 un prêt social  d''un montant de %3 ( %4 ) avec un taux d'' intérêt de %5%,remboursable sur %6 périodes , la période étant %7 à raison de %8 Dinars.';
        Text014: Label 'L''emprunteur %1 déclare qu''il a reçu la totalité du montant du prêt le jour de la signature.';
        Text015: Label 'L''emprunteur %1 s''engage à rembourser les sommes prêtées en cas de démission ou de licenciement avant l''extinction de sa dette.';
        CduMntLettre: Codeunit 55028;
        RecGAdvHead: Record "WDC Loan & Advance";
        EmployName: Code[50];
}

