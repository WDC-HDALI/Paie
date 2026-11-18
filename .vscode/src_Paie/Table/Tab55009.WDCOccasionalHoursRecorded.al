table 55009 "WDC Occasional Hours Recorded"
{
    CaptionML = ENG = 'Occasional Hours Recorded', FRA = 'Heures occasionnelles enregistrées';

    DrillDownPageID = 55050;
    LookupPageID = 55050;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENG = 'Employee No.', FRA = 'N° Salarié';
            TableRelation = Employee."No.";
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENG = 'Line No.', FRA = 'N° Ligne';
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
        }
        field(10; "Department Code"; Code[20])
        {
            CaptionML = ENG = 'Department Code', FRA = 'Code département';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(11; "Folder Code"; Code[20])
        {
            CaptionML = ENG = 'Folder Code', FRA = 'Code dossier';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Start Time"; Time)
        {
            CaptionML = ENG = 'Start Time', FRA = 'Heure début';
        }
        field(16; "End Time"; Time)
        {
            CaptionML = ENG = 'End Time', FRA = 'Heure Fin';
        }
        field(20; "Hours Number"; Decimal)
        {
            CaptionML = ENG = 'Hours Number', FRA = 'Nombre d''heures';
        }
        field(21; "Unit Tariff"; Decimal)
        {
            CaptionML = ENG = 'Unit Tariff', FRA = 'Tarif unitaire';
        }
        field(22; "Line Amount"; Decimal)
        {
            CaptionML = ENG = 'Line Amount', FRA = 'Montant ligne';
            AutoFormatType = 0;
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(50; "Transaction No."; Integer)
        {
            CaptionML = ENG = 'Transaction No.', FRA = 'N° transaction';
        }
        field(60; "Payment Month"; Enum "WDC Payroll Month")
        {
            CaptionML = ENG = 'Payment Month', FRA = 'Mois de paiement';
        }
        field(61; "Payment Year"; Integer)
        {
            CaptionML = ENG = 'Payment Year', FRA = 'Année de paiement';
        }
        field(70; "Days Type"; Enum "WDC Days Type")
        {
            CaptionML = ENG = 'Days Type', FRA = 'Type Jours';
        }
        field(80; "Days Number"; Decimal)
        {
            CaptionML = ENG = 'Days Number', FRA = 'Nombre Jour';
        }
        field(100; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENG = 'Date Filter', FRA = 'Date Filter';
        }
        field(300; "Payment No."; Code[20])
        {
            CaptionML = ENG = 'Payment No.', FRA = 'N° Paiement';
        }
        field(50000; "Overtime Rate"; Decimal)
        {
            CaptionML = ENG = 'Overtime Rate', FRA = 'Taux de majoration';
        }
        field(50012; Week; Integer)
        {
            CaptionML = ENG = 'Week', FRA = 'Semaine';
        }
        field(50013; Department; Code[20])
        {
            CaptionML = ENG = 'Department', FRA = 'Direction';
        }
        field(50014; Service; Code[20])
        {
            CaptionML = ENG = 'Service', FRA = 'Service';
        }
        field(50015; Section; Code[20])
        {
            CaptionML = ENG = 'Section', FRA = 'Section';
        }
        field(50016; "Day Indemnity"; Decimal)
        {
            CaptionML = ENG = 'Day Indemnity', FRA = 'Jour indemnité';
        }
        field(50017; "Worked Days (Hours)"; Decimal)
        {
            CaptionML = ENG = 'Worked Days (Hours)', FRA = 'Jours Travaille (Horaire)';
        }
        field(50018; "Pulic Holiday Days"; Decimal)
        {
            CaptionML = ENG = 'Holiday Days', FRA = 'Jour Ferié';
        }
        field(50019; "Pulic Holiday Amount"; Decimal)
        {
            Editable = false;
            CaptionML = ENG = 'Holiday Amount', FRA = 'Montant Jours Férie';
        }
        field(50022; "P-Encouragement"; Decimal)
        {
            CaptionML = ENG = 'P-Encouragement', FRA = 'P-Encouragement';
        }
        field(50023; "P-Bonus"; Decimal)
        {
            CaptionML = ENG = 'P-Bonus', FRA = 'P-Bonus';
        }
        field(50024; "Team Bonus"; Decimal)
        {
            CaptionML = ENG = 'Team Bonus', FRA = 'P-Equipe';
        }
        field(50025; "Exceptional Bonus"; Decimal)
        {
            CaptionML = ENG = 'Exceptional Bonus', FRA = 'P-Exceptionlle';
        }
        field(50026; "Competence Bonus"; Decimal)
        {
            CaptionML = ENG = 'Competence Bonus', FRA = 'P-Comptétence';
        }
        field(50027; "Overtime Houres Pay"; Decimal)
        {
            CaptionML = ENG = 'Overtime Houres Pay', FRA = 'P-Heures Majoré';
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
            CaptionML = ENG = 'Back Pay', FRA = 'Rappel';
        }
        field(50032; "Productivity Bonus"; Decimal)
        {
            CaptionML = ENG = 'Productivity Bonus', FRA = 'P-Productivité';
        }
        field(50033; "Quality Coordination Bonus"; Decimal)
        {
            CaptionML = ENG = 'Quality Coordination Bonus', FRA = 'P-Coord-Qualité';
        }
        field(50034; "13th Month Pay"; Decimal)
        {
            CaptionML = ENG = '13th Month Pay', FRA = 'P-13EMois';
        }
        field(50036; "Quarterly Bonus"; Decimal)
        {
            CaptionML = ENG = 'Quarterly Bonus', FRA = 'P-Trimestrielle';
        }
        field(50037; "End of Contract Balance Amount"; Decimal)
        {
            CaptionML = ENG = 'End of Contract Pay', FRA = 'P-Solde-Fin-Contrat';
        }
        field(50038; "Gratification Aid"; Decimal)
        {
            CaptionML = ENG = 'Gratification Aid', FRA = 'Gratification Aid';
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
            CaptionML = ENG = 'Other Recall', FRA = 'Rappel-PAutre';
        }
        field(50045; "Transport Bonus"; Decimal)
        {
            CaptionML = ENG = 'Transport Bonus', FRA = 'P-Transport';
        }
        field(50047; "Breastfeeding Hours"; Decimal)
        {
            CaptionML = ENG = 'Breastfeeding Hours', FRA = 'H.Allaittement';
        }
        field(50048; "Accident Hours"; Decimal)
        {
            CaptionML = ENG = 'Accident Hours', FRA = 'Heure A.T';
        }
        field(50049; "Accident Amount"; Decimal)
        {
            Editable = false;
            CaptionML = ENG = 'Accident Amount', FRA = 'Montant A.T';
        }

        field(50052; "Overtime Days"; Decimal)
        {
            CaptionML = ENG = 'Overtime Days', FRA = 'Jour Sup';
        }
        field(50053; "Overtime Amount"; Decimal)
        {
            CaptionML = ENG = 'Overtime Amount', FRA = 'Montant J.Sup';
        }
        field(50054; Fortnight; Enum "WDC Fortnight")
        {
            CaptionML = ENG = 'Fortnight', FRA = 'Quinzaine';
        }
        field(50055; "Productivité"; Decimal)
        {
            CaptionML = ENG = 'Productivity', FRA = 'Productivité';
        }
    }

    keys
    {
        key(Key1; "Transaction No.", "Line No.", "Employee No.")
        {
            Clustered = true;
            SumIndexFields = "Hours Number", "Line Amount", "Days Number", "Breastfeeding Hours", "Accident Hours", "Pulic Holiday Days";
        }
        key(Key2; "Employee No.", "Department code", "Folder Code", "Posting Date", "Days Type")
        {
            SumIndexFields = "Hours Number", "Line Amount", "Days Number", "Breastfeeding Hours", "Accident Hours", "Pulic Holiday Days";
        }
        key(Key3; "Employee No.", "Payment Month", "Payment Year", "Payment No.")
        {
            SumIndexFields = "Hours Number", "Line Amount", "Days Number", "Breastfeeding Hours", "Accident Hours", "Pulic Holiday Days";
        }
        key(Key4; "Overtime Rate")
        {
            SumIndexFields = "Hours Number", "Line Amount", "Days Number", "Breastfeeding Hours", "Accident Hours", "Pulic Holiday Days";
        }
        key(Key5; "Employee No.", "Posting Date", "Payment Month", "Payment Year", "Payment No.", Week)
        {
            SumIndexFields = "Hours Number", "Line Amount", "Days Number", "Breastfeeding Hours", "Accident Hours", "Pulic Holiday Days";
        }
        key(Key6; "Employee No.")
        {
            SumIndexFields = "Hours Number", "Line Amount", "Days Number", "Breastfeeding Hours", "Accident Hours", "Pulic Holiday Days";
        }
        key(Key7; "Payment Month", "Payment Year", "Posting Date", "Employee No.")
        {
        }
        key(Key8; "Employee No.", "Overtime Rate", "Payment Month", "Payment Year")
        {
        }
        key(Key9; "Employee No.", "Posting Date", "Payment No.")
        {
            SumIndexFields = "Hours Number", "Line Amount", "Days Number", "Breastfeeding Hours", "Accident Hours", "Pulic Holiday Days";
        }
        key(Key10; "Employee No.", "Payment Month", "Payment Year", Fortnight, "Payment No.")
        {
            SumIndexFields = "Hours Number", "Line Amount", "Days Number", "Breastfeeding Hours", "Accident Hours", "Pulic Holiday Days";
        }
    }

    fieldgroups
    {
    }
}

