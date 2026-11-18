page 55048 "WDC Rec. Social Contrib."
{
    CaptionML = ENU = 'Recorded Social Contribution', FRA = 'Cotisations sociales enregistrées';
    Editable = false;
    PageType = List;
    SourceTable = 55027;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }

                field(Indemnity; Rec.Indemnity)
                {
                    ApplicationArea = all;
                }
                field("Social Contribution"; Rec."Social Contribution")
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
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = all;
                }
                field("Real Amount : Employee"; Rec."Real Amount : Employee")
                {
                    ApplicationArea = all;
                }
                field("Real Amount : Employer"; Rec."Real Amount : Employer")
                {
                    ApplicationArea = all;
                }
                field("Deductible of taxable basis"; Rec."Deductible of taxable basis")
                {
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

