table 55015 "WDC Monthly Overtime Hours"
{
    DrillDownPageID = 55029;
    CaptionML = ENU = 'Monthly Overtime Hours', FRA = 'Heures sup. m';
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee."No." WHERE(Status = CONST(Active),
                                                Blocked = const(false));
            trigger OnValidate()
            begin
                Employee.GET("Employee No.");
                "Last Name" := Employee."Last Name";
                "First Name" := Employee."First Name";
                "Department Code" := Employee."Global Dimension 1 Code";
                "Folder Code" := Employee."Global Dimension 2 Code";
                "Employee Statistic Group" := Employee."Statistics Group Code";
            end;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            CaptionML = ENU = 'Line No.', FRA = 'N° Ligne';
        }
        field(3; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name', FRA = 'Nom usuel';
            Editable = false;
        }
        field(4; "First Name"; Text[60])
        {
            CaptionML = ENU = 'First Name', FRA = 'Prénom';
            Editable = false;
        }
        field(7; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
            NotBlank = true;

            trigger OnValidate()
            begin
                Rec."Payment Month" := Enum::"WDC Payroll Month".FromInteger(DATE2DMY(Rec."Posting Date", 2) - 1);
                Rec."Payment Year" := DATE2DMY(Rec."Posting Date", 3);
            end;
        }
        field(10; "Department Code"; Code[20])
        {
            CaptionML = ENU = 'Department Code', FRA = 'Code département';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(11; "Folder Code"; Code[20])
        {
            CaptionML = ENU = 'Folder Code', FRA = 'Code dossier';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Starting Time"; Time)
        {
            CaptionML = ENU = 'Start Time', FRA = 'Heure Début';

            trigger OnValidate()
            begin
                "Ending Time" := 0T;
                "Hours Number" := 0;
            end;
        }
        field(16; "Ending Time"; Time)
        {
            CaptionML = ENU = 'End Time', FRA = 'Heure Fin';
            trigger OnValidate()
            begin
                VALIDATE("Hours Number", (("Ending Time" - "Starting Time") / 3600000));
            end;
        }
        field(20; "Hours Number"; Decimal)
        {
            CaptionML = ENU = 'Hours Number', FRA = 'Nombre d''heures';
            DecimalPlaces = 3 : 3;
            InitValue = 0;

            trigger OnValidate()
            begin
                Dectarif := 0;

                HumanResourcesSetup.Get;
                IF EmploymentContract.GET("Employee No.") THEN
                    Regimesofwork.GET(EmploymentContract."Work Regime");


                DefaultIndemnitys.RESET;
                DefaultIndemnitys.SETRANGE("Emplymt. Contract Code", "Employee No.");
                DefaultIndemnitys.SETRANGE("Included in Overtime", TRUE);
                IF DefaultIndemnitys.Findset THEN
                    REPEAT
                        Dectarif := Dectarif + DefaultIndemnitys."Default amount";
                    UNTIL DefaultIndemnitys.NEXT = 0;

                EMP.RESET;
                EMP.SETRANGE("No.", "Employee No.");
                IF EMP.Findset THEN BEGIN
                    IF EMP."Employee type" = EMP."Employee type"::"Month based" THEN BEGIN
                        DecMntBase := EMP."Basis salary" + Dectarif;
                        "Unit Tariff" := EMP."Basis salary";
                        IF "Day Type" = "Day Type"::Regular THEN BEGIN
                            CASE "Overtime Rate" OF
                                1:
                                    "Line amount" := ((DecMntBase / Regimesofwork."Work Hours per month") * "Hours Number" * 1);
                                0.25:
                                    "Line amount" := ((EMP."Basis salary" / Regimesofwork."Work Hours per month") * "Hours Number" * 1.25);
                                0.5:
                                    "Line amount" := ((EMP."Basis salary" / Regimesofwork."Work Hours per month") * "Hours Number" * 1.5);
                                2:
                                    "Line amount" := ((EMP."Basis salary" / Regimesofwork."Work Hours per month") * "Hours Number" * 2);
                            END;
                        END;
                    END ELSE BEGIN
                        IF EMP."Employee type" = EMP."Employee type"::"Hour based" THEN BEGIN
                            //Regimesofwork.Findset;
                            DecMntBase := EMP."Basis salary" + (Dectarif / Regimesofwork."Work Hours per month");
                            "Unit Tariff" := EMP."Basis salary";
                            IF "Day Type" = "Day Type"::Regular THEN BEGIN
                                CASE "Overtime Rate" OF
                                    1:
                                        "Line amount" := (DecMntBase * "Hours Number") * 1;
                                    0.25:
                                        "Line amount" := (DecMntBase * "Hours Number") * 1.25;
                                    0.5:
                                        "Line amount" := (DecMntBase * "Hours Number") * 1.5;
                                    2:
                                        "Line amount" := (DecMntBase * "Hours Number") * 2;
                                END;
                            END;
                        END;
                    END;
                    // END;
                    // IF EMP.Findset THEN BEGIN
                    DecMntBase := EMP."Basis salary" + Dectarif;
                    IF EMP."Employee type" = EMP."Employee type"::"Month based" THEN BEGIN
                        IF ("Day Type".AsInteger() <> 0) AND ("Day Type".AsInteger() <> 3) AND ("Day Type".AsInteger() <> 5) THEN
                            "Line amount" := (((EMP."Basis salary")
                            / Regimesofwork."Work Hours per month") * "Hours Number") * "Overtime Rate"

                        ELSE

                            IF ("Day Type" = "Day Type"::Night) OR ("Day Type".AsInteger() = 5) THEN
                                "Line amount" := ((EMP."Basis salary" / Regimesofwork."Work Hours per month")
                             * Regimesofwork."Rate of Night" / 100 * "Hours Number")
                    END ELSE
                        IF EMP."Employee type" = EMP."Employee type"::"Hour based" THEN BEGIN
                            // Regimesofwork.Findset;
                            IF ("Day Type".AsInteger() <> 0) AND ("Day Type".AsInteger() <> 3) AND ("Day Type".AsInteger() <> 5) THEN
                                "Line amount" := (EMP."Basis salary" * "Hours Number")
                                 * HumanResourcesSetup."From Work day to Work hour" * "Overtime Rate"
                            ELSE
                                IF "Day Type" = "Day Type"::Night THEN
                                    "Line amount" := (EMP."Basis salary"
                          * Regimesofwork."Rate of Night" / 100 * "Hours Number")
                                ELSE
                                    IF "Day Type".AsInteger() = 5 THEN
                                        "Line amount" := (EMP."Basis salary" * "Hours Number");
                        END;
                END;
            end;
        }
        field(21; "Unit Tariff"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Unit Tariff', FRA = 'Tarif unitaire';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(22; "Line amount"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Line Amount', FRA = 'Montant ligne';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(70; "Day Type"; Enum "WDC Days Type")
        {
            CaptionML = ENU = 'Day Type', FRA = 'Type jour';

            trigger OnValidate()
            begin
                IF "Day Type" <> "Day Type"::Regular THEN
                    "Hour Type" := "Hour Type"::Overtime;
            end;
        }
        field(200; "System"; Boolean)
        {
            CaptionML = ENU = 'System', FRA = 'Système';
        }
        field(300; "Payment No."; Code[20])
        {
            CaptionML = ENU = 'Payment No.', FRA = 'N° paiement';
        }
        field(50001; "Heures sup. enreg."; Decimal)
        {
            CalcFormula = Sum("WDC Overtime hours recorded m"."Hours Number" WHERE("Employee No." = FIELD("Employee No."),
                                                                                   "Posting Date" = FIELD("Filter date"),
                                                                                   "Day Type" = CONST(Regular),
                                                                                   "Hour Type" = FILTER(Overtime)));
            CaptionML = ENU = 'Registered Overtime Hours', FRA = 'Heures sup. enregistrées';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Filter date"; Date)
        {
            CaptionML = ENU = 'Filter Date', FRA = 'Date filtre';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50003; "Overtime Rate"; Decimal)
        {
            CaptionML = ENU = 'Overtime Rate', FRA = 'Taux majoration';
            Editable = true;
        }
        field(50010; "Payment Month"; Enum "WDC Payroll Month")
        {
            CaptionML = ENU = 'Payment Month', FRA = 'Mois paiement';
        }
        field(50011; "Payment Year"; Integer)
        {
            CaptionML = ENU = 'Payment Year', FRA = 'Année paiement';
        }
        field(50012; Week; Integer)
        {
            CaptionML = ENU = 'Week', FRA = 'Semaine';
        }
        field(39001450; "Hour Type"; Enum "WDC Hours work Type")
        {
            CaptionML = ENU = 'Hour Type', FRA = 'Type heure';

            trigger OnValidate()
            begin
                IF "Hour Type" = "Hour Type"::Roulement THEN
                    "Day Type" := "Day Type"::Regular;
            end;
        }
        field(39001451; "Employee Statistic Group"; Code[30])
        {
            CaptionML = ENU = 'Employee Statistic Group', FRA = 'Groupe stat. employé';
            Editable = true;
            TableRelation = "Employee Statistics Group";
        }
        field(39001490; Fortnight; Enum "WDC Fortnight")
        {
            CaptionML = ENU = 'Fortnight', FRA = 'Quinzaine';
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Line No.", "Department Code", "Folder Code")
        {
            SumIndexFields = "Line amount", "Hours Number";
        }
        key(Key3; "Hour Type", "Employee No.", "Line No.", "Department Code", "Folder Code")
        {
            SumIndexFields = "Line amount", "Hours Number";
        }
    }


    var
        Employee: Record Employee;
        EMP: Record Employee;
        Regimesofwork: Record "WDC work Regimes";
        EmploymentContract: Record "Employment Contract";
        HumanResourcesSetup: Record "Human Resources Setup";
        Dectarif: Decimal;
        DefaultIndemnitys: Record "WDC Default Indemnities";
        DecMntBase: Decimal;
}

