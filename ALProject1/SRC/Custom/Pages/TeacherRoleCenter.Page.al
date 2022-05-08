page 50250 "Teacher Role Center"
{
    PageType = RoleCenter;

    layout
    {
        area(content)
        {
        }
    }

    actions
    {
        area(processing)
        {
            group("Teacher Administration")
            {
                action("Attendance/Child Management")
                {
                    Image = OpenJournal;
                    Promoted = true;
                    RunObject = Page Kindergarten;
                }
            }
        }
    }
}

