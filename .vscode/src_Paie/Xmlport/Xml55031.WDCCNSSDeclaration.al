xmlport 55031 "WDC CNSS Declaration"
{
    Direction = Export;
    ////FieldSeparator = '<TAB>'; //HD Migration//HD Migration
    Format = FixedText;
    captionML = ENU = 'CNSS Declaration', FRA = 'Déclaration CNSS';
    schema
    {
        textelement(Root)
        {
            tableelement(Employee; Employee)
            {
                RequestFilterFields = "No.";
                XmlName = 'ContactHeader';
                SourceTableView = SORTING("No.")
                                  ORDER(Ascending);
                textelement(numsociete)
                {
                    XmlName = 'NMatEmplyeur';
                    Width = 10;
                }
                textelement(codcnss)
                {
                    XmlName = 'CodeExploit';
                    Width = 4;
                }
                textelement(trim)
                {
                    XmlName = 'Trimestre';
                    Width = 1;
                }
                textelement("annéem")
                {
                    XmlName = 'Année';
                    Width = 4;
                }
                textelement(pages)
                {
                    XmlName = 'Pges';
                    Width = 3;
                }
                textelement(lig)
                {
                    XmlName = 'lignes';
                    Width = 2;
                }
                textelement(numsecsal)
                {
                    XmlName = 'NAssuré';
                    Width = 10;
                }
                textelement(nomp)
                {
                    XmlName = 'NomAssure';
                    Width = 60;
                }
                textelement(ncin)
                {
                    XmlName = 'NCIN';
                    Width = 8;
                }
                textelement(mntfinal)
                {
                    XmlName = 'dc';
                    Width = 10;
                }
                textelement(filler)
                {
                    XmlName = 'ZReserve';
                    Width = 10;
                }

                trigger OnAfterGetRecord()
                begin
                    //----------------------
                    NumSociete := infosoc."Social Security No.";
                    NumsecSal := '';
                    AnnéeM := '';
                    Montantcum := '';
                    NomP := '';
                    Pages := '';
                    Lig := '';
                    Filler := PADSTR(Filler, 10, '0');
                    codcnss := '0000';
                    NumsecSal := DELCHR(Employee."Social Security No.", '=', '-');
                    NCIN := Employee."CIN No.";
                    BEGIN
                        Total := 0;
                        LigneSalaireEnreg.RESET;
                        LigneSalaireEnreg.SETRANGE("Employee No.", Employee."No.");
                        LigneSalaireEnreg.SETRANGE(LigneSalaireEnreg.Year, Année);
                        LigneSalaireEnreg.SETFILTER("Non Taxable Soc. Contrib.", '<>%1', 0); //WDC
                        IF Trimestre = 0 THEN
                            LigneSalaireEnreg.SETRANGE("Posting Date", DMY2DATE(1, 1, Année), DMY2DATE(31, 3, Année))
                        ELSE IF Trimestre = 1 THEN
                            LigneSalaireEnreg.SETRANGE("Posting Date", DMY2DATE(1, 4, Année), DMY2DATE(30, 6, Année))
                        ELSE IF Trimestre = 2 THEN
                            LigneSalaireEnreg.SETRANGE("Posting Date", DMY2DATE(1, 7, Année), DMY2DATE(30, 9, Année))
                        ELSE
                            LigneSalaireEnreg.SETRANGE("Posting Date", DMY2DATE(1, 10, Année), DMY2DATE(31, 12, Année));

                        LigneSalaireEnreg.SETFILTER("No.", PaieFrom."No.");
                        IF LigneSalaireEnreg.FINDFIRST THEN
                            REPEAT
                                Total := Total + LigneSalaireEnreg."Gross Salary"
                            UNTIL LigneSalaireEnreg.NEXT = 0;

                        IF (Total > 0)
                         THEN BEGIN
                            IF EmplContract.GET(Employee."Emplymt. Contract Code") THEN BEGIN
                                DefaultSoc.RESET;
                                DefaultSoc.SETRANGE("Emplymt. Contract Code", EmplContract.Code);
                                DefaultSoc.SETRANGE("Social Contribution Code", RecSocialContribution.Code);
                                IF NOT DefaultSoc.FINDFIRST
                                  THEN BEGIN
                                    currXMLport.SKIP;
                                END;
                            END;
                            IF Employee."Social Security No." = ''
                              THEN BEGIN
                                MESSAGE(lText001);
                                MESSAGE(lText002, Employee."No." + ' - ' + Employee.FullName);
                                NumsecSal := '0000000000';
                            END
                            ELSE
                                IF STRLEN(DELCHR(Employee."Social Security No.", '=', '-')) > 10 THEN
                                    MESSAGE(lText003, Employee."No." + ' - ' + Employee.FullName)
                                ELSE
                                    NumsecSal := DELCHR(Employee."Social Security No.", '=', '-');
                            AnnéeM := FORMAT(Année);

                            IF Employee."Last Name" <> '' THEN
                                NomP := Employee."Last Name" + ' ' + Employee."First Name" ELSE
                                NomP := Employee."First Name";
                            //***********************************************************************************************************************
                            Total := ROUND(Total, 0.001);
                            Montantcum := FORMAT(Total * 1000 + 1000000000);   //100000000
                            NonNum := FORMAT('');
                            FOR k := 1 TO 8 DO BEGIN
                                IF ((Montantcum[k] <> '0') AND (Montantcum[k] <> '1') AND (Montantcum[k] <> '2') AND (Montantcum[k] <> '3') AND
                                    (Montantcum[k] <> '4') AND (Montantcum[k] <> '5') AND (Montantcum[k] <> '6') AND (Montantcum[k] <> '7') AND
                                    (Montantcum[k] <> '8') AND (Montantcum[k] <> '9')
                                   ) THEN
                                    NonNum := FORMAT(Montantcum[k]);
                            END;
                            Montantcum := DELCHR(Montantcum, '=', NonNum);
                            MntFinal := '';

                            MntFinal := COPYSTR(Montantcum, 2, 10); //WDC  10 REMPLACE 8
                            IF STRLEN(COPYSTR(Montantcum, 2, 10)) = 9 THEN
                                MntFinal := '0' + MntFinal
                            ELSE
                                MntFinal := '00' + MntFinal;
                            //***********************************************************************************************************************
                            // N° ligne : 12 lignes / PAGEN
                            IF (i < 10) THEN Lig := '0' + FORMAT(i);
                            IF ((i MOD 12) + 1) < 10
                               THEN
                                Lig := '0' + FORMAT((i MOD 12) + 1)
                            ELSE
                                Lig := FORMAT((i MOD 12) + 1);
                            // N° PAGEN
                            IF ((i DIV 12) + 1) < 10
                              THEN
                                Pages := '00' + FORMAT((i DIV 12) + 1)
                            ELSE BEGIN
                                IF ((i DIV 12) + 1) < 100
                                  THEN
                                    Pages := '0' + FORMAT((i DIV 12) + 1)
                                ELSE
                                    Pages := FORMAT((i DIV 12) + 1);
                            END;
                            i := i + 1;
                        END
                        ELSE
                            currXMLport.SKIP
                    END;
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
                field(Filtre; PaieFrom."No.")
                {
                    ApplicationArea = all;
                }

                field("Année"; Année)
                {
                    ApplicationArea = all;
                }
                field(Trimestre; Trimestre)
                {
                    ApplicationArea = all;
                }
                field("Code CNSS"; RecSocialContribution.Code)
                {
                    TableRelation = "WDC Social Contribution";
                    ApplicationArea = all;
                }
            }
        }

    }

    trigger OnInitXmlPort()
    begin
        i := 0;
        infosoc.GET;
    end;

    trigger OnPreXmlPort()
    begin
        Trim := FORMAT(Trimestre + 1);
        AnnéeM := FORMAT(Année);
    end;

    var
        lText001: TextConst ENU = 'Warning: The generated file is invalid!',
                            FRA = 'Attention : Le fichier généré n''est pas valide !';
        lText002: TextConst ENU = 'Employee %1 does not have a social security registration number!',
                            FRA = 'Le salarié %1 n''a pas de N° affiliation sécurité sociale !';
        lText003: TextConst ENU = 'Check the employee''s social security affiliation number %1',
                            FRA = 'Vérifiez le N° affiliation sécurité sociale du salarié %1';

        Montantcum: Code[13];
        LigneSalaireEnreg: Record "WDC Salary Lines";
        Trimestre: Option "1er","2ème","3ème","4ème";
        "Année": Integer;
        Total: Decimal;
        i: Integer;
        infosoc: Record 79;
        EmplContract: Record "Employment Contract";
        DefaultSoc: Record "WDC Default Soc. Contribution";
        PaieFrom: Record 55024;
        NonNum: Text[1];
        k: Integer;
        RecSocialContribution: Record "WDC Social Contribution";
}

