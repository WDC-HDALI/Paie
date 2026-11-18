report 55025 "WDC Loan Amortization Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/TableauAmortissementPrêt.rdlc';
    captionML = ENU = 'Loan Amortization Schedule', FRA = 'Tableau d''amortissement de prêt';
    dataset
    {
        dataitem("Loan & Advance"; "WDC Loan & Advance")
        {
            RequestFilterFields = "No.";
            column(Employee_LoanAdvance; "Loan & Advance"."Employee No.")
            {
            }
            column(Name_LoanAdvance; "Loan & Advance".Name)
            {
            }
            column("PrêtNo"; "Loan & Advance"."No.")
            {
            }
            column(MontantBase; "Loan & Advance".Amount)
            {
            }
            column(Interest; "Loan & Advance"."Interest %")
            {
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(COMPANYNAME; CompagnyInfo.Name)
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }
                column(DateEch; DateEch)
                {
                }
                column(MntRest; MntRest)
                {
                }
                column(MntRet; MntRet)
                {
                }
                column(MntInt; MntInt)
                {
                }
                column(MntRetMntInt; MntRet + MntInt)
                {
                }
                column(Cumul; Cumul)
                {
                }
                column(TotMntRet; TotMntRet)
                {
                }
                column(TotMntInt; TotMntInt)
                {
                }
                column(TotMntRetTotMntInt; TotMntRet + TotMntInt)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //>>
                    MntRest := MntRest - MntRet;
                    MntRet := 0;
                    MntRet := ROUND(MntRest / ("Loan & Advance"."Repayment slices" - (Number - 1)), 0.001);
                    MntInt := 0;
                    DateEch := CALCDATE('+1J', DateEch);
                    //MntInt := ROUND("Loan & Advance".CalcMntInetretReport(DateEch, CALCDATE('+FM', DateEch)), 0.001);//Migration Hamdi
                    DateEch := CALCDATE('+FM', DateEch);
                    TotMntRet := TotMntRet + MntRet;
                    TotMntInt := TotMntInt + MntInt;
                    Cumul := Cumul + MntRet + MntInt;
                    //<<
                end;

                trigger OnPreDataItem()
                begin
                    //>>
                    IF ("Loan & Advance".Type.AsInteger = 0) OR ("Loan & Advance"."Repayment slices" = 0) THEN
                        CurrReport.BREAK;
                    SETFILTER(Number, '1..%1', "Loan & Advance"."Repayment slices");
                    MntRest := "Loan & Advance".Amount;
                    DateEch := "Loan & Advance"."Effective date";
                    MntRet := 0;
                    TotMntRet := 0;
                    TotMntInt := 0;
                    Cumul := 0;
                    //<<
                end;
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("No.");
            end;
        }
    }


    trigger OnInitReport()
    begin
        //>>
        CompagnyInfo.GET();
        CompagnyInfo.CALCFIELDS(Picture);
        //<<
    end;

    var
        LastFieldNo: Integer;
        MntRest: Decimal;
        MntRet: Decimal;
        MntInt: Decimal;
        DateEch: Date;
        TotMntRet: Decimal;
        TotMntInt: Decimal;
        Cumul: Decimal;
        CompagnyInfo: Record 79;
}

