xmlport 55037 "WDC Import Overtime Hours"
{
    captionML = ENU = 'Import Overtime Hours', FRA = 'Import Heures Supplémentaires';
    Direction = Import;
    FieldDelimiter = 'None';
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("<heures sup. m>"; 55008)
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
                    EVALUATE(HeureS25, HS25);
                    EVALUATE(HeureS50, HS50);
                    CLEAR(HeureSupp);
                    HeureSupp.SETRANGE("Employee No.", NSalarie);
                    IF NOT HeureSupp.FINDSET THEN BEGIN
                        IF Employee.GET(NSalarie) THEN BEGIN
                            IF Employee."Employee type".AsInteger() = 0 THEN BEGIN
                                IF HeureS25 <> 0 THEN BEGIN
                                    HeureSupp.INIT;
                                    HeureSupp.VALIDATE("Employee No.", NSalarie);
                                    HeureSupp.VALIDATE("Line No.", Nligne);
                                    HeureSupp.VALIDATE("Posting Date", DateDebut);
                                    HeureSupp."Overtime Rate" := 0.25;
                                    HeureSupp.VALIDATE("Hours Number", HeureS25);
                                    IF (HeureS25 <> 0) OR (HeureS50 <> 0) THEN
                                        HeureSupp.INSERT;
                                END;
                                IF HeureS50 <> 0 THEN BEGIN
                                    Nligne += 1;
                                    HeureSupp.INIT;
                                    HeureSupp.VALIDATE("Employee No.", NSalarie);
                                    HeureSupp.VALIDATE("Line No.", Nligne);
                                    HeureSupp.VALIDATE("Posting Date", DateDebut);
                                    HeureSupp."Overtime Rate" := 0.5;
                                    HeureSupp."Overtime Rate" := 0.5;
                                    HeureSupp.VALIDATE("Hours Number", HeureS50);
                                    IF (HeureS25 <> 0) OR (HeureS50 <> 0) THEN
                                        HeureSupp.INSERT;
                                END;
                            END;
                        END;
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
        "Employee No.": Record Employee;
        RecGHeurOccas: Record "WDC Occasional Hours";
        DateDebut: Date;
        HeureSupp: Record "WDC Monthly Overtime Hours";
        JourF: Decimal;
        JourS: Decimal;
        Nligne: Integer;
        Employee: Record Employee;
        NombreJ: Decimal;
        HeureS25: Decimal;
        HeureS50: Decimal;
}

