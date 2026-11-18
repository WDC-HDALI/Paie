tableextension 55000 "WDC Employee" extends Employee
{


    fields
    {
        modify("First Name")
        {
            trigger OnAfterValidate()
            var
                EmpCont: Record "Employment Contract";
            begin

                EmpCont.RESET;
                EmpCont.SETRANGE(Code, "No.");
                IF EmpCont.Findfirst THEN BEGIN
                    EmpCont.Description := "First Name" + ' ' + "Last Name";
                    EmpCont.MODIFY;
                END
            end;
        }
        modify("Middle Name")
        {
            trigger OnAfterValidate()
            var
                EmpCont: Record "Employment Contract";
            begin
                EmpCont.RESET;
                EmpCont.SETRANGE(Code, "No.");
                IF EmpCont.Findfirst THEN BEGIN
                    EmpCont.Description := "First Name" + ' ' + "Last Name";
                    EmpCont.MODIFY;
                END
            end;
        }
        modify("Last Name")
        {
            trigger OnAfterValidate()
            var
                EmpCont: Record "Employment Contract";
            begin
                EmpCont.RESET;
                EmpCont.SETRANGE(Code, "No.");
                IF EmpCont.Findfirst THEN BEGIN
                    EmpCont.Description := "First Name" + ' ' + "Last Name";
                    EmpCont.MODIFY;
                END
            end;
        }

        field(55000; "Family Situation A"; Enum "WDC Family Situation A")
        {
            CaptionML = ENG = 'Family Situation', FRA = 'Situation familiale';
            trigger OnValidate()
            begin
                IF Rec.Gender = Rec.Gender::Male THEN
                    IF Rec."Family Situation A" = Rec."Family Situation A"::Married THEN
                        "Family chief" := TRUE
                    ELSE
                        "Family chief" := FALSE
            end;
        }
        field(55001; "Working Relationship"; Enum "WDC Working relationship")
        {
            CaptionML = ENG = 'Working Relationship', FRA = 'Relation de travail';
        }
        // field(55002; "CIN No."; Code[8])
        // {
        //     CaptionML = ENG = 'CIN No.', FRA = 'N° CIN';

        //     trigger OnValidate()
        //     begin

        //         "CIN No." := "CIN No.";
        //         MODIFY;
        //     end;
        // }

        field(50228; "Empl. Posting Group"; Code[30])
        {
            CaptionML = ENU = 'Employee Posting Group', FRA = 'Groupe compta. employee';
            TableRelation = "WDC Employee Posting Group";
        }
        field(55003; "Passeport No."; Code[20])
        {
            CaptionML = ENG = 'Passeport No.', FRA = 'N° Passeport';
        }
        field(55004; "CAVIS No."; Code[20])
        {
            CaptionML = ENG = 'CAVIS No.', FRA = 'N° CAVIS';
        }
        field(55005; "Place CIN"; Text[30])
        {
            CaptionML = ENG = 'Place CIN', FRA = 'Lieu CIN';
        }
        field(55006; "Birth place A"; Text[30])
        {
            CaptionML = ENG = 'Birth place A', FRA = 'Lieu Naissance A';
        }
        field(55007; "Contract Number"; Integer)
        {
            CaptionML = ENG = 'Contract Number', FRA = 'Nombre contrat';
            CalcFormula = Count("WDC Career Record" WHERE("Type Career Record" = FILTER("Recruitment" | "Mutation"),
                                                          "Status Career Record" = CONST(Active),
                                                          "Employee No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(55008; "Education Level"; Enum "WDC Level of Education")
        {
            CaptionML = ENG = 'Education Level', FRA = 'Niveau d''instruction';
        }
        field(55009; Degree; Code[50])
        {
            CaptionML = ENG = 'Degree', FRA = 'Diplôme';

        }
        field(55010; "Application Selection"; Boolean)
        {
            CaptionML = ENG = 'Application Selection', FRA = 'Sélection demande';
        }
        field(55011; "Social Category"; Enum "WDC Social Category")
        {
            CaptionML = ENG = 'Social Category', FRA = 'Catégorie sociale';
        }
        field(55012; Selection; Boolean)
        {
            CaptionML = ENG = 'Selection', FRA = 'Sélection';
        }
        field(55013; "Year of Graduation"; Integer)
        {
            CaptionML = ENG = 'Year of Graduation', FRA = 'Année Diplôme';
        }
        field(55014; "Specialization"; Text[60])
        {
            CaptionML = ENG = 'Specialization', FRA = 'Spécialité';
        }
        field(55015; "CIN Issued on"; Date)
        {
            CaptionML = ENG = 'CIN Issued on', FRA = 'CIN Délivrée le';
        }

        field(55017; Abattement; Boolean)
        {
            CaptionML = ENG = 'Abattement', FRA = 'Abattement';
        }
        field(55018; Management; Code[20])
        {
            TableRelation = "WDC Management".Code;
            CaptionML = ENG = 'Direction', FRA = 'Direction';
            trigger OnValidate()
            begin
                CALCFIELDS("Job Description");
                IF Management <> xRec.Management THEN BEGIN
                    VALIDATE(Service, '');
                    VALIDATE(Section, '');
                END;
            end;
        }
        field(55019; "Job Description"; Text[100])
        {
            CaptionML = ENG = 'Job Description', FRA = 'Description Direction';

            CalcFormula = Max("WDC Management".Designation WHERE(Code = FIELD(Management)));
            FieldClass = FlowField;
        }
        field(55020; Service; Code[20])
        {
            TableRelation = "WDC Service".Service WHERE(Management = FIELD(Management));

            trigger OnValidate()
            begin
                CALCFIELDS("Service Description");
                IF Service <> xRec.Service THEN BEGIN
                    VALIDATE(Section, '');
                END;
            end;
        }
        field(55021; "Service Description"; Text[50])
        {
            CaptionML = ENG = 'Service Description', FRA = 'Description Service';
            CalcFormula = Lookup("WDC Service".Description WHERE(Management = FIELD(Management),
                                                            Service = FIELD(Service)));
            FieldClass = FlowField;
        }
        field(55022; Section; Code[20])
        {
            CaptionML = ENG = 'Section', FRA = 'Section';
            TableRelation = IF (Management = CONST('SIEGE'))
                                "WDC Section".Section WHERE(Management = FIELD(Management),
                                                            Service = FIELD(Service),
                                                            "Employee Status Group" = FIELD("Statistics Group Code"))
            ELSE IF (Management = FILTER(<> 'SIEGE')) "WDC Section".Section WHERE(Management = FIELD(Management),
                                                                                      Service = FIELD(Service));

            trigger OnValidate()
            begin
                CALCFIELDS("Section Description");
                IF Management <> 'SIEGE' THEN
                    IF ("Global Dimension 1 Code" <> Section) AND (Section <> '') THEN
                        MESSAGE('Attention Incohérance entre section et affectation analytique');
            end;
        }
        field(55023; "Section Description"; Text[50])
        {
            CaptionML = ENG = 'Description Section', FRA = 'Description Section';
            CalcFormula = Lookup("WDC Section".Decription WHERE(Management = FIELD(Management),
                                                           Service = FIELD(Service),
                                                           Section = FIELD(Section)));
            FieldClass = FlowField;
        }
        field(55024; "Professional Experience"; Integer)
        {
            CaptionML = ENG = 'Professional Experience', FRA = 'Expérience Professionnelle';
        }
        field(55025; "Gross Salary"; Decimal)
        {
            CaptionML = ENG = 'Gross Salary', FRA = 'Salaire brut';
            AutoFormatType = 2;
            CalcFormula = Sum("WDC Default Indemnities"."Default Amount" WHERE("Emplymt. Contract Code" = FIELD("Emplymt. Contract Code")));
            DecimalPlaces = 3 : 3;
            Editable = true;
            FieldClass = FlowField;
        }
        field(55026; "Social Fund"; Boolean)
        {
            CaptionML = ENG = 'Social Fund', FRA = 'Caisse fonds social';
        }
        field(55027; "Worked Days Number"; Decimal)
        {
            CaptionML = ENG = 'Number of Days Worked', FRA = 'Nbre jours travaillés';
            CalcFormula = Sum("WDC Occasional Hours Recorded"."Days Number" WHERE("Employee No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(55028; "Seniority %"; Decimal)
        {
            CaptionML = ENG = 'Seniority %', FRA = '% Ancienneté';
        }
        field(55029; Situation; Enum "WDC Situation")
        {
            CaptionML = ENG = 'Situation', FRA = 'Situation';
        }
        field(55030; "Net Salary"; Decimal)
        {
            CaptionML = ENG = 'Net Salary', FRA = 'Salaire net';
            Editable = false;
        }
        field(55031; "Filter Date"; Date)
        {
            CaptionML = ENG = 'Filter Date', FRA = 'Date Filter recup';
            FieldClass = FlowFilter;
        }
        field(55032; "First Campaign"; Code[20])
        {
            CaptionML = ENG = 'First Campaign', FRA = 'Premier compagne';
        }
        field(55033; "Campaign Start Date"; Date)
        {
            CaptionML = ENG = 'Campaign Start Date', FRA = 'Date de compagne';
        }
        field(55034; "Campaign End"; Code[20])
        {
            CaptionML = ENG = 'Campaign End', FRA = 'Fin de compagne';
        }
        field(55035; "Bank Domiciliation"; Boolean)
        {
            CaptionML = ENG = 'Bank Domiciliation', FRA = 'Domiciliation bancaire';
        }
        field(55036; "Bank Account Number"; Code[20])
        {
            FieldClass = Normal;
            CaptionML = ENG = 'Bank Account Number', FRA = 'RIB';
        }
        field(55037; "Domiciliation Date"; Date)
        {
            CaptionML = ENG = 'Domiciliation Date', FRA = 'Date de domiciliation';
        }
        field(55038; "Issued On"; Date)
        {
            CaptionML = ENG = 'Issued On', FRA = 'Délivrée le';
        }
        field(55040; "CAVIS End Year"; Boolean)
        {
            CaptionML = ENG = 'CAVIS Year-End', FRA = 'CAVIS fin Année';
        }
        // field(55041; "Payment Method Code"; enum "WDC Payment Method")
        // {
        //     CaptionML = ENG = 'Payment Method', FRA = 'Mode de règlement';
        // }
        field(55042; "Days off  Recup-"; Decimal)
        {
            CalcFormula = Sum("WDC Employee's days off Entry"."Quantity (Days)" WHERE("Employee No." = FIELD("No."),
                                                                                   "Line type" = FILTER("Recovery Consumption"),
                                                                                   "Validity Date" = FIELD("Date Filter")));
            CaptionML = ENG = 'Day off consumed recup', FRA = 'Jours de récupération consommés';
            FieldClass = FlowField;
        }
        field(55043; "Days off + Recup"; Decimal)
        {
            CalcFormula = Sum("WDC Employee's days off Entry"."Quantity (Days)" WHERE("Employee No." = FIELD("No."),
                                                                                   "Line type" = FILTER("Recovery Right"),
                                                                                   "Validity Date" = FIELD("Date Filter")));
            CaptionML = ENG = 'Day off Right recup.', FRA = 'Jours de repos + récupération';
            FieldClass = FlowField;
        }
        field(55044; "Days off = Recup"; Decimal)
        {
            CalcFormula = Sum("WDC Employee's days off Entry"."Quantity (Days)" WHERE("Employee No." = FIELD("No."),
                                                                                   "Line type" = FILTER("Recovery Right" | "Recovery Consumption"),
                                                                                   "Validity Date" = FIELD("Date Filter")));
            CaptionML = ENG = 'Days off Remaining Recup.', FRA = 'Jours de repos / récupération restants';
            FieldClass = FlowField;
        }
        field(55045; Grade; Integer)
        {
            CaptionML = ENG = 'Grade', FRA = 'Grade';

            trigger OnValidate()
            begin
                HumanResSetup.FindSet();
                EmploymentContract.GET("Emplymt. Contract Code");

                IF NOT CONFIRM(Text002) THEN
                    ERROR(Text001) ELSE BEGIN
                    Linegrid.SETFILTER(Linegrid.Code, '%1', EmploymentContract."Salary grid");
                    Linegrid.SETFILTER(College, '%1', College);
                    Linegrid.SETFILTER(Echelon, '%1', Scale);
                    Linegrid.SETRANGE(Scale, Echelon);
                    IF Linegrid.FINDSET THEN
                        "Basis salary" := Linegrid."Base Salary"
                    ELSE
                        "Basis salary" := 0;
                END
            end;
        }
        field(55046; Scale; Integer)
        {
            CaptionML = ENG = 'Scale', FRA = 'Echelle';
            TableRelation = "WDC Scale".Scale WHERE(Category = FIELD(College));

            trigger OnValidate()
            begin
                HumanResSetup.Findfirst();
                EmploymentContract.GET("Emplymt. Contract Code");

                IF NOT CONFIRM(Text002) THEN
                    ERROR(Text001) ELSE BEGIN
                    Linegrid.SETFILTER(Linegrid.Code, '%1', EmploymentContract."Salary grid");
                    Linegrid.SETFILTER(College, '%1', College);
                    Linegrid.SETFILTER(Echelon, '%1', Echelon);
                    Linegrid.SETRANGE(Scale, Scale);
                    IF Linegrid.Findfirst() THEN
                        "Basis salary" := Linegrid."Base Salary"
                    ELSE
                        "Basis salary" := 0;
                END
            end;
        }
        field(55048; "Category Number"; Code[20])
        {
            CaptionML = ENG = 'Category Number', FRA = 'N° Catégorie';
        }
        field(55049; "Date of Tenure"; Date)
        {
            CaptionML = ENU = 'Date of Tenure', FRA = 'Date Titularisation';
        }
        field(50209; Overtime; Decimal)
        {
            CalcFormula = Sum("WDC Monthly Overtime Hours"."Hours Number" WHERE("Employee No." = FIELD("No."),
                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                 "Department Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Folder Code" = FIELD("Global Dimension 2 Filter")));
            FieldClass = FlowField;
            CaptionML = ENU = 'Overtime', FRA = 'Heures sup.';
            InitValue = 0;
        }

        field(50214; Note; Decimal)
        {
            CaptionML = ENU = 'Note', FRA = 'Note';

            trigger OnValidate()
            var
                DateFinYear: Date;
            begin
                IF Note <> 0 THEN
                    Purcent := (Note / 20) * 100
                ELSE
                    Purcent := 0;

            end;
        }
        field(50215; "Note Type"; Enum "WDC Note Type")
        {
            CaptionML = ENU = 'Note Type', FRA = 'Type de note';
            FieldClass = FlowFilter;
        }
        field(50216; Trimestre; Enum "WDC Quarter")
        {
            CaptionML = ENU = 'Quarter', FRA = 'Trimestre';
            FieldClass = FlowFilter;
        }
        field(50217; "Year Filter"; Integer)
        {
            CaptionML = ENU = 'Year Filter', FRA = 'Filtre année';
            FieldClass = FlowFilter;
        }
        field(50220; "Taxable Indemnity"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Sum("WDC Default Indemnities"."Basis amount" WHERE("Emplymt. Contract Code" = FIELD("Emplymt. Contract Code"),
                                                                          Type = FILTER(<> "Not Taxable"),
                                                                        "Conventional Indemnity" = FILTER(true)));
            CaptionML = ENU = 'Taxable Indemnity', FRA = 'Indemnité imposable';
            Editable = true;
            FieldClass = FlowField;
        }
        field(50223; Charge; Enum "WDC Charge")
        {
            CaptionML = ENU = 'Charge', FRA = 'Charge';
        }
        field(50224; "Basis salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Basis salary', FRA = 'Salaire de base';
            DecimalPlaces = 7 : 7;

        }
        field(50225; "Employee type"; Enum "WDC Employee type")
        {
            CaptionML = ENU = 'Employee type', FRA = 'Type d''employé';
        }
        field(50226; "CIN No."; Code[8])
        {
            CaptionML = ENU = 'CIN No.', FRA = 'N° CIN';
            Numeric = false;

            trigger OnValidate()
            begin
                Employee.RESET;
                Employee.SETRANGE("CIN No.", "CIN No.");
                IF Employee.Findfirst() THEN
                    ERROR(ERROR01, Employee."No.");
                txtcompany := COMPANYNAME;

                IF RecGCompany.Findfirst() THEN
                    REPEAT
                        ReCGEmployee.CHANGECOMPANY(RecGCompany.Name);
                        IF RecGCompany.Name <> txtcompany THEN BEGIN
                            ReCGEmployee.RESET;
                            ReCGEmployee.SETRANGE("CIN No.", "CIN No.");
                            IF ReCGEmployee.Findfirst() THEN
                                MESSAGE(ERROR02, ReCGEmployee."No.", RecGCompany.Name);
                        END;
                    UNTIL RecGCompany.NEXT = 0;
                CLEARALL;
                MODIFY;
            end;
        }
        field(50229; College; Code[20])
        {
            CaptionML = ENU = 'College', FRA = 'Collège';
            TableRelation = "WDC College";

            trigger OnValidate()
            begin
                HumanResSetup.Findfirst();
                EmploymentContract.GET("Emplymt. Contract Code");
                IF NOT CONFIRM(Text002) THEN
                    ERROR(Text001) ELSE BEGIN
                    Linegrid.SETFILTER(Linegrid.Code, '%1', EmploymentContract."Salary grid");
                    Linegrid.SETFILTER(College, '%1', College);
                    Linegrid.SETRANGE(Scale, Scale);
                    Linegrid.SETFILTER(Echelon, '%1', Echelon);
                    IF Linegrid.Findfirst() THEN
                        "Basis salary" := Linegrid."Base Salary"
                    ELSE
                        "Basis salary" := 0;
                END;

                IF College = 'CIVP1' THEN "Employee Contract Type" := "Employee Contract Type"::"SIVP I First Year";
                IF College = 'CIVP2' THEN "Employee Contract Type" := "Employee Contract Type"::"SIVP I Second Year";
            end;
        }
        field(50230; Echelon; Integer)
        {
            CaptionML = ENU = 'Echelon', FRA = 'Échelon';
            TableRelation = "WDC Echelon".Echelon;

            trigger OnValidate()
            begin
                HumanResSetup.Findfirst();
                EmploymentContract.GET("Emplymt. Contract Code");
                IF NOT CONFIRM(Text002) THEN
                    ERROR(Text001) ELSE BEGIN
                    Linegrid.SETFILTER(Linegrid.Code, '%1', EmploymentContract."Salary grid");
                    Linegrid.SETFILTER(College, '%1', College);
                    Linegrid.SETFILTER(Echelon, '%1', Echelon);
                    IF Scale <> 0 THEN
                        Linegrid.SETRANGE(Scale, Scale);
                    IF Linegrid.Findfirst() THEN
                        "Basis salary" := Linegrid."Base Salary"
                    ELSE
                        "Basis salary" := 0;

                END;

                RegimeOfWork.GET(EmploymentContract."Work Regime");
                IF "Basis salary" > 0 THEN
                    IF "Employee type".AsInteger() = 0 THEN
                        "Reel Basis salary" := "Basis salary" * RegimeOfWork."Work Hours per month"
                    ELSE
                        "Reel Basis salary" := "Basis salary"
            end;
        }
        field(50232; "Upgrading date Cat/Echelon"; Date)
        {
            CaptionML = ENU = 'Update date Cat/Echelon', FRA = 'Date MAJ Cat/Échelon';
        }
        field(50233; "Family chief"; Boolean)
        {
            CaptionML = ENG = 'Family chief', FRA = 'Chef famille';
        }
        field(50234; "Deduction Loaded child"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Sum("Employee Relative"."Associated deduction" WHERE("Employee No." = FIELD("No."),
                                                                                "Associated deduction" = FILTER(> 0)));
            CaptionML = ENU = 'Deduction Loaded child', FRA = 'Déduction enfant à charge';
            FieldClass = FlowField;
        }
        field(50235; "Loaded childs"; Integer)
        {
            CalcFormula = Count("Employee Relative" WHERE("Employee No." = FIELD("No.")));
            CaptionML = ENU = 'Loaded childs', FRA = 'Enfants à charge';
            FieldClass = FlowField;
        }
        field(50237; "Non paid days"; Decimal)
        {
            CalcFormula = - Sum("WDC Employee's days off Entry"."Quantity (Days)" WHERE("Employee No." = FIELD("No."),
                                                                                    "Line type" = FILTER("Not Paid"),
                                                                                    "Posting year" = FIELD("Year Filter")));
            CaptionML = ENU = 'Non paid days', FRA = 'Jours non payés';
            FieldClass = FlowField;
        }
        field(50238; "Days off -"; Decimal)
        {
            CalcFormula = Sum("WDC Employee's days off Entry"."Quantity (Days)" WHERE("Employee No." = FIELD("No."),
                                                                                   "Line type" = FILTER("Day off Consumption"),
                                                                                   "Posting year" = FIELD("Year Filter")));
            CaptionML = ENU = 'Day off consumed', FRA = 'Jours de congé consommés';
            FieldClass = FlowField;
        }
        field(50239; "Days off +"; Decimal)
        {
            CalcFormula = Sum("WDC Employee's days off Entry"."Quantity (Days)" WHERE("Employee No." = FIELD("No."),
                                                                                   "Line type" = FILTER("Day off Right"),
                                                                                   "Posting year" = FIELD("Year Filter")));
            CaptionML = ENU = 'Day off Right', FRA = 'Droit jours de congé';
            FieldClass = FlowField;
        }
        field(50240; "Days off ="; Decimal)
        {
            CalcFormula = Sum("WDC Employee's days off Entry"."Quantity (Days)" WHERE("Employee No." = FIELD("No."),
                                                                                   "Line type" = FILTER("Day off Right" | "Day off Consumption"),
                                                                                   "Posting year" = FIELD("Year Filter")));
            CaptionML = ENU = 'Days off remaining', FRA = 'Jours de congé restants';
            FieldClass = FlowField;
        }
        field(50244; "Payment Method Code"; Code[20])
        {
            CaptionML = ENG = 'Payment Method', FRA = 'Mode de règlement';
            TableRelation = "Payment Method";
        }
        field(50246; "Default Bank Account Code"; Code[20])
        {
            CaptionML = ENU = 'Default Bank Account', FRA = 'Compte bancaire par défaut';
            TableRelation = "WDC Employee Bank Account".Code WHERE("Employee No." = FIELD("No."));

            trigger OnValidate()
            begin
                IF "Default Bank Account Code" <> '' THEN BEGIN
                    Bnk.RESET;
                    Bnk.SETRANGE("Employee No.", "No.");
                    Bnk.SETRANGE(Code, "Default Bank Account Code");
                    IF Bnk.Findfirst() THEN
                        "Bank Account Number" := Bnk."Bank Branch No." + Bnk."Agency Code" + Bnk."Bank Account No." + Bnk."RIB Key";

                END;
            end;
        }


        field(50252; Blocked; Boolean)
        {
            CaptionML = ENU = 'Blocked', FRA = 'Bloqué';
        }
        field(50255; "Loans balance"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Sum("WDC Loan & Advance Entry".Amount WHERE("Employee No." = FIELD("No."),
                                                                   Type = FILTER(Loan),
                                                                   Status = FILTER("In progress"),
                                                                   "Payroll Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'Loans balance', FRA = 'Solde prêts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50256; "Advances balance"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Sum("WDC Loan & Advance Entry".Amount WHERE("Employee No." = FIELD("No."),
                                                                   Type = FILTER("Advance"),
                                                                   Status = FILTER("In progress"),
                                                                   "Payroll Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'Advances balance', FRA = 'Solde avances';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50258; "Company Bank Account No."; Code[20])
        {
            CaptionML = ENU = 'Company Bank Account No.', FRA = 'N° compte bancaire société';
            TableRelation = "Bank Account"."No.";
        }
        field(50259; "Insurance Amount"; Decimal)
        {
            CaptionML = ENU = 'Insurance Amount', FRA = 'Montant assurance';
            CalcFormula = Sum("WDC Employee Deduction Amount".Amount WHERE("Employee No." = FIELD("No.")));
            DecimalPlaces = 3 : 3;
            FieldClass = FlowField;
        }
        field(50263; "Qualification Code"; Code[20])
        {
            CaptionML = ENU = 'Qualification Code', FRA = 'Code Qualification';
            TableRelation = Qualification;

            trigger OnValidate()
            begin
                CLEAR(Qualification);
                IF Qualification.GET("Qualification Code") THEN
                    Title := Qualification.Description
                ELSE
                    Title := '';
            end;
        }
        field(50264; "Reel Basis salary"; Decimal)
        {
            CaptionML = ENU = 'Reel Basis Salary', FRA = 'Salaire de base reél';
        }
        field(50265; Purcent; Decimal)
        {
            CaptionML = ENU = 'Purcent', FRA = 'Pourcentage';
        }
        field(50266; "Total Holiday Indemnities"; Decimal)
        {
            CaptionML = ENU = 'Total Holiday Indemnities', FRA = 'Total indemnités congé';
            CalcFormula = Sum("WDC Default Indemnities"."Basis amount" WHERE("Emplymt. Contract Code" = FIELD("No."),
                                                                          "Not included in vacation days" = FILTER(false),
                                                                          "Evaluation Mode" = FILTER(< "On Flight Hours")));
            FieldClass = FlowField;
        }
        field(50268; Class; Enum "WDC Classification")
        {
            CaptionML = ENU = 'Class', FRA = 'Classe';
        }
        field(50269; "Saved Basis Salary"; Decimal)
        {
            AutoFormatType = 0;
            CaptionML = ENU = 'Saved Basis Salary', FRA = 'Salaire de base sauvegardé';
            DecimalPlaces = 7 : 7;
            Editable = false;
        }
        field(50301; "Contract Start Date"; Date)
        {
            CaptionML = ENU = 'Contract start date', FRA = 'Date début contrat';
        }
        field(50901; "Residence Permit"; Boolean)
        {
            CaptionML = ENU = 'Residence Permit', FRA = 'Carte séjour';
        }
        field(50903; Nationality; Text[30])
        {
            CaptionML = ENU = 'Nationality', FRA = 'Nationalité';
        }
        field(50904; "Spouse's Name"; Text[100])
        {
            CaptionML = ENU = 'Spouse''s Name', FRA = 'Nom conjoint';
        }
        field(50905; Retirement; Boolean)
        {
            CaptionML = ENU = 'Retirement', FRA = 'Retraite';
        }
        field(80001; "ASS GRP Affiliate"; Boolean)
        {
            CaptionML = ENU = 'ASS GRP Affiliate', FRA = 'Affilé ASS GRP';
        }
        field(80003; "Employee Contract Type"; Enum "WDC Employees type Contract")
        {
            CaptionML = ENU = 'Employee Type Contract', FRA = 'Type contrat';
        }
        field(80005; "Report Employee en -"; Decimal)
        {
            CaptionML = ENU = 'Report Employee en -', FRA = 'Rapport employé en -';
            DecimalPlaces = 3 : 3;
        }
        field(80006; "Hors Grille"; Boolean)
        {
            CaptionML = ENU = 'Off-grid', FRA = 'Hors grille';
        }
        field(90001; "Horaire Salarie"; Code[20])
        {
            CaptionML = ENU = 'Working Hours', FRA = 'Heures travail';
            // TableRelation = Table 55050;
        }

        field(90003; "Retirement plus"; Decimal)
        {
            CaptionML = ENU = 'Retirement plus', FRA = 'Retraite plus';
        }
        field(90004; "Presence Percent"; Decimal)
        {
            CaptionML = ENU = 'Presence Percent', FRA = 'Pourcentage présence';
        }
        field(90005; "Quarterly Note"; Decimal)
        {
            CaptionML = ENU = 'Quarterly Note', FRA = 'Note trimestrielle';
        }
        field(90006; "Quarterly 1 Note"; Decimal)
        {
            CaptionML = ENU = 'Quarterly 1 Note', FRA = 'Note trimestre 1';

            trigger OnValidate()
            begin
                CLEAR(MonthCumul);
                CLEAR(CumMonthNote);
                IF "Quarterly 1 Note" <> 0 THEN N1 := 1 ELSE N1 := 0;
                IF "Quarterly 2 Note" <> 0 THEN N2 := 1 ELSE N2 := 0;
                IF "Quarterly 3 Note" <> 0 THEN N3 := 1 ELSE N3 := 0;
                IF "Quarterly 4 Note" <> 0 THEN N4 := 1 ELSE N4 := 0;
                CumMonthNote := N1 + N2 + N3 + N4;
                IF CumMonthNote <> 0 THEN
                    "Quarterly Note" := ("Quarterly 1 Note" + "Quarterly 2 Note" + "Quarterly 3 Note" + "Quarterly 4 Note") / CumMonthNote
                ELSE
                    "Quarterly Note" := 0;
                VALIDATE(Note, "Quarterly Note");
            end;
        }
        field(90007; "Quarterly 2 Note"; Decimal)
        {
            CaptionML = ENU = 'Quarterly 2 Note', FRA = 'Note trimestre 2';

            trigger OnValidate()
            begin
                CLEAR(MonthCumul);
                CLEAR(CumMonthNote);
                IF "Quarterly 1 Note" <> 0 THEN N1 := 1 ELSE N1 := 0;
                IF "Quarterly 2 Note" <> 0 THEN N2 := 1 ELSE N2 := 0;
                IF "Quarterly 3 Note" <> 0 THEN N3 := 1 ELSE N3 := 0;
                IF "Quarterly 4 Note" <> 0 THEN N4 := 1 ELSE N4 := 0;
                CumMonthNote := N1 + N2 + N3 + N4;
                IF CumMonthNote <> 0 THEN
                    "Quarterly Note" := ("Quarterly 1 Note" + "Quarterly 2 Note" + "Quarterly 3 Note" + "Quarterly 4 Note") / CumMonthNote
                ELSE
                    "Quarterly Note" := 0;
                VALIDATE(Note, "Quarterly Note");
            end;
        }
        field(90008; "Quarterly 3 Note"; Decimal)
        {
            CaptionML = ENU = 'Quarterly 3 Note', FRA = 'Note trimestre 3';

            trigger OnValidate()
            begin
                CLEAR(MonthCumul);
                CLEAR(CumMonthNote);
                IF "Quarterly 1 Note" <> 0 THEN N1 := 1 ELSE N1 := 0;
                IF "Quarterly 2 Note" <> 0 THEN N2 := 1 ELSE N2 := 0;
                IF "Quarterly 3 Note" <> 0 THEN N3 := 1 ELSE N3 := 0;
                IF "Quarterly 4 Note" <> 0 THEN N4 := 1 ELSE N4 := 0;
                CumMonthNote := N1 + N2 + N3 + N4;
                IF CumMonthNote <> 0 THEN
                    "Quarterly Note" := ("Quarterly 1 Note" + "Quarterly 2 Note" + "Quarterly 3 Note" + "Quarterly 4 Note") / CumMonthNote
                ELSE
                    "Quarterly Note" := 0;
                VALIDATE(Note, "Quarterly Note");
            end;
        }
        field(90009; "Quarterly 4 Note"; Decimal)
        {
            CaptionML = ENU = 'Quarterly 4 Note ', FRA = 'Note trimestre 4';

            trigger OnValidate()
            begin
                CLEAR(MonthCumul);
                CLEAR(CumMonthNote);
                IF "Quarterly 1 Note" <> 0 THEN N1 := 1 ELSE N1 := 0;
                IF "Quarterly 2 Note" <> 0 THEN N2 := 1 ELSE N2 := 0;
                IF "Quarterly 3 Note" <> 0 THEN N3 := 1 ELSE N3 := 0;
                IF "Quarterly 4 Note" <> 0 THEN N4 := 1 ELSE N4 := 0;
                CumMonthNote := N1 + N2 + N3 + N4;
                IF CumMonthNote <> 0 THEN
                    "Quarterly Note" := ("Quarterly 1 Note" + "Quarterly 2 Note" + "Quarterly 3 Note" + "Quarterly 4 Note") / CumMonthNote
                ELSE
                    "Quarterly Note" := 0;
                VALIDATE(Note, "Quarterly Note");
            end;
        }
        field(90010; CNSS; Code[20])
        {
            CalcFormula = Lookup("WDC Default Soc. Contribution"."Social Contribution Code" WHERE("Social Contribution Code" = CONST('CNSS'),
                                                                                               "Emplymt. Contract Code" = FIELD("No.")));
            CaptionML = ENU = 'CNSS', FRA = 'CNSS';
            FieldClass = FlowField;
        }
        field(90011; CSS; Code[20])
        {
            CalcFormula = Lookup("WDC Default Soc. Contribution"."Social Contribution Code" WHERE("Social Contribution Code" = CONST('CSS'),
                                                                                               "Emplymt. Contract Code" = FIELD("No.")));
            CaptionML = ENU = 'CSS', FRA = 'CSS';
            FieldClass = FlowField;
        }
        field(90012; BUS; Code[20])
        {
            CalcFormula = Lookup("WDC Default Soc. Contribution"."Social Contribution Code" WHERE("Social Contribution Code" = CONST('BUS'),
                                                                                               "Emplymt. Contract Code" = FIELD("No.")));
            CaptionML = ENU = 'BUS', FRA = 'BUS';
            FieldClass = FlowField;
        }
        field(90013; "Workplace Accident"; Code[20])
        {
            CalcFormula = Lookup("WDC Default Soc. Contribution"."Social Contribution Code" WHERE("Social Contribution Code" = CONST('ACC_TRAVAI'),
                                                                                               "Emplymt. Contract Code" = FIELD("No.")));
            CaptionML = ENU = 'Work Accident', FRA = 'Accident travail';
            FieldClass = FlowField;
        }
        field(90014; VOIT; Code[20])
        {
            CalcFormula = Lookup("WDC Default Soc. Contribution"."Social Contribution Code" WHERE("Social Contribution Code" = CONST('VOIT'),
                                                                                               "Emplymt. Contract Code" = FIELD("No.")));
            CaptionML = ENU = 'VOIT', FRA = 'VOIT';
            FieldClass = FlowField;
        }
        field(90015; "Insurance Group"; Code[20])
        {
            CalcFormula = Lookup("WDC Default Soc. Contribution"."Social Contribution Code" WHERE("Social Contribution Code" = CONST('ASS'),
                                                                                               "Emplymt. Contract Code" = FIELD("No.")));
            CaptionML = ENU = 'Insurance Group', FRA = 'Assurance Groupe';
            FieldClass = FlowField;
        }
        field(90016; "Hire Date"; Date)
        {
            CaptionML = ENU = 'Hire Date', FRA = 'Date d''embauche';

            trigger OnValidate()
            begin
                CLEAR(Jour);
                CLEAR(Month);
                CLEAR(Year);
                Jour := DATE2DMY("Hire Date", 1);
                Month := DATE2DMY("Hire Date", 2);
                Year := DATE2DMY("Hire Date", 3);
                "Employment Date" := DMY2DATE(1, Month, Year);
            end;
        }
        field(90017; "Brut prime"; Decimal)
        {
            CaptionML = ENU = 'Gross Bonus', FRA = 'Prime brute';
        }

    }

    keys
    {
        key(Key6; "Social Security No.")
        {
        }
        key(Key7; "CIN No.")
        {
        }
        key(Key8; "Statistics Group Code", "No.")
        {
        }
    }

    fieldgroups
    {
        addlast(DropDown; "No.", "First Name", "Last Name")
        {
        }
    }

    trigger OnDelete()
    begin
        RecSalaryLines.SETRANGE("Employee No.", "No.");
        IF RecSalaryLines.FINDFIRST THEN
            ERROR(ErrSupr, "No.");
        AlternativeAddr.SETRANGE("Employee No.", "No.");
        AlternativeAddr.DELETEALL;

        EmployeeQualification.SETRANGE("Employee No.", "No.");
        EmployeeQualification.DELETEALL;

        Relative.SETRANGE("Employee No.", "No.");
        Relative.DELETEALL;

        EmployeeAbsence.SETRANGE("Employee No.", "No.");
        EmployeeAbsence.DELETEALL;

        MiscArticleInformation.SETRANGE("Employee No.", "No.");
        MiscArticleInformation.DELETEALL;

        ConfidentialInformation.SETRANGE("Employee No.", "No.");
        ConfidentialInformation.DELETEALL;
        RecGContrat.RESET;
        RecGContrat.SETRANGE(Code, "No.");
        RecGContrat.DELETEALL;

        HumanResComment.SETRANGE("No.", "No.");
        HumanResComment.DELETEALL;

        DimMgt.DeleteDefaultDim(DATABASE::Employee, "No.");
    end;


    trigger OnRename()
    begin
        "Last Date Modified" := TODAY;
    end;





    procedure MAJDeductions()
    var
        EmployeeRelative: Record "Employee Relative";
    begin
        EmployeeRelative.SETRANGE("Employee No.", "No.");
        IF EmployeeRelative.Findfirst() THEN
            REPEAT
                IF (EmployeeRelative."Holding on end date" <= WORKDATE) THEN BEGIN
                    EmployeeRelative."Associated deduction" := 0;
                END;
            UNTIL EmployeeRelative.NEXT = 0;
    end;

    procedure FullAdress() adr: Text[150]
    begin
        adr := Address + ' ' + "Address 2" + ' ' + "Post Code" + ' ' + City;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        AlternativeAddr: Record "Alternative Address";
        EmployeeQualification: Record "Employee Qualification";
        Relative: Record "Employee Relative";
        EmployeeAbsence: Record "Employee Absence";
        MiscArticleInformation: Record "Misc. Article Information";
        ConfidentialInformation: Record "Confidential Information";
        HumanResComment: Record "Human Resource Comment Line";
        DimMgt: Codeunit DimensionManagement;
        Linegrid: Record "WDC Grid Line";
        EmploymentContract: Record "Employment Contract";
        RecSalaryLines: Record "WDC Posted Salary Lines";
        Bnk: Record "WDC Employee Bank Account";
        RecGCompany: Record Company;
        ReCGEmployee: Record Employee;
        txtcompany: Text[30];
        Qualification: Record Qualification;
        RegimeOfWork: Record "WDC work Regimes";
        ERROR01: TextConst ENU = 'Employee CIN exists for employee %1.',
                           FRA = 'N° CIN existe pour l''employé %1.';
        ErrSupr: TextConst ENU = 'WARNING!!!: Deletion impossible, employee %1, salary record exists',
                           FRA = 'ATTENTION !!! : Suppression impossible, salarié %1, existence du salaire enregistré';
        Text001: TextConst ENU = 'Basic Salary retained at its initial value!',
                           FRA = 'Salaire de Base conservé à sa valeur initiale !';
        Text002: TextConst ENU = 'Do you want to update basis salary',
                           FRA = 'Voulez-vous changer le Salaire de Base?';
        RecGContrat: Record "Employment Contract";
        MonthCumul: Integer;
        N1: Integer;
        N2: Integer;
        N3: Integer;
        N4: Integer;
        CumMonthNote: Integer;
        Jour: Integer;
        Month: Integer;
        Year: Integer;
        EmpContract: Record "Employment Contract";
        ERROR02: TextConst ENU = 'CIN exists for employee %1 in company %2.',
                           FRA = 'N° CIN existe pour l''employé %1 dans la société %2.';


}

