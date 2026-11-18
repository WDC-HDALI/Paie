table 55037 "WDC Career Record"
{
    CaptionML = ENG = 'Career Record', FRA = 'Enregistrement carrière';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENG = 'Sequence No.', FRA = 'N° séquence';
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENG = 'Employee No. ', FRA = 'N° Employé';
        }
        field(3; "Posting Date"; Date)
        {
            CaptionML = ENG = 'Posting Date', FRA = 'Date comptabilisation';
        }
        field(4; "Type Career Record"; Enum "WDC Type Career record")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';
        }
        field(5; "Base Salary"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Base Salary', FRA = 'Salaire Base';
        }
        field(6; "Number of bonus months"; Decimal)
        {
            CaptionML = ENU = 'Number of bonus months', FRA = 'Nbre Mois Bonification';
        }
        field(7; "Entry Date"; Date)
        {
            CaptionML = ENU = 'Entry Date', FRA = 'Date entrée';
        }
        field(8; "Social Category"; Enum "WDC Social category")
        {
            CaptionML = ENU = 'Social Category', FRA = 'Catégorie sociale';
        }
        field(9; "College"; Code[20])
        {
            CaptionML = ENG = 'College', FRA = 'College';
            TableRelation = "WDC College";
        }
        field(10; Echelon; Integer)
        {
            CaptionML = ENG = 'Echelon', FRA = 'Echelon';
            TableRelation = "WDC Echelon";
        }
        field(11; Grade; Integer)
        {
            CaptionML = ENG = 'Grade', FRA = 'Grade';
        }
        field(12; Ladder; Integer)
        {
            CaptionML = ENG = 'Ladder', FRA = 'Echelle';
        }
        field(13; "Class Career record"; Enum "WDC Class Career record")
        {
            CaptionML = ENG = 'Class', FRA = 'Classe';
        }
        field(14; Function; Text[50])
        {
            CaptionML = ENG = 'Function', FRA = 'Fonction';
        }
        field(15; "Status Career Record"; Enum "WDC Status Career record")
        {
            CaptionML = ENG = 'Status', FRA = 'Status';
        }
        field(16; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            CaptionML = ENG = 'Global Dimension 1 Code', FRA = 'Code axe principal 1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            CaptionML = ENG = 'Global Dimension 2 Code', FRA = 'Code Dimension Global 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(18; "Working Relationship"; Enum "WDC Working relationship")
        {
            CaptionML = ENG = 'Working Relationship', FRA = 'Relation de travail';
        }
        field(19; "Work Site"; Code[20])
        {
            TableRelation = "WDC Management";
            CaptionML = ENG = 'Work Site', FRA = 'Site de travail';
        }
        field(20; "Work Site Designation"; Text[30])
        {
            CaptionML = ENG = 'Work Site Designation', FRA = 'Désignation Site de travail';
        }
        field(21; "Document No. Extract"; Code[20])
        {
            CaptionML = ENG = 'Document No. Extract', FRA = 'N° Document Extr.';
        }

        field(23; "Decision Date"; Date)
        {
            CaptionML = ENG = 'Decision Date', FRA = 'Date Décision';
        }
        field(24; Name; Text[30])
        {
            CaptionML = ENG = 'Name', FRA = 'Nom';
        }
        field(25; "First Name"; Text[30])
        {
            CaptionML = ENG = 'First Name', FRA = 'Prénom';

        }
        field(26; Qualification; Code[20])
        {
            CaptionML = ENG = 'Qualification', FRA = 'Qualification';
        }
        field(27; "Strain No."; Code[20])
        {
            CaptionML = ENG = 'Strain No.', FRA = 'Souche N°';
        }
        field(28; "Indemnity Code"; Code[20])
        {
            TableRelation = "WDC Indemnity";
            CaptionML = ENG = 'Indemnity Code', FRA = 'Code Indemnité';
        }

        field(29; "Default Amount"; Decimal)
        {
            CaptionML = ENG = 'Default Amount', FRA = 'Montant par défaut';
            DecimalPlaces = 3 : 5;
        }
        field(30; "Currency Code"; Code[20])
        {
            CaptionML = ENG = 'Currency Code', FRA = 'Code de devise';
            TableRelation = Currency;
        }
        field(31; "Gross Salary"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENG = 'Gross Salary', FRA = 'Salaire brut';
            Editable = false;
        }
        field(32; "Contract Start Date"; Date)
        {
            CaptionML = ENG = 'Contract Start Date', FRA = 'Date début contrat';
        }
        field(33; "Contract End Date"; Date)
        {
            CaptionML = ENG = 'Contract End Date', FRA = 'Date Fin contrat';
        }
        field(34; CodeAV; Code[20])
        {
            CaptionML = ENG = 'CodeAV', FRA = 'CodeAV';
        }
        field(35; "Transaction No."; Integer)
        {
            CaptionML = ENG = 'Transaction No.', FRA = 'N° Transaction';
        }
        field(36; Management; Code[20])
        {
            TableRelation = "WDC Management".Code;
            CaptionML = ENG = 'Direction', FRA = 'Direction';
        }
        field(37; Service; Code[20])
        {
            CaptionML = ENG = 'Service', FRA = 'Service';
            TableRelation = "WDC Service".Service WHERE(Management = FIELD(Management));
        }
        field(38; Section; Code[20])
        {
            CaptionML = ENG = 'Section', FRA = 'Section';
            TableRelation = "WDC Section".Section WHERE(Management = FIELD(Management),
                  Service = FIELD(Service));
        }
        field(39; Sanction; Text[100])
        {
            CaptionML = ENG = 'Sanction', FRA = 'Sanction';
        }
        field(40; "Motif Sanction"; Text[100])
        {
            CaptionML = ENG = 'Motif Sanction', FRA = 'Motif sanction';
        }
        field(41; "Recommendation Sanction"; Text[250])
        {
            CaptionML = ENG = 'Recommandation Sanction', FRA = 'Recommandation Sanction';
        }
        field(42; "Departure Company"; Code[20])
        {
            TableRelation = Company;
            CaptionML = ENG = 'Departure Company', FRA = 'Société Départ';
        }
        field(43; "Arrival Company"; Code[20])
        {
            CaptionML = ENG = 'Arrival Company', FRA = 'Société Arrivée';
            TableRelation = Company;
        }
        field(44; "Beginning of Mutation"; Date)
        {
            CaptionML = ENG = 'Beginning of Mutation', FRA = 'Début Mutation';
        }
        field(45; "Fin Mutation"; Date)
        {
            CaptionML = ENG = 'End of Mutation', FRA = 'Fin Mutation';
        }
        field(46; "Former Base Salary"; Decimal)
        {
            CaptionML = ENG = 'End of Mutation', FRA = 'Ancien Salaire Base';
            AutoFormatType = 2;
        }
    }

    keys
    {
        key(Key1; "Document No. Extract")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Decision Date")
        {
        }
        key(Key3; "Employee No.", "Posting Date")
        {
        }
    }

}

