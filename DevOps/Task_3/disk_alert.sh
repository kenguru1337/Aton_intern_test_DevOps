#!/usr/bin/env bash

# Параметры
MSMTP_CONF="/Users/alex/Documents/Работа/Aton/DevOps/disk_alert/msmtprc"
THRESHOLD=85
PARTITION="/"

read _ TOTALKB AVAILKB _ < <(df -k "$PARTITION" | awk 'NR==2 {print $2, $4}')

FREE=$(( AVAILKB * 100 / TOTALKB ))
USED=$(( 100 - FREE ))

# Проверка, превышает ли использование порог
if (( FREE < THRESHOLD )); then
  SUBJECT="Disk Free Alert: ${FREE}% available"
  BODY="Warning: Free disk space on $(hostname) is now ${FREE}% (<${THRESHOLD}%) at $(date '+%F %T')."

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

