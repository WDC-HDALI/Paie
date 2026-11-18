table 55023 "WDC Salary Lines"
{
    CaptionML = ENU = 'Posted Salary Lines', FRA = 'Lignes salaire enregistrées';
    DrillDownPageID = 55039;
    LookupPageID = 55039;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
            Editable = false;
            TableRelation = "WDC Salary Header"."No.";
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° Employé';
            Editable = false;
            TableRelation = Employee."No.";
        }
        field(3; Name; Text[100])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';
            Editable = false;
        }
        field(4; "Employee Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe compta employé';
            Editable = true;
            TableRelation = "WDC Employee Posting Group";
        }
        field(5; "Employee Work Regime"; Code[20])
        {
            CaptionML = ENU = 'Employee Work Regime', FRA = 'Régime de travail employé';
            Editable = false;

        }
        field(6; "Emplymt. Contract Code"; Code[20])
        {
            CaptionML = ENU = 'Empl. Contract Code', FRA = 'Code contrat employé';
            Editable = false;
            TableRelation = "Employment Contract";

            // trigger OnLookup()
            // begin
            //     EmploymentContract.SETRANGE (Code,"Emplymt. Contract Code");
            //     IF EmploymentContract.Findfirst THEN
            //       BEGIN
            //         EmploymentContractNE.SETTABLEVIEW (EmploymentContract);
            //         EmploymentContractNE.RUN;
            //       END
            // end;
        }
        field(7; "Bank Account Code"; Code[20])
        {
            CaptionML = ENU = 'Bank Account', FRA = 'Compte bancaire';
            Editable = false;
            TableRelation = "WDC Employee Bank Account".Code WHERE("Employee No." = FIELD("Employee No."));
        }
        field(8; "Employee type"; Enum "WDC Employee type")
        {
            CaptionML = ENU = 'Employee type', FRA = 'Type d''employé';
            Editable = false;
        }

        field(10; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
            Editable = false;
        }
        field(11; Note; Decimal)
        {
            CaptionML = ENU = 'Note', FRA = 'Note';
            DecimalPlaces = 2 : 2;
        }
        field(12; Purcent; Decimal)
        {
            CaptionML = ENU = 'Purcent', FRA = 'Pourcentage';
        }
        field(13; "Worked Months"; Decimal)
        {
            CaptionML = ENU = 'Worked Months', FRA = 'Mois travaillés';
            DecimalPlaces = 2 : 2;
        }
        field(20; Month; Enum "WDC Payroll Month")
        {
            CaptionML = ENU = 'Month', FRA = 'Mois';
            Editable = false;
        }
        field(21; Year; Integer)
        {
            CaptionML = ENU = 'Year', FRA = 'Année';
            Editable = false;
        }
        field(23; "Days off remaining"; Decimal)
        {
            CaptionML = ENU = 'Days off remaining', FRA = 'Congés restants';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = Normal;
        }
        field(24; "Days off balacement"; Decimal)
        {
            CaptionML = ENU = 'Days off balacement', FRA = 'Congé Soldé';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(25; Absences; Decimal)
        {
            CaptionML = ENU = 'Absences', FRA = 'Absences';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = Normal;
        }
        field(26; "Adjustment of absences"; Decimal)
        {
            CaptionML = ENU = 'Adjustment of absences', FRA = 'Ajustement des absences';
            DecimalPlaces = 3 : 3;
        }
        field(27; "Days off"; Decimal)
        {
            CaptionML = ENU = 'Days off', FRA = 'Congés';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(28; "Assiduity (Paid days)"; Decimal)
        {
            CaptionML = ENU = 'Assiduity (Paid days)', FRA = 'Assiduité (Jours payés)';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(29; "Assiduity (Worked days)"; Decimal)
        {
            CaptionML = ENU = 'Assiduity (Worked days)', FRA = 'Assiduité (Jours travaillés)';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(30; Holiday; Decimal)
        {
            CaptionML = ENU = 'Holiday', FRA = 'Congé';
        }
        field(35; "Worked hours"; Decimal)
        {
            CaptionML = ENU = 'Worked hours', FRA = 'Heures travaillées';
            FieldClass = Normal;
        }
        field(36; "Basis hours"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Basis hours', FRA = 'Heures de base';
            Editable = false;
            FieldClass = Normal;
        }
        field(37; "Amount Days Off balacement"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Amount Days Off balacement', FRA = 'Montant congé Soldé';
            DecimalPlaces = 3 : 3;
        }
        field(38; "Assiduity (days off balacement"; Decimal)
        {
            CaptionML = ENU = 'Assiduity (Days off balacement)', FRA = 'Assiduité (congé soldé)';
            DecimalPlaces = 3 : 3;
        }
        field(39; "Hours off Balacement"; Decimal)
        {
            CaptionML = ENU = 'Hours off Balacement', FRA = 'Heure congé soldé';
            DecimalPlaces = 3 : 3;
        }
        field(40; "Basis salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Basis salary', FRA = 'Salaire de base';
            DecimalPlaces = 3 : 3;
        }
        field(41; "Taxable Indemnities"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxable indemnities', FRA = 'Indemnités imposables';
            DecimalPlaces = 3 : 3;
            FieldClass = Normal;
        }
        field(42; "Supp. hours"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Supp. hours', FRA = 'Supp. hours';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = Normal;
        }
        field(43; "Real Basis Salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Real basis salary', FRA = 'Salaire réel de base';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(44; "Gross Salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Gross Salary', FRA = 'Salaire brut';
            DecimalPlaces = 3 : 3;
            Editable = false;
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
        field(48; "Taxable indemnities(Not Gross)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxable indemnities(Not Gross)', FRA = 'Indemnités imposables (Non Brut)';
            DecimalPlaces = 3 : 3;
        }
        field(49; "Gross Salary (Without AV) PR"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Gross Salary (Without AV) PR', FRA = 'Salaire brut (sans AV) PR';
            DecimalPlaces = 3 : 3;
        }
        field(50; "Taxable Salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxable Salary', FRA = 'Salaire imposable';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(55; "Deduction Family chief"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Deduction Family chief', FRA = 'Déduction chef famille';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(56; "Deduction Loaded child"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Deduction Loaded child', FRA = 'Déduction enfant en charge';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(57; "Deduction Prof. expenses"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Deduction Prof. expenses', FRA = 'Déduction frais professionnels';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(60; "Real taxable"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Real taxable', FRA = 'Imposable réel';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(65; "Total taxable rec."; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Total taxable rec.', FRA = 'Total imposable enreg.';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = Normal;
        }
        field(66; "Rec. payments"; Integer)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Rec. payments', FRA = 'Paiements enreg.';
            Editable = false;
            FieldClass = Normal;
        }
        field(67; "Real taxable (Year)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Real taxable (Year)', FRA = 'Imposable réel (Année)';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(70; "Taxe (Year)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxe (Year)', FRA = 'Impôts(Année)';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(71; "Total taxes rec."; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Total taxes rec.', FRA = 'Total taxes enreg.';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = Normal;
        }
        field(72; "Taxe (Month)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxe (Month)', FRA = 'Taxe (Mois)';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(80; "Non Taxable indemnities"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Non Taxable indemnities', FRA = 'Indemnités non imposables';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = Normal;
        }
        field(81; "Taxable Soc. Contrib."; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxable Soc. Contrib.', FRA = 'Cotis. soc. imposable';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = Normal;
        }
        field(82; "Mission Expenses"; Decimal)
        {
            CaptionML = ENU = 'Mission expenses Heading', FRA = 'Frais de mission';
            DecimalPlaces = 3 : 3;
            Editable = false;
            FieldClass = Normal;
        }
        field(100; "Net Salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Net salary', FRA = 'Salaire net';
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
            CaptionML = ENU = 'Net salary cashed', FRA = 'Salaire net encaissé';
            DecimalPlaces = 3 : 3;
            Editable = true;
            FieldClass = Normal;
        }
        field(121; "Global Dimension 1"; Code[20])
        {
            CaptionML = ENU = 'Code département', FRA = 'Code département';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(122; "Global Dimension 2"; Code[20])
        {
            CaptionML = ENU = 'Code dossier', FRA = 'Code dossier';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(241; "Taxable Indemnities PR"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxable indemnities PR', FRA = 'Indemnités imposables PR';
            DecimalPlaces = 3 : 3;
        }
        field(244; "Gross Salary PR"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Gross Salary PR', FRA = 'Salaire brut PR';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(245; "Non Taxable Soc. Contrib. PR"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Non Taxable Soc. Contrib. PR', FRA = 'Cotis. soc. non imposable PR';
            DecimalPlaces = 3 : 3;
        }
        field(247; "Taxable Indem. PR (Not Gross)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'indemnities Impo. PR (Non Brut)', FRA = 'Indemnités imposables PR (Non Brut)';
            DecimalPlaces = 3 : 3;
        }
        field(250; "Taxable Salary PR"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxable salary PR', FRA = 'Salaire imposable PR';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(260; "Real Taxable PR"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Real taxable PR', FRA = 'Imposable réel PR';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(270; "Real Taxable PR (Year)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Real Taxable PR (Year) PR', FRA = 'Imposable réel PR (Année) PR';
            DecimalPlaces = 3 : 3;
        }
        field(272; "Taxe PR (Month)"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxe PR(Month)', FRA = 'Impôts PR (Mois)';
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
        field(500; "6 * SMIG"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = '6 * SMIG', FRA = '6 * SMIG';
            DecimalPlaces = 3 : 3;
        }
        field(600; "Bonus Type"; Code[20])
        {
            CaptionML = ENU = 'Bonus Type', FRA = 'Type prime';
        }
        field(800; "Hours Consumption Holiday"; Decimal)
        {
            CaptionML = ENU = 'Hours consumption Holiday', FRA = 'Heures consomation congé';
            DecimalPlaces = 3 : 3;
        }
        field(910; "Calculate Year"; Integer)
        {
            CaptionML = ENU = 'Year of Calculate', FRA = 'Année calcul';
        }
        field(5000; "Account No."; Code[20])
        {
            CaptionML = ENU = 'Account No.', FRA = 'N° compte';
        }
        field(50000; Management; Code[20])
        {
            CaptionML = ENU = 'Management', FRA = 'Direction';
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
            CaptionML = ENU = 'Amount retained cash FS', FRA = 'Montant retenu caisse FS';
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
        field(50005; "Work Accident Amount"; Decimal)
        {
            CaptionML = ENU = 'Work Accident Amount', FRA = 'Montant accident travail';
            CalcFormula = Sum("WDC Employee's days off Entry"."Line amount" WHERE("Employee No." = FIELD("Employee No."),
                                                                                 "Posting month" = FIELD(Month),
                                                                                 "Posting year" = FIELD(Year),
                                                                                 Unit = FILTER("Work hour"),
                                                                                 "Absence Reason" = FILTER("Work Accident")));
            FieldClass = FlowField;
        }
        field(50010; "Days Number"; Decimal)
        {
            CaptionML = ENU = 'Days Number', FRA = 'Nombre jours';
        }
        field(50012; Class; Enum "WDC Classification")
        {
            CaptionML = ENU = 'Class', FRA = 'Classe';

            Editable = false;
        }
        field(50021; Taxable; Boolean)
        {
            CaptionML = ENU = 'Taxable', FRA = 'Imposable';
        }

        field(50030; "Cumulative Taxable Salary"; Decimal)
        {
            CaptionML = ENU = 'Cumulative Taxable Salary', FRA = 'Cumul Sal.Impos';
            Editable = false;
        }
        field(50031; "Recorded Pay Days"; Decimal)
        {
            CaptionML = ENU = 'Recorded Pay Days', FRA = 'Nbre jour paie enreg';
            Editable = false;
        }
        field(50032; "Taxable Average Period"; Decimal)
        {
            CaptionML = ENU = 'Taxable Average Period', FRA = 'Moyenne imposable période';
            Editable = false;
        }
        field(50033; "Days Period Number"; Decimal)
        {
            CaptionML = ENU = 'Days Period Number', FRA = 'Nbr jour période';
            Editable = false;
        }
        field(50034; "Annual Taxable"; Decimal)
        {
            CaptionML = ENU = 'Annual Taxable', FRA = 'Imposable annuel';
            Editable = false;
        }
        field(50036; "Annual CSS Tax"; Decimal)
        {
            CaptionML = ENU = 'Annual CSS Tax', FRA = 'Impôt annuel CSS';
            Editable = false;
        }
        field(50037; "Monthly CSS Tax"; Decimal)
        {
            CaptionML = ENU = 'Monthly CSS Tax', FRA = 'Impôt mensuel CSS';
            Editable = false;
        }
        field(50038; "CSS Tax"; Decimal)
        {
            CaptionML = ENU = 'CSS Tax', FRA = 'Impôt CSS';
            Editable = false;
        }
        field(50039; "Total CSS Tax Recorded"; Decimal)
        {
            CaptionML = ENU = 'Total CSS Tax Recorded', FRA = 'Total impôt CSS Rec.';
            Editable = false;
        }
        field(50040; "Taxe PR (Month) CSS"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxe (Month)', FRA = 'Taxe (Mois)';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(50041; "Taxe PR (Year) CSS"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Taxe PR (Year)', FRA = 'Taxe PR (Année)';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(50071; "Indem. Not Tax. Not Contrib."; Decimal)
        {
            CaptionML = ENU = 'Indem. Not Tax. Not Contrib.', FRA = 'Indem. non impos. non cotis.';
            CalcFormula = Sum("WDC Indemnities"."Real Amount" WHERE("No." = FIELD("No."),
                                                               "Employee No." = FIELD("Employee No."),
                                                               Type = FILTER("Not Taxable Not Contrib.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50072; Assurance; Decimal)
        {
            CaptionML = ENU = 'Assurance', FRA = 'Assurance';
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
            CaptionML = ENU = 'Retraite plus', FRA = 'Retraite plus';
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
            CaptionML = ENU = 'Imposable Annuel Regul', FRA = 'Imposable annuel régul';
            Description = 'WDC REGUL';
        }
        field(50900; Trimestre; Enum "WDC Quarter")
        {
            CaptionML = ENU = 'Quarter', FRA = 'Trimestre';
        }
        field(50901; "Ajout  en +"; Decimal)
        {
            CaptionML = ENU = 'Addition +', FRA = 'Ajout  en +';
            DecimalPlaces = 3 : 3;
        }
        field(50902; "Report en -"; Decimal)
        {
            CaptionML = ENU = 'Subtraction -', FRA = 'Report en -';
            DecimalPlaces = 3 : 3;
        }
        field(50903; "Salary RIB"; Code[50])
        {
            CaptionML = ENU = 'Salary RIB', FRA = 'RIB salaire';
        }
        field(50904; "Statistics Group Code"; Code[30])
        {
            CaptionML = ENU = 'Statistics Group Code', FRA = 'Code groupe statistiques';
            TableRelation = "Employee Statistics Group".Code;
        }
        field(50905; "Employee Contract Type"; Enum "WDC Employees type Contract")
        {
            CaptionML = ENU = 'Employee Type Contract', FRA = 'Type contrat';
        }
        field(50906; "CNSS No."; Code[30])
        {
            CaptionML = ENU = 'CNSS No.', FRA = 'N° CNSS';
        }
        field(50907; "CIN No."; Code[20])
        {
            CaptionML = ENU = 'CIN No.', FRA = 'N° CIN';
        }
        // field(50908; "Payment Method Code"; Option) //Hamdi Migration
        // {
        //     CaptionML = ENU = 'Payment Method Code', FRA = 'Code mode règlement';
        //     OptionMembers = "Espèce","Chéque",Virement;
        // }
        field(50908; "Payment Method Code"; Code[20])
        {
            CaptionML = ENU = 'Payment Method Code', FRA = 'Code mode règlement';
            TableRelation = "Payment Method";
        }
        field(50910; "Salaire Brut Prime Fin Annee"; Decimal)
        {
            CaptionML = ENU = 'Year-end Bonus Gross Salary', FRA = 'Salaire brut prime fin année';
        }
        field(50911; "Salaire Brut Paie Reel"; Decimal)
        {
            CaptionML = ENU = 'Actual Pay Gross Salary', FRA = 'Salaire brut paie reel';
        }
        field(50912; "Salaire Brut Prime Rend"; Decimal)
        {
            CaptionML = ENU = 'Rendered Bonus Gross Salary', FRA = 'Salaire brut prime rend.';
        }
        field(50913; "Nbr Mois Prime"; Decimal)
        {
            CaptionML = ENU = 'Bonus Months Number', FRA = 'Nbr mois prime';
        }
        field(50914; "Quarterly Note"; Decimal)
        {
            CaptionML = ENU = 'Quarterly Note', FRA = 'Note trimestrielle';
            Description = 'WDC';
        }

        field(8099200; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
        }
        field(8099201; "Free Day Hours"; Decimal)
        {
            CaptionML = ENU = 'Free Day Hours', FRA = 'Heure jours libre';
        }
        field(39001490; Fortnight; Enum "WDC Fortnight")
        {
            CaptionML = ENU = 'Fortnight', FRA = 'Quinzaine';
        }
        field(39001492; Charge; Enum "WDC Charge")
        {
            CaptionML = ENU = 'Charge', FRA = 'Charge';
        }
        field(39001493; "Monthly Leave Entitlement"; Decimal)
        {
            CaptionML = ENU = 'Monthly leave entitlement', FRA = 'droit de congé du mois';
        }
        field(39001494; "Annual taxable vacation salary"; Decimal)
        {
            CaptionML = ENU = 'Annual taxable vacation salary', FRA = 'Salaire impos. ann. conge';
            DecimalPlaces = 3 : 3;
        }
        field(39001495; "Vacation Tax. bracket Rate"; Decimal)
        {
            CaptionML = ENU = 'Vacation Tax. bracket Rate', FRA = 'Taux tranche impos. Conge';
        }
        field(39001496; "Paied days"; Decimal)
        {
            CaptionML = ENU = 'Jours payés', FRA = 'Jours payés';
        }
        field(39001497; "Company Bank Account No."; Code[20])
        {
            CaptionML = ENU = 'Company Bank Account No.', FRA = 'N° compte bancaire société';
            TableRelation = "Bank Account"."No.";
        }
        field(39001498; "Public Holidays"; Decimal)
        {
            CaptionML = ENU = 'Public Holidays', FRA = 'Jours Fériés';
            Editable = false;
        }
        field(39001499; "Public Holiday Amount"; Decimal)
        {
            CaptionML = ENU = 'Public Holiday Amount', FRA = 'Montant jours fériés';
            Editable = false;
        }
        field(39001500; "Overtime Hours"; Decimal)
        {
            CaptionML = ENU = 'Overtime Hours', FRA = 'Nombre d''heures suppl.';
            FieldClass = Normal;
        }
        field(39001501; "Public Holiday Worked Days"; Decimal)
        {
            CaptionML = ENU = 'Public Holiday Worked Days', FRA = 'Jours fériés travaillés';
            FieldClass = Normal;
        }
        field(39001502; "Public Holiday Worked Amount"; Decimal)
        {
            CaptionML = ENU = 'Public Holiday Worked Amount', FRA = 'Montant jours fériés travaillé';
            FieldClass = Normal;
        }
        field(39001503; "Seniority leave entitlement"; Decimal)
        {
            CaptionML = ENU = 'Seniority leave entitlement', FRA = 'Droit de congé ancienneté';
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
            CaptionML = ENU = 'Echelon', FRA = 'Echelon';
        }
        field(39001507; "Salary grid base"; Decimal)
        {
            CaptionML = ENU = 'Salary grid base', FRA = 'salaire de base grille';
        }
        field(39001508; "Hours Amount"; Decimal)
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
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours";
        }
        key(Key2; "Employee Posting Group", "Global Dimension 1", "Global Dimension 2")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours";
        }
        key(Key3; "No.", Month, Year, "Employee Posting Group", "Global Dimension 1", "Global Dimension 2")
        {
            SumIndexFields = "Supp. hours", Absences, "Days off", Advances, Loans, "Ajout  en +", "Report en -", "Taxable indemnities";
        }
        key(Key4; "No.", "Account No.")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours";
        }
        key(Key5; "Employee No.", "Calculate Year", Month, "Bonus Type")
        {
            SumIndexFields = "Gross Salary", "Net salary", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours";
        }
        key(Key6; "No.", "Salary RIB")
        {
            SumIndexFields = "Net Salary Cashed";
        }
        key(Key7; "No.", "Statistics Group Code", "Employee Posting Group")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours";
        }
        key(Key8; "Employee No.", "Employee Posting Group", "Statistics Group Code")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours";
        }
        key(Key9; "Statistics Group Code", "Employee No.")
        {
            SumIndexFields = "Gross Salary", "Basis salary", "Real basis salary", "Net salary", "Net salary cashed", "Taxe (Month)", "Taxable salary", "Ajout  en +", "Report en -", "Taxable indemnities", "Supp. hours";
        }
    }

    trigger OnDelete()
    var
        SuppHourLine: Record "WDC Overtime hours recorded m";
        LigneTravail: Record "WDC Occasional Hours Recorded";
    begin

        Indemnities.SETRANGE("No.", "No.");
        Indemnities.SETRANGE("Employee No.", "Employee No.");
        Indemnities.DELETEALL;

        SuppHourLine.RESET;
        SuppHourLine.SETCURRENTKEY("Employee No.", "Overtime Rate", "Payment Month", "Payment Year");
        SuppHourLine.SETFILTER("Employee No.", "Employee No.");
        SuppHourLine.SETFILTER("Payment Year", '%1', Year);
        SuppHourLine.SETFILTER("Payment Month", '%1', Month);
        SuppHourLine.MODIFYALL("Payment No.", '');

        LigneTravail.RESET;
        LigneTravail.SETCURRENTKEY("Employee No.", "Payment Month", "Payment Year");
        LigneTravail.SETFILTER("Employee No.", "Employee No.");
        LigneTravail.SETRANGE("Payment Month", Month);
        LigneTravail.SETRANGE("Payment Year", Year);
        LigneTravail.SETRANGE("Payment No.", "No.");
        LigneTravail.MODIFYALL("Payment No.", '');

        SocialContributions.SETRANGE("No.", "No.");
        SocialContributions.SETRANGE("Employee No.", "Employee No.");
        SocialContributions.DELETEALL;
        LoanAdvanceLines.SETRANGE("Employee No.", "Employee No.");
        LoanAdvanceLines.SETRANGE(Status, 0);
        LoanAdvanceLines.SETRANGE(Paid, FALSE);
        LoanAdvanceLines.DELETEALL;

    end;



    trigger OnModify()
    begin
        IF SalaryHeader.GET("No.") THEN BEGIN
            SalaryHeader."Up to date" := FALSE;
            SalaryHeader.MODIFY;
        END;

        "Posting Date" := SalaryHeader."Posting Date";
    end;

    var
        SalaryHeader: Record "WDC Salary Header";
        Indemnities: Record "WDC Indemnities";
        SocialContributions: Record "WDC Social Contributions";
        LoanAdvanceLines: Record "WDC Loan & Advance Lines";
}

