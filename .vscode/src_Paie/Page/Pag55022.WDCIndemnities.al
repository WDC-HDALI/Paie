page 55022 "WDC Indemnities"
{
    CaptionML = ENU = 'Indemnities', FRA = 'Indemnités';
    DataCaptionFields = "Employee No.", Type;
    PageType = Card;
    SourceTable = "WDC Indemnities";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    CaptionML = ENU = 'Name', FRA = 'Nom salarié';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Indemnity; Rec.Indemnity)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = all;
                }
                field("Real Amount"; Rec."Real Amount")
                {
                    ApplicationArea = all;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

