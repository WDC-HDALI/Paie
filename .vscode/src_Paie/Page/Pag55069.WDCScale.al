page 55069 "WDC Scale"
{
    PageType = List;
    SourceTable = "WDC Scale";
    CaptionML = ENU = 'Scale', FRA = 'Echelle';
    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field(Category; Rec.Category)
                {
                    ApplicationArea = all;
                }
                field(Scale; Rec.Scale)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

