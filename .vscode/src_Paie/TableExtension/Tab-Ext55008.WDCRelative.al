tableextension 55008 "WDC Relative" extends "Relative"
{

    fields
    {
        field(50000; Type; Enum "WDC Relative Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';
            trigger OnValidate()
            begin
                IF Type.AsInteger() <> 1 THEN BEGIN
                    "Associated deduction" := 0;
                    "Support Type" := "Support Type"::"Full Coverage";
                END;
            end;
        }
        field(50001; "Support Type"; Enum "WDC Support Type")
        {
            CaptionML = ENU = 'Support Type', FRA = 'Type de soutien';

            trigger OnValidate()
            begin
                IF "Support Type".AsInteger() = 1 THEN
                    "Associated deduction" := 0;
            end;
        }
        field(50002; "Associated deduction"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Associated deduction', FRA = 'Déduction associée';
        }
        field(50003; "Holding on End date"; DateFormula)
        {
            CaptionML = ENU = 'Holding on End date', FRA = 'Maintien à l''échéance';
        }
    }
}

