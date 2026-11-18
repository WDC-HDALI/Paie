table 55044 "WDC Note Parameters"
{
    CaptionML = ENU = 'Parameter notes', FRA = 'Paramètre notes';
    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', FRA = 'N° séquence';
            NotBlank = false;
        }
        field(2; "Lower limit"; Decimal)
        {
            CaptionML = ENU = 'Lower limit', FRA = 'Limite inférieur';
        }
        field(3; "Upper limit"; Decimal)
        {
            CaptionML = ENU = 'Upper limit', FRA = 'Limite supérieur';
        }
        field(4; Purcent; Decimal)
        {
            CaptionML = ENU = 'Purcent', FRA = 'Pourcentage';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }


}

