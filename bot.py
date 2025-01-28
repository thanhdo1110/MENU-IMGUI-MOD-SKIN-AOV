import os
import subprocess
import time
import shutil
import telebot
import logging
from threading import Thread


bot = telebot.TeleBot('7379104019:AAF6mss6m0TRtgTRyaEeNqI_5ZkN-OAbkTY')


obj_folder = './.theos/obj'


logging.basicConfig(level=logging.DEBUG, filename='bot.log', filemode='w',
                    format='%(asctime)s - %(levelname)s - %(message)s')


def handle_make(message, msg, progress_callback):

    try:
        subprocess.run(['make', 'clean'], check=True)
        progress_callback(10)
    except subprocess.CalledProcessError as e:
        bot.send_message(message.chat.id, f'Error during make clean: {e}')
        logging.error(f'Lỗi trong quá trình make clean: {e}')
        return False


    process = subprocess.Popen(['make'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

   
    total_lines = 0
    with open('Makefile', 'r') as makefile:
        for line in makefile:
            total_lines += 1

  
    current_line = 0
    while True:
     
        if process.poll() is not None:
            break

       
        output = process.stdout.readline().decode('utf-8').strip()
        if output:
            logging.info(f'Output from make: {output}')
            current_line += 1
            progress = int((current_line / total_lines) * 90) + 10
            progress_callback(progress)

      
        time.sleep(1)

 
    if process.returncode == 0:
     
        dylib_files = [f for f in os.listdir(obj_folder) if f.endswith('.dylib')]
        if dylib_files:
      
            for dylib_file in dylib_files:
                with open(os.path.join(obj_folder, dylib_file), 'rb') as f:
                    bot.send_document(message.chat.id, f)
            progress_callback(100)
            return True
        else:
            bot.send_message(message.chat.id, 'No .dylib file found.')
    else:
        bot.send_message(message.chat.id, 'Error during make.')
        logging.error(f'Lỗi trong quá trình make: {process.stderr.read().decode("utf-8")}')
    return False


@bot.message_handler(commands=['makemenu'])
def handle_makemenu(message):

    if os.path.exists('config.mm'):
        os.remove('config.mm')


    shutil.copy2('configbackup.mm', 'config.mm')

  
    msg = bot.send_message(message.chat.id, 'Đang dọn dẹp các file cũ.')

    def progress_callback(increment):
        nonlocal progress
        progress = increment
        bot.edit_message_text(chat_id=message.chat.id, message_id=msg.message_id, text=f'Đang bắt đầu quá trình make | Tiến độ {progress}%')

    progress = 0
    success = handle_make(message, msg, progress_callback)
    if success:
 
        bot.edit_message_text(chat_id=message.chat.id, message_id=msg.message_id, text='Đã gửi file thành công!')


@bot.message_handler(commands=['makemenumodskin'])
def handle_makemenumodskin(message):
  
    if os.path.exists('config.mm'):
        os.remove('config.mm')


    shutil.copy2('configbackup.mm', 'config.mm')


    bot.send_document(message.chat.id, open('configbackup.mm', 'rb'), caption='Sửa lại file này và gửi lại cho bot.')

    @bot.message_handler(content_types=['document'])
    def handle_config_file(message):
      
        file_info = bot.get_file(message.document.file_id)
        downloaded_file = bot.download_file(file_info.file_path)

       
        with open('config.mm', 'wb') as f:
            f.write(downloaded_file)


        logging.info(f'Nhận được file config.mm mới.')
        logging.info(f'Ghi đè nội dung file config.mm thành công.')

       
        msg = bot.send_message(message.chat.id, 'Đang dọn dẹp các file cũ.')

        def progress_callback(increment):
            nonlocal progress
            progress = increment
            bot.edit_message_text(chat_id=message.chat.id, message_id=msg.message_id, text=f'Đang bắt đầu quá trình make | Tiến độ {progress}%')

        progress = 0
        success = handle_make(message, msg, progress_callback)
        if success:
        
            bot.edit_message_text(chat_id=message.chat.id, message_id=msg.message_id, text='Đã gửi file thành công!')


bot.polling()