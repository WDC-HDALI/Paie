page 55050 "WDC Occ. Hours Recorded"
{
    CaptionML = ENU = 'Occasional Hours Recorded', FRA = 'Heures trav. enregistrées';
    DeleteAllowed = false;
    ApplicationArea = all;
    UsageCategory = History;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = 55009;
    SourceTableView = SORTING("Transaction No.", "Line No.", "Employee No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                Editable = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(SalaryName; Rec."First Name" + ' ' + Rec."Last Name")
                {
                    Caption = 'Nom salarié';
                    ApplicationArea = all;
                }
                field("Day Type"; Rec."Days Type")
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
                field("Payment No."; Rec."Payment No.")
                {
                    ApplicationArea = all;
                }
                field("Hours Number"; Rec."Hours Number")
                {
                    ApplicationArea = all;
                }
                field("Days Number"; Rec."Days Number")
                {
                    ApplicationArea = all;
                }
                field("Unit Tariff"; Rec."Unit Tariff")
                {
                    ApplicationArea = all;
                }
                field("Overtime Rate"; Rec."Overtime Rate")
                {
                    ApplicationArea = all;
                }
                field(Productivité; Rec.Productivité)
                {
                    ApplicationArea = all;
                }
                field("Line amount"; Rec."Line amount")
                {
                    ApplicationArea = all;
                }
            }
            // group(Group)
            // {
            //     field("Employee No.2"; Rec."Employee No.")
            //     {
            //         Editable = false;
            //         ApplicationArea = all;
            //     }
            //     field(SalaryNameGroupe; Rec."First Name" + ' ' + Rec."Last Name")
            //     {
            //         Caption = 'Nom salarié';
            //         Editable = false;
            //         ApplicationArea = all;
            //     }
            //     field("Payment Month 2"; Rec."Payment Month")
            //     {
            //         Editable = false;
            //         ApplicationArea = all;
            //     }
            //     field("Payment Year 2"; Rec."Payment Year")
            //     {
            //         Editable = false;
            //         ApplicationArea = all;
            //     }
            // }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Fonction&s")
            {
                CaptionML = ENU = 'Function&s', FRA = 'Fonction&s';

                action("Cancel post")
                {
                    CaptionML = ENU = 'Cancel post', FRA = 'Annuler validation';
                    Image = UnApply;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        HeuresSup: Record "WDC Occasional Hours";
                        Wind: Dialog;
                        Saved: Record "WDC Occasional Hours Recorded";
                        Nligne: Integer;
                        Hcode: Codeunit 55026;
                        conf: TextConst ENU = 'Are you sure to unvalidate the selected lines.',
                                        FRA = 'Êtes-vous sûr de vouloir annuler la validation des lignes sélectionnées.';
                    begin
                        HeuresSup.RESET;
                        HeuresSup.SETCURRENTKEY("Line No.");
                        IF HeuresSup.FINDLAST THEN
                            Nligne := HeuresSup."Line No." + 10000
                        ELSE
                            Nligne := 10000;
                        CurrPage.SETSELECTIONFILTER(Saved);
                        //Saved.SETFILTER("Payment No.",'=''''');
                        Wind.OPEN('De validation de Heures Supplémentaire : \' +
                                  ' Salariée  #1########################### \' +
                                  ' N° Ligne              #2############### \' +
                                  ' Date Heure Supplémentaire  #3########## ');
                        IF Saved.FINDSET THEN
                            IF CONFIRM(conf) THEN
                                REPEAT
                                    Wind.UPDATE(1, Saved."Employee No." + ' ' + Saved."Last Name");
                                    Wind.UPDATE(2, Nligne);
                                    Wind.UPDATE(3, Saved."Posting Date");
                                    Hcode.DevaliderHeuresTravail(Saved, Nligne);
                                    Nligne := Nligne + 10000;
                                UNTIL Saved.NEXT = 0;
                        Wind.CLOSE;
                    end;
                }
            }
        }
    }

}

