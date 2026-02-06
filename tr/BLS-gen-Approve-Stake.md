# BLS: Anahtar Üretimi, Approve ve Stake (Seçenekler 18, 19, 20)

Aztec doğrulayıcı staking’i için aztec-logs betiğindeki **18** (BLS anahtar üretimi ve alt seçenekler), **19** (Approve) ve **20** (Stake) seçeneklerinin ayrıntılı açıklaması.

---

## Seçenek 18 — Mnemonic’ten BLS Anahtarları Üret

Ana menüde **18** seçildiğinde, BLS anahtarlarıyla çalışmanın dört yoluyla **"BLS Keys Generation and Transfer"** alt menüsü açılır.

### Seçenek 18 alt menüsü

| # | Açıklama |
|---|----------|
| **1** | Yeni operatör adresi oluştur (tavsiye edilen) |
| **2** | Mevcut adresleri kullanarak oluştur (mnemonic’ten; yalnızca tüm doğrulayıcı adresleri aynı seed ifadesindense) |
| **3** | BLS anahtarlarını keystore.json’a ekle |
| **4** | Dashboard keystore’ları oluştur (staking dashboard için özel + staker_output) — **tavsiye edilen** |

---

### Alt seçenek 18-1: Yeni operatör adresi (tavsiye edilen)

**Amaç:** Doğrulayıcı operatörünü değiştirmek: her mevcut doğrulayıcı için **yeni** bir ETH adresi ve yeni BLS anahtarı üretilir. Eski adres sözleşmede kalır (çekim vb. için), staking ise yeni operatöre bağlanır.

**Betik ne yapar:**

1. **Eski doğrulayıcı özel anahtarlarını** ister (bir veya daha fazla, virgülle ayrılmış, boşluksuz; giriş gizlidir).
2. Bu anahtarlardan eski ETH adreslerini türetir ve `$HOME/aztec/config/keystore.json` ile karşılaştırır.
3. Keystore’daki ilk doğrulayıcıdan `feeRecipient` alır.
4. **Her** eski anahtar için sırayla:
   - Enter’a basmanızı ister ve `aztec validator-keys new --fee-recipient <feeRecipient>` çalıştırır (mnemonic yok — yeni anahtar çifti üretilir).
   - Üretilen `~/.aztec/keystore/key1.json` dosyasından yeni ETH özel anahtarı, BLS özel anahtarı ve yeni ETH adresini çıkarır.
   - Eski adresi yeni anahtarlarla eşleştirir ve bellekte tutar.
5. Keystore’daki doğrulayıcı sırasına göre **`$HOME/aztec/bls-filtered-pk.json`** oluşturur. Her girdide:
   - `attester.eth` — eski özel anahtar (staking işlemini imzalamak için kullanılır),
   - `attester.bls` — yeni BLS özel anahtarı,
   - `attester.old_address` — eski adres,
   - `feeRecipient`,
   - `new_operator_info`: yeni ETH özel anahtarı, yeni BLS, yeni ETH adresi, RPC URL.

**Önemli:**  
- Tüm yeni verileri (tekrar kullanılacak mnemonic, yeni adresler ve BLS) **kaydedin**. Özel anahtarlar ayrıca `bls-filtered-pk.json` içinde saklanır.  
- Betik ardından şunları önerir: yeni adrese 0.1–0.3 Sepolia ETH gönderin, sonra **19 (Approve)** ve **20 (Stake)** seçeneklerini çalıştırın.

**Ne zaman kullanılır:** Doğrulayıcı operatörünü değiştirirken (sistemde eski adresler dururken yeni cüzdan ve yeni BLS anahtarları).

---

### Alt seçenek 18-2: Mevcut adresler (tek mnemonic’ten)

**Amaç:** Tüm bu adresler **tek** bir mnemonic ifadeden türetilmişse **zaten var olan** doğrulayıcı ETH adreleri için BLS anahtarları almak.

**Betik ne yapar:**

1. **Mnemonic ifade** (gizli giriş) ve **cüzdan sayısı** (örn. 1, 30, 50 — fazla yazmak daha iyi; fazlalar atılır) ister.
2. `$HOME/aztec/config/keystore.json` dosyasından (ilk doğrulayıcı) **feeRecipient** okur.
3. `aztec validator-keys new` çalıştırır:
   - `--fee-recipient`, `--mnemonic`, `--count`, `--file bls.json`, `--data-dir $HOME/aztec/`.
4. Üretilen `bls.json` içinde her doğrulayıcı için özel anahtardan ETH adresini türetir (`cast wallet address` ile), geçici `bls-ethwallet.json` oluşturur.
5. Keystore’daki doğrulayıcı adres listesini **aynı sırada** alır ve **`bls-filtered-pk.json`** oluşturur: yalnızca adresleri keystore ile eşleşen (ETH özel + BLS özel) çiftler. Girdi sırası keystore ile aynıdır.
6. Geçici `bls.json` ve `bls-ethwallet.json` dosyaları silinir.

