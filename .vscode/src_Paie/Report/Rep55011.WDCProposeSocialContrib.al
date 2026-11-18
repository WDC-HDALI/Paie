report 55011 "WDC Propose Social Contrib."
{
    CaptionML = ENU = 'Propose Social Contribution', FRA = 'Proposer Cotisation Sociale';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.")
                                WHERE(Blocked = CONST(false),
                                      Status = CONST(Active));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                //>>
                i := i + 1;
                CLEAR(G_Cnt);
                IF NOT (G_Cnt.GET("Emplymt. Contract Code")) THEN
                    CurrReport.SKIP;
                CLEAR(G_Cot);
                G_Cot.GET(G_CotCode);
                G_defCot.INIT;
                G_defCot."Emplymt. Contract Code" := "Emplymt. Contract Code";
                G_defCot.VALIDATE("Social Contribution Code", G_CotCode);
                IF G_defCot.INSERT(TRUE) THEN;
                Wind.UPDATE(1, ("Last Name" + ' ' + "First Name"));

                IF COUNT <> 0 THEN
                    Wind.UPDATE(2, (ROUND(i / COUNT, 0.01) * 10000));
                //<<
            end;

            trigger OnPostDataItem()
            begin
                Wind.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                //>>
                IF G_CotCode = '' THEN
                    CurrReport.BREAK;
                Wind.OPEN('Créer Cotisations                   \' +
                          ' Employé  #1####################### \' +
                          ' Avancement                         \' +
                          ' @2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ');
                //<<
            end;
        }
    }


    var
        G_CotCode: Code[20];
        G_Cot: Record "WDC Social Contribution";
        G_defCot: Record "WDC Default Soc. Contribution";
        Wind: Dialog;
        i: Integer;
        G_Cnt: Record "Employment Contract";


    procedure Setind(var codeind: Code[20])
    begin
        G_CotCode := codeind;
    end;
}

