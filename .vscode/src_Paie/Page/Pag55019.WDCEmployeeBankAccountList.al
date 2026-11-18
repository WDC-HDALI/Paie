page 55019 "WDC Employee Bank Account List"
{
    CaptionML = ENU = 'Employee Bank Account List', FRA = 'Liste comptes bancaires salariés';
    DataCaptionFields = "Employee No.";
    Editable = true;
    PageType = Card;
    SourceTable = "WDC Employee Bank Account";

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
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = all;
                }
                field("Agency Code"; Rec."Agency Code")
                {
                    ApplicationArea = all;
                }

                field("RIB Key"; Rec."RIB Key")
                {
                    ApplicationArea = all;
                }

                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = all;
                }

                field(Contact; Rec.Contact)
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Bank Acc.")
            {
                CaptionML = ENU = '&Bank Acc.', FRA = '&Comptes bancaires';
                action(Card)
                {
                    applicationArea = all;
                    CaptionML = ENU = 'Card', FRA = 'Fiche';
                    Image = EditLines;
                    RunObject = Page 55021;
                    RunPageLink = "Employee No." = FIELD("Employee No."),
                                  Code = FIELD(Code);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
    }
}

