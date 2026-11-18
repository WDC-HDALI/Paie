table 55036 "WDC Overcharge of hour cost"
{
    DrillDownPageID = 55036;
    LookupPageID = 55036;
    CaptionML = ENU = 'Overcharge of hour cost', FRA = 'Majoration Taux horaire';
    fields
    {
        field(1; "Regime of work"; Code[20])
        {
            CaptionML = ENU = 'Regime of work', FRA = 'Régime de travail';
            Editable = true;
            TableRelation = "WDC work Regimes";
        }
        field(2; Identifier; Integer)
        {
            CaptionML = ENU = 'Identifier', FRA = 'Identifiant';
            Editable = false;
        }
        field(3; "Lower limit"; Decimal)
        {
            CaptionML = ENU = 'Lower limit', FRA = 'Limite inférieure';
        }
        field(4; "Upper limit"; Decimal)
        {
            CaptionML = ENU = 'Upper limit', FRA = 'Limite supérieure';
        }
        field(5; "Rate of overcharge"; Decimal)
        {
            CaptionML = ENU = 'Rate of overcharge', FRA = 'Taux de majoration';
        }

    }

    keys
    {
        key(Key1; "Regime of work", Identifier, "Rate of overcharge")
        {
            Clustered = true;
        }
    }


}

