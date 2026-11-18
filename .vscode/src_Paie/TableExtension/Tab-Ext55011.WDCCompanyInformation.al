tableextension 55011 "WDC Company Information" extends "Company Information"
{
    fields
    {
        field(55000; "Executive Director 1"; Text[80])
        {
            Caption = 'Executive Director 1';
            DataClassification = ToBeClassified;
        }
        field(55001; "Executive Director 2"; Text[80])
        {
            Caption = 'Executive Director 2';
            DataClassification = ToBeClassified;
        }

        field(55013; "Social Security No."; Code[20])
        {
            Caption = 'Social Security No.';
            DataClassification = ToBeClassified;
        }
    }
}
