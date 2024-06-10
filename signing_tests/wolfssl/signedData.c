/* signedData.c
 *
 * Copyright (C) 2006-2020 wolfSSL Inc.
 *
 * This file is part of wolfSSL. (formerly known as CyaSSL)
 *
 * wolfSSL is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * wolfSSL is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
 */
#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/settings.h>
#include <wolfssl/wolfcrypt/pkcs7.h>
#include <wolfssl/wolfcrypt/error-crypt.h>
#include <wolfssl/wolfcrypt/logging.h>

#define certFile "device.der"
#define keyFile "key.der"
#define inputFile "tmp/json"
#define encodedFileAttrs   "tmp/smime.der"

// static const byte data[] = { /* Hello World */
//     0x48,0x65,0x6c,0x6c,0x6f,0x20,0x57,0x6f,
//     0x72,0x6c,0x64
// };

// READ VARIABLE WITH CORRECT SIZE
//byte data[1000];
byte * data ;
size_t data_size;


// Function to read file contents into memory
byte* read_file(const char* filename, size_t* size) {
    FILE* file = fopen(filename, "rb");
    if (!file) {
        printf("ERROR: Couldn't open file %s\n", filename);
        return NULL;
    }

    fseek(file, 0, SEEK_END);
    long file_size = ftell(file);
    fseek(file, 0, SEEK_SET);

    byte* buffer = (byte*)malloc(file_size);
    if (!buffer) {
        printf("ERROR: Couldn't allocate memory\n");
        fclose(file);
        return NULL;
    }

    if (fread(buffer, 1, file_size, file) != file_size) {
        printf("ERROR: Couldn't read file %s\n", filename);
        fclose(file);
        free(buffer);
        return NULL;
    }
    *size = (size_t)file_size;

    fclose(file);
    return buffer;
}


static int load_certs(byte* cert, word32* certSz, byte* key, word32* keySz)
{
    FILE* file;

    /* certificate file */
    file = fopen(certFile, "rb");
    if (!file)
        return -1;

    *certSz = (word32)fread(cert, 1, *certSz, file);
    fclose(file);

    /* key file */
    file = fopen(keyFile, "rb");
    if (!file)
        return -1;

    *keySz = (word32)fread(key, 1, *keySz, file);
    fclose(file);

    return 0;
}

static int write_file_buffer(const char* fileName, byte* in, word32 inSz)
{
    int ret;
    FILE* file;

    file = fopen(fileName, "wb");
    if (file == NULL) {
        printf("ERROR: opening file for writing: %s\n", fileName);
        return -1;
    }

    ret = (int)fwrite(in, 1, inSz, file);
    if (ret == 0) {
        printf("ERROR: writing buffer to output file\n");
        return -1;
    }
    fclose(file);

    return 0;
}

