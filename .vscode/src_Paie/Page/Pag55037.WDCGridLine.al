page 55037 "WDC Grid Line"
{
    CaptionML = ENU = 'Grid Lines ', FRA = 'Lignes grille';
    PageType = ListPart;
    SourceTable = 55038;
    ModifyAllowed = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field("College"; Rec.College)
                {
                    ApplicationArea = all;
                }
                field(Echelle; Rec.Scale)
                {
                    ApplicationArea = all;
                }
                field(Echelon; Rec.Echelon)
                {
                    ApplicationArea = all;
                }
                field("Basis Salary"; Rec."Base Salary")
                {
                    ApplicationArea = all;
                }
                field("New Basic Salary"; Rec."New Basic Salary")
                {
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Old Basis Salary"; Rec."Old Basis Salary")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
            }
        }
    }

}

