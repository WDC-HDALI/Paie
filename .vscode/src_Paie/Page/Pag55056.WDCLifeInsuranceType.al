page 55056 "WDC Life Insurance Type"
{
    CaptionML = ENU = 'Life Insurance Type', FRA = 'Type assurance vie';
    PageType = List;
    SourceTable = 55041;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(description; Rec.description)
                {
                    ApplicationArea = all;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

