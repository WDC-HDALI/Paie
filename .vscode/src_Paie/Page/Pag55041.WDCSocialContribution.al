page 55041 "WDC Social Contribution"
{
    CaptionML = ENU = 'Social Contribution', FRA = 'Cotisations sociale';
    PageType = Card;
    SourceTable = "WDC Social Contributions";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Employee; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Social Contribution"; Rec."Social Contribution")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Real Amount : Employee"; Rec."Real Amount : Employee")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Real Amount : Employer"; Rec."Real Amount : Employer")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Deductible of taxable basis"; Rec."Deductible of taxable basis")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

