table 55027 "WDC Rec. Social Contributions"
{
    Caption = 'Rec. Social Contributions';
    DrillDownPageID = 55048;
    LookupPageID = 55048;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
            TableRelation = "WDC Posted Salary Header";
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Editable = true;
            TableRelation = Employee;
        }
        field(3; "Employee Posting Group"; Code[20])
        {
            Caption = 'Employee Posting Group';
            Editable = true;
            TableRelation = "WDC Employee Posting Group";
        }
        field(4; Indemnity; Code[20])
        {
            Caption = 'Indemnity';
            TableRelation = "WDC Indemnity";
        }
        field(5; "Social Contribution"; Code[20])
        {
            Caption = 'Social Contribution';
            TableRelation = "WDC Social Contribution";
        }
        field(6; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(10; "Employer's part"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Employer''s part', FRA = 'Part de l''employeur';
            ;
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(11; "Employee's part"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Employee''s part', FRA = 'Part employé';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(14; "Basis of calculation"; Enum "WDC Base Calcul ")
        {
            CaptionML = ENU = 'Basis of calculation', FRA = 'Base de calcul';
        }
        field(15; "Base Amount"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Base Amount', FRA = 'Montant de base';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(16; "Real Amount : Employee"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Real Amount : Employee', FRA = 'Montant réel : Employé';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(17; "Real Amount : Employer"; Decimal)
        {
            CaptionML = ENU = 'Real Amount : Employer', FRA = 'Montant réel : Employeur';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(20; "Deductible of taxable basis"; Boolean)
        {
            CaptionML = ENU = 'Deductible of taxable basis', FRA = 'Déductible base imposable';
        }
        field(30; "Globlal dimension 1"; Code[20])
        {
            CaptionML = ENU = 'DeparCode', FRA = 'Code département';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(31; "Global dimension 2"; Code[20])
        {
            Caption = 'Code dossier';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(910; "Calculate Year"; Integer)
        {
            CaptionML = ENU = 'Calculate Year', FRA = 'Année de calcul';
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
        field(50002; "Posting date"; Date)
        {
            CaptionML = ENU = 'Posting date', FRA = 'Date comptabilisation';
        }
        field(50050; Number; Integer)
        {
            CaptionML = ENU = 'Number', FRA = 'Numéro';
        }
        field(50051; "Basis Salary"; Decimal)
        {
            CaptionML = ENU = 'Basis Salary', FRA = 'Salaire de base';
            DecimalPlaces = 3 : 3;
        }
        field(50052; Month; Enum "WDC Payroll Month")
        {
            CaptionML = ENU = 'Month', FRA = 'Mois';
        }
        field(39001430; "6 SMIG"; Decimal)
        {
            CaptionML = ENU = '6 SMIG', FRA = '6 SMIG';
            DecimalPlaces = 3 : 3;
        }
        field(39001431; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';
        }
        field(39001450; "Integrated into accounting"; Boolean)
        {
            CaptionML = ENU = 'Integrated into accounting', FRA = 'Intégré en comptabilité';
        }
        field(39001451; "Employee Statistic Group"; Code[30])
        {
            CaptionML = ENU = 'Employee statistic Group', FRA = 'Groupe statistique employé';
            Editable = true;
            TableRelation = "Employee Statistics Group";
        }
        field(39001452; Management; Code[20])
        {
            CaptionML = ENU = 'Management', FRA = 'Direction';
        }
        field(39001453; Service; Code[20])
        {
            CaptionML = ENU = 'Service', FRA = 'Service';
        }
        field(39001454; Section; Code[20])
        {
            CaptionML = ENU = 'Section', FRA = 'Section';
        }
    }

    keys
    {
        key(Key1; "No.", "Employee No.", Indemnity, "Social Contribution")
        {
            Clustered = true;
            SumIndexFields = "Employer's part", "Employee's part", "Base Amount", "Real Amount : Employee", "Real Amount : Employer";
        }
        key(Key2; "Employee Posting Group", "Deductible of taxable basis", "Employee No.", "No.", "Globlal dimension 1", "Global dimension 2")
        {
            SumIndexFields = "Employer's part", "Employee's part", "Base Amount", "Real Amount : Employee", "Real Amount : Employer";
        }
        key(Key3; "Social Contribution", "Globlal dimension 1", "Global dimension 2", "Employee Posting Group")
        {
            SumIndexFields = "Employer's part", "Employee's part", "Base Amount", "Real Amount : Employee", "Real Amount : Employer";
        }
        key(Key4; "Social Contribution", "Employee No.", "Calculate Year")
        {
            SumIndexFields = "Base Amount";
        }
        key(Key5; "Employee Statistic Group", "Deductible of taxable basis", "No.")
        {
            SumIndexFields = "Employer's part", "Employee's part", "Base Amount", "Real Amount : Employee", "Real Amount : Employer";
        }
    }

}