**Sonuç:** `$HOME/aztec/bls-filtered-pk.json` içinde yalnızca keystore’daki doğrulayıcılarla eşleşen anahtarlar vardır. Format “eski”: `new_operator_info` yok, yalnızca `attester.eth`, `attester.bls`, `feeRecipient`. Ardından **19** ve **20** (eski staking formatı) çalıştırılabilir.

**Ne zaman kullanılır:** Tüm doğrulayıcılar tek seed ifadesinden, adresler zaten keystore’da — yalnızca BLS anahtarlarını eklemek veya güncellemek gerekiyor.

---

### Alt seçenek 18-3: BLS anahtarlarını keystore.json’a ekle

**Amaç:** `bls-filtered-pk.json` içindeki BLS özel anahtarlarını `$HOME/aztec/config/keystore.json` dosyasına yazmak (her doğrulayıcı için ETH adresi eşleşmesine göre `attester.bls` alanına).

**Betik ne yapar:**

1. `$HOME/aztec/bls-filtered-pk.json` ve `$HOME/aztec/config/keystore.json` dosyalarının varlığını kontrol eder.
2. Zaman damgalı keystore yedeği oluşturur.
3. Eşleme kurar: ETH adresi (bls-filtered-pk’deki özel anahtardan) → BLS özel anahtarı.
4. Keystore’daki her doğrulayıcı için `attester.eth` (adres) alanına göre bls-filtered-pk’den ilgili BLS’i bulur ve `attester.bls` günceller.
5. Güncellenmiş keystore’u kaydeder ve kısa bir rapor yazdırır.

**Ne zaman kullanılır:** Yalnızca BLS üretiminden (18-1 veya 18-2) sonra ve yalnızca BLS’ler seed ifadesinden türetildiyse veya `bls-filtered-pk.json` dosyasını kendiniz doğru oluşturduysanız. Rastgele dosyalarla kullanmayın.

---

### Alt seçenek 18-4: Dashboard keystore’ları

**Amaç:** **Staking dashboard** için dosyalar oluşturmak (Aztec dokümantasyonu: sequencer_management vb.): özel keystore ve staker_output.

**Betik ne yapar:**

1. Dizin olarak `$HOME/aztec`, ağ ayarlarından (mainnet/testnet) GSE adresi, betik ayarlarından RPC (veya varsayılan Sepolia) kullanır.
2. Sorar: yeni mnemonic **(1)** mi kendi girişiniz **(2)** mi?
3. Doğrulayıcı kimlik sayısını ister (örn. 1 veya 5).
4. Şu bayraklarla `aztec validator-keys new` çalıştırır:
   - `--fee-recipient` (sıfır adres),
   - `--staker-output`,
   - `--gse-address`, `--l1-rpc-urls`, `--data-dir $HOME/aztec`,
   - `--file dashboard_keystore.json`,
   - 2 seçildiyse — `--mnemonic "..."`,
   - `--count N`.
5. Sonuç `$HOME/aztec/` altına kaydedilir:
   - **dashboard_keystore.json** — özel keystore,
   - **dashboard_keystore_staker_output.json** — staking dashboard için.

**Ne zaman kullanılır:** Anahtarları özellikle Aztec staking web dashboard’u için hazırlarken; bu betikteki 19/20 seçenekleri için değil.

---

## Seçenek 19 — Approve

**Amaç:** Staking (rollup) akıllı sözleşmesinin staking token’ınızı harcamasına izin vermek (token biriminde 200000 ether’e kadar approve). Bu adım olmadan 20 (Stake) seçeneği token’ı cüzdanınızdan çekemez.

**Betik ne yapar:**

1. Betik ayarlarından ağ, RPC ve sözleşme adresini alır (`get_network_settings`).
2. `$HOME/aztec/keys/` içindeki tüm `*.yml` dosyalarını bulur (ada göre sıralı, örn. validator_1, validator_2). Adında “bls” geçen dosyalar atlanır.
3. Her YML’den `privateKey:` (tırnak içindeki değer) çıkarır.
4. Her anahtar için:
   - ETH adresini hesaplar ve **nonce** (pending) alır; ardışık birkaç işlemde nonce tekrarlanmasın diye.
   - Gas: mevcut gas fiyatının %50 üstü, en az 10 gwei; “replacement transaction underpriced” hatasında gas iki katına çıkarılıp sonraki RPC ile tekrar dener.
   - **ERC-20 approve** çağrısı: token sözleşmesi `0x5595cb9ed193cac2c0bc5393313bc6115817954b`, metot `approve(address,uint256)` — spender staking (rollup) sözleşme adresi, miktar `200000 ether` (token wei cinsinden).
   - RPC listesi (birincil + yedek Sepolia) kullanılır; farklı doğrulayıcılar için farklı RPC’ler dönüşümlü; işlemler arasında ~12 saniye bekleme.

