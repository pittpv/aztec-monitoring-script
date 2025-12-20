# Pittpv'nin Betiği ile Aztec Düğümü Kurulumu

Bu rehber, **pittpv**'nin kullanışlı izleme ve yönetim betiğini kullanarak hızlı ve kolay bir şekilde bir Aztec düğümü dağıtmanıza yardımcı olacaktır. Betik, rutin görevlerin çoğunu otomatikleştirerek hata riskini en aza indirir.

## Betiği Başlatma

Betiği ilk kez çalıştırmak için terminalinizde aşağıdaki tek satırlık komutu çalıştırın:

```bash
curl -o aztec-logs.sh https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/aztec-logs.sh && chmod +x aztec-logs.sh && ./aztec-logs.sh
```

> **Önemli:** Sonraki tüm başlatmalar için şu komutu kullanın:
> ```bash
> cd $HOME && ./aztec-logs.sh
> ```

## İlk Kurulum

Betik başlatıldıktan sonra, gerekli sistem yazılımlarını (`docker`, `docker-compose`, `jq` vb.) kontrol edecek ve eksikse kurmayı teklif edecektir. `y` (evet) yanıtını vererek **kurulumu kabul edin**.

Betiğin ana menüsünde size bir seçenek listesi sunulacaktır. Düğüm kurulumuna başlamak için:

1.  **Ana menüden `11` numaralı öğeyi seçin ve Enter'a basın.**

    ![Betik Ana Menüsü](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/1.jpg)

## Port Kontrolü ve Bağımlılık Kurulumu

Betik, düğümün çalışması için gereken portların (40400, 8080) meşgul olup olmadığını otomatik olarak kontrol edecektir. Meşgullerse, farklı portlar atamayı teklif edecektir, ancak mümkünse **standart portları kullanmanız önerilir**.

Ardından, Aztec düğümüne özel yazılımları kontrol edecek ve yeniden kurmayı teklif edecektir. **Kurulumu kabul edin**.

> **Not:** Sunucunuzda `ufw` güvenlik duvarı etkinse, betik gerekli tüm portları otomatik olarak açacaktır.

## İkili Dosyaları ve Docker Görüntüsünü Kurma

Bu aşamada, betik, Aztec ekibinin orijinal betiğini kullanarak düğüm bileşenlerinin indirilmesini ve kurulmasını başlatacaktır.

**Dikkat! Aşağıdaki uyarı görüntülenirse:**
```
Add it to /root/.bash_profile to make the aztec binaries accessible?
```

**`n` (hayır) girin.** Sadece yukarıda listelenen soru için. Lütfen dikkatli olun.

