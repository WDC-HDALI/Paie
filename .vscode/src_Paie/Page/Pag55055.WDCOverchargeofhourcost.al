page 55055 "WDC Overcharge of hour cost"
{
    CaptionML = ENU = 'Overcharge of the hour Rate', FRA = 'Majoration des Taux horaire';
    PageType = Card;
    SourceTable = "WDC Overcharge of hour cost";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Regime of work"; Rec."Regime of work")
                {
                    ApplicationArea = all;
                }
                field(Identifier; Rec.Identifier)
                {
                    ApplicationArea = all;
                }
                field("Lower limit"; Rec."Lower limit")
                {
                    ApplicationArea = all;
                }
                field("Upper limit"; Rec."Upper limit")
                {
                    ApplicationArea = all;
                }
                field("Rate of overcharge"; Rec."Rate of overcharge")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

