page 55086 "WDC Follow-up of loans & adv."
{
    PageType = Card;
    SourceTable = "Company Information";
    CaptionML = ENU = 'Follow-up of loans and advances', FRA = 'Suivi des prêts et avances';
    layout
    {
        area(content)
        {
            group(Employee)
            {
                CaptionML = ENU = 'Employee', FRA = 'Employé';
                part("WDC Employee List"; "WDC Employee List")
                {
                    ApplicationArea = all;
                }
            }
            group("Advance List_G")
            {
                CaptionML = ENU = 'Advance List', FRA = 'Liste des avances';
                part("WDC Advance List"; "WDC Advance List")
                {
                    provider = "WDC Employee List";
                    SubPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = all;
                }
            }
            group("Loan List_G")
            {
                CaptionML = ENU = 'Loan List', FRA = 'Liste des prêts';
                part("WDC Loan List"; "WDC Loan List")
                {
                    provider = "WDC Employee List";
                    SubPageLink = "Employee No." = FIELD("No.");
                    ApplicationArea = all;
                }
            }
        }
    }
}

//}

