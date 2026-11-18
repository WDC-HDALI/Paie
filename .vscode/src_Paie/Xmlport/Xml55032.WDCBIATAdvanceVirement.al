xmlport 55032 "WDC BIAT Advance Virement"
{
    captionML = ENU = 'WDC BIAT Advance Virement', FRA = 'Virement BIAT Avance';
    Direction = Export;
    ////FieldSeparator = '<TAB>'; //HD Migration //HD Migration
    Format = FixedText;
    TableSeparator = '<NewLine>';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement("Company Information"; "Company Information")
            {
                XmlName = 'Loanheader';
                SourceTableView = SORTING("Primary Key")
                                  ORDER(Ascending);
                textelement(sens)
                {
                    XmlName = 'Sens';
                    Width = 1;
                }
                textelement(codevaleur)
                {
                    XmlName = 'CodeValeur';
                    Width = 2;
                }
                textelement(rib)
                {
                    XmlName = 'RIB';
                    Width = 20;
                }
                textelement(dateech)
                {
                    XmlName = 'DateEch';
                    Width = 8;
                }
                textelement(numlot)
                {
                    XmlName = 'NumLot';
                    Width = 4;
                }
                textelement(codeenreg)
                {
                    XmlName = 'CodeEnreg';
                    Width = 2;
                }
                textelement(codedevise)
                {
                    XmlName = 'CodeDevise';
                    Width = 3;
                }
                textelement(Rang)
                {
                    Width = 5;
                }
                textelement(montantglobal)
                {
                    XmlName = 'MontantGlobal';
                    Width = 12;
                }
                textelement(nombrevirements)
                {
                    XmlName = 'NombreVirements';
                    Width = 10;
                }
                textelement(raisonsocial)
                {
                    XmlName = 'RaisonSocial';
                    Width = 30;
                }
                textelement(referenceenvoi)
                {
                    XmlName = 'ReferenceEnvoi';
                    Width = 20;
                }
                textelement(datecreation)
                {
                    XmlName = 'DateCreation';
                    Width = 8;
                }
                textelement(espace)
                {
                    XmlName = 'Espace';
                    Width = 155;
                }

                trigger OnAfterGetRecord()
                begin
                    //num:='1';
                    Sens := '1';
                    CodeValeur := '10';
                    RIB := '08500000205000927305'; // A paramétrer
                    DateECH := FORMAT(WORKDATE, 8, '<Year4><Month,2><Day,2>');
                    NumLot := '0001';
                    CodeEnreg := '11';
                    CodeDevise := '788';
                    Rang := '00000';
                    CLEAR(AvanceLine);
                    AvanceLine.SETRANGE(Type, AvanceLine.Type::Advance);
                    AvanceLine.SETRANGE("Effective date", DateEffet);
                    IF AvanceLine.FINDFIRST THEN BEGIN
                        countLines := AvanceLine.COUNT;
                        REPEAT
                            CLEAR(NumRIB);
                            IF Lemp.GET(AvanceLine."Employee No.") THEN
                                NumRIB := Lemp."Bank Account Number";
                            IF NumRIB <> '' THEN
                                countAmount += AvanceLine.Amount;
                        UNTIL (AvanceLine.NEXT = 0);
                    END;
                    MontantGlobal := FORMAT((countAmount * 1000) + 1000000000000.0);
                    MontantGlobal := DELCHR(MontantGlobal, '=', DELCHR(MontantGlobal, '=', '0123456789'));
                    MontantGlobal := COPYSTR(MontantGlobal, 2, 12);
                    NombreVirements := FORMAT(countLines + 10000000000.0);
                    NombreVirements := DELCHR(NombreVirements, '=', DELCHR(NombreVirements, '=', '0123456789'));
                    NombreVirements := COPYSTR(NombreVirements, 2, 10);
                    RaisonSocial := 'STE KBE ELEKTROTECHNIK';
                    ReferenceEnvoi := 'Virement salaire';
                    DateCreation := FORMAT(WORKDATE, 8, '<Year4><Month,2><Day,2>');
                    Espace := '';
                end;

                trigger OnPreXmlItem()
                begin
                    IF RecHRSetup.GET THEN;
                end;
            }
            tableelement("Loan & Advance Header"; "WDC Loan & Advance Header")
            {
                XmlName = 'LoanLine';
                SourceTableView = SORTING("No.")
                                  ORDER(Ascending)
                                  WHERE(Type = CONST(Advance));
                textelement(lsens)
                {
                    XmlName = 'LSens';
                    Width = 1;
                }
                textelement(lcodevaleur)
                {
                    XmlName = 'LCodeValeur';
                    Width = 2;
                }
                textelement(lrib)
                {
                    XmlName = 'LRIB';
                    Width = 20;
                }
                textelement(ldateech)
                {
                    XmlName = 'LDateEch';
                    Width = 8;
                }
                textelement(lnumlot)
                {
                    XmlName = 'LNumLot';
                    Width = 4;
                }
                textelement(lcodeenreg)
                {
                    XmlName = 'LCodeEnreg';
                    Width = 2;
                }
                textelement(lcodedevise)
                {
                    XmlName = 'LCodeDevise';
                    Width = 3;
                }
                textelement(lrang)
                {
                    XmlName = 'LRang';
                    Width = 5;
                }
                textelement(montantvirement)
                {
                    XmlName = 'MontantVirement';
                    Width = 12;
                }
                textelement(numord)
                {
                    XmlName = 'NUMORD';
                    Width = 7;
                }
                textelement(numrib)
                {
                    XmlName = 'NumRIB';
                    Width = 20;
                }
                textelement(nombeneficiaire)
                {
                    XmlName = 'NomBeneficiaire';
                    Width = 30;
                }
                textelement(mat)
                {
                    XmlName = 'MAT';
                    Width = 20;
                }
                textelement(espzero)
                {
                    XmlName = 'ESPZERO';
                    Width = 3;
                }
                textelement(lmotif)
                {
                    XmlName = 'LMOTIF';
                    Width = 30;
                }
                textelement(lespace)
                {
                    XmlName = 'LESPACE';
                    Width = 113;
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(Emp);
                    IF Emp.GET("Loan & Advance Header"."Employee No.") THEN;
                    IF Emp."Payment Method Code" = 'Virement' THEN BEGIN
                        LSens := '1';
                        LCodeValeur := '10';
                        LRIB := '08500000205000927305';
                        LDateECH := FORMAT(WORKDATE, 8, '<Year4><Month,2><Day,2>');
                        LNumLot := '0001';
                        LCodeEnreg := '21';
                        LCodeDevise := '788';
                        LRang := '00000';
                        CLEAR(NumRIB);
                        IF Lemp.GET("Loan & Advance Header"."Employee No.") THEN
                            NumRIB := Lemp."Bank Account Number";
                        i := i + 1;
                        NUMORD := FORMAT(i + 10000000);
                        NUMORD := COPYSTR(NUMORD, 2, 7);
                        RecBanqAccountL.GET(Emp."No.", Emp."Default Bank Account Code");
                        NomBeneficiaire := COPYSTR(Emp."First Name" + ' ' + Emp."Last Name", 1, 30);
                        NomBeneficiaire := PADSTR(Emp."First Name" + ' ' + Emp."Last Name", 30, ' ');
                        MontantVirement := FORMAT(("Loan & Advance Header".Amount * 1000) + 1000000000000.0);
                        MontantVirement := DELCHR(MontantVirement, '=', DELCHR(MontantVirement, '=', '0123456789'));
                        MontantVirement := COPYSTR(MontantVirement, 2, 12);
                        MAT := Emp."No.";
                        ESPZERO := '000';
                        LMOTIF := 'Virement salaire';
                        LESPACE := '';
                    END;
                end;

                trigger OnPreXmlItem()
                begin
                    i := 0;
                    "Loan & Advance Header".SETRANGE(Type, "Loan & Advance Header".Type::Advance);
                    "Loan & Advance Header".SETRANGE("Effective date", DateEffet);
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
                field("Date d'effet avance"; DateEffet)
                {
                    CaptionML = ENU = 'Advance Effective Date', FRA = 'Date d''effet avance';
                    ApplicationArea = all;
                }
            }
        }

    }

    trigger OnPreXmlPort()
    begin
        IF DateEffet = 0D THEN
            ERROR(Err001);
    end;

    var
        RecHRSetup: Record "Human Resources Setup";
        RecBanqAccountE: Record 270;
        RecBanqAccountL: Record "WDC Employee Bank Account";
        i: Integer;
        countLines: Integer;
        countAmount: Decimal;
        num: Code[20];
        Text001: TextConst ENU = 'salaries transfer %1',
                           FRA = 'Virement Salaires %1';
        RecSalaryLines: Record "WDC Salary lines";
        Lemp: Record Employee;
        AvanceLine: Record "WDC Loan & Advance";
        Emp: Record Employee;
        DateEffet: Date;
        Err001: TextConst ENU = 'The effective date cannot be empty',
                           FRA = 'La date d''effet ne peut être vide';
}

