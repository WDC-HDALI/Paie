xmlport 55036 "WDC Import Work Time"
{
    captionML = ENU = 'Import Work Time', FRA = 'Import Pointage';
    Direction = Import;
    FieldDelimiter = 'None';
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Heures occasionnelles"; "WDC Occasional Hours")
            {
                XmlName = 'ContactHeader';
                SourceTableView = SORTING("Employee No.", "Line No.", "Department Code", "Folder Code");
                textelement(NSalarie)
                {
                    Width = 20;
                }
                textelement(THJP)
                {
                }
                textelement(THJC)
                {
                }
                textelement(THJF)
                {
                }
                textelement(HS25)
                {
                }
                textelement(HS50)
                {
                }
                textelement(JS)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    //<<WDC
                    Nligne += 1;
                    EVALUATE(JourF, THJF);
                    EVALUATE(JourS, JS);
                    EVALUATE(NombreJ, THJP);
                    CLEAR(Heureocc);
                    Heureocc.SETRANGE("Employee No.", NSalarie);
                    IF NOT Heureocc.FINDSET THEN BEGIN
                        Heureocc.INIT;
                        Heureocc.VALIDATE("Employee No.", NSalarie);
                        Heureocc.VALIDATE("Line No.", Nligne);
                        Heureocc.VALIDATE("Posting Date", DateDebut);
                        IF Employee.GET(NSalarie) THEN BEGIN
                            IF Employee."Employee type".AsInteger() = 0 THEN
                                Heureocc.VALIDATE("Hours Number", NombreJ)
                            ELSE
                                Heureocc.VALIDATE("Days Number", NombreJ);
                        END;
                        Heureocc.VALIDATE("Pulic Holiday Days", JourF);
                        Heureocc.VALIDATE("Overtime Days", JourS);
                        Heureocc.INSERT;
                    END;
                    currXMLport.SKIP;
                    //>>WDC
                end;
            }
        }
    }


    trigger OnInitXmlPort()
    begin
        Nligne := 1000;
    end;

    trigger OnPostXmlPort()
    var
        lText001: TextConst ENU = 'Successfully imported', FRA = 'Import terminé';
    begin
        MESSAGE(lText001);
    end;

    trigger OnPreXmlPort()
    var
        lText001: TextConst ENU = 'The start date must be filled', FRA = ' La date début doit être renseignée.';
    begin
        IF DateDebut = 0D THEN
            ERROR(lText001);
    end;

    var
        DateDebut: Date;
        Heureocc: Record "WDC Occasional Hours";
        JourF: Decimal;
        JourS: Decimal;
        Nligne: Integer;
        Employee: Record Employee;
        NombreJ: Decimal;
}

