report 55002 "WDC Post Loan & Advance"
{
    ProcessingOnly = true;
    CaptionML = ENU = 'Payroll : Post Loan & Advance', FRA = 'Paie : Validation Prêts & Avances';
    dataset
    {
        dataitem("Loan & Advance"; "WDC Loan & Advance")
        {
            DataItemTableView = SORTING("Document type");
            RequestFilterFields = "No.", "Document type";
            RequestFilterHeading = 'Loans && Advances';
            dataitem("Loan & Advance Type"; 55010)
            {
                DataItemLink = Code = FIELD("Document type"),
                               Type = FIELD(Type);
                DataItemTableView = SORTING(Code)
                                    ORDER(Descending);

                trigger OnAfterGetRecord()
                begin
                    IF NOT MgmtLoansAdvances.TestValiditeDocument("Loan & Advance") THEN
                        ERROR(errDoc, "Loan & Advance"."No." + ' - ' + "Loan & Advance".Name);

                    IF "Accounting Posting".AsInteger() = 0 THEN
                        MgmtLoansAdvances.EcrComptaPaiement("Loan & Advance", PostingDate, PostingMode);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                window.UPDATE(1, "Loan & Advance"."No.");
                window.UPDATE(2, "Loan & Advance"."Employee No." + ' - ' + "Loan & Advance".Name);
                window.UPDATE(3, 'Vérification de la validité des documents');
            end;

            trigger OnPostDataItem()
            begin
                IF "Loan & Advance".FIND('-') THEN
                    REPEAT
                        MgmtLoansAdvances.EnregDocument("Loan & Advance", PostingDate);
                        window.UPDATE(3, 'Enregistrement des documents validés');
                    UNTIL "Loan & Advance".NEXT = 0;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("Document type");
                window.OPEN('Validation des Prêts && Avances en cours ...\' +
                             'N° document : ########################1####\' +
                             "Loan & Advance".FIELDCAPTION("Employee No.") + '     : ########################2####\' +
                             '######################################3####');
            end;
        }
    }


    trigger OnInitReport()
    begin
        PostingDate := WORKDATE;
    end;

    trigger OnPostReport()
    begin
        CASE PostingMode OF
            0:
                MESSAGE(success, HumResSetup."General Journal Template", HumResSetup."Gen. Journal Batch (L&A)");
        END;

        window.CLOSE;
    end;

    var
        LastFieldNo: Integer;
        MgmtLoansAdvances: Codeunit "WDC Mgmt. Loans & Adv";
        PostingDate: Date;
        PostingMode: Option "Par Feuille de saisie",Directe;
        HumResSetup: Record "Human Resources Setup";
        Success: TextConst ENU = 'Document posting operation successfull.\Lines inserted on Journal : %1 - %2.',
                           FRA = 'Opération d''enregistrement des documents réussie.\Lines insérées dans le journal : %1 - %2.';
        window: Dialog;
        errDoc: TextConst ENU = '%1 is not a valid document. Some needed informations are missing.',
                          FRA = '%1 n''est pas un document valide. Certaines informations requises sont manquantes.';
}