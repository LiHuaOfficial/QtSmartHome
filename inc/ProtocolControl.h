#include <QtQml>
#include <QObject>
#include <QtQml/qqmlregistration.h>

class ProtocolControl: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString author READ author WRITE setAuthor NOTIFY authorChanged)
    QML_ELEMENT

public:
    explicit ProtocolControl(QObject* parent = nullptr) : QObject(parent) {}

    QString author() const { return m_author; }
    void setAuthor(const QString& author);

    Q_INVOKABLE void greet() {
        qDebug() << "Hello from C++!" << m_author;
    }

signals:
    void authorChanged();

private:
    QString m_author;
};
