report 55041 "WDC Employee Entry/Exit"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/EntréeSortieSalarié.rdlc';
    captionML = ENU = 'Employee Entry/Exit', FRA = 'Entrée/Sortie des salariés';
    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Name; "Company Information".Name)
            {
            }
            column(AdresseCompany; "Company Information".Address)
            {
            }
            column(Picture; "Company Information".Picture)
            {
            }
            column(Titre; TxtTitre)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Company Information".CALCFIELDS(Picture);
            end;
        }
        dataitem("Heures occasionnelles"; "WDC Occasional Hours")
        {
            DataItemTableView = WHERE("Employee No." = FILTER(<> ''));
            column("Salarié"; "Employee No.")
            {
            }
            column(NomPrenom; "First Name" + ' ' + "Last Name")
            {
            }
            column(Date_Heuresoccasionnelles; "Posting Date")
            {
            }
            column(Heuredebut_HeuresoccasionnellesMatin; HDebMatin)
            {
            }
            column(HeureFin_HeuresoccasionnellesMatin; HFinMatin)
            {
            }
            column(Heuredebut_HeuresoccasionnellesSoire; HDebSoire)
            {
            }
            column(HeureFin_HeuresoccasionnellesSoire; HFinSoire)
            {
            }
            column(Nombredheures_Heuresoccasionnelles; totalNombreHeure)
            {
            }
            column(Moisdepaiement_Heuresoccasionnelles; "Payment Month")
            {
            }
            column("Annéedepaiement_Heuresoccasionnelles"; "Payment Year")
            {
            }

            trigger OnAfterGetRecord()
            var
                NbrRow: Integer;
            begin
                "Heure Travaille".RESET;
                "Heure Travaille".SETRANGE("Posting Date", "Heures occasionnelles"."Posting Date");
                "Heure Travaille".SETRANGE("Employee No.", "Heures occasionnelles"."Employee No.");
                IF "Heure Travaille".FINDSET THEN BEGIN
                    NbrRow := "Heure Travaille".COUNT;
                    totalNombreHeure := 0;
                    REPEAT

                        IF "Heures occasionnelles"."Starting Time" <= 120000T THEN BEGIN
                            HDebMatin := "Heures occasionnelles"."Starting Time";
                            HFinMatin := "Heures occasionnelles"."Ending Time";
                            NbrHeureMatin := "Heures occasionnelles"."Hours Number";
                            IF NbrRow = 2 THEN
                                CurrReport.SKIP;
                        END
                        ELSE BEGIN
                            HDebSoire := "Heures occasionnelles"."Starting Time";
                            HFinSoire := "Heures occasionnelles"."Ending Time";
                            totalNombreHeure := NbrHeureMatin + "Heures occasionnelles"."Hours Number";
                        END
                    UNTIL "Heure Travaille".NEXT = 0;
                END;
                IF (NbrRow = 1) AND (NbrHeureMatin > 0) THEN
                    totalNombreHeure := NbrHeureMatin;
                NbrHeureMatin := 0;
            end;
        }
    }


    var
        TxtTitre: Label 'Entrée\Sortie des salariés';
        "Heure Travaille": Record "WDC Occasional Hours";
        HDebMatin: Time;
        HFinMatin: Time;
        HFinSoire: Time;
        HDebSoire: Time;
        totalNombreHeure: Decimal;
        NbrHeureMatin: Decimal;
}