![.bash_profile'a ekleme istemi](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/2.jpg)

## Doğrulayıcı Kurulumu

Sonraki sorunlar:
```
Birden fazla validator çalıştırmak istiyor musunuz? (y/n)

BLS anahtarlarınız var mı? (y/n)
```

*   **Bir doğrulayıcı** çalıştırıyorsanız, `n` girin.
*   **Birden fazla doğrulayıcı** çalıştırmayı planlıyorsanız, `y` girin.

    ![Doğrulayıcı sayısını seçme](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/3.jpg)

### Çoklu doğrulayıcı modu için

Ardından, doğrulayıcı verilerini girmeniz gerekmektedir. Her doğrulayıcı için verileri kesin biçimde girin:

`0x_ile_özel_anahtar,doğrulayıcı_adresi`

Örnek:
`0xa1b2c3d4e5f6...,0x742d35Cc6634C0532925a3b844Bc454e4438f44e`

BLS anahtarları seçeneği seçilirse, katı formatta işlem yapılır:

`0x_ile_özel_anahtar,doğrulayıcı_adresi,0x_ile_BLS_özel_anahtar,public_BLS_adresi`

Örnek:
`0xa1b2c3d4e5f6...,0x742d35Cc6634C0532925a3b844Bc454e4438f44e,0xa1b2c3d4e5f6...,0x12d4720c311e6d2e0826738a071fa06743f6cb8efd586ed718c3b020f09b5c8d`

⚠️ Eğer **tüm** validatörlerin işlemleri için Sepolia ETH ödemek amacıyla **tek bir adres** kullanmayı planlıyorsanız, önce o adresin verilerini girin. Tüm validatörlerin verilerini girdikten sonra script, ilk adresin tüm validatörler için publisher adresi olarak kullanılıp kullanılmayacağını soracaktır (`Use first address as publisher for all validators?`) - **`y`** seçin.

Eğer tüm adreslerde Sepolia ETH varsa, **`n`** seçebilirsiniz.

![Doğrulayıcı verilerini girme](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/4.jpg)

### Tek doğrulayıcı modu için

Özel anahtarı ve doğrulayıcının eth adresini ayrı ayrı girin.

### feeRecipient için Aztec L2 adresi

Bundan sonra, betik resmi web sitesinde oluşturabileceğiniz **Aztec L2 adresinizi** isteyecektir: https://app.obsidion.xyz/.

Herhangi bir nedenden dolayı bir Aztec L2 adresi oluşturamıyorsanız, `0x0000000000000000000000000000000000000000000000000000000000000000` ekleyin

İsterseniz bunu daha sonra gerçek bir L2 adresiyle değiştirebilirsiniz.

![L2 adresini girme](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/5.jpg)

> **Önemli:** Betik, gerekli tüm yapılandırma dosyalarını (web3signer için `/root/aztec/keys` içinde `YML` ve `/root/aztec/config` içinde `keystore.json`) otomatik olarak oluşturacaktır.

## Docker Compose Yapılandırması

Son düğüm kurulumu için betik, `docker-compose.yml` dosyasını oluşturmak üzere veri isteyecektir:

*   **`ETHEREUM_RPC_URL`** — Ethereum L1 için RPC URL'niz. **Önemli:** Mainnet için mainnet RPC kullanın, testnet için Sepolia testnet RPC kullanın.
*   **`CONSENSUS_BEACON_URL`** — Beacon Chain için RPC URL'niz. **Önemli:** Mainnet için mainnet Beacon Chain RPC kullanın, testnet için Sepolia testnet Beacon Chain RPC kullanın.
*   **`COINBASE`** — Ethereum cüzdan adresiniz. Doğrulayıcınızın adresini girin.
*   **`P2P_IP`** — Bu parametre betik tarafından otomatik olarak belirlenecektir.
    **Sunucuda VPN kullanıyorsanız**, node kurulumunu tamamladıktan sonra gerçek IP adresini `/root/aztec` klasöründeki `.env` dosyasına **manuel olarak** girmelisiniz.

    ![RPC ve diğer verileri girme](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/6.jpg)

## Ağ Seçimi (Mainnet/Testnet)

RPC adreslerini girdikten sonra betik, düğüm için ağ seçimi yapmanızı isteyecektir:

1.  **Mainnet** — Aztec ana ağı
2.  **Testnet** — Aztec test ağı

İlgili numarayı (1 veya 2) girerek istediğiniz ağı seçin.

> **Önemli:** 
> *   Seçilen ağ, düğümünüzün hangi ağda çalışacağını belirler
> *   Düğüm verileri farklı dizinlerde saklanacaktır: mainnet için `/root/.aztec/mainnet/data/` ve testnet için `/root/.aztec/testnet/data/`
> *   Seçilen ağ için doğru RPC adreslerini kullandığınızdan emin olun
> *   Seçilen ağ, `~/.env-aztec-agent` dosyasındaki `NETWORK` değişkenine kaydedilir

## Watchtower Kurulumu

Betik, düğüm konteynerlerinizi otomatik olarak güncellemek için bir servis olan **Watchtower**'ı kurmayı teklif edecektir. Güncelleme süreci hakkında Telegram bildirimlerini yapılandırmak için şunlara ihtiyacınız olacak:

1.  **Telegram Token:** [BotFather](https://t.me/BotFather)'dan yeni bir bot oluşturarak alın.
2.  **Oluşturduğunuz bota gidin** ve sohbette `/start` komutunu gönderin.
3.  **Chat ID:** Chat ID'nizi öğrenin, örneğin [@myidbot](https://t.me/myidbot) kullanarak.

İlgili istemler göründüğünde istenen verileri girin.

![Telegram bildirimleri için veri girme](https://raw.githubusercontent.com/pittpv/aztec-monitoring-script/main/other/Aztec-Install-by-Script/7.jpg)

## Web3signer Kurulumu

Betik, web3signer görüntüsünü otomatik olarak indirecek ve gerekli argümanlarla başlatacaktır.

## Tamamlama ve Doğrulama

Tüm adımlar tamamlandıktan sonra, betik başarılı bir kurulum raporlayacak ve otomatik olarak logları göstermeye başlayacaktır (`docker-compose logs -f`).

**Logların görünmesini bekleyin ve düğümün senkronizasyona başladığından emin olun.** Log görüntüleme modundan çıkmak için **`Ctrl+C`** tuş kombinasyonuna basın.

Düğüm kurulumu şu anda tamamlanmıştır.

## Sonraki Adımlar

1.  Betiğin ana menüsünden `1` seçeneğini seçerek **düğümün senkronizasyon durumunu kontrol edin**.
2.  Ana menüdeki `2` seçeneği aracılığıyla kullanışlı düğüm izleme için **izleme aracısını kurun**.
3.  **Kritik hata tanımları dosyasını**, `24` seçeneğini kullanarak indirin.
4.  **Doğrulayıcı durumunu kontrol edin ve kuyruk pozisyonu izlemesini ayarlayın** `9` seçeneğini kullanarak

Ana menüde bulunan betiğin diğer özelliklerini de incelediğinizden emin olun, örneğin:
*   Konteynerleri başlatma ve durdurma
*   Düğüm sürümünü düşürme (bir güncellemede sorun çıkması durumunda)
*   Logları ve istatistikleri görüntüleme

Düğümünüzü çalıştırırken size istikrarlı çalışma ve başarılar dileriz!

Saygılarımızla,  
pittpv

> **Betiğin çalışması hakkında herhangi bir sorunuz varsa**, Telegram sohbetimizde sorun: [https://t.me/+DLsyG6ol3SFjM2Vk](https://t.me/+DLsyG6ol3SFjM2Vk)