static int signedData_sign_attrs(byte* cert, word32 certSz, byte* key,
                                 word32 keySz, byte* out, word32 outSz)
{
    int ret;
    PKCS7* pkcs7;
    WC_RNG rng;

    static byte messageTypeOid[] =
               { 0x06, 0x0a, 0x60, 0x86, 0x48, 0x01, 0x86, 0xF8, 0x45, 0x01,
                 0x09, 0x02 };
    static byte messageType[] = { 0x13, 2, '1', '9' };

    PKCS7Attrib attribs[] =
    {
        { messageTypeOid, sizeof(messageTypeOid), messageType,
                                       sizeof(messageType) }
    };

    /* init rng */
    ret = wc_InitRng(&rng);
    if (ret != 0) {
        printf("ERROR: wc_InitRng() failed, ret = %d\n", ret);
        return -1;
    }

    /* init PKCS7 */
    pkcs7 = wc_PKCS7_New(NULL, INVALID_DEVID);
    if (pkcs7 == NULL) {
        wc_FreeRng(&rng);
        return -1;
    }

    ret = wc_PKCS7_InitWithCert(pkcs7, cert, certSz);
    if (ret != 0) {
        printf("ERROR: wc_PKCS7_InitWithCert() failed, ret = %d\n", ret);
        wc_PKCS7_Free(pkcs7);
        wc_FreeRng(&rng);
        return -1;
    }

    pkcs7->rng             = &rng;
    pkcs7->content         = (byte*)data;
    pkcs7->contentSz       = data_size;
    pkcs7->contentOID      = DATA;
    pkcs7->hashOID         = SHA256h;
    pkcs7->encryptOID      = RSAk;
    pkcs7->privateKey      = key;
    pkcs7->privateKeySz    = keySz;
    pkcs7->signedAttribs   = attribs;
    pkcs7->signedAttribsSz = sizeof(attribs)/sizeof(PKCS7Attrib);

    /* encode signedData, returns size */
    ret = wc_PKCS7_EncodeSignedData(pkcs7, out, outSz);
    if (ret <= 0) {
        printf("ERROR: wc_PKCS7_EncodeSignedData() failed, ret = %d\n", ret);
        wc_PKCS7_Free(pkcs7);
        wc_FreeRng(&rng);
        return -1;

    } else {
        // printf("Successfully encoded SignedData bundle (%s)\n",
        //        encodedFileAttrs);

#ifdef DEBUG_WOLFSSL
        printf("Encoded DER (%d bytes):\n", ret);
        WOLFSSL_BUFFER(out, ret);
#endif

        if (write_file_buffer(encodedFileAttrs, out, ret) != 0) {
            printf("ERROR: error writing encoded to output file\n");
            return -1;
        }

    }

    wc_PKCS7_Free(pkcs7);
    wc_FreeRng(&rng);

    return ret;
}


#ifdef HAVE_PKCS7

int main(int argc, char** argv)
{
    int ret;
    int encryptedSz;
    word32 certSz, keySz;

    byte cert[2048];
    byte key[2048];
    byte encrypted[2048];

    // if (argc < 4) {
    //     printf("Usage: %s <cert_file> <key_file> <input_file>\n", argv[0]);
    //     return -1;
    // }

    // // Set certFile and keyFile based on command-line arguments
    // const char* certFile = argv[1];
    // const char* keyFile = argv[2];
    // const char* inputFile = argv[3];

    byte* file_data = read_file(inputFile, &data_size);
    if (!file_data) {
        return -1; // or handle the error appropriately
    }
    //printf("data_size %ld\n", data_size);
    data = malloc(data_size);
    //printf("sizeof(data) %ld\n", sizeof(data));
    // Copy file contents into global data array
    // if (data_size > sizeof(data)) {
    //     printf("ERROR: File size exceeds buffer size\n");
    //     free(file_data);
    //     return -1;
    // }

    
    // size_t actual_data_size = (data_size > file_size) ? file_size : data_size;
    // memcpy(data, file_data, actual_data_size);
    // data_size = actual_data_size;
    memcpy(data, file_data, data_size);
    free(file_data);
    

    // Print the data variable
    // printf("Contents of data variable:\n");
    // for (size_t i = 0; i < data_size; ++i) {
    //     printf("%c", data[i]);
    // }
    // printf("\n");

#ifdef DEBUG_WOLFSSL
    wolfSSL_Debugging_ON();
#endif

    certSz = sizeof(cert);
    keySz = sizeof(key);
    ret = load_certs(cert, &certSz, key, &keySz);
    if (ret != 0)
        return -1;
    
    /* default attributes + messageType attribute */
    encryptedSz = signedData_sign_attrs(cert, certSz, key, keySz,
                                        encrypted, sizeof(encrypted));
    if (encryptedSz < 0)
        return -1;

    (void)argc;
    (void)argv;

    return 0;
}

#else

int main(int argc, char** argv)
{
    printf("Must build wolfSSL using ./configure --enable-pkcs7\n");
    return 0;
}

#endif

