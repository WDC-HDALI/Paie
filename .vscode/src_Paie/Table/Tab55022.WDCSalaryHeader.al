table 55022 "WDC Salary Header"
{
    CaptionML = ENU = 'Salary Header', FRA = 'En-tête salaire';
    DrillDownPageID = "WDC Payment List";
    LookupPageID = "WDC Payment List";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
        }
        field(2; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(5; Month; Enum "WDC Payroll Month")
        {
            CaptionML = ENU = 'Month', FRA = 'Mois';

            trigger OnValidate()
            var
                EntSal: Record 55024;
                HumanResSetup: Record "Human Resources Setup";
            begin
                HumanResSetup.GET;

                IF Month.AsInteger() < 12 THEN
                    Rec."Posting Date" := DMY2DATE(HumanResSetup."Payroll Calculation Date", Month.AsInteger() + 1, Year);

                IF ((Month.AsInteger() = 13) OR (Month.AsInteger() = 14)) AND ("Calculate Year" = Year) THEN BEGIN
                    EntSal.RESET;
                    EntSal.SETRANGE(Year, Year);
                    EntSal.SETFILTER(Month, '..11');
                    IF EntSal.Findlast() THEN
                        "Posting Date" := EntSal."Posting Date";
                END;
                Description := 'Paie ' + FORMAT(Month) + ' ' + FORMAT(Year);
            end;
        }
        field(6; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';

            trigger OnValidate()
            begin
                Rec."Calculate Year" := Year;
                Description := 'Paie ' + FORMAT(Month) + ' ' + FORMAT(Year);
            end;
        }
        field(10; "Paid days"; Decimal)
        {
            CaptionML = ENU = 'Paid days', FRA = 'Jours payés';

            trigger OnValidate()
            begin
                CLEAR(RegimeOfWork);
                IF RegimeOfWork.FINDFIRST THEN
                    REPEAT
                        RegimeOfWork.VALIDATE("Worked Day Per Month", "Paid days");
                        RegimeOfWork.MODIFY;
                    UNTIL RegimeOfWork.NEXT = 0;
            end;
        }
        field(11; "Worked days"; Decimal)
        {
            CaptionML = ENU = 'Worked days', FRA = 'Jours travaillés';
        }
        field(48; "Taxable indemnities(Not Gross)"; Decimal)
        {
            CaptionML = ENU = 'Taxable indemnities(Not Gross)', FRA = 'Indemnités imposables (Non Brut)';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC indemnities"."Real Amount" WHERE("No." = FIELD("No."),
                                                               Type = FILTER("Taxable (Not Subject to Social Security)"),
                                                               "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                               "Employee No." = FIELD("Employee No. filter"),
                                                               "Global Dimension 1" = FIELD("Global Dimension 1 Filter"),
                                                               "Global Dimension 2" = FIELD("Global Dimension 2 Filter"),
                                                               "Employee Statistic Group" = FIELD("Statistic Group Filter")));

        }
        field(50; "Total Basis Salary"; Decimal)
        {
            CaptionML = ENU = 'Salary basis total', FRA = 'Total base salaire';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Salary Lines"."Real basis salary" WHERE("No." = FIELD("No."),
                                                                        "Employee Posting Group" = FIELD("Employee Posting grp. filter"),
                                                                        "Employee No." = FIELD("Employee No. filter"),
                                                                        "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                        "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                        "Statistics Group Code" = FIELD("Statistic Group Filter")));

        }
        field(51; "Total Taxable indemnities"; Decimal)
        {
            CaptionML = ENU = 'Taxable indemnities total', FRA = 'Total indemnités imposables';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Salary Lines"."Taxable indemnities" WHERE("No." = FIELD("No."),
                                                                          "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                          "Employee No." = FIELD("Employee No. filter"),
                                                                          "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                          "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                          "Statistics Group Code" = FIELD("Statistic Group Filter")));

        }
        field(52; "Total Not Taxable indemnities"; Decimal)
        {
            CaptionML = ENU = 'Non Taxable indemnities total', FRA = 'Total indemnités non imposables';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Indemnities"."Real Amount" WHERE("No." = FIELD("No."),
                                                               Type = FILTER("Not Taxable"),
                                                               "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                               "Employee No." = FIELD("Employee No. filter"),
                                                               "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                               "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                               "Employee Statistic Group" = FIELD("Statistic Group Filter")));

        }
        field(53; "Mission expenses total"; Decimal)
        {
            AutoFormatType = 0;
            BlankNumbers = DontBlank;
            CaptionML = ENU = 'Mission expenses total', FRA = 'Total frais mission';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(54; "Non Taxable Soc. Contrib."; Decimal)
        {
            CaptionML = ENU = 'Non Taxable Soc. Contrib.', FRA = 'Cotisations soc. non imposables';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Social Contributions"."Real Amount : Employee" WHERE("No." = FIELD("No."),
                                                                                     "Deductible of taxable basis" = FILTER(TRUE),
                                                                                     "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                                     "Employee No." = FIELD("Employee No. filter"),
                                                                                     "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                                     "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                                     "Employee Statistic Group" = FIELD("Statistic Group Filter")));

        }
        field(55; "Taxable Soc. Contrib."; Decimal)
        {
            CaptionML = ENU = 'Taxable Soc. Contrib.', FRA = 'Cotisations soc. imposables';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Social Contributions"."Real Amount : Employee" WHERE("No." = FIELD("No."),
                                                                                     "Deductible of taxable basis" = FILTER(FALSE),
                                                                                     "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                                     "Employee No." = FIELD("Employee No. filter"),
                                                                                     "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                                     "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                                     "Employee Statistic Group" = FIELD("Statistic Group Filter")));
        }
        field(56; "Total Charges patronales"; Decimal)
        {
            CaptionML = ENU = 'Total Employer Charges', FRA = 'Total charges patronales';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Social Contributions"."Real Amount : Employer" WHERE("No." = FIELD("No."),
                                                                                     "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                                     "Employee No." = FIELD("Employee No. filter"),
                                                                                     "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                                     "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                                     "Employee Statistic Group" = FIELD("Statistic Group Filter")));
        }
        field(57; "Loans repaiment total"; Decimal)
        {
            CaptionML = ENU = 'Loans repayment total', FRA = 'Total remboursement prêts';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Loan & Advance Lines"."Line Amount" WHERE("Employee No." = FIELD("Employee No. filter"),
                                                                          "Payment No." = FIELD("No."),
                                                                          Month = FIELD(Month),
                                                                          Year = FIELD(Year),
                                                                          "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                          "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                          "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                          Type = CONST(Loan),
                                                                          "Employee Statistic Group" = FIELD("Statistic Group Filter")));

        }
        field(58; "Advances repaiment total"; Decimal)
        {
            CaptionML = ENU = 'Advances repayment total', FRA = 'Total remboursement avances';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Loan & Advance Lines"."Line Amount" WHERE("Employee No." = FIELD("Employee No. filter"),
                                                                          "Payment No." = FIELD("No."),
                                                                          Month = FIELD(Month),
                                                                          Year = FIELD(Year),
                                                                          "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                          "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                          "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                          Type = CONST(Advance),
                                                                          "Document type" = FIELD("Loan & Advance Type filter"),
                                                                          "Employee Statistic Group" = FIELD("Statistic Group Filter")));

        }
        field(59; "Taxes total"; Decimal)
        {
            CaptionML = ENU = 'Taxes total', FRA = 'Total impôts';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Salary Lines"."Taxe (Month)" WHERE("No." = FIELD("No."),
                                                                   "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                   "Employee No." = FIELD("Employee No. filter"),
                                                                   "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                   "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                   "Statistics Group Code" = FIELD("Statistic Group Filter")));

        }
        field(60; "Net salary total"; Decimal)
        {
            CaptionML = ENU = 'Net salary total', FRA = 'Total salaire net';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Salary Lines"."Net salary" WHERE("No." = FIELD("No."),
                                                                 "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                 "Employee No." = FIELD("Employee No. filter"),
                                                                 "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                 "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                 "Statistics Group Code" = FIELD("Statistic Group Filter")));
        }
        field(61; "Net salary cashed"; Decimal)
        {
            CaptionML = ENU = 'Net salary cashed', FRA = 'Salaire net encaissé';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Salary Lines"."Net salary cashed" WHERE("No." = FIELD("No."),
                                                                        "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                        "Employee No." = FIELD("Employee No. filter"),
                                                                        "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                        "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                        "Account No." = FIELD("Account No. Filter"),
                                                                        "Statistics Group Code" = FIELD("Statistic Group Filter")));
        }
        field(65; "Total Gross salary"; Decimal)
        {
            CaptionML = ENU = 'Total Gross salary', FRA = 'Total salaire brut';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Salary Lines"."Gross Salary" WHERE("No." = FIELD("No."),
                                                                   "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                   "Employee No." = FIELD("Employee No. filter"),
                                                                   "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                   "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                   "Statistics Group Code" = FIELD("Statistic Group Filter")));
        }
        field(66; "Total taxable"; Decimal)
        {
            CaptionML = ENU = 'Total taxable', FRA = 'Total imposable';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Salary Lines"."Taxable salary" WHERE("No." = FIELD("No."),
                                                                     "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                     "Employee No." = FIELD("Employee No. filter"),
                                                                     "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                     "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                     "Statistics Group Code" = FIELD("Statistic Group Filter")));
        }
        field(67; "Total Supp. Hours"; Decimal)
        {
            CaptionML = ENU = 'Total Overtime Hours', FRA = 'Total heures sup.';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Salary Lines"."Supp. hours" WHERE("No." = FIELD("No."),
                                                                  "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                  "Employee No." = FIELD("Employee No. filter"),
                                                                  "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                  "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                  "Statistics Group Code" = FIELD("Statistic Group Filter")));
        }
        field(70; Abcences; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Employee's days off Entry"."Quantity (Days)" WHERE("Posting month" = FIELD(Month),
                                                                                   "Posting year" = FIELD(Year),
                                                                                   "Employee No." = FIELD("Employee No. filter"),
                                                                                   "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                                   "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                                   "Global dimension 2" = FIELD("Global dimension 2 Filter")));
            CaptionML = ENU = 'Absences', FRA = 'Absences';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Holidays taken"; Decimal)
        {
            CaptionML = ENU = 'Days off', FRA = 'Congés pris';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("WDC Employee's days off Entry"."Quantity (Days)" WHERE("Posting month" = FIELD(Month),
                                                                                   "Posting year" = FIELD(Year),
                                                                                   "Employee No." = FIELD("Employee No. filter"),
                                                                                   "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                                   "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                                   "Global dimension 2" = FIELD("Global dimension 2 Filter")));
        }
        field(90; "Salary lines"; Integer)
        {
            CaptionML = ENU = 'Salary lines', FRA = 'Lignes salaire';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("WDC Salary Lines" WHERE("No." = FIELD("No."),
                                                      "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                      "Employee No." = FIELD("Employee No. filter"),
                                                      "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                      "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                      "Statistics Group Code" = FIELD("Statistic Group Filter")));

        }
        field(98; "Loan & Advance Type filter"; Code[20])
        {
            CaptionML = ENU = 'Loan & Advance Type filter', FRA = 'Filtre type prêt & avance';
            FieldClass = FlowFilter;
            TableRelation = "WDC Loan & Advance Type";
        }
        field(99; "Employee No. filter"; Code[20])
        {
            CaptionML = ENU = 'Employee No. filter', FRA = 'Filtre N° employé';
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(100; "Employee posting grp. filter"; Code[20])
        {
            CaptionML = ENU = 'Employee posting grp. filter', FRA = 'Filtre groupe compta employé';
            FieldClass = FlowFilter;
            TableRelation = "WDC Employee Posting Group";
        }
        field(101; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionML = ENU = 'Department Code', FRA = 'Code département';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(102; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionML = ENU = 'File Code', FRA = 'Code dossier';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(300; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series', FRA = 'Souches de n°';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(400; "Regulation Taxe"; Enum "WDC Regulation Taxe")
        {
            CaptionML = ENU = 'Taxes regulation', FRA = 'Réglementation fiscale';
            Editable = false;
        }
        field(900; "Calculate Year"; Integer)
        {
            CaptionML = ENU = 'Year of Calculate', FRA = 'Année calcul';

            trigger OnValidate()
            begin
                VALIDATE(Month);
            end;
        }

        field(50010; "Disable loan calculation"; Boolean)
        {
            CaptionML = ENU = 'Disable loan calculation', FRA = 'Désactiver calcul des prêts';
        }
        field(50011; "Tax Regulation"; Boolean)
        {
            CaptionML = ENU = 'Tax Regulation', FRA = 'Régul Impôt';
        }
        field(60000; "Monthes Number"; Enum "WDC type Retributions")
        {
            CaptionML = ENU = 'Monthes Number', FRA = 'Nombre de mois';
        }
        field(60001; "Salary lines Virement"; Integer)
        {
            CalcFormula = Count("WDC Salary Lines" WHERE("No." = FIELD("No."),
                                                      "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                      "Employee No." = FIELD("Employee No. filter"),
                                                      "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                      "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                      "Salary RIB" = FILTER(<> ''),
                                                      "Statistics Group Code" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Salary lines Virement', FRA = 'Lignes salaire virement';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60002; "Net salary cashed Virement"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Salary Lines"."Net salary cashed" WHERE("No." = FIELD("No."),
                                                                        "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                        "Employee No." = FIELD("Employee No. filter"),
                                                                        "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                        "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                        "Account No." = FIELD("Account No. Filter"),
                                                                        "Salary RIB" = FILTER(<> ''),
                                                                        "Statistics Group Code" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Net salary cashed', FRA = 'Salaire net encaissé';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(8099197; "Up to date"; Boolean)
        {
            CaptionML = ENU = 'Up to date', FRA = 'À jour';
            Editable = false;
        }
        field(8099198; "User ID"; Code[22])
        {
            CaptionML = ENU = 'User ID', FRA = 'ID utilisateur';
            Editable = false;
            TableRelation = User."User Name";
        }
        field(8099199; "Last Date Modified"; Date)
        {
            CaptionML = ENU = 'Last Date Modified', FRA = 'Dernière date modifiée';
            Editable = false;
        }
        field(8099200; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
        }
        field(39001456; "Account No. Filter"; Code[20])
        {
            CaptionML = ENU = 'Account No. Filter', FRA = 'Filtre N° compte';
            FieldClass = FlowFilter;
        }
        field(39001457; "Ajout en +"; Decimal)
        {
            CalcFormula = Sum("WDC Salary Lines"."Ajout  en +" WHERE("No." = FIELD("No."),
                                                                  "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                  "Employee No." = FIELD("Employee No. filter"),
                                                                  "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                  "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                  "Statistics Group Code" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Addition +', FRA = 'Ajout en +';
            DecimalPlaces = 3 : 3;
            FieldClass = FlowField;
        }
        field(39001458; "Report en -"; Decimal)
        {
            CaptionML = ENU = 'Report -', FRA = 'Report en -';
            CalcFormula = Sum("WDC Salary Lines"."Report en -" WHERE("No." = FIELD("No."),
                                                                  "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                  "Employee No." = FIELD("Employee No. filter"),
                                                                  "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                  "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                  "Statistics Group Code" = FIELD("Statistic Group Filter")));
            DecimalPlaces = 3 : 3;
            FieldClass = FlowField;
        }
        field(39001459; "Statistic Group Filter"; Code[20])
        {
            CaptionML = ENU = 'Statistic Group Filter', FRA = 'Filtre groupe statistique';
            FieldClass = FlowFilter;
            TableRelation = "Employee Statistics Group";
        }
        field(39001460; "Management Filter"; Code[20])
        {
            CaptionML = ENU = 'Management Filter', FRA = 'Filtre direction';
            TableRelation = "WDC Management";
        }
        field(39001461; "Filter Service"; Code[20])
        {
            CaptionML = ENU = 'Filter Service', FRA = 'Filtre service';
            TableRelation = "WDC Service";
        }
        field(39001462; "Filter Section"; Code[20])
        {
            CaptionML = ENU = 'Filter Section', FRA = 'Filtre section';
            TableRelation = "WDC Section";
        }
        field(39001463; "Fortnight Regim"; Code[20])
        {
            CaptionML = ENU = 'Fortnight Regime', FRA = 'Régime quinzaine';
            TableRelation = "WDC work Regimes".Code;
        }
        field(39001464; Fortnight; Enum "WDC Fortnight")
        {
            CaptionML = ENU = 'Fortnight', FRA = 'Quinzaine';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }


    trigger OnDelete()
    begin
        Lines.SETRANGE("No.", "No.");
        Lines.DELETEALL;

        Indemnities.SETRANGE("No.", "No.");
        Indemnities.DELETEALL;

        SocialContributions.SETRANGE("No.", "No.");
        SocialContributions.DELETEALL;

        LoanAdvanceLines.SETRANGE(Status, 0);
        LoanAdvanceLines.SETRANGE("Payment No.", "No.");
        LoanAdvanceLines.SETRANGE(Paid, FALSE);
        LoanAdvanceLines.DELETEALL;
    end;

    trigger OnInsert()
    begin
        HumanResSetup.GET;

        IF "No." = '' THEN BEGIN
            HumanResSetup.TESTFIELD("Paiment Nos.");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Paiment Nos.", WorkDate());
        END;

        "Paid days" := HumanResSetup."Paid days";
        "Worked days" := HumanResSetup."Worked days";
        RecSalaryHeader.SETCURRENTKEY("Posting Date", Month, "No.");
        RecSalaryHeader.SETRANGE(Month, 0, 12);
        IF RecSalaryHeader.Findlast() THEN BEGIN
            IF RecSalaryHeader.Month.AsInteger() < 11 THEN BEGIN
                Month := Enum::"WDC Payroll Month".FromInteger(RecSalaryHeader.Month.AsInteger() + 1);
                Year := RecSalaryHeader.Year;
                "Calculate Year" := Year;
            END
            ELSE BEGIN
                Month := Month::January;
                Year := RecSalaryHeader.Year + 1;
                "Calculate Year" := Year;
            END;
        END
        ELSE BEGIN
            Month := Enum::"WDC Payroll Month".FromInteger(DATE2DMY(WORKDATE, 2) - 1);
            Year := DATE2DMY(WORKDATE, 3);
            "Calculate Year" := Year;

            Description := 'Paie ' + FORMAT(Month) + ' ' + FORMAT(Year);

            "Last Date Modified" := WORKDATE;
            "User ID" := USERID;

            "Posting Date" := DMY2DATE(HumanResSetup."Payroll Calculation Date", Month.AsInteger() + 1, Year);
        end;
    end;

    trigger OnModify()
    begin
        Lines.SETRANGE("No.", "No.");
        IF Lines.Findfirst() THEN
            ERROR(errExistingLines);

        "Up to date" := FALSE;
        "Last Date Modified" := WORKDATE;
        "User ID" := USERID;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := WORKDATE;
        "User ID" := USERID;
    end;

    var

        HumanResSetup: Record "Human Resources Setup";
        Lines: Record "WDC Salary Lines";
        Indemnities: Record "WDC Indemnities";
        SocialContributions: Record "WDC Social Contributions";
        LoanAdvanceLines: Record "WDC Loan & Advance Lines";
        RecSalaryHeader: Record "WDC Posted Salary Header";
        errExistingLines: TextConst ENU = 'Salary header cannot be modified as there are some liked Salary lines.',
                                    FRA = 'L''entête de paie ne peut être modifié car il y a des lignes de paie associées.';
        RegimeOfWork: Record "WDC work Regimes";
        NoSeriesMgt: Codeunit "No. Series";
}

