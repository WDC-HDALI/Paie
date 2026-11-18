table 55029 "WDC Employee Posting Group"
{
    CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe comptable employé';
    DrillDownPageID = 55049;
    LookupPageID = 55049;

    fields
    {
        field(1; "Code"; Code[30])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
            NotBlank = true;
        }
        field(2; "Net Salary Account No."; Code[20])
        {
            CaptionML = ENU = 'Net Salary Account No.', FRA = 'N° Compte Salaire Net';
            TableRelation = "G/L Account";
        }
        field(7; "Service Charge Acc. No."; Code[20])
        {
            CaptionML = ENU = 'Service Charge Acc. No.', FRA = 'N° Compte frais de service';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Service Charge Acc. No.", TRUE, TRUE);
            end;
        }
        field(8; "Payment Disc. Acc. No."; Code[20])
        {
            CaptionML = ENU = 'Payment Disc. Acc. No.', FRA = 'N° Compte remise paiement';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Payment Disc. Acc. No.", FALSE, FALSE);
            end;
        }
        field(9; "Invoice Rounding Account No."; Code[20])
        {
            CaptionML = ENU = 'Invoice Rounding Account No.', FRA = 'N° Compte arrondi facture';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Invoice Rounding Account No.", TRUE, FALSE);
            end;
        }

        field(20; "Basis Salary Account No."; Code[20])
        {
            CaptionML = ENU = 'Basis Salary Account No.', FRA = 'N° Compte salaire de base';
            TableRelation = "G/L Account";
        }
        field(21; "Supp. Hours Account No."; Code[20])
        {
            CaptionML = ENU = 'Supp. Hours Account No.', FRA = 'N° Compte heures supp.';
            TableRelation = "G/L Account";
        }
        field(22; "Taxable Indemnities Acc. No."; Code[20])
        {
            CaptionML = ENU = 'Taxable Indemnities Acc. No.', FRA = 'N° Compte indemnités imposables';
            TableRelation = "G/L Account";
        }
        field(23; "Non Tax. Indemnities Acc. No."; Code[20])
        {
            CaptionML = ENU = 'Non Taxable Indemnities Acc. No.', FRA = 'N° Compte indemnités non imposables';
            TableRelation = "G/L Account";
        }

        field(25; "Taxes Account No."; Code[20])
        {
            CaptionML = ENU = 'Taxes Account No.', FRA = 'N° Compte impôts';
            TableRelation = "G/L Account";
        }
        field(30; "13th/14th Month Account No."; Code[20])
        {
            CaptionML = ENU = '13th/14th Month Account No.', FRA = 'N° Compte 13ème/14ème';
            TableRelation = "G/L Account";
        }
        field(31; "Bonus Account No."; Code[20])
        {
            CaptionML = ENU = 'Bonus Account No.', FRA = 'N° Compte Prime';
            TableRelation = "G/L Account";
        }
        field(32; "Other Bonus Account No."; Code[20])
        {
            CaptionML = ENU = 'Other Bonus Account No.', FRA = 'N° Compte autres primes';
            TableRelation = "G/L Account";
        }
        field(33; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(50000; "Social fund empl. Account No."; Code[20])
        {
            CaptionML = ENU = 'Social fund empl. Account No.', FRA = 'Caisse fond social sal';
            TableRelation = "G/L Account";
        }

    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    local procedure CheckGLAcc(AccNo: Code[20]; CheckProdPostingGroup: Boolean; CheckDirectPosting: Boolean)
    var
        GLAcc: Record 15;
    begin
        IF AccNo <> '' THEN BEGIN
            GLAcc.GET(AccNo);
            GLAcc.CheckGLAcc;
            IF CheckProdPostingGroup THEN
                GLAcc.TESTFIELD("Gen. Prod. Posting Group");
            IF CheckDirectPosting THEN
                GLAcc.TESTFIELD("Direct Posting", TRUE);
        END;
    end;
}

