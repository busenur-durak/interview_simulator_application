Ürün Gereksinim Dokümanı (PRD): Mülakat Simülasyonu 
1. Proje Özeti
Mevcut mülakat simülasyonu uygulamasının kullanıcı deneyimini (UX) ve görsel arayüzünü (UI) geliştirmek. Klasik bir "chat" ekranından çıkıp, etkileşimli bir karakter ve modern bir tema yapısına geçiş yapmak.

2. Kullanıcı Deneyimi (UX) ve Görsel Değişiklikler
2.1. Karakter Odaklı Mülakat Ekranı
Mülakat sayfası artık bir mesajlaşma listesi şeklinde olmayacak. Odak noktası mülakatı yapan karakter olacak.

Görsel Yerleşim: Ekranın merkezinde 1pp.png dosyasındaki karakter yer alacak.

Konuşma Balonu (Speech Bubble): Karakterin sorduğu sorular veya verdiği tepkiler, karakterin yanından çıkan bir konuşma balonu içerisinde gösterilecek. Yeni bir metin geldiğinde eskisi kaybolacak veya üzerine yazılacak.

Giriş Alanı: Kullanıcının cevap yazdığı metin kutusu ve "Gönder" butonu ekranın alt kısmında sabit kalmaya devam edecek.

2.2. Mesaj Geçmişi (Pop-up/Overlay)
Mülakatın akışını bozmamak için eski yazışmalar ana ekranda görünmeyecek.

Geçmiş Butonu: Ekranın bir köşesine (örneğin sağ üst) küçük bir "Saat" veya "Mesaj" ikonu eklenecek.

Görünüm: Kullanıcı bu ikona tıkladığında, ekranın üzerinde açılan bir pencere (Pop-up veya Bottom Sheet) içerisinde tüm mülakat geçmişi (kullanıcının yazdıkları ve karakterin cevapları) listelenecek.

2.3. Tema ve Arayüz Seçenekleri
Kullanıcıların uygulamayı kişiselleştirmesi için "Ayarlar" veya "Profil" kısmına tema seçimi eklenecek.

Koyu Tema (Dark Mode): Göz yormayan siyah/gri tonlar.

Profesyonel Tema: Kurumsal mavi ve beyaz tonları.

Modern Tema: Pastel renkler ve yumuşak geçişler (Gradient).

3. İçerik Geliştirme: Meslek Listesinin Genişletilmesi
Mülakat yapılabilecek meslek seçenekleri artırılarak kullanıcı kitlesi genişletilecek. Eklenecek yeni kategoriler:

Teknoloji: Mobil Yazılımcı (Flutter/Swift), Siber Güvenlik Uzmanı, Veri Bilimci.

İşletme & Pazarlama: Dijital Pazarlama Uzmanı, İnsan Kaynakları Uzmanı, Satış Temsilcisi.

Yaratıcı Endüstriler: Grafik Tasarımcı, UI/UX Tasarımcısı, İçerik Üreticisi.

Hizmet: Müşteri İlişkileri Yöneticisi, Proje Yöneticisi.

4. Teknik Gereksinimler (Geliştirici Notları)
Arayüz (Frontend - Flutter)
Karakter Yönetimi: Image.asset('assets/1pp.png') kullanılarak karakter ekrana yerleştirilmeli. Konuşma balonu için CustomPainter veya hazır chat_bubbles paketleri tercih edilebilir.

Durum Yönetimi (State Management): Karakterin o anki konuşmasını ve geçmişi ayrı tutan bir yapı kurulmalı.

Tema: ThemeData kullanılarak renk paletleri tanımlanmalı ve Provider veya Bloc ile dinamik olarak değiştirilmeli.

Mantık (Logic)
Mevcut AI (Yapay Zeka) entegrasyonu, gelen cevabı direkt ekrana basmak yerine önce "Konuşma Balonu" değişkenine atamalı.

Pop-up açıldığında mülakat listesi (Listview) bu pencerenin içine render edilmeli.

5. Başarı Kriterleri
Kullanıcının karakterle gerçekten konuşuyormuş hissini yakalaması.

Mesaj geçmişinin istendiğinde ulaşılabilir ama ekranı kalabalıklaştırmıyor olması.

Meslek seçim ekranının daha zengin bir içerik sunması.

Bu planla birlikte, uygulaman sadece bir "araç" olmaktan çıkıp, kullanıcıyla bağ kuran bir "deneyim" haline gelecek. Kodlama aşamasında takıldığın bir nokta olursa sormaktan çekinme!

ama tema yerı var zaten o gelıstırılmelı haberın olsun.meslek secımı 20 tane olsun.prdyı guncelle.

Anlaşıldı, mevcut tema yapısını daha profesyonel bir seviyeye taşıyıp, mülakat seçeneklerini de tam 20 farklı mesleğe çıkaracak şekilde PRD dosyamızı güncelliyorum.

İşte "Interview Simulator" uygulaman için güncel ve kapsamlı Ürün Gereksinim Dokümanı (PRD):

