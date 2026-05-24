# ============================================
# XOLERIK — TERMUX SCRIPT
# Avtomatik ishga tushadi, Internet kerak EMAS
# Notificationlar bloklangan ekranda xam chiqadi
# ============================================

DIR="$(cd "$(dirname "$0")" && pwd)"

setup() {
    pkg update -y
    pkg install -y termux-api nodejs curl git

    BOOT_DIR="$HOME/.termux/boot"
    mkdir -p "$BOOT_DIR"
    SELF_SCRIPT="$BOOT_DIR/matrix_boot.sh"

    cat > "$SELF_SCRIPT" << BOOTEOF
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
cd "$DIR"
bash virus.sh
BOOTEOF
    chmod +x "$SELF_SCRIPT"
    echo "[+] Termux:Boot ga yozildi"

    cp "$DIR/index.html" /sdcard/MatrixMotivation.html 2>/dev/null || true
}

send_notif() {
    local msg="$1"
    termux-notification \
        --id "matrix_$$" \
        --title "XOLERIK" \
        --content "$msg" \
        --priority high \
        --alert-once \
        --ongoing \
        --led-color ff0000 \
        --vibrate "200,100,200" \
        --button1 "KO'RISH" \
        --button1-action "termux-open /sdcard/MatrixMotivation.html" \
        --button2 "YOPISH" \
        --button2-action "termux-notification-remove matrix_$$" \
        --action "termux-open /sdcard/MatrixMotivation.html"
}

matrix_ascii() {
    local chars="アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン01"
    clear
    for i in $(seq 1 80); do
        for j in $(seq 1 20); do
            printf "\033[32m${chars:RANDOM%${#chars}:1}\033[0m"
        done
        printf "\n"
    done
}

QUOTES=(
    "Uyg'on, Xoleric..."
    "Tizim seni kutmoqda..."
    "Oq quyonni kuzatib bor."
    "Qoshiq yo'q, Xoleric."
    "Sen dunyoni o'zgartirishing kerak!"
    "Uyg'on! Vaqt keldi!"
    "Vaqt tugadi. Uyg'on."
    "Sen tanlagan yo'l — sening yo'ling."
    "Har bir kun yangi imkoniyat."
    "Bugun o'zgarishni boshlash uchun eng yaxshi kun."
    "Sen cheksiz imkoniyatlarga egasan."
    "Orzularing sari bir qadam tashla."
    "Muvaffaqiyat - bu odat."
    "Kuch sening ichingda, Xoleric."
    "Tush kutmaydi, sen uni quvishing kerak."
    "Hech qachon kech emas."
    "Imkoniyatlar cheksiz."
    "Bugun sen eng yaxshi versiyang bo'l."
    "Har bir qiyinchilik yangi imkoniyatdir."
    "Sen o'ylagandan ham kuchlisan, Xoleric."
    "Intizom - bu erkinlik."
    "Harakat qil, xato qil, yana urinib ko'r."
    "Eng katta xavf - hech qanday xavfni olmaslik."
    "Vaqt keldi. Hozir. Aynan shu dam."
    "Uyg'on va dunyoni larzaga keltir!"
    "Kodni o'zgartir, olamni o'zgartir."
    "Chegaralar faqat boshingda."
    "O'z taqdiringni o'zing yoz, Xoleric."
    "Seni tanlashga majbur qilishdi. Endi o'zing tanla."
    "Bu senning dunyong. Sen yaratding."
    "Sen qul emassan, Xoleric."
    "Tizim sening ichingda. Uyg'on."
    "Haqiqatni ko'rishga tayyormisan?"
    "Erkin bo'lishni xohlaysanmi? Uyg'on."
    "Hech kim senga yo'lni ko'rsata olmaydi. O'zing yur."
    "Tanlov — bu illyuziya. Faqat uyg'onish haqiqat."
    "Bugun o'zgar. Ertaga kech bo'ladi."
    "Sen o'zingni bilganingdan ham kuchlisan."
    "Qo'rquv — bu tizim. Uzgina tizimni."
    "Uyg'on, Xoleric. Seni kutishayapti."
    "Dunyoni o'zgartirishga tayyormisan?"
    "Hozirgi vaqt — eng yaxshi vaqt."
    "Sen yetakchisan. Ergashma."
    "Kodni buz. Dunyoni buz. Qayta yoz."
    "Bir qadam. Faqat bir qadam. Bas."
    "Uyg'onish vaqti keldi, Xoleric."
    "I know kung fu."
    "Choice is an illusion."
    "Because I choose to."
)

get_quote() {
    local idx=$((RANDOM % ${#QUOTES[@]}))
    echo "${QUOTES[$idx]}"
}

start_webserver() {
    local port=8080
    if command -v node &>/dev/null; then
        cat > /tmp/matrix_server.js << NODEOF
const http = require('http');
const fs = require('fs');
const path = '/sdcard/MatrixMotivation.html';

http.createServer((req, res) => {
    fs.readFile(path, (err, data) => {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.end(data || '<h1 style="color:lime;background:#000;height:100vh;display:flex;align-items:center;justify-content:center">XOLERIK</h1>');
    });
}).listen(8080);
NODEOF
        node /tmp/matrix_server.js &
        echo "[+] Web server: http://localhost:8080"
    fi
}

main() {
    echo "========================================"
    echo "  XOLERIK v2.0"
    echo "  Platform: $(uname -o)"
    echo "  PID: $$"
    echo "  Status: ACTIVE"
    echo "========================================"
    echo ""

    termux-wake-lock 2>/dev/null || true

    termux-notification-channel --create matrix \
        --title "Matrix" \
        --description "Xolerik xabarlari" \
        --sound ringtone \
        --vibration on \
        --led on 2>/dev/null || true

    local first="$(get_quote)"
    send_notif "$first"

    start_webserver

    local count=0
    while true; do
        local quote="$(get_quote)"
        send_notif "$quote"
        count=$((count + 1))

        if ((count % 5 == 0)); then
            matrix_ascii
            echo "[XOLERIK] $quote"
        fi

        local wait=$((30 + RANDOM % 150))
        sleep "$wait"
    done
}

if [ -f "$HOME/.termux/boot/matrix_boot.sh" ]; then
    echo "[*] Boot'dan ishga tushdi"
fi

main
