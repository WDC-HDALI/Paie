page 55028 "WDC Détail Prêt Avance"
{
    CaptionML = ENU = 'Loan & Advance Detail', FRA = 'Détail Prêt & Avance';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "WDC Loan & Advance Entry";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field(Employee; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Document type"; Rec."Document type")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
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
                field("Entry type"; Rec."Entry type")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Global dimension 1"; Rec."Global dimension 1")
                {
                    ApplicationArea = all;
                }
                field("Global dimension 2"; Rec."Global dimension 2")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

