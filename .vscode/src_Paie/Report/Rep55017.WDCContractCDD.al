report 55017 "WDC Contract CDD"
{
    CaptionML = ENU = 'Contrat CDD', FRA = 'Contrat CDD';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/ContratCDD.rdlc';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = SORTING("Primary Key");
            column(Name_CompanyInfo; COMPANYNAME)
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
            column(Text001; Text001)
            {
            }
            column(Text002; Text002)
            {
            }
            dataitem(DataItem1000000001; 5200)
            {
                RequestFilterFields = "No.";
                column(FullName_Employee; FullName)
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
                column(JobTitle_Employee; Title)
                {
                }
                column(EmploymentDate_Employee; "Employment Date")
                {
                }
                column(SalaireBase_Employee; "Basis salary")
                {
                }
                column(MaritalStatus; MaritalStatus)
                {
                }
                column(First_Name; "First Name")
                {
                }
                column(Last_Name; "Last Name")
                {
                }
                column("CIN_Délivrée_le"; "CIN Issued on")
                {
                }
                column(Birth_Date; "Birth Date")
                {
                }
                column(Birth_place_A; "Birth place A")
                {
                }
                column(Nationalite; Nationality)
                {
                }
                column(Family_Situation_A; "Family Situation A")
                {
                }
                column(Loaded_childs; "Loaded childs")
                {
                }
                column(Social_Security_No; "Social Security No.")
                {
                }
                column(Categorie_soc; "Social Category")
                {
                }
                column(Echelon; Echelon)
                {
                }
                column(Employment_Date; "Employment Date")
                {
                }
                column(debut_contrat; "Contract Start Date")
                {
                }
                column(fin_contrat; "Termination Date")
                {
                }
                column(Salaire_brute; FORMAT("Gross Salary" + "Basis salary", 0, 1))
                {
                }
                column(MaritalStatusDG; MaritalStatusDG)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //CALCFIELDS("Job Title");
                    MaritalStatus := ' ';

                    IF Gender = Gender::Male THEN
                        MaritalStatus := Text014
                    ELSE
                        CASE "Family Situation A" OF
                            "Family Situation A"::Single:
                                MaritalStatus := Text016;
                            "Family Situation A"::Married:
                                MaritalStatus := Text015;
                            "Family Situation A"::Divorced:
                                MaritalStatus := Text015;
                            "Family Situation A"::Widowed:
                                MaritalStatus := Text015;
                        END;
                    "Rec_Employment Contract".RESET;
                    "Rec_Employment Contract".SETRANGE(Code, "Emplymt. Contract Code");
                    IF "Rec_Employment Contract".FINDFIRST THEN BEGIN
                        RecRegimesofwork.RESET;
                        RecRegimesofwork.SETRANGE(Code, "Rec_Employment Contract"."Work Regime");
                        IF RecRegimesofwork.FINDFIRST THEN;
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
        DG.RESET;
        IF DG.GET(HRSetup."Matricule Directeur Général") THEN BEGIN
            IF DG.Gender = DG.Gender::Male THEN
                MaritalStatusDG := Text014
            ELSE
                CASE DG."Family Situation A" OF
                    DG."Family Situation A"::Single:
                        MaritalStatusDG := Text016;
                    DG."Family Situation A"::Married:
                        MaritalStatusDG := Text015;
                    DG."Family Situation A"::Divorced:
                        MaritalStatusDG := Text015;
                    DG."Family Situation A"::Widowed:
                        MaritalStatusDG := Text015;
                END;
        END;
    end;

    var
        HRSetup: Record "Human Resources Setup";
        Text001: Label 'CONTRAT DE TRAVAIL A DUREE LIMITEE POUR UNE ACTIVITE SAISONNIERE';
        Text002: Label 'ENTRE LES SOUSSIGNES: ';
        Text003: Label 'D''UNE PART : ';
        Text004: Label 'D''AUTRE PART :  ';
        MaritalStatus: Text[100];
        FinPeriodeEssai: Date;
        VilleSoc: Text[100];
        NomSoc: Text[100];
        Text005: Label 'PREFACE : ';
        Text006: Label 'ARTICLE 1 :';
        Text007: Label 'ARTICLE 2 :';
        Text008: Label 'ARTICLE 3 :';
        Text009: Label 'ARTICLE 4 :';
        Text010: Label 'ARTICLE 5 :';
        Text011: Label 'ARTICLE 6 :';
        Text012: Label 'ARTICLE 7 :';
        Text013: Label 'ARTICLE 8 :';
        Text014: Label 'Mr : ';
        Text015: Label 'Mme :';
        Text016: Label 'Melle : ';
        Text017: Label ' de surgélation et exportation de la fraise représentée par ';
        Text018: Label ', agissant en qualité de Président Directeur Général. Sise à ';
        Text019: Label ', de nationalité : ';
        Text020: Label ' CIN n° : ';
        Text021: Label ', habitant à ';
        Text022: Label 'en qualité de Salarié.';
        Text023: Label 'Compte tenu de la nature saisonnière de l''activité illimitée de la sociétébdurant la période de travail en relation avec la saison de la cueillette de la fraise et en conformité avec les exigences de l''article 16 du code de travail, il a été convenu entre les 2 parties ce qui suit: ';
        Text024: Label 'La seconde partie travaille chez la première partie en tant que salarié saisonnier selon un contrat spécifique de durée limitée selon les exigences du travail associé à l''activité agricole mentionnée précédemment.';
        Text025: Label 'La 2ème partie est soumise à une période d''essai d''une durée limitée à 15 jours d''occupation réelle, et chacune des parties peut rompre volontairement le contrat de travail sans préavis ni indemnité.';
        Text026: Label 'Il a été convenu entre les 2 parties, la limitation de la durée de contrat du : ';
        Text027: Label ' jusqu''à la fin de la saison et qui se termine progressivement en fonction des besoins de la société, de la main d''ouevre associée à la production abondante comme on peut suspendre le travail en cas d''urgence en dehors du contrôle de la ère partie en raison des conditions climatiques inhabituelles.';
        Text028: Label 'La 2ème partie ne peut réclamer aucune indemnité au cours de cet arrêt de travail mais peut remédier les heures de travail perdues en raison de cet arrêt (dans la mesure permise par la loi).';
        Text029: Label 'La 2ème partie reçoit un salaire précis limité à ';
        Text030: Label 'La 2ème partie s''engage à respecter le code des règlements intérieurs de la société, le respect des conditions d''hygiène et de sécurité et les consignes la 1ère partie dans ce sens.Il s''engage aussi à respecter les heures de travail limitées spécifiées en cours.';
        Text031: Label 'Etant donné la nature périssable des matières premières de la société, la 2ème partie s''engage à ne recourir à la cessation et à l''absentéisme brusque de travail pour une raison quelconque qu''après l''avis d''administration, faute de quoi elle délivre une pièce justificative avec un délai de moins de 24 h sauf cas de force majeure ou événement imprévu.';
        Text032: Label 'La 2ème partie s''engage à informer la 1ère partie de tout changement de situation familiale ou personnelle et il s''engage aussi à l''informer de tout changement de son adresse ou de son lieu de résidence.';
        Text033: Label 'La 2ème partie s''engage à se présenter dans son poste de travail au sein de la société et respecter les horaires de travail prévus.';
        Text034: Label 'Chaque partie recevra une copie faite en 2 exemplaires après la ratification de la signature.';
        Text035: Label 'Signé';
        Text036: Label 'SIGNATURE 1ERE PARTIE';
        Text037: Label 'SIGNATURE 2EME PARTIE';
        Text038: Label 'SOCIETE MESSEM';
        Text039: Label 'LE SALARIE';
        Text040: Label '  LA SOCIETE ';
        Text041: Label ' Dh par heure avec un rabais de déductions légales.Il est payé chaque 15 jours après signature des documents de paie.';
        "Rec_Employment Contract": Record "Employment Contract";
        RecRegimesofwork: Record "WDC work Regimes";
        MaritalStatusDG: Text[100];
        DG: Record Employee;
}

