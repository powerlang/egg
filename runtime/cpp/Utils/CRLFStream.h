
#ifndef _CRLF_STREAM_H_
#define _CRLF_STREAM_H_

#include <streambuf>
#include <ostream>
#include <iostream>

class CRLFStreamBuf : public std::streambuf {
    std::streambuf* dest;
    bool lastWasCR = false;

public:
    explicit CRLFStreamBuf(std::streambuf* dest) : dest(dest) {}

    void setStreamBuf(std::streambuf* dest) {
        this->dest = dest;
    }

protected:
    int overflow(int c) override {
        if (c == '\r') {
            lastWasCR = true;
            return dest->sputc('\n'); // Convert CR to LF
        }
        if (c == '\n') {
            if (lastWasCR) {
                lastWasCR = false; // Ignore this LF since we already wrote one
                return 0;
            }
            return dest->sputc('\n'); // Normal LF
        }
        lastWasCR = false;
        return dest->sputc(c);
    }

    int sync() override {
        return dest->pubsync();
    }
};

class CRLFStream : public std::ostream {
    CRLFStreamBuf buf;

public:
    explicit CRLFStream(std::ostream& out) : std::ostream(&buf), buf(out.rdbuf()) {}
    void setStream(std::ostream &out) {
        buf.setStreamBuf(out.rdbuf());
    }
};

#endif // ~ _CRLF_STREAM_H_
