table 55008 "WDC Occasional Hours"
{
    CaptionML = ENU = 'Occasional Hours', FRA = 'Heures occasionnelles';
    DrillDownPageID = "WDC Occasional Work Hours";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENG = 'Employee No.', FRA = 'N° salarié';
            NotBlank = true;
            TableRelation = Employee."No." WHERE(Status = CONST(Active));

            trigger OnValidate()
            begin
                Employee.GET("Employee No.");
                "Last Name" := Employee."Last Name";
                "First Name" := Employee."First Name";

                "Department Code" := Employee."Global Dimension 1 Code";
                "Folder Code" := Employee."Global Dimension 2 Code";
                Management := Employee.Management;
                service := Employee.Service;
                section := Employee.Section;
                HeuresSup.SETFILTER("Employee No.", Employee."No.");
                IF HeuresSup.FINDLAST() THEN
                    "Line No." := HeuresSup."Line No." + 1000
                ELSE
                    "Line No." := 1000;
            end;
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENG = 'Line No.', FRA = 'N° ligne';
        }
        field(3; "Last Name"; Text[50])
        {
            CaptionML = ENG = 'Last Name', FRA = 'Nom';
            Editable = false;
        }
        field(4; "First Name"; Text[50])
        {
            CaptionML = ENG = 'First Name', FRA = 'Prénom';
            Editable = false;
        }
        field(7; "Posting Date"; Date)
        {
            CaptionML = ENG = 'Posting Date', FRA = 'Date comptabilisation';
            NotBlank = true;

            trigger OnValidate()
            begin
                Rec."Payment Month" := Enum::"WDC Payroll Month".FromInteger(DATE2DMY("Posting Date", 2) - 1);
                Rec."Payment Year" := DATE2DMY("Posting Date", 3);
            end;
        }
        field(10; "Department Code"; Code[20])
        {
            CaptionML = ENG = 'Department Code', FRA = 'Code département';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(11; "Folder Code"; Code[20])
        {
            CaptionML = ENG = 'Project Code', FRA = 'Code projet';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Starting Time"; Time)
        {
            CaptionML = ENG = 'Starting Time', FRA = 'Heure Début';

            trigger OnValidate()
            begin
                "Ending Time" := 0T;
                "Hours Number" := 0;
                "Days Number" := 0;
            end;
        }
        field(16; "Ending Time"; Time)
        {
            CaptionML = ENG = 'Ending Time', FRA = 'Heure Fin';

            trigger OnValidate()
            var
                HeureDM: Time;
                HeureFM: Time;
                HeureDA: Time;
                HeureFA: Time;
                Nonworking: Boolean;
                Roul: Boolean;
                JourFree: Boolean;
                NbreHS: Decimal;
                calh: Codeunit 55024;
            begin
                IF (FORMAT("Starting Time") <> '') AND (FORMAT("Ending Time") <> '') THEN BEGIN
                    calh.CalcHJour("Employee No.", "Posting Date", HeureDM, HeureFM, HeureDA, HeureFA, Nonworking, Roul, JourFree);
                    NbreHS := 0;
                    //if
                    IF "Starting Time" > "Ending Time" THEN
                        Rec.VALIDATE("Hours Number", ROUND((("Ending Time" - 000000T) + (235959T - "Starting Time") + 1) / 3600000, 0.01))
                    ELSE
                        VALIDATE("Hours Number", ROUND(("Ending Time" - "Starting Time") / 3600000, 0.01))
                END
            end;
        }
        field(20; "Hours Number"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENG = 'Hours number', FRA = 'Nombre d''heures';
            DecimalPlaces = 3 : 3;
            InitValue = 0;

            trigger OnValidate()
            begin

                IF contratT.GET("Employee No.") THEN;
                IF Regim.GET(contratT."Work Regime") THEN;
                Employee.RESET;
                Employee.SETRANGE("No.", "Employee No.");
                IF Employee.FINDFIRST THEN
                    CASE Employee."Employee type".AsInteger() OF
                        0:
                            "Line amount" := Employee."Basis salary" * "Hours Number";
                        1:
                            "Line amount" := (Employee."Basis salary" / Regim."Work Hours per month") * "Hours Number";
                    END;
            end;
        }
        field(21; "Unit Tariff"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENG = 'Unit Tariff', FRA = 'Tarif unitaire';
            Editable = false;
        }
        field(22; "Line amount"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENG = 'Line amount', FRA = 'Montant ligne';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(27; "Regime of work"; Code[20])
        {
            CaptionML = ENG = 'Regime of work', FRA = 'Régime travail';
            Editable = false;
            TableRelation = "WDC work Regimes";
        }
        field(30; "Same week worked hour"; Decimal)
        {
            CalcFormula = Sum("WDC Occasional Hours Recorded"."Hours Number" WHERE("Employee No." = FIELD("Employee No."),
                                                                               Week = FIELD(Week),
                                                                               "Payment Year" = FIELD("Payment Year")));
            CaptionML = ENG = 'Same week worked hour', FRA = 'Heures travaillées la même semaine';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Overcharge line"; Integer)
        {
            CaptionML = ENG = 'Overcharge line', FRA = 'Ligne majoration';
            Editable = false;
            TableRelation = "WDC Overcharge of hour cost".Identifier WHERE("Regime of work" = FIELD("Regime of work"));
        }
        field(32; "Overcharge target line"; Integer)
        {
            CaptionML = ENG = 'Overcharge target line', FRA = 'Ligne cible majoration';
            Editable = false;
            TableRelation = "WDC Overcharge of hour cost".Identifier WHERE("Regime of work" = FIELD("Regime of work"));
        }
        field(70; "Day Type"; enum "WDC Days Type")
        {
            CaptionML = ENG = 'Day Type', FRA = 'Type jour travail';
        }
        field(80; "Days Number"; Decimal)
        {
            CaptionML = ENU = 'Days Number', FRA = 'Nombre jours';

            trigger OnValidate()
            begin
                InsertionJS("Employee No.");
            end;
        }
        field(100; "Filter date"; Date)
        {
            CaptionML = ENU = 'Filter Date', FRA = 'Date filtre';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(101; "Recorded Hours"; Decimal)
        {
            CaptionML = ENU = 'Recorded Hours', FRA = 'Heures enregistrées';
            CalcFormula = Sum("WDC Occasional Hours Recorded"."Hours Number" WHERE("Employee No." = FIELD("Employee No."),
                                                                               "Payment Year" = FIELD("Payment Year"),
                                                                               "Payment Month" = FIELD("Payment Month")));
            FieldClass = FlowField;
        }
        field(300; "Payment No."; Code[20])
        {
            CaptionML = ENU = 'Payment No.', FRA = 'N° paiement';
        }
        field(601; "Overtime Hours Recorded"; Decimal)
        {
            CaptionML = ENU = 'Overtime Hours Recorded', FRA = 'Heures sup. enregistrées';
            CalcFormula = Sum("WDC Overtime hours recorded m"."Hours Number" WHERE("Employee No." = FIELD("Employee No."),
                                                                                   "Posting Date" = FIELD("Filter date"),
                                                                                   "Day Type" = CONST(Regular),
                                                                                   "Hour Type" = FILTER(Overtime)));
            FieldClass = FlowField;
        }
        field(50003; "Overtime Rate"; Decimal)
        {
            CaptionML = ENG = 'Overtime Rate', FRA = 'Taux majoration';
            Editable = false;
        }
        field(50010; "Payment Month"; Enum "WDC Payroll Month")
        {
            CaptionML = ENG = 'Payment month', FRA = 'Mois de paiement';
        }
        field(50011; "Payment Year"; Integer)
        {
            CaptionML = ENG = 'Payment year', FRA = 'Année paiement';

        }
        field(50012; Week; Integer)
        {
            CaptionML = ENG = 'Week', FRA = 'Semaine';
        }
        field(50013; Management; Code[20])
        {
            CaptionML = ENG = 'Management', FRA = 'Direction';
        }
        field(50014; Service; Code[20])
        {
            CaptionML = ENG = 'Service', FRA = 'Service';
        }
        field(50015; Section; Code[20])
        {
            CaptionML = ENG = 'Section', FRA = 'Section';
        }
        field(50016; "Indemnity Day"; Decimal)
        {
            CaptionML = ENG = 'Indemnity Day', FRA = 'Jour indemnité';
        }
        field(50017; "Jours Travaille (Horaire)"; Decimal)
        {
            CaptionML = ENG = 'Worked Days (Hour based)', FRA = 'Jours travaillés (Horaire)';
        }
        field(50018; "Pulic Holiday Days"; Decimal)
        {
            CaptionML = ENG = 'Pulic Holiday Days', FRA = 'Jours fériés';
            trigger OnValidate()
            begin
                Dectarif := 0;
                Dectarif1 := 0;
                DectarifParJ := 0;
                DectarifHoraire := 0;
                RecGParamRH.GET();

                IF EmploymentContract.GET("Employee No.") THEN
                    EmploymentContract.CalcFields("Employee type");

                RecGRegWork.GET(EmploymentContract."Work Regime");
                RecGEmploy.GET("Employee No.");

                IF EmploymentContract."Employee type".AsInteger() = 1 THEN BEGIN
                    //--------Mensuel
                    RecGIndemnity.RESET;
                    RecGIndemnity.SETRANGE("Emplymt. Contract Code", "Employee No.");
                    RecGIndemnity.SETRANGE("Not Included Public Holidays", FALSE);
                    RecGIndemnity.SETRANGE("Included in Overtime", TRUE);
                    //RecGIndemnity.SETFILTER("Indemnity Code", '<>%1|<>%2', 'C.PAYE', 'J.SUPP');
                    RecGIndemnity.SETFILTER("Indemnity Code", '<>%1|<>%2', RecGParamRH."Paid Holiday Indemnity", RecGParamRH."Indem Overtime Days");
                    RecGIndemnity.SETFILTER(Type, '<>%1', 2);    //WDC0805
                    IF RecGIndemnity.FINDFIRST THEN
                        REPEAT
                            Dectarif := Dectarif + RecGIndemnity."Default amount";
                        UNTIL RecGIndemnity.NEXT = 0;
                    Dectarif := Dectarif / RecGRegWork."Worked Day Per Month";//WDC23deman de pr08
                    DecMntBase := RecGEmploy."Basis salary" + Dectarif;
                    "Pulic Holiday Amount" := (((Dectarif) + (RecGEmploy."Basis salary" / RecGRegWork."Worked Day Per Month")) * "Pulic Holiday Days");
                END ELSE BEGIN
                    //--------Horaire
                    RecGIndemnity.RESET;
                    RecGIndemnity.SETRANGE("Emplymt. Contract Code", "Employee No.");
                    RecGIndemnity.SETRANGE("Not Included Public Holidays", FALSE);
                    //RecGIndemnity.SETFILTER("Indemnity Code", '<>%1|<>%2', 'C.PAYE', 'J.SUPP');
                    RecGIndemnity.SETFILTER("Indemnity Code", '<>%1|<>%2', RecGParamRH."Paid Holiday Indemnity", RecGParamRH."Indem Overtime Days");
                    RecGIndemnity.SETRANGE("Included in Overtime", TRUE);
                    RecGIndemnity.SETFILTER(Type, '<>%1', 2);    //WDC0805
                    IF RecGIndemnity.FINDFIRST THEN
                        REPEAT
                            Dectarif := Dectarif + RecGIndemnity."Default amount";
                        UNTIL RecGIndemnity.NEXT = 0;
                    Dectarif := (Dectarif / RecGRegWork."Work Hours per month") * "Pulic Holiday Days" * 8;
                    DecMntBase := (RecGEmploy."Basis salary" * 8 * "Pulic Holiday Days") + Dectarif;
                    "Pulic Holiday Amount" := DecMntBase;
                END;

            end;
        }
        field(50019; "Pulic Holiday Amount"; Decimal)
        {
            CaptionML = ENG = 'Pulic Holiday Amount', FRA = 'Montant jours fériés';
            Editable = true;
        }

        field(50022; "P-Encouragement"; Decimal)
        {
            CaptionML = ENG = 'Encouragement Bonus', FRA = 'P-Encouragement';
        }
        field(50023; "P-Bonus"; Decimal)
        {
            CaptionML = ENG = 'Bonus', FRA = 'P-Bonus';
        }
        field(50024; "Team Bonus"; Decimal)
        {
            CaptionML = ENG = 'Team Bonus', FRA = 'P-Equipe';
        }
        field(50025; "Exceptional Bonus"; Decimal)
        {
            CaptionML = ENG = 'Exceptional Bonus', FRA = 'P-Exceptionnel';
        }
        field(50026; "Competence Bonus"; Decimal)
        {
            CaptionML = ENG = 'Competence Bonus', FRA = 'P-Comptétence';
        }
        field(50027; "Overtime Houres Pay"; Decimal)
        {
            CaptionML = ENG = 'Overtime Hours Pay', FRA = 'P-Heures Sup.';
        }
        field(50028; "Mission Pay"; Decimal)
        {
            CaptionML = ENG = 'Mission Pay', FRA = 'P-Mission';
        }
        field(50029; "Assignment Pay"; Decimal)
        {
            CaptionML = ENG = 'Assignment Pay', FRA = 'P-Affectation';
        }
        field(50030; "Position Pay"; Decimal)
        {
            CaptionML = ENG = 'Position Pay', FRA = 'P-Poste';
        }
        field(50031; "Back Pay"; Decimal)
        {
            CaptionML = ENG = 'Back Pay', FRA = 'P-Rappel';
        }
        field(50032; "Productivity Bonus"; Decimal)
        {
            CaptionML = ENG = 'Productivity Bonus', FRA = 'P-Productivité';
        }
        field(50033; "Quality Coordination Bonus"; Decimal)
        {
            CaptionML = ENG = 'Quality Coordination Bonus', FRA = 'P-Coordination Qualité';
        }
        field(50034; "13th Month Pay"; Decimal)
        {
            CaptionML = ENG = '13th Month Pay', FRA = 'P-13ème Mois';
        }
        field(50036; "Quarterly Bonus"; Decimal)
        {
            CaptionML = ENG = 'Quarterly Bonus', FRA = 'P-Trimestriel';
        }
        field(50037; "End of Contract Balance Amount"; Decimal)
        {
            CaptionML = ENG = 'End of Contract Balance Amount', FRA = 'Solde de tout compte';

        }
        field(50038; "Gratification Aid"; Decimal)
        {
            CaptionML = ENG = 'Gratification Aid', FRA = 'Aide à la Gratification';
        }
        field(50039; Gratification; Decimal)
        {
            CaptionML = ENG = 'Gratification', FRA = 'Gratification';
        }
        field(50040; "Severance Pay Indemnity"; Decimal)
        {
            CaptionML = ENG = 'Departure Indemnity', FRA = 'Ind.Départ';
        }
        field(50041; "Objective Bonus"; Decimal)
        {
            CaptionML = ENG = 'Objective Bonus', FRA = 'P-Objectif';
        }
        field(50042; "Seniority Bonus"; Decimal)
        {
            CaptionML = ENG = 'Seniority Bonus', FRA = 'P-Ancienneté';
        }
        field(50043; "Retirement Bonus"; Decimal)
        {
            CaptionML = ENG = 'Retirement Bonus', FRA = 'P-Retraite';
        }
        field(50044; "Other Back Pay"; Decimal)
        {
            CaptionML = ENG = 'Other Back pay', FRA = 'Rappel-PAutre';
        }
        field(50045; "Transport Bonus"; Decimal)
        {
            CaptionML = ENG = 'Transport Bonus', FRA = 'P-Transport';
        }

        field(50052; "Overtime Days"; Decimal)
        {
            CaptionML = ENG = 'Overtime Days', FRA = 'Jour Sup';
            trigger OnValidate()
            begin
                Dectarif := 0;
                Dectarif1 := 0;
                DectarifParJ := 0;
                DectarifHoraire := 0;
                RecGParamRH.GET();
                EmploymentContract.GET("Employee No.");
                RecGRegWork.GET(EmploymentContract."Work Regime");      //3006
                RecGEmploy.GET("Employee No.");
                EmploymentContract.CalcFields("Employee type");
                IF EmploymentContract."Employee type".AsInteger() = 1 THEN BEGIN
                    //--------Mensuel
                    RecGIndemnity.RESET;
                    RecGIndemnity.SETRANGE("Emplymt. Contract Code", "Employee No.");
                    RecGIndemnity.SETRANGE("Included in Overtime", TRUE);
                    RecGIndemnity.SETRANGE("Includes Extra Days", TRUE);
                    IF RecGIndemnity.FINDFIRST THEN BEGIN
                        REPEAT
                            Dectarif := Dectarif + RecGIndemnity."Basis amount";
                        UNTIL RecGIndemnity.NEXT = 0;
                    END;
                END ELSE BEGIN
                    //-------------Horaire
                    RecGEmploy.GET("Employee No.");
                    RecGIndemnity.RESET;
                    RecGIndemnity.SETRANGE("Emplymt. Contract Code", "Employee No.");
                    RecGIndemnity.SETRANGE("Included in Overtime", TRUE);
                    RecGIndemnity.SETRANGE("Includes Extra Days", TRUE);
                    IF RecGIndemnity.FINDFIRST THEN BEGIN
                        REPEAT
                            Dectarif := Dectarif + RecGIndemnity."Basis amount";
                        UNTIL RecGIndemnity.NEXT = 0;
                    END;
                END;

                DecMntBase := RecGEmploy."Basis salary" + Dectarif;
                //--------Mensuel
                IF RecGEmploy."Employee type" = RecGEmploy."Employee type"::"Month based" THEN BEGIN
                    "Overtime Amount" := ((DecMntBase / RecGRegWork."Worked Day Per Month") * "Overtime Days");
                END ELSE BEGIN
                    //--------Horaire
                    IF RecGEmploy."Employee type".AsInteger() = 2 THEN BEGIN
                        "Overtime Amount" := (((RecGEmploy."Basis salary" * RecGRegWork."Work Hours per month") + Dectarif) / RecGRegWork."Worked Day Per Month") * "Overtime Days";

                    END;
                END;
            end;
        }
        field(63; "Overtime Amount"; Decimal)
        {
            CaptionML = ENG = 'Overtime Amount', FRA = 'Montant J.Sup';
        }
        field(39001490; Fortnight; Enum "WDC Fortnight")
        {
            CaptionML = ENG = 'Fortnight', FRA = 'Quinzaine';
        }
        field(39001491; "Productivité"; Decimal)
        {
            CaptionML = ENG = 'Productivity', FRA = 'Productivité';
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Line No.", "Department Code", "Folder Code")
        {
            Clustered = true;
            SumIndexFields = "Line amount", "Hours Number";
        }
        key(Key2; "Line No.")
        {
        }
    }

    var
        HeuresSup: Record "WDC Occasional Hours";
        Employee: Record 5200;
        contratT: Record 5211;
        Regim: Record "WDC work Regimes";
        RecGParamRH: Record 5218;
        RecGEmploy: Record 5200;
        RecGRegWork: Record "WDC work Regimes";
        EmploymentContract: Record 5211;
        Dectarif: Decimal;
        RecGIndemnity: Record "WDC Default Indemnities";
        DecMntBase: Decimal;
        Dectarif1: Decimal;
        DectarifHoraire: Decimal;
        DectarifParJ: Decimal;
        MontantCong: Decimal;
        IndemCong: Record "WDC Default Indemnities";
        Text001: TextConst ENU = 'Check employee contract, information missing!! Employee ID %1',
                           FRA = 'Vérifier le contrat de l''employé,informations manquantes !! matricule %1';

    procedure InsertionJS(EmployeeNo: Code[20])
    begin
        //>>WDC
        MontantCong := 0;
        Dectarif := 0;
        Dectarif1 := 0;
        DectarifParJ := 0;
        DectarifHoraire := 0;
        DecMntBase := 0;
        RecGParamRH.GET;
        IF ("Days Number" <> 0) THEN BEGIN
            CLEAR(IndemCong);
            IndemCong.SETRANGE("Emplymt. Contract Code", "Employee No.");
            IndemCong.SETRANGE("Indemnity Code", RecGParamRH."Indem Overtime Days");
            IF IndemCong.FINDSET THEN
                IndemCong.DELETE;

            IF EmploymentContract.GET("Employee No.") THEN;
            RecGRegWork.GET(EmploymentContract."Work Regime");
            RecGEmploy.GET("Employee No.");

            EmploymentContract.CalcFields("Employee type");
            IF EmploymentContract."Employee type".AsInteger() = 1 THEN BEGIN
                //--------Mensuel

                RecGIndemnity.RESET;
                RecGIndemnity.SETRANGE("Emplymt. Contract Code", EmployeeNo);
                RecGIndemnity.SETRANGE("Not Included Public Holidays", FALSE);
                RecGIndemnity.SETRANGE("Included in Overtime", TRUE);
                RecGIndemnity.SETFILTER("Indemnity Code", '<>%1|<>%2', RecGParamRH."Paid Holiday Indemnity", RecGParamRH."Indem Overtime Days");
                RecGIndemnity.SETFILTER(Type, '<>%1', 2);    //WDC0805
                IF RecGIndemnity.FINDFIRST THEN
                    REPEAT
                        Dectarif := Dectarif + RecGIndemnity."Default amount";
                    UNTIL RecGIndemnity.NEXT = 0;
                Dectarif := Dectarif / RecGRegWork."Worked Day Per Month"; //WDC2308


                DecMntBase := RecGEmploy."Basis salary" + Dectarif;
                MontantCong := (((Dectarif) + (RecGEmploy."Basis salary" / RecGRegWork."Worked Day Per Month")) * "Days Number");
            END;
            IndemCong.INIT;
            IndemCong."Emplymt. Contract Code" := "Employee No.";
            IndemCong.VALIDATE("Indemnity Code", RecGParamRH."Indem Overtime Days");
            IndemCong."Days Number" := "Days Number";
            IndemCong.VALIDATE("Default amount", MontantCong);
            IndemCong.INSERT;
        END ELSE BEGIN
            CLEAR(IndemCong);
            IndemCong.SETRANGE("Emplymt. Contract Code", "Employee No.");
            IndemCong.SETRANGE("Indemnity Code", RecGParamRH."Indem Overtime Days");
            IF IndemCong.FINDSET THEN
                IndemCong.DELETE;
        END;
    end;
}

