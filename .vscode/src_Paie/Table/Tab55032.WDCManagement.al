table 55032 "WDC Management"
{
    CaptionML = ENU = 'Management', FRA = 'Direction';

    LinkedObject = false;

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(2; Designation; Text[50])
        {
            CaptionML = ENU = 'Designation', FRA = 'Désignation';
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

