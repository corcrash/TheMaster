#ifndef CONNECTION_H
#define CONNECTION_H

#include <QtNetwork/QTcpSocket>

static const int MAX_BUFFER_SIZE = 1024000;

class Connection : public QTcpSocket
{
    Q_OBJECT

public:
private:
    QByteArray buffer;

private:
    int readDataIntoBuffer(int maxSize = MAX_BUFFER_SIZE);

public:
    explicit Connection(QObject *parent = 0);
    bool sendEventMessage(const QString &eventMessage);
    bool sendQMLRequest();

signals:
    void newQMLCodeRecieved(const QString &QMLCode);


private slots:
    void processReadyRead();
    void processConnected();


};

#endif // CONNECTION_H
