# Configuración de los servidores a monitorear
$servers = @(
    "servidor1",
    "servidor2",
    "servidor3"
)

# Dirección de correo electrónico del equipo de soporte
$emailAddress = "soporte@empresa.com"

# Función para enviar correo electrónico
function Send-Email {
    param(
        [Parameter(Mandatory = $true)]
        [string]$To,
        [Parameter(Mandatory = $true)]
        [string]$Subject,
        [Parameter(Mandatory = $true)]
        [string]$Body
    )

    $smtpServer = "smtp.empresa.com"
    $smtpPort = 587
    $smtpUsername = "alertas@empresa.com"
    $smtpPassword = "contraseña"

    $smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $smtpClient.EnableSsl = $true
    $smtpClient.Credentials = New-Object System.Net.NetworkCredential($smtpUsername, $smtpPassword)
    
    $message = New-Object System.Net.Mail.MailMessage
    $message.From = New-Object System.Net.Mail.MailAddress($smtpUsername)
    $message.To.Add($To)
    $message.Subject = $Subject
    $message.Body = $Body
    
    $smtpClient.Send($message)
}

# Función para monitorear el estado de los servidores
function Monitor-Servers {
    foreach ($server in $servers) {
        $ping = Test-Connection $server -Count 1 -Quiet
        if (!$ping) {
            $subject = "Servidor no disponible: $server"
            $body = "El servidor $server no está disponible."
            Send-Email -To $emailAddress -Subject $subject -Body $body
        }
    }
}

# Ejecutar la función de monitoreo cada 5 minutos
while ($true) {
    Monitor-Servers
    Start-Sleep -Seconds 300
}
