report 50090 "Child Attendance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC\Custom\Reports\RdlcLayouts\ChildAttendanceReport.rdlc';

    dataset
    {
        dataitem(Childer; Childer)
        {
            column(KidNo; Childer."Child No.")
            {
            }
            column(KindName; KindergartenName)
            {
            }
            column(KindCity; KindergartenCity)
            {
            }
            column(KindAddress; KindergartenAddress)
            {
            }
            column(DtFrom; DateFrom)
            {
            }
            column(DtTo; DateTo)
            {
            }
            dataitem("Child Attendance"; "Child Attendance")
            {
                DataItemLink = "Child No." = FIELD("Child No.");
                column(EntryNo; "Child Attendance"."Entry No.")
                {
                }
                column(ChildNo; "Child Attendance"."Child No.")
                {
                }
                column(AttDate; "Child Attendance".Date)
                {
                }
                column(Attend; "Child Attendance".Attendance)
                {
                }
                column("Break"; "Child Attendance".Breakfast)
                {
                }
                column(Brun; "Child Attendance".Brunch)
                {
                }
                column(Lun; "Child Attendance".Lunch)
                {
                }
                column(Dinn; "Child Attendance".Dinner)
                {
                }
                column(Activ; "Child Attendance".Activity)
                {
                }
                column(Activ2; "Child Attendance".Activity2)
                {
                }
                column(Activ3; "Child Attendance".Activity3)
                {
                }
                column(Comm; "Child Attendance".Comment)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if (DateFrom = 0D) and (DateTo = 0D) then
                        DateTo := WorkDate;

                    case true of
                        (DateFrom <> 0D) and (DateTo <> 0D):
                            //"Cust. Ledger Entry".SETRANGE("Posting Date",DateFrom,DateTo);
                            "Child Attendance".SetRange(Date, DateFrom, DateTo);
                        (DateFrom <> 0D):
                            //"Cust. Ledger Entry".SETFILTER("Posting Date",'%1..',DateFrom);
                            "Child Attendance".SetFilter(Date, '%1..', DateFrom);
                        else
                            //"Cust. Ledger Entry".SETRANGE("Posting Date",0D,DateTo);
                            "Child Attendance".SetRange(Date, 0D, DateTo);
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Kid.SetFilter(Kid."Child No.", Childer."Child No.");
                if Kid.FindSet then begin
                    KindGroup.SetFilter("Group No.", Kid."Group No.");
                    if KindGroup.FindSet then begin
                        Kindergarten.SetFilter("No.", KindGroup."Kindergarten No.");
                        if Kindergarten.FindSet then begin
                            KindergartenName := Kindergarten.Name;
                            KindergartenAddress := Kindergarten.Address;
                            KindergartenCity := Kindergarten.City;
                        end;
                    end;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Date From"; DateFrom)
                {
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if (DateFrom <> 0D) and (DateTo <> 0D) then begin
                            if DateFrom > DateTo then
                                Error('Date From cannot be greater than Date To');
                        end;
                    end;
                }
                field("Date To"; DateTo)
                {
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if (DateFrom <> 0D) and (DateTo <> 0D) then begin
                            if DateTo < DateFrom then
                                Error('Date From cannot be greater than Date To');
                        end;
                    end;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Kid: Record Childer;
        KindGroup: Record "Kindergarten Groups";
        Kindergarten: Record Kindergarten;
        KindergartenName: Text[50];
        KindergartenCity: Text[50];
        KindergartenAddress: Text[100];
        DateFrom: Date;
        DateTo: Date;
}

