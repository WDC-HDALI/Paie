pageextension 55003 "WDC User Setup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Allow Cancel Posted Payroll"; Rec."Allow Cancel Posted Payroll")
            {
                ApplicationArea = All;
            }
        }
    }
}
