page 55076 "WDC Salary Adjustment"
{
    CaptionML = ENU = 'Salary adjustment', FRA = 'Rappel sur salaire';
    PageType = List;
    SourceTable = 55004;
    SourceTableView = SORTING("Emplymt. Contract Code", "Indemnity Code", "Not Included in Bonus")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        Rec.VALIDATE("Indemnity Code", 'G134');
                    end;
                }
                field("Indemnity Code"; Rec."Indemnity Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Days Number"; Rec."Days Number")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        Employee: Record Employee;
                        SetUpRH: Record "Human Resources Setup";
                    begin
                        IF Employee.GET(Rec."Emplymt. Contract Code") THEN BEGIN
                            SetUpRH.GET();

                            Rec.VALIDATE("Default amount", ROUND(((Employee."Basis salary" * Rec."Days Number") / SetUpRH."Worked days"), SetUpRH."Rounded Amount"));
                        END;
                        CurrPage.UPDATE;
                    end;
                }
                field("Default amount"; Rec."Default amount")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 6 : 3;
                    Editable = false;
                }
            }
        }
    }
}

