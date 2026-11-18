table 55049 "WDC Tablau amortissement prêt"
{

    fields
    {
        field(1; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° employé';
            TableRelation = Employee;
        }
        field(3; "Interest Calculation Base"; Decimal)
        {
            CaptionML = ENU = 'Interest Calculation Base', FRA = 'Base de calcul des intérêts';
        }
        field(4; "Annuity"; Decimal)
        {
            CaptionML = ENU = 'Annuity', FRA = 'Annuité';
        }
        field(5; "Annual Interest"; Decimal)
        {
            CaptionML = ENU = 'Annual Interest', FRA = 'Intérêt annuels';
        }
        field(6; "Principal Repaid"; Decimal)
        {
            CaptionML = ENU = 'Principal Repaid', FRA = 'Principal remboursé';
        }
        field(7; "Remaining Principal"; Decimal)
        {
            CaptionML = ENU = 'Remaining Principal', FRA = 'Principal restant dû';
        }
    }

    keys
    {
        key(Key1; "Year")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.")
        {
        }
    }
}

