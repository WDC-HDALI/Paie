report 55095 "WDC Gris Salary Adj. 2022"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/RAPPELSALAIREGRILLE2022.rdlc';
    captionML = ENU = 'Gris Salary Adjustment 2022', FRA = 'Rappel salaire grille 2022';
    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE(Status = CONST(Active),
                                      "Working Relationship" = FILTER(Contractuel | Holder));
            RequestFilterFields = "No.";
            column(No_Employee; "No.")
            {
            }
            column(FullName; FullName)
            {
            }
            column(OldSB; OldSB)
            {
            }
            column(Basissalary_; "Basis salary")
            {
            }
            column(Ptransport; Ptransport)
            {
            }
            column(Ptransport1; Ptransport1)
            {
            }
            column(PLogement; PLogement)
            {
            }
            column(PLogement1; PLogement1)
            {
            }
            column(PPresence; PPresence)
            {
            }
            column(PPresence1; PPresence1)
            {
            }
            column(Int; Int)
            {
            }
            column(SomDifference; SomDifference)
            {
            }
            column(NbrMois; NbrMois)
            {
            }

            trigger OnAfterGetRecord()
            var
                Linegrid: Record "WDC Grid Line";
            begin
                IF "Hors Grille" THEN CurrReport.SKIP;
                Int += 1;
                OldSB := 0;
                Linegrid.SETFILTER(College, '%1', College);
                Linegrid.SETFILTER(Scale, '%1', Scale);
                Linegrid.SETRANGE(Echelon, Echelon);
                IF Linegrid.FINDLAST THEN;
                OldSB := Linegrid."Old Basis Salary";


                Ptransport := 0;
                Ptransport1 := 0;
                PLogement := 0;
                PLogement1 := 0;
                PPresence := 0;
                PPresence1 := 0;
                SomDifference := 0;
                //@@@@@@@@@@@@ TRANSPORT
                DefaultIndemnities.RESET;
                DefaultIndemnities.SETRANGE("Emplymt. Contract Code", "Emplymt. Contract Code");
                DefaultIndemnities.SETFILTER("Indemnity Code", '%1|%2|%3', 'G100', 'G109', 'G137');
                IF DefaultIndemnities.FINDSET THEN BEGIN
                    I := 1;
                    REPEAT
                        Ptransport := DefaultIndemnities."Default amount";
                        Ptransport1 := GetIndemnityValue(DefaultIndemnities, "No.");
                    UNTIL DefaultIndemnities.NEXT = 0;
                END;
                //@@@@@@@@@@@@ LOGEMENT
                DefaultIndemnities.RESET;
                DefaultIndemnities.SETRANGE("Emplymt. Contract Code", "Emplymt. Contract Code");
                DefaultIndemnities.SETFILTER("Indemnity Code", '%1', 'G10');
                IF DefaultIndemnities.FINDSET THEN BEGIN
                    I := 1;
                    REPEAT
                        PLogement := DefaultIndemnities."Default amount";
                        PLogement1 := GetIndemnityValue(DefaultIndemnities, "No.");
                    UNTIL DefaultIndemnities.NEXT = 0;
                END;
                //@@@@@@@ PRESENCE
                DefaultIndemnities.RESET;
                DefaultIndemnities.SETRANGE("Emplymt. Contract Code", "Emplymt. Contract Code");
                DefaultIndemnities.SETFILTER("Indemnity Code", '%1', 'G1');
                IF DefaultIndemnities.FINDSET THEN BEGIN
                    I := 1;
                    REPEAT
                        PPresence := DefaultIndemnities."Default amount";
                        PPresence1 := GetIndemnityValue(DefaultIndemnities, "No.");
                    UNTIL DefaultIndemnities.NEXT = 0;
                END;
                SomDifference := ("Basis salary" - OldSB) + (PPresence - PPresence1) + (PLogement - PLogement1) + (Ptransport - Ptransport1);
                NbrMois := GetnbrMois("No.");
            end;
        }
    }



    trigger OnInitReport()
    begin
        //>>AM INNOVATION 11/05/2022
    end;

    var
        OldSB: Decimal;
        DefaultIndemnities: Record "WDC Default Indemnities";
        CodeInde: array[100] of Code[20];
        CodeDescript: array[100] of Code[80];
        I: Integer;
        Montant: array[100] of Decimal;
        Ptransport: Decimal;
        Ptransport1: Decimal;
        PLogement: Decimal;
        PLogement1: Decimal;
        PPresence: Decimal;
        PPresence1: Decimal;
        Int: Integer;
        SomDifference: Decimal;
        NbrMois: Integer;


    procedure GetIndemnityValue(pIndemnity: Record "WDC Default Indemnities"; EmployNo: Code[20]): Decimal
    var
        lIndemnityEn: Record "WDC Rec. Indemnities";
        lRecSalaryLines: Record "WDC Salary Lines";
    begin
        lRecSalaryLines.RESET;
        lRecSalaryLines.SETRANGE("Employee No.", EmployNo);
        lRecSalaryLines.SETRANGE(Month, 0, 11);
        IF lRecSalaryLines.FINDLAST THEN BEGIN
            lIndemnityEn.RESET;
            lIndemnityEn.SETRANGE("No.", lRecSalaryLines."No.");
            lIndemnityEn.SETRANGE("Employee No.", lRecSalaryLines."Employee No.");
            lIndemnityEn.SETRANGE(Indemnity, pIndemnity."Indemnity Code");
            IF lIndemnityEn.FINDSET THEN
                EXIT(lIndemnityEn."Base Amount") ELSE
                EXIT(0);
        END;
    end;

    local procedure GetnbrMois(EmployNo: Code[20]): Integer
    var
        RecSalaryLines: Record "WDC Salary Lines";
        NbrN1: Integer;
        NbrN: Integer;
    begin
        RecSalaryLines.RESET;
        RecSalaryLines.SETCURRENTKEY(Year, "Employee No.", "No.");
        RecSalaryLines.SETRANGE("Employee No.", EmployNo);
        RecSalaryLines.SETRANGE(Year, DATE2DMY(TODAY, 3) - 1);
        RecSalaryLines.SETRANGE(Month, RecSalaryLines.Month::December);
        IF RecSalaryLines.FINDSET THEN
            NbrN1 := RecSalaryLines.COUNT;
        RecSalaryLines.RESET;
        RecSalaryLines.SETCURRENTKEY(Year, "Employee No.", "No.");
        RecSalaryLines.SETRANGE("Employee No.", EmployNo);
        RecSalaryLines.SETRANGE(Year, DATE2DMY(TODAY, 3));
        RecSalaryLines.SETRANGE(Month, 0, 11);
        IF RecSalaryLines.FINDSET THEN
            NbrN := RecSalaryLines.COUNT;
        EXIT(NbrN1 + NbrN);
    end;
}

