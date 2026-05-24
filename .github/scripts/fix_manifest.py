import sys, re

f = sys.argv[1] if len(sys.argv) > 1 else "android/app/src/main/AndroidManifest.xml"
c = open(f).read()

perms = (
    '    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>\n'
    '    <uses-permission android:name="android.permission.VIBRATE"/>\n'
    '    <uses-permission android:name="android.permission.WAKE_LOCK"/>\n'
    '    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>\n'
    '    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>\n'
    '    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>\n'
    '    <uses-permission android:name="android.permission.USE_EXACT_ALARM"/>\n    '
)

c = c.replace('    <application', perms + '    <application')
c = c.replace('android:label="xolerik"', 'android:label="Xolerik"')
c = c.replace(
    'android:hardwareAccelerated="true">',
    'android:hardwareAccelerated="true" android:showWhenLocked="true" android:showOnLockScreen="true" android:turnScreenOn="true">'
)

open(f, 'w').write(c)
print("Manifest updated: " + f)
