pageextension 89800 JBP_JobQueueEntries extends "Job Queue Entries"
{
    layout
    {
        addafter("User ID")
        {
            field(JobQueueEntryFailResponse; Rec.JBP_JobQueueEntryFailResponse)
            {
                ToolTip = 'Specifies the value of the Job Queue Entry Fail Response field.', Comment = 'NOR="Jobbkø håndtering ved feil"';
                ApplicationArea = All;
            }
        }
    }
}