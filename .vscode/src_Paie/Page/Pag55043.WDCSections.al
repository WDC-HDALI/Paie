page 55043 "WDC Sections"
{
    CaptionML = ENU = 'Sections', FRA = 'Sections';
    PageType = List;
    SourceTable = "WDC Section";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Employee Status Group"; Rec."Employee Status Group")
                {
                    ApplicationArea = all;
                }
                field(Management; Rec.Management)
                {
                    ApplicationArea = all;
                }
                field(Service; Rec.Service)
                {
                    ApplicationArea = all;
                }
                field(Section; Rec.Section)
                {
                    ApplicationArea = all;
                }
                field(Decription; Rec.Decription)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}

