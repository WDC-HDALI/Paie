page 55045 "WDC Recorded Salary Lines"
{
    CaptionML = ENU = 'Recorded Salary Lines', FRA = 'Lignes salaires enregistrées';
    Editable = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "WDC Posted Salary Lines";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field(Month; Rec.Month)
                {
                    ApplicationArea = all;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Employee; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Employee type"; Rec."Employee type")
                {
                    ApplicationArea = all;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(CNSS; Rec.CNSS)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field("6 SMIG"; Rec."6 SMIG")
                {
                    ApplicationArea = all;
                }
                field("Cumulative Taxable Salary"; Rec."Cumulative Taxable Salary")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Recorded Pay Days"; Rec."Recorded Pay Days")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Taxable Average Period"; Rec."Taxable Average Period")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Annual Taxable"; Rec."Annual Taxable")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Real taxable (Year)"; Rec."Real taxable (Year)")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Days Period Number"; Rec."Days Period Number")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Public Holidays"; Rec."Public Holidays")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Public Holiday Amount"; Rec."Public Holiday Amount")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Holiday Taken"; Rec."Holiday Taken")
                {
                    ApplicationArea = all;
                }
                field("Seniority leave entitlement"; Rec."Seniority leave entitlement")
                {
                    ApplicationArea = all;
                }
                field("Base RCGC"; Rec."Base RCGC")
                {
                    ApplicationArea = all;
                }
                field("Retenue CGC"; Rec."Retenue CGC")
                {
                    ApplicationArea = all;
                }
                field("Worked hours"; Rec."Worked hours")
                {
                    ApplicationArea = all;
                }

                field(Note; Rec.Note)
                {
                    Visible = NoteVisible;
                    ApplicationArea = all;
                }
                field(Percent; Rec.Percent)
                {
                    Visible = PourcentageVisible;
                    ApplicationArea = all;
                }
                field("Worked months"; Rec."Worked months")
                {
                    Enabled = true;
                    Visible = "Mois travaillésVisible";
                    ApplicationArea = all;
                }

                field(Absences; Rec.Absences)
                {
                    ApplicationArea = all;
                }
                field("Adjustment of absences"; Rec."Adjustment of absences")
                {
                    ApplicationArea = all;
                }
                field("Days off"; Rec."Days off")
                {
                    ApplicationArea = all;
                }

                field("Days off balacement"; Rec."Days off balacement")
                {
                    ApplicationArea = all;
                }
                field("Assiduity (Paid days)"; Rec."Assiduity (Paid days)")
                {
                    ApplicationArea = all;
                }
                field("Assiduity (Worked days)"; Rec."Assiduity (Worked days)")
                {
                    ApplicationArea = all;
                }
                field("Basis hours"; Rec."Basis hours")
                {
                    ApplicationArea = all;
                }
                field("Basis salary"; Rec."Basis salary")
                {
                    ApplicationArea = all;
                }
                field("Real basis salary"; Rec."Real basis salary")
                {
                    ApplicationArea = all;
                }
                field("Taxable indemnities"; Rec."Taxable indemnities")
                {
                    ApplicationArea = all;
                }
                field("Supp. hours"; Rec."Supp. hours")
                {
                    ApplicationArea = all;
                }
                field("Gross Salary"; Rec."Gross Salary")
                {
                    ApplicationArea = all;
                }
                field("Non Taxable Soc. Contrib."; Rec."Non Taxable Soc. Contrib.")
                {
                    ApplicationArea = all;
                }
                field("Taxable salary"; Rec."Taxable salary")
                {
                    ApplicationArea = all;
                }
                field("Deduction Family chief"; Rec."Deduction Family chief")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                    Visible = true;
                }
                field("Deduction Loaded child"; Rec."Deduction Loaded child")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Deduction Prof. expenses"; Rec."Deduction Prof. expenses")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }

                field("Taxe (Year)"; Rec."Taxe (Year)")
                {
                    ApplicationArea = all;
                }
                field("Total taxes rec."; Rec."Total taxes rec.")
                {
                    ApplicationArea = all;
                }
                field("Taxe (Month)"; Rec."Taxe (Month)")
                {
                    DecimalPlaces = 3 : 3;
                    Editable = false;
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Annual CSS Tax"; Rec."Annual CSS Tax")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Monthly CSS Tax"; Rec."Monthly CSS Tax")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("CSS Tax"; Rec."CSS Tax")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Total CSS Tax Recorded"; Rec."Total CSS Tax Recorded")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Non Taxable indemnities"; Rec."Non Taxable indemnities")
                {
                    ApplicationArea = all;
                }
                field("Taxable Soc. Contrib."; Rec."Taxable Soc. Contrib.")
                {
                    ApplicationArea = all;
                }
                field("Net salary"; Rec."Net salary")
                {
                    ApplicationArea = all;
                }
                field(Loans; Rec.Loans)
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(Advances; Rec.Advances)
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Net salary cashed"; Rec."Net salary cashed")
                {
                    DecimalPlaces = 3 : 3;
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        IF Rec.Month.AsInteger() > 11 THEN BEGIN
            NoteVisible := TRUE;
            PourcentageVisible := TRUE;
            "Mois travaillésVisible" := TRUE;
        END
        ELSE BEGIN
            PourcentageVisible := FALSE;
            "Mois travaillésVisible" := FALSE;
        END
    end;

    trigger OnInit()
    begin
        PourcentageVisible := TRUE;
        NoteVisible := TRUE;
    end;

    var
        NoteVisible: Boolean;
        PourcentageVisible: Boolean;
        "Mois travaillésVisible": Boolean;


}
