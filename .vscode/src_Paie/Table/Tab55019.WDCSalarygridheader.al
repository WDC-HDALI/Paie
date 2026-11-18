table 55019 "WDC Salary Grid Header"
{
    CaptionML = ENU = 'Salary grid header', FRA = 'En-tête grille de salaire';
    DrillDownPageID = 55035;
    LookupPageID = 55035;

    fields
    {
        field(1; Code; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(2; Description; Text[30])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(10; "Start Date"; Date)
        {
            CaptionML = ENU = 'Start Date', FRA = 'Date début';
        }
        field(11; "End Date"; Date)
        {
            CaptionML = ENU = 'End Date', FRA = 'Date fin';
        }
        field(100; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series', FRA = 'No. Série';
        }
        field(120; "Filter College"; Code[20])
        {
            CaptionML = ENU = 'Filter College', FRA = 'Filtre collège';
            FieldClass = FlowFilter;
            TableRelation = "WDC College";
        }
        field(121; "Filter Grade"; Integer)
        {
            CaptionML = ENU = 'Filter Grade', FRA = 'Filtre grade';
            FieldClass = FlowFilter;
        }
        field(122; "Filter Echelle"; Integer)
        {
            CaptionML = ENU = 'Filter Scale', FRA = 'Filtre échelle';
            FieldClass = FlowFilter;
        }
        field(123; "Filter Classe"; Enum "WDC Class Career record")
        {
            CaptionML = ENU = 'Filter Class', FRA = 'Filtre classe';
            FieldClass = FlowFilter;
        }
        field(50210; "Av. auto. Classe"; Boolean)
        {
            CaptionML = ENU = 'Auto advance Class', FRA = 'Av. auto. Classe';
        }
        field(50211; "Av. auto. Echelon"; Boolean)
        {
            CaptionML = ENU = 'Auto advance Step', FRA = 'Av. auto. Échelon';
        }
        field(8099200; "Expiry date"; Date)
        {
            CaptionML = ENU = 'Expiry date', FRA = 'Date d''expiration';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Start Date", "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        SalaryGridLines.SETRANGE(Code, Code);
        IF SalaryGridLines.FINDFIRST THEN
            SalaryGridLines.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF Code = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Salary grid Nos.");
            code := NoSeriesMgt.GetNextNo(HumanResSetup."Salary grid Nos.", WorkDate(), FALSE);
        END;
        "Start Date" := WORKDATE;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        EmployeeSalespersonUpdate: Codeunit 5201;
        DimMgt: Codeunit 408;
        SalaryGridHeader: Record "WDC Salary grid header";
        SalaryGridLines: Record "WDC Salary Grid Lines";

}

