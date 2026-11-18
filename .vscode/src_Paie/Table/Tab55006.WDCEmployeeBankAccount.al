table 55006 "WDC Employee Bank Account"
{
    CaptionML = ENU = 'Employee Bank Account', FRA = 'Compte bancaire employé';
    DataCaptionFields = "Employee No.", "Code", Name;
    DrillDownPageID = 55019;
    LookupPageID = 55019;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.', FRA = 'N° employé';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
            NotBlank = true;
        }
        field(3; Name; Text[60])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';
        }
        field(5; "Name 2"; Text[60])
        {
            CaptionML = ENU = 'Name 2', FRA = 'Nom 2';
        }
        field(6; Address; Text[100])
        {
            CaptionML = ENU = 'Address', FRA = 'Adresse';
        }
        field(7; "Address 2"; Text[100])
        {
            CaptionML = ENU = 'Address 2', FRA = 'Adresse 2';
        }
        field(8; City; Text[30])
        {
            CaptionML = ENU = 'City', FRA = 'Ville';
        }
        field(9; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code', FRA = 'Code postal';
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF PostCode.GET("Post Code") THEN
                    City := PostCode.City;
            end;
        }
        field(10; Contact; Text[30])
        {
            CaptionML = ENU = 'Contact', FRA = 'Contact';
        }
        field(11; "Phone No."; Text[30])
        {
            CaptionML = ENU = 'Phone No.', FRA = 'N° téléphone';
        }
        field(12; "Telex No."; Text[20])
        {
            CaptionML = ENU = 'Telex No.', FRA = 'N° télex';
        }
        field(13; "Bank Branch No."; Code[10])
        {
            CaptionML = ENU = 'Bank Branch No.', FRA = 'N° agence bancaire';

            trigger OnValidate()
            begin
                //"RIB Checked" := RIBKey.CheckRIb("Bank Branch No.","Agency Code","Bank Account No.","RIB Key");
            end;
        }
        field(14; "Bank Account No."; Code[30])
        {
            CaptionML = ENU = 'Bank Account No.', FRA = 'N° compte bancaire';

            trigger OnValidate()
            begin
                I := "Bank Account No.";
            end;
        }
        field(15; "Transit No."; Code[20])
        {
            CaptionML = ENU = 'Transit No.', FRA = 'N° transit';
        }
        field(16; "Currency Code"; Code[20])
        {
            CaptionML = ENU = 'Currency Code', FRA = 'Code devise';
            TableRelation = Currency;
        }
        field(17; "Country Code"; Code[20])
        {
            CaptionML = ENU = 'Country Code', FRA = 'Code pays';
            TableRelation = "Country/Region";
        }
        field(18; Country; Code[30])
        {
            CaptionML = ENU = 'Country', FRA = 'Pays';
        }
        field(19; "Fax No."; Code[30])
        {
            CaptionML = ENU = 'Fax No.', FRA = 'N° fax';
        }
        field(20; "Telex Answer Back"; Text[20])
        {
            CaptionML = ENU = 'Telex Answer Back', FRA = 'Réponse télex';
        }
        field(21; "Language Code"; Code[20])
        {
            CaptionML = ENU = 'Language Code', FRA = 'Code langue';
            TableRelation = Language;
        }
        field(22; "E-Mail"; Text[80])
        {
            CaptionML = ENU = 'E-Mail', FRA = 'E-mail';
        }
        field(23; "Home Page"; Text[80])
        {
            CaptionML = ENU = 'Home Page', FRA = 'Page d''accueil';
        }
        field(10851; "Agency Code"; Code[20])
        {
            CaptionML = ENU = 'Agency Code', FRA = 'Code agence';

            trigger OnValidate()
            begin
                //"RIB Checked" := RIBKey.CheckRIb("Bank Branch No.","Agency Code","Bank Account No.","RIB Key");
            end;
        }
        field(10852; "RIB Key"; Text[30])
        {
            CaptionML = ENU = 'RIB Key', FRA = 'RIB';

            trigger OnValidate()
            begin
                //"RIB Checked" := RIBKey.CheckRIb("Bank Branch No.","Agency Code","Bank Account No.","RIB Key");
            end;
        }
        field(10853; "RIB Checked"; Boolean)
        {
            CaptionML = ENU = 'RIB Checked', FRA = 'RIB vérifié';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Code")
        {
            Clustered = true;
        }
        key(Key2; "Code", "Employee No.")
        {
        }
    }

    var
        PostCode: Record "Post Code";
        I: Code[20];
}

