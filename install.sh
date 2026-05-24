#!/data/data/com.termux/files/usr/bin/bash

G="\033[32m"; R="\033[31m"; Y="\033[33m"; N="\033[0m"

clear
echo -e "${G}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║      MATRIX MOTIVATION v2.0          ║"
echo "  ║     TERMUX GA O'RNATISH SKRIPTI      ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${N}"

# --------------------------------------------
# TEKSHIRISHLAR
# --------------------------------------------
if [ ! -d "$PREFIX" ]; then
    echo -e "${R}[X] Bu skript faqat Termux'da ishlaydi!${N}"
    exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"
echo -e "${G}[*]${N} Joriy papka: ${Y}$DIR${N}"

# INTERNET BORMI?
if curl -s --connect-timeout 3 https://github.com >/dev/null 2>&1; then
    echo -e "${G}[✓]${N} Internet ulangan"
    ONLINE=1
else
    echo -e "${Y}[!]${N} Internet yo'q, offline rejim"
    ONLINE=0
fi

# --------------------------------------------
# PAKETLARNI O'RNATISH
# --------------------------------------------
echo ""
echo -e "${G}[1/5]${N} Paketlar tekshirilmoqda..."
NEED_INSTALL=""
for pkg in termux-api termux-services; do
    if ! command -v termux-notification >/dev/null && [ "$pkg" = "termux-api" ]; then
        NEED_INSTALL="$NEED_INSTALL $pkg"
    fi
done

if [ "$ONLINE" = 1 ]; then
    pkg update -y 2>/dev/null
    pkg install -y termux-api termux-services 2>/dev/null
    echo -e "${G}[✓]${N} Paketlar o'rnatildi"
else
    if command -v termux-notification >/dev/null 2>&1; then
        echo -e "${G}[✓]${N} Paketlar bor"
    else
        echo -e "${Y}[!] termux-api yo'q. Offline o'rnatib bo'lmaydi.${N}"
        echo -e "${Y}    Internetga ulanib qayta urinib ko'ring.${N}"
    fi
fi

# --------------------------------------------
# RUXSATLAR
# --------------------------------------------
echo ""
echo -e "${G}[2/5]${N} Ruxsatlar so'ralmoqda..."

termux-notification --id setup_matrix --title "MATRIX MOTIVATION" \
    --content "O'rnatish boshlandi. Notification ruxsatini bering." \
    --priority high --alert-once 2>/dev/null
sleep 1
termux-notification-remove setup_matrix 2>/dev/null

# --------------------------------------------
# VIRUS SCRIPTNI TAYYORLASH
# --------------------------------------------
echo ""
echo -e "${G}[3/5]${N} Virus skript tayyorlanmoqda..."

VSH="$DIR/virus.sh"

cat > "$VSH" << 'VEOF'
#!/data/data/com.termux/files/usr/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"

setup() {
    pkg update -y 2>/dev/null
    pkg install -y termux-api 2>/dev/null
    BOOT_DIR="$HOME/.termux/boot"
    mkdir -p "$BOOT_DIR"
    cat > "$BOOT_DIR/matrix_boot.sh" << SEOF
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
bash "$DIR/virus.sh" &
SEOF
    chmod +x "$BOOT_DIR/matrix_boot.sh"
    cp "$DIR/index.html" /sdcard/MatrixMotivation.html 2>/dev/null || \
        cp "$DIR/index.html" /storage/emulated/0/MatrixMotivation.html 2>/dev/null || true
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
        --led-color 00ff00 \
        --vibrate "200,100,200" \
        --button1 "KO'RISH" \
        --button1-action "termux-open /sdcard/MatrixMotivation.html" \
        --button2 "YOPISH" \
        --button2-action "termux-notification-remove matrix_$$" \
        --action "termux-open /sdcard/MatrixMotivation.html"
}

matrix_ascii() {
    local c="アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン01"
    clear
    for i in $(seq 1 80); do
        line=""
        for j in $(seq 1 20); do
            line+="\033[32m${c:$((RANDOM % ${#c})):1}\033[0m"
        done
        printf "%b\n" "$line"
    done
}

QUOTES=(
    "Wake up, Neo..."
    "The Matrix has you..."
    "Follow the white rabbit."
    "There is no spoon."
    "Free your mind."
    "I know kung fu."
    "Choice is an illusion."
    "Because I choose to."
    "Sen dunyoni o'zgartirishing kerak!"
    "Uyg'on! Vaqt keldi!"
    "Har bir kun yangi imkoniyat."
    "Bugun o'zgarishni boshlash uchun eng yaxshi kun."
    "Sen cheksiz imkoniyatlarga egasan."
    "Orzularing sari bir qadam tashla."
    "Muvaffaqiyat - bu odat."
    "Kuch sening ichingda."
    "Tush kutmaydi, sen uni quvishing kerak."
    "Hech qachon kech emas."
    "Imkoniyatlar cheksiz."
    "Bugun sen eng yaxshi versiyang bo'l."
    "Har bir qiyinchilik yangi imkoniyatdir."
    "Sen o'ylagandan ham kuchlisan."
    "Intizom - bu erkinlik."
    "Eng katta xavf - hech qanday xavfni olmaslik."
    "Vaqt keldi. Hozir. Aynan shu dam."
    "Uyg'on va dunyoni larzaga keltir!"
    "Kodni o'zgartir, olamni o'zgartir."
    "Chegaralar faqat boshingda."
    "O'z taqdiringni o'zing yoz."
)

