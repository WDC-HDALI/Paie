report 55013 "WDC Payment order"
{
    CaptionML = ENU = 'Payment order', FRA = 'Ordre de virements';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/Ordredevirements.rdlc';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = SORTING("Primary Key")
                                ORDER(Ascending);
            column(Fait_le_______FORMAT_WORKDATE_0_4_; 'Fait le : ' + FORMAT(WORKDATE, 0, 4))
            {
            }
            column(CurrReport_PAGENO; '')
            {
            }
            column(Page__Caption; 'Page')
            {
            }
            column(Company_Information_Primary_Key; "Primary Key")
            {
            }
            column(NomBanque; NomBanque)
            {
            }
            column(RibBanque; RibBanque)
            {
            }
            column(TexteBanque; TexteBanque)
            {
            }
            column(NomCompany; "Company Information".Name)
            {
            }
            column(AdresseCompany; "Company Information".Address)
            {
            }
            column("TélCompany"; "Company Information"."Phone No.")
            {
            }
            column(FaxCompany; "Company Information"."Fax No.")
            {
            }
            column(Registredecommerce; "Company Information"."Trade Register")
            {
            }
            column(MatriculeFiscal; "Company Information"."VAT Registration No.")
            {
            }
            column("NuméroPaie"; Description)
            {
            }
            dataitem("Salary Header"; "WDC Salary Header")
            {
                RequestFilterFields = "No.";
                column(Salary_Headers_Description; Description)
                {
                }
                column(comptebq_Name; comptebq.Name)
                {
                }
                column(Ordre_de_virementCaption; Ordre_de_virementCaptionLbl)
                {
                }
                column(MotifCaption; MotifCaptionLbl)
                {
                }
                column(Destinataire____Caption; Destinataire____CaptionLbl)
                {
                }
                column(Salary_Headers_No_; "No.")
                {
                }
                column(TotalCashed; NetCashed)
                {
                }
                column("Arrêté_le_présent_virement_à_la_somme_de______TextGMnt"; 'Arrêté le présent virement à la somme de : ' + TextGMnt)
                {
                }
                dataitem("Salary lines"; "WDC Salary Lines")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemTableView = SORTING("No.", "Employee No.")
                                        ORDER(Ascending)
                                        WHERE("Net salary cashed" = FILTER(<> 0),
                                              "Payment Method Code" = FILTER('Virement'),
                                              "Salary RIB" = FILTER(<> ''));
                    RequestFilterFields = "Employee No.";
                    column(text1; text1)
                    {
                    }
                    column(CurrReport_PAGENO_Control1102752000; '')
                    {
                    }
                    column(CurrReport_PAGENO_Control1102752006; '')
                    {
                    }
                    column(Salary_Lines_Description; Description)
                    {
                    }
                    column(total; total)
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(total_Control1102752009; total)
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(total_Control1102752015; total)
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column(Page__Caption_Control1102752005; Page__Caption_Control1102752005Lbl)
                    {
                    }
                    column(Page__Caption_Control1102752007; Page__Caption_Control1102752007Lbl)
                    {
                    }
                    column(Salary_Lines_DescriptionCaption; FIELDCAPTION(Description))
                    {
                    }
                    column(MontantCaption; MontantCaptionLbl)
                    {
                    }
                    column(STRSUBSTNO___1_2_3_4___Bank_Branch_No____Agency_Code___Bank_Account_No____RIB_Key__Caption; STRSUBSTNO___1_2_3_4___Bank_Branch_No____Agency_Code___Bank_Account_No____RIB_Key__CaptionLbl)
                    {
                    }
                    column("Nom___PrénomCaption"; Nom___PrénomCaptionLbl)
                    {
                    }
                    column(MatriculeCaption; MatriculeCaptionLbl)
                    {
                    }
                    column(Banque_AgenceCaption; Banque_AgenceCaptionLbl)
                    {
                    }
                    column(ReportCaption; ReportCaptionLbl)
                    {
                    }
                    column(Total_pageCaption; Total_pageCaptionLbl)
                    {
                    }
                    column("Signature_autorisée_Caption"; Signature_autorisée_CaptionLbl)
                    {
                    }
                    column("Montant_total_à_virerCaption"; Montant_total_à_virerCaptionLbl)
                    {
                    }
                    column(Salary_Lines_No_; "No.")
                    {
                    }
                    column(Salary_Lines_Employee; "Employee No.")
                    {
                    }
                    column(Salary_Lines_Bank_Account_Code; "Bank Account Code")
                    {
                    }
                    column(RIBsalar; "Salary RIB")
                    {
                    }
                    column(Salary_Name; Name)
                    {
                    }
                    column(Salary_NetCashed; "Net salary cashed")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //>>
                        IF ExportVirement THEN BEGIN
                            RecGEmploy.GET("Employee No.");
                            DetailLine := '02';                                                             // Code de l'enregistremeent
                            DetailLine := DetailLine + COPYSTR(RecGEmploy."Bank Account Number", 1, 2);                         // Code Banque Employee
                            DetailLine := DetailLine + comptebq."Bank Account No.";                         // RIB Société
                            DetailLine := DetailLine + RecGEmploy."Bank Account Number";                                      // RIB Employee
                            DetailLine := DetailLine + PADSTR('', 20, ' ');                                   // Ref envoie

                            DetailLine := DetailLine + PADSTR("Salary Header".Description, 50);                    // Lib                          50       64-113
                            DetailLine := DetailLine + IntLen(DecToString("Net salary cashed", 1), 10);               // Montant du virement          10       114-123
                            DetailLine := DetailLine + PADSTR('', 2, ' ');                                    // Motif de rejet               2        124-125
                            DetailLine := DetailLine + PADSTR('', 34, '0');                                   // Zone inutilisée              34       126-160
                            OutStream.WRITE(DetailLine);
                            NumOrdre := NumOrdre + 1;
                        END;
                        //<<
                    end;

                    trigger OnPreDataItem()
                    begin
                        //>>
                        NumOrdre := 1;
                        comptebq.GET(ChoixBanque);
                        IF ExportVirement THEN BEGIN
                            DetailLine := '09';                                                             // Code de l'enregistremeent
                            DetailLine := DetailLine + '12';                                                // Code Banque
                            DetailLine := DetailLine + comptebq."Bank Account No.";                           // RIB Société
                            DetailLine := DetailLine + FORMAT(TODAY, 0, '<Year4><Month,2><Day,2>');           // Date d'échéance
                            DetailLine := DetailLine + PADSTR('', 20, ' ');                                   // Ref envoie
                            DetailLine := DetailLine + PADSTR('', 15, ' ');                                   // Code du registre
                            DetailLine := DetailLine + IntLen(FORMAT("Salary Lines".COUNT), 10);           // Nbr Ligne
                            CalcTot("Salary Header"."No.");
                            DetailLine := DetailLine + IntLen(DecToString(MntTot, 1), 12);                     // Total Vir
                            DetailLine := DetailLine + PADSTR('', 20, ' ');                                   // Contrepartie
                            DetailLine := DetailLine + PADSTR('', 51, '0');                                   // Zone inutilisée
                            OutStream.WRITE(DetailLine);
                        END;
                        //<<
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(RecL);
                    RecL.SETRANGE("No.", "No.");
                    RecL.SETFILTER("Net salary cashed", '<>%1', 0);
                    RecL.SETFILTER("Payment Method Code", 'Virement');
                    RecL.SETFILTER("Salary RIB", '<>%1', '');
                    IF RecL.FINDSET THEN
                        REPEAT
                            NetCashed += RecL."Net salary cashed";
                        UNTIL RecL.NEXT = 0;
                    TextGMnt := '';
                    Convert."Montant en texte"(TextGMnt, NetCashed);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                total := 0;
                test := FALSE;
                CLEAR(Description);
                IF RecH.GET("Salary Header".GETFILTER("No.")) THEN
                    Description := RecH.Description;
                IF comptebq.GET(ChoixBanque) THEN BEGIN
                    Text3 := comptebq."Bank Account No.";
                    TexteBanque := comptebq.Name + ' ' + comptebq.Address;
                    text1 := STRSUBSTNO('Par le débit de notre compte N°  %1  ouvert chez '
                        + 'vous, veuillez virer aux crédits des comptes courants des bénéficiaires ci-dessous '
                        + 'désignés les montants conformément aux détails suivants :', Text3);
                END;
            end;
        }
    }
    trigger OnPreReport()
    var
        lText001: TextConst ENU = 'You have to choose a payroll journal',
                            FRA = 'Vous devez choisir un journal de paie';
    begin
        comptebq.GET(ChoixBanque);
        IF ExportVirement THEN
            IF CONFIRM(TextConf, FALSE) THEN BEGIN
                TempBlob.CreateOutStream(OutStream);
            END
            ELSE
                ExportVirement := FALSE;
        IF "Salary Header".GETFILTER("No.") = '' THEN
            ERROR(lText001);
    end;

    trigger OnPostReport()
    begin
        IF ExportVirement THEN BEGIN
            TempBlob.CreateInStream(NewStream);
            ToFile := 'Fdetvir.txt';
            ReturnValue := DOWNLOADFROMSTREAM(
                      NewStream,
                      'Save File to RoleTailored Client',
                      '',
                      'Text File *.txt| *.txt',
                      ToFile);
            MESSAGE(FORMAT(ToFile));
        END;
    end;

    var
        total: Decimal;
        test: Boolean;
        text1: Text[300];
        Convert: Codeunit 55028;
        comptebq: Record 270;
        Text3: Text[50];
        TextGMnt: Text[250];
        Ordre_de_virementCaptionLbl: TextConst ENU = 'Transfer Order',
                                               FRA = 'Ordre de virement';
        MotifCaptionLbl: TextConst ENU = 'Reason',
                                   FRA = 'Motif';
        Destinataire____CaptionLbl: TextConst ENU = 'Beneficiary :',
                                              FRA = 'Destinataire :';
        Page__Caption_Control1102752005Lbl: TextConst ENU = 'Page :',
                                                      FRA = 'Page :';
        Page__Caption_Control1102752007Lbl: TextConst ENU = 'Page :',
                                                      FRA = 'Page :';
        MontantCaptionLbl: TextConst ENU = 'Amount',
                                     FRA = 'Montant';
        STRSUBSTNO___1_2_3_4___Bank_Branch_No____Agency_Code___Bank_Account_No____RIB_Key__CaptionLbl: TextConst ENU = 'Bank Account', FRA = 'Compte bancaire';
        "Nom___PrénomCaptionLbl": TextConst ENU = 'Name & Surname',
                                            FRA = 'Nom & prénom';
        MatriculeCaptionLbl: TextConst ENU = 'Employee ID',
                                       FRA = 'Matricule';
        Banque_AgenceCaptionLbl: TextConst ENU = 'Bank/Agency',
                                           FRA = 'Banque/Agence';
        ReportCaptionLbl: TextConst ENU = 'Report',
                                    FRA = 'Rapport';
        Total_pageCaptionLbl: TextConst ENU = 'Total page',
                                        FRA = 'Total page';
        "Signature_autorisée_CaptionLbl": TextConst ENU = 'Authorized signature',
                                                    FRA = 'Signature autorisée';
        "Montant_total_à_virerCaptionLbl": TextConst ENU = 'Total amount to transfer',
                                                     FRA = 'Montant total à virer';
        ChoixBanque: Code[20];
        NomBanque: Code[50];
        RibBanque: Code[20];
        TexteBanque: Code[60];
        ExportVirement: Boolean;
        DetailLine: Text[289];
        sepMil: Text[1];
        MntTot: Decimal;
        TextConf: TextConst ENU = 'Have you inserted a diskette into drive A:',
                            FRA = 'Avez-vous inséré une disquette dans le lecteur A:';
        RecGEmploy: Record Employee;
        NumOrdre: Integer;
        RecH: Record "WDC Employee's days off Entry";
        Description: Text;
        NetCashed: Decimal;
        RecL: Record "WDC Salary Lines";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        NewStream: InStream;
        ToFile: Variant;
        ReturnValue: Boolean;


    procedure DecToString(dec: Decimal; type: Integer): Text[250]
    var
        Str: Text[250];
    begin
        IF type = 0 THEN            // Conversion integer
         BEGIN
            Str := FORMAT(dec, 0, '<Integer>');
        END
        ELSE                        // Other
         BEGIN
            dec := dec * 1000;
            Str := FORMAT(dec, 0, '<Integer>');
            //Str := INSSTR(Str,'V',STRLEN(Str)-(3-1));
        END;

        Str := DELCHR(Str, '=', sepMil);
        EXIT(Str);
    end;


    procedure IntLen(IntText: Text[60]; Len: Integer): Text[60]
    begin
        REPEAT
            IF STRLEN(IntText) < Len THEN
                IntText := '0' + IntText;
        UNTIL STRLEN(IntText) = Len;
        EXIT(IntText);
    end;


    procedure CalcTot(PaieNo: Code[20])
    var
        RecLignePaie: Record "WDC Salary Lines";
    begin
        MntTot := 0;
        RecLignePaie.RESET;
        RecLignePaie.SETRANGE("No.", PaieNo);
        RecLignePaie.SETRANGE("Payment Method Code", 'Virement');
        IF RecLignePaie.FINDSET THEN BEGIN
            REPEAT
                MntTot += RecLignePaie."Net salary cashed";
            UNTIL RecLignePaie.NEXT = 0;
        END;
    end;
}

