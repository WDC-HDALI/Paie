table 55030 "WDC Detail Employee Ledg.Entry"
{
    CaptionML = ENU = 'Detailed Employee Ledger Entry', FRA = 'Détail écriture grand livre employé';
    DataCaptionFields = "Employee No.";
    DrillDownPageID = 55051;
    LookupPageID = 55051;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', FRA = 'N° écriture';
        }
        field(2; "Employee Ledger Entry No."; Integer)
        {
            CaptionML = ENU = 'Employee Ledger Entry No.', FRA = 'N° écriture employé';
            TableRelation = "Employee Ledger Entry";
        }
        field(3; "Entry Type"; Enum "WDC Entry Type II")
        {
            CaptionML = ENU = 'Entry Type', FRA = 'Type d''écriture';
        }
        field(4; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
        }
        field(5; "Document Type"; Enum "WDC Type document")
        {
            CaptionML = ENU = 'Document Type', FRA = 'Type document';
        }
        field(6; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', FRA = 'N° document';
        }
        field(7; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU = 'Amount', FRA = 'Montant';
        }
        field(8; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'Amount (LCY)', FRA = 'Montant (LCY)';
        }
        field(9; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° employé';
            TableRelation = Employee;
        }
        field(10; "Currency Code"; Code[20])
        {
            CaptionML = ENU = 'Currency Code', FRA = 'Code devise';
            TableRelation = Currency;
        }

        field(12; "Source Code"; Code[20])
        {
            CaptionML = ENU = 'Source Code', FRA = 'Code source';
            TableRelation = "Source Code";
        }
        field(13; "Transaction No."; Integer)
        {
            CaptionML = ENU = 'Transaction No.', FRA = 'N° transaction';
        }
        field(14; "Journal Batch Name"; Code[20])
        {
            CaptionML = ENU = 'Journal Batch Name', FRA = 'Nom lot journal';
        }
        field(15; "Reason Code"; Code[20])
        {
            CaptionML = ENU = 'Reason Code', FRA = 'Code raison';
            TableRelation = "Reason Code";
        }
        field(16; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU = 'Debit Amount', FRA = 'Montant débit';
        }
        field(17; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU = 'Credit Amount', FRA = 'Montant crédit';
        }
        field(18; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU = 'Debit Amount (LCY)', FRA = 'Montant débit (LCY)';
        }
        field(19; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU = 'Credit Amount (LCY)', FRA = 'Montant crédit (LCY)';
        }
        field(20; "Initial Entry Due Date"; Date)
        {
            CaptionML = ENU = 'Initial Entry Due Date', FRA = 'Date échéance écriture initiale';
        }
        field(21; "Initial Entry Global Dim. 1"; Code[20])
        {
            CaptionML = ENU = 'Initial Entry Global Dim. 1', FRA = 'Dimension globale initiale 1';
        }
        field(22; "Initial Entry Global Dim. 2"; Code[20])
        {
            CaptionML = ENU = 'Initial Entry Global Dim. 2', FRA = 'Dimension globale initiale 2';
        }
        field(35; "Initial Document Type"; Enum "WDC Type document")
        {
            CaptionML = ENU = 'Initial Document Type', FRA = 'Type document initial';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
            SumIndexFields = Amount, "Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)";
        }
        key(Key2; "Employee Ledger Entry No.", "Posting Date")
        {
        }
        key(Key3; "Employee Ledger Entry No.", "Entry Type", "Posting Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Amount, "Amount (LCY)", "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)";
        }
        key(Key4; "Employee No.", "Initial Entry Due Date", "Currency Code")
        {
            SumIndexFields = Amount, "Amount (LCY)", "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)";
        }
        key(Key5; "Employee No.", "Posting Date", "Entry Type", "Currency Code")
        {
            SumIndexFields = Amount, "Amount (LCY)", "Debit Amount", "Debit Amount (LCY)", "Credit Amount", "Credit Amount (LCY)";
        }
        key(Key6; "Employee No.", "Initial Document Type", "Document Type")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key7; "Document Type", "Document No.", "Posting Date")
        {
        }
        key(Key8; "Initial Document Type", "Employee No.", "Posting Date", "Currency Code", "Entry Type")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
    }
    var
        ll: Record 17;

}

