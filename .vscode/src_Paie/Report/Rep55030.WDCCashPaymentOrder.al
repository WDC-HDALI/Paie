report 55030 "WDC Cash Payment Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/Ordredepaiementespèces.rdlc';
    captionML = ENU = 'Cash Payment Order', FRA = 'Ordre paiement espèces';
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
            column(MatriculeFiscal; "Company Information"."APE Code")
            {
            }
            dataitem(DataItem9180; 55022)
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
                                        WHERE("Net salary cashed" = FILTER(<> 0),
                                              "Payment Method Code" = FILTER('ESPECE'));
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
                    column(NomEmployee; Nomemployee)
                    {
                    }
                    column(NetSalary; "Net salary cashed")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF RecEmployee.GET("Employee No.") THEN
                            Nomemployee := RecEmployee."First Name" + '  ' + RecEmployee."Last Name"
                        ELSE
                            Nomemployee := '';
                        total := total + "Salary Lines"."Net salary cashed";
                        TextGMnt := '';

                        //Convert."Montant en texte"(TextGMnt,total);  //WDC.SH
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                total := 0;
                test := FALSE;
            end;
        }
    }


    trigger OnPreReport()
    var
        T1: Record "WDC Employee Bank Account";
    begin

        CLEAR(T1);
        T1.RESET;
        T1.SETRANGE(Code, bcode);
        IF T1.FINDFIRST AND (bcode <> '') THEN
            btext := T1.Name;
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
        Page__CaptionLbl: Label 'Page :';
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
        Nomemployee: Code[70];
        RecEmployee: Record Employee;
}

