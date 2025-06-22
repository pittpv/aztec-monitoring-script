# Aztec Node İzleme Aracı

**Açıklama:**
- [🌐 English Version](https://github.com/pittpv/aztec-monitoring-script/blob/main/en/ "Açıklamanın İngilizce versiyonu")
- [🇷🇺 Russian Version](https://github.com/pittpv/aztec-monitoring-script/blob/main/ "Açıklamanın Rusça versiyonu")

![Bash](https://img.shields.io/badge/Bash-5.2-blue)
![Docker](https://img.shields.io/badge/Docker-20.10+-blue)
![Telegram](https://img.shields.io/badge/Telegram-API-blue)

![Ana Ekran](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/img-tr-2025-06-06-13-19-12.png)

## 📝 Açıklama

Bu betik, Aztec node’unuzu izlemek için kapsamlı bir çözüm sunar: konteyner durumu kontrolü, blok senkronizasyon doğrulaması ve Telegram bildirimleri dahil.

## 🌟 Temel Özellikler

* 🐳 Aztec konteyner izleme
* 🔗 Blok güncelliği kontrolü (akıllı kontratla karşılaştırma)
* 🔍 Log analizi ile kritik parametre kontrolü
* 📨 Sorunlar için Telegram uyarıları
* ⏰ Otomatik izleme için cron görevi

## 🛠️ İşlevsellik

| Özellik         | Açıklama                                       |
| --------------- | ---------------------------------------------- |
| ✅ **Konteyner** | Aztec Docker konteyner durumunu izler          |
| 🔄 **Bloklar**  | Yerel blok yüksekliğini zincirle karşılaştırır |
| 🤖 **Telegram** | Telegram üzerinden anlık uyarılar              |
| 🌐 **Diller**   | Dil desteği İngilizce/Rusça/Türkçe                 |
| ⚙️ **RPC**      | Esnek RPC uç noktası yapılandırması            |

## 📌 Son Güncellemeler 22-06-2025  
- Aztec logları artık son 500 satırı gösteriyor (otomatik yenileme özelliği ile).  
- Konteyner/blok kontrolü artık logları daha verimli işliyor.  
- Bağımlılık kontrolü ve otomatik kurulum iyileştirildi.   

---

<details>
<summary>📅 Sürüm Geçmişi</summary>

### 06-06-2025

- Telegram bildirimleri de dahil olmak üzere betik tamamen üç dile yerelleştirildi. Türkçe dili eklendi.
- Docker ile **Watchtower** kullanarak Aztec node kurulum özelliği eklendi. Watchtower, yapılandırmaları koruyarak node konteynerini otomatik olarak güncellemeye ayarlanmıştır.
  - Bağımlılıkların kurulumu
  - Docker ve Docker Compose'un varlığının kontrolü ve gerekirse kurulumu
  - Varsayılan portların kullanılabilirliğinin kontrolü, portları değiştirme seçeneği ile
  - Node’un en son binary dosyasının kurulumu
  - `.env` ve `docker-compose` dosyalarının otomatik oluşturulması
  - ufw üzerinden portlarının açılması
  - Node’un başlatılması ve ilk logların gösterimi 
- Aztec düğümünü silme işlevi eklendi 

### 05-06-2025

* Watchtower uyumluluğu güncellendi

### 04-06-2025

* Gelişmiş blok numarası arama (Seçenek 1 ve cron ajanı), debug seviyesindeki günlüklerde çalışır. Tüm log seviyeleriyle (debug, info vb.) uyumludur.
* Blok doğrulama hata yönetimi geliştirildi
* Log’ları doğrudan betikten görüntüleme seçeneği eklendi (Ctrl+C ile çıkılır)
* Seçenek 1 çalıştırıldığında log’tan blok numarası gösterimi eklendi
* Sürüm kontrolü eklendi – yeni sürüm varsa kullanıcı bilgilendirilir
* Küçük iyileştirmeler

### 02-06-2025

* Farklı Aztec node sürümleriyle daha iyi uyumluluk için log filtreleri güncellendi
* RPC/cast hataları için loglama eklendi
* Betik sürüm bilgisi loglanıyor

### 01-06-2025

* Docker ve CLI tabanlı Aztec node’larıyla uyumluluk sağlandı
* "block NNNN" formatındaki yeni log desteği eklendi
* Seçenek 9 için `bc` yardımcı aracının otomatik kurulumu
* Analizden önce ANSI kodlarının temizlenmesi
* Log’larda PeerID tespiti düzeltildi
* Blok hex değeri işleme optimize edildi
* Telegram bildirim sistemi geliştirildi

### 30-05-2025

* Doğrulayıcı kontrol işlevi eklendi. Tüm doğrulayıcıları analiz eder, belirli doğrulayıcıları gösterir ve tam listeyi sunar.
* Eğer node portu değiştirildiyse, kanıt üretimi için özel port yapılandırma desteği eklendi.

### 29-05-2025

* Log dosyası 1 MB’a ulaştığında temizlenir, ilk rapor saklanır.

</details>

## ⚙️ Kurulum ve Başlatma

1. **Gereksinimler**:
   Betik, gerekli bileşenleri kontrol eder ve eksikse yüklemeyi önerir.

2. **Başlatma veya Güncelleme**:

```bash
curl -o aztec-logs.sh https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/aztec-logs.sh && chmod +x aztec-logs.sh && ./aztec-logs.sh
```

Sonraki çalıştırmalar için:

```bash
cd $HOME && ./aztec-logs.sh
```

3. **Talimatları izleyin**:

   * Dil seçin
   * RPC URL’sini girin
   * Telegram bot’unu yapılandırın
   * İzlemeyi etkinleştirin

## 🖥️ Kullanım

Ana menü:

1. 🔍 Konteyner ve blokları kontrol et
2. ⚙️ İzleme ajanını kur
3. 🗑️ İzleme ajanını kaldır
4. 🏷️ rollupAddress bul
5. 👥 PeerID bul
6. 🏛️ governanceProposerPayload bul
7. 🔗 Proven L2 Block kontrol et *(Discord'da Apprentice rolü almak için veri)*
   - Artık kendi portunuzu ayarlayabilirsiniz (varsayılan 8080). Yeni port .env-aztec-agent dosyasına kaydedilir.
8. 🔌 RPC URL’sini değiştir
9. 🔍 Doğrulayıcı ara ve durumunu kontrol et
10. Aztec loglarını görüntüle
11. Watchtower ile birlikte Aztec Node Kurulumu
12. Aztec düğümünü sil
0. 🚪 Çıkış

## 🚀 Cron Ajanı Kullanımı

Betik çalıştırıldıktan sonra, **Cron izleme ajanını kur** seçeneğini seçin:

* \~/aztec-monitor-agent dizininde ajan oluşturur
* Bir cron görevi kurar
* Telegram'a ilk durum güncellemesini gönderir
* Node’u sürekli izler, \~/aztec-monitor-agent/agent.log dosyasına log yazar
* Aşağıdaki durumlarda Telegram’a uyarı gönderir:

  * Aztec konteyneri bulunamadıysa
  * Log’lardaki en son blok ile akıllı kontrattaki blok **> 3 blok** fark varsa
  * RPC sunucusunda sorun varsa
* Log dosyası 1 MB’a ulaştığında temizlenir, ilk rapor saklanır

### Cron Ajanı Gereksinimleri:

1. [BotFather](https://t.me/BotFather) üzerinden bir Telegram token alın
2. [IDBot](https://t.me/myidbot) ile chat\_id’nizi öğrenin
3. Kurulum sırasında bu bilgileri girin
   Betik hem token hem de chat ID’yi doğrular – yanlış girilirse uyarı alırsınız

### Cron ajanını güncelleme

Ajan güncellemesi varsa, önce betiğin tamamını güncelleyin. Sonra eski ajanı silin ve yenisini oluşturun.

## ⚠️ Önemli

Bu betik Aztec Network’ün resmi ürünü değildir ve “olduğu gibi” sunulmaktadır.

## 📜 Lisans

MIT Lisansı © 2025

## ✍️ Geri Bildirim

Sorularınız, önerileriniz veya geri bildirimleriniz için:

[https://t.me/+DLsyG6ol3SFjM2Vk](https://t.me/+DLsyG6ol3SFjM2Vk)

## 🔗 Faydalı Bağlantılar

[Tek tıkla RPC kurulum betiği](https://github.com/pittpv/sepolia-auto-install "Sepolia node'unu hızlıca RPC için kurun")
