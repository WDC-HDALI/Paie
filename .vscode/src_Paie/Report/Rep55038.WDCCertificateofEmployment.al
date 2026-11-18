report 55038 "WDC Certificate of Employment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/Certificatdetravail.rdlc';
    captionML = ENU = 'Certificate of Employment', FRA = 'Certificat de travail';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = SORTING("Primary Key")
                                ORDER(Ascending);
            column(Company_Information_Primary_Key; "Primary Key")
            {
            }
            column(Logo; CampanyInfo.Picture)
            {
            }
            column(Name; COMPANYNAME)
            {
            }
            column(Address; CampanyInfo.Address)
            {
            }
            column(City; CampanyInfo.City)
            {
            }
            column(Country; CampanyInfo."Country/Region Code")
            {
            }
            column(MaritalStatusRH; MaritalStatusRH)
            {
            }
            dataitem(Employee; Employee)
            {
                DataItemTableView = SORTING("No.");
                RequestFilterFields = "No.";
                column(HumRessSetup_DG; HumRessSetup."Nom Prénom Chef Sce RH")
                {
                }
                column(FORMAT_WORKDATE; FORMAT(WORKDATE))
                {
                }
                column(Employee_No_; "No.")
                {
                }
                column(FirstName; "First Name")
                {
                }
                column(LastName; "Last Name")
                {
                }
                column(Text001_Caption; Text001)
                {
                }
                column(Text002_Caption; STRSUBSTNO(Text002, "Company Information".City))
                {
                }
                column(Text003_Caption; STRSUBSTNO(Text003, UPPERCASE(HumRessSetup."Directeur général"), "Company Information".Name))
                {
                }
                column(Text004_Caption; Text004)
                {
                }
                column(Text005_Caption; Text005)
                {
                }
                column(Text006_Caption; Text006)
                {
                }
                column(Text007_Caption; Text007)
                {
                }
                column(Text008_Caption; Text008)
                {
                }
                column(Text009_Caption; Text009)
                {
                }
                column(Text010; Text010)
                {
                }
                column(Text011_Caption; Text011)
                {
                }
                column(Text012_Caption; STRSUBSTNO(Text012, CampanyInfo."Phone No."))
                {
                }
                column(Text013_Caption; STRSUBSTNO(Text013, CampanyInfo."Fax No."))
                {
                }
                column(Text014_Caption; STRSUBSTNO(Text014, CampanyInfo."E-Mail"))
                {
                }
                column(Text015_Caption; STRSUBSTNO(Text015, ''))
                {
                }
                column(Text016_Caption; STRSUBSTNO(Text016, "Termination Date", Title))
                {
                }
                column(MaritalStatus; MaritalStatus)
                {
                }
                column(FullName; FullName)
                {
                }
                column(FullAdress; FullAdress)
                {
                }
                column(SocialSecurityNo; "Social Security No.")
                {
                }
                column(NCIN; "CIN No.")
                {
                }
                column(EmploymentDate; "Employment Date")
                {
                }
                column(JobTitle; Title)
                {
                }
                column(Text016; Text016)
                {
                }
                column(Text017; Text017)
                {
                }
                column(Text018; Text018)
                {
                }
                column(Text019; Text019)
                {
                }
                column(TerminationDate; "Termination Date")
                {
                }
                column(Text020; Text020)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    MOIS := DATE2DMY(WORKDATE, 2);
                    ANN := DATE2DMY(WORKDATE, 3);

                    MaritalStatus := ' ';
                    //Employee.CALCFIELDS("Job Title");
                    QualificationEmploye.RESET;
                    QualificationEmploye.SETCURRENTKEY("Employee No.", "Line No.");
                    QualificationEmploye.SETRANGE("Employee No.", Employee."No.");
                    IF QualificationEmploye.FINDLAST() THEN
                        IF RecQualif.GET(QualificationEmploye."Qualification Code") THEN
                            TxtQualification := RecQualif.Description;


                    IF Gender = Empl.Gender::Male THEN
                        MaritalStatus := Text008
                    ELSE
                        CASE "Family Situation A" OF
                            Empl."Family Situation A"::Single:
                                MaritalStatus := Text006;
                            Empl."Family Situation A"::Married:
                                MaritalStatus := Text007;
                            Empl."Family Situation A"::Divorced:
                                MaritalStatus := Text007;
                            Empl."Family Situation A"::Widowed:
                                MaritalStatus := Text007;
                        END;
                    //>>MES01.NM
                end;
            }

            trigger OnPreDataItem()
            begin
                CampanyInfo.GET;
                CampanyInfo.CALCFIELDS(CampanyInfo.Picture);
            end;
        }
    }


    trigger OnInitReport()
    begin
        HumRessSetup.GET;
        //<<
        RH.RESET;
        IF RH.GET(HumRessSetup."Matricule Chef Service RH") THEN BEGIN
            IF RH.Gender = RH.Gender::Male THEN
                MaritalStatusRH := Text008
            ELSE
                CASE RH."Family Situation A" OF
                    RH."Family Situation A"::Single:
                        MaritalStatusRH := Text006;
                    RH."Family Situation A"::Married:
                        MaritalStatusRH := Text007;
                    RH."Family Situation A"::Divorced:
                        MaritalStatusRH := Text007;
                    RH."Family Situation A"::Widowed:
                        MaritalStatusRH := Text007;
                END;
        END;
        //>>
    end;

    var
        HumRessSetup: Record "Human Resources Setup";
        Empl: Record Employee;
        MOIS: Integer;
        ANN: Integer;
        REF: Code[20];
        MaritalStatus: Text[30];
        QualificationEmploye: Record 5203;
        RecQualif: Record 5202;
        TxtQualification: Text[60];
        Text001: Label 'Head Office';
        Text002: Label '%1';
        CampanyInfo: Record 79;
        Text003: Label 'We, the undersigned company %1 based in %2 -%3  confirm that %4 %5 holding CIN No. %6   is part of our staff in his capacity as %7 %8  from %9 up to today.';
        Text004: Label 'STATEMENT OF WORK';
        Text005: Label 'This certificate is issued to the person upon request to serve and argues that law.';
        Text006: Label 'Ms.';
        Text007: Label 'Mrs.';
        Text008: Label 'Mr.';
        Text009: Label 'ATTESTE PAR LA PRESENTE';
        Text010: Label 'Que ';
        Text011: Label 'PDG';
        Text012: Label 'T: %1';
        Text013: Label 'F: %1';
        Text014: Label 'E: %1';
        Text015: Label 'I: %1';
        Text016: Label ' ,immatriculé(e) à la Caisse Nationale de la Sécurité Sociale sous n° ';
        Text017: Label ' titulaire de la C.I.N ';
        Text018: Label ' , travaille dans notre société à partir du ';
        Text019: Label ', en qualité de ';
        Text020: Label ' jusqu''au ';
        MaritalStatusRH: Text;
        RH: Record Employee;
}

