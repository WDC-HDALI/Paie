table 55018 "WDC College"
{
    CaptionML = ENG = 'College', FRA = 'College';
    DrillDownPageID = 55032;
    LookupPageID = 55032;

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(2; Description; Text[30])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(3; "Lower Limit"; Integer)
        {
            CaptionML = ENU = 'Lower Limit', FRA = 'Borne inférieure';
        }
        field(4; "Upper Limit"; Integer)
        {
            CaptionML = ENU = 'Upper Limit', FRA = 'Borne Supérieure';
        }
        field(5; "Transport Indemnity Amount"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            CaptionML = ENU = 'Transport Indemnity amount', FRA = 'Montant Indemnité Transport';
        }
        field(6; "Housing Indemnity Amount"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            CaptionML = ENU = 'Housing Indemnity amount', FRA = 'Montant Indemnité Logement';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    var
}

