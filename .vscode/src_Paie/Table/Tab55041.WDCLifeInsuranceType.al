table 55041 "WDC Life Insurance Type"
{
    DrillDownPageID = 55057;
    LookupPageID = 55057;

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(2; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(3; "Maximum Amount"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            CaptionML = ENU = 'Maximum Amount', FRA = 'Montant plafond';
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

