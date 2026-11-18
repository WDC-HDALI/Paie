pageextension 55000 "WDC Employee Card" extends "Employee Card"
{
    layout
    {
        moveafter("No."; "First Name")
        moveafter("First Name"; "Last Name")
        modify("Middle Name")
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Visible = false;
        }
        modify("Marital Status")
        {
            Visible = false;
        }
        modify("Employee Posting Group")
        {
            Visible = false;
        }
        addafter("Last Name")
        {

            field("CIN No."; Rec."CIN No.")
            {
                ApplicationArea = all;
            }
            field("CIN Issued on"; Rec."CIN Issued on")
            {
                ApplicationArea = all;
            }
            field("Qualification Code"; Rec."Qualification Code")
            {
                ApplicationArea = all;
            }

            field(Title; Rec.Title)
            {
                Style = Strong;
                StyleExpr = TRUE;
                ApplicationArea = all;
            }

            field("Education Level"; Rec."Education Level")
            {
                ApplicationArea = all;
            }
            field(Degree; Rec.Degree)
            {
                ApplicationArea = all;
            }
        }

        addafter(Status)
        {
            field("CAVIS End Year"; Rec."CAVIS End Year")
            {
                ApplicationArea = all;
            }
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = all;
            }
            field(Class; Rec.Class)
            {
                ApplicationArea = all;
            }
            field(Retirement; Rec.Retirement)
            {
                ApplicationArea = all;
            }

            field("Working Relationship"; Rec."Working Relationship")
            {
                Style = Unfavorable;
                StyleExpr = TRUE;
                ApplicationArea = all;
            }
            field("Employee type"; Rec."Employee type")
            {
                Style = Unfavorable;
                StyleExpr = TRUE;
                ApplicationArea = all;
            }
            field("Hire Date"; Rec."Hire Date")
            {
                Style = Attention;
                StyleExpr = TRUE;
                ApplicationArea = all;
            }
        }
        addbefore("Statistics Group Code")
        {
            field("Empl. Posting Group"; Rec."Empl. Posting Group")
            {
                ApplicationArea = all;
            }
        }
        addafter("Emplymt. Contract Code")
        {
            field("Employee Contract Type"; Rec."Employee Contract Type")
            {
                ApplicationArea = all;
            }
            field("Contract Start Date"; Rec."Contract Start Date")
            {
                ApplicationArea = all;
            }
            field("Contract Number"; Rec."Contract Number")
            {
                ApplicationArea = all;
            }

            field("Horaire Salarie"; Rec."Horaire Salarie")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Employee Posting Group")
        {
            field("Brut prime"; Rec."Brut prime")
            {
                Style = StrongAccent;
                StyleExpr = TRUE;
                ApplicationArea = all;
            }
            field("Basis salary"; Rec."Basis salary")
            {
                Style = Unfavorable;
                StyleExpr = TRUE;
                ApplicationArea = all;
            }
            field(College; Rec.College)
            {
                Caption = 'Catégorie';
                ApplicationArea = all;
            }
            field(Scale; Rec.Scale)
            {
                ApplicationArea = all;
            }
            field(Echelon; Rec.Echelon)
            {
                ApplicationArea = all;
            }
            field("Upgrading date Cat/Echelon"; Rec."Upgrading date Cat/Echelon")
            {
                ApplicationArea = all;
            }
            field("Hors Grille"; Rec."Hors Grille")
            {
                ApplicationArea = all;
            }
            field("Gross Salary"; Rec."Gross Salary")
            {
                CaptionML = ENU = 'Indemnity', FRA = 'Indemnités';
                Style = Unfavorable;
                StyleExpr = TRUE;
                ApplicationArea = all;
            }
            field("Salaire brut"; Rec."Gross Salary" + Rec."Basis salary")
            {
                CaptionML = ENU = 'Gross Salary', FRA = 'Salaire brut';
                DecimalPlaces = 0 : 3;
                Style = Unfavorable;
                StyleExpr = TRUE;
                ApplicationArea = all;
            }
            field("Net Salary"; Rec."Net Salary")
            {

                Style = Unfavorable;
                StyleExpr = TRUE;
                ApplicationArea = all;
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                Style = Strong;
                StyleExpr = TRUE;
                ApplicationArea = all;
            }
            field("Bank Domiciliation"; Rec."Bank Domiciliation")
            {
                ApplicationArea = all;
            }
            field("Domiciliation Date"; Rec."Domiciliation Date")
            {
                ApplicationArea = all;
            }
            field("Default Bank Account Code"; Rec."Default Bank Account Code")
            {
                ApplicationArea = all;
            }
            field("Company Bank Account No."; Rec."Company Bank Account No.")
            {
                ApplicationArea = all;
            }
            field(RIB; Rec."Bank Account Number")
            {
                ApplicationArea = all;
            }

        }

        addafter("Social Security No.")
        {
            group(Identification)
            {
                Caption = 'Identification';
                Visible = true;
                field(Nationalité; Rec.Nationality)
                {
                    ApplicationArea = all;
                }
                field("Birth place A"; Rec."Birth place A")
                {
                    ApplicationArea = all;
                }
            }
            group("Situation familiale")
            {
                Caption = 'Situation familiale';
                field("Family chief"; Rec."Family chief")
                {
                    ApplicationArea = all;
                }
                field(Abattement; Rec.Abattement)
                {
                    ApplicationArea = all;
                }
                field("Family Situation A"; Rec."Family Situation A")
                {
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Deduction Loaded child"; Rec."Deduction Loaded child")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Loaded childs"; Rec."Loaded childs")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Spouse's Name"; Rec."Spouse's Name")
                {
                    ApplicationArea = all;

                }
            }
            group(Flag)
            {
                Caption = 'Flag';
                field("Social Fund"; Rec."Social Fund")
                {
                    ApplicationArea = all;
                }
                field("Affilé ASS GRP"; Rec."ASS GRP Affiliate")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Insurance Amount"; Rec."Insurance Amount")
                {
                    ApplicationArea = all;
                }
                field(Charge; Rec.Charge)
                {
                    ApplicationArea = all;
                }
                field("Retirement plus"; Rec."Retirement plus")
                {
                    ApplicationArea = all;
                }
            }
        }

        addafter(Payments)
        {
            group(Indemnities)
            {
                CaptionML = ENU = 'Indemnities', FRA = 'Indemnités';
                part("WDC Empl. Contracts List Ind"; "WDC Empl. Contracts List Ind")
                {
                    SubPageLink = "Emplymt. Contract Code" = FIELD("Emplymt. Contract Code");
                    ApplicationArea = all;
                }
            }
            group("Social contributions")
            {
                CaptionML = ENU = 'Social contributions', FRA = 'Cotisations sociale';
                part("Employment Contracts List Cot"; "WDC Empl. Contracts List Cot")
                {
                    ApplicationArea = all;
                    SubPageLink = "Emplymt. Contract Code" = FIELD("Emplymt. Contract Code");
                }
            }

            group(Statistics)
            {
                CaptionML = ENU = 'Statistics', FRA = 'Statistiques';
                group("Absences & Holidays")
                {
                    CaptionML = ENU = 'Absences & Holidays', FRA = 'Absences & Congés';
                    field("Congés années Précédentes"; DroitCong[1])
                    {
                        CaptionML = ENU = 'Holiday Previous Year', FRA = 'Congés années Précédentes';
                        ApplicationArea = all;
                    }
                    field("Congès année encours"; DroitCong[2])
                    {
                        CaptionML = ENU = 'Holiday Current Year', FRA = 'Congès année encours';
                        Style = Unfavorable;
                        StyleExpr = TRUE;
                        ApplicationArea = all;
                    }
                    field("Cuml Congés"; DroitCong[3])
                    {
                        CaptionML = ENU = 'Holiday Cuml', FRA = 'Cuml Congés';
                        ApplicationArea = all;
                    }
                }
                group("Recovery")
                {
                    CaptionML = ENU = 'Recovery', FRA = 'Récuperation';
                    field(Note; Rec.Note)
                    {
                        ApplicationArea = all;
                    }
                    field("Quarterly Note"; Rec."Quarterly Note")
                    {
                        CaptionML = ENU = 'Average Note', FRA = 'Moyenne note';
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

            group("Loan & Advances balance")
            {
                Captionml = ENU = 'Loan & Advances balance', FRA = 'Solde prêts & avances';
                field("Loans balance"; Rec."Loans balance")
                {
                    ApplicationArea = all;
                }
                field("Advances balance"; Rec."Advances balance")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        // area(navigation)
        // {
        addlast("E&mployee")
        {

            // action("Historiques carière") //Hamdi migration
            // {
            //     Caption = 'Historiques carière';
            //     Image = Employee;
            //     RunObject = Page 52078236;
            //     RunPageLink = Field2 = FIELD("No.");
            // }
            action("Absences in progress")
            {
                CaptionML = ENU = 'Absences in progress', FRA = 'A&bsences en cours';
                Image = WorkCenterAbsence;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = process;
                PromotedIsBig = true;
                RunObject = Page 5226;
                RunPageLink = "No." = FIELD("No."),
                                  "Employee No. Filter" = FIELD("No.");
            }
            action("Validated absences")
            {
                CaptionML = ENU = 'Validated absences', FRA = 'A&bsences validées';
                Image = ImplementRegAbsence;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = process;
                PromotedIsBig = true;
                RunObject = Page 5231;
                RunPageLink = "No." = FIELD("No.");
            }
            // action("Comptes &bancaires") //Hamdi Migration
            // {
            //     Caption = 'Comptes &bancaires';
            //     Image = BankAccount;
            //     RunObject = Page 52078155;
            //     RunPageLink = Field1 = FIELD("No.");
            // }
            // action("Contrat de travail")
            // {
            //     Caption = 'Contrat de travail';
            //     Image = EmployeeAgreement;
            //     RunObject = Page 52078153;
            //     RunPageLink = Field1 = FIELD("No.");
            // }

            action("Posted salaries")
            {
                CaptionML = ENU = 'Posted salaries', FRA = 'Salaires enreg.';
                Image = WageLines;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = process;
                PromotedIsBig = true;
                RunObject = Page 55045;
                RunPageLink = "Employee No." = FIELD("No.");
            }
            action("Posted Indemnities")
            {
                CaptionML = ENU = 'Posted Indemnities', FRA = 'Indemnitiés enreg.';
                RunObject = Page "WDC Recorded Indemnities";
                RunPageLink = "Employee No." = FIELD("No.");
                ApplicationArea = All;
                Image = InwardEntry;
                Promoted = true;
                PromotedCategory = process;
                PromotedIsBig = true;

            }
            action("Posted Social Controbition")
            {
                CaptionML = ENU = 'Posted Social Controbition', FRA = 'Cotisations sociales enreg.';
                RunObject = Page "WDC Rec. Social Contrib.";
                RunPageLink = "Employee No." = FIELD("No.");
                ApplicationArea = All;
                Image = CostEntries;
                Promoted = true;
                PromotedCategory = process;
                PromotedIsBig = true;

            }
        }
        addafter("E&mployee")
        {
            group("Employee Commitments")
            {
                CaptionML = ENU = 'Employee Commitments', FRA = 'Engagements Salariée';

                action("Loans in Progrss")
                {
                    CaptionML = ENU = 'Loans in Progrss', FRA = 'Prêts en cours';
                    Image = OpenWorksheet;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = process;
                    PromotedIsBig = true;
                    RunObject = Page 55025;
                    RunPageLink = "Employee No." = FIELD("No.");
                    RunPageView = SORTING("Employee No.", Type, Status, "No.", "Avance Sur Prime")
                                  ORDER(Ascending)
                                  WHERE(Status = FILTER("In progress"),
                                        Type = FILTER(Loan));
                }
                action("Advances in Progrss")
                {
                    CaptionML = ENU = 'Advances in Progrss', FRA = 'Avance en cours';
                    Image = OpenWorksheet;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = process;
                    PromotedIsBig = true;
                    RunObject = Page 55025;
                    RunPageLink = "Employee No." = FIELD("No.");
                    RunPageView = SORTING("Employee No.", Type, Status, "No.", "Avance Sur Prime")
                                  ORDER(Ascending)
                                  WHERE(Status = FILTER("In progress"),
                                        Type = FILTER(Advance));
                }
                action("Closed loans")
                {
                    CaptionML = ENU = 'Closed loans', FRA = 'Prêts clôturés';
                    Image = ApplicationWorksheet;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = process;
                    PromotedIsBig = true;
                    RunObject = Page 55025;
                    RunPageLink = "Employee No." = FIELD("No.");
                    RunPageView = SORTING("Employee No.", Type, Status, "No.", "Avance Sur Prime")
                                  ORDER(Ascending)
                                  WHERE(Status = FILTER(Enclosed),
                                        Type = FILTER(Loan));
                }

                action("Closed Advances")
                {
                    CaptionML = ENU = 'Closed Advances', FRA = 'Avances clôturées';
                    Image = ApplicationWorksheet;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = process;
                    PromotedIsBig = true;
                    RunObject = Page 55025;
                    RunPageLink = "Employee No." = FIELD("No.");
                    RunPageView = SORTING("Employee No.", Type, Status, "No.", "Avance Sur Prime")
                                  ORDER(Ascending)
                                  WHERE(Status = FILTER(Enclosed),
                                        Type = FILTER(Advance));
                }
            }
            // group(Functions)
            // {
            //     CaptionML = ENU = 'Functions', FRA = 'Fonctions';
            // action("Calculate salary")
            // {
            //     CaptionML = ENU = 'Calculate salary', FRA = 'Calcul du Salaire';
            //     Image = CalculateCost;
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = process;
            //     PromotedIsBig = true;
            //     trigger OnAction()
            //     begin
            //         SalaryLine.SETRANGE("No.", 'SIMULATION');
            //         SalaryLine.SETRANGE("Employee No.", Rec."No.");
            //         IF SalaryLine.Findfirst THEN
            //             MngtSalary.DeleteLineSimu(SalaryLine);
            //         MngtSalary.CréerSimulationPaie(Rec);
            //         COMMIT;

            //         SalaryLine.SETRANGE("No.", 'SIMULATION');
            //         SalaryLine.SETRANGE("Employee No.", Rec."No.");
            //         IF SalaryLine.Findfirst THEN
            //             PAGE.RUN(PAGE::"WDC Empl.Salary calculation", SalaryLine);

            //     end;
            // }
            // action("Archiver contrat de travail") //Hamdi Migration
            // {
            //     Image = FileContract;

            //     trigger OnAction()
            //     begin
            //         //>> DELTA 01
            //         ArchiveContract;
            //         //<< DELTA 01
            //     end;
            //     }
            // }
            group(Impression)
            {
                Caption = 'Impression';
                action("Mise en Demeure")
                {
                    CaptionML = ENU = 'Formal notice', FRA = 'Mise en Demeure';
                    Image = OpenWorksheet;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        RecGEmploy.RESET;
                        RecGEmploy.SETRANGE("No.", Rec."No.");
                        IF RecGEmploy.FINDSET THEN BEGIN
                            REPORT.RUN(55036, TRUE, FALSE, RecGEmploy);
                        END;
                    end;
                }
                // action("Annulation Domiciliation")
                // {
                //     Image = Alerts;
                //     RunObject = Report 52078240;
                //                     Visible = true;
                // }
                action("Work Attestation")
                {
                    CaptionML = ENU = 'Work attestation', FRA = 'Attestation de travail';
                    Image = OpenWorksheet;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        RecGEmploy.RESET;
                        RecGEmploy.SETRANGE("No.", Rec."No.");
                        IF RecGEmploy.FINDSET THEN BEGIN
                            REPORT.RUN(55037, TRUE, FALSE, RecGEmploy);
                        END;
                    end;
                }
                action("Salary Attestation")
                {
                    CaptionML = ENU = 'Salary Attestation', FRA = 'Attestation Salaire';
                    Image = OpenWorksheet;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        RecGEmploy.RESET;
                        RecGEmploy.SETRANGE("No.", Rec."No.");
                        IF RecGEmploy.FINDSET THEN BEGIN
                            REPORT.RUN(55039, TRUE, FALSE, RecGEmploy);
                        END;
                    end;
                }
                action("Work Certificate")
                {
                    CaptionML = ENU = 'Work certificate', FRA = 'Certificat de travail';
                    Image = OpenWorksheet;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        RecGEmploy.RESET;
                        RecGEmploy.SETRANGE("No.", Rec."No.");
                        IF RecGEmploy.FINDSET THEN BEGIN
                            REPORT.RUN(55038, TRUE, FALSE, RecGEmploy);
                        END;
                    end;
                }
                action("Update qualification")
                {
                    CaptionML = ENU = 'Update qualification', FRA = 'Mise à jour qualification';
                    Image = Job;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        MngtSalary2.MajQualif;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SETFILTER("Year Filter", '%1', DATE2DMY(WORKDATE, 3) - 2);
        FOR i := 1 TO 3 DO BEGIN
            DroitCong[i] := 0;
        END;
        CLEAR(Conges);
        Conges.SETRANGE("Employee No.", Rec."No.");
        Conges.SETFILTER("Line type", '%1|%2', Conges."Line type"::"Day off Right", Conges."Line type"::"Day off Consumption");
        Conges.SETFILTER("Posting year", '<=%1', DATE2DMY(WORKDATE, 3) - 1);
        IF Conges.FINDSET THEN
            REPEAT
                DroitCong[1] += Conges."Quantity (Days)";
            UNTIL Conges.NEXT = 0;

        CLEAR(Conges);
        Conges.SETRANGE("Employee No.", Rec."No.");
        Conges.SETFILTER("Line type", '%1|%2', Conges."Line type"::"Day off Right", Conges."Line type"::"Day off Consumption");
        Conges.SETFILTER("Posting year", '%1', DATE2DMY(WORKDATE, 3));
        IF Conges.FINDSET THEN
            REPEAT
                DroitCong[2] += Conges."Quantity (Days)";
            UNTIL Conges.NEXT = 0;
        DroitCong[3] := DroitCong[2] + DroitCong[1];
    end;



    // trigger OnNextRecord(Echelons: Integer): Integer //Migration Hamdi
    // begin
    //     CASE Rec.Status OF     //Inactive,Terminated
    //         Rec.Status::Inactive:
    //             BEGIN
    //                 IF (Rec."Cause of Inactivity Code" = '') OR (Rec."Inactive Date" = 0D) THEN MESSAGE(TxtIndispo);
    //             END;
    //         Rec.Status::Terminated:
    //             BEGIN
    //                 IF (Rec."Grounds for Term. Code" = '') OR (Rec."Termination Date" = 0D) THEN MESSAGE(Txtfincontrat);
    //             END;
    //     END;
    // end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit 802;
    begin
        IF NOT MapMgt.TestSetup THEN
            MapPointVisible := FALSE;
    end;


    var
        MapPointVisible: Boolean;
        SalaryLine: Record "WDC Salary Lines";
        MngtSalary: Codeunit 55023;
        MngtSalary2: Codeunit "WDC Salary Management 2";
        i: Integer;
        DroitCong: array[3] of Decimal;
        RecGEmploy: Record Employee;
        Conges: Record "WDC Employee's days off Entry";



}

