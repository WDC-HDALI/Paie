report 55004 "WDC Loan Contract"
{
    CaptionML = ENU = 'Loan Contract', FRA = 'Contrat de prêt';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/Contratdeprêt.rdlc';

    dataset
    {
        dataitem("Loan & Advance Header"; "WDC Loan & Advance Header")
        {
            column(Name_CompanyInfo; COMPANYNAME)
            {
            }
            column(Date_Report; FORMAT(WORKDATE, 0, 4))
            {
            }
            column(Text001; Text001)
            {
            }
            column(Text002; Text002)
            {
            }
            column(Text003; Text003)
            {
            }
            column(Text004; Text004)
            {
            }
            column(Text005; Text005)
            {
            }
            column(Text006; Text006)
            {
            }
            column(Text007; Text007)
            {
            }
            column(Text008; Text008)
            {
            }
            column(Text009; Text009)
            {
            }
            column(Text010; STRSUBSTNO(Text010, COMPANYNAME, Representant))
            {
            }
            column(Text011; STRSUBSTNO(Text011, Name, RecEmployee."CIN No.", RecEmployee."CIN Issued on"))
            {
            }
            column(Text013; STRSUBSTNO(Text013, COMPANYNAME, Name, Amount, MontantLettre, "Interest %", "Repayment slices", Périodicité, ROUND("Slice Amount", 0.001)))
            {
            }
            column(Text014; STRSUBSTNO(Text014, Name))
            {
            }
            column(Text015; STRSUBSTNO(Text015, Name))
            {
            }

            trigger OnAfterGetRecord()
            begin
                RecEmployee.GET("Employee No.");
                CduMntLettre."Montant en texte sans millimes"(MontantLettre, Amount);
            end;
        }
    }



    trigger OnPreReport()
    begin
        RecRHSetup.GET;
        RecCompanyInfo.GET;

        IF RecCompanyInfo.Name = '******' THEN
            Representant := Text008
        ELSE
            Representant := Text009;
    end;

    var
        RecCompanyInfo: Record 79;
        RecEmployee: Record Employee;
        RecRHSetup: Record "Human Resources Setup";
        Representant: Text[100];
        MontantLettre: Text[250];
        Text001: TextConst ENU = 'Loan Contract',
                           FRA = 'Contrat de Prêt';
        Text002: TextConst ENU = 'Between the undersigned: ',
                           FRA = 'Entre les soussignés : ';
        Text003: TextConst ENU = 'ARTICLE 1: ',
                           FRA = 'ARTICLE 1 : ';
        Text004: TextConst ENU = 'ARTICLE 2: ',
                           FRA = 'ARTICLE 2 : ';
        Text005: TextConst ENU = 'ARTICLE 3: ',
                           FRA = 'ARTICLE 3 : ';
        Text006: TextConst ENU = 'Borrower''s signature',
                           FRA = 'Signature de l''emprunteur';
        Text007: TextConst ENU = 'Employer''s signature',
                           FRA = 'Signature de l''employeur';
        Text008: TextConst ENU = '************',
                           FRA = '************';
        Text009: TextConst ENU = '************',
                           FRA = '************';
        Text010: TextConst ENU = 'The Company %1 represented by %2 on one hand,',
                           FRA = 'La Société %1 représentée par %2  d''une part,';
        Text011: TextConst ENU = 'And %1 holder of CIN No. %2 issued on %3, hereinafter the borrower on the other hand, it was agreed as follows:',
                           FRA = 'Et %1  titulaire de CIN N° %2 délivrée le %3, ci-après l''emprunteur d''autre part, il a été convenu ce qui suit:';
        Text013: TextConst ENU = 'The Company %1 grants to %2 a social loan of the amount of %3 ( %4 ) with an interest rate of %5%, repayable over %6 periods, the period being %7 at the rate of %8 Dinars.',
                           FRA = 'La Société %1 consent à %2 un prêt social  d''un montant de %3 ( %4 ) avec un taux d'' intérêt de %5%,remboursable sur %6 périodes , la période étant %7 à raison de %8 Dinars.';
        Text014: TextConst ENU = 'The borrower %1 declares that he has received the full amount of the loan on the day of signing.',
                           FRA = 'L''emprunteur %1 déclare qu''il a reçu la totalité du montant du prêt le jour de la signature.';
        Text015: TextConst ENU = 'The borrower %1 undertakes to repay the amounts borrowed in case of resignation or dismissal before the extinction of his debt.',
                           FRA = 'L''emprunteur %1 s''engage à rembourser les sommes prêtées en cas de démission ou de licenciement avant l''extinction de sa dette.';
        CduMntLettre: Codeunit 55028;
}

