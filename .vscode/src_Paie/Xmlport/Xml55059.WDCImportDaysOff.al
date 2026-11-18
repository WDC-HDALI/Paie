xmlport 55059 "WDC Import Days-Off"
{
    captionML = ENU = 'Import Days-Off', FRA = 'Import jours supp.';
    Direction = Import;
    FieldDelimiter = 'None';
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("WDC Occasional Hours"; "WDC Occasional Hours")
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
                textelement(AVANCE)
                {
                }
                textelement(DSAM)
                {
                }
                textelement(RETDON)
                {
                }
                textelement(DAIDFITR)
                {
                }
                textelement(DAIDKEBIR)
                {
                }
                textelement(DRENTSCO)
                {
                }
                textelement(PAIDIDHA)
                {
                }
                textelement(JSUPP)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    //<<WDC
                    Nligne += 1;
                    EVALUATE(JourS, JSUPP);
                    CLEAR(Heureocc);
                    Heureocc.SETRANGE("Employee No.", NSalarie);
                    IF NOT Heureocc.FINDSET THEN BEGIN
                        Heureocc.INIT;
                        Heureocc.VALIDATE("Employee No.", NSalarie);
                        Heureocc.VALIDATE("Line No.", Nligne);
                        Heureocc.VALIDATE("Posting Date", DateDebut);
                        IF Employee.GET(NSalarie) THEN BEGIN
                            IF Employee."Employee type".AsInteger() = 1 THEN
                                Heureocc.VALIDATE("Days Number", JourS);
                        END;
                        IF JourS <> 0 THEN
                            Heureocc.INSERT;
                    END;
                    currXMLport.SKIP;
                    //>>WDC
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Date début mois"; DateDebut)
                {
                    ApplicationArea = all;
                }
            }
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        Nligne := 1000;
    end;

    trigger OnPostXmlPort()
    var
        lText001: TextConst ENU = 'Successfully imported',
                            FRA = 'Import terminé';
    begin
        MESSAGE(lText001);
    end;

    trigger OnPreXmlPort()
    var
        lText001: TextConst ENU = 'The start date must be filled',
                            FRA = ' La date début doit être renseignée.';
    begin
        IF DateDebut = 0D THEN
            ERROR(lText001);
    end;

    var
        "Employee No.": Record Employee;
        RecGHeurOccas: Record "WDC Occasional Hours";
        DateDebut: Date;
        Heureocc: Record "WDC Occasional Hours";
        JourF: Decimal;
        JourS: Decimal;
        Nligne: Integer;
        Employee: Record Employee;
        NombreJ: Decimal;
}

