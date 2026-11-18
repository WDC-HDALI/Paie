tableextension 55003 "WDC Employee Relative" extends "Employee Relative"
{

    fields
    {

        field(50001; Type; enum "WDC Relative Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';

            trigger OnValidate()
            begin
                IF Rec.Type <> Rec.Type::Child THEN BEGIN
                    "Associated deduction" := 0;
                    "Support Type" := "Support Type"::"Full coverage";
                END;
            end;
        }
        field(50002; "Support Type"; enum "WDC Support Type")
        {
            CaptionML = ENU = 'Support Type', FRA = 'Type prise en charge';

            trigger OnValidate()
            begin
                IF "Support Type" = "Support Type"::"Full coverage" THEN
                    "Associated deduction" := 0;
            end;
        }
        field(50004; "Associated deduction"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Associated deduction', FRA = 'Déduction associée';
            Editable = true;
        }
        field(50005; "Holding on end date"; Date)
        {
            CaptionML = ENU = 'Holding on end date', FRA = 'Blocage à la date fin';
        }
        field(50008; "Not Covered"; Boolean)
        {
            CaptionML = ENU = 'Not Covered', FRA = 'Non pris en charge';
        }
    }



    trigger OnDelete()
    var
        HRCommentLine: Record 5208;
    begin
        HRCommentLine.SETRANGE("Table Name", HRCommentLine."Table Name"::"Employee Relative");
        HRCommentLine.SETRANGE("No.", "Employee No.");
        HRCommentLine.DELETEALL;
    end;


}

