report 55045 "WDC 13th Salary Slip"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/FichedePAIE13ième.rdlc';
    captionML = ENU = '13th Salary Slip', FRA = 'Fiche de PAIE 13ième';
    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = SORTING("Primary Key");
            column(Company_Information_Name; "Company Information".Name)
            {
            }
            column(Company_Information_Address; "Company Information".Address)
            {
            }
            column(CompanyInformation_PhoneNo; "Company Information"."Phone No.")
            {
            }
            column(Company_Information_Picture; "Company Information".Picture)
            {
            }
            column(CompanyInformation_FaxNo; "Company Information"."Fax No.")
            {
            }
            column(CNSS_CompanyInformation; "Company Information"."Executive Director 2")
            {
            }
            column(SignatureElectronique; "Company Information"."Executive Director 1")
            {
            }
            column(TextTitre; TextTitre)
            {
            }
        }
        dataitem("Rec. Salary Header"; "WDC Posted Salary Header")
        {
            RequestFilterFields = "No.";
            column(Description_SalaryHeaders; Description)
            {
            }
            column(Month_SalaryHeaders; Month)
            {
            }
            column(Year_SalaryHeaders; Year)
            {
            }
            column(Salary_Headers_No; "No.")
            {
            }
            column(Afficher; Afficher)
            {
            }
            dataitem("Rec. Salary Lines"; "WDC Posted Salary Lines")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("No.", "Employee No.");
                RequestFilterFields = "Employee No.";
                column(Basis_salary; "Basis salary")
                {
                }
                column(Gross_Salary; "Gross Salary")
                {
                }
                column(Taxable_salary; "Taxable salary")
                {
                }
                column(Taxe_Month; "Taxe (Month)")
                {
                }
                column(Net_salary; "Net salary")
                {
                }
                column(Net_salary_cashed; "Net salary cashed")
                {
                }
                column(No_Salary_line; "No.")
                {
                }
                column(No_Employee_S_Line; "Employee No.")
                {
                }
                column(NumCNSS_SalaryLines; "CNSS No.")
                {
                }
                column(NumCIN_SalaryLines; "CIN No.")
                {
                }
                column(HRTRAVAILNORMAL_SalaryLines; DECGNBHEURE)
                {
                }
                column(JRTRAVAILNORMAL_SalaryLines; DECGNBJOURS)
                {
                }
                column(SaliaireComplementaire; SaliaireComplementaire)
                {
                }
                column(SalBaseReel_SalaryLines; "Real basis salary")
                {
                }
                column(JourTrav; NBJourtravail)
                {
                }
                column(Redevance; "CSS Tax")
                {
                }
                column(Assurance; Assurance)
                {
                }
                column(Bus; Bus)
                {
                }
                column(Shems; Shems)
                {
                }
                column("Téléphone"; Phone)
                {
                }
                column(MontantLoiFinance20141; "Montant Loi Finance 2014-1J")
                {
                }
                column(MontAssGrp; MontAssGrp)
                {
                }
                column(DeductionCOVID_SalaryLines; 0)
                {
                }
                column(NbrHS; NbrHS)
                {
                }
                column(MontHS; MontHS)
                {
                }
                column(BaseHS; BaseHS)
                {
                }
                column(NbrHS125; NbrHS125)
                {
                }
                column(MontHS125; MontHS125)
                {
                }
                column(BaseHS125; BaseHS125)
                {
                }
                column(NbrHS15; NbrHS15)
                {
                }
                column(MontHS15; MontHS15)
                {
                }
                column(BaseHS15; BaseHS15)
                {
                }
                column(NbrHS175; NbrHS175)
                {
                }
                column(MontHS175; MontHS175)
                {
                }
                column(BaseHS175; BaseHS175)
                {
                }
                column(NbrHS200; NbrHS200)
                {
                }
                column(MontHS200; MontHS200)
                {
                }
                column(BaseHS200; BaseHS200)
                {
                }
                column(NbrHSTot; NbrHSTot)
                {
                }
                column("JourCongéAPEM"; 0)
                {
                }
                column("MontantCongéAPEM"; 0)
                {
                }
                column(MontCOVID; 0)
                {
                }
                column(DescCOVID; 0)
                {
                }
                column("JoursFériés"; "Public Holidays")
                {
                }
                column("MontantJoursFériés"; "Public Holiday Amount")
                {
                }
                column(txtmsg; txtmsg)
                {
                }
                column(THJP; THJP)
                {
                }
                column(THJE; THJE)
                {
                }
                column(JFER; JFER)
                {
                }
                column(RetPlus; "Retirement plus")
                {
                }
                column(C_PAYE; C_PAYE)
                {
                }
                column(J_Supp; J_SUPP)
                {
                }
                column(INDNCOT; INDNCOT)
                {
                }
                column(HS25; HS25)
                {
                }
                column(HS50; HS50)
                {
                }
                column(HS; HS)
                {
                }
                column(CP; CP)
                {
                }
                column(NoteTrim; NoteTrim)
                {
                }
                column(Pret; Loans)
                {
                }
                column(Avance; Advances)
                {
                }
                dataitem(Employee; Employee)
                {
                    DataItemLink = "No." = FIELD("Employee No.");
                    column(No_Employee; Employee."No.")
                    {
                    }
                    column(FirstName_Employee; Employee."First Name")
                    {
                    }
                    column(LastName_Employee; Employee."Last Name")
                    {
                    }
                    column(SocialSecurityNo_Employee; Employee."Social Security No.")
                    {
                    }
                    column("College"; College)
                    {
                    }
                    column(Echelle; Scale)
                    {
                    }
                    column(Echelon; Echelon)
                    {
                    }
                    column(Loaded_childs; "Loaded childs")
                    {
                    }
                    column(Marital_Status; ChefFamily)
                    {
                    }
                    column(Employee_Posting_Group; "Empl. Posting Group")
                    {
                    }
                    column(Job_Title; Title)
                    {
                    }
                    column(Employee_type; "Employee type")
                    {
                    }
                    column(RIB_Employee; "Bank Account Number")
                    {
                    }
                    column(NationalIdentityCardNo_Employee; "CIN No.")
                    {
                    }
                    column(Relation_de_travail; EmpCont."Employee Contract Type")
                    {
                    }
                    column(PaymentMethodCode_Employee; "Payment Method Code")
                    {
                    }
                    column(ModeReglement; "Payment Method Code")
                    {
                    }
                    column("SoldePrêt"; "Loans balance")
                    {
                    }
                    column(SoldeCong2; Employee."Days off =")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CALCFIELDS("Loans balance", "Days off =");
                        SoldeCong := "Days off =";

                        IF "Family chief" THEN
                            ChefFamily := 'Oui'
                        ELSE
                            ChefFamily := 'Non';

                        Employee.SETFILTER(Employee."No.", "Rec. Salary Lines"."Employee No.");
                        IF RecGContrat.GET("Emplymt. Contract Code") THEN
                            IF RecGRegime.GET(RecGContrat."Work Regime") THEN BEGIN
                                DECGNBHEURE := RecGRegime."Work Hours per month";
                                DECGNBJOURS := RecGRegime."Worked Day Per Month";
                            END;

                        IF "Employee type".AsInteger() = 1 THEN BEGIN
                            DECGNBJOURS := "Rec. Salary Lines"."Paied days";
                            NBJourtravail := (DECGNBJOURS);//-"Salary Lines".Absences);
                        END
                        ELSE BEGIN
                            Salarylines.RESET;
                            Salarylines.SETRANGE("No.", "Rec. Salary Header"."No.");
                            Salarylines.SETRANGE("Employee No.", "No.");
                            DECGNBHEURE := "Rec. Salary Lines"."Worked hours";
                            NBJourtravail := (DECGNBHEURE);//-("Salary Lines".Absences));
                        END;
                        CLEAR(EmpCont);
                        EmpCont.GET(Employee."No.");
                        IF "Employee type".AsInteger() = 0 THEN
                            Employeetype := 'Horaire'
                        ELSE
                            Employeetype := 'Mensuel';

                    end;

                    trigger OnPostDataItem()
                    begin
                        Employee.SETFILTER(Employee."No.", "Rec. Salary Lines"."Employee No.");
                    end;

                    trigger OnPreDataItem()
                    begin
                        Employee.SETFILTER(Employee."No.", "Rec. Salary Lines"."Employee No.");
                    end;
                }
                dataitem("Rec. Indemnities"; "WDC Rec. Indemnities")
                {
                    DataItemLink = "Employee No." = FIELD("Employee No."),
                                   "No." = FIELD("No.");
                    DataItemTableView = SORTING("No.", "Employee No.", Indemnity)
                                        ORDER(Ascending)
                                        WHERE(Type = FILTER(Imposable));
                    column(Description; Description)
                    {
                    }
                    column(Indemnity; Indemnity)
                    {
                    }
                    column(BaseAmount_Indemnities; ApemBaseAmount)
                    {
                    }
                    column(Real_Amount; ROUND("Real Amount", 0.001))
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column("Quantité"; Quantité)
                    {
                    }
                    column(AllaitUGTTATECH; "Allait-UGTT-ATECH")
                    {
                    }
                    column(IndInvisibiel; IndInvisibiel)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        "Rec. Indemnities".SETFILTER("No.", "Rec. Salary Lines"."No.");
                        "Rec. Indemnities".SETFILTER("Employee No.", "Rec. Salary Lines"."Employee No.");
                        IF "Rec. Indemnities".Indemnity <> '002' THEN BEGIN
                            //Evaluation mode
                            ApemBaseAmount := ROUND("Base Amount", 0.001);
                        END ELSE BEGIN
                            IF ("Rec. Indemnities".Indemnity = '002') AND ("Rec. Indemnities"."Evaluation mode" = "Rec. Indemnities"."Evaluation mode"::"Worked Days Number") THEN
                                ApemBaseAmount := ROUND("Rec. Indemnities"."Base Amount" * 26, 0.001);
                        END;
                        Quantité := 0;
                        Quantité := "Rec. Indemnities"."Days Number";
                        //>>WDC
                        CLEAR(GIndemnity);
                        IndInvisibiel := FALSE;
                        IF GIndemnity.GET("Rec. Indemnities".Indemnity) THEN
                            IndInvisibiel := GIndemnity.Invisible;
                        //<<WDC

                    end;

                    trigger OnPostDataItem()
                    begin
                        "Rec. Indemnities".SETFILTER("No.", "Rec. Salary Lines"."No.");
                        "Rec. Indemnities".SETFILTER("Employee No.", "Rec. Salary Lines"."Employee No.");
                    end;

                    trigger OnPreDataItem()
                    begin
                        "Rec. Indemnities".SETFILTER("Rec. Indemnities"."No.", "Rec. Salary Lines"."No.");
                        "Rec. Indemnities".SETFILTER("Rec. Indemnities"."Employee No.", "Rec. Salary Lines"."Employee No.");
                    end;
                }
                dataitem("Rec. Social Contributions"; "WDC Rec. Social Contributions")
                {
                    DataItemLink = "No." = FIELD("No."),
                                     "Employee No." = FIELD("Employee No.");
                    DataItemTableView = SORTING("No.", "Employee No.", Indemnity, "Social Contribution")
                                        ORDER(Ascending)
                                        WHERE("Social Contribution" = FILTER('CNSS*|CAVIS'));
                    column(Social_Contribution; "Social Contribution")
                    {
                    }
                    column(Social_Contribution_Description; Description)
                    {
                    }
                    column(BaseAmount_SocialContributions; "Base Amount")
                    {
                    }
                    column(Employee_Part; FORMAT("Employee's part"))
                    {
                    }
                    column(Real_Amount_Employee; "Real Amount : Employee")
                    {
                        DecimalPlaces = 3 : 3;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        "Rec. Social Contributions".SETFILTER("No.", "Rec. Salary Lines"."No.");
                    end;

                    trigger OnPostDataItem()
                    begin
                        "Rec. Social Contributions".SETFILTER("No.", "Rec. Salary Lines"."No.");
                    end;

                    trigger OnPreDataItem()
                    begin
                        "Rec. Social Contributions".SETFILTER("No.", "Rec. Salary Lines"."No.");
                    end;
                }
                dataitem("<IndemnitiesNonSoc>"; "WDC Rec. Indemnities")
                {
                    DataItemLink = "Employee No." = FIELD("Employee No."),
                                   "No." = FIELD("No.");
                    DataItemTableView = SORTING("No.", "Employee No.", Indemnity)
                                        ORDER(Ascending)
                                        WHERE(Type = FILTER("Taxable (Not Subject to Social Security)"));
                    column(DescriptionNonSoc; Description)
                    {
                    }
                    column(IndemnityNonSoc; Indemnity)
                    {
                    }
                    column(Real_AmountNonSoc; ROUND("Real Amount", 0.001))
                    {
                        DecimalPlaces = 3 : 3;
                    }
                    column("QuantitéNonSoc"; Quantité)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        "Rec. Indemnities".SETFILTER("Rec. Indemnities"."No.", "Rec. Salary Lines"."No.");
                        "Rec. Indemnities".SETFILTER("Rec. Indemnities"."Employee No.", "Rec. Salary Lines"."Employee No.");
                        Quantité := 0;
                        CLEAR(RecEmploye);
                        IF RecEmploye.GET("Rec. Indemnities"."Employee No.") THEN
                            IF RecEmploye."Employee type".AsInteger() = 1 THEN
                                Quantité := "Rec. Indemnities"."Days Number"

                            ELSE
                                Quantité := "Rec. Indemnities"."Days Number" * 8;
                    end;

                    trigger OnPostDataItem()
                    begin
                        "Rec. Indemnities".SETFILTER("Rec. Indemnities"."No.", "Rec. Salary Lines"."No.");
                        "Rec. Indemnities".SETFILTER("Rec. Indemnities"."Employee No.", "Rec. Salary Lines"."Employee No.");
                    end;

                    trigger OnPreDataItem()
                    begin
                        "Rec. Indemnities".SETFILTER("Rec. Indemnities"."No.", "Rec. Salary Lines"."No.");
                        "Rec. Indemnities".SETFILTER("Rec. Indemnities"."Employee No.", "Rec. Salary Lines"."Employee No.");
                    end;
                }

                trigger OnAfterGetRecord()
                begin

                    //calc sal compl du mois
                    CLEAR(SaliaireComplementaire);
                    RecG_Indemnities.SETRANGE("Employee No.", "Rec. Salary Lines"."Employee No.");
                    RecG_Indemnities.SETRANGE(RecG_Indemnities."No.", "Rec. Salary Lines"."No.");
                    RecG_Indemnities.SETFILTER(Indemnity, '%1|%2', 'SAL COMPL M', 'SAL COMPL H');
                    IF RecG_Indemnities.FINDFIRST THEN
                        SaliaireComplementaire := RecG_Indemnities."Real Amount";

                    QtéJ := 0;
                    RecGHOcc.RESET;
                    RecGHOcc.SETRANGE("Employee No.", "Rec. Salary Lines"."Employee No.");
                    RecGHOcc.SETRANGE("Payment No.", "Rec. Salary Lines"."No.");
                    IF RecGHOcc.FINDSET THEN BEGIN
                        QtéJ := RecGHOcc."Days Number";
                    END;

                    NbrHSTot := 0;
                    //------------100%
                    NbrHS := 0;
                    MontHS := 0;
                    RecGHeurSup.RESET;
                    RecGHeurSup.SETRANGE("Employee No.", "Rec. Salary Lines"."Employee No.");
                    RecGHeurSup.SETRANGE("Payment Month", "Rec. Salary Lines".Month);
                    RecGHeurSup.SETRANGE("Payment Year", Year);
                    RecGHeurSup.SETFILTER("Payment No.", '<>%1', '');
                    RecGHeurSup.SETFILTER("Overtime Rate", '%1', 1);
                    IF RecGHeurSup.FINDSET THEN BEGIN
                        REPEAT
                            NbrHS := NbrHS + RecGHeurSup."Hours Number";
                            MontHS := MontHS + RecGHeurSup."Line amount";
                        UNTIL RecGHeurSup.NEXT = 0;
                        BaseHS := MontHS / NbrHS;
                    END;
                    //------------125%
                    NbrHS125 := 0;
                    MontHS125 := 0;
                    RecGHeurSup.RESET;
                    RecGHeurSup.SETRANGE("Employee No.", "Rec. Salary Lines"."Employee No.");
                    RecGHeurSup.SETRANGE("Payment Month", "Rec. Salary Lines".Month);
                    RecGHeurSup.SETRANGE("Payment Year", Year);
                    RecGHeurSup.SETFILTER("Payment No.", '<>%1', '');
                    RecGHeurSup.SETFILTER("Overtime Rate", '%1', 0.25);
                    IF RecGHeurSup.FINDSET THEN BEGIN
                        REPEAT
                            NbrHS125 := NbrHS125 + RecGHeurSup."Hours Number";
                            MontHS125 := MontHS125 + RecGHeurSup."Line amount";
                        UNTIL RecGHeurSup.NEXT = 0;
                        BaseHS125 := MontHS125 / NbrHS125;
                    END;
                    //------------150%
                    NbrHS15 := 0;
                    MontHS15 := 0;
                    RecGHeurSup.RESET;
                    RecGHeurSup.SETRANGE("Employee No.", "Rec. Salary Lines"."Employee No.");
                    RecGHeurSup.SETRANGE("Payment Month", "Rec. Salary Lines".Month);
                    RecGHeurSup.SETRANGE("Payment Year", Year);
                    RecGHeurSup.SETFILTER("Payment No.", '<>%1', '');
                    RecGHeurSup.SETFILTER("Overtime Rate", '%1', 0.5);
                    IF RecGHeurSup.FINDSET THEN BEGIN
                        REPEAT
                            NbrHS15 := NbrHS15 + RecGHeurSup."Hours Number";
                            MontHS15 := MontHS15 + RecGHeurSup."Line amount";
                        UNTIL RecGHeurSup.NEXT = 0;
                        BaseHS15 := MontHS15 / NbrHS15;
                    END;
                    //------------175%
                    NbrHS175 := 0;
                    MontHS175 := 0;
                    RecGHeurSup.RESET;
                    RecGHeurSup.SETRANGE("Employee No.", "Rec. Salary Lines"."Employee No.");
                    RecGHeurSup.SETRANGE("Payment Month", "Rec. Salary Lines".Month);
                    RecGHeurSup.SETRANGE("Payment Year", Year);
                    RecGHeurSup.SETFILTER("Payment No.", '<>%1', '');
                    RecGHeurSup.SETFILTER("Overtime Rate", '%1', 0.75);
                    IF RecGHeurSup.FINDSET THEN BEGIN
                        REPEAT
                            NbrHS175 := NbrHS175 + RecGHeurSup."Hours Number";
                            MontHS175 := MontHS175 + RecGHeurSup."Line amount";
                        UNTIL RecGHeurSup.NEXT = 0;
                        BaseHS175 := MontHS175 / NbrHS175;
                    END;
                    //------------200%
                    //>>
                    NbrHS200 := 0;
                    MontHS200 := 0;
                    RecGHeurSup.RESET;
                    RecGHeurSup.SETRANGE("Employee No.", "Rec. Salary Lines"."Employee No.");
                    RecGHeurSup.SETRANGE("Payment Month", "Rec. Salary Lines".Month);
                    RecGHeurSup.SETRANGE("Payment Year", Year);
                    RecGHeurSup.SETFILTER("Payment No.", '<>%1', '');
                    RecGHeurSup.SETFILTER("Overtime Rate", '%1', 2);
                    IF RecGHeurSup.FINDSET THEN BEGIN
                        REPEAT
                            NbrHS200 := NbrHS200 + RecGHeurSup."Hours Number";
                            MontHS200 := MontHS200 + RecGHeurSup."Line amount";
                        UNTIL RecGHeurSup.NEXT = 0;
                        BaseHS200 := MontHS200 / NbrHS200;
                    END;
                    //<<

                    //>>
                    /// Assurance Groupe
                    MontAssGrp := 0;
                    NbrHSTot := NbrHS + NbrHS125 + NbrHS15 + NbrHS175 + NbrHS200;
                    RecGSocialContr.RESET;
                    RecGSocialContr.SETRANGE("Employee No.", "Rec. Salary Lines"."Employee No.");
                    RecGSocialContr.SETRANGE("No.", "Rec. Salary Lines"."No.");
                    RecGSocialContr.SETRANGE("Social Contribution", 'ASS GRP');
                    IF RecGSocialContr.FINDSET THEN BEGIN
                        MontAssGrp := RecGSocialContr."Real Amount : Employee";
                    END;

                    //<<

                    //>>
                    //CSS:="Monthly CSS Tax"-"Taxe (Month)";
                    //IF CSS<0 THEN CSS :=0;
                    //<<
                    //>>WDC01

                    GEmployee.GET("Employee No.");
                    GEmployee.CALCFIELDS("Loaded childs");
                    //GEmployee.CALCFIELDS("Job Title");
                    A_PRIME := 0;
                    P_KBE := 0;
                    P_REND := 0;
                    I_FONC := 0;
                    I_PANIER := 0;
                    I_PRES := 0;
                    I_TRAN := 0;
                    P_KBETRS := 0;
                    ACCORD_2021 := 0;
                    AUG_2021 := 0;
                    I_AKEBIRC := 0;
                    D_MAR := 0;
                    D_NAI := 0;
                    C_PAYE := 0;
                    THJP := 0;
                    THJE := 0;
                    JFER := 0;
                    HJFER := 0;
                    HS := 0;
                    CP := 0;
                    INDNCOT := 0;
                    HS25 := 0;
                    HS50 := 0;
                    I_AKEBIRC := 0;
                    D_AFITR := 0;
                    D_AKEBIR := 0;
                    D_RENTSCO := 0;
                    SalBrutSIVP := 0;
                    Realbasissalary := "Real basis salary";
                    CLEAR(GIndemnities);
                    //<<WDC01
                    //>>WDC02
                    Realbasissalary := "Real basis salary";
                    IF GEmployee."Employee type".AsInteger() = 0 THEN BEGIN
                        CLEAR(HeureTrav);
                        HeureTrav.SETRANGE("Employee No.", "Employee No.");
                        HeureTrav.SETRANGE(HeureTrav."Payment No.", "No.");
                        HeureTrav.SETRANGE("Payment Month", Month);
                        HeureTrav.SETRANGE("Payment Year", Year);
                        IF HeureTrav.FINDSET THEN BEGIN
                            THJP := HeureTrav."Hours Number";
                            JFER := HeureTrav."Pulic Holiday Days" * 8;
                        END;
                        CLEAR(Absence);
                        Absence.SETRANGE("Employee No.", "Employee No.");
                        Absence.SETRANGE("Payment No.", "No.");
                        Absence.SETRANGE("Posting month", Month);
                        Absence.SETRANGE("Posting year", Year);
                        Absence.SETRANGE("Cause of Absence Code", 'CP');
                        IF Absence.FINDSET THEN BEGIN
                            CP := Absence.Quantity * 8;
                        END;
                    END
                    ELSE
                        IF GEmployee."Employee type".AsInteger() = 1 THEN BEGIN
                            THJP := "Rec. Salary Lines"."Paied days";
                            CLEAR(HeureTrav);
                            HeureTrav.SETRANGE("Employee No.", "Employee No.");
                            HeureTrav.SETRANGE(HeureTrav."Payment No.", "No.");
                            HeureTrav.SETRANGE("Payment Month", Month);
                            HeureTrav.SETRANGE("Payment Year", Year);
                            IF HeureTrav.FINDSET THEN BEGIN
                                JFER := HeureTrav."Pulic Holiday Days";
                            END;
                            CLEAR(Absence);
                            Absence.SETRANGE("Employee No.", "Employee No.");
                            Absence.SETRANGE("Payment No.", "No.");
                            Absence.SETRANGE("Posting month", Month);
                            Absence.SETRANGE("Posting year", Year);
                            Absence.SETRANGE("Cause of Absence Code", 'CP');
                            IF Absence.FINDSET THEN BEGIN
                                CP := Absence.Quantity;
                            END;
                        END;
                    THJE := THJP + JFER + CP;
                    CLEAR(HeureSupp);
                    HeureSupp.SETRANGE("Employee No.", "Employee No.");
                    HeureSupp.SETRANGE("Payment No.", "No.");
                    HeureSupp.SETRANGE("Payment Month", Month);
                    HeureSupp.SETRANGE("Payment Year", Year);
                    IF HeureSupp.FINDSET THEN
                        REPEAT
                            IF HeureSupp."Overtime Rate" = 0 THEN HS += HeureSupp."Line amount";
                            IF HeureSupp."Overtime Rate" = 0.25 THEN HS25 += HeureSupp."Line amount";
                            IF HeureSupp."Overtime Rate" = 0.5 THEN HS50 += HeureSupp."Line amount";
                        UNTIL HeureSupp.NEXT = 0;
                    IF ROUND("Non Taxable Soc. Contrib.", 0.001) = 0 THEN
                        SalBrutSIVP := "Gross Salary"
                    ELSE
                        SalBrutSIVP := 0;
                    //>>Jour Supp
                    J_SUPP := 0;
                    IndemJS.RESET;
                    IndemJS.SETRANGE("Emplymt. Contract Code", "Employee No.");
                    IndemJS.SETFILTER("Indemnity Code", '%1', 'J.SUPP');
                    IF IndemJS.FINDSET THEN
                        J_SUPP := IndemJS."Days Number"
                    ELSE
                        J_SUPP := 0;
                    //<<WDC02
                    //<<WDC03
                    CLEAR(NoteTrim);
                    IF "Quarterly Note" <> 0 THEN
                        NoteTrim := "Quarterly Note"
                    ELSE BEGIN
                        CLEAR(Gemp);
                        IF Gemp.GET("Employee No.") THEN
                            NoteTrim := Gemp."Quarterly Note";
                    END;
                    //>>WDC03

                end;
            }

            trigger OnAfterGetRecord()
            begin

                Afficher := TRUE;
                IF Month.AsInteger() > 11 THEN Afficher := FALSE;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Solde Fin Contrat"; SFC)
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        IF SFC THEN TextTitre := 'Solde fin de contrat';
                    end;
                }
                field("Solde de tous compte"; STC)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        IF STC THEN BEGIN
                            TextTitre := 'Solde de tous compte';
                            txtmsg := TxtSTC;
                        END;
                    end;
                }
            }
        }

    }


    var
        SaliaireComplementaire: Decimal;
        RecG_Indemnities: Record "WDC Rec. Indemnities";
        JourTrav: Decimal;
        RecEmploye: Record Employee;
        "Quantité": Decimal;
        NBJourtravail: Decimal;
        RecGContrat: Record "Employment Contract";
        RecGRegime: Record "WDC work Regimes";
        DECGNBHEURE: Decimal;
        DECGNBJOURS: Decimal;
        Salarylines: Record "WDC Salary Lines";
        RecGHeurSup: Record "WDC Overtime hours recorded m";
        NbrHS: Decimal;
        MontHS: Decimal;
        BaseHS: Decimal;
        NbrHS125: Decimal;
        MontHS125: Decimal;
        BaseHS125: Decimal;
        NbrHS15: Decimal;
        MontHS15: Decimal;
        BaseHS15: Decimal;
        NbrHS175: Decimal;
        MontHS175: Decimal;
        BaseHS175: Decimal;
        NbrHS200: Decimal;
        MontHS200: Decimal;
        BaseHS200: Decimal;
        RecGSocialContr: Record "WDC Rec. Social Contributions";
        NbrHSTot: Decimal;
        SoldeCong: Decimal;
        MontAssGrp: Decimal;
        ChefFamily: Text;
        ApemBaseAmount: Decimal;
        RecGHOcc: Record "WDC Occasional Hours Recorded";
        "QtéJ": Decimal;
        SFC: Boolean;
        STC: Boolean;
        TextTitre: Text;
        txtmsg: Text;
        TxtSTC: Label 'Je reconnais avoir reçu mon solde de tous compte.';
        CSS: Decimal;
        MontCOVID: Decimal;
        DescCOVID: Text[50];
        A_PRIME: Decimal;
        P_KBE: Decimal;
        P_REND: Decimal;
        I_FONC: Decimal;
        I_PANIER: Decimal;
        I_PRES: Decimal;
        I_TRAN: Decimal;
        P_KBETRS: Decimal;
        ACCORD_2021: Decimal;
        AUG_2021: Decimal;
        GIndemnities: Record "WDC Rec. Indemnities";
        SitFam: Code[20];
        NbrEnf: Integer;
        Titre: Code[20];
        Echelle: Code[20];
        C_PAYE: Decimal;
        GEmployee: Record Employee;
        THJP: Decimal;
        THJE: Decimal;
        HeureTrav: Record "WDC Occasional Hours Recorded";
        JFER: Decimal;
        Absence: Record "WDC Employee's days off Entry";
        CP: Decimal;
        HJFER: Decimal;
        Realbasissalary: Decimal;
        INDNCOT: Decimal;
        HS25: Decimal;
        HS50: Decimal;
        HeureSupp: Record "WDC Overtime hours recorded m";
        HS: Decimal;
        D_MAR: Decimal;
        D_NAI: Decimal;
        I_AKEBIRC: Decimal;
        D_AFITR: Decimal;
        D_AKEBIR: Decimal;
        D_RENTSCO: Decimal;
        SalBrutSIVP: Decimal;
        EmpCont: Record "Employment Contract";
        Employeetype: Text[20];
        SalHead: Record "WDC Posted Salary Header";
        IndInvisibiel: Boolean;
        GIndemnity: Record "WDC Indemnity";
        J_SUPP: Decimal;
        IndemJS: Record "WDC Default Indemnities";
        Afficher: Boolean;
        Gemp: Record Employee;
        NoteTrim: Decimal;
        MntPret: Decimal;
        MntAvance: Decimal;
        RecSalarylines: Record "WDC Posted Salary Lines";


    procedure GetTitre(TexteTitre: Text[50]): Text[20]
    begin
        TextTitre := TexteTitre;
    end;
}

