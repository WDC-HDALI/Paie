pageextension 55008 "WDC Relatives" extends Relatives
{
    layout
    {
        addafter(Description)
        {
            field(Type; Rec.Type)
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
            field("Holding on end date"; Rec."Holding on end date")
            {
                ApplicationArea = all;
            }
        }
    }
}

