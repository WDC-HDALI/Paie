table 55048 "WDC Hist. Soc. Contribution"
{
    DrillDownPageID = 55054;
    LookupPageID = 55054;

    fields
    {
        field(1; "Emplymt. Contract Code"; Code[20])
        {
            CaptionML = ENU = 'Emplymt. Contract Code', FRA = 'Code contrat travail';
            Editable = false;
            TableRelation = "WDC Hist. contrat de travail";
        }
        field(2; "Social Contribution Code"; Code[20])
        {
            CaptionML = ENU = 'Social Contribution Code', FRA = 'Code cotisation sociale';
            NotBlank = true;
            TableRelation = "WDC Social Contribution";

            trigger OnValidate()
            begin
                IF SocialContribution.GET("Social Contribution Code") THEN BEGIN
                    "Employer's part" := SocialContribution."Employer's part";
                    "Employee's part" := SocialContribution."Employee's part";
                    "Basis of calculation" := SocialContribution."Basis of calculation";
                    "Deductible of taxable basis" := SocialContribution."Deductible of taxable basis";
                    "Maximum value - Employee" := SocialContribution."Maximum value - Employee";
                    "Maximum value - Employer" := SocialContribution."Maximum value - Employer";

                    "Evaluation Mode" := SocialContribution."Evaluation Mode";
                    "Salary Package" := SocialContribution."Salary Package";
                    "Employer contribution" := SocialContribution."Employer contribution";
                    "Not Included in Accounting" := SocialContribution."Not Included in Accounting";
                END;
                Employee.RESET;
                IF "Social Contribution Code" = 'ASS GRP' THEN BEGIN
                    IF Employee.GET("Emplymt. Contract Code") THEN
                        Employee.TESTFIELD("ASS GRP Affiliate", TRUE);
                END
            end;
        }
        field(3; "Indemnity Code"; Code[20])
        {
            CaptionML = ENU = 'Indemnity Code', FRA = 'Code Indemnité';
            TableRelation = "WDC Default Indemnities"."Indemnity Code" WHERE("Emplymt. Contract Code" = FIELD("Emplymt. Contract Code"));
        }
        field(4; "Employer's part"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Employer''s part', FRA = 'Part employeur';
            Editable = true;
        }
        field(5; "Employee's part"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Employee''s part', FRA = 'Part employé';
            Editable = true;
        }
        field(15; "Basis of calculation"; Enum "WDC Base Calcul ")
        {
            CaptionML = ENU = 'Basis of calculation', FRA = 'Base de calcul';
            Editable = false;
        }
        field(25; "Deductible of taxable basis"; Boolean)
        {
            CaptionML = ENU = 'Deductible of taxable basis', FRA = 'Déductible base imposable';
            Editable = true;
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
            CaptionML = ENU = 'Evaluation Mode', FRA = 'Mode évaluation';
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

        field(39001450; "Not Included in Accounting"; Boolean)
        {
            CaptionML = ENU = 'Not Included in Accounting', FRA = 'Non inclus en comptabilité';
        }
        field(39001451; "Not Included in Bonus"; Boolean)
        {
            CaptionML = ENU = 'Not Included in Bonus', FRA = 'Non inclus en prime';
        }
        field(39001537; "Archived contract code"; Code[20])
        {
            CaptionML = ENU = 'Archived contract code', FRA = 'Code contrat archivé';
            TableRelation = "WDC Hist. contrat de travail";
        }
    }

    keys
    {
        key(Key1; "Emplymt. Contract Code", "Social Contribution Code", "Indemnity Code", "Archived contract code")
        {
            Clustered = true;
        }
        key(Key2; "Archived contract code", "Emplymt. Contract Code")
        {
        }
    }



    var
        SocialContribution: Record "WDC Social Contribution";
        Employee: Record Employee;
}

