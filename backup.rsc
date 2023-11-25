:local lerctoken "token-telegram"
:local lercgrupochat "-chatid"
:local hostname [/system identity get name];
:local destinatario "xxxx1@gmail.com"
:local destinatariocc "xxxx2@gmail.com"

/tool e-mail set address=mail.com.br from=destino@email.com.br password=senha123mudar port=587 user=destino@email.com.br

:local backupconf "$[/system identity get name]-CONF.backup"
:local backupexp "$[/system identity get name]-CONF.rsc"
:local backuplog "$[/system identity get name]-LOG.txt"
:delay 2s
:log warning "[BACKUP] Criando arquivo de Backup - $backupconf"
/system backup save name=$backupconf
:delay 1s;
/export file=$backupexp
:log warning "[BACKUP] Criando arquivo de Importacao - $backupexp"
:delay 1s;
:log warning "[BACKUP] Criando arquivo de LOGs - $backuplog"
/log print file=$backuplog
:delay 1s;
:log warning "[BACKUP] Arquivos criandos com sucesso. Realizando envios e notificacoes."

:local arquivos {$backupconf;$backuplog;$backupexp}
/tool e-mail send to="$destinatario,$destinatariocc" subject="[Backup de Configuracoes e LOGs - $hostname]"  file=$arquivos body="Backup automatico realizado com sucesso.."
:log warning "[BACKUP] Enviado!"
:delay 2s;
:local lercmsg "Backup de $hostname Realizado com Sucesso."
/tool fetch url="https://api.telegram.org/bot$lerctoken/sendMessage\?chat_id=$lercgrupochat&text=$lercmsg" keep-result=no
:log warning "[BACKUP] Notificado via Telegram!"
:log error "[BACKUP] Backups anteriores serao removidos em instantes."
:delay 15s;
/file remove [find where name~"CONF.backup"]
/file remove [find where name~"CONF.rsc"]
/file remove [find where name~"LOG.txt"]
:delay 5s;
/tool e-mail set address=1.2.3.4 port=25 from=x@x.x.x user=x@x.x.x password=xxx
:if ([:len [/system scheduler find name="AUTO-BKP"]] = 0) do={
  /log error "[Auto Backup] Alerta: Agendamento nao localizado. Criando agendamento de Auto Backup..."
  /system scheduler add name=AUTO-BKP interval=1d start-date=nov/13/2023 start-time=startup on-event=BKP
  /log warning "[Auto Backup] Alerta: Agendamento Criado com Sucesso."
}
