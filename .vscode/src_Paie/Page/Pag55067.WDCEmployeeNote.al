page 55067 "WDC Employee Note"
{
    PageType = List;
    CaptionML = ENU = 'Employees Notes', FRA = 'Notes Salariés';
    SourceTable = 5200;
    DeleteAllowed = true;
    InsertAllowed = true;
    SaveValues = true;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Active));

    layout
    {
        area(content)
        {
            group(Group)
            {
                field(TrimestreT; TrimestreT)
                {
                    CaptionML = ENU = 'Quarter', FRA = 'Trimestre  :';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Year; Year)
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Year', FRA = 'Année';
                    trigger OnValidate()
                    begin
                        yearOnAfterValidate;
                    end;
                }
            }
            repeater(General)
            {
                captionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    Editable = false;
                    NotBlank = true;
                    ApplicationArea = all;
                }
                field("First Name"; Rec."First Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Last Name"; Rec."Last Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = all;
                }
                field(Purcent; Rec.Purcent)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Presence Percent"; Rec."Presence Percent")
                {
                    ApplicationArea = all;
                }
                field("Quarterly Note"; Rec."Quarterly Note")
                {
                    ApplicationArea = all;
                }
                field("Quarterly 1 Note"; Rec."Quarterly 1 Note")
                {
                    ApplicationArea = all;
                }
                field("Quarterly 2 Note"; Rec."Quarterly 2 Note")
                {
                    ApplicationArea = all;
                }
                field("Quarterly 3 Note"; Rec."Quarterly 3 Note")
                {
                    ApplicationArea = all;
                }
                field("Quarterly 4 Note"; Rec."Quarterly 4 Note")
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
            group(Validation)
            {
                CaptionML = ENU = 'Posting', FRA = 'Validation';
                action(Post)
                {
                    CaptionML = ENU = 'Post', FRA = 'Valider';
                    Image = ValueLedger;
                    ShortCutKey = 'F9';
                    promoted = true;
                    promotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        lText001: TextConst ENU = 'Year must be mentioned!!!',
                                            FRA = 'Année doit être mentionnée!!!';
                    begin
                        IF Year = 0 THEN
                            ERROR(lText001);
                        Employee.RESET;
                        Employee.COPYFILTERS(Rec);
                        valid.ValiderNote(Employee, year, TrimestreT);
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        IF TrimestreT.AsInteger() <> 4 THEN
            TrimestreT := TrimestreT::"4th";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ERROR(TEXT01)
    end;

    var
        TrimestreT: Enum "WDC Quarter";
        year: Integer;
        valid: Codeunit 55027;
        Employee: Record Employee;
        TEXT01: TextConst ENU = 'You have reached the limit of lines',
                          FRA = 'Vous avez atteint la limite des lignes';




    local procedure yearOnAfterValidate()
    begin
        Rec.SETFILTER("Year Filter", '%1', year);
        CurrPage.UPDATE;
    end;
}