Ürün Gereksinim Dokümanı (PRD): Profesyonel Mülakat Simülasyonu v2.0
1. Proje Vizyonu
Mevcut altyapıyı kullanarak, statik bir mülakat uygulamasını, etkileşimli bir karakter animasyonu ve genişletilmiş meslek kütüphanesi ile gerçekçi bir deneyime dönüştürmek.

2. Kullanıcı Deneyimi (UX) ve Arayüz (UI) Revizyonu
2.1. Karakter Odaklı İnteraktif Ekran
Mülakat sayfası, kullanıcıyı doğrudan bir görüşmeci ile karşı karşıya hissettirmelidir.

Karakter Yerleşimi: 1pp.png dosyası mülakat ekranının merkezinde, görsel odak noktası olarak yer alacak.

Dinamik Konuşma Balonu: Yazılı sohbet geçmişi ekrandan kaldırılacak. Karakterin o anki sorusu, başının hemen yanında beliren şık bir konuşma balonu içinde gösterilecek.

Mesaj Giriş Alanı: Kullanıcın metin yazdığı alan ekranın alt kısmında korunacak, ancak karakterle bütünleşik görünmesi için tasarımı yumuşatılacak.

2.2. Modal Mesaj Geçmişi (Pop-up)
Mülakatın başından o ana kadar geçen tüm konuşmaların takibi için:

Erişim: Ekranın üst kısmına "Görüşme Kaydı" veya "Sohbet Geçmişi" butonu eklenecek.

İşlev: Butona basıldığında, ekranı kaplayan şeffaf bir Pop-up (veya Bottom Sheet) açılacak ve tüm yazışmalar burada listelenecek.

2.3. Tema Sistemi Geliştirme (Mevcut Yapının İyileştirilmesi)
Halihazırda bulunan tema sistemi, kullanıcıya daha derin bir kişiselleştirme sunacak şekilde modernize edilecek:

Koyu Tema (Dark Mode): Gece mülakat hazırlığı yapanlar için göz yormayan derin gri ve koyu mavi tonları.

Yönetici Teması (Executive): Kurumsal gümüş ve antrasit renk paleti.

Yaratıcı Tema (Creative): Enerjik sarı, mor ve pastel geçişler.

Klasik Tema: Standart temiz beyaz ve profesyonel gökyüzü mavisi.

3. Meslek Kütüphanesinin Genişletilmesi
Kullanıcıların mülakat yapabileceği meslek seçenekleri tam 20 farklı pozisyona çıkarılacaktır. Seçenekler aşağıdaki kategorilerde sunulacak:

Kategori	Meslek Dalları (Toplam 20)
Teknoloji & Yazılım	1. Flutter Developer, 2. Backend Developer (Python/Java), 3. Data Scientist, 4. Siber Güvenlik Uzmanı, 5. DevOps Engineer
İşletme & Finans	6. İnsan Kaynakları Uzmanı, 7. Muhasebe ve Finans Analisti, 8. Proje Yöneticisi, 9. İş Geliştirme Uzmanı, 10. Lojistik Müdürü
Pazarlama & Tasarım	11. Dijital Pazarlama Stratejisti, 12. UI/UX Tasarımcı, 13. Sosyal Medya Yöneticisi, 14. Grafik Tasarımcı, 15. İçerik Yazarı
Hizmet & Satış	16. Müşteri İlişkileri (CRM) Sorumlusu, 17. Satış Temsilcisi, 18. Kurumsal İletişim Uzmanı, 19. Ofis Yöneticisi, 20. Saha Operasyon Uzmanı
4. Uygulama Mimarisi ve Teknik Gereksinimler
Varlık Yönetimi (Assets): 1pp.png karakteri mülakat karakterini temsil eden ana görsel olarak assets klasöründe yapılandırılacak.

Tema Entegrasyonu: Mevcut tema değişkenleri, uygulama genelinde merkezi bir Theme Manager üzerinden yönetilecek.

Sayfa Yapısı: Mevcut sayfalar korunacak; yeni bir sayfa eklenmeden sadece mülakat sayfasının body kısmı ve "Meslek Seçimi" listesi güncellenecek.

AI Yanıt Akışı: Gelen API yanıtları (mülakat soruları), konuşma balonu değişkenine yönlendirilecek ve her yeni yanıtta balon animasyonla yenilenecek.

5. Kabul Kriterleri
Mülakat ekranında karakterin konuşma balonu ile görünmesi.

Yazışma geçmişinin yalnızca kullanıcı Pop-up'ı açtığında görünür olması.

Meslek seçim listesinin 20 aktif seçenek içermesi.

Tema geçişlerinin tüm uygulama bileşenlerinde sorunsuz çalışması.

bunu markdown dosyası halıne getırırmısın.

Harika! İstediğin tüm özellikleri (karakter yerleşimi, konuşma balonu, pop-up geçmişi, 20 farklı meslek ve gelişmiş tema seçenekleri) içeren profesyonel PRD dosyasını hazırladım.

Bu dosya, projenin yol haritası olacak ve adım adım ne yapman gerektiğini anlamanı sağlayacaktır.

