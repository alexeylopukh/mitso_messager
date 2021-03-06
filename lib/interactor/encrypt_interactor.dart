import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

class EncryptInteractor {
  final encrypt.IV iv = encrypt.IV.fromLength(15);

  void test() {
    final String message = '''
    Есть много вариантов Lorem Ipsum, 
    https://ru.lipsum.com/
    👍🙈😂
    но большинство из них имеет не всегда приемлемые модификации, например, юмористические вставки или слова, которые даже отдалённо не напоминают латынь. Если вам нужен Lorem Ipsum для серьёзного проекта, вы наверняка не хотите какой-нибудь шутки, скрытой в середине абзаца. Также все другие известные генераторы Lorem Ipsum используют один и тот же текст, который они просто повторяют, пока не достигнут нужный объём. Это делает предлагаемый здесь генератор единственным настоящим Lorem Ipsum генератором. Он использует словарь из более чем 200 латинских слов, а также набор моделей предложений. В результате сгенерированный Lorem Ipsum выглядит правдоподобно, не имеет повторяющихся абзацей или "невозможных" слов.
    ''';
    print('message: $message');
    String keyString = encrypt.Key.fromSecureRandom(32).base64;
    print('keyString: $keyString');
    final String encrypted =
        encryptMessage(message: message, encrypter: createEncrypter(keyString));
    final String decrypted =
        decryptMessage(message: encrypted, encrypter: createEncrypter(keyString));

    print('encrypted: $encrypted');
    print('decrypted: $decrypted');
  }

  encrypt.Encrypter createEncrypter(String keyString) {
    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    return encrypt.Encrypter(encrypt.AES(key));
  }

  String encryptMessage({@required message, @required encrypt.Encrypter encrypter}) {
    return encrypter.encrypt(message, iv: iv).base64;
  }

  String decryptMessage({@required message, @required encrypt.Encrypter encrypter}) {
    return encrypter.decrypt(encrypt.Encrypted.from64(message), iv: iv);
  }
}
