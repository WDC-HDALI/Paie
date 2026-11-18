pageextension 55004 "WDC Absence Registration" extends "Absence Registration"
{
    layout
    {
        modify("Employee No.")
        {
            StyleExpr = FieldStyle;
        }
        modify("Cause of Absence Code")
        {
            StyleExpr = FieldStyle;
        }

        addafter(Description)
        {
            field("Line type"; Rec."Line type")
            {
                ApplicationArea = all;
                StyleExpr = FieldStyle;
            }
        }
        addbefore(Control1)
        {
            group(Dates)
            {
                CaptionML = ENU = 'Dates', FRA = 'Dates';

                field(date2; Date2)
                {
                    CaptionML = ENU = 'Date', FRA = 'Date';
                    ApplicationArea = all;
                }
            }

        }
        addafter("Employee No.")
        {
            field(name; Rec.Name)
            {
                ApplicationArea = all;
            }
        }
        addafter("To Date")
        {
            field("Posting month"; Rec."Posting month")
            {
                ApplicationArea = all;
            }
            field("Posting year"; Rec."Posting year")
            {
                ApplicationArea = all;
            }
        }

        addafter(quantity)
        {
            field("Holiday Balance"; Rec."Holiday Balance")
            {
                ApplicationArea = all;
                style = Strong;
                StyleExpr = true;
            }
        }
    }
    actions
    {
        addlast("A&bsence")
        {
            action("Absences Insertion")
            {
                CaptionML = ENU = 'Absences Insertion', FRA = 'Insertion Absence';
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                var
                    Employee: Record Employee;
                    EmployeeAbsence: Record "Employee Absence";
                    EntryNo: Integer;
                    EmployeeAbsence2: Record "Employee Absence";
                    Err001: TextConst ENU = 'Please enter the start date',
                                      FRA = 'Veuillez saisir la date début';
                begin
                    //<<WDC01
                    IF (Date2 <> 0D) THEN BEGIN
                        CLEAR(EntryNo);
                        Employee.RESET;
                        Employee.SETRANGE(Status, Employee.Status::Active);
                        IF Employee.FINDSET THEN BEGIN
                            EmployeeAbsence2.RESET;
                            IF EmployeeAbsence2.FINDLAST THEN
                                EntryNo := EmployeeAbsence2."Entry No." + 1
                            ELSE
                                EntryNo := 1;
                            REPEAT
                                EmployeeAbsence.INIT;
                                EmployeeAbsence."Entry No." := EntryNo;
                                EntryNo += 1;
                                EmployeeAbsence.VALIDATE("Employee No.", Employee."No.");
                                EmployeeAbsence.VALIDATE("From Date", Date2);
                                EmployeeAbsence.INSERT;
                            UNTIL Employee.NEXT = 0
                        END;
                    END ELSE
                        ERROR(Err001);
                    //>>WDC01
                end;
            }
            action("Test Print")
            {
                CaptionML = ENU = 'Test Print', FRA = 'Impression test';
                Image = PrintChecklistReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    REPORT.RUN(5205, TRUE, TRUE, Rec); //HD1703
                end;
            }
            action(Post)
            {
                CaptionML = ENU = 'Post', FRA = 'Valider';
                Image = Post;
                ShortCutKey = 'F11';
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                Var
                    lText001: TextConst ENU = 'Are you sure you want to post the absence?',
                                        FRA = 'Voulez-vous valider l''absence ?';
                begin
                    If Not Confirm(lText001) then
                        EXIT;
                    EmployeeAbsence.RESET;
                    EmployeeAbsence.COPYFILTERS(Rec);
                    IF EmployeeAbsence.FINDFIRST THEN BEGIN
                        HumanRessource.ValidAbsence(EmployeeAbsence);
                    END;
                end;
            }
            action("Import congés")
            {
                CaptionML = ENU = 'Import Holidays', FRA = 'Import congés';
                Image = Answers;
                RunObject = XMLport 55035;
                ApplicationArea = all;
            }
            action("Import absences")
            {
                CaptionML = ENU = 'Import Absences', FRA = 'Import absences';
                Image = AbsenceCalendar;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = XMLport 55046;
                ApplicationArea = all;
            }

        }
    }


    trigger OnAfterGetRecord()
    begin
        SetStyle();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        EXIT(Employee.GET(Rec."Employee No."));
    end;

    var
        Employee: Record Employee;
        EmployeeAbsence: Record "Employee Absence";
        HumanRessource: Codeunit 55024;
        FieldStyle: Text[50];
        RecGSalarie: Record Employee;
        RecGAbsences: Record "Employee Absence";
        Window: Dialog;
        Date2: Date;

    procedure SetStyle()
    begin
        CASE Rec."Cause of Absence Code" OF
            'CONGE':
                FieldStyle := 'Attention';
            'ABS':
                FieldStyle := 'Favorable';
            'CP':
                FieldStyle := 'StandardAccent';
            'AUT':
                FieldStyle := 'AttentionAccent';
            'MAT':
                FieldStyle := 'Ambiguous';
            'MAP':
                FieldStyle := 'Strong';
        END;
    end;
}

