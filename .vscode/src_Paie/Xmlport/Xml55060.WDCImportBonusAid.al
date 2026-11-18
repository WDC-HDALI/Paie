xmlport 55060 "WDC Import Bonus Aid"
{
    captionML = ENU = 'Import Bonus Aid', FRA = 'Import primes Aid';
    Direction = Import;
    FieldDelimiter = 'None';
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Default Indemnities"; "WDC Default Indemnities")
            {
                XmlName = 'Defaultindem';
                SourceTableView = SORTING("Indemnity Code", "Emplymt. Contract Code", "Indemnity Type")
                                  ORDER(Ascending);
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
                    EVALUATE(PAID, PAIDIDHA);
                    CLEAR(Defaultindem);
                    Defaultindem.SETRANGE("Emplymt. Contract Code", NSalarie);
                    Defaultindem.SETRANGE("Indemnity Code", 'P.AID');
                    IF Defaultindem.FINDSET THEN
                        Defaultindem.DELETE
                    ELSE BEGIN
                        Defaultindem.INIT;
                        Defaultindem."Emplymt. Contract Code" := NSalarie;
                        Defaultindem.VALIDATE("Indemnity Code", 'P.AID');
                        Defaultindem.VALIDATE("Default amount", PAID);
                        IF PAID <> 0 THEN
                            Defaultindem.INSERT;
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
        PAID: Decimal;
        Defaultindem: Record "WDC Default Indemnities";
}

