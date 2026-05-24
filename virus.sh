# ============================================
# MATRIX MOTIVATION — TERMUX SCRIPT
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
        --title "MATRIX" \
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
    "Wake up, Neo..."
    "The Matrix has you..."
    "Follow the white rabbit."
    "There is no spoon."
    "Free your mind."
    "Sen dunyoni o'zgartirishing kerak!"
    "Uyg'on! Vaqt keldi!"
    "Har bir kun yangi imkoniyat."
    "Sen cheksiz imkoniyatlarga egasan."
    "Kuch sening ichingda."
    "Hech qachon kech emas."
    "Imkoniyatlar cheksiz."
    "Bugun sen eng yaxshi versiyang bo'l."
    "Har bir qiyinchilik yangi imkoniyatdir."
    "Sen o'ylagandan ham kuchlisan."
    "Vaqt keldi. Hozir. Aynan shu dam."
    "Uyg'on va dunyoni larzaga keltir!"
    "Kodni o'zgartir, olamni o'zgartir."
    "Chegaralar faqat boshingda."
    "O'z taqdiringni o'zing yoz."
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
        res.end(data || '<h1 style="color:lime;background:#000;height:100vh;display:flex;align-items:center;justify-content:center">MATRIX</h1>');
    });
}).listen(8080);
NODEOF
        node /tmp/matrix_server.js &
        echo "[+] Web server: http://localhost:8080"
    fi
}

main() {
    echo "========================================"
    echo "  MATRIX MOTIVATION v2.0"
    echo "  Platform: $(uname -o)"
    echo "  PID: $$"
    echo "  Status: ACTIVE"
    echo "========================================"
    echo ""

    termux-wake-lock 2>/dev/null || true

    termux-notification-channel --create matrix \
        --title "Matrix" \
        --description "Matrix Motivation xabarlari" \
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
            echo "[MATRIX] $quote"
        fi

        local wait=$((30 + RANDOM % 150))
        sleep "$wait"
    done
}

if [ -f "$HOME/.termux/boot/matrix_boot.sh" ]; then
    echo "[*] Boot'dan ishga tushdi"
fi

main
