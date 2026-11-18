table 55002 "WDC Slices of imposition"
{
    CaptionML = ENU = 'Slices of imposition', FRA = 'Tranches d''imposition';
    LookupPageID = 55008;

    fields
    {
        field(1; "No."; Integer)
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
        }
        field(2; "Code"; Code[4])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(3; "Lower limit"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Lower limit', FRA = 'Limite inférieure';

            trigger OnValidate()
            begin
                IF ("Lower limit" < "Superior limit") THEN
                    "Slice amount" := ("Superior limit" - "Lower limit") * Rate / 100
                ELSE
                    "Slice amount" := 0;
            end;
        }
        field(4; "Superior limit"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Superior limit', FRA = 'Limite supérieure';

            trigger OnValidate()
            begin
                IF ("Lower limit" < "Superior limit") THEN
                    "Slice amount" := ("Superior limit" - "Lower limit") * Rate / 100
                ELSE
                    "Slice amount" := 0;
            end;
        }
        field(5; Rate; Decimal)
        {
            CaptionML = ENU = 'Rate', FRA = 'Taux';

            trigger OnValidate()
            begin
                IF ("Lower limit" < "Superior limit") THEN
                    "Slice amount" := ("Superior limit" - "Lower limit") * Rate / 100
                ELSE
                    "Slice amount" := 0;
            end;
        }
        field(100; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series', FRA = 'Souche de numérotation';
            Editable = false;
        }
        field(200; "Slice Amount"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Slice Amount', FRA = 'Montant tranche';
            Editable = true;
        }
        field(8099198; "User ID"; Code[22])
        {
            CaptionML = ENU = 'User ID', FRA = 'ID utilisateur';
            Editable = false;
            TableRelation = User;
        }
        field(8099199; "Last Date Modified"; Date)
        {
            CaptionML = ENU = 'Last Date Modified', FRA = 'Dernière date modifiée';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Last Date Modified" := WORKDATE;
        "User ID" := USERID;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := WORKDATE;
        "User ID" := USERID;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := WORKDATE;
        "User ID" := USERID;
    end;

}