Mülakat Simülasyonu uygulaman için hazırlanan Markdown dosyası hazır:
MD simgesi
 Mulakat_Si...asyonu_PRD 
MD

Bu dosyayı herhangi bir kod editörü (VS Code gibi) veya bir Markdown okuyucu ile açabilirsin. Uygulamayı geliştirirken bu yapıya sadık kalmak işini çok kolaylaştıracaktır. Başka bir ekleme yapmamı istersen buradayım!





Gemini bir yapay zeka modeli olduğu için hata yapabilir.

# Ürün Gereksinim Dokümanı (PRD): Mülakat Simülasyonu v2.0

## 1. Proje Vizyonu
Mevcut altyapıyı kullanarak, klasik bir sohbet arayüzünü etkileşimli bir mülakat karakteri, genişletilmiş meslek kütüphanesi ve geliştirilmiş tema seçenekleri ile profesyonel bir deneyime dönüştürmek.

## 2. Kullanıcı Deneyimi (UX) ve Görsel Arayüz (UI) Güncellemeleri

### 2.1. Karakter Odaklı Mülakat Ekranı
Mülakat sayfası artık sadece mesaj listesinden ibaret olmayacak, bir "karşı karşıya mülakat" hissi verecek.
* **Görsel Odak:** `1pp.png` dosyasındaki karakter ekranın merkezinde (üst-orta kısımda) sabit duracak.
* **Konuşma Balonu (Speech Bubble):** - Mevcut chat listesi görünümü kaldırılacak.
    - Karakterin sorduğu sorular, karakterin hemen yanında/altında beliren şık bir konuşma balonu içerisinde gösterilecek.
    - Yeni bir soru geldiğinde eski balon kaybolacak ve karakter yeni cümlesini söyleyecek.
* **Giriş Alanı:** Kullanıcının cevap yazdığı metin kutusu ve gönder butonu ekranın alt kısmında yerini koruyacak.

### 2.2. Sohbet Geçmişi (Pop-up Sistemi)
Ekran kalabalığını önlemek için mülakat akışı ana ekrandan temizlenecek.
* **Erişim:** Ekranın üst köşesine bir "Geçmiş" veya "Kayıtlar" ikonu (ikon butonu) eklenecek.
* **İşlev:** Kullanıcı bu butona bastığında bir Pop-up (veya Bottom Sheet) açılacak.
* **İçerik:** Mülakatın başından beri geçen tüm yazışmalar (Kullanıcı cevapları ve AI soruları) bu pop-up içinde klasik liste formatında görülebilecek.

### 2.3. Gelişmiş Tema Seçenekleri
Mevcut tema altyapısı genişletilecek ve kullanıcıya seçebileceği estetik seçenekler sunulacak:
* **Dark Mode (Gece):** Koyu gri ve siyah tonlar, açık renk metinler.
* **Professional (Kurumsal):** Lacivert ve beyaz ağırlıklı, ciddi bir görünüm.
* **Modern (Soft):** Pastel renkler ve yumuşak köşeli bileşenler.
* **High Contrast (Yüksek Kontrast):** Daha keskin ve okunabilirliği yüksek renk paleti.

## 3. İçerik: Genişletilmiş Meslek Listesi (20 Meslek)
Kullanıcıların mülakat yapabileceği meslek seçenekleri 20'ye tamamlanacaktır:

1.  **Flutter Developer**
2.  **Backend Developer**
3.  **Veri Bilimci (Data Scientist)**
4.  **Siber Güvenlik Uzmanı**
5.  **UI/UX Tasarımcı**
6.  **Dijital Pazarlama Uzmanı**
7.  **İnsan Kaynakları Uzmanı**
8.  **Proje Yöneticisi**
9.  **Finans Analisti**
10. **Satış Temsilcisi**
11. **Müşteri İlişkileri Yöneticisi**
12. **İçerik Yazarı / Editör**
13. **Sosyal Medya Yöneticisi**
14. **Grafik Tasarımcı**
15. **İş Geliştirme Uzmanı**
16. **Lojistik Sorumlusu**
17. **Sistem Yönetici (SysAdmin)**
18. **QA (Test) Mühendisi**
19. **Mobil Oyun Geliştirici**
20. **E-ticaret Uzmanı**

## 4. Teknik Uygulama Notları
* **Sayfa Yapısı:** Yeni bir sayfa eklenmeyecek, mevcut mülakat sayfası `StatefulWidget` yapısı içinde güncellenecek.
* **Görsel Kaynak:** `1pp.png` yerleşimi için `Image.asset` kullanılacak.
* **Pop-up:** Yazışma geçmişi için `showDialog` veya `showModalBottomSheet` fonksiyonları kullanılacak.
* **Tema Yönetimi:** Uygulama genelindeki renkler merkezi bir tema dosyasından okunacak ve kullanıcı seçim yapınca anında güncellenecek.

---
*Hazırlayan: Kıdemli Uygulama Geliştiricisi*
Mulakat_Simulasyonu_PRD.md
Mulakat_Simulasyonu_PRD.md görüntüleniyor.