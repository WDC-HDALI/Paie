pageextension 55017 "WDC Employment Contracts" extends "Employment Contracts"
{


    layout
    {
        addafter(Description)
        {
            field("Calendar Type"; Rec."Calendar Type")
            {
                ApplicationArea = all;
            }
            field("Code Calendar"; Rec."Code Calendar")
            {
                ApplicationArea = all;
            }
            field("Taxes Calculation Mode"; Rec."Taxes Calculation Mode")
            {
                ApplicationArea = all;
            }
            field("Employee Contract Type"; Rec."Employee Contract Type")
            {
                ApplicationArea = all;
            }
            field("Salary grid"; Rec."Salary grid")
            {
                ApplicationArea = all;
            }
            field("Default Employment Contract"; Rec."Default Employment Contract")
            {
                ApplicationArea = all;
            }
            field("Regular payments"; Rec."Regular payments")
            {
                ApplicationArea = all;
            }
            field("Employee type"; Rec."Employee type")
            {
                ApplicationArea = all;

                trigger OnValidate()
                begin
                    CurrPage.SAVERECORD;
                end;
            }
            field(Taxable; Rec.Taxable)
            {
                ApplicationArea = all;
            }
            field("Temporary payments"; Rec."Temporary payments")
            {
                ApplicationArea = all;
            }
            field("Take in account deductions"; Rec."Take in account deductions")
            {
                ApplicationArea = all;
            }
            field("Has Bonus 13"; Rec."Has Bonus 13")
            {
                ApplicationArea = all;
            }
            field("Adjust indemnity amount"; Rec."Adjust indemnity amount")
            {
                ApplicationArea = all;
            }
            field("Slice of imposition"; Rec."Slice of imposition")
            {
                ApplicationArea = all;
            }
            field("Work Regimes"; Rec."Work Regime")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addfirst(Navigation)
        {
            group("Employment Contract")
            {
                Caption = 'Employment Contract';
                action(Fiche)
                {
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;
                    Image = Card;
                    RunObject = Page 55065;
                    RunPageLink = Code = FIELD(Code);
                }
            }
        }
    }
}

