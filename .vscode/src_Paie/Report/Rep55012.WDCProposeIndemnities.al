report 55012 "WDC Propose Indemnities"
{
    CaptionML = ENU = 'Propose Indemnities', FRA = 'Proposer Indemnités';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.")
                                WHERE(Blocked = CONST(False),
                                      Status = CONST(Active));
            RequestFilterFields = "No.", "Employee type";

            trigger OnAfterGetRecord()
            begin
                i := i + 1;
                CLEAR(G_Cnt);
                IF NOT (G_Cnt.GET("Emplymt. Contract Code")) THEN
                    CurrReport.SKIP;
                CLEAR(Indemnity);
                Indemnity.GET(IndemnityCode);
                DefaultIndemnities.INIT;
                DefaultIndemnities."Emplymt. Contract Code" := "Emplymt. Contract Code";
                DefaultIndemnities.VALIDATE("Indemnity Code", IndemnityCode);
                IF DefaultIndemnities.INSERT(TRUE) THEN
                    if IndemnityAmount <> 0 then begin
                        DefaultIndemnities.Validate("Default Amount", IndemnityAmount);
                        DefaultIndemnities.MODIFY(TRUE);
                    end;
                Wind.UPDATE(1, ("Last Name" + ' ' + "First Name"));

                IF COUNT <> 0 THEN
                    Wind.UPDATE(2, (ROUND(i / COUNT, 0.01) * 10000));
            end;

            trigger OnPostDataItem()
            begin
                Wind.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                IF IndemnityCode = '' THEN
                    CurrReport.BREAK;
                Wind.OPEN('Créer indemnités                    \' +
                          ' Employé  #1####################### \' +
                          ' Avancement                         \' +
                          ' @2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ');

            end;
        }


    }
    requestpage
    {

        layout
        {
            area(content)
            {
                field(IndemnityAmount; IndemnityAmount)
                {
                    CaptionML = ENU = 'Indemnity Amount', FRA = 'Montant indemnité';
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
            }
        }
    }

    var
        IndemnityCode: Code[20];
        Indemnity: Record "WDC Indemnity";
        DefaultIndemnities: Record "WDC Default Indemnities";
        Wind: Dialog;
        i: Integer;
        G_Cnt: Record "Employment Contract";
        IndemnityAmount: Decimal;


    procedure SetIndemnityCode(var pIndCode: Code[20])
    begin
        IndemnityCode := pIndCode;
    end;


}

