table 55020 "WDC Salary Grid Lines"
{
    CaptionML = ENG = 'Salary Grid Lines', FRA = 'Lignes de grille salariale';


    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENG = 'Code', FRA = 'Code';

            Editable = false;
            TableRelation = "WDC Salary grid header";
        }
        field(2; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', FRA = 'N° sequence';
            Editable = false;
        }
        field(3; "College"; Code[20])
        {
            CaptionML = ENG = 'College', FRA = 'College';
            Editable = true;
            TableRelation = "WDC College";
        }
        field(4; Grade; Integer)
        {
            CaptionML = ENG = 'Grade', FRA = 'Grade';

            trigger OnValidate()
            var
                Err001: TextConst ENG = 'College does not exist!!!', FRA = 'College inexistant !!!';
                Err002: TextConst ENG = 'Grade must be between %1 and %2, please', FRA = 'Grade doit être entre %1 et %2, merci';
            begin
                CLEAR(College1);
                IF NOT College1.GET(College) THEN
                    ERROR(Err001);
                IF (Grade > College1."Upper Limit") OR (Grade < College1."Lower Limit") THEN
                    ERROR(Err002, College1."Upper Limit", College1."Lower Limit");
            end;
        }
        field(5; Scale; Integer)
        {
            CaptionML = ENG = 'Scale', FRA = 'Échelle';
        }
        field(6; Class; Enum "WDC Class Career record")
        {
            CaptionML = ENG = 'Class', FRA = 'Classe';
        }
        field(7; Echelon; Integer)
        {
            TableRelation = "WDC Echelon".Echelon;
        }
        field(8; "Basis Salary"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENG = 'Basis Salary', FRA = 'Salaire de base';
            DecimalPlaces = 3 : 3;
        }
        field(9; "Date fomula"; DateFormula)
        {
            CaptionML = ENG = 'Date Formula', FRA = 'Formule de date';
        }
        field(10; "User ID"; Code[20])
        {
            Editable = false;
            TableRelation = User;
            CaptionML = ENG = 'User ID', FRA = 'ID Utilisateur';
        }
        field(11; "Last Modified Date"; Date)
        {
            CaptionML = ENG = 'Last Modified Date', FRA = 'Dernière modification';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Code, College, Grade, Scale, Class, Echelon)
        {
            SumIndexFields = "Basis salary";
        }
        key(Key3; "Code", Grade)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        Echelon: Record "WDC Echelon";
    begin
        "User ID" := USERID;
        "Last Modified Date" := WORKDATE;
        Echelon.RESET;
        IF Echelon.GET(rec.Echelon) THEN
            "Date fomula" := Echelon."Formula Date";
    end;

    var
        College1: Record "WDC College";
}

