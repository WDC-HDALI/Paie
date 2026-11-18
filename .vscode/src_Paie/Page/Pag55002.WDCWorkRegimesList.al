page 55002 "WDC Work Regimes List"
{
    CaptionML = ENU = 'Work Regimes List', FRA = 'Liste régimes travail';
    PageType = list;
    Editable = false;
    SourceTable = "WDC work Regimes";
    CardPageId = 55001;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Work Hours per week"; Rec."Work Hours per week")
                {
                    ApplicationArea = all;
                }
                field("Max. Supp. Hours per month"; Rec."Max. Supp. Hours per month")
                {
                    ApplicationArea = all;
                }
                field("Days off per month"; Rec."Days off per month")
                {
                    ApplicationArea = all;
                }
                field("Assignement mode"; Rec."Assignement mode")
                {
                    ApplicationArea = all;
                }
                field("Default Regime"; Rec."Default Regime")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

