report 55018 "WDC CDI Work Contract"
{
    CaptionML = ENU = 'CDI Work Contract', FRA = 'Contrat de travail CDI';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/ContratdetravailCDI.rdlc';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = SORTING("Primary Key");
            column(Name_CompanyInfo; Name)
            {
            }
            column(StockCapital_CompanyInfo; "Executive Director 2")
            {
            }
            column(TradeRegister_CompanyInfo; "Executive Director 2")
            {
            }
            column(Address_CompanyInfo; Address + ' ' + "Address 2")
            {
            }
            column(DG_HRSetup; HRSetup."Directeur général")
            {
            }
            column(Picture_CompanyInfo; Picture)
            {
            }
            column(Text032_Caption; STRSUBSTNO(Text032, "Executive Director 2", "VAT Registration No."))
            {
            }
            column(Text033_Caption; STRSUBSTNO(Text033, Address + ' ' + "Address 2"))
            {
            }
            column(Text034; Text034)
            {
            }
            column(Text035; Text035)
            {
            }
            column(Text036; Text036)
            {
            }
            column(Text073_Caption; STRSUBSTNO(Text073, City))
            {
            }
            column(Text074_Caption; STRSUBSTNO(Text074, FORMAT(WORKDATE)))
            {
            }
            dataitem(Employee; Employee)
            {
                RequestFilterFields = "No.";
                column(TxtMmeMsgerand; TxtMmeMsgerand)
                {
                }
                column(TxtReprentepar; TxtReprentepar)
                {
                }
                column(TxtMmeMs; TxtMmeMs)
                {
                }
                column(DG; HRSetup."Directeur général")
                {
                }
                column(MaritalStatus_Employee; MaritalStatus)
                {
                }
                column(Nomsalarie; Employee.FullName)
                {
                }
                column(FullAddress_Employee; Address)
                {
                }
                column(Nationalite_Employee; Nationality)
                {
                }
                column(CIN_Employee; "CIN No.")
                {
                }
                column(CIN_DATE; "CIN Issued on")
                {
                }
                column(JobTitle_Employee; Title)
                {
                }
                column(EmploymentDate_Employee; "Employment Date")
                {
                }
                column(SalaireBrut_Employee; "Gross Salary" + "Basis salary")
                {
                }
                column(MontToutLettre; MontToutLettre)
                {
                }
                column(TxtMoispreavis; TxtMoispreavis)
                {
                }
                column(DatDebContart; "Contract Start Date")
                {
                }
                column(DatFinContart; "Termination Date")
                {
                }
                column(FinPeriodeEssai; FinPeriodeEssai)
                {
                }
                column(DateContrat; 'Fait à Tunis le :' + FORMAT(TODAY))
                {
                }
                column(Text001; Text001)
                {
                }
                column(Text002; Text002)
                {
                }
                column(Text003; Text003)
                {
                }
                column(Text004; Text004)
                {
                }
                column(Text005; Text005)
                {
                }
                column(Text006; Text006)
                {
                }
                column(Text007; Text007)
                {
                }
                column(Text008; Text008)
                {
                }
                column(Text009; Text009)
                {
                }
                column(Text010; Text010)
                {
                }
                column(Text011; Text011)
                {
                }
                column(Text012; Text012)
                {
                }
                column(Text013; Text013)
                {
                }
                column(Text014; Text014)
                {
                }
                column(Text015; Text015)
                {
                }
                column(Text016; Text016)
                {
                }
                column(Text017; Text017)
                {
                }
                column(Text018; Text018)
                {
                }
                column(Text019; Text019)
                {
                }
                column(Text020; Text020)
                {
                }
                column(Text021; Text021)
                {
                }
                column(Text022; Text022)
                {
                }
                column(Text023; Text023)
                {
                }
                column(Text024; Text024)
                {
                }
                column(Text025; Text025)
                {
                }
                column(Text026; Text026)
                {
                }
                column(Text027; Text027)
                {
                }
                column(Text028; Text028)
                {
                }
                column(Text029; STRSUBSTNO(Text029, NomSoc))
                {
                }
                column(Text030; Text030)
                {
                }
                column(Text031; Text031)
                {
                }
                column(Text032; Text032)
                {
                }
                column(Text033; Text033)
                {
                }
                column(Text037; Text037)
                {
                }
                column(Text038; Text038)
                {
                }
                column(Text039; Text039)
                {
                }
                column(Text040; Text040)
                {
                }
                column(Text042; Text042)
                {
                }
                column(Text043; Text043)
                {
                }
                column(Text044; Text044)
                {
                }
                column(Text045; Text045)
                {
                }
                column(Text046; Text046)
                {
                }
                column(Text047; Text047)
                {
                }
                column(Text048; Text048)
                {
                }
                column(Text049; Text049)
                {
                }
                column(Text050; Text050)
                {
                }
                column(Text051; Text051)
                {
                }
                column(Text052; Text052)
                {
                }
                column(Text053; Text053)
                {
                }
                column(Text054; Text054)
                {
                }
                column(Text055; Text055)
                {
                }
                column(Text056; Text056)
                {
                }
                column(Text057; Text057)
                {
                }
                column(Text058; Text058)
                {
                }
                column(Text059; Text059)
                {
                }
                column(Text060; Text060)
                {
                }
                column(Text061; Text061)
                {
                }
                column(Text062; Text062)
                {
                }
                column(Text063; Text063)
                {
                }
                column(Text064; Text064)
                {
                }
                column(Text065; Text065)
                {
                }
                column(Text066; Text066)
                {
                }
                column(Text067; Text067)
                {
                }
                column(Text068; Text068)
                {
                }
                column(Text069; Text069)
                {
                }
                column(Text070; Text070)
                {
                }
                column(Text071; Text071)
                {
                }
                column(Text072; Text072)
                {
                }
                column(VilleSoc; VilleSoc)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //CALCFIELDS("Job Title", "Gross Salary");
                    MaritalStatus := ' ';

                    IF Gender = Gender::Male THEN
                        MaritalStatus := Text044
                    ELSE
                        CASE "Family Situation A" OF
                            "Family Situation A"::Single:
                                MaritalStatus := Text042;
                            "Family Situation A"::Married:
                                MaritalStatus := Text043;
                            "Family Situation A"::Divorced:
                                MaritalStatus := Text043;
                            "Family Situation A"::Widowed:
                                MaritalStatus := Text043;
                        END;
                    FinPeriodeEssai := CALCDATE('<+1M>', "Employment Date");

                    IF Employee.Gender = Employee.Gender::Female THEN TxtMmeMs := 'Mme.' ELSE IF Employee.Gender = Employee.Gender::Male THEN TxtMmeMs := 'Mr';
                    MontToutLettre := '';
                    Convert."Montant en texte"(MontToutLettre, "Gross Salary" + "Basis salary");
                    CASE Class OF
                        Class::Execution:
                            TxtMoispreavis := '6 Mois';
                        Class::Mastery:
                            TxtMoispreavis := '9 Mois';
                        Class::Executive:
                            TxtMoispreavis := '12 Mois';
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    HRSetup.RESET;
                    IF Employee.GET(HRSetup."Matricule Directeur Général") THEN BEGIN

                        IF Employee.Gender = Employee.Gender::Female THEN TxtMmeMsgerand := 'Mme.' ELSE IF Employee.Gender = Employee.Gender::Male THEN TxtMmeMsgerand := 'Mr';
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS(Picture);
                VilleSoc := City;
                NomSoc := Name;
            end;
        }
    }


    trigger OnInitReport()
    begin
        HRSetup.GET;
    end;

    var
        HRSetup: Record "Human Resources Setup";
        Text001: Label 'CONTRAT DE TRAVAIL A DUREE INDETERMINEE';
        Text002: Label 'ENTRE LES SOUSSIGNES: ';
        Text003: Label 'D''UNE PART,';
        Text004: Label 'ET';
        Text005: Label 'D''AUTRE PART,';
        Text006: Label 'IL A ETE CONVENU CE QUI SUIT:';
        Text007: Label 'ARTICLE I:';
        Text008: Label 'EMPLOI OCCUPE';
        Text009: Label 'ARTICLE II:';
        Text010: Label 'DEFINITION DES MISSIONS';
        Text011: Label 'ARTICLE III:';
        Text012: Label 'DUREE';
        Text013: Label 'ARTICLE IV:';
        Text014: Label 'PERIODE D''ESSAI';
        Text015: Label 'ARTICLE V:';
        Text016: Label 'LIEU DE TRAVAIL';
        Text017: Label 'ARTICLE VI:';
        Text018: Label 'REMUNERATION';
        Text019: Label 'ARTICLE VII:';
        Text020: Label 'CONGES PAYES';
        Text021: Label 'ARTICLE VIII:';
        Text022: Label 'RUPTURE';
        Text023: Label 'ARTICLE IX:';
        Text024: Label 'NON CONCURRENCE';
        Text025: Label 'ARTICLE X:';
        Text026: Label 'SECRET PROFESSIONNEL';
        Text027: Label 'Fait en double exemplaire';
        Text028: Label 'Lu et approuvé';
        Text029: Label 'La société %1 ';
        Text030: Label 'Représentée aux fins des présents par le PDG';
        Text031: Label 'La société %1, société anonyme ';
        Text032: Label 'au capital de %1 DH, sous numéro de Registre de Commerce %2';
        Text033: Label 'Ayant le siège social situé à : %1';
        Text034: Label 'Représentée par Monsieur: ';
        Text035: Label ' agissant en qualité de: ';
        Text036: Label 'Président Directeur Général de la société.';
        Text037: Label '(Ex-S.V.Z Maroc S.A) ';
        Text038: Label 'demeurant à: ';
        Text039: Label 'de nationalité: ';
        Text040: Label 'C.I.N. N°: ';
        MaritalStatus: Text[100];
        Text042: Label 'Ms.';
        Text043: Label 'Mrs.';
        Text044: Label 'Mr.';
        Text045: Label ' est engagé par la société Messem Maroc S.A., ';
        Text046: Label 'en qualité de';
        Text047: Label 'aura pour mission : ';
        Text048: Label 'déclare avoir pris connaissance du règlement intérieur, applicable(s) à l''entreprise.';
        Text049: Label 'Les parties s''engagent, chacune en ce qui la concerne, à respecter les stipulations.';
        Text050: Label 'est engagé à partir du ';
        Text051: Label ', pour une durée indéterminée.';
        Text052: Label 'Le contrat ne deviendra définitif qu''à l''issue d''une période d''essai d''un mois, au cours de laquelle chacune des parties pourra rompre le contrat sans indemnité.';
        Text053: Label 'La période d''essai prendra fin le ';
        Text054: Label 'Le lieu de travail est situé à l''usine ';
        Text055: Label ' s''engage à effectuer les déplacements en relation avec sa mission dans la société Messem sans avoir le droit à une indemnité supplémentaire.';
        Text056: Label 'Le salaire de ';
        Text057: Label ' est fixé au montant Brut mensuel de ';
        Text058: Label ' Le salaire lui sera transmis par virement bancaire à la fin de chaque mois civil.';
        Text059: Label 'Toutefois ';
        Text060: Label 'aura droit à une indemnité pour frais de transport d''un montant de ';
        Text061: Label 'dirhams durant toute l''année.';
        Text062: Label 'Les congés payés seront attribués suivant les prescriptions de la législation en vigueur.';
        Text063: Label 'Il est convenu que ';
        Text064: Label 'aura droit chaque année d''un mois de congés payés, cette période étant déterminée par accord entre la société et ';
        Text065: Label 'pour tenir compte des nécessités du service.';
        Text066: Label 'En cas de rupture du présent contrat, le préavis réciproque sera de 2 mois.Cette rupture devra être notifiée à l''autre partie par une lettre recommandée ou avec accusé de réception.';
        Text067: Label 'En cas de faute lourde, l''entreprise pourra mettre fin au contrat sans préavis.La notification de la rupture audit contrat devra cependant se faire par écrit avec indication du motif de cette rupture.';
        Text068: Label 'Le salarié s''interdira, pendant 2 ans, tout acte pouvant concurrencer son ancien employeur, en cas de rupture du contrat de travail pour quelque cause que ce soit.';
        Text069: Label 'En contrepartie, pendant la période fixée ci-dessus, ';
        Text070: Label ' aura tout droit à une indeminté mensuelle égale à 10% du dernier salaire.Cette indemnité ne lui sera plus due en cas de violation de l''obligation de non concurrence, sans préjudice des dommages et intérêts qui pourraient être réclaméscontre l''intéressé.';
        Text071: Label ' est lié(e) par une obligation de discrétion.';
        Text072: Label 'Il/Ellle s''engage à ne divulger à personne, ni directement ni indirectement, ni pendant la durée de ses fonctions dans la société, ni à l''expiration de celles-ci aucune information en relation avec l''activité de la société Messem.';
        FinPeriodeEssai: Date;
        Text073: Label 'A %1';
        Text074: Label 'Le %1';
        VilleSoc: Text[100];
        NomSoc: Text[100];
        TxtMmeMs: Code[20];
        TxtReprentepar: Label '  représenté par ';
        Convert: Codeunit 55028;
        MontToutLettre: Text[80];
        TxtMoispreavis: Text[15];
        TxtMmeMsgerand: Text[5];
}

