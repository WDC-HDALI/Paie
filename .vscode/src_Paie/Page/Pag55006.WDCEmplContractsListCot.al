page 55006 "WDC Empl. Contracts List Cot"
{
    PageType = ListPart;
    SourceTable = "WDC Default Soc. Contribution";
    CaptionML = ENU = 'Empl. Contracts List Cot', FRA = 'Liste cotisations';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                captionML = ENU = 'General', FRA = 'Général';
                field("Social Contribution Code"; Rec."Social Contribution Code")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Evaluation Mode"; Rec."Evaluation Mode")
                {
                    ApplicationArea = all;
                }
                field("Employer's part"; Rec."Employer's part")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Employee's part"; Rec."Employee's part")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Basis of calculation"; Rec."Basis of calculation")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Salary Package"; Rec."Salary Package")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Employer contribution"; Rec."Employer contribution")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Deductible of taxable basis"; Rec."Deductible of taxable basis")
                {
                    ApplicationArea = all;
                }

                field("Not Included in Bonus"; Rec."Not Included in Bonus")
                {
                    ApplicationArea = all;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
            }
        }
    }
}

