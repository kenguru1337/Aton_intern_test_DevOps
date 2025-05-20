#!/usr/bin/env bash

MSMTP_CONF="/Users/alex/Documents/Работа/Aton/DevOps/disk_alert/msmtprc"
THRESHOLD_FREE=85
PARTITION="/"

timestamp(){ date '+%Y-%m-%d %H:%M:%S'; }

# читаем total и avail в KB (ровно две переменные!)
read TOTALKB AVAILKB < <(df -k "$PARTITION" | awk 'NR==2 {print $2, $4}')

# считаем проценты
USEDKB=$(( TOTALKB - AVAILKB ))
FREE=$(( AVAILKB * 100 / TOTALKB ))
USED=$((100 - FREE))

# алерт
if (( FREE < THRESHOLD_FREE )); then
  SUBJECT="Disk Free Alert: ${FREE}% available"
  BODY="Warning: free disk space on $(hostname) is ${FREE}% (<${THRESHOLD_FREE}%) at $(timestamp)."

  # Отправка письма
  FULL_MESSAGE="From: test_aton_777@mail.ru
To:   test_aton_777@mail.ru
Subject: $SUBJECT

$BODY"

  printf '%s\n' "$FULL_MESSAGE" \
    | msmtp -v -C "$MSMTP_CONF" -a mailru -t
fi

