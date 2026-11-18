table 55035 "WDC Section"
{
    // LookupPageID = 52078252;

    fields
    {
        field(1; Management; Code[20])
        {
            TableRelation = "WDC Management".Code;
            CaptionML = ENG = 'Direction', FRA = 'Direction';
        }
        field(2; Service; Code[20])
        {
            TableRelation = "WDC Service".Service WHERE(Management = FIELD(Management));
            CaptionML = ENG = 'Service', FRA = 'Service';
        }
        field(3; Section; Code[20])
        {
            CaptionML = ENG = 'Section', FRA = 'Section';
        }
        field(4; Decription; Text[50])
        {
            CaptionML = ENG = 'Decription', FRA = 'Decription';
        }
        field(5; "Employee Status Group"; Code[20])
        {
            TableRelation = "Employee Statistics Group".Code;
            CaptionML = ENG = 'Employee status group', FRA = 'Groupe Statut Employé';
        }
    }

    keys
    {
        key(Key1; Management, Service, Section)
        {
            Clustered = true;
        }
    }
}

