xmlport 55053 "WDC Import IRPP Bonus"
{
    captionML = ENU = 'Import IRPP Bonus', FRA = 'Import IRPP prime';
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
                    CLEAR(SalaryLine);
                    SalaryLine.SETRANGE("Employee No.", NSalarie);
                    IF SalaryLine.FINDSET THEN BEGIN
                        IF SalaryLine."Non Taxable Soc. Contrib." = 0 THEN BEGIN
                            SalaryLine.VALIDATE("Taxe (Month)", 0);
                            SalaryLine.VALIDATE("CSS Tax", 0);
                            SalaryLine.MODIFY;
                        END
                        ELSE BEGIN
                            SalaryLine.VALIDATE("Taxe (Month)", IRPP);
                            SalaryLine.VALIDATE("CSS Tax", 0);
                            SalaryLine.MODIFY;
                        END;
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
        Prime: Decimal;
        IRPP: Decimal;
        SalaryLine: Record "WDC Salary Lines";
}

