page 55018 "WDC Irregular Indemnity"
{
    CaptionML = ENU = 'Irregular Indemnity', FRA = 'Indeminités irrégulières';
    PageType = List;
    SourceTable = "WDC Default Indemnities";
    SourceTableView = SORTING("Emplymt. Contract Code", "Indemnity Code", "Not Included in Bonus")
                      ORDER(Ascending)
                      WHERE("Indemnity Type" = FILTER("Not Regular"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = all;
                }
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
                field("Default amount"; Rec."Default amount")
                {
                    ApplicationArea = all;
                }
                field("Indemnity Type"; Rec."Indemnity Type")
                {
                    ApplicationArea = all;
                }
                field("Days Number"; Rec."Days Number")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

