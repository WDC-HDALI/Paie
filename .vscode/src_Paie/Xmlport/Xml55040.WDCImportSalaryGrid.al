xmlport 55040 "WDC Import Salary Grid"
{
    captionML = ENU = 'Import Salary Grid', FRA = 'Import Grille de Salaire';
    Direction = Import;
    FieldDelimiter = '"';
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Line grid"; "WDC Grid Line")
            {
                XmlName = 'ContactHeader';
                fieldelement(code; "Line grid".Code)
                {
                }
                fieldelement(College; "Line grid"."College")
                {
                }
                fieldelement(Echelle; "Line grid".Scale)
                {
                }
                fieldelement(Echelon; "Line grid".Echelon)
                {
                }
                fieldelement(SalBase; "Line grid"."Base Salary")
                {
                }
            }

            trigger OnAfterAssignVariable()
            begin
                IF NOT IsSecondRow THEN
                    currXMLport.SKIP
                ELSE
                    IsSecondRow := TRUE;
            end;
        }
    }


    trigger OnPostXmlPort()
    begin

        MESSAGE(Text001);
    end;

    var
        Text001: TextConst ENU = 'Import complete',
                           FRA = 'Import terminé';
        IsSecondRow: Boolean;
}

