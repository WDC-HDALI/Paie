page 55046 "WDC Recorded salaries"
{
    CaptionML = ENU = 'Recorded salaries', FRA = 'Salaires enregistrés';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "WDC Posted Salary Header";
    SourceTableView = SORTING("Posting Date", "No.");

    layout
    {
        area(content)
        {
            Group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }

                field(Month; Rec.Month)
                {
                    ApplicationArea = all;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Paid days"; Rec."Paid days")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Worked days"; Rec."Worked days")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Integrated in accounting"; Rec."Integrated in accounting")
                {
                    ApplicationArea = all;
                }
            }
            part(SalaryLineForm; "WDC Recorded Salary Lines")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = all;
            }
            group("Cumulated salaries")
            {
                CaptionML = ENU = 'Cumulated salaries', FRA = 'Salaires cumulés';
                field("Employee No. filter"; Rec."Employee No. filter")
                {
                    ApplicationArea = all;
                }
                field("Employee posting grp. filter"; Rec."Employee posting grp. filter")
                {
                    ApplicationArea = all;
                }
                field("Salary lines"; Rec."Salary lines")
                {
                    ApplicationArea = all;
                }
                field("Total Basis Salary"; Rec."Total Basis Salary")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Total Supp. Hours"; Rec."Total Supp. Hours")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Total Taxable indemnities"; Rec."Total Taxable indemnities")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Total Gross salary"; Rec."Total Gross salary")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Non Taxable Soc. Contrib."; Rec."Non Taxable Soc. Contrib.")
                {
                    ApplicationArea = all;
                }
                field("Taxable indemnities Not Gross"; Rec."Taxable indemnities Not Gross")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Total taxable"; Rec."Total taxable")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Taxable Soc. Contrib."; Rec."Taxable Soc. Contrib.")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Taxes total"; Rec."Taxes total")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Total Not Taxable indemnities"; Rec."Total Not Taxable indemnities")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Mission expenses total"; Rec."Mission expenses total")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Net salary total"; Rec."Net salary total")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Loans repaiment total"; Rec."Loans repaiment total")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Advances repaiment total"; Rec."Advances repaiment total")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Net salary cashed"; Rec."Net salary cashed")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Global dimension 1 Filter"; Rec."Global dimension 1 Filter")
                {
                    ApplicationArea = all;
                }
                field("Global dimension 2 Filter"; Rec."Global dimension 2 Filter")
                {
                    ApplicationArea = all;
                }
                field("Statistic Group Filter"; Rec."Statistic Group Filter")
                {
                    ApplicationArea = all;
                }
            }
            group("Payement balance")
            {
                CaptionML = ENU = 'Payement balance', FRA = 'Solde paiement';
                field("Employee No. filter 2"; Rec."Employee No. filter")
                {
                    ApplicationArea = all;
                }
                field("Employee posting grp. filter 2"; Rec."Employee posting grp. filter")
                {
                    ApplicationArea = all;
                }
                field("Global dimension 1 Filter 2"; Rec."Global dimension 1 Filter")
                {
                    ApplicationArea = all;
                }
                field("Global dimension 2 Filter 2"; Rec."Global dimension 2 Filter")
                {
                    ApplicationArea = all;
                }
                field("Filter gpe statistic 2"; Rec."Statistic Group Filter")
                {
                    ApplicationArea = all;
                }
                field("Salary lines 3"; Rec."Salary lines")
                {
                    ApplicationArea = all;
                }
                field("Salary basis total 2"; Rec."Total Basis Salary")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Total Supp. Hours 2"; Rec."Total Supp. Hours")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Total Taxable indemnities 2"; Rec."Total Taxable indemnities")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Total Taxable indemnities Not 2"; Rec."Taxable indemnities Not Gross")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Total Non Taxable indemnities 2"; Rec."Total Not Taxable indemnities")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Mission expenses total 2"; Rec."Mission expenses total")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field(MntJourFerTrav; MntJourFerTrav)
                {
                    CaptionML = ENU = 'Worked Holiday Amount', FRA = 'Montant jour férie travaillé';
                    Enabled = false;
                }
                // field(;ROUND("Total Basis Salary"+ "Total Supp. Hours"+"Total Taxable indemnities"+"Mission expenses total" + "Total Not Taxable indemnities"+"Taxable indemnities Not Gross",0.001) +MntJourFerTrav)
                // {
                //     AutoFormatType = 0;
                //     DecimalPlaces = 3:3;
                // }
                field("Non Taxable Soc. Contrib. 2"; Rec."Non Taxable Soc. Contrib.")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Taxable Soc. Contrib. 2"; Rec."Taxable Soc. Contrib.")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Loans repaiment total 2"; Rec."Loans repaiment total")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Advances repaiment total 2"; Rec."Advances repaiment total")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Taxes total 2"; Rec."Taxes total")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Ajout en +"; Rec."Ajout en +")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Report en -"; Rec."Report en -")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Net salary cashed 2"; Rec."Net salary cashed")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Caisse fond social"; Rec."Caisse fond social")
                {
                    ApplicationArea = all;
                }
                field(Total; ROUND(Rec."Taxable Soc. Contrib." + Rec."Non Taxable Soc. Contrib." + Rec."Loans repaiment total" + Rec."Advances repaiment total" + Rec."Taxes total" + Rec."Net salary cashed" + Rec."Report en -" - Rec."Ajout en +", 0.001) + Rec."Caisse fond social")
                {
                    AutoFormatType = 0;
                    Caption = 'Total';
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
            }
            group("Human Ress. cost")
            {
                CaptionML = ENU = 'Human Ress. cost', FRA = 'Coût ressources humaines';
                field("Employee No. filter 3"; Rec."Employee No. filter")
                {
                    ApplicationArea = all;
                }
                field("Employee posting grp. filter 3"; Rec."Employee posting grp. filter")
                {
                    ApplicationArea = all;
                }
                field("Global dimension 1 Filter 3"; Rec."Global dimension 1 Filter")
                {
                    ApplicationArea = all;
                }
                field("Global dimension 2 Filter 3"; Rec."Global dimension 2 Filter")
                {
                    ApplicationArea = all;
                }
                field("Filter gpe statistic 3"; Rec."Statistic Group Filter")
                {
                    ApplicationArea = all;
                }
                field("Salary lines 4"; Rec."Salary lines")
                {
                    ApplicationArea = all;
                }
                field("Salary basis total 3"; Rec."Total Basis Salary")
                {
                    ApplicationArea = all;
                }
                field("Taxable indemnities total 3"; Rec."Total Taxable indemnities")
                {
                    ApplicationArea = all;
                }
                field("Non Taxable indemnities T 3"; Rec."Total Not Taxable indemnities")
                {
                    ApplicationArea = all;
                }
                field("Taxable indemnities Not 3"; Rec."Taxable indemnities Not Gross")
                {
                    DecimalPlaces = 3 : 3;
                    ApplicationArea = all;
                }
                field("Mission expenses total 3"; Rec."Mission expenses total")
                {
                    ApplicationArea = all;
                }
                field("Total Supp. Hours 3"; Rec."Total Supp. Hours")
                {
                    ApplicationArea = all;
                }
                field("Total Employer Contributions"; Rec."Total Employer Contributions")
                {
                    ApplicationArea = all;
                }
                field(Total2; Rec."Total Basis Salary" + Rec."Total Taxable indemnities" + Rec."Total Not Taxable indemnities" + Rec."Mission expenses total" + Rec."Total Supp. Hours" + Rec."Total Employer Contributions")
                {
                    //HD Caption manquante
                    AutoFormatType = 2;
                }
            }
            group("Absences/Days off")
            {
                CaptionML = ENU = 'Absences/Days off', FRA = 'Absences/Jours fermés';
                field("Employee No. filter 4"; Rec."Employee No. filter")
                {
                    ApplicationArea = all;
                }
                field("Employee posting grp. filter 4"; Rec."Employee posting grp. filter")
                {
                    ApplicationArea = all;
                }
                field("Global dimension 1 Filter 4"; Rec."Global dimension 1 Filter")
                {
                    ApplicationArea = all;
                }
                field("Global dimension 2 Filter 4"; Rec."Global dimension 2 Filter")
                {
                    ApplicationArea = all;
                }
                field("Filter gpe statistic 4"; Rec."Statistic Group Filter")
                {
                    ApplicationArea = all;
                }
                field("Salary lines 5"; Rec."Salary lines")
                {
                    ApplicationArea = all;
                }
                field(Abcences; Rec.Abcences)
                {
                    ApplicationArea = all;
                }
                field("Holidays taken"; Rec."Holidays taken")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {

        area(reporting)
        {

            group("Print...")
            {
                CaptionML = ENU = 'Print...', FRA = 'Imprimer...';
                action("Payroll Journal")
                {
                    CaptionML = ENU = 'Payroll Journal', FRA = 'Journal de paie';
                    Image = PrintVAT;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        CurrPage.SalaryLineForm.PAGE.GETRECORD(Line);
                        SalaryRecLine.SETRANGE("No.", Line."No.");
                        SalaryRecLine.SETRANGE("Employee No.", Line."Employee No.");
                        Header.SETRANGE("No.", Rec."No.");
                        REPORT.RUN(55008, TRUE, TRUE, Header);
                    end;
                }
                action("Payroll Slip 2P")
                {
                    CaptionML = ENU = 'Payroll Slip 2P', FRA = 'Fiche de paie 2P';
                    Image = PrintVAT;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        Header.RESET;
                        Header.SETRANGE("No.", Rec."No.");
                        IF Header.FINDSET THEN BEGIN
                            SalaryRecLine.SETRANGE("No.", Header."No.");
                            IF SalaryRecLine.FINDSET THEN BEGIN
                                REPORT.RUN(55006, TRUE, TRUE, Header);
                            END;
                        END;
                    end;
                }
                action("Payroll Slip 13th month")
                {
                    CaptionML = ENU = 'Payroll Slip 13th month', FRA = 'Fiche de paie 13ième';
                    Image = SendElectronicDocument;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        Report13: Report 55045;
                    begin
                        CLEAR(Report13);
                        Header.RESET;
                        Header.SETRANGE("No.", Rec."No.");
                        IF Header.FINDSET THEN BEGIN
                            SalaryRecLine.SETRANGE("No.", Header."No.");
                            IF SalaryRecLine.FINDSET THEN BEGIN
                                Report13.SETTABLEVIEW(Header);
                                Report13.GetTitre(Rec.Description);
                                Report13.RUNMODAL;
                            END;

                        END;
                    end;
                }

                action("Print transfer order")
                {
                    CaptionML = ENU = 'Print transfer order', FRA = 'Impression ordre de virement';
                    Image = Bank;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        Header2.SETRANGE("No.", Rec."No.");
                        REPORT.RUNMODAL(55014, TRUE, TRUE, Header2);
                    end;
                }
                action("Print cash payment")
                {
                    CaptionML = ENU = 'Print cash payment', FRA = 'Impression paiement espèces';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        Header.SETRANGE("No.", Rec."No.");
                        REPORT.RUN(55034, TRUE, TRUE, Header);
                    end;
                }
                action("Cancel Payroll Posting")
                {
                    CaptionML = ENU = 'Cancel Payroll Posting', FRA = 'Annuler validation paie';
                    ApplicationArea = all;
                    Visible = CancelPayrollPosting;
                    trigger OnAction()
                    Var
                        DeletePostedSalary: Codeunit "WDC Delete Posted Salary";
                        lText001: TextConst ENU = 'Are you sure you want to delete this posted payroll?',
                            FRA = 'Voulez-voussupprimer cette paie validée ?';
                    begin
                        if confirm(lText001, false) then
                            DeletePostedSalary.DeletePostedSalary(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        MntJourFerTrav := 0;
        SalaryRecLine.SETCURRENTKEY("No.");
        SalaryRecLine.SETFILTER("No.", Rec."No.");
        IF SalaryRecLine.FINDSET THEN BEGIN
            REPEAT
                SalaryRecLine.CALCFIELDS("Public Holiday Worked Amount");
                MntJourFerTrav := MntJourFerTrav + SalaryRecLine."Public Holiday Worked Amount";
            UNTIL SalaryRecLine.NEXT = 0;
        END;
    end;

    trigger OnOpenPage()
    begin
        UserSetup.GET(UserId);
        CancelPayrollPosting := UserSetup."Allow Cancel Posted Payroll";
    end;

    var
        SalaryRecLine: Record "WDC Posted Salary Lines";
        Line: Record "WDC Posted Salary Lines";
        Header: Record 55024;
        MntJourFerTrav: Decimal;
        Header2: Record 55024;
        CancelPayrollPosting: Boolean;
        UserSetup: Record "User Setup";

}

