page 55079 "WDC Note Parameters"
{
    PageType = List;
    SourceTable = "WDC Note Parameters";
    CaptionML = ENU = 'Note Parameters', FRA = 'Paramètres Note';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
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
                field("Purcent"; Rec."Purcent")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

