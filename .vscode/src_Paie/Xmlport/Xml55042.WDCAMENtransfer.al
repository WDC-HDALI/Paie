xmlport 55042 "WDC AMEN transfer"
{
    captionML = ENU = 'AMEN transfer', FRA = 'Virement AMEN';
    Direction = Export;
    //FieldSeparator = '<TAB>'; //HD Migration
    Format = FixedText;
    TableSeparator = '<NewLine>';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement("Salary Lines"; 55023)
            {
                XmlName = 'SalLine';
                SourceTableView = SORTING("No.", "Employee No.")
                                  WHERE("Payment Method Code" = filter('Virement'));
                textelement(codeenregistrementl)
                {
                    XmlName = 'CodeEnregistrementL';
                    Width = 2;
                }
                textelement(matricule)
                {
                    XmlName = 'MATRICULE';
                    Width = 8;
                }
                textelement(codebanque)
                {
                    XmlName = 'CodeBanque';
                    Width = 2;
                }
                textelement(filler1)
                {
                    XmlName = 'Filler1';
                    Width = 16;
                }
                textelement(nombeneficiaire)
                {
                    XmlName = 'NomBeneficiaire';
                    Width = 30;
                }
                textelement(numrib)
                {
                    XmlName = 'NumRIB';
                    Width = 20;
                }
                textelement(libelle)
                {
                    XmlName = 'LIBELLE';
                    Width = 17;
                }
                textelement(montantvirement)
                {
                    XmlName = 'MontantVirement';
                    Width = 10;
                }
                textelement(mois)
                {
                    XmlName = 'Mois';
                    Width = 2;

                    trigger OnBeforePassVariable()
                    var
                        MonthAux: Integer;
                    begin
                    end;
                }
                textelement("année")
                {
                    XmlName = 'Année';
                    Width = 4;
                }
                textelement(filler2)
                {
                    XmlName = 'Filler2';
                    Width = 17;
                }

                trigger OnAfterGetRecord()
                begin

                    CodeEnregistrementL := 'SH';
                    MATRICULE := "Salary Lines"."Employee No.";
                    CompleteParZero(MATRICULE, 8);
                    CodeBanque := COPYSTR("Salary Lines"."Salary RIB", 1, 2);
                    NumRIB := "Salary Lines"."Salary RIB";
                    NomBeneficiaire := COPYSTR("Salary Lines".Name, 1, 30);
                    NomBeneficiaire := PADSTR("Salary Lines".Name, 30, ' ');
                    MontantVirement := FORMAT(("Salary Lines"."Net salary cashed" * 1000) + 10000000000.0);
                    MontantVirement := DELCHR(MontantVirement, '=', DELCHR(MontantVirement, '=', '0123456789'));
                    MontantVirement := COPYSTR(MontantVirement, 2, 12);
                    LIBELLE := 'PAYE ' + UPPERCASE(FORMAT("Salary Lines".Month));
                    MonthAux := "Salary Lines".Month.AsInteger() + 1;
                    Mois := FORMAT(MonthAux);
                    CompleteParZero(Mois, 2);
                    Année := FORMAT("Salary Lines".Year);
                end;
            }
        }
    }
    var
        MonthAux: Integer;

    local procedure CompleteParZero(var InputTxt: Text; LongTxt: Integer)
    var
        LengthInput: Integer;
        i: Integer;
        ChAux: Text;
    begin
        LengthInput := LongTxt - STRLEN(InputTxt);
        ChAux := '';
        FOR i := 1 TO LengthInput DO
            ChAux += '0';
        InputTxt := ChAux + InputTxt;
    end;
}

