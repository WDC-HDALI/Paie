table 55043 "WDC Bonus"
{
    CaptionML = ENU = 'Bonus', FRA = 'Prime';
    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(3; Type; Enum "WDC Bonus Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';

        }
        field(4; "Calculation Type"; Enum "WDC Bonus Calculation Type")
        {
            CaptionML = ENU = 'Calculation Type', FRA = 'Type Calcul';
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

