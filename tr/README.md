# Aztec Node Kurulum ve İzleme Betiği (yeni testnet)

**Açıklama Dilleri:**
- [🇷🇺 Rusça Versiyon](https://github.com/pittpv/aztec-monitoring-script/blob/main/ "Rusça açıklama")
- [🇹🇷 Türkçe Versiyon](https://github.com/pittpv/aztec-monitoring-script/blob/main/tr/ "Türkçe açıklama")

![Bash](https://img.shields.io/badge/Bash-5.2-blue)
![Docker](https://img.shields.io/badge/Docker-20.10+-blue)
![Telegram](https://img.shields.io/badge/Telegram-API-blue)

![Ana Ekran](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/img-en-2025-05-25-05-44-01.png)

## 📝 Açıklama

Bu betik, bir Aztec düğümünü çalıştırmak (docker-compose veya CLI) ve izlemek için otomatik güncellemeler, konteyner durumunu kontrol etme, blok senkronizasyonu, düğüm hakkında önemli bilgiler alma ve Telegram'a bildirim gönderme dahil olmak üzere eksiksiz bir çözüm sunar.

Ayrıca, spoiler altındaki Sürüm Geçmişine de göz atın, betiğin işlevleri hakkında birçok yararlı bilgi bulunmaktadır.

## 🌟 Temel Özellikler

* 🏃🏻‍ Düğüm başlatma (docker-compose veya CLI)
* 🐳 Aztec düğümünün çalışmasının izlenmesi
* 🔗 Blok tazelik kontrolleri (akıllı sözleşmeyle karşılaştırmalı)
* 🔍 Kritik parametreler için günlük ayrıştırma
* 📨 Sorunlar ve doğrulayıcı aktivitesi hakkında Telegram uyarıları
* ⏰ Otomatik izleme için systemd servisi

## 🛠️ İşlevsellik

| Özellik          | Açıklama                                       |
| ---------------- | ------------------------------------------------- |
| ✅ **Konteyner**  | Aztec Docker konteynerının durumunu izler |
| 🔄 **Bloklar**    | Yerel blok yüksekliğini zincir üzerindeki yükseklikle karşılaştırır  |
| 🤖 **Telegram**  | Telegram üzerinden anlık sorun uyarıları                 |
| 🌐 **Diller** | Dil desteği İngilizce/Rusça/Türkçe                  |
| ⚙️ **RPC**       | Esnek RPC uç noktası yapılandırması               |

## 📌 Son Güncellemeler 20-11-2025

⚠️ **Tam node yeniden kurulumu gereklidir. Kurulumdan önce verileri hazırlayın!**
BLS anahtarlarıyla multivalidator modu için format: `private_key,address,private_bls,public_bls`
BLS anahtarları olmadan multivalidator modu için format: `private_key,address`
Tek validator modu için aynı veriler ayrı ayrı sağlanır.

- Node kurulumu sırasında testnet/mainnet ağı seçimi
  - NETWORK değişkenine .env-aztec-agent dosyasında yazılır
  - docker-compose.yml dosyasına eklenir
  - Script parametreleri ağa göre değişir
- BLS anahtarlarıyla validator eklemek için yeni yöntem
  - web3signer için BN254 tipi yml dosyalarının otomatik oluşturulması
  - Multi-validator ve solo mod desteği
- keystore.json yapısı güncellendi
  - `slasher` kaldırıldı
  - `attester`: basit bir string yerine eth alanı içeriyor
  - `publisher`: Artık string dizisidir
  - `coinbase`: artık keystore şemasında, env ve docker-compose.yml dosyalarından kaldırıldı
- Yeni keystore.json yapısına göre BLS oluşturma fonksiyonları güncellendi
  - Public BLS anahtarlarının kaydedilmesi uyarısı
- BLS'yi keystore’a taşımak için fonksiyon eklendi – Seçenek 18-3
  - bls-filtered-pk.json dosyasından göç verilerinin alınması, karşılaştırılması ve private BLS anahtarının kendi attester’ına eklenmesi
- Yeni Docker sürümlerini desteklemek için watchtower imaj URL’si güncellendi
- Sözleşmeden validator istatistikleri alma fonksiyonu güncellendi
  - Reward gösterimi eklendi
- Validator kuyruğu izleme fonksiyonu güncellendi (izlemeyi yeniden oluşturun)
  - Aktif sette bulunma kontrolü eklendi
  - API sorunları veya kuyruktan çıkma ile ilgili diğer sebepler için bildirim eklendi
  - İndeks eklendi
- İlk RPC isteğinde çeviriye eklendi – Ethereum RPC URL’sini girin

<details>
<summary>📅 Sürüm Geçmişi</summary>

### 13-11-2025

- Eski doğrulayıcı özel anahtarından yeni bir operatör oluşturma yöntemi eklendi (bu betik aracılığıyla düğüm kurulumu gereklidir, seçenek 11)
  - çoklu doğrulayıcı modu desteği
  - eski özel anahtarlardan yeni adres, özel ve BLS anahtarlarının oluşturulması
  - yeni anahtarlar oluşturmak için eski özel anahtarları hangi sırayla girerseniz girin, keystore.json dosyasındaki adres sırasına göre doğru veri sıralaması.
- Stake fonksiyonu güncellemesi
  - seçilen BLS anahtarı oluşturma yönteminin otomatik algılanması
  - yeni adresler oluşturulurken keystore.json içindeki doğrulayıcı adresinin otomatik olarak değiştirilmesi
  - özel anahtarların yeni yml dosyalarının otomatik oluşturulması
  - keystore.json yedeklemesi
  - web3signer’ın otomatik yeniden başlatılması
  - gönderimden önce stake komutunun önizlemesi
- Doğrulayıcı Arama ve Durum Kontrolü işlevi güncellendi (**Seçenek 9**)
  - Doğrulayıcı Sıra İzleme işlevi geri yüklendi**
  - Doğrulayıcı Sıra İzleme işlevini silmek için bir işlev eklendi
  - Dashtec.xyz'deki test ağında sıralayıcı verilerini görüntülemek için yeni URL
  - Onaylayıcı ve çıktı adresinin yanı sıra işlem karma değerini kolayca kopyalayın
- Yuva istatistiklerini izleme
  - Sıralayıcı sayfası için yeni URL
- Ana betikte küçük iyileştirmeler
- İzleme aracı betiğinde küçük iyileştirmeler
- Düğüm kurulum betiğinde küçük iyileştirmeler

### 08-11-2025
- Yeni sözleşme için tam destek
  - izleme
  - node kurulumu
  - doğrulayıcı kontrolü ve arama
  - doğrulayıcı kuyruğunun izlenmesi
- Eski sıralaıcınız için mnemonic ifadeden BLS anahtarları oluşturma (bu betik aracılığıyla node kurulumu gereklidir)
  - tek bir mnemonic’ten birden fazla adres desteği
  - gereksiz anahtarların otomatik filtrelenmesi ve silinmesi
- Stake onaylama fonksiyonu (bu betik aracılığıyla node kurulumu gereklidir)
- Stake etme — doğrulayıcı ekleme fonksiyonu (bu betik aracılığıyla node kurulumu gereklidir)

### 04-10-2025
⚠️ Lütfen eski izleme aracını silin (seçenek 3'ü kullanın) ve yeni aracı yükleyin (seçenek 2'yi kullanın)

- Yeni slot istatistik bildirim sistemi
    - Artık istatistikler doğrudan mesaj içinde canlı slotlar olarak güncelleniyor. 25 mesaj yerine yalnızca bir mesaj
    - Birden fazla doğrulayıcı desteği. Her doğrulayıcı için kendi durum mesajı
    - Geri dönüş (fallback) desteği. İlk mesaj güncellenirken bir hata oluşursa, betik yeni bir mesaj gönderecek.
- Kurulum betiğinde güncelleme, IP adresini belirlemenin yeni yöntemi.
    - Sanal makineye sahip bir sunucuda düğüm kurulurken P2P_IP için IP adresi yerel olarak algılanıyordu, bu da düğümün düzgün çalışmasını engelliyordu. Eğer VPN yapılandırıldıysa, P2P_IP için gerçek IP adresini manuel olarak belirtin.
- Kritik hata izleme modülü tarafından algılanacak hata dosyasında güncelleme
    - Düğüm BEACON RPC’den BLOB verilerini almadığında eklenen hata durumu

### 20-09-2025
- Kuyruktaki doğrulayıcı izlemeyi arama ve kurma işlevi (9. seçenek) çalışıyor.
    - Cloudflare atlatma eklendi
- Eksik çeviriler eklendi
- Yeni gerekli bileşenler: Python ve curl\_cffi.
    - Betik, eksik bileşenleri yüklemeyi önerecek
- **curl_cffi** kurulumu için düzeltme. Bazı kullanıcılar curl_cffi kurulumunda şu sorunla karşılaştı: `/usr/bin/python3: No module named pip` veya `error: externally-managed-environment`
- Kritik hata kontrol modülü tarafından tespit edilmesi için yeni hatalar eklendi

Çözüme dair ipucu için `@xtoun` (Discord)’a ve test eden herkese çok teşekkürler.

### 17-09-2025
- Yeni ağ ve testnet için tam destek.
- Yeni düğüm kurulum betiği.
  - Web3signer için YML anahtar dosyalarının otomatik oluşturulması.
  - Web3signer kurulumu ve başlatılması.
  - Keystore.json anahtar şemasının otomatik oluşturulması.
  - Çoklu doğrulayıcı modu desteği (düğüm başına 10'a kadar).
  - Tüm doğrulayıcılar için bir ortak yayıncı adresi atama veya her birinin kendi adresini kullanma (attester ile aynı) yeteneği.
  - Tüm önceki özellikler (gerekli yazılımların otomatik kurulumu, port kontrolleri, özel port atama yeteneği, doğrulamalar).
- Düğüm için yeni izleme aracı betiği (seçenek 2).
  - Tüm durum türlerini (✅ onaylama, ❌ onaylama, ⛏️ Blok kazıldı, 📤 Blok önerildi, ⚠️ Blok kaçırıldı) içeren slot bazlı istatistiklerle yeni Telegram bildirimleri.
  - Çoklu doğrulayıcı modu (komiteye katılan tüm doğrulayıcılar için istatistikler) ve tek doğrulayıcı modu desteği.
  - DEBUG modu – oldukça ayrıntılı izleme günlükleri almayı sağlar. Günlük /root/aztec-monitor-agent/agent.log dosyasına yazılır. Etkinleştirmek için /root/.env-aztec-agent içinde DEBUG=true yapın (varsayılan false).
  - Kontroller bir systemd zamanlayıcısı ile tam olarak her 37 saniyede bir (bir slotun yaklaşık süresi) çalışır – hiçbir durumu kaçırmazsınız!
- Tüm önceki özellikler (senkronizasyon kontrolü, kritik hata tespiti, hızlı günlük görüntüleme, otomatik güncellemeler, düşürme işlevi, konteyner yönetimi ve daha fazlası).
- Rollup ve GSE sözleşmelerinde doğrudan doğrulayıcı arama ve doğrulama için yeni betik (seçenek 9).
  - Hızlı doğrulayıcı arama ve durum kontrolü.
  - Tek bir istekte birden çok doğrulayıcının kontrolünü destekler.
  - Ağdaki aktif doğrulayıcıların tam sayısı.
  - Her zaman güncel bilgiler.
- Güncellenmiş betik sürüm kontrol işlevi. Artık yeni sürümler ve güncellemeler hakkında kısa açıklamalar gösteriliyor.
- Kritik hata kontrol modülü tarafından tespit edilen yeni hatalar eklendi, düzeltme yönergeleri ve Telegram bildirimleri ile birlikte.
- Diğer özelliklere yönelik küçük iyileştirmeler

### 21-08-2025
- PeerID arama işlevi güncellendi (işlev geri yüklendi + yeni özellikler)
  - Betik, günlüklerde düğümün PeerID'sini bulur
  - Mevcut Nethermind.io verileri arasında arar
  - Mevcut Nethermind.io verilerinde bulunamazsa, arşivde arar
- Cron aracı oluşturma işlevi güncellendi
  - Artık komite dahil etme bildiriminde, doğrulayıcı adresine tıklayarak dashtec.xyz'deki sayfasına gidebilirsiniz.
- Aztec düğüm kurulum betiği güncellendi
  - Ufw aktivite kontrolü eklendi.
  - Ufw aktifse, 8080 ve 40400 portları için kurallar eklenir, aksi takdirde kurallar eklenmez.

### 06-08-2025
- Doğrulayıcı kuyruğu kontrol işlevi geri yüklendi.

### 02-08-2025
- Doğrulayıcı komite dahil etme kontrol işlevi güncellendi (işlev geri yüklendi)
  - Birden fazla doğrulayıcı adresi belirtilebilir

### 01-08-2025
- Doğrulayıcı kontrol betiği güncellendi. Kontrol modları eklendi.
  - Hızlı işleme – yüksek CPU yükü
  - Yavaş işleme – CPU yükü yok
- Aztec düğüm sürüm kontrolü, betik yüklenirken zaman kaybını önlemek için ayrı bir menü öğesine taşındı.

### 29-07-2025
- Aztec Düğüm Güncelleme işlevi eklendi. İşlev, Watchtower'dan otomatik güncellemeleri beklemek yerine düğümü anında günceller.
  - Ayrıca, bir düşürme işlemi yaptıysanız ve geri dönmek istiyorsanız bu seçeneği kullanın.
  - `docker-compose.yml` dosyasını kontrol eder ve etiketi `latest` ile değiştirir
- Aztec Düğüm Düşürme işlevi eklendi. İşlev, Docker Hub'daki tüm düğüm sürümlerini gösterir, listeden seçilen herhangi bir sürüme geri dönüşe izin verir.
  - İstenilen sürümün seçimi
  - `docker-compose.yml` dosyasının güncellenmesi
  - Konteynerlerin durdurulması, indirilmesi ve başlatılması

### 28-07-2025
- Watchtower ile Aztec düğüm kurulum betiği güncellendi. Kurulum sırasında betik soracaktır: "Birden fazla doğrulayıcı çalıştırmak istiyor musunuz? (y/n)"
  - Çoklu doğrulayıcı modunda kurulum (düğüm başına 10'a kadar doğrulayıcı)
  - Tek doğrulayıcı modunda kurulum

### 21-07-2025
- CLI'de düğüm başlatma komutu güncellendi (validatorPrivateKey**s**) 1.1.0 ve üzeri düğüm sürümleri için
- CLI'de düğüm içeren eski ekran oturumlarını kontrol etme ve yeni bir oturum oluşturmadan önce silme işlevi eklendi.
- Rollup sözleşme adresi güncellendi.

### 15-07-2025
- **Doğrulayıcılar** için Telegram bildirim sistemi geliştirildi. Fikir için teşekkürler @malbur187 (Discord)
  - Düğüm izleme cron aracı kurulurken, artık hangi bildirimleri alacağınızı seçebilirsiniz: sadece hatalar veya ayrıca komite seçimi ve blok oluşturma uyarıları.
  - Seçim `.env-aztec-agent` dosyasına kaydedilir ve sonraki araç yeniden oluşturmalarında uygulanır. Değiştirmek için `.env-aztec-agent` dosyasını düzenleyin.
- Kritik hata tespiti eklendi. Düğüm günlüklerinde kritik bir hata bulunursa, bir Telegram bildirimi gönderilir.
  - Hata dizisi, birleşik bir JSON dosyası aracılığıyla güncellenir, yeni hataların ve çözümlerinin hızlı bir şekilde eklenmesine olanak tanır.
- PeerID arama işlevi güncellendi. Fikir için teşekkürler @web3.creed (Discord)
  - Başarılı günlük tespitinden sonra, PeerID genel veritabanı `aztec.nethermind.io`'da kontrol edilir ve sonuç gösterilir.
- Küçük iyileştirmeler

### 25-06-2025
- "Aztec Düğüm Konteynerlerini Durdur" işlevi eklendi – akıllı bir işlev, düğüm konteynerini çalıştırma yönteminizi (docker-compose veya CLI) hatırlar ve seçilen modda çalışmaya devam eder.
  - Çalışma yöntemi sorulduğunda, düğümünüzün nasıl çalıştığını belirtin: `docker-compose` veya `CLI`
  - Docker-compose dosyasının yolu sorulduğunda, kök dizinden itibaren yolu şu biçimde verin: `/root/aztec` veya `./aztec`
  - Tüm ayarlar `.env-aztec-agent` dosyasına kaydedilir. İsterseniz değiştirebilirsiniz.
- "Aztec Düğüm Konteynerlerini Başlat" işlevi eklendi – "Aztec Düğüm Konteynerlerini Durdur" işlevinde (seçenek 13) atanan konteyner çalıştırma yöntemini kullanan akıllı bir işlev.
  - **Konteyner yönetim yöntemini ayarlamadıysanız** (seçenek 13) ve "Aztec Düğüm Konteynerlerini Başlat" işlevini kullanırsanız, **bir CLI düğümü başlatma sihirbazı** olarak çalışacaktır. Bu durumda, betik gerekli CLI başlatma parametrelerini soracak, komutu oluşturacak ve CLI düğümünü bir ekran oturumunda başlatacaktır.
  - Tüm ayarlar `.env-aztec-agent` dosyasına kaydedilir. İsterseniz değiştirebilirsiniz.
- Cron-agent oluşturma işlevi güncellendi – artık ChatID ve Telegram token'ı `.env-aztec-agent` dosyasına kaydediliyor ve cron-agent'ı kaldırırken/oluştururken yeniden girilmesi gerekmiyor.
- Betik yüklendiğinde Aztec Düğüm sürüm kontrolü eklendi.

### 22-06-2025
- Aztec günlüklerini görüntüleme işlevi – otomatik yenileme ile son 500 satırı gösterecek şekilde güncellendi.
- Konteyner ve mevcut blok kontrol işlevi - günlük okuma iyileştirildi ve bellek sorunlarının önlenmesi sağlandı
- Gerekli betik araçları için geliştirilmiş bağımlılık kontrolü ve kurulumu.

### 06-06-2025

- Betiğin ve Telegram bildirimlerinin tam yerelleştirmesi, üç dilde yapıldı. Türkçe dili eklendi.
- Docker ve **Watchtower** ile Aztec düğümü kurma işlevi eklendi. Watchtower, yapılandırmayı korurken düğüm konteynerini otomatik olarak güncellemek üzere yapılandırılmıştır.
  - Bağımlılıkların kurulumu
  - Docker ve Docker Compose kontrolü ve gerekirse kurulumu
  - Varsayılan portların kullanılabilirliğinin kontrolü ve gerekirse portları değiştirme seçeneği.
  - En son düğüm ikilisinin kurulumu
  - `.env` ve `docker-compose` dosyalarının otomatik oluşturulması
  - UFW'de portların açılması
  - Düğümün başlatılması ve ilk günlüklerin gösterilmesi
- Aztec düğümünü silme işlevi eklendi

### 05-06-2025
- Watchtower uyumluluğu için güncelleme

### 04-06-2025
- Hata ayıklama düzeyi günlüklerinde blok numarası arama mekanizması (Seçenek 1 ve cron aracı) geliştirildi. Hata ayıklama, bilgi (ve muhtemelen diğer tüm) günlük düzeylerini destekler. Maksimum doğru arama sonuçları.
- Geliştirilmiş blok doğrulama hata işleme
- Yeni bir seçenek eklendi – Betikten doğrudan düğüm günlüklerini görüntüleme (Günlüklerden çıkmak için Ctrl+C)
- Seçenek 1 çalıştırılırken günlüklerden blok numarası çıktısı eklendi.
- Betik sürüm kontrolü eklendi. Güncellemeler varsa, betik sizi bu konuda bilgilendirecektir.
- Küçük iyileştirmeler

### 02-06-2025
- Farklı Aztec düğüm sürümleriyle daha iyi uyumluluk için günlük okuma filtre değerleri güncellendi
- RPC/cast hataları için günlüğe kaydetme eklendi
- Betik sürüm günlüğü eklendi

### 01-06-2025
- Geliştirilmiş uyumluluk. Betik artık hem Docker tabanlı hem de CLI Aztec düğümleriyle çalışıyor
- Yeni günlük formatı "block NNNN" için destek eklendi
- Seçenek 9'daki hesaplamalar için `bc` yardımcı programının otomatik kontrolü ve kurulumu
- Daha güvenilir veri ayrıştırma için analiz öncesi ANSI kodlarının kaldırılması
- Günlüklerde PeerID tespiti sorunu düzeltildi
- Blok onaltılık değerlerinin işlenmesi optimize edildi
- Telegram bildirim sistemi geliştirildi

### 30-05-2025
- Doğrulayıcı kontrol işlevi eklendi. Tüm doğrulayıcıları analiz eder, belirli olanlar için bilgi gösterir, tam listeyi görüntüler.
- İspat oluşturma seçeneği için Aztec düğümü özel port kurulumu. Bu, kurulum sırasında düğüm portunu değiştirdiyseniz gereklidir.

### 29-05-2025
- 1 MB'a ulaşıldığında günlük dosyası temizleme, ilk rapor korunur.
</details>


---

## ⚙️ Kurulum ve Başlatma

1. **Gereksinimler**:
   Betik, gerekli bileşenleri kontrol edecek ve eksik olanları kurmayı teklif edecektir.

2. **Başlatma veya Güncelleme**:

   ```bash
   curl -o aztec-logs.sh https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/aztec-logs.sh && chmod +x aztec-logs.sh && ./aztec-logs.sh
   ```

   Gelecekteki çalıştırmalar için:

   ```bash
   cd $HOME && ./aztec-logs.sh
   ```

3. **Talimatları izleyin**:

  * Bir dil seçin
  * RPC URL'sini girin
  * Telegram botunu yapılandırın
  * İzlemeyi etkinleştirin (seçenek 2)

## 🖥️ Kullanım

Ana menü:

1. 🔍 Konteyner ve düğüm senkronizasyonunun kontrol et
2. ⚙️ Bildirimlerle düğüm izleme aracısını yükleyin
3. 🗑️ Düğüm izleme aracısını ve dosyalarını kaldırın
4. 🏷️ Loglarda rollupAddress bul
5. 👥 Loglarda PeerID bul
6. 🏛️ Loglarda governanceProposerPayload bul
7. 🔗 Kanıtlanmış L2 Bloğunu ve Sync Proof'u Kontrol Et *(daha önce Discord'da Çırak rolü almak için gereken veriler)*
   - Artık kendi portunuzu ayarlayabilirsiniz (varsayılan port 8080). Yeni port numarası .env-aztec-agent ortam dosyasına kaydedilecektir.
8. 🔌 RPC URL'sini değiştir
9. 🔍 Validator ara ve durumunu kontrol et
10. Aztec loglarını görüntüle
11. Watchtower ile birlikte Aztec Node Kurulumu
12. Aztec düğümünü sil
13. Aztec düğüm konteynerlerini durdur
14. Aztec düğüm konteynerlerini başlat
15. Aztec düğümünü güncelle
16. Aztec düğümünü eski sürüme düşür
17. Aztek sürümünü kontrol edin
18. BLS anahtarları oluştur
19. Approve
20. Stake

0. 🚪 Çıkış

## 🚀 Düğüm İzleme Aracını Kullanma

Betiği çalıştırdıktan sonra `Bildirimlerle düğüm izleme aracısını yükleyin` seçeneğini seçin:

- `~/aztec-monitor-agent` konumunda bir aracı oluşturur
- Bir systemd servisi ve zamanlayıcısı kurar (her 37 saniyede bir çalışır)
- Telegram'a bir başlangıç durum güncellemesi gönderir
- Düğümü sürekli izler ve günlükleri `~/aztec-monitor-agent/agent.log` dosyasına kaydeder
- Aşağıdaki durumlarda Telegram uyarıları gönderir:
  - Aztec konteyneri bulunamazsa
  - Günlüklerdeki en son blok ile akıllı sözleşmedeki blok arasında **> 3 blok** uyuşmazlık varsa
  - RPC sunucusu sorunu varsa
  - Kritik hatalar bulunursa
  - Komiteye seçilirse
  - Doğrulayıcı komitedeyken her slot için istatistikler (başarılı/kaçırılmış onaylama, önerilen/kazılmış/kaçırılmış blok)
- Günlük dosyası boyutu 1 MB'a ulaştığında temizler, en ilk raporu kaydeder.

### İzleme Aracı Gereksinimleri:

1. [BotFather](https://t.me/BotFather)'dan bir Telegram token'ı alın
2. [IDBot](https://t.me/myidbot) kullanarak `chat_id`nizi bulun
3. Bunları cron-agent kurulumu sırasında betiğe girin.
   Betik hem token'ı hem de chat ID'sini doğrular — yanlış girilirse bir uyarı görürsünüz.

### İzleme Aracını Güncelleme

Cron-agent için bir güncelleme varsa, önce tüm betiği güncelleyin. Ardından eski aracı silin ve yeni bir tane oluşturun. Daha önce girdiğiniz ChatID ve Telegram token'ı otomatik olarak yeni araca atanır.

## 🚀 Aztec v 2.1.7 düğümünü kurma

Aztec düğümünü kurmak için **seçenek 11**'i seçin ve betik talimatlarını izleyin.

Düğüm kurulum sürecinin adım adım açıklaması burada bulunabilir: [Aztec-Install-by-Script.md](https://github.com/pittpv/aztec-monitoring-script/blob/main/tr/Aztec-Install-by-Script.md)

## ⚠️ Önemli

Bu betik, Aztec Network'ün resmi bir ürünü değildir ve "olduğu gibi" sağlanmıştır.

## 📜 Lisans

MIT Lisansı © 2025

## ✍️ Geri Bildirim

Herhangi bir sorun, öneri veya geri bildirim için:

[https://t.me/+DLsyG6ol3SFjM2Vk](https://t.me/+DLsyG6ol3SFjM2Vk)

## 🔗 Yararlı Bağlantılar

[Tek tıklamayla RPC kurulum betiği](https://github.com/pittpv/sepolia-auto-install "RPC için hızlı bir şekilde Sepolia düğümü kurun")
