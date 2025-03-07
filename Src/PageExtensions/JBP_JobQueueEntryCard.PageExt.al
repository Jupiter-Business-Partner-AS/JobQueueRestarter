pageextension 89801 JBP_JobQueueEntryCard extends "Job Queue Entry Card"
{
    layout
    {
        addafter(General)
        {
            group(JobQueueErrorHandling)
            {
                Caption = 'Job Queue Error Hanlding', Comment = 'NOR="Jobbkø feilhåndtering"';

                field(JobQueueEntryFailResponse; Rec.JBP_JobQueueEntryFailResponse)
                {
                    ToolTip = 'Specifies the value of the Job Queue Entry Fail Response field.', Comment = 'NOR="Jobbkø håndtering ved feil"';
                    ApplicationArea = All;
                }
                field(JobQueueEntryFailResponseEmail; Rec.JBP_JobQueueEntryResponseEmail)
                {
                    ToolTip = 'Specifies the value of the Email on error field.', Comment = 'NOR="Epost ved feil"';
                    ApplicationArea = All;
                }
                field(JBP_RestartsBeforeAlert; Rec.JBP_RestartsBeforeAlert)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Number of restarts before email sendt field.', Comment = 'NOR="Antall omstarter før epost sendes"';
                }
                field(JBP_NumberOfRestarts; Rec.JBP_NumberOfRestarts)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Number of restarts field.', Comment = 'NOR="Antall omstarter"';
                    Editable = false;
                }
            }
        }
    }
}