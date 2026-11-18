pageextension 55009 "WDC Employee Relatives" extends "Employee Relatives"
{


    layout
    {
        addafter("Phone No.")
        {

            field("Holding on end date"; Rec."Holding on end date")
            {
                ApplicationArea = all;
            }
            field("Not Covered"; Rec."Not Covered")
            {
                ApplicationArea = all;
            }
            field("Support Type"; Rec."Support Type")
            {
                ApplicationArea = all;
            }
            field("Associated deduction"; Rec."Associated deduction")
            {
                ApplicationArea = all;
            }

        }
    }

}

