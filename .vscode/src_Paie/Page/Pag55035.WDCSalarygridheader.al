page 55035 "WDC Salary Grid Header"
{
    CaptionML = ENU = 'Salary grid', FRA = 'Grille de salaires';
    PageType = Card;
    SourceTable = "WDC Salary grid header";
    ModifyAllowed = true;
    layout
    {
        area(content)
        {
            group("General")
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                    trigger OnAssistEdit()
                    begin
                        // IF AssistEdit(xRec) THEN
                        CurrPage.UPDATE;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = all;
                }
                field("expiry date"; Rec."expiry date")
                {
                    ApplicationArea = all;
                }
            }
            part("Line grid"; "WDC Grid Line")
            {
                ApplicationArea = all;
                Editable = true;
                SubPageLink = Code = FIELD(Code);
            }
            group("Additional Parameters")
            {
                CaptionML = ENU = 'Additional Parameters', FRA = 'Paramétres supp.';
                field("Av. auto. Cla  sse"; Rec."Av. auto. Classe")
                {
                    ApplicationArea = all;
                }
                field("Av. auto. Echelon"; Rec."Av. auto. Echelon")
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
            group("Fonctions")
            {
                CaptionML = ENU = 'Fonctions', FRA = 'Fonctions';
                action("Import Salary grid")
                {
                    CaptionML = ENU = 'Import Salary grid', FRA = 'Import grille salaire';
                    ApplicationArea = all;
                    Image = ImportExcel;
                    RunObject = XMLport "WDC Import Salary Grid";
                }
                action("Update Basis Salary")
                {
                    CaptionML = ENU = 'Update Basis Salary', FRA = 'Mise à jour salaire de base';
                    Image = RefreshText;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        Employee: Record Employee;
                        Linegrid: Record "WDC Grid Line";
                        EmploymentContract: Record "Employment Contract";
                        lText001: TextConst ENU = 'Update success',
                                            FRA = 'Mise à jour terminé!';
                    begin
                        Employee.RESET;
                        Employee.SETRANGE(Status, Employee.Status::Active);
                        Employee.SETRANGE("Hors Grille", FALSE);
                        IF Employee.FINDSET THEN
                            REPEAT
                                EmploymentContract.GET(Employee."Emplymt. Contract Code");
                                Linegrid.SETFILTER(Linegrid.Code, '%1', EmploymentContract."Salary grid");
                                Linegrid.SETFILTER(College, '%1', Employee.College);
                                Linegrid.SETFILTER(scale, '%1', Employee.scale);
                                Linegrid.SETRANGE(Echelon, Employee.Echelon);
                                IF Linegrid.FINDSET THEN
                                    Employee."Basis salary" := Linegrid."Base Salary"
                                ELSE
                                    Employee."Basis salary" := 0;
                                Employee.MODIFY;
                            UNTIL Employee.NEXT = 0;
                        MESSAGE(lText001);
                    end;
                }
                action("Apply New Values")
                {
                    CaptionML = ENU = 'Apply New Values', FRA = 'Appliquer les nouvelles valeurs';
                    Image = ConditionalBreakpoint;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        Linegrid: Record "WDC Grid Line";
                        Window: Dialog;
                        dialogWindow: TextConst FRA = 'Application nouveau grille .....',
                                                ENU = 'Application new grid .....';
                        I: Integer;
                    begin
                        Linegrid.RESET;
                        Linegrid.SETRANGE(Code, Rec.Code);
                        IF Linegrid.FINDSET THEN BEGIN
                            Window.OPEN(dialogWindow
                                    + '\#######################################1#'
                                    + '\#######################################2#'
                                    + '\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3@');
                            REPEAT
                                I += 1;
                                Linegrid."Base Salary" := Linegrid."New Basic Salary";
                                Linegrid.MODIFY;
                                Window.UPDATE(1, FORMAT(Linegrid.Scale) + '  ' + FORMAT(Linegrid.Echelon));
                                Window.UPDATE(2, Linegrid."Base Salary");
                                Window.UPDATE(3, ROUND((I / Linegrid.COUNT) * 10000, 1));
                            UNTIL Linegrid.NEXT = 0;
                        END;
                    end;
                }
            }
        }
    }
}

