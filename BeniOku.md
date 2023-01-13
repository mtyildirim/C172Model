# C172Model
Cessna 172 için dinamik model ve sensör füzyonu, otopilot hala geliştirme aşamasında.

Bu model Muhammet Tarık Yıldırım tarafından Marmara Üniversitesi Fen Bilimleri Enstitüsü'nde “ Otonom Araçlarda Yazılım ve Donanım Mimarisi “ ve  “Navigasyon Algoritmaları ve Hesaplamaları” dersleri için oluşturulmuştur. Projein amacı , verilen waypointler arasındaki en kısa yoldan gitmesi için GPS pozisyonları ile çalışan bir model oluşturmaktır.

### Simülasyon Önkoşulları;

1 - MATLAB/SIMULINK

2 - FlightGear

### Simülasyonu Çalıştırmak İçin ; 

1 - Tüm dosyaları aynı klasöre indirin

2 - runfg.bat'i çalıştırın

3 - cessa_model.slx'i açın

4 - SIMULINK modelini çalıştırın

## Genel Bilgiler

### Ana Model

Model Kararlılık Katsayıları ile oluşturulmuştur."Simulation Model" isimli subsystem'de ana dinamik modeli ve çevre modellerini görebilirsiniz. Ana model'in stateleri Araç üzerindeki hızlar, Açısal hızlar, Açısal İvmeler, Euler Açıları, Düz Dünya Kordinat Sistemi üzerindeki pozisyon ve Dünya üzerindeki hızlarıdır. Pozisyon hariç tüm statelerin başlangıç koşulları sıfırdır. Başlangıç pozisyonu Sabiha Gökçen Havalimanı 06 nuamralı pisttir.Waypointler Sabiha Gökçen Havalimanı'ndan Atatürk Havalimanı'na bir trajectory oluşturacak şekilde verilmiştir.

### Motor Modeli

Motor modeli "Aerospace Blockset" içindeki SIMULINK blokları ile oluşturulmuştur.Modeli, Cessna 172'nin seyir hızı olan 60m/s'de tutmak için gerekli itkiyi vermek üzere düzenlenmiştir.

### Navigasyon Bilgisayarı

Sensör modelleri ve sensör füzyonları SIMULINK blokları ve kullanıcı tarafından yazılan fonksiyonlar ile oluşturulmuştur.Bu subsystemin içinde 3 farklı alt subsystem göreceksiniz.Bunlar "IMU" , "GPS ve " Position,Velocity and Orientation Sensor Fusion" alt subsystemleridir.Sesnör gürültüleri simülasyonun yavaş çalışmasını engellemek için ihmal edilmiştir.

##### IMU 

IMU yani Ataletsel Ölçü Birimi, SIMULINK IMU bloğu ile modellenmiştir. Araç üzerindeki ivmeler, açısal hızlar, açısal ivmeler, aracın ağırlık merkezi ve yerçekimini giriş olarak alır ve İvmeölçer ve Jiroskop datalarını çıktı olarak verir. İvmeölçerin yerçekmini ölçmesinin önüne geçmek için IMU çıktısıyla yerçekimi toplanmıştır. Ayrıca aracın oryantasyonunu hesaplamak için bir "Tümleyici Filtre" yapılmıştır. 

##### GPS 

GPS alıcısı SIMULINK GPS bloğu ile modellenmiştir ve giriş olarak ayrık zamanda ana modelden pozisyon ve hız datalarını alır. Çıktı olarak Enlem,Boylam,Yükseklik , hız, Yere göre hız ve burun yönelimini verir.

##### Position,Velocity and Orientation Sensor Fusion

Bu subsystemde aracın pozisyonu, hızı ve oryantasyonu için hesaplamalar bulunmaktadır. Bu subsystemin içinde 3 alt subsystem ve bir ayrık integral göreceksiniz. Ayrık integral IMU'dan gelen ivme verisine uygulanarak bir hız verisi elde edilir.

###### Position Fusion

Bu alt subsystemin içinde, hız verisine bir ayrık integral uygulayarak, Düz Dünya Kordinat Sisteminde göre bir pozisyon bilgisi elde ederiz. Bu bilgiyi EBY bilgisine çevirdikten sonra GPS'den gelen EBY bilgisi ile bir Kalman Filtresine sokarak sensör füzyonu gerçekleştirmiş olur.Ayrıca bu iki datayı birbirinden çıkararak Kalman Filtresi için gerekli olan R matrisini oluşturmuş olur. Q matrisi "Velocity Fusion" alt subsysteminden gelecektir. Ayrıca yükseklik verisi için bir basınç sensörü modelli kullandım çünkü basınç sensörleri irtifa ölçmede hem IMU hem GPS'e göre daha başarılırdır.

###### Velocity Fusion 

3 vektörel hız formülünü ve GPS'den gelen hız verisini kullanarak bir Kalman Filtresi ile sensör füzyonunu gerçekleştirebiliriz.Bu iki datayı birbirinden çıkararak Kalman Filtresi için gerekli Q matrisinide elde etmiş oluruz.

###### Orientation

Bu alt subsystemde oryantasyonu hesaplamak için iki farklı yöntem bulunmaktadır. Birincisi Jiroskop verileri ile Dördeyler kullanarak oluşturulan oryantasyon verisi diğeri ise IMU subsysteminde oluşturulan "Tümleyici Filtre"dir. Denemelerin sonucunda Dördeylerin daha iyi sonuç verdiğini gördüğüm için Dördeyleri kullandım.

### Flight Computer

Bu subsystemin içinde tek bir alt subsystem bulunmaktadır ve bu alt subsystem verilen waypointler ile bir yörünge oluşturup dşnamik modelin bu yörüngeyi takip etmesi için gereken kontrol yüzeyi komutlarını oluşturmaya çalışır yani bu alt subsystem aslında otopilottur.Şu ana kadar tam başarılı olarak sayılabilecek bir sistem geliştiremediğim için bu alt subsystem hala geliştirme aşamasındadır.


