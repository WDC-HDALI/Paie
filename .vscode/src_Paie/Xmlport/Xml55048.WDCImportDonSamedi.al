xmlport 55048 "WDC Import Don Samedi"
{
    Direction = Import;
    FieldDelimiter = 'None';
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Employee Absence"; 55008)
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
                textelement(ABS)
                {
                }
                textelement(AVC)
                {
                }
                textelement(DON)
                {
                }
                textelement(RDON)
                {
                }
                textelement(DFITR)
                {
                }
                textelement(DKEBIR)
                {
                }
                textelement(DSCO)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    //<<WDC
                    Nligne += 1;
                    EVALUATE(JourF, THJF);
                    EVALUATE(NombreJ, THJP);
                    EVALUATE(JourC, THJC);
                    EVALUATE(Avance, AVC);
                    EVALUATE(DONSAM, DON);
                    EVALUATE(RETDON, RDON);
                    //>>NEW
                    EVALUATE(DONFITR, DFITR);
                    EVALUATE(DONKEBIR, DKEBIR);
                    EVALUATE(DONSCO, DSCO);
                    //<<NEW
                    IF (DONSAM <> 0) THEN BEGIN
                        CLEAR(DefaultIndem);
                        DefaultIndem.SETRANGE("Emplymt. Contract Code", NSalarie);
                        DefaultIndem.SETRANGE("Indemnity Code", 'D.SAM');
                        IF DefaultIndem.FINDSET THEN
                            DefaultIndem.DELETE;
                        Employee2.RESET;
                        Employee2.SETRANGE("No.", NSalarie);
                        Employee2.SETRANGE(Status, Employee2.Status::Active);
                        IF Employee2.FINDSET THEN BEGIN
                            DefaultIndem.INIT;
                            DefaultIndem."Emplymt. Contract Code" := NSalarie;
                            DefaultIndem.VALIDATE("Indemnity Code", 'D.SAM');
                            DefaultIndem.VALIDATE("Default amount", DONSAM);
                            DefaultIndem.INSERT(TRUE);
                        END;
                    END;
                    IF (RETDON <> 0) THEN BEGIN
                        CLEAR(DefaultSoc);
                        DefaultSoc.SETRANGE("Emplymt. Contract Code", NSalarie);
                        DefaultSoc.SETRANGE("Social Contribution Code", 'DSAM');
                        IF DefaultSoc.FINDSET THEN
                            DefaultSoc.DELETE;
                        Employee2.RESET;
                        Employee2.SETRANGE("No.", NSalarie);
                        Employee2.SETRANGE(Status, Employee2.Status::Active);
                        IF Employee2.FINDSET THEN BEGIN
                            DefaultSoc.INIT;
                            DefaultSoc."Emplymt. Contract Code" := NSalarie;
                            DefaultSoc.VALIDATE("Social Contribution Code", 'DSAM');
                            DefaultSoc.VALIDATE("Employee's part", RETDON);
                            DefaultSoc.VALIDATE("Employee's part", RETDON);
                            DefaultSoc.INSERT(TRUE);
                        END;
                    END;
                    //>>DEBUT DON AID EL FITR
                    HumanResSetup.GET;
                    IF (DONFITR <> 0) THEN BEGIN
                        CLEAR(DefaultIndem);
                        DefaultIndem.SETRANGE("Emplymt. Contract Code", NSalarie);
                        DefaultIndem.SETRANGE("Indemnity Code", HumanResSetup."Indem Aid Fitr");
                        IF DefaultIndem.FINDSET THEN
                            DefaultIndem.DELETE;
                        Employee2.RESET;
                        Employee2.SETRANGE("No.", NSalarie);
                        Employee2.SETRANGE(Status, Employee2.Status::Active);
                        IF Employee2.FINDSET THEN BEGIN
                            DefaultIndem.INIT;
                            DefaultIndem."Emplymt. Contract Code" := NSalarie;
                            DefaultIndem.VALIDATE("Indemnity Code", HumanResSetup."Indem Aid Fitr");
                            DefaultIndem.VALIDATE("Default amount", DONFITR);
                            DefaultIndem.INSERT(TRUE);
                        END;
                    END;
                    //>>DEBUT DON AID FITR
                    //>>DEBUT DON AID KEBIR
                    HumanResSetup.GET;
                    IF (DONKEBIR <> 0) THEN BEGIN
                        CLEAR(DefaultIndem);
                        DefaultIndem.SETRANGE("Emplymt. Contract Code", NSalarie);
                        DefaultIndem.SETRANGE("Indemnity Code", HumanResSetup."Indem Aid Idhha");
                        IF DefaultIndem.FINDSET THEN
                            DefaultIndem.DELETE;
                        Employee2.RESET;
                        Employee2.SETRANGE("No.", NSalarie);
                        Employee2.SETRANGE(Status, Employee2.Status::Active);
                        IF Employee2.FINDSET THEN BEGIN
                            DefaultIndem.INIT;
                            DefaultIndem."Emplymt. Contract Code" := NSalarie;
                            DefaultIndem.VALIDATE("Indemnity Code", HumanResSetup."Indem Aid Idhha");
                            DefaultIndem.VALIDATE("Default amount", DONKEBIR);
                            DefaultIndem.INSERT(TRUE);
                        END;
                    END;
                    //>>DEBUT DON AID KEBIR
                    //>>DEBUT DON SCOLAIRE
                    HumanResSetup.GET;
                    IF (DONSCO <> 0) THEN BEGIN
                        CLEAR(DefaultIndem);
                        DefaultIndem.SETRANGE("Emplymt. Contract Code", NSalarie);
                        DefaultIndem.SETRANGE("Indemnity Code", HumanResSetup."Indem Don Rent");
                        IF DefaultIndem.FINDSET THEN
                            DefaultIndem.DELETE;
                        Employee2.RESET;
                        Employee2.SETRANGE("No.", NSalarie);
                        Employee2.SETRANGE(Status, Employee2.Status::Active);
                        IF Employee2.FINDSET THEN BEGIN
                            DefaultIndem.INIT;
                            DefaultIndem."Emplymt. Contract Code" := NSalarie;
                            DefaultIndem.VALIDATE("Indemnity Code", HumanResSetup."Indem Don Rent");
                            DefaultIndem.VALIDATE("Default amount", DONSCO);
                            DefaultIndem.INSERT(TRUE);
                        END;
                    END;
                    //>>DEBUT DON SCOLAIRE
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
    Begin
        MESSAGE(lText001);
    end;

    trigger OnPreXmlPort()
    var
        lText001: TextConst ENU = 'The start date must be filled', FRA = 'La date début doit être renseignée.';
    begin
        IF DateDebut = 0D THEN
            ERROR(lText001);
    end;

    var
        DateDebut: Date;
        JourF: Decimal;
        Nligne: Integer;
        NombreJ: Decimal;
        JourC: Decimal;
        Avance: Decimal;
        Employee2: Record 5200;
        HumanResSetup: Record 5218;
        DONSAM: Decimal;
        DefaultIndem: Record 55004;
        RETDON: Decimal;
        DefaultSoc: Record 55005;
        DONFITR: Decimal;
        DONKEBIR: Decimal;
        DONSCO: Decimal;
}

