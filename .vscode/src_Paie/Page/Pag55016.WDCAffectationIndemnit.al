page 55016 "WDC Indemnities Affectation"
{
    PageType = List;
    SourceTable = "WDC Default Indemnities";
    CaptionML = ENU = 'Indemnities Affectation', FRA = 'Affectation Indemnité';
    layout
    {
        area(content)
        {
            repeater(general)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Indemnity Code"; Rec."Indemnity Code")
                {
                    ApplicationArea = all;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = all;
                }
                field(CalcLib; Rec.CalcLib)
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
                field("Default amount"; Rec."Default amount")
                {
                    ApplicationArea = all;
                }
                field("Not Included in Bonus"; Rec."Not Included in Bonus")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    // actions
    // {
    //     area(creation)
    //     {
    //         action("Propose Indemnities")
    //         {
    //             Image = AmountByPeriod;
    //             ApplicationArea = all;
    //             captionMl = ENU = 'Propose Indemnities', FRA = 'Proposer indemnités';
    //             trigger OnAction()
    //             var
    //                 lRproposer: Report 55012;
    //             begin
    //                 CLEAR(lRproposer);
    //                 lRproposer.Setind(Rec."Indemnity Code");
    //                 lRproposer.RUNMODAL;
    //                 CurrPage.UPDATE;
    //             end;
    //         }
    //     }
    // }
}

