xmlport 55034 "WDC Posted ATB Transfer"
{
    captionML = ENU = 'Posted ATB Transfer', FRA = 'Virement ATB Enregistré';
    Direction = Export;
    ////FieldSeparator = '<TAB>'; //HD Migration //HD Migration
    Format = FixedText;
    TableSeparator = '<NewLine>';

    schema
    {
        textelement(Root)
        {
            tableelement("Rec. Salary Headers"; 55024)
            {
                XmlName = 'SalHeader';
                SourceTableView = SORTING("No.");
                textelement(codeenregistremente)
                {
                    XmlName = 'CodeEnre';
                    Width = 2;
                }
                textelement(codesiegee)
                {
                    XmlName = 'CodeSieg';
                    Width = 2;
                }
                textelement(comptegeneral)
                {
                    XmlName = 'CompteGene';
                    Width = 4;
                }
                textelement(compteparticulier)
                {
                    XmlName = 'CompteParti';
                    Width = 4;
                }
                textelement(cle)
                {
                    XmlName = 'Cle';
                    Width = 2;
                }
                textelement(libellevirement)
                {
                    XmlName = 'LibelleVirement';
                    Width = 70;
                }
                textelement(montantglobal)
                {
                    XmlName = 'MontantGlobal';
                    Width = 12;
                }
                textelement(nombrevirements)
                {
                    XmlName = 'NombreVirements';
                    Width = 3;
                }

                trigger OnAfterGetRecord()
                begin

                    num := "Rec. Salary Headers"."No.";
                    CodeEnregistrementE := '01';
                    IF RecBanqAccountE.GET(RecHRSetup."Transfer ATB Bank") THEN;
                    CodeSiegeE := COPYSTR(RecBanqAccountE."Bank Account No.", 2, 2);
                    CompteGeneral := COPYSTR(RecBanqAccountE."Bank Account No.", 4, 4);
                    CompteParticulier := COPYSTR(RecBanqAccountE."Bank Account No.", 8, 4);
                    Cle := COPYSTR(RecBanqAccountE."Bank Account No.", 12, 2);
                    LibelleVirement := STRSUBSTNO(Text001, DELCHR(FORMAT(WORKDATE), '=', '/'));
                    LibelleVirement := PADSTR(LibelleVirement, 70, ' ');

                    RecSalaryLines.SETFILTER("No.", "Rec. Salary Headers"."No.");
                    RecSalaryLines.SETFILTER("Bank Account Code", '<>%1', '');
                    IF RecSalaryLines.FINDFIRST THEN BEGIN
                        countLines := RecSalaryLines.COUNT;
                        REPEAT
                            countAmount += RecSalaryLines."Net salary cashed";
                        UNTIL (RecSalaryLines.NEXT = 0);
                    END;
                    MontantGlobal := FORMAT((countAmount * 1000) + 1000000000000.0);
                    MontantGlobal := DELCHR(MontantGlobal, '=', DELCHR(MontantGlobal, '=', '0123456789'));
                    MontantGlobal := COPYSTR(MontantGlobal, 2, 12);
                    NombreVirements := FORMAT(countLines + 1000);
                    NombreVirements := DELCHR(NombreVirements, '=', DELCHR(NombreVirements, '=', '0123456789'));
                    NombreVirements := COPYSTR(NombreVirements, 2, 3);
                end;

                trigger OnPreXmlItem()
                begin
                    IF RecHRSetup.GET THEN;
                end;
            }
            tableelement("Rec. Salary Lines"; 55025)
            {
                XmlName = 'SalLine';
                SourceTableView = SORTING("No.", "Employee No.")
                                  WHERE("Bank Account Code" = FILTER(<> ''));
                textelement(codeenregistrementl)
                {
                    XmlName = 'CodeEnregistrementL';
                    Width = 2;
                }
                textelement(numord)
                {
                    XmlName = 'NUMORD';
                    Width = 3;
                }
                textelement(codebanque)
                {
                    XmlName = 'CodeBanque';
                    Width = 3;
                }
                textelement(codesiegel)
                {
                    XmlName = 'CodeSiegeL';
                    Width = 2;
                }
                textelement(codeptt)
                {
                    XmlName = 'CodePTT';
                    Width = 4;
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
                textelement(montantvirement)
                {
                    XmlName = 'MontantVirement';
                    Width = 12;
                }
                textelement(virtel)
                {
                    XmlName = 'VIRTEL';
                    Width = 1;
                }

                trigger OnAfterGetRecord()
                begin

                    CodeEnregistrementL := '02';
                    i := i + 1;
                    NUMORD := FORMAT(i + 1000);
                    NUMORD := COPYSTR(NUMORD, 2, 3);
                    RecBanqAccountL.GET("Rec. Salary Lines"."Employee No.", "Rec. Salary Lines"."Bank Account Code");
                    CodeBanque := '0' + RecBanqAccountL."Bank Branch No.";
                    CodeSiegeL := PADSTR('', 2, ' ');
                    CodePTT := '1000';
                    NumRIB := RecBanqAccountL."Bank Branch No." + RecBanqAccountL."Agency Code" + RecBanqAccountL."Bank Account No." + RecBanqAccountL."RIB Key";
                    NomBeneficiaire := COPYSTR("Rec. Salary Lines".Name, 1, 30);
                    NomBeneficiaire := PADSTR("Rec. Salary Lines".Name, 30, ' ');
                    MontantVirement := FORMAT(("Rec. Salary Lines"."Net salary cashed" * 1000) + 1000000000000.0);
                    MontantVirement := DELCHR(MontantVirement, '=', DELCHR(MontantVirement, '=', '0123456789'));
                    MontantVirement := COPYSTR(MontantVirement, 2, 12);
                    VIRTEL := 'N';

                end;

                trigger OnPreXmlItem()
                begin

                    i := 0;
                    "Rec. Salary Lines".SETFILTER("No.", num);
                end;
            }
        }
    }


    var
        RecHRSetup: Record "Human Resources Setup";
        RecBanqAccountE: Record 270;
        RecBanqAccountL: Record "WDC Employee Bank Account";
        i: Integer;
        RecSalaryLines: Record "WDC Posted Salary Lines";
        countLines: Integer;
        countAmount: Decimal;
        num: Code[20];
        Text001: TextConst ENU = 'salaries transfer %1',
                           FRA = 'Virement Salaires %1';
}

