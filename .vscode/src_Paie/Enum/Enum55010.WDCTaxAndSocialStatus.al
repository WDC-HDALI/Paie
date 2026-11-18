Enum 55010 "WDC Tax And Social Status"
{
    Extensible = true;
    value(0; "Imposable")
    {
        CaptionML = ENU = 'Taxable', FRA = 'Imposable';
    }
    value(1; "Not Taxable")
    {
        CaptionML = ENU = 'Not taxable', FRA = 'Non imposable';
    }
    value(2; "Taxable (Not Subject to Social Security)")
    {
        CaptionML = ENU = 'Taxable (Not Subject to Social Security)', FRA = 'Imposable Non Assujettie Socialement';
    }
    value(3; "Subject Not taxable")
    {
        CaptionML = ENU = 'Subject Not Taxable', FRA = 'Assujettie non imposable';
    }

}
