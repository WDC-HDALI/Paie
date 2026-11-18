report 55028 "WDC Settle Loan"
{
    // //>>
    captionML = ENU = 'Settle Loan', FRA = 'Solder Prêt';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Loan & Advance Header"; "WDC Loan & Advance Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Principal Amount", "Interest Amount";

            trigger OnAfterGetRecord()
            var
                lText001: TextConst ENU = 'Choose an Account Type!!!',
                                    FRA = 'Choisissez un type de Compte !!!';
                lText002: TextConst ENU = 'Nothing to Sell',
                                    FRA = 'Rien à Solder';

            begin

                CASE AccountType OF
                    0:
                        ERROR(lText001);
                    1:
                        TypeC := TypeC::"G/L Account";
                    2:
                        TypeC := TypeC::"Bank Account";
                END;
                CASE Actiontype OF

                    0:
                        MESSAGE(lText002);
                    1:
                        Val.Solder("Loan & Advance Header", PostingDate, TypeC, NumCpt, NumDoc, DateP);
                    2:
                        Val.SolderDepasser("Loan & Advance Header", PostingDate, TypeC, NumCpt, NumDoc, DateP);
                    3:
                        Val.ReglerMnt("Loan & Advance Header", PostingDate, TypeC, NumCpt, NumDoc, BalanceAmount, DateP);
                END;

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field("Action type"; Actiontype)
                {
                    ApplicationArea = all;
                    CaptionMl = ENU = 'Action type', FRA = 'Type d''action';
                }

                field("Document No."; NumDoc)
                {
                    ApplicationArea = all;
                    CaptionMl = ENU = 'Document No.', FRA = 'N° Document';
                }
                field("Posting Date"; PostingDate)
                {
                    ApplicationArea = all;
                    CaptionMl = ENU = 'Posting Date', FRA = 'Date comptabilité';
                }
                field("Due Date"; DateP)
                {
                    ApplicationArea = all;
                    CaptionMl = ENU = 'Due Date', FRA = 'Date échéance';
                }
                field("Account Type"; AccountType)
                {
                    ApplicationArea = all;
                    CaptionMl = ENU = 'Account Type', FRA = 'Type de compte';
                }
                field("Account No."; NumCpt)
                {
                    ApplicationArea = all;
                    CaptionMl = ENU = 'Account No.', FRA = 'N° Compte';
                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        CASE AccountType OF
                            1:
                                BEGIN
                                    CLEAR(Lcpt);
                                    CLEAR(compt);
                                    Lcpt.LOOKUPMODE := TRUE;
                                    IF Lcpt.RUNMODAL = ACTION::LookupOK THEN
                                        Lcpt.GETRECORD(compt);
                                    NumCpt := compt."No.";
                                END;
                            2:
                                BEGIN
                                    CLEAR(Lbanq);
                                    CLEAR(banq);
                                    Lbanq.LOOKUPMODE := TRUE;
                                    IF Lbanq.RUNMODAL = ACTION::LookupOK THEN
                                        Lbanq.GETRECORD(banq);
                                    NumCpt := banq."No.";
                                END;
                        END;
                    end;
                }
                field("Amount to settle"; BalanceAmount)
                {
                    ApplicationArea = all;
                    CaptionMl = ENU = 'Amount to settle', FRA = 'Montant à solder';
                }
            }
        }

        trigger OnOpenPage()
        begin
            PostingDate := WORKDATE;
            DateP := WORKDATE;

        end;
    }

    var
        NumDoc: Code[20];
        Actiontype: Option " ","Solder Restant","solde Dépasser","Regler Montant";
        BalanceAmount: Decimal;
        Val: Codeunit "WDC Mgmt. Loans & Adv";
        PostingDate: Date;
        DateP: Date;
        AccountType: Option " ","Général",Banque;
        NumCpt: Code[20];
        Lcpt: Page 18;
        compt: Record 15;
        banq: Record 270;
        Lbanq: Page 371;
        TypeC: Enum "Gen. Journal Account Type";
}

