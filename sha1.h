#sha1.h

#ifndef SHA1_HPP
#define SHA1_HPP

#include <iostream>
#include <string>
using namespace std;

class SHA1
{
public:
    SHA1();
    void update(const string &s);
    void update(istream &is);
    string final();
    static string from_file(const string &filename);

private:
    typedef unsigned long int uint32;   /* just needs to be at least 32bit */
    typedef unsigned long long uint64;  /* just needs to be at least 64bit */

    static const unsigned int DIGEST_INTS = 5;  /* number of 32bit integers per SHA1 digest */
    static const unsigned int BLOCK_INTS = 16;  /* number of 32bit integers per SHA1 block */
    static const unsigned int BLOCK_BYTES = BLOCK_INTS * 4;

    uint32 digest[DIGEST_INTS];
    string buffer;
    uint64 transforms;

    void reset();
    void transform(uint32 block[BLOCK_BYTES]);

    static void buffer_to_block(const string &buffer, uint32 block[BLOCK_BYTES]);
    static void read(istream &is, string &s, int max);
};

string sha1(const string &string);

#endif
