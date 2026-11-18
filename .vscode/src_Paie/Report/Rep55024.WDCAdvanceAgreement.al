report 55024 "WDC Advance Agreement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_Paie/Report/RDLC/AccordAvance.rdlc';
    CaptionML = ENU = 'Advance Agreement', FRA = 'Accord Avance';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Name_CompanyInformation; "Company Information".Name)
            {
            }
            column(DateExecute; FORMAT(TODAY, 0, 4))
            {
            }
            dataitem("Loan & Advance"; "WDC Loan & Advance")
            {
                DataItemTableView = SORTING(Type);
                RequestFilterFields = Type;
                column(Fonction; "Job Title")
                {
                }
                column(DesignationLoad; DesignationLoad)
                {
                }
                column(Periodicity; Periodicity)
                {
                }
                column(No_LoanAdvance; "Loan & Advance"."No.")
                {
                }
                column(Employee_LoanAdvance; "Loan & Advance"."Employee No.")
                {
                }
                column(Name_LoanAdvance; "Loan & Advance".Name)
                {
                }
                column(Montanttranche_LoanAdvance; "Loan & Advance"."Slice Amount")
                {
                }
                column(Totaltorepay_LoanAdvance; "Loan & Advance"."Total to repay")
                {
                }
                column(Repaymentslices_LoanAdvance; "Loan & Advance"."Repayment slices")
                {
                }
                column(Amount_LoanAdvance; "Loan & Advance".Amount)
                {
                }
                column(Interest_LoanAdvance; "Loan & Advance"."Interest %")
                {
                }
                column(EmployeePostingGroup_LoanAdvance; "Loan & Advance"."Employee Posting Group")
                {
                }
                column(Documenttype_LoanAdvance; "Loan & Advance"."Document type")
                {
                }
                column(Type_LoanAdvance; "Loan & Advance".Type)
                {
                }
                column(GroupeFilterss; 'Type du document : ' + FORMAT(Type))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RecGLoadType.RESET;
                    RecGLoadType.GET("Document type");
                    DesignationLoad := RecGLoadType.Description;
                end;
            }
        }
    }

    var
        RecGLoadType: Record 55010;
        DesignationLoad: Code[20];
}

