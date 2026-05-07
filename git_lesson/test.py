import smtplib
import csv
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


EMAIL_HOST = os.getenv(get_env_var_name("EMAIL_HOST"))
EMAIL_PORT = os.getenv(get_env_var_name("EMAIL_PORT"))
EMAIL_HOST_USER = os.getenv(get_env_var_name("EMAIL_HOST_USER"))
EMAIL_HOST_PASSWORD = os.getenv(get_env_var_name("EMAIL_HOST_PASSWORD"))
SERVER_EMAIL = EMAIL_HOST_USER
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
REPLY_FROM_EMAIL = os.getenv(get_env_var_name("REPLY_FROM_EMAIL"))
SEND_MAIL_ENABLED = env.bool(get_env_var_name("SEND_MAIL_ENABLED"), default=False)
SEND_MAIL_ADD_LIST = os.getenv(get_env_var_name("SEND_MAIL_ADD_LIST"))

receiver_email = 'recipient@example.com' 

message = MIMEMultipart()
message['From'] = sender_email
message['To'] = receiver_email
message['Subject'] = 'DMC. Удаление устаревших ОТР'

body = """
Добрый день.

Сообщаем вам, что 21.01.2026 все документы с типом "(Устарел) ОТР по АФУ и аппаратной" в статусе «На доработке» будут удалены. 
При необходимости их согласования надо отправить либо на согласование до 21.01.2026, либо создать новые документы с типом "ОТР по АФУ и аппаратной".
Ссылки на такие документы:

"""

message.attach(MIMEText(body, 'plain'))

try:
    # Подключаемся к серверу Gmail через TLS соединение
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()  # активируем шифрование
    
    # Авторизация
    server.login(sender_email, password)
    
    # Отправляем письмо
    text = message.as_string()
    server.sendmail(sender_email, receiver_email, text)
    
    print('Письмо успешно отправлено!')
except Exception as e:
    print(f'Ошибка: {e}')
finally:
    server.quit()