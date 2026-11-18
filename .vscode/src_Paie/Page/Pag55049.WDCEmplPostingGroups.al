page 55049 "WDC Empl. Posting Groups"
{
    CaptionML = ENU = 'Employee Posting Groups', FRA = 'Groupes compta. employés';
    PageType = List;
    SourceTable = "WDC Employee Posting Group";

    layout
    {
        area(content)
        {
            repeater(General)
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
                field("Net Salary Account No."; Rec."Net Salary Account No.")
                {
                    ApplicationArea = all;
                }
                field("Basis salary Account No."; Rec."Basis salary Account No.")
                {
                    ApplicationArea = all;
                }
                field("Supp. Hours Account No."; Rec."Supp. Hours Account No.")
                {
                    ApplicationArea = all;
                }
                field("Taxable Indemnities Acc. No."; Rec."Taxable Indemnities Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Social fund empl. Account No."; Rec."Social fund empl. Account No.")
                {
                    ApplicationArea = all;
                }
                field("Non Tax. Indemnities Acc. No."; Rec."Non Tax. Indemnities Acc. No.")
                {
                    ApplicationArea = all;
                }
                field("Taxes Account No."; Rec."Taxes Account No.")
                {
                    ApplicationArea = all;
                }
                field("13th/14th Month Account No."; Rec."13th/14th Month Account No.")
                {
                    ApplicationArea = all;
                }
                field("Bonus Account No."; Rec."Bonus Account No.")
                {
                    ApplicationArea = all;
                }
                field("Other Bonus Account No."; Rec."Other Bonus Account No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

