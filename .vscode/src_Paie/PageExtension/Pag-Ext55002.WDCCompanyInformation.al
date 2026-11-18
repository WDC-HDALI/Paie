pageextension 55002 "WDC Company Information" extends "Company Information"
{
    layout
    {

        addafter(Picture)
        {
            field("Executive Director 1"; Rec."Executive Director 1")
            {
                ApplicationArea = all;
            }
            field("Executive Director 2"; Rec."Executive Director 2")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Industrial Classification")
        {
            field("Social Security No."; Rec."Social Security No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
