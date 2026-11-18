table 55046 "WDC Hist. contrat de travail"
{
    CaptionML = ENU = '', FRA = 'Historique contrat travail';

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(3; "No. of Contracts"; Integer)
        {
            CalcFormula = Count(Employee WHERE(Status = CONST(Active),
                                                "Emplymt. Contract Code" = FIELD(Code)));
            CaptionML = ENU = 'No. of Contracts', FRA = 'Nombre contrats';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Job Title"; Text[50])
        {
            CaptionML = ENU = 'Job Title', FRA = 'Fonction';
            Editable = false;
            FieldClass = Normal;
        }
        field(8; Address; Text[60])
        {
            CaptionML = ENU = 'Address', FRA = 'Adresse';
        }
        field(10; City; Text[30])
        {
            CaptionML = ENU = 'City', FRA = 'Ville';
        }
        field(13; "Phone No."; Text[30])
        {
            CaptionML = ENU = 'Phone No.', FRA = 'N° téléphone';
        }
        field(21; "Social Security No."; Text[30])
        {
            CaptionML = ENU = 'Social Security No.', FRA = 'N° sécurité sociale';
        }
        field(24; Gender; Enum "Employee Gender")
        {
            CaptionML = ENU = 'Gender', FRA = 'Sexe';
        }
        field(28; "Statistics Group Code"; Code[20])
        {
            CaptionML = ENU = 'Statistics Group Code', FRA = 'Code groupe statistiques';
            TableRelation = "Employee Statistics Group";
        }
        field(29; "Employment Date"; Date)
        {
            CaptionML = ENU = 'Employment Date', FRA = 'Date d''embauche';
        }
        field(31; Status; Enum "WDC Status Active inactive")
        {
            CaptionML = ENU = 'Status', FRA = 'Statut';
        }
        field(32; "Inactive Date"; Date)
        {
            CaptionML = ENU = 'Inactive Date', FRA = 'Date d''inactivité';
        }
        field(33; "Cause of Inactivity Code"; Code[20])
        {
            CaptionML = ENU = 'Cause of Inactivity Code', FRA = 'Code cause d''inactivité';
            TableRelation = "Cause of Inactivity";
        }
        field(34; "Termination Date"; Date)
        {
            CaptionML = ENU = 'Termination Date', FRA = 'Date résiliation';
        }
        field(35; "Grounds for Term. Code"; Code[20])
        {
            CaptionML = ENU = 'Grounds for Term. Code', FRA = 'Code motif résiliation';
            TableRelation = "Grounds for Termination";
        }
        field(10800; "Family Situation A"; Enum "WDC Family Situation A")
        {
            CaptionML = ENU = 'Family Situation A', FRA = 'Situation familiale A';

        }
        field(50000; "Working Relationship"; Enum "WDC Working relationship")
        {
            CaptionML = ENU = 'Working Relationship', FRA = 'Relation travail';
        }
        field(50001; "Employee Contract Type"; Enum "WDC Employees type Contract")
        {
            CaptionML = ENU = 'Employee Type Contract', FRA = 'Type Contrat';
        }
        field(50013; "Specialty"; Text[60])
        {
            CaptionML = ENU = 'Specialty', FRA = 'Spécialité';
        }
        field(50301; "Start Contract Date"; Date)
        {
            CaptionML = ENU = 'Start Contract Date', FRA = 'Date début contrat';
        }
        field(50903; "Nationality"; Text[30])
        {
            CaptionML = ENU = 'Nationality', FRA = 'Nationalité';
        }
        field(80006; "Off-grid"; Boolean)
        {
            CaptionML = ENU = 'Off-grid', FRA = 'Hors grille';
        }
        field(8099000; "Regular payments"; Integer)
        {
            CaptionML = ENU = 'Regular payments', FRA = 'Paiements réguliers';
        }
        field(8099001; "Temporary payments"; Integer)
        {
            CaptionML = ENU = 'Temporary payments', FRA = 'Paiements temporaires';
        }
        field(8099005; "Adjust indemnity amount"; Boolean)
        {
            CaptionML = ENU = 'Adjust indemnity amount', FRA = 'Ajuster montant indemnité';
        }
        field(8099010; "Employee type"; Enum "WDC Employee type")
        {
            CaptionML = ENU = 'Employee type', FRA = 'Type employé';
        }
        field(8099020; "Work Regimes"; Code[20])
        {
            CaptionML = ENU = 'Work Regimes', FRA = 'Régimes travail';
            TableRelation = "WDC work Regimes".Code;
        }
        field(8099030; "Salary grid"; Code[20])
        {
            CaptionML = ENU = 'Salary grid', FRA = 'Grille salariale';
            TableRelation = "WDC Salary grid header".Code;
        }
        field(8099100; Taxable; Boolean)
        {
            CaptionML = ENU = 'Taxable', FRA = 'Imposable';
        }
        field(8099101; "Take in account deductions"; Boolean)
        {
            CaptionML = ENU = 'Take in account deductions', FRA = 'Prendre en compte déductions';
        }
        field(8099110; "Taxes Calculation Mode"; Enum "WDC Taxes Calcul Type")
        {
            CaptionML = ENU = 'Calculation mode of the taxes', FRA = 'Mode calcul impôts';
        }
        field(8099111; "Inclusive ratio"; Decimal)
        {
            CaptionML = ENU = 'Inclusive ratio', FRA = 'Ratio inclusif';
        }

        field(39001450; "Appliquer Heure Supp"; Boolean)
        {
            CaptionML = ENU = 'Apply Overtime Hours', FRA = 'Appliquer heure supp';
        }

        field(39001470; Note; Decimal)
        {
            CaptionML = ENU = 'Note', FRA = 'Note';
        }
        field(39001480; "Gross Salary"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Gross Salary', FRA = 'Salaire brut';
            Editable = true;
            FieldClass = Normal;
        }
        field(39001493; "Basis salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Basis salary', FRA = 'Salaire de base';
            DecimalPlaces = 3 : 3;
        }
        field(39001497; "Employee Posting Group"; Code[30])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe comptable employé';
            TableRelation = "WDC Employee Posting Group";
        }
        field(39001498; "College"; Code[20])
        {
            CaptionML = ENU = 'College', FRA = 'Collège';
            TableRelation = "WDC College";
        }
        field(39001499; Echelon; Integer)
        {
            CaptionML = ENU = 'Echelon', FRA = 'Échelon';
            TableRelation = "WDC Echelon".Echelon;
        }
        field(39001500; "Entry date Cat/Echelon"; Date)
        {
            CaptionML = ENU = 'Entry date Cat/Echelon', FRA = 'Date écri. cat/échelon';
        }

        field(39001504; "Loaded childs"; Integer)
        {
            CaptionML = ENU = 'Loaded childs', FRA = 'Enfants à charge';
            FieldClass = Normal;
        }
        field(39001507; "Days off -"; Decimal)
        {
            CaptionML = ENU = 'Day off- consumed', FRA = 'Congé- consommé';
            FieldClass = Normal;
        }
        field(39001508; "Days off +"; Decimal)
        {
            CaptionML = ENU = 'Day off+ Right', FRA = 'Congé+ Droit';
            FieldClass = Normal;
        }
        field(39001509; "Days off ="; Decimal)
        {
            CaptionML = ENU = 'Day off= Remaining', FRA = 'Congé =';
            FieldClass = Normal;
        }
        field(39001537; "Archived contract code"; Code[20])
        {
            CaptionML = ENU = 'Archived contract code', FRA = 'Code contrat archivé';
        }
    }

    keys
    {
        key(Key1; "Code", "Archived contract code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

