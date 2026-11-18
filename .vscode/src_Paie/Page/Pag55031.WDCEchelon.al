page 55031 "WDC Echelon"
{
    CaptionML = ENU = 'Echelon', FRA = 'Échelon';
    Editable = true;
    PageType = List;
    SourceTable = "WDC Echelon";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field(Echelon; Rec.Echelon)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Date fomula"; Rec."Formula Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

