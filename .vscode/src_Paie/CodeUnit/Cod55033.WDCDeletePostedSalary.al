codeunit 55033 "WDC Delete Posted Salary"
{

    var
        RecEmpDayOFF: Record "WDC Employee's days off Entry";

    procedure DeletePostedSalary(var pPostedSalaryHeader: Record "WDC Posted Salary Header")
    var
        lPostedSalaryLine: Record "WDC Posted Salary Lines";
        RecIndemnitie: Record "WDC Rec. Indemnities";
        RecSocialContribution: Record "WDC Rec. Social Contributions";
        RecSuppHour: Record "WDC Overtime hours recorded m";
        Wind: Dialog;
    begin
        Wind.OPEN('Supression de Paie  :  #1############### \' +
                    'Salarié  #2################################# \' +
                    'Avancement :                                 \' +
                    ' @3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ');
        //--> Création de l'en-tête

        Wind.UPDATE(1, pPostedSalaryHeader."No.");

        RecEmpDayOFF.RESET;
        RecEmpDayOFF.SETCURRENTKEY("Line type", "Employee No.", "Posting month", "Posting year");
        RecEmpDayOFF.SetRange("Payment No.", pPostedSalaryHeader."No.");
        IF RecEmpDayOFF.FINDFIRST THEN
            REPEAT
                RecEmpDayOFF.delete;
            UNTIL RecEmpDayOFF.NEXT = 0;

        lPostedSalaryLine.RESET;
        lPostedSalaryLine.SETRANGE("No.", pPostedSalaryHeader."No.");
        IF lPostedSalaryLine.FINDFIRST THEN
            REPEAT
                lPostedSalaryLine.Delete();
            UNTIL lPostedSalaryLine.NEXT = 0;

        RecIndemnitie.RESET;
        RecIndemnitie.SETRANGE("No.", pPostedSalaryHeader."No.");
        IF RecIndemnitie.FINDFIRST THEN
            REPEAT
                RecIndemnitie.DELETE;
            UNTIL RecIndemnitie.NEXT = 0;

        RecSocialContribution.Reset();
        RecSocialContribution.SETRANGE("No.", pPostedSalaryHeader."No.");
        IF RecSocialContribution.FINDFIRST THEN
            REPEAT

                RecSocialContribution.DELETE;
            UNTIL RecSocialContribution.NEXT = 0;


        RecSuppHour.SETRANGE("Payment Month", pPostedSalaryHeader.Month);
        RecSuppHour.SETRANGE("Payment Year", pPostedSalaryHeader.Year);
        IF RecSuppHour.FINDFIRST THEN
            REPEAT
                RecSuppHour.DELETE;
            UNTIL RecSuppHour.NEXT = 0;

        pPostedSalaryHeader.Delete();

        Wind.CLOSE;
        Message('Paie Supprimée avec Succès');

    end;


}
