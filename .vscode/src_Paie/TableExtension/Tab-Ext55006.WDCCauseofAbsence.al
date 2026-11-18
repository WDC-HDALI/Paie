tableextension 55006 "WDC Cause of Absence" extends "Cause of Absence"
{
    fields
    {
        field(50000; "Imputable on Holiday"; Boolean)
        {
            CaptionML = ENU = 'Imputable on Holiday', FRA = 'Imputable sur congé';
        }
        field(50001; "Authorized Days number"; Decimal)
        {
            CaptionML = ENU = 'Authorized Days number', FRA = 'Nbre Jour autorisé';
            DecimalPlaces = 0 : 2;
        }
        field(50002; "Auth. Days number Period 1"; Decimal)
        {
            CaptionML = ENU = 'Auth. Days number Period 1', FRA = 'Nbre de J auto. Période 1';
            DecimalPlaces = 0 : 2;
        }
        field(50003; "Auth. Days number Period 2"; Decimal)
        {
            CaptionML = ENU = 'Auth. Days number Period 2', FRA = 'Nbre de J auto. Période 2';
            DecimalPlaces = 0 : 2;
        }
        field(50004; "Cause Code Period 2"; Code[20])
        {
            CaptionML = ENU = 'Cause Code Period 2', FRA = 'Code Cause Période 2';
            TableRelation = "Cause of Absence";
        }
        field(50005; "Auth. Days Number Period 3"; Decimal)
        {
            CaptionML = ENU = 'Auth. Days number Period 3', FRA = 'Nbre de J auto. Période 3';
            DecimalPlaces = 0 : 2;
        }
        field(50006; "Cause Code Period 3"; Code[20])
        {
            CaptionML = ENU = 'Cause Code Period 3', FRA = 'Code Cause Période 3';
            TableRelation = "Cause of Absence";
        }
        field(50007; "Absence Reason"; Enum "WDC Absence Reason")
        {
            CaptionML = ENU = 'Absence Reason', FRA = 'Motif d''absence';
        }
        field(50008; "Cause Code Period 1"; Code[20])
        {
            TableRelation = "Cause of Absence";
            CaptionML = ENU = 'Cause Code Period 1', FRA = 'Code Cause Période 1';
        }
        field(50009; Type; Enum "WDC Absence Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';
        }
        field(50010; "Total validated Absence"; Decimal)
        {
            CaptionML = ENU = 'Total validated Absence', FRA = 'Total absences validées';
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 1;
            CalcFormula = Sum("WDC Employee's days off Entry".Quantity WHERE("Cause of Absence Code" = FIELD(Code),
                                                                          "Employee No." = FIELD("Employee No. Filter"),
                                                                          "From Date" = FIELD("Date Filter")));

        }
        field(50013; "Is Santion"; Boolean)
        {
            CaptionML = ENU = 'Is Santion', FRA = 'Sanction';
        }
    }

}

