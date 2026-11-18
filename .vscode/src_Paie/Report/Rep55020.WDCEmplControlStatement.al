report 55020 "WDC Empl. Control Statement"
{
    CaptionML = ENU = 'Employee Control Statement', FRA = 'Etat contrôle salariés';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/Etatdecontrolesalarié.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE("Basis salary" = FILTER(<> 0));
            RequestFilterFields = "No.";
            column(Moiss; Moiss)
            {
            }
            column(TXTMOIS1; TXTMOIS1)
            {
            }
            column(TxtTitre; TxtTitre)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; '')
            {
            }
            column(USERID; USERID)
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee__FullName; NomPrenom)
            {
            }
            column(SBASE; SBASE)
            {
                DecimalPlaces = 3 : 3;
            }
            column(HJWORKED; HJWORKED)
            {
            }
            column(IndemImpo; IndemImpo)
            {
                DecimalPlaces = 3 : 3;
            }
            column(SBRUT; SBRUT)
            {
                DecimalPlaces = 3 : 3;
            }
            column(PRET; PRET)
            {
                DecimalPlaces = 3 : 3;
            }
            column(AVANCE; AVANCE)
            {
                DecimalPlaces = 3 : 3;
            }
            column(SNET; SNET)
            {
                DecimalPlaces = 3 : 3;
            }
            column(SBASE1; SBASE1)
            {
            }
            column(HJWORKED1; HJWORKED1)
            {
            }
            column(IndemImpo1; IndemImpo1)
            {
            }
            column(SBRUT1; SBRUT1)
            {
            }
            column(PRET1; PRET1)
            {
            }
            column(AVANCE1; AVANCE1)
            {
            }
            column(SNET1; SNET1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //>>
                //-------------------Initialisation -------------------------
                SBASE := 0;
                IndemImpo := 0;
                SBRUT := 0;
                PRET := 0;
                AVANCE := 0;
                SNET := 0;
                HJWORKED := '';
                SBASE1 := 0;
                IndemImpo1 := 0;
                SBRUT1 := 0;
                PRET1 := 0;
                AVANCE1 := 0;
                SNET1 := 0;
                HJWORKED1 := '';

                //----------------------------------------------

                SBASE := FctGetSalaryBaseAV("No.", Moiss);
                HJWORKED := FctGetHJWorkedAV("No.", Moiss);
                IndemImpo := FctGetIndImposAV("No.", Moiss);
                SBRUT := FctGetSalaryBrutAV("No.", Moiss);
                PRET := FctGetPrêtAV("No.", Moiss);
                AVANCE := FctGetAvanceAV("No.", Moiss);
                SNET := FctGetSNetAV("No.", Moiss);
                ///-------------
                SBASE1 := FctGetSalaryBase("No.", Moiss1);
                HJWORKED1 := FctGetHJWorked("No.", Moiss1);
                IndemImpo1 := FctGetIndImpos("No.", Moiss1);
                SBRUT1 := FctGetSalaryBrut("No.", Moiss1);
                PRET1 := FctGetPrêt("No.", Moiss1);
                AVANCE1 := FctGetAvance("No.", Moiss1);
                SNET1 := FctGetSNet("No.", Moiss1);
                TxtTitre := 'ETAT DE VARIATION SALARIE' + '   ' + FORMAT(Moiss) + '  ET  ' + TXTMOIS1 + '   ' + FORMAT(Year);
                NomPrenom := Employee."First Name" + ' ' + Employee."Last Name";
                //<<
            end;

            trigger OnPreDataItem()
            begin
                CASE Moiss OF

                    Moiss::Février:
                        BEGIN
                            Moiss1 := 0;
                            TXTMOIS1 := 'Janvier';
                        END;
                    Moiss::Mars:
                        BEGIN
                            Moiss1 := 1;
                            TXTMOIS1 := 'Février';
                        END;
                    Moiss::Avril:
                        BEGIN
                            Moiss1 := 2;
                            TXTMOIS1 := 'Mars';
                        END;
                    Moiss::Mai:
                        BEGIN
                            Moiss1 := 3;
                            TXTMOIS1 := 'Avril';
                        END;
                    Moiss::Juin:
                        BEGIN
                            Moiss1 := 4;
                            TXTMOIS1 := 'Mai';
                        END;
                    Moiss::Juillet:
                        BEGIN
                            Moiss1 := 5;
                            TXTMOIS1 := 'Juin';
                        END;
                    Moiss::Août:
                        BEGIN
                            Moiss1 := 6;
                            TXTMOIS1 := 'Juillet';
                        END;
                    Moiss::Septembre:
                        BEGIN
                            Moiss1 := 7;
                            TXTMOIS1 := 'Août';
                        END;
                    Moiss::Octobre:
                        BEGIN
                            Moiss1 := 8;
                            TXTMOIS1 := 'Septembre';
                        END;
                    Moiss::Novembre:
                        BEGIN
                            Moiss1 := 9;
                            TXTMOIS1 := 'Octobre';
                        END;
                    Moiss::Décembre:
                        BEGIN
                            Moiss1 := 10;
                            TXTMOIS1 := 'Novembre';
                        END;
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
                field(Mois; Moiss)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CASE Moiss OF
                            //Janvier,Février,Mars,Avril,Mai,Juin,Juillet,Août,Septembre,Octobre,Novembre,Décembre
                            Moiss::Février:
                                Moiss1 := 0;
                            Moiss::Mars:
                                Moiss1 := 1;
                            Moiss::Avril:
                                Moiss1 := 2;
                            Moiss::Mai:
                                Moiss1 := 3;
                            Moiss::Juin:
                                Moiss1 := 4;
                            Moiss::Juillet:
                                Moiss1 := 5;
                            Moiss::Août:
                                Moiss1 := 6;
                            Moiss::Septembre:
                                Moiss1 := 7;
                            Moiss::Octobre:
                                Moiss1 := 8;
                            Moiss::Novembre:
                                Moiss1 := 9;
                            Moiss::Décembre:
                                Moiss1 := 10;
                        END;
                    end;
                }
                field("Année"; Year)
                {
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            Year := DATE2DMY(WORKDATE, 3);
        end;
    }

    labels
    {
    }

    var
        SBASE: Decimal;
        RAPPEL: Decimal;
        HSUP: Decimal;
        IndemImpo: Decimal;
        SBRUT: Decimal;
        CNSS: Decimal;
        SIMPOSABLE: Decimal;
        TAXEMOIS: Decimal;
        AUTRETENU: Decimal;
        PRET: Decimal;
        AVANCE: Decimal;
        SNET: Decimal;
        Moiss: Option Janvier,"Février",Mars,Avril,Mai,Juin,Juillet,"Août",Septembre,Octobre,Novembre,"Décembre";
        Moiss1: Integer;
        TXTMOIS1: Code[20];
        "Year": Integer;
        HJWORKED: Text[10];
        TxtTitre: Text[80];
        SBASE1: Decimal;
        HJWORKED1: Text[10];
        IndemImpo1: Decimal;
        SBRUT1: Decimal;
        PRET1: Decimal;
        AVANCE1: Decimal;
        SNET1: Decimal;
        NomPrenom: Text;


    procedure FctGetSalaryBase(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //>>
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := Return + RecLSalaryLineEnreg."Real basis salary";
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;


    procedure FctGetHJWorked(SalryNo: Code[20]; Months: Integer) Return: Text[10]
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //<<
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            IF RecLSalaryLineEnreg."Employee type" = RecLSalaryLineEnreg."Employee type"::"Hour based" THEN
                Return := FORMAT(RecLSalaryLineEnreg."Basis hours") + 'H' ELSE
                Return := FORMAT(RecLSalaryLineEnreg."Paied days") + 'J';
        END;
        //<<
    end;


    procedure FctGetIndImpos(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //>>
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := RecLSalaryLineEnreg."Taxable indemnities";
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;


    procedure FctGetSalaryBrut(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //<<  -------------BRUT---------------
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := Return + RecLSalaryLineEnreg."Gross Salary";
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;


    procedure "FctGetPrêt"(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //<<
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := Return + RecLSalaryLineEnreg.Loans;
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;


    procedure FctGetAvance(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //<< -----------Avance ---------------
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := Return + RecLSalaryLineEnreg.Advances;
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;


    procedure FctGetSNet(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //<< -----------S Net ---------------
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := Return + RecLSalaryLineEnreg."Net salary cashed";
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;


    procedure "---"()
    begin
    end;


    procedure FctGetSalaryBaseAV(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //>>
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);
        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := Return + RecLSalaryLineEnreg."Real basis salary";
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;


    procedure FctGetHJWorkedAV(SalryNo: Code[20]; Months: Integer) Return: Text[10]
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //<<
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            IF RecLSalaryLineEnreg."Employee type" = RecLSalaryLineEnreg."Employee type"::"Hour based" THEN
                Return := FORMAT(RecLSalaryLineEnreg."Basis hours") + 'H' ELSE
                Return := FORMAT(RecLSalaryLineEnreg."Paied days") + 'J';
        END;
        //<<
    end;


    procedure FctGetIndImposAV(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //>> -----------Inde.Imposable ---------------
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := RecLSalaryLineEnreg."Taxable indemnities";
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;


    procedure FctGetSalaryBrutAV(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //<<   -------------BRUT---------------
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := Return + RecLSalaryLineEnreg."Gross Salary";
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;


    procedure "FctGetPrêtAV"(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //<<
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := Return + RecLSalaryLineEnreg.Loans;
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;


    procedure FctGetAvanceAV(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //<< -----------Avance ---------------
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := Return + RecLSalaryLineEnreg.Advances;
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;


    procedure FctGetSNetAV(SalryNo: Code[20]; Months: Integer) Return: Decimal
    var
        RecLSalaryLineEnreg: Record "WDC Salary Lines";
    begin
        //<< -----------S Net ---------------
        RecLSalaryLineEnreg.RESET;
        RecLSalaryLineEnreg.SETRANGE("Employee No.", SalryNo);
        RecLSalaryLineEnreg.SETRANGE(Year, Year);
        RecLSalaryLineEnreg.SETRANGE(Month, Months);

        IF RecLSalaryLineEnreg.FINDSET THEN BEGIN
            REPEAT
                Return := Return + RecLSalaryLineEnreg."Net salary cashed";
            UNTIL RecLSalaryLineEnreg.NEXT = 0;
        END;
        //<<
    end;
}

