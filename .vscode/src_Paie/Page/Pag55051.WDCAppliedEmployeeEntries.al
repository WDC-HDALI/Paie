page 55051 "WDC Applied Employee Entries"
{
    CaptionML = ENU = 'Applied Employee Entries', FRA = 'Ecritures salarié lettrées';
    DataCaptionExpression = Heading;
    Editable = false;
    PageType = Card;
    SourceTable = "Employee Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                // field("External Document No."; Rec."External Document No.")
                // {
                //     Visible = true;
                //     ApplicationArea = all;
                // }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Closed by Amount"; Rec."Closed by Amount")
                {
                    ApplicationArea = all;
                }
                field("Closed by Currency Code"; Rec."Closed by Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Closed by Currency Amount"; Rec."Closed by Currency Amount")
                {
                    //AutoFormatExpression = "Closed by Currency Code";
                    AutoFormatType = 1;
                    ApplicationArea = all;
                }

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {

        area(processing)
        {
            action("&Navigate")
            {
                CaptionML = ENU = '&Navigate', FRA = '&Naviguer';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        Heading: Text[50];
        Navigate: Page 344;
}

