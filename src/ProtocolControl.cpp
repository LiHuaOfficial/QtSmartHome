#include "inc/ProtocolControl.h"

void ProtocolControl::setAuthor(const QString& author) {
    if (author != m_author) {
        m_author = author;
        emit authorChanged();
    }
}
