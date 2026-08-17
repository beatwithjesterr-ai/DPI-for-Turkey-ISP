@echo off
chcp 65001 > nul
setlocal EnableExtensions
cls

:: ============================================================
::   TURKIYE ISS - ZAPRET DPI BYPASS KONTROL PANELI
::   Tum islemler (Baslat / Servis Kur / Servis Kaldir) tek dosyada
:: ============================================================

:: Yonetici yetkisi kontrolu
NET SESSION >nul 2>&1
if %errorLevel% neq 0 (
    echo [HATA] Lutfen bu dosyaya SAG TIKLAYIP "YONETICI OLARAK CALISTIR" deyin!
    pause
    exit /b
)

:: Klasor konumunu sabitle
cd /d "%~dp0Private Data"
if not exist "winws.exe" (
    echo [HATA] winws.exe bulunamadi! "Private Data" klasorunu kontrol edin.
    pause
    exit /b
)

:: Servis kurulumu icin sabit degiskenler
set "SERVICE_NAME=zapret"
set "EXE_PATH=%~dp0Private Data\winws.exe"

:ANAMENU
cls
echo =======================================================
echo         TURKIYE ISS SECIN - ZAPRET KONTROL PANELI
echo =======================================================
echo.
echo  -- Test edilmis / dogrulanmis presetler --
echo  [1]  Turk Telekom / TTNET
echo  [2]  Turk Telekom - Alternatif
echo  [3]  SuperOnline (Turkcell)
echo  [4]  SuperOnline - Alternatif
echo  [5]  Kablonet
echo  [6]  Turkcell Hotspot / Mobil Veri
echo  [7]  Vodafone Hotspot / Mobil Veri
echo  [8]  Netspeed
echo.
echo  -- Icin hazir dogrulanmis preset olmayan ISS'ler --
echo  [9]  Vodafone Fiber / ADSL  (Genel Strateji Denemesi)
echo  [10] TurkNet               (Genel Strateji Denemesi)
echo  [11] Millenicom            (Genel Strateji Denemesi)
echo  [12] Turksat Kablo / D-Smart (Genel Strateji Denemesi)
echo  [13] Diger / Listede Olmayan ISS (Tum Genel Stratejiler)
echo.
echo  [0]  Cikis
echo.
echo  NOT: 9-13 arasindakiler topluluk kaynakli GENEL denemelerdir,
echo  o ISS icin ozel olarak dogrulanmamistir. Ilkinde calismazsa
echo  ayni ISS icin listedeki diger stratejileri sirayla deneyin.
echo.
set /p iss="Lutfen ISS numaranizi girin: "

