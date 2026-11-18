
tableextension 55009 "WDC Employee Absence" extends "Employee Absence"
{

    fields
    {
        modify("Employee No.")
        {
            trigger OnAfterValidate()
            Var
                lEmployee: Record Employee;
            begin
                lEmployee.GET("Employee No.");
                Name := lEmployee."First Name" + ' ' + lEmployee."Last Name";
                lEmployee.CALCFIELDS("Days off =");
                Rec."Holiday Balance" := lEmployee."Days off =";
            end;
        }

        modify("From Date")
        {
            trigger OnAfterValidate()
            begin

                Rec."Posting month" := Enum::"WDC Payroll Month".FromInteger(DATE2DMY("From Date", 2) - 1);
                Rec."Posting year" := DATE2DMY("From Date", 3);
                Rec."To Date" := Rec."From Date";
            end;
        }
        field(55000; "Is Santion"; Boolean)
        {
            CaptionML = ENU = 'Is Santion', FRA = 'Sanction';
        }
        field(55001; Management; Code[20])
        {
            CaptionML = ENU = 'Management', FRA = 'Direction';
        }
        field(55002; Service; Code[20])
        {
            CaptionML = ENU = 'Service', FRA = 'Service';
        }
        field(55003; Section; Code[20])
        {
            CaptionML = ENG = 'Section', FRA = 'Section';

        }
        field(55004; "Starting Time"; Time)
        {
            CaptionML = ENU = 'Starting Time', FRA = 'Heure début';
            trigger OnValidate()
            begin
                CLEAR("Ending Time");
            end;
        }
        field(55005; "Ending Time"; Time)
        {
            CaptionML = ENU = 'Ending Time', FRA = 'Heure fin';
            trigger OnValidate()
            begin
                IF "Line type".AsInteger() <> 1 THEN BEGIN
                    Quantity := Abscode.CalcJourHeureAbs(Rec, JN);
                    IF Unit.AsInteger() <> JN THEN
                        Unit := enum::"WDC Work Unit".FromInteger(JN);
                END;
            end;
        }
        field(55006; "Absence Reason"; Enum "WDC Absence Reason")
        {
            CaptionML = ENU = 'Absence Reason', FRA = 'Motif d''absence';
        }
        field(55007; "Validity Date"; Date)
        {
            CaptionML = ENU = 'Validity Date', FRA = 'Date Validation';
        }
        field(55008; "Recovery Entry No.";
        Integer)
        {

            trigger OnLookup()
            begin
                IF "Line type".AsInteger() = 2 THEN BEGIN
                    Absengtmp.RESET;
                    Absengtmp.SETCURRENTKEY("Employee No.", "Line type", "Validity Date");
                    Absengtmp.SETFILTER("Validity Date", '..%1', "To Date");
                    Absengtmp.SETFILTER("Employee No.", "Employee No.");
                    Absengtmp.SETRANGE("Line type", 1);
                    CLEAR(PageAbs);
                    PageAbs.SETTABLEVIEW(Absengtmp);
                    PageAbs.LOOKUPMODE := TRUE;
                    IF PageAbs.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        PageAbs.GETRECORD(Absengtmp);
                        "Recovery Entry No." := Absengtmp."Entry No.";
                    END;
                END;
            end;

            trigger OnValidate()
            var
                lText001: TextConst ENU = 'You must select the list !',
                                    FRA = 'vous devez sélectionner de la liste !';
            begin
                ERROR(lText001);
            end;
        }
        field(55009; "Filter Date"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(55010; "To Impute on days off"; Boolean)
        {
            CaptionML = ENU = 'To impute on days off', FRA = 'A imputer sur les jours de repos';
            Editable = false;
        }
        field(55011; Unit; Enum "WDC Work Unit")
        {
            CaptionML = ENU = 'Unit', FRA = 'Unité';
        }
        field(55012; "Posting month"; Enum "WDC Payroll Month")
        {
            CaptionML = ENU = 'Posting month', FRA = 'Mois comptabilisation';
        }
        field(55013; "Posting year"; Integer)
        {
            CaptionML = ENU = 'Posting year', FRA = 'Année comptabilisation';
        }
        field(55014; "Line type"; enum "WDC Absence Type")
        {
            CaptionML = ENU = 'Line type', FRA = 'Type ligne';
        }
        field(55015; Name; Text[30])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';
            Editable = false;
        }
        field(55016; Surname; Text[30])
        {
            CaptionML = ENU = 'Surname', FRA = 'Prénom';
            Editable = false;
        }
        field(55017; "Quantity en Hours"; Decimal)
        {
            CaptionML = ENU = 'Quantity en Hours', FRA = 'Quantité en Heures';
        }
        field(55018; Week; Integer)
        {
            CaptionML = ENU = 'Week', FRA = 'Semaine';
        }
        field(55019; Interim; Code[20])
        {
            CaptionML = ENU = 'Interim', FRA = 'Intérimaire';
            TableRelation = Employee;
        }
        field(55020; "Holiday Balance"; Decimal)
        {
            CaptionML = ENU = 'Holiday Balance', FRA = 'Solde Congé';
            Editable = false;
        }

    }
    procedure InsertionCP(EmployeeNo: Code[20])
    begin
        //>>WDC
        IF ("Line type" = "Line type"::"Day off Consumption") AND (Quantity <> 0) THEN BEGIN
            RecGParamRH.GET;
            RecGEmploy.RESET;
            RecGRegWork.RESET;
            RecGRegWork.Findfirst();
            IF EmploymentContract.GET("Employee No.") THEN
                EmploymentContract.CalcFields("Employee type");
            RecGRegWork.GET(EmploymentContract."Work Regime");
            CLEAR(RecGEmploy);
            RecGEmploy.SETRANGE("No.", "Employee No.");
            Dectarif := 0;
            Dectarif1 := 0;
            DectarifParJ := 0;
            DectarifHoraire := 0;
            MontantCong := 0;
            DecMntBase := 0;
            IF EmploymentContract."Employee type".AsInteger() = 1 THEN BEGIN
                //--------Mensuel
                RecGEmploy.GET("Employee No.");
                RecGIndemnity.RESET;
                RecGIndemnity.SETRANGE("Emplymt. Contract Code", EmployeeNo);
                RecGIndemnity.SETRANGE("Not Included Public Holidays", FALSE);
                RecGIndemnity.SETRANGE("Included in Overtime", TRUE);
                RecGIndemnity.SETFILTER("Indemnity Code", '<>%1', RecGParamRH."Paid Holiday Indemnity");
                RecGIndemnity.SETFILTER(Type, '<>%1', 2);    //WDC0805
                IF RecGIndemnity.Findfirst() THEN
                    REPEAT
                        Dectarif := Dectarif + RecGIndemnity."Default amount";
                    UNTIL RecGIndemnity.NEXT = 0;
                Dectarif := Dectarif / RecGRegWork."Worked Day Per Month"; //WDC2308
            END ELSE BEGIN
                //--------Horaire
                RecGIndemnity.RESET;
                RecGIndemnity.SETRANGE("Emplymt. Contract Code", EmployeeNo);
                RecGIndemnity.SETRANGE("Not Included Public Holidays", FALSE);
                RecGIndemnity.SETRANGE("Included in Overtime", TRUE);
                RecGIndemnity.SETFILTER("Indemnity Code", '<>%1', RecGParamRH."Paid Holiday Indemnity");
                RecGIndemnity.SETFILTER(Type, '<>%1', 2);    //WDC0805
                IF RecGIndemnity.Findfirst() THEN
                    REPEAT
                        Dectarif := Dectarif + RecGIndemnity."Default amount";
                    UNTIL RecGIndemnity.NEXT = 0;
                Dectarif := (Dectarif / RecGRegWork."Work Hours per month") * Quantity * 8;
            END;
        END;
        IF RecGEmploy.Findfirst() THEN BEGIN
            IF EmploymentContract."Employee type".AsInteger() = 1 THEN BEGIN
                DecMntBase := RecGEmploy."Basis salary" + Dectarif;
                MontantCong := (((Dectarif) + (RecGEmploy."Basis salary" / RecGRegWork."Worked Day Per Month")) * Quantity);
            END
            ELSE BEGIN
                DecMntBase := (RecGEmploy."Basis salary" * 8 * Quantity) + Dectarif;
                MontantCong := DecMntBase;
            END;
        END;

        IF ("Line type" = "Line type"::"Day off Consumption") AND (Quantity <> 0) THEN BEGIN
            CLEAR(IndemCong);
            IndemCong.SETRANGE("Emplymt. Contract Code", "Employee No.");
            IndemCong.SETRANGE("Indemnity Code", RecGParamRH."Paid Holiday Indemnity");
            IF IndemCong.FINDSET THEN
                IndemCong.DELETE;

            IndemCong.INIT;
            IndemCong."Emplymt. Contract Code" := "Employee No.";
            IndemCong.VALIDATE("Indemnity Code", RecGParamRH."Paid Holiday Indemnity");
            IndemCong."Days Number" := Quantity;
            IndemCong.VALIDATE("Default amount", MontantCong);
            IndemCong.INSERT;
        END;
    end;

    var
        Absengtmp: Record "WDC Employee's days off Entry";
        IndemCong: Record "WDC Default Indemnities";
        RecGParamRH: Record "Human Resources Setup";
        RecGEmploy: Record Employee;
        RecGRegWork: Record "WDC work Regimes";
        EmploymentContract: Record "Employment Contract";
        Dectarif: Decimal;
        RecGIndemnity: Record "WDC Default Indemnities";
        DecMntBase: Decimal;
        Dectarif1: Decimal;
        DectarifHoraire: Decimal;
        DectarifParJ: Decimal;
        MontantCong: Decimal;
        Abscode: Codeunit "WDC Absences Management";
        PageAbs: Page "WDC Empl.'s days off Entry";
        JN: Integer;
}