**Önemli:**  
- `$HOME/aztec/keys/` içinde stake edeceğiniz cüzdanların özel anahtarlarını içeren YML dosyaları olmalıdır.  
- İşlem takılı (pending) kalırsa betik iptal veya hızlandırma (örn. MetaMask) önerir, ardından Approve’u tekrar çalıştırmanızı söyler.

**Sıra:** Approve (19), BLS üretiminden (18) **sonra** ve Stake’ten (20) **önce** çalıştırılır. “Yeni operatör” yöntemi (18-1) için 19’dan önce yeni adreslere gas için ETH yollanmalıdır.

---

## Seçenek 20 — Stake

**Amaç:** Doğrulayıcıyı ağda kaydetmek (staking sözleşmesini çağırmak): BLS anahtarını ve doğrulayıcı verilerini rollup sözleşmesine bağlamak. `bls-filtered-pk.json` ve gerektiğinde `keystore.json` verileri kullanılır.

**Betik ne yapar:**

1. `$HOME/aztec/bls-filtered-pk.json` dosyasının varlığını kontrol eder. Yoksa önce 18’i çalıştırmanızı önerir.
2. bls-filtered-pk formatını tespit eder:
   - ilk doğrulayıcıda **`new_operator_info`** varsa — **yeni format** (yeni operatör yöntemi, 18-1);
   - yoksa — **eski format** (mevcut adresler, 18-2).
3. Ağ, RPC ve rollup sözleşme adresi betik ayarlarından gelir.

Davranış sonra farklılaşır.

---

### Stake — Eski format (existing method)

- `bls-filtered-pk.json` içindeki her doğrulayıcı için:
  - ETH ve BLS özel anahtarları `bls-filtered-pk.json`’dan alınır (`attester.eth`, `attester.bls` alanları).
  - Attester ETH adresi **keystore.json**’dan aynı indeksle alınır (sıra aynı olmalı).
- Her doğrulayıcı için komut:
  - `aztec add-l1-validator`
  - `--l1-rpc-urls`, `--network`, `--private-key` (bls-filtered-pk’den),
  - `--attester`, `--withdrawer` (keystore’daki adres),
  - `--bls-secret-key` (bls-filtered-pk’den),
  - `--rollup` (sözleşme adresi).
- Hata durumunda betik birkaç RPC dener; göndermeden önce onay (y/s/q) ister. Başarıdan sonra doğrulayıcı linkini yazdırır (örn. dashtec.xyz).

---

### Stake — Yeni format (new operator method)

- `bls-filtered-pk.json` içindeki her doğrulayıcı için:
  - Eski özel anahtar — `attester.eth` (işlemi imzalamak için kullanılır).
  - Yeni adres ve anahtarlar `new_operator_info`’dan: `eth_private_key`, `bls_private_key`, `eth_address`, isteğe bağlı `rpc_url`.
- Komut aynı şekilde kurulur ama attester/withdrawer olarak **yeni** adres (`new_operator_info`’dan) kullanılır.
- Başarılı stake’ten sonra:
  - **Yeni** özel anahtarı içeren bir YML `$HOME/aztec/keys/` içinde oluşturulur (sonraki Approve vb. için).
  - **keystore.json**’da eski doğrulayıcı adresi yenisiyle değiştirilir (düğüm yapılandırması yeni operatöre uysun diye).
  - Yeni anahtarın yüklenmesi için **web3signer** yeniden başlatması önerilir.

Doğrulayıcı linkleri (mainnet/testnet) eski formatta olduğu gibi yazdırılır.

---

## Kısa adım sırası

1. **Seçenek 18** — uygun alt seçeneği seçin (1: yeni operatör, 2: mnemonic’ten mevcut adresler, 3: keystore’a BLS ekleme, 4: dashboard).
2. **18-1** için: yeni adreslere 0.1–0.3 Sepolia ETH gönderin.
3. **Seçenek 19** — `$HOME/aztec/keys/*.yml` içindeki tüm anahtarlar için Approve (bls hariç).
4. **Seçenek 20** — `bls-filtered-pk.json` verileriyle Stake (format otomatik tespit edilir).

Başarılı Stake’ten sonra doğrulayıcılar explorer’da (örn. dashtec.xyz) görünür ve düğüm güncellenmiş keystore ve `keys/` içindeki anahtarları kullanabilir.
