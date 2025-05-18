#!/usr/bin/env bash

# Параметры
MSMTP_CONF="/Users/alex/Documents/Работа/Aton/DevOps/disk_alert/msmtprc"
THRESHOLD=85
PARTITION="/"

# Получение текущего использования диска в процентах
USAGE=$(df -h "$PARTITION" | awk 'NR==2 {gsub(/%/,"",$5); print $5}')

# Проверка, превышает ли использование порог
if (( USAGE >= THRESHOLD )); then
  SUBJECT="Disk Usage Alert: ${USAGE}%% used"
  BODY="Warning: disk usage is ${USAGE}%% on $(hostname) at $(date '+%F %T')."

  FULL_MESSAGE="From: test_aton_777@mail.ru
To:   test_aton_777@mail.ru
Subject: $SUBJECT

$BODY"

  # Отправка письма
  printf '%s\n' "$FULL_MESSAGE" \
    | msmtp -v \
            -C "$MSMTP_CONF" \
            -a mailru \
            -t test_aton_777@mail.ru
fi

