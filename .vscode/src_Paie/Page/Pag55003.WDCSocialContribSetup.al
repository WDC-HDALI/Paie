page 55003 "WDC Social Contrib. Setup"
{
    CaptionML = ENU = 'Social Contributions Setup', FRA = 'Paramètres Cotisations Sociales';
    PageType = List;
    SourceTable = "WDC Social Contribution";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                captionML = ENU = 'General', FRA = 'Général';
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Exploitation Code"; Rec."Exploitation Code")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field(Libellé; Rec.Libellé)
                {
                    ApplicationArea = all;
                }
                field("Evaluation Mode"; Rec."Evaluation Mode")
                {
                    ApplicationArea = all;
                }
                field("Employee's part"; Rec."Employee's part")
                {
                    ApplicationArea = all;
                }
                field("Employer contribution"; Rec."Employer contribution")
                {
                    ApplicationArea = all;
                }
                field("Salary Package"; Rec."Salary Package")
                {
                    ApplicationArea = all;
                }
                field("Employer's part"; Rec."Employer's part")
                {
                    ApplicationArea = all;
                }
                field("Basis of calculation"; Rec."Basis of calculation")
                {
                    ApplicationArea = all;
                }
                field("Employee Account No."; Rec."Employee Account No.")
                {
                    ApplicationArea = all;
                }
                field("Employer Account No."; Rec."Employer Account No.")
                {
                    ApplicationArea = all;
                }
                field("Employer : Bal. Account No."; Rec."Employer : Bal. Account No.")
                {
                    ApplicationArea = all;
                }
                field("Deductible of taxable basis"; Rec."Deductible of taxable basis")
                {
                    ApplicationArea = all;
                }
                field("Not Included in Bonus"; Rec."Not Included in Bonus")
                {
                    Visible = true;
                }

                field("active Max"; Rec."active Max")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions', FRA = 'F&onctions';
                action("Social Contribution Card")
                {
                    CaptionML = ENU = 'Social Contribution Card', FRA = 'Fiche cotisations sociales';
                    Image = SocialSecurityTax;
                    RunObject = Page 55014;
                    RunPageLink = Code = FIELD(Code);
                }
                action("MAJ contrats de travail")
                {
                    CaptionML = ENU = 'Update Employment Contracts', FRA = 'MAJ contrats de travail';
                    Image = FileContract;

                    trigger OnAction()
                    var
                        DefaultCot: Record "WDC Default Soc. Contribution";
                        Soc: Record "WDC Social Contribution";
                    begin
                        Soc.RESET;
                        IF Soc.FINDSET THEN
                            REPEAT
                                DefaultCot.RESET;
                                DefaultCot.SETRANGE("Social Contribution Code", Soc.Code);
                                IF DefaultCot.FINDSET THEN
                                    REPEAT
                                        DefaultCot."Employer's part" := Soc."Employer's part";
                                        DefaultCot."Employee's part" := Soc."Employee's part";
                                        DefaultCot."Basis of calculation" := Soc."Basis of calculation";
                                        DefaultCot."Deductible of taxable basis" := Soc."Deductible of taxable basis";

                                        DefaultCot."Evaluation Mode" := Soc."Evaluation Mode";

                                        DefaultCot."Maximum value - Employee" := Soc."Maximum value - Employee";
                                        DefaultCot."Maximum value - Employer" := Soc."Maximum value - Employer";

                                        DefaultCot."Evaluation Mode" := Soc."Evaluation Mode";
                                        DefaultCot."Salary Package" := Soc."Salary Package";
                                        DefaultCot."Employer contribution" := Soc."Employer contribution";

                                        DefaultCot."Employer's part" := Soc."Employer's part";
                                        DefaultCot."Employee's part" := Soc."Employee's part";

                                        DefaultCot."Not Included in Accounting" := Soc."Not Included in Accounting";
                                        DefaultCot."Not Included in Bonus" := Soc."Not Included in Bonus";

                                        DefaultCot.MODIFY;
                                    UNTIL DefaultCot.NEXT = 0;
                            UNTIL Soc.NEXT = 0;
                    end;
                }
                action("Social Contribution Assignment")
                {
                    CaptionML = ENU = 'Social Contribution Assignment', FRA = 'Affectation Cotisation social';
                    Image = Agreement;
                    RunObject = Page 55015;
                    RunPageLink = "Employee No." = FIELD(Code);
                }
            }
        }
    }
}

