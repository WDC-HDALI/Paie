xmlport 55047 "WDC Import Advances"
{
    captionML = ENU = 'Import Advances', FRA = 'Import avances';
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
                textelement(ABS)
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
                    EVALUATE(NombreJ, THJP);
                    EVALUATE(JourC, THJC);
                    EVALUATE(Avance, AVC);
                    CLEAR(HeureAbs);
                    IF (DateDebut <> 0D) AND (Avance <> 0) THEN BEGIN
                        Employee2.RESET;
                        Employee2.SETRANGE("No.", NSalarie);
                        Employee2.SETRANGE(Status, Employee2.Status::Active);
                        IF Employee2.FINDSET THEN BEGIN
                            LoanAdvance2.INIT;
                            HumanResSetup.GET;
                            HumanResSetup.TESTFIELD("Loan & Advance Nos.");
                            LoanAdvance2."No." := NoSeriesMgt.GetNextNo(HumanResSetup."Loan & Advance Nos.", 0D, TRUE);
                            LoanAdvance2No := LoanAdvance2."No.";
                            LoanAdvance2.INSERT(TRUE);
                            LoanAdvance2.GET(LoanAdvance2No);
                            LoanAdvance2.VALIDATE("Employee No.", NSalarie);
                            LoanAdvance2.VALIDATE("Document type", 'AVANCE');
                            LoanAdvance2.VALIDATE("Effective date", DateDebut);//WDC01
                            LoanAdvance2.VALIDATE(Amount, Avance);
                            LoanAdvance2.MODIFY;
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
        NombreJ: Decimal;
        JourC: Decimal;
        Avance: Decimal;
        LoanAdvance2: Record 55011;
        Employee2: Record Employee;
        NoSeriesMgt: Codeunit "No. Series";
        HumanResSetup: Record "Human Resources Setup";
        LoanAdvance2No: Code[20];
}

