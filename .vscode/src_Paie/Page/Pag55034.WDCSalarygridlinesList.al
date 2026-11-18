page 55034 "WDC Salary Grid Lines List"
{
    CaptionML = ENU = 'Salary Grid Lines List', FRA = 'Liste lignes grille salaire';
    PageType = Card;
    SourceTable = "WDC Salary Grid Lines";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                Editable = false;
                field(Echelle; Rec.Echelon)
                {
                    ApplicationArea = all;
                }
                field(Code; Rec.Code)
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
                field("Basis salary"; Rec."Basis salary")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;

}

