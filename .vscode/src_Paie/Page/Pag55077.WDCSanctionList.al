page 55077 "WDC Sanction List"
{
    PageType = List;
    SourceTable = 5207;
    SourceTableView = WHERE("Is Santion" = CONST(true));
    CaptionML = ENU = 'Sanction List', FRA = 'Liste sanctions';
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = all;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = all;
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        CauseAbsence: Record 5206;
                    begin
                        CauseAbsence.RESET;
                        IF CauseAbsence.GET(Rec."Cause of Absence Code") THEN
                            Rec."Is Santion" := CauseAbsence."Is Santion";
                        Rec.MODIFY;
                    end;
                }
                field("Line type"; Rec."Line type")
                {
                    ApplicationArea = all;
                }
                field("Absence Reason"; Rec."Absence Reason")
                {
                    ApplicationArea = all;
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Posting month"; Rec."Posting month")
                {
                    ApplicationArea = all;
                }
                field("Posting year"; Rec."Posting year")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Recovery Entry No.";
                Rec."Recovery Entry No.")
                {
                    ApplicationArea = all;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = all;
                }
            }
        }
        area(factboxes)
        {

            systempart(Notes; Notes)
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
    }


    var
        FieldStyle: Text[30];
}

