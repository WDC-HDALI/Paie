page 55039 "WDC Calculation Lines"
{
    CaptionML = ENU = 'Calculation lines', FRA = 'Lignes de calcul';
    Editable = true;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "WDC Salary Lines";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                Editable = true;
                field(Employee; Rec."Employee No.")
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    StyleExpr = FieldStyle;
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Cumulative Taxable Salary"; Rec."Cumulative Taxable Salary")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Recorded Pay Days"; Rec."Recorded Pay Days")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Taxable Average Period"; Rec."Taxable Average Period")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Annual Taxable"; Rec."Annual Taxable")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Real taxable (Year)"; Rec."Real taxable (Year)")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Indem. Not Tax. Not Contrib."; Rec."Indem. Not Tax. Not Contrib.")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Days Period Number"; Rec."Days Period Number")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Paied days"; Rec."Paied days")
                {
                    ApplicationArea = all;
                }
                field("Public Holidays"; Rec."Public Holidays")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Overtime Hours"; Rec."Overtime Hours")
                {
                    ApplicationArea = all;
                }
                field("Supp. hours"; Rec."Supp. hours")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Days Number"; Rec."Days Number")
                {
                    Visible = NbrJoursVisible;
                    ApplicationArea = All;
                }
                field("Worked hours"; Rec."Worked hours")
                {
                    Caption = 'Worked hours';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Monthly Leave Entitlement"; Rec."Monthly Leave Entitlement")
                {
                    Editable = false;
                    Enabled = true;
                    ApplicationArea = All;
                }

                field("Basis hours"; Rec."Basis hours")
                {
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field(Purcent; Rec.Purcent)
                {
                    Caption = 'Pourcentage / Coefficient';
                    Editable = false;
                    Visible = PourcentageVisible;
                    ApplicationArea = All;
                }
                field("Worked Months"; Rec."Worked Months")
                {
                    Editable = false;
                    Visible = MoisTravaillésVisible;
                    ApplicationArea = All;
                }

                field("Real taxable"; Rec."Real taxable")
                {
                    ApplicationArea = all;
                }
                field("Taxe (Year)"; Rec."Taxe (Year)")
                {
                    ApplicationArea = all;
                }
                field("Annual CSS Tax"; Rec."Annual CSS Tax")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Monthly CSS Tax"; Rec."Monthly CSS Tax")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("CSS Tax"; Rec."CSS Tax")
                {
                    Editable = true;
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        //>>WDC Recalcul de la paie
                        Rec."Net salary" := Rec."Taxable salary" - Rec."Taxe (Month)" - Rec."CSS Tax" - Rec.Bus - Rec.Assurance - Rec.Shems - Rec.Phone - Rec.DSAM;
                        Rec."Net salary cashed" := Rec."Taxable salary" - Rec."Taxe (Month)" - Rec."CSS Tax" - Rec.Bus - Rec.Assurance - Rec.Shems - Rec.Phone - Rec.DSAM - Rec.Advances - Rec.Loans;
                        CurrPage.SAVERECORD;
                        //<<WDC Recalcul de la paie
                    end;
                }
                field("Total CSS Tax Recorded"; Rec."Total CSS Tax Recorded")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }

                field("Report en -"; Rec."Report en -")
                {
                    DecimalPlaces = 3 : 3;
                    Editable = false;
                    ApplicationArea = All;
                }

                field(Absences; Rec.Absences)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Holiday; Rec.Holiday)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee type"; Rec."Employee type")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Assiduity (Paid days)"; Rec."Assiduity (Paid days)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Assiduity (Worked days)"; Rec."Assiduity (Worked days)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Basis salary"; Rec."Basis salary")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Real basis salary"; Rec."Real basis salary")
                {
                    ApplicationArea = all;
                }
                field("Taxable indemnities"; Rec."Taxable indemnities")
                {
                    DecimalPlaces = 3 : 3;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Gross Salary"; ROUND(Rec."Gross Salary", 0.0001))
                {
                    Caption = 'Salaire Brut';
                    DecimalPlaces = 3 : 3;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Gross Salary (Without AV)"; Rec."Gross Salary (Without AV)")
                {
                    ApplicationArea = all;
                }
                field("Taxable salary"; Rec."Taxable salary")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = All;
                }
                field("Deduction Family chief"; Rec."Deduction Family chief")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Deduction Loaded child"; Rec."Deduction Loaded child")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Deduction Prof. expenses"; Rec."Deduction Prof. expenses")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }

                field("Non Taxable Soc. Contrib."; Rec."Non Taxable Soc. Contrib.")
                {
                    DecimalPlaces = 3 : 3;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total taxes rec."; Rec."Total taxes rec.")
                {
                    ApplicationArea = all;
                }
                field("Real taxable PR"; Rec."Real taxable PR")
                {
                    ApplicationArea = All;
                }
                field("Taxe (Month)"; Rec."Taxe (Month)")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 3 : 3;
                    Editable = true;
                    Style = AttentionAccent;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        //>>WDC Recalcul de la paie
                        Rec."Net salary" := Rec."Taxable salary" - Rec."Taxe (Month)" - Rec."CSS Tax" - Rec.Bus - Rec.Assurance - Rec.Shems - Rec.Phone - Rec.DSAM;
                        Rec."Net salary cashed" := Rec."Taxable salary" - Rec."Taxe (Month)" - Rec."CSS Tax" - Rec.Bus - Rec.Assurance - Rec.Shems - Rec.Phone - Rec.DSAM - Rec.Advances - Rec.Loans;
                        CurrPage.SAVERECORD;
                        //<<WDC Recalcul de la paie
                    end;
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
                    ApplicationArea = All;
                    DecimalPlaces = 3 : 3;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        //>>WDC Recalcul de la paie
                        Rec."Net salary" := Rec."Taxable salary" - Rec."Taxe (Month)" - Rec."CSS Tax" - Rec.Bus - Rec.Assurance - Rec.Shems - Rec.Phone - Rec.DSAM;
                        Rec."Net salary cashed" := Rec."Taxable salary" - Rec."Taxe (Month)" - Rec."CSS Tax" - Rec.Bus - Rec.Assurance - Rec.Shems - Rec.Phone - Rec.DSAM - Rec.Advances - Rec.Loans;
                        CurrPage.SAVERECORD;

                        //<<WDC Recalcul de la paie
                    end;
                }
                field(Loans; Rec.Loans)
                {
                    ApplicationArea = All;
                    Editable = true;
                    Style = Attention;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        //>>WDC Recalcul de la paie
                        Rec."Net salary" := Rec."Taxable salary" - Rec."Taxe (Month)" - Rec."CSS Tax" - Rec.Bus - Rec.Assurance - Rec.Shems - Rec.Phone - Rec.DSAM;
                        Rec."Net salary cashed" := Rec."Taxable salary" - Rec."Taxe (Month)" - Rec."CSS Tax" - Rec.Bus - Rec.Assurance - Rec.Shems - Rec.Phone - Rec.DSAM - Rec.Advances - Rec.Loans;
                        CurrPage.SAVERECORD;

                        //<<WDC Recalcul de la paie
                    end;
                }
                field(Advances; Rec.Advances)
                {
                    ApplicationArea = All;
                    Editable = true;
                    Style = Attention;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        //>>WDC Recalcul de la paie
                        Rec."Net salary" := Rec."Taxable salary" - Rec."Taxe (Month)" - Rec."CSS Tax" - Rec.Bus - Rec.Assurance - Rec.Shems - Rec.Phone - Rec.DSAM;
                        Rec."Net salary cashed" := Rec."Taxable salary" - Rec."Taxe (Month)" - Rec."CSS Tax" - Rec.Bus - Rec.Assurance - Rec.Shems - Rec.Phone - Rec.DSAM - Rec.Advances - Rec.Loans;
                        CurrPage.SAVERECORD;

                        //<<WDC Recalcul de la paie
                    end;
                }
                field("Net salary cashed"; Rec."Net salary cashed")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 3 : 3;
                    Editable = true;
                    Style = Attention;
                    StyleExpr = TRUE;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Update Bonus")
            {
                CaptionML = ENU = 'Update Bonus', FRA = 'Mise à jour Prime';
                action("Update IRPP Bonus")
                {
                    CaptionML = ENU = 'Update IRPP Bonus', FRA = 'Mise à jour IRPP Prime';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        lText001: TextConst ENU = 'Update success',
                                            FRA = 'Mise à jour terminé!';
                    begin
                        CLEAR(SalaryLines);
                        SalaryLines.SETRANGE("No.", Rec."No.");
                        IF SalaryLines.FINDFIRST THEN
                            REPEAT
                                IF SalaryLines."Non Taxable Soc. Contrib." = 0 THEN BEGIN
                                    SalaryLines.VALIDATE("Taxe (Month)", 0);
                                    SalaryLines.VALIDATE("CSS Tax", 0);
                                    SalaryLines."Net salary" := SalaryLines."Taxable salary" - SalaryLines."Taxe (Month)" - SalaryLines."CSS Tax" - SalaryLines.Bus - SalaryLines.Assurance - SalaryLines.Shems - SalaryLines.Phone - SalaryLines.DSAM;
                                    SalaryLines."Net salary cashed" := SalaryLines."Taxable salary" - SalaryLines."Taxe (Month)" - SalaryLines."CSS Tax" - SalaryLines.Bus - SalaryLines.Assurance - SalaryLines.Shems - SalaryLines.Phone - SalaryLines.DSAM - SalaryLines.Advances - SalaryLines.Loans;
                                    SalaryLines.MODIFY;
                                END
                                ELSE BEGIN
                                    SalaryLines.VALIDATE("Taxe (Month)", SalaryLines."Taxe (Month)");
                                    SalaryLines.VALIDATE("CSS Tax", 0);
                                    SalaryLines."Net salary" := SalaryLines."Taxable salary" - SalaryLines."Taxe (Month)" - SalaryLines."CSS Tax" - SalaryLines.Bus - SalaryLines.Assurance - SalaryLines.Shems - SalaryLines.Phone - SalaryLines.DSAM;
                                    SalaryLines."Net salary cashed" := SalaryLines."Taxable salary" - SalaryLines."Taxe (Month)" - SalaryLines."CSS Tax" - SalaryLines.Bus - SalaryLines.Assurance - SalaryLines.Shems - SalaryLines.Phone - SalaryLines.DSAM - SalaryLines.Advances - SalaryLines.Loans;
                                    SalaryLines.MODIFY;
                                END;
                            UNTIL SalaryLines.NEXT = 0;
                        MESSAGE(lText001);
                    end;
                }

                action("Update IRPP Bonus CNSS 0")
                {
                    CaptionML = ENU = 'Update IRPP Bonus CNSS 0', FRA = 'Mise à jour IRPP prime CNSS 0';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        SalaryLines: Record "WDC Salary Lines";
                        lText001: TextConst ENU = 'Update success',
                                            FRA = 'Mise à jour terminé!';
                    begin
                        CLEAR(SalaryLines);
                        SalaryLines.SETRANGE("No.", Rec."No.");
                        IF SalaryLines.FINDFIRST THEN
                            REPEAT
                                SalaryLines.VALIDATE("Non Taxable Soc. Contrib.", 0);
                                SalaryLines.VALIDATE(SalaryLines."Taxable salary", SalaryLines."Gross Salary");
                                SalaryLines.VALIDATE("Taxe (Month)", SalaryLines."Taxe (Month)");
                                SalaryLines.VALIDATE("CSS Tax", 0);
                                SalaryLines."Net salary" := SalaryLines."Taxable salary" - SalaryLines."Taxe (Month)" - SalaryLines."CSS Tax" - SalaryLines.Bus - SalaryLines.Assurance - SalaryLines.Shems - SalaryLines.Phone - SalaryLines.DSAM;
                                SalaryLines."Net salary cashed" := SalaryLines."Taxable salary" - SalaryLines."Taxe (Month)" - SalaryLines."CSS Tax" - SalaryLines.Bus - SalaryLines.Assurance - SalaryLines.Shems - SalaryLines.Phone - SalaryLines.DSAM - SalaryLines.Advances - SalaryLines.Loans;
                                SalaryLines.MODIFY;
                            UNTIL SalaryLines.NEXT = 0;
                        MESSAGE(lText001);
                    end;
                }

            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetEmployeeNo;
    end;

    trigger OnAfterGetRecord()
    begin
        //>>
        IF Rec.Month.AsInteger() > 11 THEN BEGIN
            NoteVisible := TRUE;
            PourcentageVisible := TRUE;
            MoisTravaillésVisible := TRUE;
            IF Rec.Month.AsInteger() = 15 THEN
                NbrJoursVisible := TRUE
            ELSE
                NbrJoursVisible := FALSE;
        END ELSE BEGIN
            NoteVisible := FALSE;
            PourcentageVisible := FALSE;
            MoisTravaillésVisible := FALSE;
            IF Rec.Month.AsInteger() = 15 THEN
                NbrJoursVisible := FALSE;
        END;
        SetStyle;
        //<<
        //<<WDC
        OldTaxe := Rec."Taxe (Month)";
        OldNetSalary := Rec."Net salary";
        OldNetCashed := Rec."Net salary cashed";
        //>>WDC
    end;

    var
        NoteVisible: Boolean;
        PourcentageVisible: Boolean;
        NbrJoursVisible: Boolean;
        "MoisTravaillésVisible": Boolean;
        FieldStyle: Text[50];
        OldTaxe: Decimal;
        OldNetSalary: Decimal;
        OldNetCashed: Decimal;
        SalaryLines: Record "WDC Salary Lines";

    procedure ChangerModePaiement(pPaymentMethodMode: code[20])
    var
        compteclt: Record 55006;
        clt: Record 5200;
        T1: Record 55023;
    begin
        T1.RESET;
        T1.SETFILTER("No.", Rec."No.");
        T1.SETFILTER("Employee No.", Rec."Employee No.");
        CurrPage.SETSELECTIONFILTER(T1);
        IF T1.FINDSET THEN
            REPEAT
                CLEAR(clt);
                clt.GET(T1."Employee No.");
                CASE pPaymentMethodMode OF
                    'VIREMENT':
                        BEGIN
                            CLEAR(compteclt);
                            IF compteclt.GET(T1."Employee No.", clt."Default Bank Account Code") THEN BEGIN
                                T1."Bank Account Code" := clt."Default Bank Account Code";
                                T1."Account No." := compteclt."Bank Account No.";
                                T1."Payment Method Code" := pPaymentMethodMode;
                                T1.MODIFY;
                            END;
                        END;
                    'ESPECE':
                        BEGIN
                            T1."Bank Account Code" := '';
                            T1."Account No." := '';
                            T1."Payment Method Code" := pPaymentMethodMode;
                            T1.MODIFY;
                        END;
                END;
                T1."Payment Method Code" := pPaymentMethodMode;
                T1.MODIFY;
            UNTIL T1.NEXT = 0;
    end;


    procedure SetStyle()
    begin
        IF Rec."Net salary cashed" < 0 THEN
            FieldStyle := 'Unfavorable'
        ELSE
            FieldStyle := 'Standard';
    end;


    procedure GetEmployeeNo() EmployeeNo: Code[20]
    begin
        EmployeeNo := Rec."Employee No.";
    end;
}

