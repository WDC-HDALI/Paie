page 55047 "WDC Recorded Indemnities"
{
    CaptionML = ENU = 'Recorded Indemnities', FRA = 'Indemnités enregistrées';
    DataCaptionFields = "Employee No.", Type;
    Editable = false;
    PageType = List;
    SourceTable = 55026;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(EmployeeName; SalarieNom)
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
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
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Evaluation mode"; Rec."Evaluation mode")
                {
                    ApplicationArea = all;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = all;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = all;
                }
                field("Real Amount"; Rec."Real Amount")
                {
                    AutoFormatType = 0;
                    ApplicationArea = all;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = all;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        RecGEmploy.RESET;
        IF RecGEmploy.GET(Rec."Employee No.") THEN
            SalarieNom := RecGEmploy."First Name" + ' ' + RecGEmploy."Last Name";
    end;

    var
        SalarieNom: Code[80];
        RecGEmploy: Record Employee;
}

