xmlport 55046 "WDC Import Absences"
{
    captionML = ENU = 'Import Absences', FRA = 'Import absences';
    Direction = Import;
    FieldDelimiter = 'None';
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("<employee absence>"; 55008)
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
                textelement(ABSENCE)
                {
                }
                textelement(AVC)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    //<<WDC
                    Nligne += 1;
                    EVALUATE(JourF, THJF);
                    EVALUATE(JourS, ABSENCE);
                    EVALUATE(NombreJ, THJP);
                    EVALUATE(JourC, THJC);
                    CLEAR(HeureAbs);
                    HeureAbs.SETRANGE("Entry No.", 999999);
                    IF NOT HeureAbs.FINDSET THEN BEGIN
                        HeureAbs.INIT;
                        HeureAbs.VALIDATE("Entry No.", Nligne);
                        HeureAbs.VALIDATE("Employee No.", NSalarie);
                        HeureAbs.VALIDATE("From Date", DateDebut);
                        HeureAbs.VALIDATE("Cause of Absence Code", 'ABNJ');
                        HeureAbs.VALIDATE("Absence Reason", HeureAbs."Absence Reason"::"Irregular Absence");
                        HeureAbs.VALIDATE("Line type", 3);
                        IF Employee.GET(NSalarie) THEN
                            HeureAbs.VALIDATE(Quantity, JourS);
                        IF JourS > 0 THEN
                            HeureAbs.INSERT;
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
        DateDebut: Date;
        HeureAbs: Record "Employee Absence";
        JourF: Decimal;
        JourS: Decimal;
        Nligne: Integer;
        Employee: Record Employee;
        NombreJ: Decimal;
        JourC: Decimal;
}

