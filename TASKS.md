# TASKS — Interview Simulator (PRD v2.0)

Bu dosya, `prd.md` içeriğindeki gereksinimleri uygulanabilir geliştirme task’lerine böler.

## Epic A — Karakter Odaklı Mülakat Ekranı
- [ ] **A1: Karakter yerleşimi**: `assets/1pp.png` görselini mülakat ekranında merkez (üst-orta) odak olacak şekilde konumlandır
- [ ] **A2: Chat listesi kaldırma**: Ana ekrandaki mesaj geçmişi/list görünümünü kaldır
- [ ] **A3: Konuşma balonu UI**: Karakterin yanında/altında tek bir “aktif soru/tepki” gösterecek konuşma balonu bileşeni oluştur
- [ ] **A4: Balon metni güncelleme**: Yeni AI mesajı geldiğinde balondaki metni replace et (eski mesaj ekranda kalmasın)
- [ ] **A5: Balon animasyonu**: Yeni metin geldiğinde balonda yumuşak geçiş (fade/slide) uygula
- [ ] **A6: Alt input bar**: Kullanıcı cevap input’u ve “Gönder” butonunu ekran altına sabitle ve yeni tasarımla uyumlu hale getir
- [ ] **A7: Boş durumlar**: Mülakat başlamadan önce balonda “Hazır mısın?” gibi başlangıç state’i göster
- [ ] **A8: Uzun metinler**: Konuşma balonunda uzun soru/yanıtların taşmaması için scroll/wrap davranışını belirle
- [ ] **A9: Erişilebilirlik**: Gönder butonu, input ve ikon butonlar için erişilebilir label/semantics ekle

## Epic B — Sohbet Geçmişi Modal/Bottom Sheet
- [ ] **B1: Geçmiş butonu**: Mülakat ekranının üst köşesine “Geçmiş/Kayıtlar” ikon butonu ekle
- [ ] **B2: Modal aç/kapat**: `showModalBottomSheet` veya `showDialog` ile geçmiş overlay’ini aç/kapat
- [ ] **B3: Geçmiş listesi**: Modal içinde tüm konuşmaları (AI + kullanıcı) kronolojik listele
- [ ] **B4: Mesaj modeli**: Mesajları rol (ai/user), içerik, timestamp gibi alanlarla temsil eden model ekle/standardize et
- [ ] **B5: State ayrımı**: “Aktif konuşma balonu metni” ile “tam geçmiş listesi” state’lerini net ayır
- [ ] **B6: Otomatik scroll**: Modal açıldığında en son mesaja scroll et
- [ ] **B7: Kopyalama**: Mesaj üzerine basılı tutma ile kopyalama (opsiyonel ama UX için önerilir)
- [ ] **B8: Empty state**: Geçmiş yoksa modal içinde açıklayıcı boş durum göster

## Epic C — Tema Sistemi (Mevcut Yapıyı Geliştirme)
- [ ] **C1: Tema envanteri**: PRD’de geçen temaları netleştir ve uygulamada tek kaynakta topla  
  - Dark Mode (Gece)
  - Professional (Kurumsal)
  - Modern (Soft)
  - High Contrast (Yüksek Kontrast)
- [ ] **C2: ThemeData setleri**: Her tema için `ThemeData` (ColorScheme, typography, component theme) tanımla
- [ ] **C3: Theme manager**: Mevcut tema altyapısını merkezi bir Theme Manager/Provider/Bloc yapısına taşı veya iyileştir
- [ ] **C4: Tema seçimi UI**: Ayarlar/Profil ekranında tema seçimi alanını güncelle (mevcut varsa iyileştir)
- [ ] **C5: Kalıcı tercih**: Seçilen temayı local storage (örn. SharedPreferences/Hive) ile kalıcı yap
- [ ] **C6: Tam kapsama**: Tema geçişinin tüm ana bileşenlerde (buton, input, modal, background) tutarlı çalıştığını doğrula
- [ ] **C7: Kontrast kontrolü**: High Contrast temasında minimum okunabilirlik/kontrast hedeflerini karşıla

## Epic D — Meslek Seçimi (20 Meslek)
- [ ] **D1: Veri kaynağı**: Meslek listesini tek bir sabit liste/enum/config dosyasında merkezi hale getir
- [ ] **D2: 20 seçenek**: Meslek seçim ekranındaki seçenekleri PRD’ye göre 20’ye tamamla ve sırayı standardize et
- [ ] **D3: Kategori sunumu**: Kategorilere göre gruplanmış görünüm (opsiyonel) veya düz liste (minimum) kararını uygula
- [ ] **D4: Arama/filtre**: Meslek araması (opsiyonel ama UX için önerilir)
- [ ] **D5: AI prompt mapping**: Seçilen mesleği AI prompt/akışına doğru şekilde bağla (sorular role uygun gelsin)
- [ ] **D6: Boş/invalid seçim**: Meslek seçilmeden mülakat başlatılamasın (guard)

## Epic E — AI Yanıt Akışı ve Durum Yönetimi
- [ ] **E1: Aktif balon akışı**: AI’den gelen son mesajı doğrudan “aktif balon metni” state’ine yaz
- [ ] **E2: Geçmişe ekleme**: AI ve kullanıcı mesajlarını ayrıca “geçmiş listesi”ne append et
- [ ] **E3: Loading state**: AI beklenirken balonda yükleniyor göstergesi ve gönder butonunda disabled durumu
- [ ] **E4: Hata state**: API/AI hatasında balonda anlaşılır hata metni ve yeniden dene aksiyonu
- [ ] **E5: Input temizleme**: Gönder sonrası input’u temizle ve odak davranışını düzenle

## Epic F — QA, Kabul Kriterleri ve Regresyon
- [ ] **F1: Kabul kriterleri kontrolü**:  
  - Karakter + konuşma balonu görünür  
  - Geçmiş yalnızca modalda görünür  
  - Meslek listesi 20 aktif seçenek içerir  
  - Tema geçişi uygulama genelinde sorunsuz
- [ ] **F2: Cihaz boyutları**: Küçük ekranlarda (telefon) ve büyük ekranlarda (tablet) layout kırılmıyor
- [ ] **F3: Erişilebilirlik QA**: Semantics/odak sırası ve dokunma hedefleri kontrolü
- [ ] **F4: Performans regresyonu**: Modal geçmiş listesi uzun olduğunda takılma yok (temel kontrol)
- [ ] **F5: Manuel test senaryoları**: Başlat → soru al → cevapla → geçmiş aç → tema değiştir → devam et akışı

## Notlar / Varsayımlar
- `prd.md` içinde eski metin + güncellenmiş PRD birlikte duruyor; task’ler **147. satırdan başlayan PRD v2.0** gereksinimlerine göre çıkarıldı
- Uygulama Flutter tabanlı olduğu için state/tema uygulamaları Flutter mimarisi üzerinden ele alındı

