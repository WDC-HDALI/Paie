page 55044 "WDC Recorded Salary List"
{
    CaptionML = ENU = 'Recorded salary List', FRA = 'Liste salaires enregistrés';
    PageType = List;
    CardPageID = 55046;
    Editable = true;
    SourceTable = "WDC Posted Salary Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Month; Rec.Month)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Year; Rec.Year)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Integrated in accounting"; Rec."Integrated in accounting")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Worked days"; Rec."Worked days")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;

}

