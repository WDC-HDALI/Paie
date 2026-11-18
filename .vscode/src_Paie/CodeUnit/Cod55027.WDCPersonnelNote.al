codeunit 55027 "WDC Personnel Note "
{

    trigger OnRun()
    begin
    end;

    var
        Window: Dialog;
        i: Integer;
        j: Integer;
        BoolExist: Boolean;
        RecSalEng: Record 55025;

    procedure ValiderNote(var Sal: Record Employee; "Année": Integer; TrimestreT: Enum "WDC Quarter")
    var
        SalTmp: Record Employee;
        Noten: Record "WDC Notes";
    begin

        i := 0;
        j := 0;
        Noten.RESET;
        noten.SetCurrentKey("Entry No.");
        IF Noten.FINDLAST() THEN
            j := Noten."Entry No.";

        Window.OPEN('Validation Notes Personnel              \' +
                     ' Année #1#### #2#### Trimetsre         \' +
                     '                                       \' +
                     'Salariée #3########################### \' +
                     ' @4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ \');
        SalTmp.COPYFILTERS(Sal);
        SalTmp.SETFILTER(Trimestre, '%1', TrimestreT);
        SalTmp.SETRANGE("Note Type", 0, 5);
        IF SalTmp.FINDFIRST THEN
            REPEAT
                i := i + 1;
                Window.UPDATE(1, Année);
                Window.UPDATE(2, TrimestreT);
                Window.UPDATE(3, (SalTmp."No." + ' ' + SalTmp."Last Name" + ' ' + SalTmp."First Name"));
                Window.UPDATE(4, (ROUND(i / SalTmp.COUNT, 0.01) * 10000));
                IF NOT TestNte(SalTmp, Année, TrimestreT) THEN BEGIN
                    j := j + 1;
                    EnregistrerNote(SalTmp, Année, TrimestreT, j);
                END;
            UNTIL SalTmp.NEXT = 0;
        Window.CLOSE;
    end;


    procedure TestNte(Sal: Record Employee; "AnnéeT": Integer; trim: Enum "WDC Quarter") Im: Boolean
    var
        Noteeng: Record "WDC Notes";
    begin
        Im := FALSE;
        CLEAR(Noteeng);
        Noteeng.RESET;
        Noteeng.SETCURRENTKEY(Year, Trimestre, "Employee No.", "Note Type");
        Noteeng.SETFILTER("Employee No.", Sal."No.");
        Noteeng.SETFILTER(Year, '%1', AnnéeT);
        Noteeng.SETFILTER(Trimestre, '%1', trim);
        if Noteeng.FINDFIRST then
            IF (Noteeng.Note <> 0) OR (Noteeng.Montant <> 0) THEN
                Im := TRUE;
    end;


    procedure EnregistrerNote(Sal: Record Employee; "AnnéeT": Integer; trim: Enum "WDC Quarter"; var nseq: Integer)
    var
        Noteeng: Record "WDC Notes";
    begin
        Noteeng.Reset();
        Noteeng.SETFILTER(Year, '%1', AnnéeT);
        Noteeng.SETFILTER(Trimestre, '%1', trim);
        Noteeng.SETFILTER("Employee No.", Sal."No.");
        BoolExist := FALSE;
        IF Noteeng.FINDFIRST THEN
            BoolExist := TRUE
        ELSE
            BoolExist := FALSE;

        CASE BoolExist OF
            TRUE:
                BEGIN
                    IF Sal.Note <> 0 THEN BEGIN
                        Noteeng.Note := Sal.Note;
                        Noteeng.VALIDATE(Note);
                        Noteeng."Posting Date" := WORKDATE;
                        Noteeng."Presence Percent" := Sal."Presence Percent";
                        Noteeng.MODIFY;
                        Sal.Note := 0;
                        Sal.MODIFY;
                    END
                END;
            FALSE:
                BEGIN
                    IF Sal.Note <> 0 THEN BEGIN
                        Noteeng.INIT;
                        Noteeng.Year := AnnéeT;
                        Noteeng.Trimestre := trim;
                        Noteeng."Employee No." := Sal."No.";
                        Noteeng."Entry No." := nseq;
                        Noteeng."Note Type" := Noteeng."Note Type"::"Diligence and Punctuality";
                        Noteeng.Note := Sal.Note;
                        Noteeng.Purcent := Sal.Purcent;
                        Noteeng."Presence Percent" := Sal."Presence Percent";
                        Noteeng.VALIDATE(Note);
                        Noteeng."Posting Date" := WORKDATE;
                        Noteeng.INSERT;
                        Sal.Note := 0;
                        Sal.Purcent := 0;
                        Sal.MODIFY;
                    END
                END;
        END;
    end;
}

