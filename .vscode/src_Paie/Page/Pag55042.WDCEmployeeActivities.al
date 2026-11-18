page 55042 "WDC Employee Activities"
{
    CaptionML = ENU = 'Employee Activities', FRA = 'Activités des employés';
    PageType = CardPart;
    SourceTable = "Sales Cue";
    RefreshOnActivate = true;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            cuegroup(Group)
            {
                field("Total Employees"; Rec."Total Employees")
                {
                    ApplicationArea = all;

                }
                field("Hours Employees"; Rec."Hours Employees")
                {
                    ApplicationArea = all;
                }
                field("Month Employees"; Rec."Month Employees")
                {
                    ApplicationArea = all;
                }
                field("CDI Employees"; Rec."CDI Employees")
                {
                    ApplicationArea = all;
                }
                field("CDD Employees"; Rec."CDD Employees")
                {
                    ApplicationArea = all;
                }
                field("SIVP Employees"; Rec."SIVP Employees")
                {
                    ApplicationArea = all;
                }
                field("Inactive Employees"; Rec."Inactive Employees")
                {
                    ApplicationArea = all;
                }


                // actions
                // {
                //     action(WorkflowPortal)
                //     {
                //         Caption = 'Workflow Portal';

                //         trigger OnAction()
                //         var
                //             WorkflowPortal: Page 5103606;
                //         begin
                //             // WF1069 - Begin
                //             WorkflowPortal.EDITABLE := TRUE;
                //             WorkflowPortal.LOOKUPMODE := FALSE;
                //             WorkflowPortal.RUN;
                //             // WF0169 - End
                //         end;
                //     }
                //     action(CreateNewMessage)
                //     {
                //         Caption = 'Create New Message';
                //         RunObject = Codeunit 5103606;
                //         RunPageMode = Create;
                //     }
                //     action(OverdueTasks)
                //     {
                //         Caption = 'Overdue Tasks';
                //         RunObject = Report 5103612;
                //         RunPageMode = Create;
                //     }
                //     action(CompletedTasks)
                //     {
                //         Caption = 'Completed Tasks';
                //         RunObject = Page 5103617;

                //         trigger OnAction()
                //         var
                //             WorkflowServices: Codeunit 5103600;
                //         begin
                //         end;
                //     }
                // }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.CalcFields("Total Employees");
    end;

}

