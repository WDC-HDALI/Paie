Enum 55071 "WDC Accounting Posting"
{
    Extensible = true;
    CaptionML = ENU = 'Accounting Posting', FRA = 'Imputation comptable';
    value(0; Imputable)
    {
        CaptionML = ENU = 'Postable', FRA = 'Imputable';
    }
    value(1; "Non Imputable")
    {
        CaptionML = ENU = 'Not Postable', FRA = 'Non Imputable';
    }
}
