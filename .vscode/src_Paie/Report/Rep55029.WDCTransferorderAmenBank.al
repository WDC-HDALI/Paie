report 55029 "WDC Transfer order Amen Bank"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/OrdredevirementsAmenBanque.rdlc';
    captionML = ENU = 'Transfer order Amen Bank', FRA = 'Ordre virements Amen Banque';
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
            dataitem("Salary Header"; "WDC Salary Header")
            {
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
                dataitem("Salary Lines"; "WDC Salary Lines")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemTableView = SORTING("No.", "Employee No.")
                                        ORDER(Ascending)
                                        WHERE("Bank Account Code" = FILTER(<> ''),
                                              "Net salary cashed" = FILTER(<> 0),
                                              "Payment Method Code" = FILTER('Virement'));
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
                    column("Arrêté_le_présent_virement_à_la_somme_de______TextGMnt"; 'Arrêté le présent virement à la somme de : ' + TextGMnt)
                    {
                        //DecimalPlaces = 3 : 3;
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
                    dataitem("Employee Bank Account"; "WDC Employee Bank Account")
                    {
                        DataItemLink = "Employee No." = FIELD("Employee No."),
                                       Code = FIELD("Bank Account Code");
                        RequestFilterFields = "Employee No.", "Code", "Bank Branch No.";
                        column(STRSUBSTNO___1_2_3_4___Bank_Branch_No____Agency_Code___Bank_Account_No____RIB_Key__; STRSUBSTNO('%1%2%3%4', "Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key"))
                        {
                        }
                        column(Salary_Lines__Name; "Salary Lines".Name)
                        {
                        }
                        column(Salary_Lines___Net_salary_cashed_; "Salary Lines"."Net salary cashed")
                        {
                            DecimalPlaces = 3 : 3;
                        }
                        column(Employee_Bank_Account__Employee_No__; "Employee No.")
                        {
                        }
                        column(Employee_Bank_Account_Name; Name)
                        {
                        }
                        column(Employee_Bank_Account_Code; Code)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            total := total + "Salary Lines"."Net salary cashed";
                            TextGMnt := '';
                            Convert."Montant en texte"(TextGMnt, total);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        LFullName: Text[30];
                        LCurrentMonth: Integer;
                        LNetSalary: Text;
                    begin
                        //>>
                        IF ExportVirement THEN BEGIN
                            RecGEmploy.GET("Employee No.");
                            DetailLine := '07';                                                             // Code de l'enregistremeent
                            DetailLine := DetailLine + PADSTR('', 8 - STRLEN(RecGEmploy."No."), '0') + RecGEmploy."No.";        // Matricule employée
                            DetailLine := DetailLine + COPYSTR(RecGEmploy."Bank Account Number", 1, 2);                         // Code banque employée
                            DetailLine := DetailLine + PADSTR('', 16, ' ');                                   // Filler
                            LFullName := RecGEmploy."First Name" + ' ' + RecGEmploy."Last Name";
                            DetailLine := DetailLine + PADSTR(LFullName, 30, ' ');                           //Nom prénom employee
                            DetailLine := DetailLine + RecGEmploy."Bank Account Number";                                      // RIB Employée
                            DetailLine := DetailLine + PADSTR("Salary Header".Description, 17, ' ');         // Lib banque
                            DetailLine := DetailLine + PADSTR('', 10 - STRLEN(DecToString("Net salary cashed", 1)), '0') + DecToString("Net salary cashed", 1);  // Montant du virement
                            LCurrentMonth := "Salary Lines".Month.AsInteger() + 1;
                            IF LCurrentMonth > 12 THEN
                                LCurrentMonth := DATE2DMY("Salary Header"."Posting Date", 2);
                            IF LCurrentMonth <= 9 THEN
                                DetailLine := DetailLine + '0' + PADSTR(FORMAT(LCurrentMonth), 1)
                            ELSE
                                DetailLine := DetailLine + PADSTR(FORMAT(LCurrentMonth), 2);                   //Current Month
                            DetailLine := DetailLine + PADSTR(FORMAT("Salary Lines".Year), 4);              //Current Year
                            DetailLine := DetailLine + PADSTR('', 17, ' ');                                   // Filler
                            OutStream.WRITE(DetailLine);
                            NumOrdre := NumOrdre + 1;
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        NumOrdre := 1;

                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                total := 0;
                test := FALSE;

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

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Export Salaire"; ExportVirement)
                {
                    ApplicationArea = all;
                }
                field("UIB BANKING"; UibBanking)
                {
                    ApplicationArea = all;
                }
                field(Banque; ChoixBanque)
                {
                    TableRelation = "Bank Account";
                    ApplicationArea = all;
                }
            }
        }

    }


    trigger OnPostReport()
    begin
        IF ExportVirement THEN BEGIN
            TempBlob.CreateInStream(NewStream);
            ToFile := 'Virement.txt';
            ReturnValue := DOWNLOADFROMSTREAM(
                      NewStream,
                      'Save File to RoleTailored Client',
                      '',
                      'Text File *.txt| *.txt',
                      ToFile);
            MESSAGE(FORMAT(ToFile));
        END;
    end;

    trigger OnPreReport()
    var
        T1: Record "WDC Employee Bank Account";
    begin
        bcode := "Employee Bank Account".GETFILTER(Code);
        CLEAR(T1);
        T1.RESET;
        T1.SETRANGE(Code, bcode);
        IF T1.FINDFIRST AND (bcode <> '') THEN
            btext := T1.Name;

        comptebq.GET(ChoixBanque);
        IF ExportVirement THEN BEGIN
            TempBlob.CreateOutStream(OutStream);
        END;
    end;

    var
        total: Decimal;
        test: Boolean;
        text1: Text[300];
        Convert: Codeunit 55028;
        bcode: Code[50];
        btext: Text[30];
        comptebq: Record 270;
        Text3: Text[50];
        TextGMnt: Text[250];
        Ordre_de_virementCaptionLbl: Label 'Ordre de virement';
        MotifCaptionLbl: Label 'Motif';
        Destinataire____CaptionLbl: Label 'Destinataire  : ';
        Page__Caption_Control1102752005Lbl: Label 'Page :';
        Page__Caption_Control1102752007Lbl: Label 'Page :';
        MontantCaptionLbl: Label 'Montant';
        STRSUBSTNO___1_2_3_4___Bank_Branch_No____Agency_Code___Bank_Account_No____RIB_Key__CaptionLbl: Label 'Bank Account';
        "Nom___PrénomCaptionLbl": Label 'Nom & Prénom';
        MatriculeCaptionLbl: Label 'Matricule';
        Banque_AgenceCaptionLbl: Label 'Banque/Agence';
        ReportCaptionLbl: Label 'Report';
        Total_pageCaptionLbl: Label 'Total page';
        "Signature_autorisée_CaptionLbl": Label 'Signature autorisée ';
        "Montant_total_à_virerCaptionLbl": Label 'Montant total à virer';
        ChoixBanque: Code[20];
        NomBanque: Code[50];
        RibBanque: Code[20];
        TexteBanque: Code[60];
        ExportVirement: Boolean;
        DetailLine: Text[289];
        sepMil: Text[1];
        MntTot: Decimal;
        RecGEmploy: Record Employee;
        NumOrdre: Integer;
        UibBanking: Boolean;
        Name: Text[280];
        ReturnValue: Boolean;
        ToFile: Variant;
        NewStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;


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
        END;

        Str := DELCHR(Str, '=', sepMil);
        EXIT(Str);
    end;



}

