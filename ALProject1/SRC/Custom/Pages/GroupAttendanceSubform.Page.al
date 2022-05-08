page 50220 "Group Attendance Subform"
{
    PageType = ListPart;
    SourceTable = "Child Attendance";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field(Date; Date)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field("Child Name"; "Child Name")
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Participation; Participation)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Attendance; Attendance)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Breakfast; Breakfast)
                {
                }
                field(Brunch; Brunch)
                {
                }
                field(Lunch; Lunch)
                {
                }
                field(Dinner; Dinner)
                {
                }
                field(Activity; Activity)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Activity2; Activity2)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Activity3; Activity3)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Comment; Comment)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UpdateStyle;
        Rec.SetCurrentKey(Date);
        Rec.SetAscending(Date, true);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Date, Today);
    end;

    var
        [InDataSet]
        Color: Boolean;

    local procedure UpdateStyle()
    begin
        if Date = Today then
            Color := true
        else
            Color := false;
    end;
}

