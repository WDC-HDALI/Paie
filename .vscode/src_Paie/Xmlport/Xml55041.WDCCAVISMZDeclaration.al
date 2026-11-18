xmlport 55041 "WDC CAVIS MZ Declaration"
{
    captionML = ENU = 'CAVIS MZ Declaration', FRA = 'Déclaration CAVIS MZ';
    Direction = Export;
    // FieldDelimiter = '<>';
    // FieldSeparator = '''''';
    Format = FixedText;
    TextEncoding = MSDOS;

    schema
    {
        textelement(Root)
        {
            tableelement(Employee; Employee)
            {
                RequestFilterFields = "No.";
                XmlName = 'ContactHeader';
                SourceTableView = WHERE("No." = FILTER(> 1000));
                textelement(numsociete)
                {
                    XmlName = 'NMatEmplyeur';
                    Width = 10;
                }
                fieldelement(NumAssure; Employee."Social Security No.")
                {
                    Width = 10;
                }
                textelement(salairedeclare)
                {
                    XmlName = 'SalaireDeclare';
                    Width = 13;
                }
                textelement(SalairePlafone)
                {
                    Width = 13;
                }
                textelement(SalaireDiffrentiel)
                {
                    Width = 13;
                }

                trigger OnAfterGetRecord()
                var
                    HumanResourcesSetup: Record "Human Resources Setup";
                    RecSocialContributions: Record "WDC Rec. Social Contributions";
                begin
                    //----------------------
                    RecSocialContributions.RESET;
                    RecSocialContributions.SETRANGE("Calculate Year", Year);
                    RecSocialContributions.SETRANGE("Employee No.", Employee."No.");
                    RecSocialContributions.SETRANGE("Social Contribution", 'CAVIS');
                    IF RecSocialContributions.FINDSET THEN
                        RecSocialContributions.CALCSUMS("Base Amount")
                    ELSE
                        currXMLport.SKIP;
                    SalaireDeclare := PADSTR('', 13 - STRLEN(DecToString(RecSocialContributions."Base Amount", 1)), '0') + DecToString(RecSocialContributions."Base Amount", 1);
                    SalairePlafone := PADSTR('', 13 - STRLEN(DecToString(SalPlafone, 1)), '0') + DecToString(SalPlafone, 1);
                    SalaireDiffrentiel := PADSTR('', 13 - STRLEN(DecToString(RecSocialContributions."Base Amount" - SalPlafone, 1)), '0') + DecToString(SalPlafone - RecSocialContributions."Base Amount", 1);
                    NumSociete := infosoc."Social Security No.";
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Year; Year)
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Year', FRA = 'Année';
                }
            }
        }

    }

    trigger OnInitXmlPort()
    var
        HumanResourcesSetup: Record "Human Resources Setup";
        SocialContribution: Record "WDC Social Contribution";
    begin

        i := 0;
        infosoc.GET;
        IF HumanResourcesSetup.GET THEN;
        SocialContribution.RESET;
        SocialContribution.SETRANGE(Code, 'CAVIS');
        IF SocialContribution.FINDSET THEN;
        SalPlafone := 3 * HumanResourcesSetup."Minimum wage guarantee" * SocialContribution."Employer's part";
    end;

    var
        PageN: Text[3];
        Montantcum: Code[11];
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        LigneSalaireEnreg: Record "WDC Salary Lines";
        LigneSalaireEnreg1: Record "WDC Salary Lines";
        LigneSalaireEnreg2: Record "WDC Salary Lines";
        LigneSalaireEnreg3: Record "WDC Salary Lines";
        Trimestre: Option "1er","2ème","3ème","4ème";
        Year: Integer;
        Total: Decimal;
        Comp: Text[30];
        CNSS: Record "WDC Rec. Social Contributions";
        Total2: Decimal;
        Total3: Decimal;
        i: Integer;
        j: Integer;
        infosoc: Record 79;
        CNSSEmpl: Code[20];
        EmplContract: Record "Employment Contract";
        DefaultSoc: Record "WDC Default Soc. Contribution";
        PaieFrom: Record 55024;
        PaieTo: Record 55024;
        F39001471: Page 55044;
        NonNum: Text[1];
        k: Integer;
        TypeCNSS: Option CNSS,CNSS5,CNSS7;
        TCNSS: Code[20];
        RecSocialContribution: Record "WDC Social Contribution";
        RecSocialContribution1: Record "WDC Social Contribution";
        numsoc: Code[20];
        EmployePostingGpeCode: Code[50];
        EmployeePostingGroup: Record 55029;
        GlobalGrossSalary: Decimal;
        SalPlafone: Decimal;


    procedure DecToString(dec: Decimal; type: Integer): Text[250]
    var
        Str: Text[250];
    begin
        IF type = 0 THEN            // Conversion integer
         BEGIN
            Str := FORMAT(dec, 0, '<Integer>');
        END
        ELSE                        // Other
         BEGIN
            dec := dec * 1000;
            Str := FORMAT(dec, 0, '<Integer>');
            //Str := INSSTR(Str,'V',STRLEN(Str)-(3-1));
        END;

        Str := DELCHR(Str, '=', '');
        EXIT(Str);
    end;
}

