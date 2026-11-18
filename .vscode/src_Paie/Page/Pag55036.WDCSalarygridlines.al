page 55036 "WDC Salary Grid Lines"
{
    CaptionML = ENU = 'Salary Grid Lines ', FRA = 'Lignes gris salaire';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = 55020;
    SourceTableView = SORTING("Entry No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Scale; Rec.Scale)
                {
                    ApplicationArea = all;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field(College; Rec.College)
                {
                    ApplicationArea = all;
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = all;
                }
                field("Date fomula"; Rec."Date fomula")
                {
                    ApplicationArea = all;
                }
                field("Basis salary"; Rec."Basis salary")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

