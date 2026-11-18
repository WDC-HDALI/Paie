xmlport 55044 "WDC Import RIB"
{
    captionML = ENU = 'Import RIB', FRA = 'Import RIB';
    Direction = Import;
    FieldDelimiter = 'None';
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("<employee bank account>"; 55008)
            {
                XmlName = 'ContactHeader';
                SourceTableView = SORTING("Employee No.", "Line No.", "Department Code", "Folder Code");
                textelement(NSalarie)
                {
                    Width = 20;
                }
                textelement(Code)
                {
                }
                textelement(RIB)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    //<<WDC
                    Nligne += 1;
                    CLEAR(Employee);
                    IF Employee.GET(NSalarie) THEN BEGIN
                        Employee."Default Bank Account Code" := Code;
                        Employee."Bank Account Number" := RIB;
                        Employee.MODIFY;
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
        Nligne: Integer;
        Employee: Record Employee;
}

