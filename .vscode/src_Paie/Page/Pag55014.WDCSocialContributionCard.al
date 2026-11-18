page 55014 "WDC Social Contribution Card"
{
    CaptionML = ENU = 'Social Contribution Card', FRA = 'Fiche cotisation Sociale';
    PageType = Card;
    SourceTable = "WDC Social Contribution";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
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
                field("Apply to all Employees"; Rec."Apply to all Employees")
                {
                    ApplicationArea = all;
                }
                field("Deductible of taxable basis"; Rec."Deductible of taxable basis")
                {
                    ApplicationArea = all;
                }
            }
            group("G/AL Config.")
            {
                CaptionML = ENU = 'G/AL Config.', FRA = 'Config. G/AL';
                field("Employee Account No."; Rec."Employee Account No.")
                {
                    ApplicationArea = all;
                }
                field("Employer Account No."; Rec."Employer Account No.")
                {
                    ApplicationArea = all;
                }
                field("Employer : Bal. Account No."; Rec."Employer : Bal. Account No.")
                {
                    ApplicationArea = all;
                }
            }
            group(Totals)
            {
                CaptionML = ENU = 'Totals', FRA = 'Totaux';
                field("Payment No. filter"; Rec."Payment No. filter")
                {
                    ApplicationArea = all;
                }
                field("Employee Posting Grp. filter"; Rec."Employee Posting Grp. filter")
                {
                    ApplicationArea = all;
                }
                field("Total employee's part"; Rec."Total employee's part")
                {
                    ApplicationArea = all;
                }
                field("Total employer's part"; Rec."Total employer's part")
                {
                    ApplicationArea = all;
                }
            }
        }
    }


}

