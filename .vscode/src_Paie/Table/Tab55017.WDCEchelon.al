table 55017 "WDC Echelon"
{
    CaptionML = ENG = 'Echelon', FRA = 'Echelon';
    DrillDownPageID = 55031;
    LookupPageID = 55031;

    fields
    {
        field(1; Echelon; Integer)
        {
            CaptionML = ENG = 'Echelon', FRA = 'Echelon';
        }
        field(2; Description; Text[100])
        {
            CaptionML = ENG = 'Description', FRA = 'Description';
        }
        field(3; "Formula Date"; DateFormula)
        {
            CaptionML = ENG = 'Formula Date', FRA = 'Date formula';
        }
    }


    keys
    {
        key(Key1; Echelon)
        {
            Clustered = true;
        }
    }
}

