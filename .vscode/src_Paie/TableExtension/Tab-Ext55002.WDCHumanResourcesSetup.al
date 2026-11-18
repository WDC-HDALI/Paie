tableextension 55002 "WDC Human Resources Setup" extends "Human Resources Setup"
{

    fields
    {
        field(50008; "Amount retained cash FS"; Decimal)
        {
            CaptionML = ENU = 'Amount retained cash FS', FRA = 'Montant retenu en espèces FS';
        }
        field(50009; "Loan Calculation Type"; Option)
        {
            OptionCaptionML = ENU = 'Number of bracket,Bracket amount', FRA = 'Nombre tranche,Montant tranche';
            OptionMembers = "Nombre de tranche","Slice Amount";
        }
        field(50011; "Calculate Absence Amount"; Boolean)
        {
            CaptionML = ENU = 'Calculate Absence Amount', FRA = 'Calcul Montant absence';
        }
        field(50021; "Code CSS Contribution"; Code[20])
        {
            CaptionML = ENU = 'Code CSS Contribution', FRA = 'Code Cotisation CSS';
            TableRelation = "WDC Social Contribution".Code;
        }
        field(50031; "Matricule Directeur Général"; Code[20])
        {
            CaptionML = ENU = 'General Manager Registration No. ', FRA = 'Matricule Directeur Général';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF "Matricule Directeur Général" <> '' THEN BEGIN
                    RecGEmploy.RESET;
                    RecGEmploy.SETRANGE(RecGEmploy."No.", "Matricule Directeur Général");
                    RecGEmploy.Findfirst();
                    "Nom Prénom DG" := RecGEmploy."First Name" + ' ' + RecGEmploy."Last Name";
                END ELSE
                    "Nom Prénom DG" := '';
            end;
        }
        field(50032; "Nom Prénom DG"; Text[65])
        {
            Editable = false;
        }
        field(50033; "Matricule Chef Service RH"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF "Matricule Chef Service RH" <> '' THEN BEGIN
                    RecGEmploy.RESET;
                    RecGEmploy.SETRANGE(RecGEmploy."No.", "Matricule Chef Service RH");
                    RecGEmploy.Findfirst();
                    "Nom Prénom Chef Sce RH" := RecGEmploy."First Name" + ' ' + RecGEmploy."Last Name";
                END ELSE
                    "Nom Prénom Chef Sce RH" := '';
            end;
        }
        field(50034; "Nom Prénom Chef Sce RH"; Text[65])
        {
            Editable = false;
        }
        field(50035; "Registration number D.A.F"; Code[20])
        {
            CaptionMl = ENU = 'Registration number D.A.F', FRA = 'Matricule D.A.F';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF "Registration number D.A.F" <> '' THEN BEGIN
                    RecGEmploy.RESET;
                    RecGEmploy.SETRANGE(RecGEmploy."No.", "Registration number D.A.F");
                    RecGEmploy.Findfirst();
                    "D.A.F. Full Name" := RecGEmploy."First Name" + ' ' + RecGEmploy."Last Name";
                END ELSE
                    "D.A.F. Full Name" := '';
            end;
        }
        field(50036; "D.A.F. Full Name"; Text[100])
        {
            CaptionMl = ENU = 'D.A.F. Full Name', FRA = 'Nom prénom D.A.F';
        }
        field(50037; "Income Tax Calculation Ceiling"; Decimal)
        {
            CaptionMl = ENU = 'Income Tax Calculation Ceiling', FRA = 'Plafond Calcul IRPP';
        }
        field(50038; "Active IRPP Ceiling"; Boolean)
        {
            CaptionMl = ENU = 'Active IRPP Ceiling', FRA = 'Activer Plafond IRPP';
        }

        field(50042; "Payslip PDF Path"; Text[250])
        {
            CaptionML = ENU = 'Payslip PDF Path', FRA = 'Chemin Fiche de Paie PDF';
            trigger OnLookup()
            var
                FileMgt: Codeunit "File Management";
                TempBlob: Codeunit "Temp Blob";
                FileName: Text;
                FileName2: Text;
                Path: Text;
            begin
                FileName := "Payslip PDF Path" + STRSUBSTNO('\%1.PDF');
                FileName2 := FileMgt.BLOBImport(TempBlob, FileName);
                IF FileName2 <> '' THEN BEGIN
                    Path := FileMgt.GetDirectoryName(FileName2);
                    IF Path <> '' THEN
                        "Payslip PDF Path" := COPYSTR(Path, 1, 250);
                END;
            end;
        }
        field(50043; "Responsable Address"; Text[250])
        {
            CaptionML = ENU = 'Responsable Address', FRA = 'Adresse Responsable';
        }
        field(50044; "Responsable Name"; Text[250])
        {
            CaptionML = ENU = 'Responsable Name', FRA = 'Nom Responsable';
        }
        field(50045; "Transfer ATB Bank"; Code[20])
        {
            CaptionML = ENU = 'Transfer ATB Bank', FRA = 'Virement Banque ATB';
            TableRelation = "Bank Account"."No.";
        }
        field(50046; "P-Encouragement"; Code[20])
        {
            CaptionML = ENU = 'P-Encouragement', FRA = 'P-Encouragement';
            TableRelation = "WDC Indemnity";
        }
        field(50047; "P-Bonus"; Code[20])
        {
            CaptionML = ENU = 'P-Bonus', FRA = 'P-Bonus';
            TableRelation = "WDC Indemnity";
        }
        field(50048; "Team Bonus"; Code[20])
        {
            CaptionML = ENU = 'Team Bonus', FRA = 'Prime Équipe';
            TableRelation = "WDC Indemnity";
        }
        // field(50049; "Exceptional Bonus"; Code[20])
        // {
        //     TableRelation = "WDC Indemnity";
        // }
        field(50050; "Competence Bonus"; Code[20])
        {
            CaptionML = ENU = 'Competence Bonus', FRA = 'Prime Compétences';
            TableRelation = "WDC Indemnity";
        }
        field(50051; "Overtime Houres Bonus"; Code[20])
        {
            captionML = ENU = 'Overtime Houres Bonus', FRA = 'Prime Heures Supp.';
            TableRelation = "WDC Indemnity";
        }
        field(50052; "Mission Bonus"; Code[20])
        {
            captionML = ENU = 'Mission Bonus', FRA = 'Prime Mission';
            TableRelation = "WDC Indemnity";
        }
        field(50053; "Assignment Bonus"; Code[20])
        {
            CaptionML = ENU = 'Assignment Bonus', FRA = 'Prime Affectation';
            TableRelation = "WDC Indemnity";
        }
        field(50054; "Position Bonus"; Code[20])
        {
            captionML = ENU = 'Position Bonus', FRA = 'Prime Poste';
            TableRelation = "WDC Indemnity";
        }
        field(50055; "Back Pay"; Code[20])
        {
            captionML = ENU = 'Back Pay', FRA = 'Rappel Salaire';
            TableRelation = "WDC Indemnity";
        }
        field(50056; "Productivity Bonus"; Code[20])
        {
            captionML = ENU = 'Productivity Bonus', FRA = 'Prime Productivité';
            TableRelation = "WDC Indemnity";
        }
        field(50057; "Quality Coordination Bonus"; Code[20])
        {
            captionML = ENU = 'Quality Coordination Bonus', FRA = 'Prime Coordination Qualité';
            TableRelation = "WDC Indemnity";
        }
        field(50058; "13th Month Bonus"; Code[20])
        {
            CaptionML = ENU = '13th Month Bonus', FRA = 'Prime 13ème Mois';
            TableRelation = "WDC Indemnity";
        }
        field(50060; "Quarterly Bonus"; Code[20])
        {
            CaptionML = ENU = 'Quarterly Bonus', FRA = 'Prime Trimestrielle';
            TableRelation = "WDC Indemnity";
        }
        field(50061; "End of Contract Balance Amount"; Code[20])
        {
            CaptionML = ENU = 'End of Contract Balance Amount', FRA = 'Solde Fin de Contrat';
            TableRelation = "WDC Indemnity";
        }
        field(50062; "Gratification Aid"; Code[20])
        {
            CaptionML = ENU = 'Gratification Aid', FRA = 'Gratification Aid';
            TableRelation = "WDC Indemnity";
        }
        field(50063; Gratification; Code[20])
        {
            CaptionML = ENU = 'Gratification', FRA = 'Gratification';
            TableRelation = "WDC Indemnity";
        }
        field(50064; "Severance Pay Indemnity"; Code[20])
        {
            CaptionML = ENU = 'Severance Pay Indemnity', FRA = 'Ind. Départ';
            TableRelation = "WDC Indemnity";
        }
        field(50065; "Objective Bonus"; Code[20])
        {
            CaptionML = ENU = 'Objective Bonus', FRA = 'Prime Objectif';
            TableRelation = "WDC Indemnity";
        }
        field(50066; "Seniority Bonus"; Code[20])
        {
            CaptionML = ENU = 'Seniority Bonus', FRA = 'Prime Ancienneté';
            TableRelation = "WDC Indemnity";
        }
        field(50067; "Retirement Bonus"; Code[20])
        {
            CaptionML = ENU = 'Retirement Bonus', FRA = 'Prime Retraite';
            TableRelation = "WDC Indemnity";
        }
        field(50068; "Other Back Pay"; Code[20])
        {
            CaptionML = ENU = 'Other Back Pay', FRA = 'Autre Rappel de Salaire';
            TableRelation = "WDC Indemnity";
        }
        field(50069; "Transport Bonus"; Code[20])
        {
            CaptionML = ENU = 'Transport Bonus', FRA = 'Prime Transport';
            TableRelation = "WDC Indemnity";
        }
        field(50070; "Maternity Leave Indem."; Code[20])
        {
            CaptionML = ENU = 'Maternity Leave Indem', FRA = 'Indemnité Congé Maternité';
            TableRelation = "WDC Indemnity";
        }
        field(50071; "Hours A.T"; Code[20])
        {
            CaptionML = ENU = 'Hours A.T', FRA = 'Heures A.T';
            TableRelation = "WDC Indemnity";
        }

        field(50073; "Indem Overtime Days"; Code[20])
        {
            captionML = ENU = 'Overtime Days Indem.', FRA = 'Indemnité Jours supp.';
            TableRelation = "WDC Indemnity";
        }

        field(50075; "Activate Alert Other Payroll"; Boolean)
        {
            CaptionML = ENU = 'Activate Alert Other Payroll', FRA = 'Activer Alerte Paie Autre';
        }
        field(50079; "1/2 solde à partir de"; Decimal)
        {
        }
        field(50080; "Type de Note"; Option)
        {
            CaptionML = ENU = 'Type of Note', FRA = 'Type de Note';
            InitValue = Pourcentage;
            OptionCaptionML = ENU = 'Percentage,Coefficient', FRA = 'Pourcentage,Coefficient';
            OptionMembers = Pourcentage,Coefficient;
        }

        field(50085; "Monthes Number"; Enum "WDC type Retributions")
        {
            CaptionML = ENU = 'Months Number', FRA = 'Nombre Mois';
        }
        field(50086; "Directeur général"; Text[100])
        {
        }

        field(50089; "Activate Fortnightly Regime"; Boolean)
        {
            CaptionML = ENU = 'Activate Fortnightly Regime', FRA = 'Activer régime quinzaine';
        }
        field(50090; "Code Monthly Rend. Indem."; Code[20])
        {
            captionML = ENU = 'Code Monthly Rend. Indem.', FRA = 'Code Indemnité Rend. Mensuel';
            TableRelation = "WDC Indemnity";
        }
        field(50091; "Apply Monthly Perfor. Bonus"; Boolean)
        {
            CaptionML = ENU = 'Apply Monthly Perfor. Bonus', FRA = 'Appliquer Prime Rendement Mensuel';
        }
        field(50095; "Apply Loan After"; Boolean)
        {
            captionML = ENU = 'Apply Loan After', FRA = 'Appliquer Prêt Après';
        }
        field(50097; "Absence Reason for Expense"; Code[20])
        {
            captionML = ENU = 'Absence Reason for Expense', FRA = 'Motif Abscence pour Dép.';
            TableRelation = "Cause of Absence";
        }
        field(50101; "Payroll Calculation Date"; Integer)
        {
            captionML = ENU = 'Payroll Calculation Date', FRA = 'Date Calcul Paie';
        }

        field(50103; "Apply Retribution for Old Days"; Boolean)
        {
            captionML = ENU = 'Apply Retribution for Old Days', FRA = 'App.retribution jour ancien.';
        }


        field(50108; "Leave Balance Calc. Type"; enum "WDC Type calcul solde conge")
        {
            captionML = ENU = 'Leave Balance Calc. Type', FRA = 'Type calcul solde congé';
        }

        field(50122; "Indem Bonus diff."; Code[20])
        {
            captionML = ENU = 'Indem Bonus diff.', FRA = 'Indem diff. Prime';
            TableRelation = "WDC Indemnity";
        }
        field(50123; "Indem Salary Diff."; Code[20])
        {
            captionML = ENU = 'Indem Salary Diff.', FRA = 'Indem Diff. Salaire';
            TableRelation = "WDC Indemnity";
        }

        field(50127; "Calculate STC auto."; Boolean)
        {
            captionML = ENU = 'Calculate STC auto.', FRA = 'Calculer STC auto.';
        }

        field(50129; "Include Leave Entitlement Days"; Boolean)
        {
            captionML = ENU = 'Include leave entitlement days', FRA = 'Inclure jours droit congé';
        }
        field(50130; "Include Overtime Hours"; Boolean)
        {
            captionML = ENU = 'Include overtime hours', FRA = 'Inclure heures supp.';
        }
        field(50131; "Include Night Hours"; Boolean)
        {
            captionML = ENU = 'Include Night Hours', FRA = 'Inclure heures nuits';
        }

        field(50134; "Activate Bonus Type"; Boolean)
        {
            captionML = ENU = 'Activate Bonus Type', FRA = 'Activer Type Prime';
        }
        field(50135; "Deduction for Familly Chief"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Deduction for Family Chief', FRA = 'Déduction Chef Famille';
        }
        field(50136; "From Work day to Work hour"; Decimal)
        {
            CaptionML = ENU = 'From Work day to Work hour', FRA = 'De jour travaillé à heure travaillée';
            DecimalPlaces = 3 : 3;
        }
        field(50137; "Regulation Taxe"; Enum "WDC Regulation Taxe")
        {
            CaptionML = ENU = 'Regulation Taxe', FRA = 'Régulation Fiscale';
        }
        field(50138; "Minimum Wage Guarantee"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Minimum Wage Guarantee', FRA = 'Garantie Salaire Minimum';
        }
        field(50139; "Pourcent professional expenses"; Decimal)
        {
            CaptionML = ENU = '% Professional Expenses', FRA = '% Frais Professionnels';
        }
        field(50140; "Paid days"; Decimal)
        {
            CaptionML = ENU = 'Paid Days', FRA = 'Jours Payés';
        }
        field(50141; "Worked days"; Decimal)
        {
            CaptionML = ENU = 'Worked Days', FRA = 'Jours Travaillés';
        }
        field(50143; "Paiment Nos."; Code[20])
        {
            CaptionML = ENU = 'Payment Nos.', FRA = 'N° Paiement';
            TableRelation = "No. Series";
        }
        field(50144; "Employment Contract Nos."; Code[20])
        {
            CaptionML = ENU = 'Employment Contract Nos.', FRA = 'N° Contrat Emploi';
            TableRelation = "No. Series";
        }
        field(50145; "Loan & Advance Nos."; Code[20])
        {
            CaptionML = ENU = 'Loan & Advance Nos.', FRA = 'N° Prêt & Avance';
            TableRelation = "No. Series";
        }
        field(50146; "Salary grid Nos."; Code[20])
        {
            CaptionML = ENU = 'Salary Grid Nos.', FRA = 'N° Grille Salaire';
            TableRelation = "No. Series";
        }
        field(50147; "Supp. hours Nos."; Code[20])
        {
            CaptionML = ENU = 'Supplementary Hours Nos.', FRA = 'N° Heures Supplémentaires';
            TableRelation = "No. Series";
        }
        field(50148; "General Journal Template"; Code[20])
        {
            CaptionML = ENU = 'General Journal Template', FRA = 'Modèle Journal Général';
            TableRelation = "Gen. Journal Template";
        }
        field(50149; "Gen. Journal Batch (Payroll)"; Code[20])
        {
            CaptionML = ENU = 'Gen. Journal Batch (Payroll)', FRA = 'Lot Journal Général (Paie)';

            trigger OnLookup()
            begin
                IF "General Journal Template" <> '' THEN BEGIN
                    GenJournalBatch.SETRANGE("Journal Template Name", "General Journal Template");
                    IF GenJournalBatch.FINDFIRST THEN BEGIN
                        PageGenJournalBatch.SETTABLEVIEW(GenJournalBatch);
                        IF PAGE.RUNMODAL(0, GenJournalBatch) = ACTION::LookupOK THEN BEGIN
                            "Gen. Journal Batch (Payroll)" := GenJournalBatch.Name;
                            MODIFY;
                        END;
                    END;
                END
            end;
        }
        field(50150; "Gen. Journal Batch (L&A)"; Code[20])
        {
            CaptionML = ENU = 'Gen. Journal Batch (Loan & Advance)', FRA = 'Lot Journal Général (Prêt & Avance)';

            trigger OnLookup()
            begin
                IF "General Journal Template" <> '' THEN BEGIN
                    GenJournalBatch.SETRANGE("Journal Template Name", "General Journal Template");
                    IF GenJournalBatch.FINDFIRST THEN BEGIN
                        PageGenJournalBatch.SETTABLEVIEW(GenJournalBatch);
                        IF PAGE.RUNMODAL(0, GenJournalBatch) = ACTION::LookupOK THEN BEGIN
                            "Gen. Journal Batch (L&A)" := GenJournalBatch.Name;
                            MODIFY;
                        END;
                    END;
                END
            end;
        }
        field(50151; "Loss on rounding amounts"; Code[20])
        {
            CaptionML = ENU = 'Loss on Rounding Amounts', FRA = 'Perte sur Arrondis';
            TableRelation = "G/L Account";
        }
        field(50154; "Default Panier"; Code[20])
        {
            captionML = ENU = 'Default Panier', FRA = 'Panier par défaut';
        }
        field(50155; "Annual Days Number"; Decimal)
        {
            captionML = ENU = 'Annual Days Number', FRA = 'NB Jours annuel';
        }
        field(50156; "Annual Hours Number"; Decimal)
        {
            captionML = ENU = 'Annual Hours Number', FRA = 'NB Heures annuel';
        }

        field(50163; "Rounded Amount"; Decimal)
        {
            captionML = ENU = 'Rounded Amount', FRA = 'Montant Arrondi';
            DecimalPlaces = 0 : 3;
        }

        field(50168; "Loan Limit Mode"; Option)
        {
            CaptionML = ENU = 'Loan limit mode', FRA = 'Mode limite avance prêt';
            OptionCaptionML = ENU = 'Percentage,Amount', FRA = 'Pourcentage,Montant';
            OptionMembers = Pourcentage,Montant;

            trigger OnValidate()
            begin
                Value := 0;
                MODIFY
            end;
        }
        field(50169; Value; Decimal)
        {
            CaptionML = ENU = 'Value', FRA = 'Valeur';
        }
        field(50170; "Bonus calculation Type"; Enum "WDC Bonus Calculation Type")
        {
            CaptionML = ENU = 'Bonus calculation Type', FRA = 'Type calcul prime';
        }
        field(50171; "Professional Expenses Charges"; Decimal)
        {
            CaptionML = ENU = '"Professional Expenses Ceiling"', FRA = 'Plafond Frais professionnel';
        }
        field(50178; Commission; Code[20])
        {
            captionML = ENU = 'Commission', FRA = 'Commission';
            TableRelation = "WDC Indemnity";
        }
        field(50180; "Exceptional Bonus"; Code[20])
        {
            CaptionML = ENU = 'Exceptional Bonus', FRA = 'Prime Exceptionnel';
            TableRelation = "WDC Indemnity";
        }
        field(50181; "Exceptional Bonus Amount"; Decimal)
        {
            CaptionML = ENU = 'Exceptional Bonus Amount', FRA = 'Montant Prime Exceptionnel';
        }
        field(50182; "Paid Holiday Indemnity"; Code[20])
        {
            CaptionML = ENU = 'Paid Holiday Indemnity', FRA = 'Indemnité Congés Payés';
            TableRelation = "WDC Indemnity";
        }
        field(50183; "Indem Aid Fitr"; Code[20])
        {
            CaptionML = ENU = 'Fitr Aid Indemnity', FRA = 'Indemnité Aide Fitr';
            TableRelation = "WDC Indemnity";
        }
        field(50184; "Indem Aid Idhha"; Code[20])
        {
            CaptionML = ENU = 'Idhha Aid Indemnity', FRA = 'Indemnité Aide Idhha';
            TableRelation = "WDC Indemnity";
        }
        field(50185; "Indem Don Rent"; Code[20])
        {
            CaptionML = ENU = 'Donation Rent Indemnity', FRA = 'Indemnité Don Rent';
            TableRelation = "WDC Indemnity";
        }
        field(50186; "Gross Salary without SIVP"; Code[20])
        {
            CaptionML = ENU = 'Gross Salary without SIVP', FRA = 'Salire Brut sans SIVP';
            TableRelation = "G/L Account";
        }
        field(50187; "Gross Salary SIVP"; Code[20])
        {
            CaptionML = ENU = 'Gross Salary SIVP', FRA = 'Salaire Brut SIVP';
            TableRelation = "G/L Account";
        }
        field(50188; "Tax.Ind.not sub.to soc. cont."; Code[20])
        {
            CaptionML = ENU = 'Taxable Indem. not subject to soc. contr.', FRA = 'Indemnité Imposable non cotisable';
            TableRelation = "G/L Account";
        }
        field(50189; "Social Charges 17,37%"; Code[20])
        {
            CaptionML = ENU = 'Social Charges 17,37%', FRA = 'Charge sociale 17,37%';
            TableRelation = "G/L Account";
        }
        field(50190; "AGA Star Debit"; Code[20])
        {
            CaptionML = ENU = 'AGA Star Debit', FRA = 'AGA Star Débit';
            TableRelation = "G/L Account";
        }
        field(50191; "AGA Star Credit"; Code[20])
        {
            CaptionML = ENU = 'AGA Star Credit', FRA = 'AGA Star Crédit';
            TableRelation = "G/L Account";
        }
        field(50192; "CNSS"; Code[20])
        {
            CaptionML = ENU = 'CNSS', FRA = 'CNSS';
            TableRelation = "G/L Account";
        }
        field(50193; "IRPP"; Code[20])
        {
            CaptionML = ENU = 'IRPP', FRA = 'IRPP';
            TableRelation = "G/L Account";
        }
        field(50194; "CSS"; Code[20])
        {
            CaptionML = ENU = 'CSS', FRA = 'CSS';
            TableRelation = "G/L Account";
        }
        field(50195; "Advance"; Code[20])
        {
            CaptionML = ENU = 'Advance', FRA = 'Avance';
            TableRelation = "G/L Account";
        }
        field(50196; "Bus Deduction"; Code[20])
        {
            CaptionML = ENU = 'Bus Deduction', FRA = 'Retenue Car';
            TableRelation = "G/L Account";
        }
        field(50197; "Insurance"; Code[20])
        {
            CaptionML = ENU = 'Insurance', FRA = 'Assurance';
            TableRelation = "G/L Account";
        }
        field(50198; "Retirement Plus"; Code[20])
        {
            CaptionML = ENU = 'Retirement Plus', FRA = 'Retraite Plus';
            TableRelation = "G/L Account";
        }
        field(50199; "Loan"; Code[20])
        {
            CaptionML = ENU = 'Loan', FRA = 'Prêt';
            TableRelation = "G/L Account";
        }
        field(50200; "Net Salary"; Code[20])
        {
            CaptionML = ENU = 'Net Salary', FRA = 'CNSS AG-Anteil';
            TableRelation = "G/L Account";
        }
        field(50201; "CNSS AG-Anteil"; Code[20])
        {
            CaptionML = ENU = 'CNSS AG-Anteil', FRA = 'CNSS AG-Anteil';
            TableRelation = "G/L Account";
        }
    }

    var
        GenJournalBatch: Record "Gen. Journal Batch";
        PageGenJournalBatch: Page "General Journal Batches";
        RecGEmploy: Record Employee;
}

