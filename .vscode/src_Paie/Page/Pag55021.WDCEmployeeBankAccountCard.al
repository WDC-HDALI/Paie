page 55021 "WDC Employee Bank Account Card"
{
    CaptionML = ENU = 'Employee Bank Account Card', FRA = 'Fiche compte bancaire salarié';
    Editable = true;
    PageType = Card;
    SourceTable = "WDC Employee Bank Account";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = all;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = all;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = all;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = all;
                }
                field("Country Code"; Rec."Country Code")
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
                field("Currency Code"; Rec."Currency Code")
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
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = all;
                }
                field("RIB Key"; Rec."RIB Key")
                {
                    ApplicationArea = all;
                }
                field("RIB Checked"; Rec."RIB Checked")
                {
                    ApplicationArea = all;
                }
            }
            group(Communication)
            {
                CaptionML = ENU = 'Communication', FRA = 'Communication';
                field("Phone No. 2"; Rec."Phone No.")
                {
                    ApplicationArea = all;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = all;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = all;
                }
                field("Home Page"; Rec."Home Page")
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
            action(List)
            {
                ApplicationArea = all;
                CaptionML = ENU = 'List', FRA = 'Liste';
                Image = List;
                RunObject = Page "WDC Employee Bank Account List";
                RunPageLink = "Employee No." = FIELD("Employee No.");
            }
        }
    }

}

