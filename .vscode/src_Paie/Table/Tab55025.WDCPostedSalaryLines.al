table 55025 "WDC Posted Salary Lines"
{
    CaptionML = ENU = 'Rec. Salary Lines', FRA = 'Lignes de paie';
    DrillDownPageID = 55045;
    LookupPageID = 55045;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
            TableRelation = "WDC Posted Salary Header";
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° Employé';
            Editable = true;
            TableRelation = Employee;
        }
        field(3; Name; Text[100])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';
            Editable = false;
        }
        field(4; "Employee Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe compta. employé';
            Editable = true;
            TableRelation = "WDC Employee Posting Group";
        }
        field(5; "Regime of work"; Code[20])
        {
            CaptionML = ENU = 'Regime of work', FRA = 'Régime travail';
            TableRelation = "WDC work Regimes";
        }
        field(6; "Emplymt. Contract Code"; Code[20])
        {
            CaptionML = ENU = 'Emplymt. Contract Code', FRA = 'Code contrat employé';
            TableRelation = "Employment Contract";
        }
        field(7; "Bank Account Code"; Code[20])
        {
            CaptionML = ENU = 'Bank Account No. ', FRA = 'N° Compte bancaire';
            TableRelation = "WDC Employee Bank Account".Code WHERE("Employee No." = FIELD("Employee No."));
        }
        field(8; "Employee type"; Enum "WDC Employee type")
        {
            CaptionML = ENU = 'Employee type', FRA = 'Type d''employé';
            Editable = false;
        }
        field(10; Description; Text[60])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(11; Note; Decimal)
        {
            CaptionML = ENU = 'Note', FRA = 'Note';
            DecimalPlaces = 2 : 2;
        }
        field(12; Percent; Decimal)
        {
            CaptionML = ENU = 'Percent', FRA = 'Pourcentage';
            DecimalPlaces = 2 : 2;
        }
        field(13; "Worked months"; Decimal)
        {
            CaptionML = ENU = 'Worked months', FRA = 'Mois travaillés';
        }
        field(20; Month; Enum "WDC Payroll Month")
        {
            CaptionML = ENU = 'Month', FRA = 'Mois';
        }
        field(21; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';
        }
        field(22; Quarter; Enum "WDC Quarter")
        {
            CaptionML = ENU = 'Quarter', FRA = 'Trimestre';
        }
        field(23; "Days off remaining"; Decimal)
        {
            CaptionML = ENU = 'Days off remaining', FRA = 'Congés restants';
            Editable = false;
            FieldClass = Normal;
        }
        field(24; "Days off balacement"; Decimal)
        {
            CaptionML = ENU = 'Days off balacement', FRA = 'Congé soldé';
            Editable = false;
        }
        field(25; Absences; Decimal)
        {
            CaptionML = ENU = 'Absences', FRA = 'Absences';
            FieldClass = Normal;
        }
        field(26; "Adjustment of absences"; Decimal)
        {
            CaptionML = ENU = 'Adjustment of absences', FRA = 'Ajustement des absences';
        }
        field(27; "Days off"; Decimal)
        {
            CaptionML = ENU = 'Days off', FRA = 'Congés';
        }
        field(28; "Assiduity (Paid days)"; Decimal)
        {
            CaptionML = ENU = 'Assiduity (Paid days)', FRA = 'Assiduité (Jours payés)';
        }
        field(29; "Assiduity (Worked days)"; Decimal)
        {
            CaptionML = ENU = 'Assiduity (Worked days)', FRA = 'Assiduité (Jours travaillés)';
        }
        field(30; "Holiday Taken"; Decimal)
        {
            CaptionML = ENU = 'Holiday Taken', FRA = 'Congé Pris';
        }
        field(35; "Worked hours"; Decimal)
        {
            CaptionML = ENU = 'Worked hours', FRA = 'Heures travaillées';
            FieldClass = Normal;
        }
        field(36; "Basis hours"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Basis hours', FRA = 'Heures de base';
            Editable = false;
            FieldClass = Normal;
        }
        field(37; "Amount Days Off balacement"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Amount Days Off balacement', FRA = 'Montant congé soldé';
        }
        field(38; "Assiduity (days off balacement"; Decimal)
        {
            CaptionML = ENU = 'Assiduity (Days off balacement)', FRA = 'Assiduité (Congé soldé)';
        }
        field(39; "Hours off Balacement"; Decimal)
        {
            CaptionML = ENU = 'Hours off Balacement', FRA = 'Heure congé soldé';
            DecimalPlaces = 3 : 3;
        }
        field(40; "Basis Salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Basis salary', FRA = 'Salaire base';
            DecimalPlaces = 3 : 3;
        }
        field(41; "Taxable indemnities"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxable indemnities', FRA = 'Indemnités imposables';
            DecimalPlaces = 3 : 3;
            FieldClass = Normal;
        }
        field(42; "Supp. hours"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Supp. hours', FRA = 'Heures supp.';
            DecimalPlaces = 3 : 3;
            FieldClass = Normal;
        }
        field(43; "Real basis salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Real basis salary', FRA = 'Salaire réel de base';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(44; "Gross Salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Gross Salary', FRA = 'Salaire brut';
            DecimalPlaces = 3 : 3;
        }
        field(45; "Non Taxable Soc. Contrib."; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Non Taxable Soc. Contrib.', FRA = 'Cotisations non imposables';
            DecimalPlaces = 3 : 3;
            FieldClass = Normal;
        }
        field(47; "Gross Salary (Without AV)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Gross Salary (Without AV)', FRA = 'Salaire brut (Sans AV)';
            DecimalPlaces = 3 : 3;
        }
        field(48; "Indm. Impo. (N. Déd. Cot. Sc)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Indemnities Taxable (Non Ded. Social Contr.)', FRA = 'Indemnités imposables (Non déduct. Cotis. soc.)';
            DecimalPlaces = 3 : 3;
        }
        field(49; "Gross Salary (Without AV) PR"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Gross Salary (Without AV) PR', FRA = 'Salaire brut (Sans AV) PR';
            DecimalPlaces = 3 : 3;
        }
        field(50; "Taxable salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxable salary', FRA = 'Salaire imposable';
            DecimalPlaces = 3 : 3;
        }
        field(55; "Deduction Family chief"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Deduction Family chief', FRA = 'Déduction chef famille';
            DecimalPlaces = 3 : 3;
        }
        field(56; "Deduction Loaded child"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Deduction Loaded child', FRA = 'Déduction enfant en charge';
            DecimalPlaces = 3 : 3;
        }
        field(57; "Deduction Prof. expenses"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Deduction Prof. expenses', FRA = 'Déduction frais professionnels';
            DecimalPlaces = 3 : 3;
        }
        field(60; "Real taxable"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Real taxable', FRA = 'Imposable réel';
            DecimalPlaces = 3 : 3;
        }
        field(65; "Total taxable rec."; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Total taxable rec.', FRA = 'Total imposable rec.';
            DecimalPlaces = 3 : 3;
        }
        field(66; "Rec. payments"; Integer)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Rec. payments', FRA = 'Paiements reçus';
        }
        field(67; "Real taxable (Year)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Real taxable (Year)', FRA = 'Imposable réel (Année)';
            DecimalPlaces = 3 : 3;
        }
        field(70; "Taxe (Year)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxe (Year)', FRA = 'Impôts (Année)';
            DecimalPlaces = 3 : 3;
        }
        field(71; "Total taxes rec."; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Total taxes rec.', FRA = 'Total Impôts rec.';
            DecimalPlaces = 3 : 3;
        }
        field(72; "Taxe (Month)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxe (Month)', FRA = 'Impôts (Mois)';
            DecimalPlaces = 3 : 3;
        }
        field(80; "Non Taxable indemnities"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Non Taxable indemnities', FRA = 'Indemnités non imposables';
            DecimalPlaces = 3 : 3;
            FieldClass = Normal;
        }
        field(81; "Taxable Soc. Contrib."; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxable Soc. Contrib.', FRA = 'Cotisat. soc. imposable';
            DecimalPlaces = 3 : 3;
            FieldClass = Normal;
        }
        field(82; "Mission expenses"; Decimal)
        {
            CaptionML = ENU = 'Mission expenses Heading', FRA = 'Frais de mission';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = Normal;
        }
        field(100; "Net salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Net Salary', FRA = 'Salaire net';
            DecimalPlaces = 3 : 3;
        }
        field(110; Loans; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Loans', FRA = 'Prêts';
            DecimalPlaces = 3 : 3;
            FieldClass = Normal;
        }
        field(111; Advances; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Advances', FRA = 'Avances';
            DecimalPlaces = 3 : 3;
            FieldClass = Normal;
        }
        field(120; "Net Salary Cashed"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Net Salary Cashed', FRA = 'Salaire net encaissé';
            DecimalPlaces = 3 : 3;
            FieldClass = Normal;
        }
        field(121; "Global dimension 1"; Code[20])
        {
            CaptionML = ENU = 'Department code', FRA = 'Code département';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(122; "Global dimension 2"; Code[20])
        {
            CaptionML = ENU = 'Folder code', FRA = 'Code dossier';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(244; "Gross Salary PR"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Gross Salary', FRA = 'Salaire brut';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(245; "Non Taxable Soc. Contrib. PR"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Non Taxable Soc. Contrib.', FRA = 'Cotisations non imposables';
            DecimalPlaces = 3 : 3;
        }
        field(247; "Taxable indem. PR (Not Gross)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxable indem. PR (Not Gross)', FRA = 'Indemnité imposable PR (Non brut)';
            DecimalPlaces = 3 : 3;
        }
        field(250; "Taxable salary PR"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxable salary', FRA = 'Salaire imposable';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(272; "Taxe PR (Month)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxe (Month)', FRA = 'Impôts (Mois)';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(275; "Taxe PR (Year)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxe PR (Year)', FRA = 'Impôts PR (Année)';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(500; "6 SMIG"; Decimal)
        {
            CaptionML = ENU = '6 SMIG', FRA = '6 SMIG';
            AutoFormatType = 0;
            DecimalPlaces = 3 : 3;
        }
        field(600; "Bonus Type"; Code[20])
        {
            CaptionML = ENU = 'Bonus Type', FRA = 'Type prime';
        }
        field(800; "Hours consumption Holiday"; Decimal)
        {
            CaptionML = ENU = 'Hours consumption Holiday', FRA = 'Consommation heures congé';
        }
        field(910; "Calculate Year"; Integer)
        {
            CaptionML = ENU = 'Year of Calculate', FRA = 'Année calcul';
        }
        field(5000; "Num Compte"; Code[20])
        {
            CaptionML = ENU = 'Account Number', FRA = 'Num Compte';
        }
        field(50000; Management; Code[20])
        {
            CaptionML = ENU = 'Management', FRA = 'Gestion';
        }
        field(50001; Service; Code[20])
        {
            CaptionML = ENU = 'Service', FRA = 'Service';
        }
        field(50002; Section; Code[20])
        {
            CaptionML = ENU = 'Section', FRA = 'Section';
        }
        field(50003; "Amount retained cash FS"; Decimal)
        {
            CaptionML = ENU = 'Amount retained cash FS', FRA = 'Montant retenu cash FS';
            DecimalPlaces = 3 : 3;
        }
        field(50004; "Sick leave amount"; Decimal)
        {
            CaptionML = ENU = 'Sick leave amount', FRA = 'Montant congé maladie';
            CalcFormula = Sum("WDC Employee's days off Entry"."Line amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                                 "Posting month" = FIELD(Month),
                                                                                 "Posting year" = FIELD(Year),
                                                                                 Unit = FILTER("Work hour"),
                                                                                 "Absence Reason" = FILTER("Medical Leave")));
            FieldClass = FlowField;
        }
        field(50005; "Work accident amount"; Decimal)
        {
            CaptionML = ENU = 'Work accident amount', FRA = 'Montant accident travail';
            CalcFormula = Sum("WDC Employee's days off Entry"."Line amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                                 "Posting month" = FIELD(Month),
                                                                                 "Posting year" = FIELD(Year),
                                                                                 Unit = FILTER("Work hour"),
                                                                                 "Absence Reason" = filter("Work Accident")));
            FieldClass = FlowField;
        }
        field(50006; "Public Holiday Worked Amount"; Decimal)
        {
            CaptionML = ENU = 'Public Holiday Worked Amount', FRA = 'Montant jours fériés travaillés';
            CalcFormula = Sum("WDC Employee's days off Entry"."Line amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                                 "Posting month" = FIELD(Month),
                                                                                 "Posting year" = FIELD(Year),
                                                                                 "Line type" = FILTER("Paid Public Holiday")));
            FieldClass = FlowField;
        }
        field(50007; "Base RCGC"; Decimal)
        {
            CaptionML = ENU = 'Base RCGC', FRA = 'Base RCGC';
            DecimalPlaces = 3 : 3;
        }
        field(50008; "Retenue CGC"; Decimal)
        {
            CaptionML = ENU = 'Retenue CGC', FRA = 'Retenue CGC';
            DecimalPlaces = 3 : 3;
        }
        field(50009; "Montant Transport"; Decimal)
        {
            CaptionML = ENU = 'Transport Amount', FRA = 'Montant Transport';
        }
        field(50010; "Days Number"; Decimal)
        {
            CaptionML = ENU = 'Days Number', FRA = 'Nombre de jours';
        }
        field(50012; Classement; Enum "WDC Classification")
        {
            CaptionML = ENU = 'Ranking', FRA = 'Classement';
        }
        field(50013; "Montant CNSS reduit"; Decimal)
        {
            CaptionML = ENU = 'Reduced CNSS Amount', FRA = 'Montant CNSS réduit';
        }
        field(50020; "Site de travail"; Code[20])
        {
            CaptionML = ENU = 'Worksite', FRA = 'Site de travail';
            TableRelation = "WDC Management";
        }
        field(50021; Imposable; Boolean)
        {
            CaptionML = ENU = 'Taxable', FRA = 'Imposable';
        }
        field(50022; "Montant Loi Finance 2014-1J"; Decimal)
        {
            CaptionML = ENU = 'Finance Law 2014-1J Amount', FRA = 'Montant Loi Finance 2014-1J';
            Editable = false;
        }
        field(50023; "Jour Loi Finance 2014"; Integer)
        {
            CaptionML = ENU = 'Finance Law 2014 Day', FRA = 'Jour Loi Finance 2014';
            Editable = false;
        }
        field(50024; "Base Loi Finance"; Decimal)
        {
            CaptionML = ENU = 'Finance Law Base', FRA = 'Base Loi Finance';
            Editable = false;
        }
        field(50025; "Autres deduction"; Decimal)
        {
            CaptionML = ENU = 'Other deduction', FRA = 'Autres déductions';
        }
        field(50026; "Historique Autr Deduct"; Decimal)
        {
            CaptionML = ENU = 'Other Deduction History', FRA = 'Historique autres déductions';
        }
        field(50027; "Rest. Autres deduction"; Decimal)
        {
            CaptionML = ENU = 'Remaining Other deduction', FRA = 'Reste autres déductions';
        }
        field(50030; "Cumulative Taxable Salary"; Decimal)
        {
            CaptionML = ENU = 'Cumulative Taxable Salary', FRA = 'Salaire imposable cumulé';
            Editable = false;
        }
        field(50031; "Recorded Pay Days"; Decimal)
        {
            CaptionML = ENU = 'Recorded Pay Days', FRA = 'Jours payés enregistrés';
            Editable = false;
        }
        field(50032; "Taxable Average Period"; Decimal)
        {
            CaptionML = ENU = 'Taxable Average Period', FRA = 'Période moyenne imposable';
            Editable = false;
        }
        field(50033; "Days Period Number"; Decimal)
        {
            CaptionML = ENU = 'Days Period Number', FRA = 'Nombre jours période';
            Editable = false;
        }
        field(50034; "Annual Taxable"; Decimal)
        {
            CaptionML = ENU = 'Annual Taxable', FRA = 'Imposable annuel';
            Editable = false;
        }
        field(50035; CNSS; Code[20])
        {
            CaptionML = ENU = 'CNSS', FRA = 'CNSS';
            CalcFormula = Lookup("WDC Rec. Social Contributions"."Social Contribution" WHERE("Deductible of taxable basis" = FILTER(TRUE),
                                                                                          "No." = FIELD("No."),
                                                                                          "Employee No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(50037; "Annual CSS Tax"; Decimal)
        {
            CaptionML = ENU = 'Annual CSS Tax', FRA = 'Impôt CSS annuel';
            Editable = false;
        }
        field(50038; "Monthly CSS Tax"; Decimal)
        {
            CaptionML = ENU = 'Monthly CSS Tax', FRA = 'Impôt CSS mensuel';
            Editable = false;
        }
        field(50039; "CSS Tax"; Decimal)
        {
            CaptionML = ENU = 'CSS Tax', FRA = 'Impôt CSS';
            Editable = true;
        }
        field(50040; "Total CSS Tax Recorded"; Decimal)
        {
            CaptionML = ENU = 'Total CSS Tax Recorded', FRA = 'Total impôt CSS enregistré';
        }
        field(50041; "Taxe PR (Month) CSS"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxe (Month)', FRA = 'Impôts (Mois)';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(50042; "Taxe PR (Year) CSS"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxe PR (Year)', FRA = 'Impôts PR (Année)';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(50051; "Tot Avantage"; Decimal)
        {
            CaptionML = ENU = 'Total Benefit', FRA = 'Tot Avantage';
            CalcFormula = Sum("WDC Rec. Indemnities"."Real Amount" WHERE("No." = FIELD("No."),
                                                                      "Employee No." = FIELD("Employee No."),
                                                                      "Benefit in Kind" = FILTER(TRUE)));
            FieldClass = FlowField;
        }
        field(50072; Assurance; Decimal)
        {
            CaptionML = ENU = 'Insurance', FRA = 'Assurance';
            Description = 'WDC';
        }
        field(50073; Bus; Decimal)
        {
            CaptionML = ENU = 'Bus', FRA = 'Bus';
            Description = 'WDC';
        }
        field(50074; Shems; Decimal)
        {
            CaptionML = ENU = 'Shems', FRA = 'Shems';
            Description = 'WDC';
        }
        field(50075; Phone; Decimal)
        {
            CaptionML = ENU = 'Phone', FRA = 'Téléphone';
            Description = 'WDC';
        }
        field(50076; "Retirement plus"; Decimal)
        {
            CaptionML = ENU = 'Retirement plus', FRA = 'Retraite plus';
            Description = 'WDC';
        }
        field(50077; Car; Decimal)
        {
            CaptionML = ENU = 'Car', FRA = 'Voiture';
            Description = 'WDC';
        }
        field(50078; DSAM; Decimal)
        {
            CaptionML = ENU = 'DSAM', FRA = 'DSAM';
            Description = 'WDC';
        }
        field(50079; "Imposable Annuel Regul"; Decimal)
        {
            CaptionML = ENU = 'Annual Taxable Regular', FRA = 'Imposable Annuel Regul';
            Description = 'WDC REGUL';
        }
        field(50900; Trimestre; Enum "WDC Quarter")
        {
            CaptionML = ENU = 'Quarter', FRA = 'Trimestre';
        }
        field(50901; "Ajout  en +"; Decimal)
        {
            CaptionML = ENU = 'Addition +', FRA = 'Ajout en +';
            DecimalPlaces = 3 : 3;
        }
        field(50902; "Report en -"; Decimal)
        {
            CaptionML = ENU = 'Carry forward -', FRA = 'Report en -';
            DecimalPlaces = 3 : 3;
        }
        field(50903; "Salary RIB"; Code[50])
        {
            CaptionML = ENU = 'Salary RIB', FRA = 'Salaire RIB';
        }
        field(50904; "Employee Statistic Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Statistic Group', FRA = 'Groupe statistique employé';
            TableRelation = "Employee Statistics Group".Code;
        }
        field(50905; "Employee Contract Type"; Enum "WDC Employees type Contract")
        {
            CaptionML = ENU = 'Employee Type Contract', FRA = 'Type Contrat';
        }
        field(50906; "CNSS No."; Code[30])
        {
            CaptionML = ENU = 'CNSS No.', FRA = 'N° CNSS';
        }
        field(50907; "CIN No."; Code[20])
        {
            CaptionML = ENU = 'CIN No.', FRA = 'N° CIN';
        }
        field(50908; "Payment Method Code"; code[20])
        {
            CaptionML = ENU = 'Payment Method Code', FRA = 'Code mode de paiement';
            TableRelation = "Payment Method";
        }
        field(50909; Number; Integer)
        {
            CaptionML = ENU = 'Number', FRA = 'Numéro';
        }
        field(50910; "Salaire Brut Prime Fin Annee"; Decimal)
        {
            CaptionML = ENU = 'Year-end Bonus Gross Salary', FRA = 'Salaire brut prime fin année';
        }
        field(50911; "Salaire Brut Paie Reel"; Decimal)
        {
            CaptionML = ENU = 'Actual Pay Gross Salary', FRA = 'Salaire brut paie réel';
        }
        field(50912; "Salaire Brut Prime Rend"; Decimal)
        {
            CaptionML = ENU = 'Productivity Bonus Gross Salary', FRA = 'Salaire brut prime rendement';
        }
        field(50913; "Nbr Mois Prime"; Decimal)
        {
            CaptionML = ENU = 'Number of Bonus Months', FRA = 'Nbr Mois Prime';
        }
        field(50914; "Quarterly Note"; Decimal)
        {
            CaptionML = ENU = 'Quarterly Note', FRA = 'Note trimestrielle';
            Description = 'WDC';
        }
        field(8099198; "User ID"; Code[22])
        {
            CaptionML = ENU = 'User ID', FRA = 'ID utilisateur';
            Editable = false;
            TableRelation = User;
        }
        field(8099199; "Last Date Modified"; Date)
        {
            CaptionML = ENU = 'Last Date Modified', FRA = 'Date dernière modification';
            Editable = false;
        }
        field(8099200; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptable';
        }

        field(39001496; "Paied days"; Decimal)
        {
            CaptionML = ENU = 'Paid days', FRA = 'Jours payés';
        }
        field(39001497; "Company Bank Account No."; Code[20])
        {
            CaptionML = ENU = 'Company Bank Account No.', FRA = 'N° compte bancaire société';
            TableRelation = "Bank Account"."No.";
        }
        field(39001498; "Public Holidays"; Decimal)
        {
            CaptionML = ENU = 'Public Holidays', FRA = 'Jours fériés';
            Editable = true;
        }
        field(39001499; "Public Holiday Amount"; Decimal)
        {
            CaptionML = ENU = 'Public Holiday Amount', FRA = 'Montant jours fériés';
            Editable = false;
        }
        field(39001503; "Seniority leave entitlement"; Decimal)
        {
            CaptionML = ENU = 'Seniority leave entitlement', FRA = 'Droit congé ancienneté';
        }
        field(39001504; "Salary grid code"; Code[20])
        {
            CaptionML = ENU = 'Salary grid code', FRA = 'Code grille salaire';
        }
        field(39001505; Category; Code[20])
        {
            CaptionML = ENU = 'Category', FRA = 'Catégorie';
        }
        field(39001506; Echelon; Integer)
        {
            CaptionML = ENU = 'Echelon', FRA = 'Échelon';
        }
        field(39001507; "salaire de base grille"; Decimal)
        {
            CaptionML = ENU = 'Salary grid base', FRA = 'Salaire de base grille';
        }
        field(39001508; "Montant Heures"; Decimal)
        {
            CaptionML = ENU = 'Hours Amount', FRA = 'Montant heures';
            AutoFormatType = 0;
            DecimalPlaces = 3 : 3;
        }
    }

    keys
    {
        key(Key1; "No.", "Employee No.")
        {
            Clustered = true;
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Supp. hours", "Taxable indemnities", "Ajout  en +", "Report en -", "Amount retained cash FS", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key2; "Employee Posting Group", "Global dimension 1", "Global dimension 2")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key3; Year, "Employee No.", "Global dimension 1", "Global dimension 2")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key4; "Employee No.", Quarter, Year, "Global dimension 1", "Global dimension 2")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key5; "Employee No.", "Last Date Modified", "Global dimension 1", "Global dimension 2")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key6; Year, "Employee No.", Month, "No.", Imposable)
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key7; Year, Month, "Employee No.", "No.", "Real taxable", "Non Taxable Soc. Contrib.", Imposable)
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Days off remaining", "Days off balacement", Absences, "Days off", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key8; "Employee No.", Year, Month, "Bonus Type")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key9; "No.", "Employee Posting Group", "Employee No.")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key10; Year, Month, "Global dimension 1", "Global dimension 2", "No.")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key11; "No.", "Num Compte")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key12; "Calculate Year", "Posting Date", Month, "Bonus Type", "No.")
        {
        }
        key(Key13; "Employee No.", "Calculate Year", Month, "Bonus Type")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "6 SMIG", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key14; "Employee No.", "Posting Date", Month, "Bonus Type")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "6 SMIG", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key15; Year, Month, "Bonus Type", "Employee No.", "No.")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "6 SMIG", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key16; "Employee No.", "Employee Posting Group")
        {
        }
        key(Key17; "Employee Statistic Group", "Employee No.")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key18; Year, Month, "No.")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key19; "Employee Statistic Group", Year, Month, "No.")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key20; "Employee Posting Group", "Employee No.")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key21; Year, Month, "Employee No.", "No.", Imposable)
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key22; Year, "Employee No.", "No.")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours", "Amount retained cash FS", "Retenue CGC", "Monthly CSS Tax";
        }
        key(Key23; "Global dimension 1", "Global dimension 2", "No.", "Employee No.")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Real taxable", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours", "Amount retained cash FS", "Retenue CGC", "Monthly CSS Tax";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        BEGIN
            Indemnities.SETRANGE("No.", "No.");
            Indemnities.SETRANGE("Employee No.", "Employee No.");
            IF Indemnities.Findfirst() THEN
                Indemnities.DELETEALL;

            SocialContributions.SETRANGE("No.", "No.");
            SocialContributions.SETRANGE("Employee No.", "Employee No.");
            IF SocialContributions.Findfirst() THEN
                SocialContributions.DELETEALL;


        END
    end;

    trigger OnInsert()
    begin
        "Last Date Modified" := WORKDATE;
        "User ID" := USERID;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := WORKDATE;
        "User ID" := USERID;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := WORKDATE;
        "User ID" := USERID;
    end;

    var
        Indemnities: Record "WDC Indemnities";
        SocialContributions: Record "WDC Social Contributions";
}

