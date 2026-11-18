page 55007 "WDC Default Indemnities"
{
    Editable = false;
    PageType = Card;
    SourceTable = "WDC Default Indemnities";
    captionML = ENU = 'Default Indemnities', FRA = 'Indemnités par défaut';
    layout
    {
        area(content)
        {
            repeater(General)
            {
                captionML = ENU = 'General', FRA = 'Général';
                field("Indemnity Code"; Rec."Indemnity Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Evaluation mode"; Rec."Evaluation mode")
                {
                    ApplicationArea = all;
                }
                field("Basis amount"; Rec."Basis amount")
                {
                    ApplicationArea = all;
                }
                field("Default amount"; Rec."Default amount")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

