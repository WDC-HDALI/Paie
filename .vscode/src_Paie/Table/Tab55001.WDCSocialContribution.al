table 55001 "WDC Social Contribution"
{

    Caption = 'Social Contribution';
    DrillDownPageID = 55003;
    LookupPageID = 55003;

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(2; Description; Text[50])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(3; "Employer's part"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Employer''s part', FRA = 'Part de l''employeur';

        }
        field(4; "Employee's part"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Employee''s part', FRA = 'Part de l''employé';
        }
        field(15; "Basis of calculation"; Enum "WDC Base Calcul ")
        {
            CaptionML = ENU = 'Basis of calculation', FRA = 'Base de calcul';
        }
        field(20; "Apply to all Employees"; Boolean)
        {
            CaptionML = ENU = 'Apply to all Employees', FRA = 'Appliquer à tous les employés';
        }
        field(25; "Deductible of taxable basis"; Boolean)
        {
            CaptionML = ENU = 'Deductible of taxable basis', FRA = 'Déductible base imposable';
        }
        field(30; "Employee Account No."; Code[20])
        {
            CaptionML = ENU = 'Employee : Account No.', FRA = 'N° compte de l''employé';
            TableRelation = "G/L Account";
        }
        field(35; "Employer Account No."; Code[20])
        {
            CaptionML = ENU = 'Employer : Account No.', FRA = 'N° compte employeur';
            TableRelation = "G/L Account";
        }
        field(36; "Employer : Bal. Account No."; Code[20])
        {
            CaptionML = ENU = 'Employer : Bal. Account No.', FRA = 'N° compte contrepartie employeur';
            TableRelation = "G/L Account";
        }
        field(40; "Payment No. filter"; Code[20])
        {
            CaptionML = ENU = 'Payment No. filter', FRA = 'Filtre N° paiement';
            FieldClass = FlowFilter;
        }
        field(41; "Employee Posting Grp. filter"; Code[20])
        {
            CaptionML = ENU = 'Employee Posting Grp. filter', FRA = 'Filtre Groupe comp. employé';
            FieldClass = FlowFilter;
            TableRelation = "WDC Employee Posting Group";
        }
        field(45; "Total employee's part"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Total employee''s part', FRA = 'Total part de l''employé';
        }
        field(46; "Total employer's part"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Total employer''s part', FRA = 'Total part de l''employeur';
        }
        field(47; "Rec. Total employee's part"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Sum("WDC Rec. Social Contributions"."Real Amount : Employee" WHERE("Social Contribution" = FIELD(Code),
                                                                                          "Employee Posting Group" = FIELD("Employee Posting Grp. filter"),
                                                                                          "No." = FIELD("Payment No. filter")));
            CaptionML = ENU = 'Total Rec. employee''s part', FRA = 'Total part de l''employé Enreg.';
            FieldClass = FlowField;
        }
        field(48; "Rec. Total employer's part"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Sum("WDC Rec. Social Contributions"."Real Amount : Employer" WHERE("Social Contribution" = FIELD(Code),
                                                                                          "Employee Posting Group" = FIELD("Employee Posting Grp. filter"),
                                                                                          "No." = FIELD("Payment No. filter")));
            CaptionML = ENU = 'Total Rec. employer''s part', FRA = 'Total part de l''employeur Enreg.';
            FieldClass = FlowField;
        }
        field(49; "Exploitation Code"; Code[20])
        {
            CaptionML = ENU = 'Exploitation Code', FRA = 'Code d''exploitation';
        }
        field(50000; "Maximum value - Employee"; Decimal)
        {
            CaptionML = ENU = 'Maximum value - Employee', FRA = 'Valeur maximale - Employé';
            DecimalPlaces = 3 : 3;
        }
        field(50001; "Maximum value - Employer"; Decimal)
        {
            CaptionML = ENU = 'Maximum value - Employer', FRA = 'Valeur maximale - Employeur';
            DecimalPlaces = 3 : 3;
        }
        field(50010; "Evaluation Mode"; Enum "WDC Contribution Eval. Mode")
        {
            CaptionML = ENU = 'Evaluation Mode', FRA = 'Mode d''évaluation';
        }
        field(50011; "Salary Package"; Decimal)
        {
            CaptionML = ENU = 'Salary Package', FRA = 'Forfait salarial';
            DecimalPlaces = 3 : 3;
        }
        field(50012; "Employer contribution"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            CaptionML = ENU = 'Employer contribution', FRA = 'Forfait employeur';
        }
        field(50013; "active Max"; Boolean)
        {
            CaptionML = ENU = 'Active Max', FRA = 'Max actif';
        }
        field(39001450; "Not Included in Accounting"; Boolean)
        {
            CaptionML = ENU = 'Not Included in Accounting', FRA = 'Non inclus dans la comptabilité';
        }
        field(39001451; "Not Included in Bonus"; Boolean)
        {
            CaptionML = ENU = 'Not Included in Bonus', FRA = 'Non inclus dans les primes';
        }
        field(39001452; "Libellé"; Text[100])
        {
            CaptionML = ENU = 'Label', FRA = 'Libellé';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

}

