page 50260 "Administrator/Accountant RC"
{
    PageType = RoleCenter;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Administrator/Accountant RC';

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
            group("Administrator Actions")
            {
                action("Manage Contracts")
                {
                    Image = Documents;
                    Caption = 'Manage Contracts';
                    Promoted = true;
                    ApplicationArea = All;
                    RunObject = Page "Child Contract List";
                }
                action("Posted Contract List")
                {
                    Image = Filed;
                    Caption = 'Posted Contract List';
                    Promoted = true;
                    ApplicationArea = All;
                    RunObject = Page "Posted Child Contract List";
                }
                action("Contract Journal")
                {
                    Image = Journal;
                    Caption = 'Contract Journal';
                    Promoted = true;
                    ApplicationArea = All;
                    RunObject = Page "Contract Journal Line";
                }
                action("Contract Ledger")
                {
                    Image = LedgerBook;
                    Caption = 'Contract Ledger';
                    Promoted = true;
                    ApplicationArea = All;
                    RunObject = Page "Contract Ledger Entry";
                }
                action("Overview Report")
                {
                    Image = FiledOverview;
                    Promoted = true;
                    Caption = 'Overview Report';
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunObject = Report "Overview Report";
                }
            }

            group("Kindergarten Management")
            {
                action("Kindergarten facilities")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    Caption = 'Kindergarten facilities';
                    Image = Home;
                    RunObject = Page "Kindergarten facilities";
                }

                action("Kindergarten groups")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    Caption = 'Kindergarten groups';
                    Image = CustomerGroup;
                    RunObject = Page "Kindergarten groups";
                }

                action("Kindergarten children")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    Caption = 'Kindergarten children';
                    Image = Customer;
                    RunObject = Page "Children List";
                }

                action("Kindergarten Activities")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    Caption = 'Kindergarten Activities';
                    Image = NewSparkle;
                    RunObject = Page Service;
                }

                action("Kindergarten Meals")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    Caption = 'Kindergarten Meals';
                    Image = EditLines;
                    RunObject = Page "Meal Prices";

                }

                action("Kindergarten Month Prices")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    Caption = 'Kindergarten Month Prices';
                    Image = EditLines;
                    RunObject = Page "Month Prices";
                }

                action("Kindergarten Day Prices")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    Caption = 'Kindergarten Day Prices';
                    Image = EditLines;
                    RunObject = Page "Day Prices";
                }

            }
        }
    }
}

