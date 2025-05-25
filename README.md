# Aztec Node Monitoring Agent

![Bash](https://img.shields.io/badge/Bash-5.2-blue)
![Docker](https://img.shields.io/badge/Docker-20.10+-blue)
![Telegram](https://img.shields.io/badge/Telegram-API-blue)

[🌐 English Version](https://github.com/pittpv/aztec-monitoring-script/blob/main/en/ "English version of description")

### 📌 Обзор

Этот скрипт обеспечивает комплексный мониторинг ноды Aztec с функциями:

- Проверка статуса контейнера
- Мониторинг синхронизации блоков
- Telegram-уведомления
- Поддержка двух языков
- Простая настройка cron-заданий

### 🛠 Возможности

1. **Мониторинг**:
   - Проверка работы контейнера Aztec
   - Контроль обработки блоков

2. **Анализ логов**:
   - Поиск rollupAddress
   - Извлечение PeerID
   - Отслеживание изменений governanceProposerPayload

3. **Уведомления**:
   - Telegram-оповещения о проблемах
   - Приветственное сообщение
   - Идентификация сервера по IP

4. **Автоматизация**:
   - Настройка cron-задания
   - Ежеминутная проверка
   - Ротация логов

### ⚙️ Установка

1. **Требования**:
   ```bash
   sudo apt-get install curl git docker.io
   ```

2. **Клонирование**:
   ```bash
   git clone https://github.com/yourrepo/aztec-monitor.git
   cd aztec-monitor
   ```

3. **Запуск**:
   ```bash
   chmod +x aztec-monitor.sh
   ./aztec-monitor.sh
   ```

4. **Следуйте инструкциям** для:
   - Выбора языка
   - Ввода RPC URL
   - Настройки Telegram-бота
   - Активации мониторинга

### 🚀 Использование

После установки скрипт:

- Создаст агента в `~/aztec-monitor-agent`
- Настроит cron-задание
- Отправит начальный статус в Telegram
- Будет непрерывно мониторить ноду

Ручные команды:
```bash
# Проверить статус
./aztec-monitor.sh

# Удалить агента
./aztec-monitor.sh (выбрать пункт 3)
```

### 📝 Telegram-сообщения

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