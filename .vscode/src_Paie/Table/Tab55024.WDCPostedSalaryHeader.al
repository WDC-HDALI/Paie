table 55024 "WDC Posted Salary Header"
{
    CaptionML = ENU = 'Posted Salary Header', FRA = 'En-têtes salaire enregistrés';
    DrillDownPageID = 55044;
    LookupPageID = 55044;

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
        }
        field(6; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';
        }
        field(10; "Paid days"; Decimal)
        {
            CaptionML = ENU = 'Paid days', FRA = 'Jours payés';
        }
        field(11; "Worked days"; Decimal)
        {
            CaptionML = ENU = 'Worked days', FRA = 'Jours travaillés';
        }
        field(48; "Taxable indemnities Not Gross"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Rec. Indemnities"."Real Amount" WHERE("No." = FIELD("No."),
                                                                      Type = FILTER("Taxable (Not Subject to Social Security)"),
                                                                      "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                      "Employee No." = FIELD("Employee No. filter"),
                                                                      "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                      "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                      "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Indemnités imposables (Non Brut)', FRA = 'Indemnités imposables (Non Brut)';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Total Basis Salary"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Posted Salary Lines"."Real basis salary" WHERE("No." = FIELD("No."),
                                                                             "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                             "Employee No." = FIELD("Employee No. filter"),
                                                                             "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                             "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                             "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Total Basis Salary', FRA = 'Base salariale totale';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Total Taxable indemnities"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Posted Salary Lines"."Taxable indemnities" WHERE("No." = FIELD("No."),
                                                                               "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                               "Employee No." = FIELD("Employee No. filter"),
                                                                               "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                               "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                               "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Total Taxable indemnities', FRA = 'Indemnités imposables totales';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                "Total Taxable indemnities" := ROUND("Total Taxable indemnities", 0.001);
                MODIFY;
            end;
        }
        field(52; "Total Not Taxable indemnities"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Rec. Indemnities"."Real Amount" WHERE("No." = FIELD("No."),
                                                                      Type = FILTER("Not Taxable"),
                                                                      "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                      "Employee No." = FIELD("Employee No. filter"),
                                                                      "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                      "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                      "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Total Not Taxable indemnities', FRA = 'Indemnités non imposables totales';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "Mission expenses total"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Mission expenses total', FRA = 'Frais de mission totaux';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(54; "Non Taxable Soc. Contrib."; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Rec. Social Contributions"."Real Amount : Employee" WHERE("No." = FIELD("No."),
                                                                                          "Deductible of taxable basis" = FILTER(TRUE),
                                                                                          "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                                          "Employee No." = FIELD("Employee No. filter"),
                                                                                          "Globlal dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                                          "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                                          "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Non Taxable Soc. Contrib.', FRA = 'Contributions sociales non imposables';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(55; "Taxable Soc. Contrib."; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Rec. Social Contributions"."Real Amount : Employee" WHERE("No." = FIELD("No."),
                                                                                          "Deductible of taxable basis" = FILTER(FALSE),
                                                                                          "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                                          "Employee No." = FIELD("Employee No. filter"),
                                                                                          "Globlal dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                                          "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                                          "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Taxable Soc. Contrib.', FRA = 'Tranche d''imposition imposables';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(56; "Total Employer Contributions"; Decimal)
        {
            CaptionML = ENU = 'Total Employer Contributions', FRA = 'Total Charges patronales';
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Rec. Social Contributions"."Real Amount : Employer" WHERE("No." = FIELD("No."),
                                                                                          "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                                          "Employee No." = FIELD("Employee No. filter"),
                                                                                          "Globlal dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                                          "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                                          "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(57; "Loans repaiment total"; Decimal)
        {

            CalcFormula = Sum("WDC Loan & Advance Lines"."Line Amount" WHERE("Payment No." = FIELD("No."),
                                                                          Type = FILTER(Loan),
                                                                          "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                          "Employee No." = FIELD("Employee No. filter"),
                                                                          "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                          "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                          "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Loans repaiment total', FRA = 'Remboursement prêts total';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(58; "Advances repaiment total"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Loan & Advance Lines"."Line Amount" WHERE("Payment No." = FIELD("No."),
                                                                          Type = FILTER(Advance),
                                                                          "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                          "Employee No." = FIELD("Employee No. filter"),
                                                                          "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                          "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                          "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Advances repaiment total', FRA = 'Remboursement avances total';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Taxes total"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Posted Salary Lines"."Taxe (Month)" WHERE("No." = FIELD("No."),
                                                                        "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                        "Employee No." = FIELD("Employee No. filter"),
                                                                        "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                        "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                        "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Taxes total', FRA = 'Total impôts';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Net salary total"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Posted Salary Lines"."Net salary" WHERE("No." = FIELD("No."),
                                                                      "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                      "Employee No." = FIELD("Employee No. filter"),
                                                                      "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                      "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                      "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Net salary total', FRA = 'Salaire net total';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Net salary cashed"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Posted Salary Lines"."Net salary cashed" WHERE("No." = FIELD("No."),
                                                                             "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                             "Employee No." = FIELD("Employee No. filter"),
                                                                             "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                             "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                             "Num Compte" = FIELD("Account No. filter"),
                                                                             "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'cashed Net salary', FRA = 'Salaire net encaissé';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Total Gross salary"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Posted Salary Lines"."Gross Salary" WHERE("No." = FIELD("No."),
                                                                        "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                        "Employee No." = FIELD("Employee No. filter"),
                                                                        "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                        "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                        "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Total Gross salary', FRA = 'Salaire brut total';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "Total taxable"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Posted Salary Lines"."Taxable salary" WHERE("No." = FIELD("No."),
                                                                          "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                          "Employee No." = FIELD("Employee No. filter"),
                                                                          "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                          "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                          "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Total taxable', FRA = 'Total imposable';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(67; "Total Supp. Hours"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Posted Salary Lines"."Supp. hours" WHERE("No." = FIELD("No."),
                                                                       "Employee No." = FIELD("Employee No. filter"),
                                                                       Month = FIELD(Month),
                                                                       Year = FIELD(Year),
                                                                       "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                       "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Total Supp. Hours', FRA = 'Total heures supplémentaires';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; Abcences; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = - Sum("WDC Employee's days off Entry"."Quantity (Days)" WHERE("Posting Month" = FIELD(Month),
                                                                                    "Posting year" = FIELD(Year),
                                                                                    "Employee No." = FIELD("Employee No. filter"),
                                                                                    "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                                    "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                                    "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                                    "Line type" = FILTER("Not Paid" | "1/2 Paid"),
                                                                                    "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Absences', FRA = 'Absences';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Holidays taken"; Decimal)
        {
            CalcFormula = - Sum("WDC Employee's days off Entry"."Quantity (Days)" WHERE("Posting month" = FIELD(Month),
                                                                                    "Posting year" = FIELD(Year),
                                                                                    "Employee No." = FIELD("Employee No. filter"),
                                                                                    "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                                    "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                                    "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                                    "Line type" = FILTER("Day off Consumption"),
                                                                                    "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Holidays taken', FRA = 'Congés pris';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Salary lines"; Integer)
        {
            CalcFormula = Count("WDC Posted Salary Lines" WHERE("No." = FIELD("No."),
                                                           "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                           "Employee No." = FIELD("Employee No. filter"),
                                                           "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                           "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                           "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            CaptionML = ENU = 'Salary lines', FRA = 'Lignes salaire';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99; "Employee No. filter"; Code[20])
        {
            CaptionML = ENU = 'Employee No. filter', FRA = 'Filtre N° employé';
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(100; "Employee posting grp. filter"; Code[20])
        {
            CaptionML = ENU = 'Employee posting grp. filter', FRA = 'Filtre groupe compta. employé';
            FieldClass = FlowFilter;
            TableRelation = "WDC Employee Posting Group";
        }
        field(101; "Global dimension 1 Filter"; Code[20])
        {
            CaptionML = ENU = 'Global dimension 1 Filter', FRA = 'Filtre Département';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(102; "Global dimension 2 Filter"; Code[20])
        {
            CaptionML = ENU = 'Global dimension 2 Filter', FRA = 'Filtre Dossier';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(110; "Integrated in accounting"; Boolean)
        {
            CaptionML = ENU = 'Integrated in accounting', FRA = 'Intégré en comptabilité';
            Editable = true;
        }
        field(300; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series', FRA = 'Souches de n°';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(400; "Regulation Taxe"; Enum "WDC Regulation Taxe")
        {
            CaptionML = ENU = 'Regulation Taxe', FRA = 'Régime d''imposition';
            Editable = false;
        }
        field(600; "Bonus Type"; Code[20])
        {
            CaptionML = ENU = 'Bonus Type', FRA = 'Type Prime';
        }
        field(900; "Calculate Year"; Integer)
        {
            CaptionML = ENU = 'Calculate Year', FRA = 'Année de calcul';
        }
        field(50040; "Caisse fond social"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("WDC Posted Salary Lines"."Amount retained cash FS" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Social fund box', FRA = 'Caisse fond social';
        }
        field(8099200; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
        }
        field(39001456; "Account No. filter"; Code[20])
        {
            CaptionML = ENU = 'Account No. filter', FRA = 'Filtre N° compte';
            FieldClass = FlowFilter;
        }
        field(39001457; "Ajout en +"; Decimal)
        {
            CaptionML = ENU = 'Addition +', FRA = 'Ajout en +';
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Posted Salary Lines"."Ajout  en +" WHERE("No." = FIELD("No."),
                                                                       "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                       "Employee No." = FIELD("Employee No. filter"),
                                                                       "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                       "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                       "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(39001458; "Report en -"; Decimal)
        {
            CaptionML = ENU = 'Report -', FRA = 'Report en -';
            AutoFormatType = 0;
            CalcFormula = Sum("WDC Posted Salary Lines"."Report en -" WHERE("No." = FIELD("No."),
                                                                       "Employee Posting Group" = FIELD("Employee posting grp. filter"),
                                                                       "Employee No." = FIELD("Employee No. filter"),
                                                                       "Global dimension 1" = FIELD("Global dimension 1 Filter"),
                                                                       "Global dimension 2" = FIELD("Global dimension 2 Filter"),
                                                                       "Employee Statistic Group" = FIELD("Statistic Group Filter")));
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = FlowField;
        }
        field(39001459; "Statistic Group Filter"; Code[20])
        {
            CaptionML = ENU = 'Statistic Group Filter', FRA = 'Filtre groupe statistique';
            FieldClass = FlowFilter;
            TableRelation = "Employee Statistics Group";
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
        key(Key2; Year, Month, "No.")
        {
        }
        key(Key3; "Posting Date", "No.")
        {
        }
        key(Key4; "Posting Date", Month, "No.")
        {
        }
    }


    trigger OnDelete()
    var
        lUserSetup: Record "User Setup";
        lText001: TextConst ENU = 'Saved table cannot be deleted',
                            FRA = 'Table enregistrée ne peut pas être supprimée';
    begin
        lUserSetup.get;
        if not lUserSetup."Allow Cancel Posted Payroll" then
            ERROR(lText001);
    end;

}

