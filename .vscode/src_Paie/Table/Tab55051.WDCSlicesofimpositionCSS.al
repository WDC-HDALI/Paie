table 55051 "WDC Slices of imposition_CSS"
{
    Caption = 'Slices of imposition';
    LookupPageID = 55008;

    fields
    {
        field(1; "No."; Integer)
        {
            Captionml = ENU = 'No.', FRA = 'N°';
        }
        field(2; "Code"; Code[4])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(3; "Lower limit"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Lower limit', FRA = 'Limite inférieure';

            trigger OnValidate()
            begin
                IF ("Lower limit" < "Superior limit") THEN
                    "Slice amount" := ("Superior limit" - "Lower limit") * Rate / 100
                ELSE
                    "Slice amount" := 0;
            end;
        }
        field(4; "Superior limit"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Superior limit', FRA = 'Limite supérieure';

            trigger OnValidate()
            begin
                IF ("Lower limit" < "Superior limit") THEN
                    "Slice amount" := ("Superior limit" - "Lower limit") * Rate / 100
                ELSE
                    "Slice amount" := 0;
            end;
        }
        field(5; Rate; Decimal)
        {
            CaptionML = ENU = 'Rate', FRA = 'Taux';

            trigger OnValidate()
            begin
                IF ("Lower limit" < "Superior limit") THEN
                    "Slice amount" := ("Superior limit" - "Lower limit") * Rate / 100
                ELSE
                    "Slice amount" := 0;
            end;
        }
        field(100; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series', FRA = 'N° de série';
            Editable = false;
        }
        field(200; "Slice amount"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Slice amount', FRA = 'Montant tranche';
            Editable = true;
        }

    }

    keys
    {
        key(Key1; "No.", "Code")
        {
            Clustered = true;
        }
    }


}