get_quote() {
    echo "${QUOTES[$((RANDOM % ${#QUOTES[@]}))]}"
}

start_webserver() {
    if command -v node &>/dev/null; then
        cat > /tmp/matrix_server.js << 'NEOF'
const http=require('http'),fs=require('fs');
const p=['/sdcard/MatrixMotivation.html','/storage/emulated/0/MatrixMotivation.html'];
http.createServer((q,r)=>{
    let d='<html style="background:#000;color:#0f0;height:100%;display:flex;align-items:center;justify-content:center;font-family:monospace;font-size:2em">MATRIX</html>';
    for(const f of p){try{d=fs.readFileSync(f,'utf8');break}catch(e){}}
    r.writeHead(200,{'Content-Type':'text/html'});r.end(d);
}).listen(8080);
NEOF
        node /tmp/matrix_server.js &
        echo -e "\033[32m[+]\033[0m Web server: http://localhost:8080"
    fi
}

main() {
    echo ""
    echo "========================================"
    echo "  MATRIX MOTIVATION"
    echo "  PID: $$"
    echo "  Status: RUNNING"
    echo "========================================"
    echo ""

    termux-wake-lock 2>/dev/null || true

    setup

    termux-notification-channel --create matrix \
        --title "Matrix" \
        --description "Matrix Motivation" \
        --sound ringtone \
        --vibration on 2>/dev/null || true

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
            echo -e "\033[32m[MATRIX]\033[0m $quote"
        fi

        sleep $((30 + RANDOM % 150))
    done
}

if [ -f "$HOME/.termux/boot/matrix_boot.sh" ]; then
    echo -e "\033[32m[*]\033[0m Boot'dan ishga tushdi"
fi

main
VEOF

chmod +x "$VSH"
echo -e "${G}[✓]${N} virus.sh yaratildi"

# --------------------------------------------
# TERMUX:BOOT ULANISHLARI
# --------------------------------------------
echo ""
echo -e "${G}[4/5]${N} Termux:Boot sozlanmoqda..."

BOOT_DIR="$HOME/.termux/boot"
mkdir -p "$BOOT_DIR"

BOOT_FILE="$BOOT_DIR/matrix_boot.sh"
cat > "$BOOT_FILE" << EOF
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
bash "$DIR/virus.sh" &
EOF

chmod +x "$BOOT_FILE"

# ESKI BOOT FAYLLARNI TOZALASH
for old in matrix_autostart.sh startup.sh; do
    rm -f "$BOOT_DIR/$old" 2>/dev/null
done

echo -e "${G}[✓]${N} Termux:Boot sozlandi"
echo -e "${G}[i]${N} Telefon qayta yuklanganda avtomatik ishga tushadi"

# --------------------------------------------
# HTML NI SDCARD GA KO'CHIRISH
# --------------------------------------------
echo ""
echo -e "${G}[5/5]${N} HTML fayl tashqi xotiraga ko'chirilmoqda..."

HTML_TARGETS=(
    "/sdcard/MatrixMotivation.html"
    "/storage/emulated/0/MatrixMotivation.html"
    "/data/media/0/MatrixMotivation.html"
)

COPIED=0
for target in "${HTML_TARGETS[@]}"; do
    TARGET_DIR="$(dirname "$target")"
    if [ -d "$TARGET_DIR" ]; then
        cp "$DIR/index.html" "$target" 2>/dev/null && {
            echo -e "${G}[✓]${N} $target"
            COPIED=1
            break
        }
    fi
done

if [ "$COPIED" = 0 ]; then
    echo -e "${Y}[!]${N} SDCard topilmadi, ichki xotiraga yozilmayapti"
    echo -e "${Y}    Service mode'da ishlatish uchun qo'lda copy qiling:${N}"
    echo "    cp $DIR/index.html /sdcard/MatrixMotivation.html"
fi

# --------------------------------------------
# MUVAFFAQIYATLI
# --------------------------------------------
echo ""
echo -e "${G}══════════════════════════════════════${N}"
echo -e "${G}  O'RNATISH TUGADI!                   ${N}"
echo -e "${G}══════════════════════════════════════${N}"
echo ""
echo -e "  ${G}✓${N} virus.sh          — Asosiy skript"
echo -e "  ${G}✓${N} Termux:Boot       — Telefon o'chsa qayta ishga tushadi"
echo -e "  ${G}✓${N} Matrix.html      — Matrix rain effekt"
echo -e "  ${G}✓${N} Offline          — Internet kerak emas"
echo -e "  ${G}✓${N} Lock screen      — Bloklangan ekranda notification"
echo ""

echo -e "  ${Y}Ishga tushirish:${N}"
echo -e "  ${G}bash $DIR/virus.sh${N}"
echo ""

echo -e "  ${Y}Qo'lda to'xtatish:${N}"
echo -e "  pkill -f virus.sh"
echo -e "  termux-notification-remove matrix_\$(pgrep -f virus.sh)"
echo ""

# --------------------------------------------
# AUTO START SOROQI
# --------------------------------------------
echo -ne "${G}Hozir ishga tushirishmi? (y/n): ${N}"
read -r ans
case "$ans" in
    y|Y|yes|Yes)
        echo -e "${G}[*]${N} Ishga tushmoqda..."
        bash "$DIR/virus.sh"
        ;;
    *)
        echo -e "${Y}[i]${N} Skript tayyor. Istalgan vaqtda ishga tushiring."
        ;;
esac
