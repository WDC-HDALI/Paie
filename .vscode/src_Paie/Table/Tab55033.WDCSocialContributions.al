table 55033 "WDC Social Contributions"
{
    CaptionML = ENU = 'Social Contributions', FRA = 'Cotisations sociales';
    DrillDownPageID = 55041;
    LookupPageID = 55041;

    fields
    {
        field(1; "No."; Code[20])
        {
            TableRelation = "WDC Salary Header";
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° employé';
            Editable = false;
            TableRelation = Employee;
        }
        field(3; "Employee Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe compta. employé';
            Editable = true;
            TableRelation = "WDC Employee Posting Group";
        }
        field(4; Indemnity; Code[20])
        {
            CaptionML = ENU = 'Indemnity', FRA = 'Indemnité';
            TableRelation = "WDC Indemnities".Indemnity WHERE("No." = FIELD("No."),
                                                         "Employee No." = FIELD("Employee No."));
        }
        field(5; "Social Contribution"; Code[20])
        {
            CaptionML = ENU = 'Social Contribution', FRA = 'Cotisation sociale';
            TableRelation = "WDC Social Contribution";

            trigger OnValidate()
            begin
                IF SocialContribution.GET("Social Contribution") THEN BEGIN
                    Description := SocialContribution.Description;
                    "Employer's part" := SocialContribution."Employer's part";
                    "Employee's part" := SocialContribution."Employee's part";
                    "Base Amount" := 0;
                    "Real Amount : Employee" := 0;
                    "Real Amount : Employer" := 0;
                    "Deductible of taxable basis" := SocialContribution."Deductible of taxable basis";
                END
            end;
        }
        field(6; Description; Text[50])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(10; "Employer's part"; Decimal)
        {
            CaptionML = ENU = 'Employer''s part', FRA = 'Part employeur'
            ;
            Editable = true;
        }
        field(11; "Employee's part"; Decimal)
        {
            CaptionML = ENU = 'Employee''s part', FRA = 'Part employé';
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
            Editable = true;
        }
        field(16; "Real Amount : Employee"; Decimal)
        {
            AutoFormatType = 3;
            CaptionML = ENU = 'Real Amount : Employee', FRA = 'Montant réel : Employé';
            Editable = false;
        }
        field(17; "Real Amount : Employer"; Decimal)
        {
            AutoFormatType = 3;
            CaptionML = ENU = 'Real Amount : Employer', FRA = 'Montant réel : Employeur';
            Editable = false;
        }
        field(20; "Deductible of taxable basis"; Boolean)
        {
            CaptionML = ENU = 'Deductible of taxable basis', FRA = 'Déductible base imposable';
        }
        field(21; "Global Dimension 1"; Code[20])
        {
            CaptionML = ENU = 'Departement Code', FRA = 'Code département';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(22; "Global Dimension 2"; Code[20])
        {
            CaptionML = ENU = 'Folder Code', FRA = 'Code dossier';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(216; "Real Amount : Employee PR"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Real Amount : Employee PR', FRA = 'Montant réel : Employé PR';
            Editable = false;
        }
        field(910; "Calculate Year"; Integer)
        {
            CaptionML = ENU = 'Year of Calculate', FRA = 'Année de calcul';
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
            CaptionML = ENU = 'Employer contribution', FRA = 'Forfait employeur';
            DecimalPlaces = 3 : 3;
        }
        field(39001430; "6 * Smig"; Decimal)
        {
        }
        field(39001450; "Integrated into accounting"; Boolean)
        {
        }
        field(39001451; "Employee Statistic Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Statistic Group', FRA = 'Groupe stat. employé';
            Editable = true;
            TableRelation = "Employee Statistics Group";
        }
        field(39001452; Management; Code[20])
        {
            CaptionML = ENU = 'Management', FRA = 'Direction';
        }
        field(39001453; Service; Code[20])
        {
        }
        field(39001454; Section; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No.", "Employee No.", Indemnity, "Social Contribution")
        {
            Clustered = true;
            SumIndexFields = "Employer's part", "Employee's part", "Base Amount", "Real Amount : Employee", "Real Amount : Employer", "Real Amount : Employee PR";
        }
        key(Key2; "Employee Posting Group", "Deductible of taxable basis", "Employee No.", "No.", "Global Dimension 1", "Global Dimension 2")
        {
            SumIndexFields = "Employer's part", "Employee's part", "Base Amount", "Real Amount : Employee", "Real Amount : Employer", "Real Amount : Employee PR";
        }
        key(Key3; "Social Contribution", "Global Dimension 1", "Global Dimension 2")
        {
            SumIndexFields = "Employer's part", "Employee's part", "Base Amount", "Real Amount : Employee", "Real Amount : Employer", "Real Amount : Employee PR";
        }
        key(Key4; "No.", "Employee No.", "Deductible of taxable basis", "Basis of calculation")
        {
            SumIndexFields = "Employer's part", "Employee's part", "Base Amount", "Real Amount : Employee", "Real Amount : Employer", "Real Amount : Employee PR";
        }
        key(Key5; "No.", "Deductible of taxable basis", "Employee Statistic Group")
        {
            SumIndexFields = "Employer's part", "Employee's part", "Base Amount", "Real Amount : Employee", "Real Amount : Employer", "Real Amount : Employee PR";
        }
        key(Key6; "No.", "Deductible of taxable basis", "Employee Posting Group")
        {
            SumIndexFields = "Employer's part", "Employee's part", "Base Amount", "Real Amount : Employee", "Real Amount : Employer", "Real Amount : Employee PR";
        }
    }

    var
        SocialContribution: Record 55033;
}

