pageextension 60000 CustomerCardExt extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field("Parent Name"; "Parent Name")
            {
                Visible = true;
                ApplicationArea = all;
            }
            field("Child Name"; "Child Name")
            {
                Visible = true;
                ApplicationArea = all;
            }
        }
    }

}