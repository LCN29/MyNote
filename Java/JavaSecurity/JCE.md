# Java Security -- JCE

## 分类
Java Security(java 安全性)其实是Java平台中一个比较独立的模块。从Java2开始，Java Security包含主要三个重要的规范
> 1. Java Cryptography(密码学) Extension（简写为JCE)。JCE所包含的内容有加解密，密钥交换，消息摘要(Message Digest)，密钥管理。

> 2. JavaSecure Socket Extension（简写为JSSE）。JSSE所包含的内容就是Java层的SSL/TLS。简单点说，使用JSSE就可以创建SSL/TLS socket了。

> 3. Java Authentication and Authorization Service（简写为JAAS）。JSSA和认证/授权有关

JCE是JavaSecurity的大头，其他两个子模块JSSE和JAAS都依赖于它，比如SSL/TLS在工作过程中需要使用密钥对数据进行加解密，那么密钥
的创建和使用就依靠JCE子模块了

## JCE 了解

### 01.Service
> Service也就是功能的具体的实现。

> 在JCE中，把功能的组合叫做Service(也称作Engine)，比如：对应“加解密”的API组合CipherService，对应“消息摘要”的API
组合MessageDigest Service，对应“签名”的API组合SignatureService。JCE为这些Service都定义了一个诸如XXXSpi的抽象类。

>也就是需要某个服务时，会先定义好一个规范的接口XXXSpi。然后服务继承这个接口，具体的实现

> 上述SPI的具体实现都会放在`Provider`中，Provider可以提供一组Service的实现，也可以提供单个Service的实现。

`总结：Service(Engine)就是我们需要的功能的实现，调用Service就能实现我们的需求`


### 02,Provider

##### 001:Provicder是什么
那么`Provider`具体是什么呢？通过源码我们可以知道Provider继承于Properties，而Properties继承于Hashtable<K,V>。所以说到底，
Provider就是一个有着键值对的属性列表。
> key为某个Service或算法的名称或别名
> value为这个服务的具体实现类
通过对应的key值，就能从Provider中找到需要的实现类比如：应用程序只说要创建MD5的MessageDigest实例。在代码中，“MD5”是一个字符串,
而MessageDigest实例肯定是由某个类创建的。JCE根据属性key，`从所有注册的Provider里面依次查找其对应的`属性value，然后创建这个类的实例

```java
  public void getProviderMsg () {
  
    //获取系统中已经注册的Provider
    Provider[] providers = Security.getProviders();
    
    // 遍历打印信息
    for (Provider item : providers) {
      Set<Map.Entry<Object, Object>> entry = item.entrySet();
      Iterator<Map.Entry<Object, Object>> iterator = entry.iterator();
      while (iterator.hasNext()) {
        Map.Entry<Object, Object> data = iterator.next();
        // 获取key值
        Object key = data.getKey();
        // 获取value值
        Object value = data.getValue();
        System.out.println("key--->:"+key+" value---->:"+value);
      }
    }
  }
```
打印的日志
```java
key--->:Alg.Alias.Signature.SHA1/DSA 
value---->:SHA1withDSA

key--->:Alg.Alias.Signature.1.2.840.10040.4.3 
value---->:SHA1withDSA

后面还有许多
```

##### 002:Provicder的注册
> 01. 代码添加
```java
// 创建Provider
BouncyCastleProvider provider = new BouncyCastleProvider();
// 添加Provider，默认添加在已有Provider的后面
Security.addProvider(provider);
```
> 02.配置文件

在你的 %JDK_HOME%\jre\lib\security\java.security的文件中找到你的provider注册（在文件的比较上面的部分）在后面添加你需要的provider
比如:
security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider

数字10是因为上面已经有9个provider了，现在是第10个， =的右边就是你的provider对应的全路径（包名.类名）

这个10同时也表示了这个provider的优先级。上面说了，provider是service的集合。所以同一个Spi可以有不同的实现，可以放在
不同的provider。当我们需要一个MessageDigestSpi。用户在创建MessageDigest的实例时。如果没有指明Provider名。JCE默认
从第一个（按照优先级，由1到n）Provider开始搜索，直到找到第一个实现了MessageDigestSpi的Provider。然后，MessageDigest
的实例就会由Provider来创建。

`总结：Provider就是Service的仓库，里面存放着对应Service的实现`

### 03,Key(钥匙,用于内容的加密和解密)
> 1. key从哪里来，既代码怎么创建key
> 2. 怎么把key发送给外部使用者，也就是怎么把key书面化。

