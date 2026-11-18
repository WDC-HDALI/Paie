table 55003 "WDC work Regimes"
{
    CaptionML = ENU = 'Regimes of work', FRA = 'Régimes travail';
    DrillDownPageID = 55002;
    LookupPageID = 55002;
    Permissions = TableData 55003 = rimd;

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(2; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(5; "Work Hours per week"; Decimal)
        {
            CaptionML = ENU = 'Work Hours per week', FRA = 'Heures travail par semaine';
        }
        field(10; "Max. Supp. Hours per month"; Decimal)
        {
            CaptionML = ENU = 'Max. Supp. Hours per month', FRA = 'Max. heures supp. par mois';
        }
        field(15; "Days off per month"; Decimal)
        {
            CaptionML = ENU = 'Days off per month', FRA = 'Jours congé par mois';
        }
        field(16; "Assignement mode"; Enum "WDC Assignement mode")
        {
            CaptionML = ENU = 'Assignement mode', FRA = 'Mode d''affectation';
        }
        field(40; "Default Regime"; Boolean)
        {
            CaptionML = ENU = 'Default Regime', FRA = 'Régime par défaut';
        }
        field(50; "Worked Day Per Month"; Decimal)
        {
            CaptionML = ENU = 'Worked Day Per Month', FRA = 'Jours travaillés par mois';

            trigger OnValidate()
            begin
                "Nbre Jour Payé Per Month" := "Worked Day Per Month";
                MODIFY
            end;
        }
        field(100; "Work Hours per month"; Decimal)
        {
            CaptionML = ENU = 'Work Hours per month', FRA = 'Heures travail par mois';
        }
        field(50100; "Rate of Night"; Decimal)
        {
            CaptionML = ENU = 'Rate of Night', FRA = 'Taux nuit';
        }
        field(50101; "Rate of No Working Day"; Decimal)
        {
            CaptionML = ENU = 'Rate of No Working Day', FRA = 'Taux jour non travaillé';
        }
        field(50102; "Rate of No Working Paied Day"; Decimal)
        {
            CaptionML = ENU = 'Rate of No Working Paied Day', FRA = 'Taux jour chômé payé';
        }
        field(50200; "Rate of Roulement"; Decimal)
        {
            CaptionML = ENU = 'Rate of Roulement', FRA = 'Taux roulement';
        }
        field(50201; "Appliquer Régime"; Boolean)
        {
            CaptionML = ENU = 'Appliquer Régime', FRA = 'Appliquer régime';
        }
        field(50202; "taux indem panier"; Decimal)
        {
            CaptionML = ENU = 'taux indem panier', FRA = 'Taux indemnité panier';
        }
        field(8099198; "User ID"; Code[20])
        {
            CaptionML = ENU = 'User ID', FRA = 'ID utilisateur';
            Editable = false;
            TableRelation = User;
        }
        field(8099199; "Last Date Modified"; Date)
        {
            CaptionML = ENU = 'Last Date Modified', FRA = 'Dernière date modifiée';
            Editable = false;
        }
        field(39001440; "Calendar Type"; Enum "WDC Calendar Type")
        {
            CaptionML = ENU = 'Type Calendar', FRA = 'Type calendrier';
        }
        field(39001450; "Activer Jour Repos"; Boolean)
        {
            CaptionML = ENU = 'Activer Jour Repos', FRA = 'Activer jour repos';
        }
        field(39001460; "Rate of Repos Days"; Decimal)
        {
            CaptionML = ENU = 'Rate of Repos Days', FRA = 'Taux jours repos';
        }
        field(39001461; "Calculating Overtime Hours"; enum "WDC Calculating Overtime Hours")
        {
            CaptionML = ENU = 'Calculating Overtime Hours', FRA = 'Type calcul H. Supp.';
        }
        field(39001462; "Type Calcul H Nuit"; Enum "WDC Type Calcul Heures Nuit")
        {
            CaptionML = ENU = 'Type Calcul H Nuit', FRA = 'Type calcul H nuit';
        }
        field(39001463; "Nbre Jour Payé Per Month"; Decimal)
        {
            CaptionML = ENU = 'Nbre Jour Payé Per Month', FRA = 'Nombre jours payés par mois';
            DecimalPlaces = 0 : 2;
        }
        field(39001464; "Taux heure supp maj"; Decimal)
        {
            CaptionML = ENU = 'Taux heure supp maj', FRA = 'Taux heure supp maj';
            Description = 'mby SAMI';
        }
        field(39001465; "From Work day to Work hour"; Decimal)
        {
            CaptionML = ENU = 'From Work day to Work hour', FRA = 'De jour travaillé à heure travaillée';
            DecimalPlaces = 3 : 3;
        }
        field(39001466; "Taux Jours Férié"; Decimal)
        {
            CaptionML = ENU = 'Taux Jours Férié', FRA = 'Taux jours fériés';
        }
        field(39001467; "Rétributions Ancienneté/An"; Decimal)
        {
            CaptionML = ENU = 'Rétributions Ancienneté/An', FRA = 'Rétributions ancienneté/an';
        }
        field(39001468; "Plafond Ancienneté/An"; Decimal)
        {
            CaptionML = ENU = 'Plafond Ancienneté/An', FRA = 'Plafond ancienneté/an';
        }
        field(39001470; "Limite ancienneté"; Decimal)
        {
            CaptionML = ENU = 'Limite ancienneté', FRA = 'Limite ancienneté';
        }
        field(39001490; "Payroll Calculation Type"; enum "WDC Calcul Payroll Type")
        {
            CaptionML = ENU = 'Payroll Calculation Type', FRA = 'Type calcul paie';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }


}

