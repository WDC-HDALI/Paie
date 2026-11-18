page 55054 "WDC Hist. Cotisation Sociale"
{
    CaptionML = ENU = 'Hist. Social Contribution', FRA = 'Hist. Cotisation Sociale';
    PageType = ListPart;
    SourceTable = "WDC Hist. Soc. Contribution";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = all;
                }
                field("Social Contribution Code"; Rec."Social Contribution Code")
                {
                    ApplicationArea = all;
                }
                field("Indemnity Code"; Rec."Indemnity Code")
                {
                    ApplicationArea = all;
                }
                field("Employer's part"; Rec."Employer's part")
                {
                    ApplicationArea = all;
                }
                field("Employee's part"; Rec."Employee's part")
                {
                    ApplicationArea = all;
                }
                field("Basis of calculation"; Rec."Basis of calculation")
                {
                    ApplicationArea = all;
                }
                field("Deductible of taxable basis"; Rec."Deductible of taxable basis")
                {
                    ApplicationArea = all;
                }
                field("Maximum value - Employee"; Rec."Maximum value - Employee")
                {
                    ApplicationArea = all;
                }
                field("Maximum value - Employer"; Rec."Maximum value - Employer")
                {
                    ApplicationArea = all;
                }
                field("Evaluation Mode"; Rec."Evaluation Mode")
                {
                    ApplicationArea = all;
                }
                field("Salary Package"; Rec."Salary Package")
                {
                    ApplicationArea = all;
                }
                field("Employer contribution"; Rec."Employer contribution")
                {
                    ApplicationArea = all;
                }

                field("Not Included in Accounting"; Rec."Not Included in Accounting")
                {
                    ApplicationArea = all;
                }
                field("Not Included in Bonus"; Rec."Not Included in Bonus")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

