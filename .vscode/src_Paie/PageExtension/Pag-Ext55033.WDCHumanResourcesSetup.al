pageextension 55033 "WDC Human Resources Setup" extends "Human Resources Setup"
{
    layout
    {
        addbefore(Numbering)
        {
            group("General")
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Paid Holiday Indemnity"; Rec."Paid Holiday Indemnity")
                {
                    ApplicationArea = all;
                }

                field("Indem Overtime Days"; Rec."Indem Overtime Days")
                {
                    ApplicationArea = all;
                }
                field("Indem Aid Fitr"; Rec."Indem Aid Fitr")
                {
                    ApplicationArea = all;
                }
                field("Indem Aid Idhha"; Rec."Indem Aid Idhha")
                {
                    ApplicationArea = all;
                }
                field("Indem Don Rent"; Rec."Indem Don Rent")
                {
                    ApplicationArea = all;
                }

                field("Exceptional Bonus"; Rec."Exceptional Bonus")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Exceptional Bonus Amount"; Rec."Exceptional Bonus Amount")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(Commission; Rec.Commission)
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Responsable Address"; Rec."Responsable Address")
                {
                    ApplicationArea = all;

                }
                field("Responsable Name"; Rec."Responsable Name")
                {
                    ApplicationArea = all;
                }
                field("Transfer ATB Bank"; Rec."Transfer ATB Bank")
                {
                    ApplicationArea = all;
                }
            }
        }
        addlast(Numbering)
        {

            field("Loan & Advance Nos."; Rec."Loan & Advance Nos.")
            {
                ApplicationArea = all;
            }
            field("Paiment Nos."; Rec."Paiment Nos.")
            {
                ApplicationArea = all;
            }
            field("Employment Contract Nos."; Rec."Employment Contract Nos.")
            {
                ApplicationArea = all;
            }
            field("Salary grid Nos."; Rec."Salary grid Nos.")
            {
                ApplicationArea = all;
            }
            field("Supp. hours Nos."; Rec."Supp. hours Nos.")
            {
                ApplicationArea = all;
            }

        }
        addafter(Numbering)
        {
            group(Constants)
            {
                CaptionML = ENU = 'Constants', FRA = 'Constantes';
                field("Code CSS Contribution"; Rec."Code CSS Contribution")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Apply Retribution for Old Days"; Rec."Apply Retribution for Old Days")
                {
                    ApplicationArea = all;
                }
                field("Active IRPP Ceiling"; Rec."Active IRPP Ceiling")
                {
                    ApplicationArea = all;
                }
                field("Income Tax Calculation Ceiling"; Rec."Income Tax Calculation Ceiling")
                {
                    ApplicationArea = all;
                }
                field("Deduction for Familly Chief"; Rec."Deduction for Familly Chief")
                {
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Minimum wage guarantee"; Rec."Minimum wage guarantee")
                {
                    ApplicationArea = all;
                }
                field("Pourcent professional expenses"; Rec."Pourcent professional expenses")
                {
                    ApplicationArea = all;
                }
                field("Professional Expenses Charges"; Rec."Professional Expenses Charges")
                {
                    ApplicationArea = all;
                }
                field("Paid days"; Rec."Paid days")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Worked days"; Rec."Worked days")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("From Work day to Work hour"; Rec."From Work day to Work hour")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Regulation Taxe"; Rec."Regulation Taxe")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = all;
                }
                field("Monthes Number"; Rec."Monthes Number")
                {
                    ApplicationArea = all;
                }
                field("Rounded Amount"; Rec."Rounded Amount")
                {
                    ApplicationArea = all;
                }
                field("Payroll Calculation Date"; Rec."Payroll Calculation Date")
                {
                    ApplicationArea = all;
                }
                field("Annual Days Number"; Rec."Annual Days Number")
                {
                    ApplicationArea = all;
                }
                field("Annual Hours Number"; Rec."Annual Hours Number")
                {
                    ApplicationArea = all;
                }
                group("Fortnightly regime")
                {
                    Caption = 'Activate fortnightly regime';
                    field("Activate fortnightly regime"; Rec."Activate fortnightly regime")
                    {
                        ApplicationArea = all;
                    }
                }
            }
            group(Accounting)
            {
                CaptionML = ENU = 'Accounting', FRA = 'Comptabilité';
                field("General Journal Template"; Rec."General Journal Template")
                {
                    ApplicationArea = all;
                }
                field("Gen. Journal Batch (Payroll)"; Rec."Gen. Journal Batch (Payroll)")
                {
                    ApplicationArea = all;
                }
                field("Gen. Journal Batch (L&A)"; Rec."Gen. Journal Batch (L&A)")
                {
                    ApplicationArea = all;
                }
                field("Loss on rounding amounts"; Rec."Loss on rounding amounts")
                {
                    ApplicationArea = all;
                }
            }
            group("Bonus Pay")
            {
                CaptionML = ENU = 'Bonus Pay', FRA = 'Prime';

                group("Paie inverse")
                {
                    Caption = 'Paie inverse';
                    field("Activate Bonus Type"; Rec."Activate Bonus Type")
                    {
                        ApplicationArea = all;
                    }
                    field("Indem Bonus diff."; Rec."Indem Bonus diff.")
                    {
                        ApplicationArea = all;
                    }
                    field("Indem Salary Diff."; Rec."Indem Salary Diff.")
                    {
                        ApplicationArea = all;
                    }
                }
            }
            group(Loans)
            {
                CaptionML = ENU = 'Loans', FRA = 'Prêts';
                field("Loan Calculation Type"; Rec."Loan Calculation Type")
                {
                    ApplicationArea = all;
                }
                field("Loan Limit Mode"; Rec."Loan Limit Mode")
                {
                    ApplicationArea = all;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = all;
                }
                field("Calculate Absence Amount"; Rec."Calculate Absence Amount")
                {
                    ApplicationArea = all;
                }
                field("Amount retained cash FS"; Rec."Amount retained cash FS")
                {
                    ApplicationArea = all;
                }
            }
            group(others)
            {
                field("Matricule Directeur Général"; Rec."Matricule Directeur Général")
                {
                    ApplicationArea = all;
                }
                field("Nom Prénom DG"; Rec."Nom Prénom DG")
                {
                    ApplicationArea = all;
                }
                field("Matricule Chef Service RH"; Rec."Matricule Chef Service RH")
                {
                    ApplicationArea = all;
                }
                field("Nom Prénom Chef Sce RH"; Rec."Nom Prénom Chef Sce RH")
                {
                    ApplicationArea = all;
                }
                field("Registration number D.A.F"; Rec."Registration number D.A.F")
                {
                    ApplicationArea = all;
                }
                field("D.A.F. Full Name"; Rec."D.A.F. Full Name")
                {
                    ApplicationArea = all;
                }
                field("Payslip PDF Path"; Rec."Payslip PDF Path")
                {
                    ApplicationArea = all;
                }
                field("P-Encouragement"; Rec."P-Encouragement")
                {
                    ApplicationArea = all;
                }
                field("P-Bonus"; Rec."P-Bonus")
                {
                    ApplicationArea = all;
                }
                field("Team Bonus"; Rec."Team Bonus")
                {
                    ApplicationArea = all;
                }
                field("Competence Bonus"; Rec."Competence Bonus")
                {
                    ApplicationArea = all;
                }
                field("Overtime Houres Bonus"; Rec."Overtime Houres Bonus")
                {
                    ApplicationArea = all;
                }
                field("Mission Bonus"; Rec."Mission Bonus")
                {
                    ApplicationArea = all;
                }
                field("Assignment Bonus"; Rec."Assignment Bonus")
                {
                    ApplicationArea = all;
                }
                field("Position Bonus"; Rec."Position Bonus")
                {
                    ApplicationArea = all;
                }
                field("Back Pay"; Rec."Back Pay")
                {
                    ApplicationArea = all;
                }
                field("Productivity Bonus"; Rec."Productivity Bonus")
                {
                    ApplicationArea = all;
                }
                field("Quality Coordination Bonus"; Rec."Quality Coordination Bonus")
                {
                    ApplicationArea = all;
                }
                field("13th Month Bonus"; Rec."13th Month Bonus")
                {
                    ApplicationArea = all;
                }
                field("Quarterly Bonus"; Rec."Quarterly Bonus")
                {
                    ApplicationArea = all;
                }
                field("End of Contract Balance Amount"; Rec."End of Contract Balance Amount")
                {
                    ApplicationArea = all;
                }
                field("Gratification Aid"; Rec."Gratification Aid")
                {
                    ApplicationArea = all;
                }
                field(Gratification; Rec.Gratification)
                {
                    ApplicationArea = all;
                }
                field("Severance Pay Indemnity"; Rec."Severance Pay Indemnity")
                {
                    ApplicationArea = all;
                }
                field("Objective Bonus"; Rec."Objective Bonus")
                {
                    ApplicationArea = all;
                }
                field("Seniority Bonus"; Rec."Seniority Bonus")
                {
                    ApplicationArea = all;
                }
                field("Retirement Bonus"; Rec."Retirement Bonus")
                {
                    ApplicationArea = all;
                }
                field("Other Back Pay"; Rec."Other Back Pay")
                {
                    ApplicationArea = all;
                }
                field("Transport Bonus"; Rec."Transport Bonus")
                {
                    ApplicationArea = all;
                }
                field("Maternity Leave Indem."; Rec."Maternity Leave Indem.")
                {
                    ApplicationArea = all;
                }
                field("Hours A.T"; Rec."Hours A.T")
                {
                    ApplicationArea = all;
                }
                field("Activate Alert Other Payroll"; Rec."Activate Alert Other Payroll")
                {
                    ApplicationArea = all;
                }
                field("1/2 solde à partir de"; Rec."1/2 solde à partir de")
                {
                    ApplicationArea = all;
                }
                field("Type de Note"; Rec."Type de Note")
                {
                    ApplicationArea = all;
                }
                field("Code Monthly Rend. Indem."; Rec."Code Monthly Rend. Indem.")
                {
                    ApplicationArea = all;
                }
                field("Apply Monthly Perfor. Bonus"; Rec."Apply Monthly Perfor. Bonus")
                {
                    ApplicationArea = all;
                }
                field("Apply Loan After"; Rec."Apply Loan After")
                {
                    ApplicationArea = all;
                }
                field("Absence Reason for Expense"; Rec."Absence Reason for Expense")
                {
                    ApplicationArea = all;
                }
                field("Leave Balance Calc. Type"; Rec."Leave Balance Calc. Type")
                {
                    ApplicationArea = all;
                }
                field("Calculate STC auto."; Rec."Calculate STC auto.")
                {
                    ApplicationArea = all;
                }
                field("Include Leave Entitlement Days"; Rec."Include Leave Entitlement Days")
                {
                    ApplicationArea = all;
                }
                field("Include Overtime Hours"; Rec."Include Overtime Hours")
                {
                    ApplicationArea = all;
                }
                field("Include Night Hours"; Rec."Include Night Hours")
                {
                    ApplicationArea = all;
                }
                field("Bonus calculation Type"; Rec."Bonus calculation Type")
                {
                    ApplicationArea = all;
                }
                field("Default Panier"; Rec."Default Panier")
                {
                    ApplicationArea = all;
                }
                field("Directeur général"; Rec."Directeur général")
                {
                    ApplicationArea = all;
                }
            }

        }
    }



    trigger OnAfterGetRecord()
    begin
        SetStyle
    end;

    trigger OnOpenPage()
    begin
        IF Rec."Apply Monthly Perfor. Bonus" THEN
            IndRendMensuelEditable := TRUE
        ELSE
            IndRendMensuelEditable := FALSE
    end;

    var
        IndRendMensuelEditable: Boolean;
        FieldStyle: Text[50];


    procedure SetStyle()
    begin
        IF Rec."Regulation Taxe".AsInteger() > 2 THEN
            FieldStyle := 'StrongAccent'
        ELSE
            FieldStyle := 'Standard';
    end;
}

