report 55019 "WDC Empl. Leave Entitl."
{
    CaptionML = ENU = 'Employee Leave Entitlement', FRA = 'Droit de congés par Employé';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/DroitdecongésparEmployé.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE(Status = CONST(Active));
            column(Matricule; Employee."No.")
            {
            }
            column(Nom; Employee."First Name")
            {
            }
            column(Type; Employee."Employee type")
            {
            }
            column(DroitCongesAnnee_1; DroitCong[1])
            {
            }
            column(ConsCongesAnnee_1; ConSCong[1])
            {
            }
            column(SoldeConges_1; SoldeCong[1])
            {
            }
            column(DroitCongesAnneeAct; DroitCong[2])
            {
            }
            column(ConsCongesAnneeAct; ConSCong[2])
            {
            }
            column(SoldesConges; SoldeCong[2])
            {
            }
            column(Company_Name; Company_Name)
            {
            }
            column(Company_Adresse; Company_Adresse)
            {
            }
            column(ValSold; ValSold)
            {
            }
            column(ValSold1; ValSold1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //>>

                SETFILTER("Year Filter", '%1', DATE2DMY(WORKDATE, 3) - 2);
                CALCFIELDS("Non paid days", "Days off -", "Days off +", "Days off =");
                FOR i := 1 TO 2 DO BEGIN
                    NonPayed[i] := 0;
                    DroitCong[i] := 0;
                    ConSCong[i] := 0;
                    SoldeCong[i] := 0;
                END;

                DroitCong[1] := "Days off =";
                SETFILTER("Year Filter", '%1', DATE2DMY(WORKDATE, 3) - 1);
                CALCFIELDS("Non paid days", "Days off -", "Days off +", "Days off =");

                NonPayed[1] := "Non paid days";
                DroitCong[1] := DroitCong[1] + "Days off +";
                ConSCong[1] := "Days off -";
                SoldeCong[1] := "Days off =";

                DroitCong[2] := "Days off =";
                SETFILTER("Year Filter", '%1', DATE2DMY(WORKDATE, 3));
                CALCFIELDS("Non paid days", "Days off -", "Days off +", "Days off =");

                NonPayed[2] := "Non paid days";
                DroitCong[2] := DroitCong[2] + "Days off +";
                ConSCong[2] := "Days off -";
                SoldeCong[2] := "Days off =";

                ValSold := 0;
                ValInd := 0;
                DefaultIndemnities.RESET;
                DefaultIndemnities.SETFILTER("Emplymt. Contract Code", '%1', "No.");
                IF DefaultIndemnities.FINDFIRST THEN BEGIN
                    REPEAT
                        ValInd := ValInd + DefaultIndemnities."Default amount";
                    UNTIL DefaultIndemnities.NEXT = 0;
                    IF Employee."Employee type".AsInteger() = 1 THEN
                        ValSold := SoldeCong[2] * ((ValInd + "Basis salary") / 26)
                    ELSE
                        ValSold := (SoldeCong[2] / 26) * ((ValInd + "Basis salary") * 8);

                END
                ELSE
                    IF Employee."Employee type".AsInteger() = 1 THEN
                        ValSold := SoldeCong[2] * ((ValInd + "Basis salary") / 26)
                    ELSE
                        ValSold := (SoldeCong[2] / 26) * ((ValInd + "Basis salary") * 8);

                ValSold1 := ValSold1 + ValSold;
                //<<
            end;
        }
    }


    trigger OnInitReport()
    begin
        Rec_Company.GET;
        Company_Name := Rec_Company.Name;
        Company_Adresse := Rec_Company.Address;
    end;

    var
        Rec_Company: Record 79;
        Company_Name: Code[60];
        Company_Adresse: Code[80];
        NonPayed: array[2] of Decimal;
        DroitCong: array[2] of Decimal;
        ConSCong: array[2] of Decimal;
        SoldeCong: array[2] of Decimal;
        i: Integer;
        ValSold: Decimal;
        DefaultIndemnities: Record "WDC Default Indemnities";
        ValInd: Decimal;
        ValSold1: Decimal;
}

