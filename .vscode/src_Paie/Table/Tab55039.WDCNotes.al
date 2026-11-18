table 55039 "WDC Notes"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', FRA = 'N° Séquence';
            Editable = false;
        }
        field(2; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';
        }
        field(3; Trimestre; Enum "WDC Quarter")
        {
            CaptionML = ENU = 'Quarter', FRA = 'Trimestre';
        }
        field(4; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° Employé';
            TableRelation = Employee."No.";
        }
        field(5; "Note Type"; Enum "WDC Note Type")
        {
            CaptionML = ENU = 'Note Type', FRA = 'Type Note';
        }
        field(6; Note; Decimal)
        {
            CaptionML = ENU = 'Note', FRA = 'Note';
            trigger OnValidate()
            begin
                IF (Note > 0) AND (Note <= 10) THEN
                    NBJours := 17;

                IF (Note > 10) AND (Note <= 14) THEN
                    NBJours := 20;

                IF (Note > 14) AND (Note <= 17) THEN
                    NBJours := 25;

                IF (Note > 17) AND (Note <= 20) THEN
                    NBJours := 30;

            end;
        }
        field(13; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date travail';
            Editable = false;
        }
        field(14; Montant; Decimal)
        {
        }
        field(15; NBJours; Decimal)
        {
        }
        field(16; Nom; Text[30])
        {
            CalcFormula = Lookup(Employee."Last Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(17; Prenom; Text[60])
        {
            CalcFormula = Lookup(Employee."First Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(18; "Payment N°"; Code[20])
        {
            Caption = 'N° Paiement';
        }
        field(19; Purcent; Decimal)
        {
            CaptionML = ENU = 'Purcent', FRA = 'Pourcentage';
        }
        field(20; "Presence Percent"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Year, Trimestre, "Employee No.", "Note Type")
        {
            SumIndexFields = Note;
        }
    }

    trigger OnDelete()
    var
        TEXT01: TextConst ENU = 'Impossible to delete this line',
                          FRA = 'Impossible de supprimer cette ligne';
    begin
        IF "Payment N°" <> '' THEN
            ERROR(TEXT01)
    end;

    trigger OnInsert()
    begin
        "Posting Date" := WORKDATE;
    end;

    trigger OnModify()
    begin
        "Posting Date" := WORKDATE;
    end;
}

