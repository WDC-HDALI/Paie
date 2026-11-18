table 55038 "WDC Grid Line"
{
    CaptionML = ENG = 'Line Grid', FRA = 'Ligne de grille';

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENG = 'Code', FRA = 'Code';
            Editable = false;
            TableRelation = "WDC Salary grid header";
        }
        field(2; "College"; Code[20])
        {
            CaptionML = ENG = 'College', FRA = 'College';
            Editable = true;
            NotBlank = true;
            TableRelation = "WDC College";
        }
        field(3; Scale; Integer)
        {
            CaptionML = ENG = 'Scale', FRA = 'Echelle';
            TableRelation = "WDC Scale".Scale WHERE(Category = FIELD(College));
        }
        field(4; Echelon; Integer)
        {
            CaptionML = ENG = 'Echelon', FRA = 'Échelon';
            TableRelation = "WDC Echelon".Echelon;
        }
        field(5; Class; Enum "WDC Class Career record")
        {
            CaptionML = ENG = 'Class', FRA = 'Classe';
        }
        field(6; "Filter Echelon"; Integer)
        {
            CaptionML = ENG = 'Filter Echelon', FRA = 'Filtrer Échelon';
            FieldClass = FlowFilter;
        }
        field(7; "Base Salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENG = 'Base Salary', FRA = 'Salaire de base';
            DecimalPlaces = 3 : 3;
        }
        field(8; "New Basic Salary"; Decimal)
        {
            CaptionML = ENG = 'New Base Salary', FRA = 'Nouveau salaire de base';
        }
        field(9; "Old Basis Salary"; Decimal)
        {
            CaptionML = ENG = 'Old Base Salary', FRA = 'Ancien salaire de base';
        }
    }

    keys
    {
        key(Key1; "Code", "College", Scale, Echelon, Class)
        {
            Clustered = true;
        }
        key(Key2; "Code", "College", Echelon)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        SalaryGridLine.RESET;
        SalaryGridLine.SETCURRENTKEY(Code, College, Grade, Scale, Class, Echelon);
        SalaryGridLine.SETFILTER(Code, Code);
        SalaryGridLine.SETFILTER(College, College);
        SalaryGridLine.SETFILTER(Grade, '%1', Scale);
        SalaryGridLine.SETFILTER(Scale, '%1', Echelon);
        SalaryGridLine.SETFILTER(Class, '%1', Class);
        SalaryGridLine.DELETEALL;
    end;

    var
        SalaryGridLine: Record "WDC Salary Grid Lines";
}

