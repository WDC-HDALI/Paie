page 55004 "WDC Employment Contracts List"
{
    CaptionML = ENU = 'Employment Contracts List', FRA = 'Liste Contrats Travail';
    Editable = false;
    PageType = Card;
    SourceTable = "Employment Contract";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                captionML = ENU = 'General', FRA = 'Général';
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Regular payments"; Rec."Regular payments")
                {
                    ApplicationArea = all;
                }
                field("Temporary payments"; Rec."Temporary payments")
                {
                    ApplicationArea = all;
                }
                field("Employee type"; Rec."Employee type")
                {
                    ApplicationArea = all;
                }
                field("Work Regimes"; Rec."Work Regime")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

