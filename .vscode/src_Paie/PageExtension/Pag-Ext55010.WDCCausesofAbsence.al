pageextension 55010 "WDC Causes of Absence" extends "Causes of Absence"
{

    layout
    {
        addafter("Unit of Measure Code")
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = all;
            }
            field("Absence Reason"; Rec."Absence Reason")
            {
                ApplicationArea = all;
            }
            field("Imputable on Holiday"; Rec."Imputable on Holiday")
            {
                ApplicationArea = all;
            }
            field("Total validated Absence"; Rec."Total validated Absence")
            {
                ApplicationArea = all;
            }
            field("Authorized Days number"; Rec."Authorized Days number")
            {
                ApplicationArea = all;
            }
            field("Auth. Days number Period 1"; Rec."Auth. Days number Period 1")
            {
                ApplicationArea = all;
            }
            field("Cause Code Period 1"; Rec."Cause Code Period 1")
            {
                ApplicationArea = all;
            }
            field("Auth. Days number Period 2"; Rec."Auth. Days number Period 2")
            {
                ApplicationArea = all;
            }
            field("Cause Code Period 2"; Rec."Cause Code Period 2")
            {
                ApplicationArea = all;
            }
            field("Auth. Days Number Period 3"; Rec."Auth. Days Number Period 3")
            {
                ApplicationArea = all;
            }
            field("Cause Code Period 3"; Rec."Cause Code Period 3")
            {
                ApplicationArea = all;
            }
            field("Is Santion"; Rec."Is Santion")
            {
                ApplicationArea = all;
            }
        }
    }

}

