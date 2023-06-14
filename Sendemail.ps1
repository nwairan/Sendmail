$senderEmail = "Sender@example.com"
$subject = "a New file Received"
$body = "Dear recipient, 

You have received a new file. Please find the attached file.

Best regards,"


$attachmentFolderPath = "path"
$attachmentExtension = "pdf"
$smtpServer = "Mail Server"
$smtpPort = 25
$destinationFolderPath = "path for processed files"
$smtpCredentials = New-Object System.Management.Automation.PSCredential($senderEmail, (ConvertTo-SecureString -String $senderPassword -AsPlainText -Force))

$attachmentFiles = Get-ChildItem -Path $attachmentFolderPath -Filter "*.$attachmentExtension"

foreach ($attachmentFile in $attachmentFiles) {
    # Extract the recipient email from the attachment file name and remove text after underscore (_)
    $recipientEmail = [regex]::Match($attachmentFile.BaseName, "(?<=^|_)[\w\.-]+@[\w\.-]+\.\w+").Value
    $recipientEmail = $recipientEmail -replace "_.*$"

    $mailParams = @{
        From = $senderEmail
        To = $recipientEmail
        Subject = $subject
        Body = $body
        Attachments = $attachmentFile.FullName
        SmtpServer = $smtpServer
        Credential = $smtpCredentials
        UseSsl = $true
    }
    Send-MailMessage @mailParams
  }


    $destinationFilePath = Join-Path -Path $destinationFolderPath -ChildPath $attachmentFile.Name
    Move-Item -Path $attachmentFile.FullName -Destination $destinationFilePath
