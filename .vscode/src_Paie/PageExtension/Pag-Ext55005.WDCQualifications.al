pageextension 55005 "WDC Qualifications" extends Qualifications
{

    layout
    {
        addafter(Description)
        {
            field(College; Rec.College)
            {
                ApplicationArea = all;
            }
        }
    }
}

