codeunit 89801 JBP_JobQueueEventSubscriber
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Queue Start Codeunit", OnAfterRun, '', false, false)]
    local procedure JobQueueuStartCodeunit_OnAfterRun(var JobQueueEntry: Record "Job Queue Entry")
    begin
        ResettAlertCounter(JobQueueEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Queue Start Report", OnRunReportOnBeforeCommit, '', false, false)]
    local procedure JobQueueuStartReport_OnAfterRun(var JobQueueEntry: Record "Job Queue Entry")
    begin
        ResettAlertCounter(JobQueueEntry);
    end;

    local procedure ResettAlertCounter(var JobQueueEntry: Record "Job Queue Entry")
    begin
        if JobQueueEntry.JBP_FailResponseEmailSent = true then begin
            SendEmail(JobQueueEntry);
            JobQueueEntry.JBP_FailResponseEmailSent := false;
        end;

        JobQueueEntry.JBP_NumberOfRestarts := 0;
        JobQueueEntry.Modify(false);
    end;

    local procedure SendEmail(JobQueueEntryRecord: Record "Job Queue Entry")
    var
        email: Codeunit Email;
        emailMessage: Codeunit "Email Message";
        ErrorMessageLbl: Label 'Previous error on job %1 on company %2 has been resolved.', Comment = 'NOR="Tidligere feil på jobb %1 i selskapet %2 er løst."';
        ErrorSubjectLbl: Label 'Resolved - queue "%1"', Comment = 'NOR="Løst - jobbkø "%1""';
    begin
        emailMessage.Create(JobQueueEntryRecord.JBP_JobQueueEntryResponseEmail, StrSubstNo(ErrorSubjectLbl, JobQueueEntryRecord.Description), StrSubstNo(ErrorMessageLbl, JobQueueEntryRecord.Description, CompanyName()));
        email.Send(emailMessage, Enum::"Email Scenario"::"Job Queue Error Message");
    end;

}