# Aztec Node Monitoring Agent

[🌐 English Version](https://github.com/pittpv/aztec-monitoring-script/blob/main/en/ "English version of description")

![Bash](https://img.shields.io/badge/Bash-5.2-blue)
![Docker](https://img.shields.io/badge/Docker-20.10+-blue)
![Telegram](https://img.shields.io/badge/Telegram-API-blue)

![Первый экран](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/img-ru-2025-05-25-05-45-23.png)

## 📌 Обзор

Этот скрипт обеспечивает  мониторинг ноды Aztec с функциями:

- Проверка статуса контейнера
- Мониторинг синхронизации блоков
- Telegram-уведомления
- Поддержка двух языков
- Простая настройка cron-заданий
- Получение доказательства для дискорд роли

## 🛠 Возможности

1. **Мониторинг**:
   - Проверка работы контейнера Aztec
   - Контроль обработки блоков

2. **Анализ логов**:
   - Поиск rollupAddress
   - Извлечение PeerID
   - Отслеживание изменений governanceProposerPayload
   - Поиск номера доказанного блока и получения кода доказательства (нужно для получения роли Apprentice)

3. **Уведомления**:
   - Telegram-оповещения об оставании блока от сети
   - Приветственное сообщение
   - Идентификация сервера по IP

4. **Автоматизация**:
   - Настройка cron-задания
   - Ежеминутная проверка
   - Ротация логов

## ⚙️ Установка и запуск

1. **Требования**:
   Скрипт проверит наличиие необходимых компонентов и предложит установить недостающие.

2. **Запуск**:
   ```bash
   curl -o aztec-logs.sh https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/aztec-logs.sh  
   chmod +x aztec-logs.sh 
   ./aztec-logs.sh 
   ```

3. **Следуйте инструкциям** для:
   - Выбора языка
   - Ввода RPC URL
   - Настройки Telegram-бота
   - Активации мониторинга

## 🚀 Использование cron-агента 

После установки скрипт:

- Создаст агента в `~/aztec-monitor-agent`
- Настроит cron-задание
- Отправит начальный статус в Telegram
- Будет непрерывно мониторить ноду и записывать логи в agent.log
- Отправит уведомление в Telegram если не найдет актуальный блок

## 📝 Telegram-сообщения

- **Первый запуск**:
  ```
  🤖 Агент успешно запущен на сервере: 192.168.1.1
  ✅ Нода обрабатывает актуальный блок 12345
  ℹ️ Уведомления будут приходить только при отставании блоков
  ```

- **Оповещение об отставании**:
  ```
  ❗ Нода НЕ обрабатывает актуальный блок 12345
  🌐 Сервер: 192.168.1.1
  ```

## 📜 License

MIT License © 2023 Aztec Monitor Project