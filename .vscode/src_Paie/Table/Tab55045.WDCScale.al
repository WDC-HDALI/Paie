Table 55045 "WDC Scale"
{
    CaptionML = ENG = 'Scale', FRA = 'Echelle';
    fields
    {
        field(1; "Category"; Code[20])
        {
            CaptionML = ENG = 'Category', FRA = 'Catégorie';
            TableRelation = "WDC College";
        }
        field(2; "Scale"; Integer)
        {
            CaptionML = ENG = 'Scale', FRA = 'Echelle';
        }
        field(3; "Description"; text[30])
        {
            CaptionML = ENG = 'Description', FRA = 'Description';
            Editable = true;
            NotBlank = true;
        }
    }
    keys
    {
        key(Key1; "Category", Scale)
        {
            Clustered = true;
        }
    }
}
