codeunit 55026 "WDC Management of Work Hours"
{
    TableNo = 55015;

    trigger OnRun()
    var
        HeuresSupEreg: Record "WDC Overtime hours recorded m";
        NTransaction: Integer;
        Window: Dialog;
        lText001: TextConst ENU = 'Error: The form is empty. Unable to proceed.',
                            FRA = 'Erreur :\Le formulaire est vide.\Impossible de poursuivre.';
    begin
        HeuresSupEreg.RESET;
        IF HeuresSupEreg.FINDLAST()
          THEN
            NTransaction := HeuresSupEreg."Transaction No." + 1
        ELSE
            NTransaction := 1;

        IF Rec.FINDSET THEN BEGIN
            Window.OPEN('Validation des lignes d''heures sup. en cours :\' +
                         '  N° ligne    : #######1\' +
                         '  N° salarié  : #######2\');
            Rec.LOCKTABLE;
            REPEAT
                Window.UPDATE(1, Rec."Line No.");
                Window.UPDATE(2, Rec."Employee No.");
                CalculateOvertimePay(NTransaction, Rec);
            UNTIL Rec.NEXT = 0;
            Window.CLOSE;
        END
        ELSE
            ERROR(lText001);
    END;

    procedure CalculateOvertimePay("N°Transaction": Integer; LigneHeureSup: Record "WDC Monthly Overtime Hours")
    var
        LigneHeureSupSlr: Record "WDC Monthly Overtime Hours";

    begin
        RecordOvertimeHours("N°Transaction", LigneHeureSup, WORKDATE);
    end;


    procedure RecordOvertimeHours("Transaction No.": Integer; HeuresSup: Record "WDC Monthly Overtime Hours"; DateValidation: Date)
    var
        HeuresSupEreg: Record "WDC Overtime hours recorded m";
        NTransaction: Integer;
        Sal: Record Employee;
    begin
        HeuresSup.TestField("Employee No.");
        HeuresSup.TestField("Posting Date");
        HeuresSup.TestField("Hours Number");
        HeuresSup.TestField("Overtime Rate");

        CLEAR(Sal);
        Sal.GET(HeuresSup."Employee No.");
        HeuresSupEreg.RESET;
        HeuresSupEreg.INIT;
        HeuresSupEreg."Transaction No." := "Transaction No.";
        HeuresSupEreg."Line No." := HeuresSup."Line No.";
        HeuresSupEreg."Employee No." := HeuresSup."Employee No.";
        HeuresSupEreg."Last Name" := HeuresSup."Last Name";
        HeuresSupEreg."First Name" := HeuresSup."First Name";
        HeuresSupEreg."Posting Date" := HeuresSup."Posting Date";
        HeuresSupEreg."Department Code" := HeuresSup."Department Code";
        HeuresSupEreg."Folder Code" := HeuresSup."Folder Code";
        HeuresSupEreg."Employee Statistic Group" := HeuresSup."Employee Statistic Group";
        HeuresSupEreg."Hours Number" := HeuresSup."Hours Number";
        HeuresSupEreg."Unit Tariff" := HeuresSup."Unit Tariff";
        HeuresSupEreg."Line amount" := HeuresSup."Line amount";
        HeuresSupEreg."Payment Month" := HeuresSup."Payment Month";
        HeuresSupEreg."Payment Year" := HeuresSup."Payment Year";
        HeuresSupEreg."Overtime Rate" := HeuresSup."Overtime Rate";
        HeuresSupEreg."Day Type" := HeuresSup."Day Type";
        HeuresSupEreg."Hour Type" := HeuresSup."Hour Type";
        HeuresSupEreg.System := HeuresSup.System;
        HeuresSupEreg.Week := HeuresSup.week;
        HeuresSupEreg.Fortnight := HeuresSup.Fortnight;
        HeuresSupEreg."Employee Posting Group" := Sal."Empl. Posting Group";
        HeuresSupEreg.INSERT;
        HeuresSup.DELETE;
    end;


    procedure DevaliderHeuresSup(HeuresSupEreg: Record "WDC Overtime hours recorded m"; Nligne: Integer)
    var
        HeuresSup: Record "WDC Monthly Overtime Hours";
        NTransaction: Integer;
        Sal: Record Employee;
    begin
        IF ((HeuresSupEreg."Employee No." <> '') AND (HeuresSupEreg."Posting Date" <> 0D)
            AND (HeuresSupEreg."Hours Number" <> 0)
           ) THEN BEGIN
            CLEAR(Sal);
            Sal.GET(HeuresSupEreg."Employee No.");
            HeuresSup.RESET;
            HeuresSup.INIT;
            HeuresSup."Line No." := Nligne;
            HeuresSup."Employee No." := HeuresSupEreg."Employee No.";
            HeuresSup."Last Name" := HeuresSupEreg."Last Name";
            HeuresSup."First Name" := HeuresSupEreg."First Name";
            HeuresSup."Posting Date" := HeuresSupEreg."Posting Date";
            HeuresSup."Department Code" := HeuresSupEreg."Department Code";
            HeuresSup."Folder Code" := HeuresSupEreg."Folder Code";
            HeuresSup."Line amount" := HeuresSupEreg."Line amount";
            HeuresSup.VALIDATE("Day Type", HeuresSupEreg."Day Type");
            HeuresSup."Overtime Rate" := HeuresSupEreg."Overtime Rate";
            HeuresSup.VALIDATE("Hours Number", HeuresSupEreg."Hours Number");
            HeuresSup.VALIDATE("Unit Tariff", HeuresSupEreg."Unit Tariff");
            HeuresSup."Payment Month" := HeuresSupEreg."Payment Month";
            HeuresSup."Payment Year" := HeuresSupEreg."Payment Year";
            HeuresSup."Overtime Rate" := HeuresSupEreg."Overtime Rate";
            HeuresSup."Hour Type" := HeuresSupEreg."Hour Type";
            HeuresSup.System := HeuresSupEreg.System;
            HeuresSup.Fortnight := HeuresSupEreg.Fortnight;
            HeuresSup.INSERT;
            HeuresSupEreg.DELETE;
        END;
    end;

    procedure IntialiserAzeroIndemnite()
    begin
        //--- P-Encouragement -----(1)
        ReGParmRH.GET();
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."P-Encouragement");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;
        END;
        //--- P-Bonus -----(2)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."P-Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Equipe -----(3)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Team Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Exceptionlle -----(4)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Exceptional Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Comptétence -----(5)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Competence Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-HeureMajoré -----(6)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Overtime Houres Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Mission -----(7)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Mission Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Affectation -----(8)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Assignment Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Poste -----(9)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Position Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- Rappel -----(10)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Back Pay");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Productivité -----(11)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Productivity Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Coord-Qualité -----(12)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Quality Coordination Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-13EMois -----(13)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."13th Month Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        // //--- P-2011 -----(14) //Hamdi Migration
        // RecGIndemnity.RESET;
        // RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."P-2011");
        // IF RecGIndemnity.FINDSET THEN BEGIN
        //     REPEAT
        //         RecGIndemnity.VALIDATE("Default amount", 0);
        //         RecGIndemnity.MODIFY;
        //     UNTIL RecGIndemnity.NEXT = 0;

        // END;
        //--- P-Trimestrielle -----(15)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Quarterly Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Solde-Fin-Contrat -----(16)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."End of Contract Balance Amount");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- Gratification Aid -----(17)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Gratification Aid");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- Gratification -----(18)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH.Gratification);
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- Ind.Départ -----(19)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Severance Pay Indemnity");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Objectif -----(20)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Objective Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Ancienneté -----(21)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Seniority Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Retraite -----(22)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Retirement Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- P-Rappel Autre -----(23)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Other Back Pay");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;
        END;
        //--- P-Transport -----(24)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Transport Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;

        END;
        //--- H.Allaittement  -----(25)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Maternity Leave Indem.");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;
        END;
        //--- A.Technique /Accident travail   -----(26)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Evaluation mode", RecGIndemnity."Evaluation mode"::Inclusive);
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Hours A.T");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;
        END;
        //--- H.UGTT  -----(27)  //Migration Hamdi
        // RecGIndemnity.RESET;
        // RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."H.UGTT");
        // IF RecGIndemnity.FINDSET THEN BEGIN
        //     REPEAT
        //         RecGIndemnity.VALIDATE("Default amount", 0);
        //         RecGIndemnity.MODIFY;
        //     UNTIL RecGIndemnity.NEXT = 0;
        // END;
        //--- J.Sup  -----(28)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Indem Overtime Days");
        IF RecGIndemnity.FINDSET THEN BEGIN
            REPEAT
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity."Days Number" := 0;
                RecGIndemnity.MODIFY;
            UNTIL RecGIndemnity.NEXT = 0;
        END;

    end;


    procedure GetTransactionNo(PLineNo: Integer; pEmpNo: code[20]): Integer
    var
        HeuresSupEreg: Record "WDC Occasional Hours Recorded";
    begin
        HeuresSupEreg.Reset();
        HeuresSupEreg.SetCurrentKey("Transaction No.", "Line No.", "Employee No.");
        HeuresSupEreg.SetRange("Line No.", PLineNo);
        HeuresSupEreg.SetRange("Employee No.", pEmpNo);
        IF HeuresSupEreg.FINDLAST THEN
            Exit(HeuresSupEreg."Transaction No." + 1);
        Exit(1);
    end;

    procedure PostWorkDays(LigneHeureSup: Record 55008)
    var
        HeuresSupEnreg: Record 55009;
        NewLigneHeureSup: Record 55008;
        LigneHeureSupSlr: Record 55015;
        Total: Decimal;
        errorSlrNotFound: TextConst ENU = 'Error: Employee not found. Check the entered Employee No.',
                                    FRA = 'Erreur :\Salarié introuvable. Vérifier le N° salarié saisi.';
        errorRegTravailSlr: TextConst ENU = 'Error: The work regime of the employee is required to continue calculation. Please verify this parameter on the employee card. Employee No.: ##########1 Employee name: ##########2',
                                      FRA = 'Erreur :\La mention du Régime de travail auquel appartient le salarié est un paramètre indispensable\à la poursuite du calacul.\Veuillez vérifier ce paramètre sur la fiche salarié.\N° salarié  : ##########1\Nom salarié : ##########2';
        Contrat: Record 5211;
        NbrHeures: Decimal;
        DSemaine: Date;
        FSemaine: Date;
        Std: Decimal;
        TarifHorraire: Decimal;
        IndSlr: Record 55004;
        CodeInd: Record 55000;
        TotalInd: Decimal;
        ParamRessHum: Record 5218;
        ErrorContrat: TextConst ENU = 'Error: Working hours for temporary workers do not exist...',
                                FRA = 'Erreur :\Heures du travail pour les occasionnels inexistant ...';
        LigHeuresSuptmp: Record 55015;
        HeuresSupEnregtmp: Record 55009;
        HeuresSupEnregtmptr: Record 55016;
        trns: Integer;
    begin

        ReGParmRH.GET();
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."P-Encouragement");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."P-Encouragement" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."P-Encouragement");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Bonus -----(2)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."P-Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."P-Bonus" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."P-Bonus");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Equipe -----(3)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Team Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Team Bonus" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Team Bonus");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Exceptionlle -----(4)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Exceptional Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Exceptional Bonus" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Exceptional Bonus");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Comptétence -----(5)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Competence Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Competence Bonus" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Competence Bonus");
            RecGIndemnity.MODIFY;
        END;
        //--- P-HeureMajoré -----(6)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Overtime Houres Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Overtime Houres Pay" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Overtime Houres Pay");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Mission -----(7)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Mission Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Mission Pay" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Mission Pay");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Affectation -----(8)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Assignment Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Assignment Pay" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Assignment Pay");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Poste -----(9)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Position Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Position Pay" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Position Pay");
            RecGIndemnity.MODIFY;
        END;
        //--- Rappel -----(10)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Back Pay");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Back Pay" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Back Pay");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Productivité -----(11)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Productivity Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Productivity Bonus" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Productivity Bonus");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Coord-Qualité -----(12)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Quality Coordination Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Quality Coordination Bonus" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Quality Coordination Bonus");
            RecGIndemnity.MODIFY;
        END;
        //--- P-13EMois -----(13)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."13th Month Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."13th Month Pay" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."13th Month Pay");
            RecGIndemnity.MODIFY;
        END;
        // //--- P-2011 -----(14) //Hamdi Migration
        // RecGIndemnity.RESET;
        // RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        // RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."P-2011");
        // IF RecGIndemnity.FINDSET THEN BEGIN
        //     IF LigneHeureSup."P-2011" <> 0 THEN
        //         RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."P-2011");
        //     RecGIndemnity.MODIFY;
        // END;
        //--- P-Trimestrielle -----(15)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Quarterly Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Quarterly Bonus" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Quarterly Bonus");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Solde-Fin-Contrat -----(16)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."End of Contract Balance Amount");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."End of Contract Balance Amount" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."End of Contract Balance Amount");
            RecGIndemnity.MODIFY;
        END;
        //--- Gratification Aid -----(17)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Gratification Aid");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Gratification Aid" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Gratification Aid");
            RecGIndemnity.MODIFY;
        END;
        //--- Gratification -----(18)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Evaluation mode", RecGIndemnity."Evaluation mode"::Inclusive);
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH.Gratification);
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup.Gratification <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup.Gratification);
            RecGIndemnity.MODIFY;
        END;
        //--- Ind.Départ -----(19)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Severance Pay Indemnity");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Severance Pay Indemnity" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Severance Pay Indemnity");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Objectif -----(20)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Objective Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Objective Bonus" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Objective Bonus");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Ancienneté -----(21)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Seniority Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Seniority Bonus" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Seniority Bonus");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Retraite -----(22)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Retirement Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Retirement Bonus" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Retirement Bonus");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Rappel Autre -----(23)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Other Back Pay");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Other Back Pay" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Other Back Pay");
            RecGIndemnity.MODIFY;
        END;
        //--- P-Transport -----(24)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Transport Bonus");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Transport Bonus" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Transport Bonus");
            RecGIndemnity.MODIFY;
        END;

        //--- J.Sup  -----(28)
        RecGIndemnity.RESET;
        RecGIndemnity.SETRANGE("Emplymt. Contract Code", LigneHeureSup."Employee No.");
        RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Indem Overtime Days");
        IF RecGIndemnity.FINDSET THEN BEGIN
            IF LigneHeureSup."Overtime Amount" <> 0 THEN
                RecGIndemnity.VALIDATE("Default amount", LigneHeureSup."Overtime Amount");
            RecGIndemnity."Days Number" := LigneHeureSup."Days Number";
            RecGIndemnity.MODIFY;
        END;



        trns := GetTransactionNo(LigneHeureSup."Line No.", LigneHeureSup."Employee No.");

        HeuresSupEnreg.TRANSFERFIELDS(LigneHeureSup);
        HeuresSupEnreg."Posting Date" := LigneHeureSup."Posting Date";
        HeuresSupEnreg."Payment Year" := LigneHeureSup."Payment Year";
        HeuresSupEnreg."Payment Month" := LigneHeureSup."Payment Month";
        HeuresSupEnreg."Transaction No." := trns;//HeuresSupEnregtmp."Transaction No." + 1; //HD Migration
        HeuresSupEnreg."Start Time" := LigneHeureSup."Starting Time";
        HeuresSupEnreg."End Time" := LigneHeureSup."Ending Time";
        HeuresSupEnreg.Fortnight := LigneHeureSup.Fortnight;
        HeuresSupEnreg.Productivité := LigneHeureSup.Productivité;
        HeuresSupEnreg."Day Indemnity" := LigneHeureSup."Indemnity Day";
        HeuresSupEnreg."Worked Days (Hours)" := LigneHeureSup."Jours Travaille (Horaire)";
        HeuresSupEnreg."Pulic Holiday Days" := LigneHeureSup."Pulic Holiday Days";
        HeuresSupEnreg."Pulic Holiday Amount" := LigneHeureSup."Pulic Holiday Amount";
        HeuresSupEnreg."P-Encouragement" := LigneHeureSup."P-Encouragement";
        HeuresSupEnreg."P-Bonus" := LigneHeureSup."P-Bonus";
        HeuresSupEnreg."Team Bonus" := LigneHeureSup."Team Bonus";
        HeuresSupEnreg."Exceptional Bonus" := LigneHeureSup."Exceptional Bonus";
        HeuresSupEnreg."Competence Bonus" := LigneHeureSup."Competence Bonus";
        HeuresSupEnreg."Overtime Houres Pay" := LigneHeureSup."Overtime Houres Pay";
        HeuresSupEnreg."Mission Pay" := LigneHeureSup."Mission Pay";
        HeuresSupEnreg."Assignment Pay" := LigneHeureSup."Assignment Pay";
        HeuresSupEnreg."Position Pay" := LigneHeureSup."Position Pay";

        HeuresSupEnreg."Back Pay" := LigneHeureSup."Back Pay";
        HeuresSupEnreg."Productivity Bonus" := LigneHeureSup."Productivity Bonus";
        HeuresSupEnreg."Quality Coordination Bonus" := LigneHeureSup."Quality Coordination Bonus";
        HeuresSupEnreg."13th Month Pay" := LigneHeureSup."13th Month Pay";
        HeuresSupEnreg."Quarterly Bonus" := LigneHeureSup."Quarterly Bonus";
        HeuresSupEnreg."End of Contract Balance Amount" := LigneHeureSup."End of Contract Balance Amount";
        HeuresSupEnreg."Gratification Aid" := LigneHeureSup."Gratification Aid";
        HeuresSupEnreg.Gratification := LigneHeureSup.Gratification;
        HeuresSupEnreg."Severance Pay Indemnity" := LigneHeureSup."Severance Pay Indemnity";
        HeuresSupEnreg."Objective Bonus" := LigneHeureSup."Objective Bonus";
        HeuresSupEnreg."Seniority Bonus" := LigneHeureSup."Seniority Bonus";
        HeuresSupEnreg."Retirement Bonus" := LigneHeureSup."Retirement Bonus";
        HeuresSupEnreg."Other Back Pay" := LigneHeureSup."Other Back Pay";
        HeuresSupEnreg."Transport Bonus" := LigneHeureSup."Transport Bonus";
        HeuresSupEnreg."Overtime Days" := LigneHeureSup."Overtime Days";
        HeuresSupEnreg."Overtime Amount" := LigneHeureSup."Overtime Amount";
        HeuresSupEnreg.INSERT;

        LigneHeureSup.DELETE;

    end;

    procedure DevaliderHeuresTravail(HeuresSupEreg: Record 55009; Nligne: Integer)
    var
        HeuresSup: Record 55008;
        NTransaction: Integer;
        Sal: Record 5200;
    begin
        IF (HeuresSupEreg."Employee No." <> '') AND (HeuresSupEreg."Posting Date" <> 0D) THEN //AND ((HeuresSupEreg."Paiement No.") = '' ) WDC
               BEGIN
            //>> --Initialisation des indemnités formetaire a zéro
            //--- P-Encouragement -----(1)
            ReGParmRH.GET();
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."P-Encouragement");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Bonus -----(2)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."P-Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Equipe -----(3)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Team Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Exceptionlle -----(4)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Exceptional Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Comptétence -----(5)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Competence Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-HeureMajoré -----(6)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Overtime Houres Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Mission -----(7)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Mission Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Affectation -----(8)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Assignment Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Poste -----(9)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Position Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- Rappel -----(10)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Back Pay");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Productivité -----(11)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Productivity Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Coord-Qualité -----(12)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Quality Coordination Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-13EMois -----(13)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."13th Month Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Trimestrielle -----(15)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Quarterly Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Solde-Fin-Contrat -----(16)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."End of Contract Balance Amount");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- Gratification Aid -----(17)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Gratification Aid");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- Gratification -----(18)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH.Gratification);
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- Ind.Départ -----(19)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Severance Pay Indemnity");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Objectif -----(20)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Objective Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Ancienneté -----(21)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Seniority Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Retraite -----(22)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Retirement Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Autre Rappel -----(23)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Other Back Pay");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            //--- P-Tranport -----(24)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Transport Bonus");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity.MODIFY;
            END;
            // //--- H.Allaittement  -----(25) //Hamdi Migration
            // RecGIndemnity.RESET;
            // RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            // RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."H.Allaittement");
            // IF RecGIndemnity.FINDSET THEN BEGIN
            //     RecGIndemnity.VALIDATE("Default amount", 0);
            //     RecGIndemnity."Allait-UGTT-ATECH" := 0;
            //     RecGIndemnity.MODIFY;
            // END;
            // //--- A.Technique /Accident travail  -----(26) //Hamdi Migration
            // RecGIndemnity.RESET;
            // RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            // //RecGIndemnity.SETRANGE("Evaluation mode",RecGIndemnity."Evaluation mode"::Inclusive);
            // RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Heure A.T");
            // IF RecGIndemnity.FINDSET THEN BEGIN
            //     RecGIndemnity.VALIDATE("Default amount", 0);
            //     RecGIndemnity."Allait-UGTT-ATECH" := 0;
            //     RecGIndemnity.MODIFY;
            // END;
            // //--- A.UGTT  -----(27)//Hamdi Migration
            // RecGIndemnity.RESET;
            // RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            // //RecGIndemnity.SETRANGE("Evaluation mode",RecGIndemnity."Evaluation mode"::Inclusive);
            // RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."H.UGTT");
            // IF RecGIndemnity.FINDSET THEN BEGIN
            //     RecGIndemnity.VALIDATE("Default amount", 0);
            //     RecGIndemnity."Allait-UGTT-ATECH" := 0;
            //     RecGIndemnity.MODIFY;
            // END;
            //--- J.Sup  -----(28)
            RecGIndemnity.RESET;
            RecGIndemnity.SETRANGE("Emplymt. Contract Code", HeuresSupEreg."Employee No.");
            RecGIndemnity.SETRANGE("Indemnity Code", ReGParmRH."Indem Overtime Days");
            IF RecGIndemnity.FINDSET THEN BEGIN
                RecGIndemnity.VALIDATE("Default amount", 0);
                RecGIndemnity."Days Number" := 0;
                RecGIndemnity.MODIFY;
            END;


            CLEAR(Sal);
            Sal.GET(HeuresSupEreg."Employee No.");
            HeuresSup.RESET;
            HeuresSup.INIT;
            HeuresSup."Line No." := Nligne;
            HeuresSup."Employee No." := HeuresSupEreg."Employee No.";
            HeuresSup."First Name" := HeuresSupEreg."First Name";
            HeuresSup."Last Name" := HeuresSupEreg."Last Name";
            HeuresSup."Posting Date" := HeuresSupEreg."Posting Date";
            HeuresSup."Department Code" := HeuresSupEreg."Department Code";
            HeuresSup."Folder Code" := HeuresSupEreg."Folder Code";
            HeuresSup."Line amount" := HeuresSupEreg."Line Amount";
            HeuresSup.VALIDATE("Day Type", HeuresSupEreg."Days Type");
            HeuresSup."Overtime Rate" := HeuresSupEreg."Overtime Rate";
            HeuresSup.VALIDATE("Hours Number", HeuresSupEreg."Hours Number");
            HeuresSup.VALIDATE("Days Number", HeuresSupEreg."Days Number");
            HeuresSup.VALIDATE("Unit Tariff", HeuresSupEreg."Unit Tariff");
            HeuresSup."Payment Month" := HeuresSupEreg."Payment Month";
            HeuresSup."Payment Year" := HeuresSupEreg."Payment Year";
            HeuresSup.Fortnight := HeuresSupEreg.Fortnight;
            HeuresSup.Productivité := HeuresSupEreg.Productivité;
            HeuresSup."Indemnity Day" := HeuresSupEreg."Day Indemnity";
            HeuresSup.VALIDATE("Pulic Holiday Days", HeuresSupEreg."Pulic Holiday Days");
            HeuresSup."P-Encouragement" := HeuresSupEreg."P-Encouragement";
            HeuresSup."P-Bonus" := HeuresSupEreg."P-Bonus";
            HeuresSup."Team Bonus" := HeuresSupEreg."Team Bonus";
            HeuresSup."Exceptional Bonus" := HeuresSupEreg."Exceptional Bonus";
            HeuresSup."Competence Bonus" := HeuresSupEreg."Competence Bonus";
            HeuresSup."Seniority Bonus" := HeuresSupEreg."Seniority Bonus";
            HeuresSup."Mission Pay" := HeuresSupEreg."Mission Pay";
            HeuresSup."Assignment Pay" := HeuresSupEreg."Assignment Pay";
            HeuresSup."Position Pay" := HeuresSupEreg."Position Pay";
            HeuresSup."Back Pay" := HeuresSupEreg."Back Pay";
            HeuresSup."Productivity Bonus" := HeuresSupEreg."Productivity Bonus";
            HeuresSup."Quality Coordination Bonus" := HeuresSupEreg."Quality Coordination Bonus";
            HeuresSup."13th Month Pay" := HeuresSupEreg."13th Month Pay";
            HeuresSup."Quarterly Bonus" := HeuresSupEreg."Quarterly Bonus";
            HeuresSup."End of Contract Balance Amount" := HeuresSupEreg."End of Contract Balance Amount";
            HeuresSup."Gratification Aid" := HeuresSupEreg."Gratification Aid";
            HeuresSup.Gratification := HeuresSupEreg.Gratification;
            HeuresSup."Severance Pay Indemnity" := HeuresSupEreg."Severance Pay Indemnity";
            HeuresSup."Objective Bonus" := HeuresSupEreg."Objective Bonus";
            HeuresSup."Seniority Bonus" := HeuresSupEreg."Seniority Bonus";
            HeuresSup."Retirement Bonus" := HeuresSupEreg."Retirement Bonus";
            HeuresSup."Other Back Pay" := HeuresSupEreg."Other Back Pay";
            HeuresSup."Transport Bonus" := HeuresSupEreg."Transport Bonus";



            HeuresSup."Overtime Days" := HeuresSupEreg."Overtime Days";
            HeuresSup."Overtime Amount" := HeuresSupEreg."Overtime Amount";


            HeuresSup.INSERT;
            HeuresSupEreg.DELETE;
        END;
    end;


    var
        RecGIndemnity: Record 55004;
        ReGParmRH: Record 5218;

}

