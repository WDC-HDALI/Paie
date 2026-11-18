page 55000 "WDC Indemnities List"
{
    CaptionML = ENU = 'Indemnities List', FRA = 'Liste indemnités';
    PageType = List;
    SourceTable = "WDC Indemnity";
    CardPageId = 55017;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Includes Extra Days"; Rec."Includes Extra Days")
                {
                    ApplicationArea = all;
                }
                field("Included Breastfeeding Hours"; Rec."Included Breastfeeding Hours")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Included in Overtime"; Rec."Included in Overtime")
                {
                    ApplicationArea = all;
                }
                field("Evaluation mode"; Rec."Evaluation mode")
                {
                    ApplicationArea = all;
                }
                field("Default amount"; Rec."Default amount")
                {
                    ApplicationArea = all;
                }
                field("Days Number"; Rec."Days Number")
                {
                    ApplicationArea = all;
                }
                field("Not Included in Bonus"; Rec."Not Included in Bonus")
                {
                    ApplicationArea = all;
                }
                field("% Of Basic Salary"; Rec."% Of Basic Salary")
                {
                    ApplicationArea = all;
                }
                field("Rate % Base Salary"; Rec."Rate % Base Salary")
                {
                    ApplicationArea = all;
                }
                field("Amount Rounding Precision"; Rec."Amount Rounding Precision")
                {
                    ApplicationArea = all;
                }
                field("Rounding Direction"; Rec."Rounding Direction")
                {
                    ApplicationArea = all;
                }
                field("Not included in vacation days"; Rec."Not included in vacation days")
                {
                    ApplicationArea = all;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = all;
                }
                field("Conventional Indemnity"; Rec."Conventional Indemnity")
                {
                    ApplicationArea = all;
                }
                field("Indemnity Type"; Rec."Indemnity Type")
                {
                    ApplicationArea = all;
                }
                field("Minimum value"; Rec."Minimum value")
                {
                    ApplicationArea = all;
                }
                field("Included in Insurance Base"; Rec."Included in Insurance Base")
                {
                    ApplicationArea = all;
                }
                field("Deduction Base Indemnity/Days"; Rec."Deduction Base Indemnity/Days")
                {
                    ApplicationArea = all;
                }
                field("Benefit in Kind"; Rec."Benefit in Kind")
                {
                    ApplicationArea = all;
                }
                field("Non-Deductible Work Accident"; Rec."Non-Deductible Work Accident")
                {
                    ApplicationArea = all;
                }
                field("Indemnity Account No."; Rec."Indemnity Account No.")
                {
                    ApplicationArea = all;
                }
                field("Indemnity Balance Account No."; Rec."Indemnity Balance Account No.")
                {
                    ApplicationArea = all;
                }
                field("Not Included Public Holidays"; Rec."Not Included Public Holidays")
                {

                    trigger OnValidate()
                    begin
                        //>>
                        IF Rec."Not Included Public Holidays" = TRUE THEN BEGIN
                            DefTmp.RESET;
                            DefTmp.SETRANGE("Indemnity Code", Rec.Code);
                            IF DefTmp.FINDSET THEN BEGIN
                                DefTmp.MODIFYALL("Not Included Public Holidays", rec."Not Included Public Holidays");
                            END;
                        END;
                        //<<
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {


            group("Fonction&s")
            {
                CaptionML = ENU = 'Functions', FRA = 'Fonctions';
                action("Propose Indemnity")
                {
                    captionMl = ENU = 'Propose Indemnity', FRA = 'Proposer l''indemnité';
                    Image = AmountByPeriod;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        lProposeIndemnities: Report 55012;
                    begin
                        CLEAR(lProposeIndemnities);
                        lProposeIndemnities.SetIndemnityCode(Rec.Code);
                        lProposeIndemnities.RUNMODAL;
                        CurrPage.UPDATE;
                    end;
                }

                action("Update Public Holiday Included/Not")
                {
                    captionML = ENU = 'Update Public Holiday Included/Not', FRA = 'Mise à jour Jour Férie Inclus/Non';
                    Image = Calculate;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        DefTmp.RESET;
                        DefTmp.SETRANGE("Indemnity Code", Rec.Code);
                        IF DefTmp.FINDSET THEN BEGIN
                            DefTmp.MODIFYALL("Not Included Public Holidays", Rec."Not Included Public Holidays");
                        END;
                    end;
                }
                action("Update Overtime Included")
                {
                    captionML = ENU = 'Update Overtime Included', FRA = 'Mise à jour Heures Sup Inclus';
                    Image = Calculate;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        DefTmp.RESET;
                        DefTmp.SETRANGE("Indemnity Code", Rec.Code);
                        IF DefTmp.FINDSET THEN BEGIN
                            DefTmp.MODIFYALL("Included in Overtime", Rec."Included in Overtime");
                        END;
                    end;
                }
                action("Update Included in Vacation Days")
                {
                    Image = Calculate;
                    captionML = ENU = 'Update Included in Vacation Days', FRA = 'Mise à jour Inclus dans jours congé';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        DefTmp.RESET;
                        DefTmp.SETRANGE("Indemnity Code", Rec.Code);
                        IF DefTmp.FINDSET THEN BEGIN
                            DefTmp.MODIFYALL("Not included in vacation days", Rec."Not included in vacation days");
                        END;
                    end;
                }
                action("Update,Attaittement|A.Technique|UGTT")
                {
                    CaptionML = ENU = 'Update,Attaittement|A.Technique|UGTT',
                                FRA = 'Mise à jour,Attaittement|A.Technique|UGTT';
                    Image = Salutation;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        DefTmp.RESET;
                        DefTmp.SETRANGE("Indemnity Code", Rec.Code);
                        IF DefTmp.FINDSET THEN BEGIN
                            DefTmp.MODIFYALL("Included Breastfeeding Hours", Rec."Included Breastfeeding Hours");
                            DefTmp.MODIFYALL("Included in UGTT Hours", Rec."Included in UGTT Hours");
                        END;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;

    var

        DefTmp: Record "WDC Default Indemnities";
        PageContractsListInd: Page 55016;
}