if "%iss%"=="1"  (set "ISPAD=Turk Telekom" & set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000,50100 --dpi-desync=fake --dpi-desync-ttl=4" & goto ACTION)
if "%iss%"=="2"  (set "ISPAD=Turk Telekom Alternatif" & set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000,50100 --dpi-desync=fake --dpi-desync-ttl=3" & goto ACTION)
if "%iss%"=="3"  (set "ISPAD=SuperOnline" & set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000,50100 --dpi-desync=fake --dpi-desync-fooling=md5sig" & goto ACTION)
if "%iss%"=="4"  (set "ISPAD=SuperOnline Alternatif" & set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000-50099 --dpi-desync=fake --dpi-desync-fooling=md5sig --dpi-desync-ttl=3" & goto ACTION)
if "%iss%"=="5"  (set "ISPAD=Kablonet" & set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000,50100 --dpi-desync=fake --dpi-desync-ttl=4" & goto ACTION)
if "%iss%"=="6"  (set "ISPAD=Turkcell Hotspot" & set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000,50100 --dpi-desync=fake --dpi-desync-ttl=1 --dpi-desync-autottl=3" & goto ACTION)
if "%iss%"=="7"  (set "ISPAD=Vodafone Hotspot" & set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000,50100 --dpi-desync=multisplit --dpi-desync-split-pos=2" & goto ACTION)
if "%iss%"=="8"  (set "ISPAD=Netspeed" & set "ARGS=--wf-l3=ipv4,ipv6 --wf-tcp=80,443 --wf-udp=443,50000-65535 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-any-protocol=1 --dpi-desync-cutoff=d4 --dpi-desync-fake-tls=!" & goto ACTION)
if "%iss%"=="9"  (set "ISPAD=Vodafone Fiber/ADSL (Genel)" & goto GENELMENU)
if "%iss%"=="10" (set "ISPAD=TurkNet (Genel)" & goto GENELMENU)
if "%iss%"=="11" (set "ISPAD=Millenicom (Genel)" & goto GENELMENU)
if "%iss%"=="12" (set "ISPAD=Turksat Kablo / D-Smart (Genel)" & goto GENELMENU)
if "%iss%"=="13" (set "ISPAD=Diger ISS (Genel)" & goto GENELMENU)
if "%iss%"=="0" exit
goto ANAMENU

:GENELMENU
cls
echo =======================================================
echo   %ISPAD% - GENEL STRATEJI SECIMI
echo =======================================================
echo.
echo  Bu ISS icin ozel dogrulanmis bir parametre yok. Asagidaki
echo  stratejileri sirayla deneyin, calisani bulunca onu kullanin.
echo.
echo  [1] Strateji A - fake + split2 + autottl (Netspeed tipi)
echo  [2] Strateji B - fake + md5sig fooling (SuperOnline tipi)
echo  [3] Strateji C - fake + ttl=4 (Turk Telekom tipi)
echo  [4] Strateji D - fake + ttl=3
echo  [5] Strateji E - multisplit split-pos=2 (Vodafone tipi)
echo  [6] Strateji F - fake + disorder2 + autottl
echo  [7] Geri
echo.
set /p gsel="Strateji numarasini girin: "

if "%gsel%"=="1" (set "ARGS=--wf-l3=ipv4,ipv6 --wf-tcp=80,443 --wf-udp=443,50000-65535 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-any-protocol=1 --dpi-desync-cutoff=d4 --dpi-desync-fake-tls=!" & goto ACTION)
if "%gsel%"=="2" (set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000,50100 --dpi-desync=fake --dpi-desync-fooling=md5sig" & goto ACTION)
if "%gsel%"=="3" (set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000,50100 --dpi-desync=fake --dpi-desync-ttl=4" & goto ACTION)
if "%gsel%"=="4" (set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000,50100 --dpi-desync=fake --dpi-desync-ttl=3" & goto ACTION)
if "%gsel%"=="5" (set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000,50100 --dpi-desync=multisplit --dpi-desync-split-pos=2" & goto ACTION)
if "%gsel%"=="6" (set "ARGS=--wf-tcp=80,443 --wf-udp=443,50000-65535 --dpi-desync=fake,disorder2 --dpi-desync-autottl=2 --dpi-desync-repeats=6" & goto ACTION)
if "%gsel%"=="7" goto ANAMENU
goto GENELMENU

:ACTION
cls
echo =======================================================
echo   SECILEN ISS: %ISPAD%
echo =======================================================
echo.
echo  [1] Tek Seferlik Baslat (Pencereyi kapatinca kapanir)
echo  [2] Windows Servisi Olarak Kur (Arka planda kalici calisir)
echo  [3] Windows Servisini Kaldir (Sistemden tamamen temizler)
echo  [4] ISS Secimine Geri Don
echo  [5] Cikis
echo.
set /p secim="Lutfen bir islem secin (1-5): "

if "%secim%"=="1" goto TEK_SEFERLIK
if "%secim%"=="2" goto SERVIS_KUR
if "%secim%"=="3" goto SERVIS_KALDIR
if "%secim%"=="4" goto ANAMENU
if "%secim%"=="5" exit
goto ACTION

:TEK_SEFERLIK
cls
echo %ISPAD% ayarlariyla baslatiliyor...
echo Pencereyi kapattiginizda bypass durur.
echo.
winws.exe %ARGS%
pause
goto ACTION

:SERVIS_KUR
cls
echo %ISPAD% icin Windows Servisi olarak kuruluyor...
echo.

:: Once ayni isimde eski bir servis var mi kontrol et, varsa temizle
sc query %SERVICE_NAME% >nul 2>&1
if %errorlevel% equ 0 (
    echo Eski %SERVICE_NAME% servisi bulundu, durduruluyor ve siliniyor...
    net stop %SERVICE_NAME% >nul 2>&1
    sc delete %SERVICE_NAME% >nul 2>&1
)

echo Yeni %SERVICE_NAME% servisi olusturuluyor...
sc create %SERVICE_NAME% binPath= "\"%EXE_PATH%\" %ARGS%" DisplayName= "Zapret DPI Bypass - %ISPAD%" start= auto

if %errorlevel% neq 0 (
    echo.
    echo [HATA] Servis olusturulamadi. Hata kodu: %errorlevel%
    pause
    goto ACTION
)

sc description %SERVICE_NAME% "Zapret DPI bypass yazilimi - %ISPAD%" >nul 2>&1
sc start %SERVICE_NAME%

if %errorlevel% equ 0 (
    echo.
    echo Islem tamamlandi! Zapret artik bilgisayar her acildiginda arkada otomatik calisacak.
) else (
    echo.
    echo [UYARI] Servis olusturuldu ama baslatilamadi. Hata kodu: %errorlevel%
    echo Bilgisayari yeniden baslatinca otomatik calisabilir, ya da servisi elle baslatmayi deneyin.
)
pause
goto ACTION

:SERVIS_KALDIR
cls
echo Zapret Windows Servisi kaldiriliyor...
echo.

sc query %SERVICE_NAME% >nul 2>&1
if %errorlevel% neq 0 (
    echo %SERVICE_NAME% servisi bulunamadi. Zaten kaldirilmis olabilir.
    pause
    goto ACTION
)

net stop %SERVICE_NAME% >nul 2>&1
sc delete %SERVICE_NAME%

if %errorlevel% equ 0 (
    echo.
    echo Servis basariyla kaldirildi ve sistem temizlendi.
) else (
    echo.
    echo [HATA] Servis kaldirilamadi. Hata kodu: %errorlevel%
)
pause
goto ACTION