##### 001: key的生成
![Alt '图片'](https://github.com/LCN29/MyNote/blob/picture-branch/Picture/Java/JavaSecurity/key.png?raw=true)

> 1. key在JCE中是通过Generator类创建的。这时候在代码中得到的是一个Key实例对象。

> 2. 书面表达Key:
>> 1. 把key表示成16进制
>> 2. 因为Key产生是基于算法的这时候就可以把参与计算的关键变量的值搞出来(这种方式叫KeySpecification)
>> 3. 然后我们只要把16进制或者关键变量发给对方。

> 3. KeyFactory的输入是Key的二进制数据或者KeySpecification，输出就是Key对象

##### 002: key的继承

![Alt '图片'](https://github.com/LCN29/MyNote/blob/picture-branch/Picture/Java/JavaSecurity/key-implement.png?raw=true)

> PublicKey，PrivateKey和SecretKey都派生自Key接口。所以，这三个类也是接口类，这个三个接口把key分成了3中，对应了
key在实例使用的三种类型(对称加密，共有的SecretKey,非对称加密的PublicKey和PrivateKey)

> DSAPublicKey和RSAPublicKey也派生自PublicKey接口。DSA和RSA是两种不同的算法。然后在实际中，不同的加密方式根据
具体的情况，实现某个接口。这样达到了key的分类


##### 003: key的分类和生成
> 1. 对称Key：即加密和解密用得是同一个Key(SecretKey)。JCE中，对称key的创建由KeyGenerator类来完成。

```java
  public void getSecretKey(){
    try{
       // 假设双方约定使用DES算法来生成对称密钥
        KeyGenerator keyGenerator = KeyGenerator.getInstance("DES");
        //设置密钥的长度
         keyGenerator.init(56);
        //生成SecretKey对象，即创建一个对称密钥，此时就可以用这个密钥进行机密内容了
        SecretKey secretKey = keyGenerator.generateKey();
        //获取二进制的书面表达
        byte[] keyData =secretKey.getEncoded();
         //日常使用时，一般会把上面的二进制数组通过Base64编码转换成字符串，然后发给使用者
         // Base64可以将任意的字节数组数据，通过算法，生成只有（大小写英文、数字、+、/）（一共64个字符）内容表示的字符串数据
         Base64.Encoder encoder = Base64.getEncoder();
         //此时，就可以吧encodeText保存在一个文件里面，发送给合作者了
         String encodedText = encoder.encodeToString(keyData);
         
         
         System.out.println("密钥以16进制的形式表达:--->"+ bytesToHexString(keyData));
         System.out.println("Base64转换后的密钥:--->"+encodedText);
         System.out.println("密钥加密方式:---->"+secretKey.getAlgorithm());
        
        System.out.println("******************重新还原key***************************************");
        Base64.Decoder decoder = Base64.getDecoder();
        //获取到字节数组  此处的encodeText假设是从文件中读取到的Base64的字符串
        byte[] receivedKeyData = decoder.decode(encodedText);
        
        //用二进制数组构造KeySpec对象。对称key使用SecretKeySpec类
        //将数据和加密算法放到这个对象  指定里面的数据是用什么数据加密的
        SecretKeySpec keySpec =new SecretKeySpec(receivedKeyData, "DES");
         //获取可以转换指定算法的SecretKeyFactory对象
        SecretKeyFactory secretKeyFactory = SecretKeyFactory.getInstance("DES");
            //根据KeySpec还原Key对象，即把key的书面表达式转换成了Key对象, 密钥还原成功
        SecretKey receivedKeyObject = secretKeyFactory.generateSecret(keySpec);
        
        byte[] encodedReceivedKeyData = receivedKeyObject.getEncoded();
        System.out.println("密钥以16进制的形式表达--->"+bytesToHexString(encodedReceivedKeyData));
            
        
    } catch (Exception e) {
            System.out.println(e);
    }
  }
  
  /** 将字节数组转为16进制格式的字符串 */
  private String bytesToHexString(byte[] src){
        StringBuilder stringBuilder = new StringBuilder("");
        if (src == null || src.length <= 0) {
            return null;
        }
        for (int i = 0; i < src.length; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);
            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
        }
        return stringBuilder.toString();
    }
```
`补充:` 对称key的创建有不同的算法支持，一般有Blowfish, DES, DESede,HmacMD5,HmacSHA1,PBEWithMD5AndDES, and 
PBEWithMD5AndTripleDES这些算法，但是不同的平台对这些算法会有不同的支持。还有KeyGenerator如果支持上面的算法，
但是SecretKeyFactory则不一定支持。比如ScreteKeyFactory则不支持HmacSHA1


> 2. 非对称Key：即加密和解密用得是两个Key。这两个Key构成一个Key对（KeyPair）。其中一个Key叫公钥（PublicKey），
另外一个Key叫私钥（PrivateKey）JCE中，非对称Key的创建由KeyPairGenerator类来完成。

```java
  public void getKeyPair() {
    try{
      //使用RSA算法创建KeyPair
       KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
      //设置密钥长度
      keyPairGenerator.initialize(1024);
      //创建非对称密钥对，即KeyPair对象
      KeyPair keyPair =keyPairGenerator.generateKeyPair();
      //获取密钥对中的公钥和私钥对象
      PublicKey publicKey =keyPair.getPublic();
      PrivateKey privateKey =keyPair.getPrivate();
      System.out.println("以16进制的格式表达公钥--->"+bytesToHexString(publicKey.getEncoded()));
      System.out.println("以16进制的格式表达私钥--->"+bytesToHexString(privateKey.getEncoded()));
      System.out.println("加密算法--->"+privateKey.getAlgorithm());
      
      /**
       * 对于非对称密钥来说，JCE不支持直接通过二进制数组来还原KeySpec（可能是算法不支持）
       * 那该怎么办呢？除了直接还原二进制数组外，还可以通过具体算法的参数来还原
       * RSA非对称密钥就得使用这种方法：首先我们要获取RSA公钥的KeySpec。
      */
      Class spec = Class.forName("java.security.spec.RSAPublicKeySpec");
      //创建KeyFactory，并获取RSAPublicKeySpec
      KeyFactory keyFactory = KeyFactory.getInstance("RSA"); 
       RSAPublicKeySpec rsaPublicKeySpec = (RSAPublicKeySpec)keyFactory.getKeySpec(publicKey, spec);
      // 对RSA算法来说，只要获取modulus和exponent这两个RSA算法特定的参数就可以了
      BigInteger modulus =rsaPublicKeySpec.getModulus();
      BigInteger exponent =rsaPublicKeySpec.getPublicExponent();
      //把这两个参数转换成Base64编码，然后发送给对方
      Base64.Encoder encoder = Base64.getEncoder();
      String modulusStr = encoder.encodeToString(modulus.toByteArray());
      String exponentStr = encoder.encodeToString(exponent.toByteArray());
      System.out.println("Bas64格式的modulus---->"+modulusStr);
      System.out.println("Base64格式的exponentStr--->"+exponentStr);
    
      System.out.println("********************还原共有key**********************************");
     
       //假设接收方收到了代表modulus和exponent的base64字符串并得到了它们的二进制表达式
        byte[] modulusByteArry =modulus.toByteArray();
        byte[] exponentByteArry =exponent.toByteArray();
        //由接收到的参数构造RSAPublicKeySpec对象
        RSAPublicKeySpec receivedKeySpec = new RSAPublicKeySpec(new BigInteger(modulusByteArry),
                new BigInteger(exponentByteArry));
      //根据RSAPublicKeySpec对象获取公钥对象
        KeyFactory receivedKeyFactory = KeyFactory.getInstance("RSA");
        PublicKey receivedPublicKey = receivedKeyFactory.generatePublic(receivedKeySpec);
        System.out.println("以16进制的格式表达公钥--->"+bytesToHexString(receivedPublicKey.getEncoded()));
          
    } catch(Exception e){
      System.out.println(e);
    }
  }
```
`补充:`非对称Key的常用算法有“RSA”、“DSA”、“Diffie−Hellman”、“Elliptic Curve (EC)”等

### 03,Certificates(证书)
> 1. Certificates(复数哦)和实际中的证书一样起证明的作用。

> 2. 在key的的传递中：创建密钥的人一般会把Key的书面表达形式转换成Base64编码后的字符串发给使用者。使用者再解码，然后还原
Key就可以用了。但是是不是随意一个人,给你发一个key，你就敢用呢？简单点说，你怎么判断是否该信任给你发Key的某个人或某个机构呢？

> 3. 一般而言，我们会把Key的二进制表达式放到证书里，证书本身再填上其他信息（比如此证书是谁签发的，什么时候签发的，有效期多久
，证书的数字签名等等）。但是还是没有解决的信任问题。

> 4. 于是有了下面这个规定:
>> 4.1  首先，在全世界范围内（或者是一个国家，一个地区）设置一些顶级证书签发机构，凡是由这些证书签发机构
（Certificate Authorities）签发的证书，我们要无条件的信任（不考虑其他伪造等因素，证书是否被篡改可通过数字签名来判断）

>> 4.2 这么多证书要发，顶级CA肯定忙不过来，所以还可以设立各种级别的CA。这种级别的CA是否该无条件信任呢？不一定。但是，这
个级别的CA可以把自己拿到顶级CA那去认个证，由于顶级CA是无条件信任的，所以这个证书是可信的。

> 5, 客户拿到这个证书时
>> 5.1 发现是某个CA签发的。如果是顶级CA签发的，那好办，直接信任。不是顶级CA签发的。客户再去查看这个发证的CA能不能被信任，
一直找到顶部，如果是顶级CA，直接信任了，如果不是，2333....

>> 5.2 如果客户本身就信任公司A，那其实公司A也不需要去找CA认证，直接把证书a给客户就可以了。当然，这个时候的证书a就不需要
CA的章了。

> 6. 由上面可知，一份证书的背后可能隐藏着一条可怕的证书链。

> 7. 很多系统(Android, Microsoft,甚至浏览器)会把一些顶级CA（也叫Root CA，即根CA）的证书默认集成到系统里。`用来表明自己
对这份证书和他签发的证书信任`

###### 个人认为的证书链的情况是这样的:
> 1. 一份证书的内容有 
>> 1.1 发布这份证书的机构的信息 

>> 1.2 机构的公钥 

>> 1.3 签名(用上一级的机构发布的私钥进行签名的内容,顶级机构除外，其本身是用自己的私钥进行签名的) 

`现在的情况是这样的：`
> 1.一级机构去顶级机构认证，顶级结构确定可以，发了一份私钥给一级机构，后面二级机构向一级机构认证，也通过，等到了一级机构的
私钥，后面的三级机构也一样。（顶级---一级---二级---三级）

> 2.现在三级机构需要给客户一份证书，三级机构会先用他得到的二级机构的私钥签名一下，然后把自己的信息和公钥包装在证书里面发给
客户了，

> 3.客户获取到了这份证书了，但是他不打算直接信任这份证书，想要验证一下。验证就是验证签名。而签名用的是私钥加密，需要有公钥，
然后他就去下载二级机构的证书，因为里面有他的公钥，但是现在又回来了，我不信任这份二级机构的证书，我要验证一下，于是我又下载了
一级机构的证书，以此类推，最后终于到了顶级机构了，他的证书（也就是根证书）我要信任的，于是我直接用顶级机构的证书里面的公钥，
验证了一级机构的签名，对了，那么用一级机构的证书验证二级的，以此类推，到了三级机构的证书，用二级的验证成功，三级机构的证书
验证成功，最后我可以从机构的信息里面获取想要的内容了。（为什么用公钥解密出了私钥的内容（签名）就是成功了，后面再说）

> 4.那么为什么系统要把一些根证书集成到系统内部呢？简单一点，就是不是所有的根证书我的信任，在我系统内的根证书，才是我选择信
任的。为什么：因为根证书的生成可以自签的，你都可以生成一份根证书。顶级CA的产生很大程度是信任度产生的。受到了别人的信任，你
也可以成为顶级CA，自签的证书，也就有了保证。所以系统为了安全，把那些受信任的机构发布的证书，集成到自己的系统内，过滤到那些
自签又没有信任度的根证书。

###### 证书类型

`一份证书的内容`
```xml
-----BEGIN CERTIFICATE-----

MIID5TCCAs2gAwIBAgIEOeSXnjANBgkqhkiG9w0BAQUFADCBgjELMAkGA1UEBhMC

VVMxFDASBgNVBAoTC1dlbGxzIEZhcmdvMSwwKgYDVQQLEyNXZWxscyBGYXJnbyBD

ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEvMC0GA1UEAxMmV2VsbHMgRmFyZ28gUm9v

dCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkwHhcNMDAxMDExMTY0MTI4WhcNMjEwMTE0

MTY0MTI4WjCBgjELMAkGA1UEBhMCVVMxFDASBgNVBAoTC1dlbGxzIEZhcmdvMSww

KgYDVQQLEyNXZWxscyBGYXJnbyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEvMC0G

A1UEAxMmV2VsbHMgRmFyZ28gUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkwggEi

MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDVqDM7Jvk0/82bfuUER84A4n13

5zHCLielTWi5MbqNQ1mXx3Oqfz1cQJ4F5aHiidlMuD+b+Qy0yGIZLEWukR5zcUHE

SxP9cMIlrCL1dQu3U+SlK93OvRw6esP3E48mVJwWa2uv+9iWsWCaSOAlIiR5NM4O

JgALTqv9i86C1y8IcGjBqAr5dE8Hq6T54oN+J3N0Prj5OEL8pahbSCOz6+MlsoCu

ltQKnMJ4msZoGK43YjdeUXWoWGPAUe5AeH6orxqg4bB4nVCMe+ez/I4jsNtlAHCE

AQgAFG5Uhpq6zPk3EPbg3oQtnaSFN9OH4xXQwReQfhkhahKpdv0SAulPIV4XAgMB

AAGjYTBfMA8GA1UdEwEB/wQFMAMBAf8wTAYDVR0gBEUwQzBBBgtghkgBhvt7hwcB

CzAyMDAGCCsGAQUFBwIBFiRodHRwOi8vd3d3LndlbGxzZmFyZ28uY29tL2NlcnRw

b2xpY3kwDQYJKoZIhvcNAQEFBQADggEBANIn3ZwKdyu7IvICtUpKkfnRLb7kuxpo

7w6kAOnu5+/u9vnldKTC2FJYxHT7zmu1Oyl5GFrvm+0fazbuSCUlFLZWohDo7qd/

0D+j0MNdJu4HzMPBJCGHHt8qElNvQRbn7a6U+oxy+hNH8Dx+rn0ROhPs7fpvcmR7

nX1/Jv16+yWt6j4pf0zjAFcysLPp7VMX2YuyFA4w6OXVE8Zkr8QA1dhYJPz1j+zx

x32l2w8n0cbyQIjmH/ZhqPRCyLk306m+LFZ4wnKbWV01QIroTmMatukgalHizqSQ

33ZwmVxwQ023tqcZZE6St8WRPH9IFmV7Fv3L/PvZ1dZPIWU7Sn9Ho/s=

-----END CERTIFICATE-----

// 明文内容
Data:

  Version: 3 (0x2)

  Serial Number:971282334 (0x39e4979e)

  Signature Algorithm: sha1WithRSAEncryption

  Issuer: C=US, O=Wells Fargo, OU=Wells Fargo CertificationAuthority, CN=Wells Fargo Root Certificate Authority

  Validity

    Not Before: Oct11 16:41:28 2000 GMT

    Not After : Jan14 16:41:28 2021 GMT

  Subject: C=US, O=Wells Fargo, OU=Wells Fargo CertificationAuthority, CN=Wells Fargo Root Certificate Authority

  Subject Public Key Info:    #Public Key的KeySpec表达式

    Public Key Algorithm: rsaEncryption  #PublicKey的算法

    Public-Key: (2048 bit)

    Modulus:

       00:d5:a8:33:3b:26:f9:34:ff:cd:9b:7e:e5:04:47:

       ce:00:e2:7d:77:e7:31:c2:2e:27:a5:4d:68:b9:31:

       ba:8d:43:59:97:c7:73:aa:7f:3d:5c:40:9e:05:e5:

        a1:e2:89:d9:4c:b8:3f:9b:f9:0c:b4:c8:62:19:2c:

       45:ae:91:1e:73:71:41:c4:4b:13:fd:70:c2:25:ac:

       22:f5:75:0b:b7:53:e4:a5:2b:dd:ce:bd:1c:3a:7a:

       c3:f7:13:8f:26:54:9c:16:6b:6b:af:fb:d8:96:b1:

       60:9a:48:e0:25:22:24:79:34:ce:0e:26:00:0b:4e:

       ab:fd:8b:ce:82:d7:2f:08:70:68:c1:a8:0a:f9:74:

       4f:07:ab:a4:f9:e2:83:7e:27:73:74:3e:b8:f9:38:

       42:fc:a5:a8:5b:48:23:b3:eb:e3:25:b2:80:ae:96:

       d4:0a:9c:c2:78:9a:c6:68:18:ae:37:62:37:5e:51:

       75:a8:58:63:c0:51:ee:40:78:7e:a8:af:1a:a0:e1:

       b0:78:9d:50:8c:7b:e7:b3:fc:8e:23:b0:db:65:00:

       70:84:01:08:00:14:6e:54:86:9a:ba:cc:f9:37:10:

       f6:e0:de:84:2d:9d:a4:85:37:d3:87:e3:15:d0:c1:

       17:90:7e:19:21:6a:12:a9:76:fd:12:02:e9:4f:21:

       5e:17

       Exponent: 65537 (0x10001)
		

  X509v3 extensions:

      X509v3 BasicConstraints: critical

      CA: TRUE
      
  X509v3Certificate Policies:

      Policy: 2.16.840.1.114171.903.1.11

      CPS: http://www.wellsfargo.com/certpolicy

  #数字签名，以后再讲
  Signature Algorithm : sha1WithRSAEncryption  

    d2:27:dd:9c:0a:77:2b:bb:22:f2:02:b5:4a:4a:91:f9:d1:2d:

    be:e4:bb:1a:68:ef:0e:a4:00:e9:ee:e7:ef:ee:f6:f9:e5:74:

    a4:c2:d8:52:58:c4:74:fb:ce:6b:b5:3b:29:79:18:5a:ef:9b:

    ed:1f:6b:36:ee:48:25:25:14:b6:56:a2:10:e8:ee:a7:7f:d0:

    3f:a3:d0:c3:5d:26:ee:07:cc:c3:c1:24:21:87:1e:df:2a:12:

    53:6f:41:16:e7:ed:ae:94:fa:8c:72:fa:13:47:f0:3c:7e:ae:

    7d:11:3a:13:ec:ed:fa:6f:72:64:7b:9d:7d:7f:26:fd:7a:fb:

    25:ad:ea:3e:29:7f:4c:e3:00:57:32:b0:b3:e9:ed:53:17:d9:

    8b:b2:14:0e:30:e8:e5:d5:13:c6:64:af:c4:00:d5:d8:58:24:

    fc:f5:8f:ec:f1:c7:7d:a5:db:0f:27:d1:c6:f2:40:88:e6:1f:

    f6:61:a8:f4:42:c8:b9:37:d3:a9:be:2c:56:78:c2:72:9b:59:

    5d:35:40:8a:e8:4e:63:1a:b6:e9:20:6a:51:e2:ce:a4:90:df:

    76:70:99:5c:70:43:4d:b7:b6:a7:19:64:4e:92:b7:c5:91:3c:

    7f:48:16:65:7b:16:fd:cb:fc:fb:d9:d5:d6:4f:21:65:3b:4a:

    7f:47:a3:fb

SHA1 Fingerprint = 93:E6:AB:22:03:03:B5:23:28:DC:DA:56:9E:BA:E4:D1:D1:CC:FB:65

```

目前通用格式为X.509格式，证书和我们看到的文件还是有一些差异。证书需要封装在文件里。不同系统支持不同的证书文件，每种证书文件，
所要求包含的具体的X.509证书内容也不一样，所以有许多种文件格式
>.pem ( Privacy-enhanced ElectronicMail ) Base64 编码的证书

>.cer, .crt, .der 证书内容为ASCII编码，二进制格式，但也可以和PEM一样采用base64编码

>.p7b, .p7c (PKCS#7)（Public-Key CryptographyStandards，是由RSA实验室与其它安全系统开发商为促进公钥密码的发展而制订的一系列标准，
#7表示第7个标准，PKCS一共有15个标准）封装的文件。其中，p7b可包含证书链信息，但是不能携带私钥，而p7c只包含证书。

>.p12– (PKCS#12)标准,可包含公钥或私钥信息。如果包含了私钥信息的话，该文件内容可能需要输入密码才能查看。

```java
  public void getCertificateMsg() {
    
    try{
        InputStream publicInputStream = new FileInputStream(PUBLIC_PATH);

        // 导入证书得需要使用CertificateFactory, CertificateFactory只能导入pem、der格式的证书文件
        CertificateFactory certificateFactory = CertificateFactory.getInstance("X.509");
        //注意，如果一个证书文件包含多个证书（证书链的情况），generateCertificate将只返回第一个证书
        // 调用generateCertificates函数可以返回一个证书数组，
        // 提取X509证书信息，并保存在X509Certificate对象中
        X509Certificate myX509Cer = (X509Certificate)certificateFactory.generateCertificate(publicInputStream);
        System.out.println("Subjecte DN --->"+ myX509Cer.getSubjectDN().getName());
        System.out.println("Issuer DN   --->"+ myX509Cer.getIssuerDN().getName());
        System.out.println("Public Key --->"+  bytesToHexString(myX509Cer.getPublicKey().getEncoded()));
            
      } catch (Exception e) {
      }
  }
```

### 04.KeyStore
> KeyStore存储Key和Certificates的一个地方(类似一个文件)

> alias:别名,在KeyStore中，每一个存储项都对应有一个别名。说白了，别名就是方便你找到Key的

> KeyStore里边存储的东西可分为两种类型
>> 1. Key Entry, KE可携带KeyPair，或者SecretKey信息,如果KE存储的是KeyPair的话，它可能会携带一整条证书链信息
>> 2. Certificate Entry, CE用于存储根证书，根证书只包含公钥。而且CE一般对应的是可信任的CA证书，即顶级CA的证书

> 在JCE中，KeyStore也是一个Service（或者叫Engine）,而其实现有不同的算法。常见的有JKS, JCEKS,and PKCS12,
其中功能比较全的是JCEKS。而PKCS12一般用于导入p12的证书文件。

> Java平台提供了一个工具可以用来创建或者管理KeyStore，这个工具叫Keytool.放在 %Java_Home%/bin/keytool.exe

```java
  public void getKeyStoreMsg() {
    try {
        FileInputStream fiKeyFile = new FileInputStream(PRIVATE_PATH);
        // 创建可以读取.p12的keystore, KeyStore实例默认是不关联任何文件的，所以需要用keystore文件来初始化它
        KeyStore myKeyStore = KeyStore.getInstance("PKCS12");
        
        //将.p12公开的内容读取到keystore里面, 参数2为这个.p12的文件密码, 如果没有这个参数，到时只能读取到公开的数据
        myKeyStore.load(fiKeyFile, PASSWORD.toCharArray());

        // 获取keyStore里面定义的别名
        Enumeration<String> aliasEnum = myKeyStore.aliases();

        //遍历别名
        while(aliasEnum.hasMoreElements()) {
            String keyAlias = (String)aliasEnum.nextElement();
            //判断别名对应的项是CE还是KE。注意,CE对应的是可信任CA的根证书。
            boolean bCE =myKeyStore.isCertificateEntry(keyAlias);
            boolean bKE =myKeyStore.isKeyEntry(keyAlias);
            System.out.println("别名是:"+keyAlias+"------是CE:"+bCE+"-----是KE:"+bKE);
            if(bCE) {
                //从KeyStore中取出别名对应的证书链
                Certificate[] certificates = myKeyStore.getCertificateChain(keyAlias);
                for (Certificate cert: certificates) {
                    X509Certificate myCert = (X509Certificate) cert;
                    System.out.println("Subjecte DN:" + myCert.getSubjectDN().getName());
                    System.out.println("Issuer DN:" + myCert.getIssuerDN().getName());
                    System.out.println("Public Key:"+ bytesToHexString(myCert.getPublicKey().getEncoded()));
                }
            }

            if(bKE){
                Key myKey =myKeyStore.getKey(keyAlias,PASSWORD.toCharArray());
                if(myKey instanceof PrivateKey){
                    System.out.println("I am a private key:" + bytesToHexString(myKey.getEncoded()));
                } else if(myKey instanceof SecretKey){
                    System.out.println("I am a secret key:" + bytesToHexString(myKey.getEncoded()));
                } else if (myKey instanceof PublicKey) {
                    System.out.println("I am a public key:" + bytesToHexString(myKey.getEncoded()));
                }
            }
        }
    }catch (Exception e){
        System.out.println(e);
    }
  }
```
### 05.MessageDigest(MD,消息摘要)
> 1. 在Security里，MD其实和论文摘要(概括这篇论文的内容)的意思差不多：

> 2. 先有一个消息。当然，这里的消息可以是任何能用二进制数组表达的数据。然后用某种方法来得到这个消息的摘要。
当然，摘要最好要独一无二，即相同的消息数据能得到一样的摘要。不同的消息数据绝对不能得到相同的摘要。

> 3. 和论文摘要不同的地方是，人们看到论文摘要是能大概了解到论文是说什么的，但是看到消息摘要，我们肯定不能猜出原始消息数据。
MD的真实作用是为了防止数据被篡改：
>> 3.1 数据发布者：对预发布的数据进行MD计算，得到MD值，然后放到一个公开的地方
>> 3.2 数据下载者：下载数据后，也计算MD值，把计算值和发布者提供的MD值进行比较，如果一样就表示下载的数据没有被篡改
```java
  public void getMD() {
    try {
      String data = "我是一段消息，请注意查收。明天6点天桥见。";
      // 创建一个MD计算器，类型是MessageDigest，计算方法有MD5，SHA等。
      MessageDigest messageDigest = MessageDigest.getInstance("MD5");
      //计算MD值时，只要不断调用MessageDigest的update函数即可，其参数是待计算的数据
      messageDigest.update(data.getBytes());
      //获取摘要信息，也是用二进制数组表达
      byte[] mdValue =messageDigest.digest();
      System.out.println("消息的MD---------->"+bytesToHexString(mdValue));
      
      //这次我们要计算一个文件的MD值
      DigestInputStream digestInputStream = new DigestInputStream(new FileInputStream(PRIVATE_PATH), messageDigest);
      byte[] buffer = new byte[1024];
      int nread = 0;
      while(digestInputStream.read(buffer)> 0){
          messageDigest.update(buffer, 0, nread);
      }
      mdValue =messageDigest.digest();
      System.out.println("文件的MD---------->"+bytesToHexString(mdValue));

    }catch(Exception e){
      System.out.println(e);
    }
  }
```
`补充:`MD值其实并不能真正解决数据被篡改的问题。因为作假者可以搞一个假网站，然后提供假数据和根据假数据得到的MD值。这样，
下载者下载到假数据，计算的MD值和假网站提供的MD数据确实一样，但是这份数据是被篡改过了的。
解决这个问题的一种方法是：计算MD的时候，输入除了消息数据外，还有一个密钥。由于作假者没有密钥信息，所以它在假网站上
提供的MD肯定会和数据下载者根据密钥+假数据得到的MD值不一样。
这种方法得到的MD叫Message Authentication Code，简称MAC

```java
  public void getMAC() {
    try{
      //计算.p12文件的的MAC值
      InputStream inputStream = new FileInputStream(PRIVATE_PATH);
      // 创建MAC计算对象，其常用算法有“HmacSHA1”和“HmacMD5”。其中SHA1和MD5是 计算消息摘要的算法，Hmac是生成MAC码的算法
      Mac myMac = Mac.getInstance("HmacSHA1");
      //创建一个SecretKey对象
      KeyGenerator keyGenerator = KeyGenerator.getInstance("DES");
      keyGenerator.init(56);
      SecretKey key =keyGenerator.generateKey();
      //用密钥初始化MAC对象
      myMac.init(key);
      byte[] buffer = new byte[1024];
      int nread = 0;
      while ((nread =inputStream.read(buffer)) > 0) {
          myMac.update(buffer, 0, nread);
      }
      //得到最后的MAC值
      byte[] macValue =myMac.doFinal();
      System.out.println(bytesToHexString(macValue));        
    } catch( Exception e){
      System.out.println(e);
    }
  }
```

### Signature(签名)
> 1.Signature的作用其实和MAC差不太多，但是它用得更广泛点。其使用步骤一般如下：

>> 1.1 数据发送者先计算数据的摘要，然后利用私钥对摘要进行签名操作，得到一个签名值

>> 1.2 数据接收者下载数据和签名值，也计算摘要。然后用公钥对摘要进行操作，得到一个计算值。然后比较计算值和下载得到的签名值，
如果一样就表明数据没有被篡改

> 2.从理论上说，签名不一定是针对摘要的，也可以对原始数据计算签名。但是由于签名所涉及的计算量比较大，所以往往我们只对数据摘要进行签名。
在JCE中，签名都针对MD而言。

```java
  public void getSignatureMsg() {
    try {
      // 私钥和公钥信息都放在test-keychain.p12文件中
      InputStream inputStream = new FileInputStream(PRIVATE3_PATH);
      KeyStore myKeyStore =KeyStore.getInstance("PKCS12");
      myKeyStore.load(inputStream, "changeit".toCharArray());
      String alias = "MyKey Chain";
      Certificate cert =myKeyStore.getCertificate(alias);
      PublicKey publicKey =cert.getPublicKey();
      PrivateKey privateKey =(PrivateKey)myKeyStore.getKey(alias, PASSWORD.toCharArray());
      
      inputStream.close();
      //对证书进行签名
      Signature signature = Signature.getInstance("MD5withRSA");
      //计算签名时，需要调用initSign，并传入一个私钥
      signature.initSign(privateKey);
      
      
      //读取需要签名的文件
      InputStream inputStream1 = new FileInputStream(TEST_PATH);
      byte[] data = new byte[1024];
      int nread = 0;
      while((nread =inputStream1.read(data))>0){
          //读取文件并计算签名
          signature.update(data, 0, nread);
      }
      //得到签名值
      byte[] sig = signature.sign();
      inputStream1.close();
      System.out.println("签名值为----->"+ bytesToHexString(sig));
        //校验签名
        signature = Signature.getInstance("MD5withRSA");
        inputStream1 = new FileInputStream(TEST_PATH);
        //校验时候需要调用initVerify，并传入公钥对象
        signature.initVerify(publicKey);
        data = new byte[1024];
        nread = 0;
        while((nread =inputStream1.read(data))>0){
            //读取文件并计算校验值
            signature.update(data, 0, nread);
        }
        //比较签名和内部计算得到的检验结果，如果一致，则返回true
        boolean isSigCorrect =signature.verify(sig);
        System.out.println("结果为--->" + isSigCorrect);
    } catche (Exception e){
      System.out.println(e);
    }
  }
```

### Encryption And Decryption(加解密)
> 1. JCE的加解密就比较简单了，主要用到一个Class就是Cipher。Cipher类实例在创建时需要指明相关算法和
模式（即Cipher.getInstance的参数）。根据JCE的要求：

>> 1.1 可以仅指明“算法”，比如“DES”。

>> 1.2 也可以指明“算法/反馈模式/填充模式”（反馈模式和填充模式都和算法的计算方式有关），比如“AES/CBC/PKCS5Padding”

> 2. JCE中

>> 2.1 常见的算法有“DES”，“DESede”、“PBEWithMD5AndDES”、“Blowfish”。

>> 2.2 常见的反馈模式有“ECB”、“CBC”、“CFB”、“OFB”、“PCBC”。

>> 2.3 常见的填充模式有“PKCS5Padding”、“NoPadding”。

`注意：算法、反馈模式和填充模式不是任意组合的，具体的组合,可以根据需要来，`
```java
  public void getCipherMsg() {
    try {
      //加解密要用到Key，本例使用SecretKey进行对称加解密运算
      KeyGenerator keyGenerator = KeyGenerator.getInstance("DES");
      SecretKey key = keyGenerator.generateKey();
      //待加密的数据是一个字符串
      String data ="This is our data";
      System.out.println("加密的数据" + data);

      Cipher encryptor = Cipher.getInstance("DES/CBC/PKCS5Padding");
      //设置Cipher对象为加密模式，同时把Key传进去
      encryptor.init(Cipher.ENCRYPT_MODE, key);
      //开始加密，注意update的返回值为输入buffer加密后得到的数据
      byte[] encryptedData =encryptor.update(data.getBytes());
      //调用doFinal以表示加密结束。doFinal有可能也返回一串数据，也有可能返回null
      byte[] encryptedData1 =encryptor.doFinal();
      //finalencrpytedData为最终加密后得到的数据，它是update和doFinal的返回数据的集合
       byte[] finalEncrpytedData = concateTwoBuffers(encryptedData,encryptedData1);
         System.out.println("加密的后的数据---->"+bytesToHexString(finalEncrpytedData));
         
        //获取本次加密时使用的初始向量。初始向量属于加密算法使用的一组参数。使用不同的加密算法时，
	// 需要保存的参数不完全相同。Cipher会提供相应的API
        byte[] iv = encryptor.getIV();
       /**
          解密：解密时，需要把加密后的数据，密钥和初始向量发给解密方。
          再次强调，不同算法加解密时，可能需要加密对象当初加密时使用的其他算法参数
        */
        
        System.out.println("***************解密中***********************");
        
        Cipher decryptor =Cipher.getInstance("DES/CBC/PKCS5Padding");
        IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);
        //设置Cipher为解密工作模式，需要把Key和算法参数传进去
        decryptor.init(Cipher.DECRYPT_MODE, key,ivParameterSpec);
        //解密数据，也是调用update和doFinal
        byte[] decryptedData =decryptor.update(finalEncrpytedData);
        byte[] decryptedData1 =decryptor.doFinal();
        byte[] finaldecrpytedData = concateTwoBuffers(decryptedData,decryptedData1);
        System.out.println("解密出来的16进制字符出--->" + bytesToHexString(finaldecrpytedData));
        System.out.println("明文数据"+new String(finaldecrpytedData));
        
        
    } catch(Exception e) {
    
    }
  }
  
    private byte[] concateTwoBuffers(byte[] buf1,byte[] buf2) {
        byte[] bufret=null;
        int len1=0;
        int len2=0;
        if(buf1 != null){
            len1=buf1.length;
        }
        if(buf2!=null){
            len2=buf2.length;
        }
        if(len1+len2>0) {
            bufret = new byte[len1+len2];
        }
        if(len1>0){
            System.arraycopy(buf1,0,bufret,0,len1);
        }

        if(len2>0){
            System.arraycopy(buf2,0,bufret,len1,len2);
        }

        return bufret;
    }
```







