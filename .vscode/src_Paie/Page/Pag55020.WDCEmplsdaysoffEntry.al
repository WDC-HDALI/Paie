page 55020 "WDC Empl.'s days off Entry"
{
    CaptionML = ENU = 'Employee''s days off Entry', FRA = 'Historique des absences';
    Editable = false;
    PageType = List;
    SourceTable = "WDC Employee's days off Entry";
    SourceTableView = SORTING("Entry No.");
    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Payment No."; Rec."Payment No.")
                {
                    ApplicationArea = all;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = all;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("EmployeeName"; SalarieNom)
                {
                    ApplicationArea = all;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = all;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = all;
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Line amount"; Rec."Line amount")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = all;
                }
                field("Impute on days off"; Rec."Impute on days off")
                {
                    ApplicationArea = all;
                }
                field("Posting month"; Rec."Posting month")
                {
                    ApplicationArea = all;
                }
                field("Number of Recovery Hours"; Rec."Number of Recovery Hours")
                {
                    ApplicationArea = all;
                }
                field("Posting year"; Rec."Posting year")
                {
                    ApplicationArea = all;
                }
                field("Line type"; Rec."Line type")
                {
                    ApplicationArea = all;
                }
                field("Quantity (Days)"; Rec."Quantity (Days)")
                {
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
                action(Unvalidate)
                {
                    CaptionML = ENU = 'Unvalidate', FRA = 'Dévalider';
                    Image = UnApply;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        HumanRessource: Codeunit "WDC Absences Management";
                        Saved: Record "WDC Employee's days off Entry";
                        conf: TextConst ENU = 'Are you sure you want to unvalidate the selected lines?', FRA = 'Êtes-vous sûr de vouloir dévalider les lignes sélectionnées?';
                    begin
                        CurrPage.SETSELECTIONFILTER(Saved);
                        Saved.SETFILTER("To Account", '%1', FALSE);
                        IF Saved.FINDSET THEN
                            IF CONFIRM(conf) THEN
                                REPEAT
                                    HumanRessource.UnValidateEmployeeAbsence(Saved);
                                UNTIL Saved.NEXT = 0;
                    end;
                }
                action(Verify)
                {
                    CaptionML = ENU = 'Verify', FRA = 'Vérifier';
                    Image = Check;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        RecPaie: Record "WDC Posted Salary Header";
                        RecAbs: Record "WDC Employee's days off Entry";
                    begin
                        //55024
                        RecAbs.RESET;
                        IF RecAbs.FINDSET THEN BEGIN
                            REPEAT
                                RecPaie.RESET;
                                RecPaie.SETRANGE(Month, RecAbs."Posting month");
                                RecPaie.SETRANGE(Year, RecAbs."Posting year");
                                IF RecPaie.FINDSET THEN BEGIN
                                    RecAbs."Payment No." := RecPaie."No.";
                                    RecAbs.MODIFY;
                                END;
                            UNTIL RecAbs.NEXT = 0;
                        END;
                    end;
                }
            }
            group("Posted Absence")
            {
                CaptionML = ENU = 'Posted Absence', FRA = 'Absence enregistrée';
                action("Co&mments")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Co&mments', FRA = 'Commentaires';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = CONST("Employee Absence"),
                                  "Table Line No." = FIELD("Entry No."),
                                  Code = FIELD("Employee No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        RecGEmploy.RESET;
        IF RecGEmploy.GET(Rec."Employee No.") THEN
            SalarieNom := RecGEmploy."First Name" + ' ' + RecGEmploy."Last Name";
    end;

    trigger OnOpenPage()
    begin
        IF RecupTmp = TRUE THEN
            Rec.SETFILTER(rec."Number of Recovery Hours", '<>0');
    end;

    var
        RecupTmp: Boolean;
        SalarieNom: Code[100];
        RecGEmploy: Record Employee;


}

