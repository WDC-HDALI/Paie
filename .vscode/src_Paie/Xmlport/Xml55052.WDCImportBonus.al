xmlport 55052 "WDC Import Bonus"
{
    captionML = ENU = 'Import Bonus', FRA = 'Import Prime';
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
                textelement(THPRIME)
                {
                }
                textelement(THIRPP)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    //<<WDC
                    Nligne += 1;
                    EVALUATE(Prime, THPRIME);
                    EVALUATE(IRPP, THIRPP);
                    IF Employee.GET(NSalarie) THEN BEGIN
                        Employee."Brut prime" := Prime;
                        Employee.MODIFY;
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
    begin

        MESSAGE(Text001);
    end;

    var
        Text001: TextConst ENU = 'Import complete',
                           FRA = 'Import terminé';
        Nligne: Integer;
        Employee: Record Employee;
        Prime: Decimal;
        IRPP: Decimal;
}

