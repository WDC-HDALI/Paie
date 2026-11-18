page 55063 "WDC Occasional Work Hours"
{
    CaptionML = ENU = 'Occasional Work Hours', FRA = 'Heures travail occasionnelles';
    PageType = List;
    ApplicationArea = all;
    UsageCategory = History;
    SourceTable = 55008;
    SourceTableView = SORTING("Employee No.", "Line No.", "Department Code", "Folder Code")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            group(Dates)
            {
                CaptionML = ENU = 'Dates', FRA = 'Dates';
                field("Posting Date_g"; Date2)
                {
                    CaptionML = ENU = 'Calcul Date', FRA = 'Date calcul';
                    ApplicationArea = all;
                }
            }
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(FullName; Rec."First Name" + ' ' + Rec."Last Name")
                {
                    CaptionML = ENU = 'Full Name', FRA = 'Nom salarié';
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    ApplicationArea = all;
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    ApplicationArea = all;
                }
                field("Hours Number"; Rec."Hours Number")
                {
                    ApplicationArea = all;
                }
                field("Payment Month"; Rec."Payment Month")
                {
                    ApplicationArea = all;
                }
                field("Payment Year"; Rec."Payment Year")
                {
                    ApplicationArea = all;
                }
                field("Day Type"; Rec."Day Type")
                {
                    ApplicationArea = all;
                }
                field("Days Number"; Rec."Days Number")
                {
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Overtime Days"; Rec."Overtime Days")
                {
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }

                field("Pulic Holiday Days"; Rec."Pulic Holiday Days")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Pulic Holiday Amount"; Rec."Pulic Holiday Amount")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }

                field("P-Encouragement"; Rec."P-Encouragement")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("P-Bonus"; Rec."P-Bonus")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Team Bonus"; Rec."Team Bonus")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Exceptional Bonus"; Rec."Exceptional Bonus")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Competence Bonus"; Rec."Competence Bonus")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Overtime Houres Pay"; Rec."Overtime Houres Pay")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Mission Pay"; Rec."Mission Pay")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Assignment Pay"; Rec."Assignment Pay")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Position Pay"; Rec."Position Pay")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(Rappel; Rec."back pay")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Productivity Bonus"; Rec."Productivity Bonus")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Quality Coordination Bonus"; Rec."Quality Coordination Bonus")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("13th Month Pay"; Rec."13th Month Pay")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Quarterly Bonus"; Rec."Quarterly Bonus")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("End of Contract Balance Amount"; Rec."End of Contract Balance Amount")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Gratification Aid"; Rec."Gratification Aid")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(Gratification; Rec.Gratification)
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Severance Pay Indemnity"; Rec."Severance Pay Indemnity")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Objective Bonus"; Rec."Objective Bonus")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Seniority Bonus"; Rec."Seniority Bonus")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Retirement Bonus"; Rec."Retirement Bonus")
                {
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Other Back Pay"; Rec."Other Back Pay")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }


            }
            group(Group)
            {
                Editable = true;
                field(gFullName; Rec."First Name" + ' ' + rec."Last Name")
                {
                    CaptionML = ENU = 'Full Name', FRA = 'Nom salarié';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Line amount"; Rec."Line amount")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Overtime; Employee.Overtime)
                {
                    CaptionML = ENU = 'Overtime', FRA = 'Heures sup.';
                    Editable = false;
                    ApplicationArea = all;
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
                CaptionML = ENU = 'Fonction&s', FRA = 'Fonctions';
                action(Post)
                {
                    CaptionML = ENU = 'Post', FRA = 'Valider';
                    Image = Post;
                    ShortCutKey = 'F9';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        GRH: Codeunit 55026;
                        Window: Dialog;
                        lText001: TextConst ENU = 'Error: The form is empty. Unable to proceed.',
                                            FRA = 'Erreur :\Le formulaire est vide.\Impossible de poursuivre.';
                        lText002: TextConst ENU = 'Do you want to post?',
                                            FRA = 'Voulez-vous valider?';
                    begin
                        if Not Confirm(lText002) then
                            exit;
                        IF Rec.FINDFIRST THEN BEGIN
                            Window.OPEN('Validation des lignes d''heures du travail en cours :\' +
                                         '  N° ligne    : #######1\' +
                                         '  N° salarié  : #######2\');
                            Rec.LOCKTABLE;
                            REPEAT

                                Window.UPDATE(1, Rec."Line No.");
                                Window.UPDATE(2, Rec."Employee No.");
                                GRH.PostWorkDays(Rec);
                            UNTIL Rec.NEXT = 0;
                            Window.CLOSE;
                        END ELSE
                            ERROR(lText001);
                    end;
                }

                action("Import TimeSheet")
                {
                    CaptionML = ENU = 'Import TimeSheet', FRA = 'Import Pointage';
                    Image = ImportExcel;
                    RunObject = XMLport 55036;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                }
                action("Import Jour supp")
                {
                    CaptionML = ENU = 'Import Overtime Hours', FRA = 'Import Heures Supp';
                    Image = Restore;
                    RunObject = XMLport 55059;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                }
                action("Prepare all employees")
                {
                    CaptionML = ENU = 'Prepare all employees', FRA = 'Préparer toutes les salariés';
                    Image = Import;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        Employee: Record Employee;
                        Heuresoccasionnelles: Record "WDC Occasional Hours";
                        Err001: TextConst ENU = 'Please fill the date', FRA = 'Veuillez saisir la date';
                        lText001: TextConst ENU = 'Do you want to prepare the time sheets for all employees?',
                                            FRA = 'Voulez-vous préparer le pointages de tous les salariés?';
                    begin
                        //<<WDC01
                        If Not Confirm(lText001) then
                            exit;
                        IF (Date2 <> 0D) THEN BEGIN
                            Employee.RESET;
                            Employee.SETRANGE(Status, Employee.Status::Active);
                            IF Employee.FINDSET THEN
                                REPEAT
                                    Heuresoccasionnelles.INIT;
                                    Heuresoccasionnelles.VALIDATE("Employee No.", Employee."No.");
                                    Heuresoccasionnelles.VALIDATE("Posting Date", Date2);
                                    Heuresoccasionnelles.INSERT;
                                UNTIL Employee.NEXT = 0;
                        END ELSE
                            ERROR(Err001);
                        //>>WDC01
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Employee.GET(Rec."Employee No.") THEN
            Employee.CALCFIELDS(Overtime);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.VALIDATE("Posting Date", WorkDate());
    end;

    var
        Employee: Record Employee;
        Date2: Date;
}

