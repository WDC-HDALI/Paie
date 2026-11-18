page 55017 "WDC Indemnity Card"
{
    CaptionML = ENU = 'Indemnity Card', FRA = 'Fiche indemnité';
    PageType = Card;
    SourceTable = "WDC Indemnity";

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
                field("Employee Posting Grp. filter"; Rec."Employee Posting Grp. filter")
                {
                    ApplicationArea = all;
                }
                field("Payment No. filter"; Rec."Payment No. filter")
                {
                    ApplicationArea = all;
                }
                field("Total Indemnity"; Rec."Total Indemnity")
                {
                    ApplicationArea = all;
                }
                field("Total Rec. Indemnity"; Rec."Total Rec. Indemnity")
                {
                    ApplicationArea = all;
                }
                field("Minimum value"; Rec."Minimum value")
                {
                    ApplicationArea = all;
                }
                field(Taux; Rec.Rate)
                {
                    ApplicationArea = all;
                }
                field("Indemnity Type"; Rec."Indemnity Type")
                {
                    ApplicationArea = all;
                }
                field("Not Included Public Holidays"; Rec."Not Included Public Holidays")
                {
                    ApplicationArea = all;
                }
                field("Not Included in Bonus"; Rec."Not Included in Bonus")
                {
                    ApplicationArea = all;
                }
                field("Amount Rounding Precision"; Rec."Amount Rounding Precision")
                {
                    ApplicationArea = all;
                }
                field("Rounding Direction"; Rec."Rounding Direction")
                {
                    ApplicationArea = all;
                }
                field("Not included in vacation days"; Rec."Not included in vacation days")
                {
                    ApplicationArea = all;
                }
                field("Conventional Indemnity"; Rec."Conventional Indemnity")
                {
                    ApplicationArea = all;
                }
                field("Deduction Base Indemnity/Days"; Rec."Deduction Base Indemnity/Days")
                {
                    ApplicationArea = all;
                }
                field("Deduction Base Indemnity/Hour"; Rec."Deduction Base Indemnity/Hour")
                {
                    ApplicationArea = all;
                }
                field("Not incl. Nat. Old Age Insur."; Rec."Not incl. Nat. Old Age Insur.")
                {
                    ApplicationArea = all;
                }
                field("Benefit in Kind"; Rec."Benefit in Kind")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

