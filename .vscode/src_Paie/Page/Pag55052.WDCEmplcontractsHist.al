page 55052 "WDC Empl. contracts Hist."
{
    CaptionML = ENU = 'Employment contracts History', FRA = 'Historique contrat travail';
    Editable = false;
    PageType = Card;
    SourceTable = "WDC Hist. contrat de travail";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Archived contract code"; Rec."Archived contract code")
                {
                    ApplicationArea = all;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("No. of Contracts"; Rec."No. of Contracts")
                {
                    ApplicationArea = all;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = all;
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ApplicationArea = all;
                }
                field("Regular payments"; Rec."Regular payments")
                {
                    ApplicationArea = all;
                }
                field("Temporary payments"; Rec."Temporary payments")
                {
                    ApplicationArea = all;
                }
            }
            group(Administration)
            {
                CaptionML = ENU = 'Administration', FRA = 'Administration';
                field("Statistics Group Code"; Rec."Statistics Group Code")
                {
                    ApplicationArea = all;
                }
                field("Working Relationship"; Rec."Working Relationship")
                {
                    ApplicationArea = all;
                }
                field("Work Regimes"; Rec."Work Regimes")
                {
                    ApplicationArea = all;
                }
                field("Salary grid"; Rec."Salary grid")
                {
                    ApplicationArea = all;
                }
                field("Employee type"; Rec."Employee type")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Start Contract Date"; Rec."Start Contract Date")
                {
                    ApplicationArea = all;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = all;
                }
                field("Inactive Date"; Rec."Inactive Date")
                {
                    ApplicationArea = all;
                }
                field("Cause of Inactivity Code"; Rec."Cause of Inactivity Code")
                {
                    ApplicationArea = all;
                }
                field("Grounds for Term. Code"; Rec."Grounds for Term. Code")
                {
                    ApplicationArea = all;
                }
                field("Employee Contract Type"; Rec."Employee Contract Type")
                {
                    ApplicationArea = all;
                }
                field(Specialty; Rec.Specialty)
                {
                    ApplicationArea = all;
                }
                field("Taxes Calculation Mode"; Rec."Taxes Calculation Mode")
                {
                    ApplicationArea = all;
                }
                field("Appliquer Heure Supp"; Rec."Appliquer Heure Supp")
                {
                    ApplicationArea = all;
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = all;
                }
            }
            group(Paiement)
            {
                CaptionML = ENU = 'Payment', FRA = 'Paiement';
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    ApplicationArea = all;
                }
                field(College; Rec.College)
                {
                    ApplicationArea = all;
                }
                field(Echelon; Rec.Echelon)
                {
                    ApplicationArea = all;
                }
                field("Entry date Cat/Echelon"; Rec."Entry date Cat/Echelon")
                {
                    ApplicationArea = all;
                }
                field("Gross Salary"; Rec."Gross Salary")
                {
                    ApplicationArea = all;
                }
                field("Basis salary"; Rec."Basis salary")
                {
                    ApplicationArea = all;
                }
                field("Loaded childs"; Rec."Loaded childs")
                {
                    ApplicationArea = all;
                }
                field("Off-grid"; Rec."Off-grid")
                {
                    ApplicationArea = all;
                }
                field(Taxable; Rec.Taxable)
                {
                    ApplicationArea = all;
                }
            }
            group(Personel)
            {
                CaptionML = ENU = 'Personnel', FRA = 'Personnel';
                field(Address; Rec.Address)
                {
                    ApplicationArea = all;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = all;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = all;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = all;
                    ValuesAllowed = " ", Male, Female;
                }
                field("Social Security No."; Rec."Social Security No.")
                {
                    ApplicationArea = all;
                }
                field("Family Situation A"; Rec."Family Situation A")
                {
                    ApplicationArea = all;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = all;
                }
                field("Days off -"; Rec."Days off -")
                {
                    ApplicationArea = all;
                }
                field("Days off +"; Rec."Days off +")
                {
                    ApplicationArea = all;
                }
                field("Days off ="; Rec."Days off =")
                {
                    ApplicationArea = all;
                }
            }
            group("Indemnities")
            {
                CaptionML = ENU = 'Indemnities', FRA = 'Indemnités';
                part("WDC Hist. Default Indemnities"; "WDC Hist. Default Indemnities")
                {
                    SubPageLink = "Archived contract code" = FIELD("Archived contract code"),
                                  "Emplymt. Contract Code" = FIELD(Code);
                    ApplicationArea = all;
                }
            }
            group("Social Contributions")
            {
                CaptionML = ENU = 'Social Contributions', FRA = 'Cotsations Sociales';
                part("WDC Hist. Cotisation Sociale"; "WDC Hist. Cotisation Sociale")
                {
                    SubPageLink = "Emplymt. Contract Code" = FIELD(Code),
                                  "Archived contract code" = FIELD("Archived contract code");
                    ApplicationArea = all;
                }
            }
        }
    }

}

