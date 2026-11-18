table 55034 "WDC Service"
{
    // LookupPageID = 52078251;
    CaptionML = ENG = 'Service', FRA = 'Service';

    fields
    {
        field(1; Management; Code[20])
        {
            TableRelation = "WDC Management".Code;
            CaptionML = ENG = 'Direction', FRA = 'Direction';
        }
        field(2; Service; Code[20])
        {
            CaptionML = ENG = 'Service', FRA = 'Service';
        }
        field(3; Description; Text[50])
        {
            CaptionML = ENG = 'Description', FRA = 'Description';
        }
    }

    keys
    {
        key(Key1; Management, Service)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

